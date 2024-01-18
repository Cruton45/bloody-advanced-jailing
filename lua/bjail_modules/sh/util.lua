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

if(SERVER) then 
    function utility:NotifyCommandError(ply, commandErrorString)
        if(!ply or !commandErrorString) then print("AAJ: Error with notify command error. player or string was nil") return end

        net.Start("baj_CommandErrorNotify")
        net.WriteString(commandErrorString)
        net.Send(ply)
    end

    util.AddNetworkString("baj_CommandErrorNotify")
end
bAdminJail.util = utility
