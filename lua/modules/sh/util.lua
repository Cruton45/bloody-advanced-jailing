local bAdminJail = bAdminJail
local utility = {}
utility.__index = utility

function utility:IsStringSteamID(str)
    local steamPrefix = string.sub(str, 1, 10)

    if(steamPrefix == "STEAM_0:1:" or steamPrefix == "STEAM_0:0:") then
        return true 
    end
    
    return false
end

bAdminJail.util = utility 


-------------------------------------------------------------------
-- Figure out why other addon util is messing up this addon util --
-------------------------------------------------------------------