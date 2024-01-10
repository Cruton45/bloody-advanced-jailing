local bAdminJail = bAdminJail

-- Finds all players that are relevent to the target string
local function FindPlayerByName(name)
    local found = {}
    for k, v in ipairs(player.GetAll()) do
        if string.find(string.lower(v:Nick()), string.lower(name)) then
            table.insert(found, v)
        end
    end

    return found
end

-- Finds player by steamid and returns it, returns nil if not found.
local function FindPlayerBySteamID(steamid)
    for k, ply in ipairs(player.GetAll()) do
        if string.find(string.upper(steamid), ply:SteamID()) then
            return ply
        end
    end

    return nil
end


-- Determins targeting method and selects target based on that method from target command.
local function DeterminTargetFromTargetArg(targetArg)
    local target = nil

    -- Look at target code
    if(targetArg == "@") then
        return
    elseif(bAdminJail.util:IsStringSteamID(targetArg)) then -- SteamID target code
        target = FindPlayerBySteamID(targetArg)
        if(!target) then print("bAdminJail: Could not find target with that steamID") return end
    else -- Name target code
        local foundPlayersByName = FindPlayerByName(targetArg)
        if(table.IsEmpty(foundPlayersByName)) then print("bAdminJail: Could not find target by name.") return end
        if(#foundPlayersByName > 1) then print("bAdminJail: Found more then one target with that name.") return end

        target = foundPlayersByName[1]
    end

    return target
end

-- Compile the args into an commandInfo dictionary
local function CompileJailCommand(len, ply)
    args = net.ReadTable()

    if(args[1] ~= bAdminJail.config.jailCommandPrefix) then return end 
    table.remove(args, 1) -- Remove the jail arg from args

    local possibleTarget = DeterminTargetFromTargetArg(args[1])
    local possibleTime = tonumber(args[2])
    local possibleReason = args[3]

    if(!possibleTarget) then print("bAdminJail: Still had no target in command compiling.") return end
    if(!possibleTime or possibleTime < 0) then possibleTime = 0 end
    if(!possibleReason) then possibleReason = "None" end
    
    local commandInfo = {
        target = possibleTarget,
        time = possibleTime,
        reason = possibleReason
    }

    PrintTable(commandInfo)
end

net.Receive("bjail_start_jail_request", CompileJailCommand)
util.AddNetworkString("bjail_start_jail_request")