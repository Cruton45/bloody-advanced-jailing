local bAdminJail = bAdminJail
local _player = FindMetaTable("Player")

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
    self:SetPos(Vector(-827.441956, -1441.969238, 7144.031250)) -- Currently hard coded vector

    hook.Call("baj_OnPlayerJailed", nil, self, self.bajJailData) -- Calls the hook OnPlayerJailed for later use in this addon and for others.

    net.Start("baj_StartJailClient")
    net.WriteString(commandInfoTable.admin:Nick())
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
    end
end

util.AddNetworkString("baj_StartJailClient")
