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
        isCurrentlyJailed = true,
        commandInfo = commandInfoTable,
        positionBeforeJailing = self:GetPos(),
        takenWeapons = GetPlayersWeapons(self)
    }

    self:StripWeapons()
    self:SetPos(Vector(-827.441956, -1441.969238, 7144.031250)) -- Currently hard coded vector

    hook.Call("baj_OnPlayerJailed", nil, self, self.bajJailData) -- Calls the hook OnPlayerJailed for later use in this addon and for others.

    net.Start("baj_StartJailClient")
    net.WriteString(commandInfoTable.admin:Nick())
    net.WriteString(commandInfoTable.reason)
    net.WriteInt(commandInfoTable.time, bAdminJail.MAX_JAIL_TIME_IN_BITS) -- Max num is 524287
    net.Send(self)

    timer.Simple(commandInfoTable.time, function() -- Change to timer.Create so that I can remove timer on unjail.
        self:bajUnJailPlayer()
    end)
end

function _player:bajUnJailPlayer(calledByAdmin, commandInfoTable)
    if(!self.bajJailData) then print("bAdminJail: Tried to unjail someone without jailing data.") return end
    if(!self.bajJailData.isCurrentlyJailed) then print("bAdminJail: Tried to unjail someone that is not jailed.") return end    

    -- This needs to be at the begining so the hooks dont prevent anything.
    self.bajJailData.isCurrentlyJailed = false -- Or set bajJailData to nil. Still havent decided yet

    GiveBackPlayerWeapon(self)
    self:SetPos(self.bajJailData.positionBeforeJailing)

    if(calledByAdmin) then -- Check to see if unjailed by admin.
        hook.Call("baj_OnPlayerAdminUnjailed", nil, self, commandInfoTable.admin)
    end
end

util.AddNetworkString("baj_StartJailClient")
