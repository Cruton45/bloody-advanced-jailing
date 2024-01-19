local bAdminJail = bAdminJail
local _player = FindMetaTable("Player")

-- Key = SteamID64, value jail time left in seconds
local disconnectedJailedPlayers = {} -- Obviously reset on server restart, however I feel like if your jailing someone for that long it should be a ban.

local function GetPlayersWeapons(ply)
    local rawPlyWeaponData = ply:GetWeapons() -- Returns a table of weapon objects
    local plyWeapons = {} -- This will handle just weaponIDs

    for k, weapon in ipairs(rawPlyWeaponData) do
        table.insert(plyWeapons, weapon:GetClass())
    end

    return plyWeapons
end

local function GiveBackPlayerWeapon(ply)
    local takenWeapons = ply.bajJailData.takenWeapons

    for k, takenWeapon in ipairs(takenWeapons) do
        ply:Give(takenWeapon)
    end
end

function _player:bajJailPlayer(commandInfoTable)
    
    self.bajJailData = {
        isJailed = true,
        commandInfo = commandInfoTable,
        positionBeforeJailing = self:GetPos(),
        takenWeapons = GetPlayersWeapons(self),
        activeWeapon = self:GetActiveWeapon():GetClass()
    }

    self:StripWeapons()
    self:SetPos(bAdminJail.config.jailPosition)

    hook.Call("baj_OnPlayerJailed", nil, self, self.bajJailData) -- Calls the hook OnPlayerJailed for later use in this addon and for others.

    local adminName

    if(commandInfoTable.admin) then
        adminName = commandInfoTable.admin:Nick()
    else
        adminName = "CONSOLE"
    end

    net.Start("baj_StartJailClient")
    net.WriteString(adminName)
    net.WriteString(commandInfoTable.reason)
    net.WriteInt(commandInfoTable.time, bAdminJail.MAX_JAIL_TIME_IN_BITS)
    net.Send(self)

    if(timer.Exists("bajJailTimer_" .. self:SteamID64())) then timer.Remove("bajJailTimer_" .. self:SteamID64()) end -- Make sure that there isnt already a timer just in case.

    timer.Create("bajJailTimer_" .. self:SteamID64(), commandInfoTable.time, 1, function(arguments)
        self:bajUnJailPlayer()
    end)
end

function _player:bajUnJailPlayer(calledByAdmin, commandInfoTable)
    -- This needs to be at the begining so the hooks dont prevent anything.
    self.bajJailData.isJailed = false -- Or set bajJailData to nil. Still havent decided yet

    GiveBackPlayerWeapon(self)
    self:SelectWeapon(self.bajJailData.activeWeapon)
    self:SetPos(self.bajJailData.positionBeforeJailing)

    if(calledByAdmin) then -- Check to see if unjailed by admin.
        hook.Call("baj_OnPlayerAdminUnjailed", nil, self, commandInfoTable.admin)

        if(timer.Exists("bajJailTimer_" .. self:SteamID64())) then
            timer.Remove("bajJailTimer_" .. self:SteamID64())
        end

        net.Start("baj_StopJailClient")
        net.Send(self)
    end
end

hook.Add("PlayerDisconnected", "baj_JailCheckOnPlayerLeave", function(ply)
    if(ply.bajJailData and ply.bajJailData.isJailed) then
        local plySteamID = ply:SteamID64()
        if(!plySteamID) then print("BAJ: SteamID didn't exist on disconnect while jailed.") return end

        if(timer.Exists("bajJailTimer_" .. ply:SteamID64())) then
            disconnectedJailedPlayers[ply:SteamID64()] = timer.TimeLeft("bajJailTimer_" .. ply:SteamID64())

            timer.Remove("bajJailTimer_" .. ply:SteamID64())
        end
    end
end)

hook.Add("PlayerAuthed", "baj_JailCheckOnPlayerJoin", function(ply)
    local plySteamID = ply:SteamID64()
    if(!plySteamID) then print("BAJ: SteamID didn't exist on join.") return end

    if(!disconnectedJailedPlayers[plySteamID]) then return end -- Checks to see if player has an entry and havent served jail time.

    local commandInfo = {
        admin = nil,
        target = ply,
        time = disconnectedJailedPlayers[plySteamID],
        reason = "Disconnected while jailed"
    }

    disconnectedJailedPlayers[plySteamID] = nil -- Remove player from disconnectJailedPlayers dictionary.

    -- Added timer for stability and make sure things exist before setting values. May need to rework this in bajJailPlayer funtion. May need to change how it sets data.
    -- Definity need to write code all around for to make this run better.
    timer.Simple(5, function()
        ply:bajJailPlayer(commandInfo)
    end)
end)

util.AddNetworkString("baj_StartJailClient")
util.AddNetworkString("baj_StopJailClient")
