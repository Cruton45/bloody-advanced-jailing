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
        if(!target) then return nil, "Could not find target with that steamID" end -- Return this to other function to send error
    else -- Name target code
        local foundPlayersByName = FindPlayerByName(targetArg)
        if(table.IsEmpty(foundPlayersByName)) then return nil, "Could not find any target with that name." end -- Return this to other function to send error
        if(#foundPlayersByName > 1) then return nil, "Found more then one target with that name." end -- Return this to other function to send error

        target = foundPlayersByName[1]
    end

    return target, nil
end

-- 1d = 1 day
-- 1h = 1 hour
-- 1m = 1 minute
-- 1s = 1 second
-- 1d1h1m1s = 1 day and 1 hour 1 minute and 1 second. so a total of 86,401 seconds

-- Takes time string and parses and then returns total time to seconds.
local function ConvertTimeString(timeString)
    if(!timeString) then return 0 end

    local dayCount = timeString:match("(%d-)d") or 0
    local hourCount = timeString:match("(%d-)h") or 0
    local minuteCount = timeString:match("(%d-)m") or 0
    local secondCount = timeString:match("(%d-)s") or 0

    local totalTimeInSeconds = (dayCount * 86400) + (hourCount * 3600) + (minuteCount * 60) + secondCount 

    if(totalTimeInSeconds > bAdminJail.MAX_JAIL_TIME_IN_SECONDS) then -- 6 days 524287
        totalTimeInSeconds = bAdminJail.MAX_JAIL_TIME_IN_SECONDS
    end

    return totalTimeInSeconds
end

-- Compile the args into an commandInfo dictionary
local function CompileJailCommand(len, ply)
    local args = net.ReadTable()

    if(args[1] ~= bAdminJail.config.jailCommandPrefix) then return end 
    table.remove(args, 1) -- Remove the jail arg from args

    local possibleTarget, commandErrorString = DeterminTargetFromTargetArg(args[1]) -- Function returns a tuple, if target is nil then it will return command error or vice versa
    local possibleTime = ConvertTimeString(args[2])
    local possibleReason = args[3]

    if(!possibleTarget) then bAdminJail.util:NotifyCommandError(ply, commandErrorString) return end
    if(!possibleTime) then possibleTime = 0 end
    if(!possibleReason) then possibleReason = "None" end
    
    local commandInfo = {
        admin = ply,
        target = possibleTarget,
        time = possibleTime,
        reason = possibleReason
    }

    possibleTarget:bajJailPlayer(commandInfo)
end

local function CompileUnjailCommand(len, ply)
    local args = net.ReadTable()
    
    if(args[1] ~= bAdminJail.config.unjailCommandPrefix) then return end 
    table.remove(args, 1) -- Remove the unjail arg from args

    local possibleTarget = DeterminTargetFromTargetArg(args[1])

    if(!possibleTarget) then print("bAdminJail: Still had no target in unjail command compiling.") return end

    local commandInfo = { -- Change becuase this sturcture is diffrent from the commandInfo in the jail command.
        admin = ply,
        target = possibleTarget
    }

    possibleTarget:bajUnJailPlayer(true, commandInfo) -- Call unjail on player and tell the function it was called by admin.
end

net.Receive("bjail_start_jail_request", CompileJailCommand)
net.Receive("bjail_start_unjail_request", CompileUnjailCommand)
util.AddNetworkString("bjail_start_jail_request")
util.AddNetworkString("bjail_start_unjail_request")