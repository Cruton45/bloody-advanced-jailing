-- This is for any helper functions in the addon.
local bAdminJail = bAdminJail
local jailPositions = {} -- This is for the jail position object that holds jail pos functions and properties
local jailPositionTable = {} -- This holds actual jail pos vectors
local bajDirectoryName = "advanced_admin_jailing"
local bajJailPositionsFileName = "jail_positions.txt"

jailPositions.__index = jailPositions

-- Adds a position to the list
function jailPositions:Add(pos)
    table.insert(jailPositionTable, pos)
    PrintTable(jailPositionTable)
end

-- Gets all avalible positions
function jailPositions:GetAll()
    return jailPositionList
end

-- Runs when the player trys to save all spawn points.
function jailPositions:Save(caller)
    local fullJailPositionsPath = (bajDirectoryName .. "/" .. game.GetMap() .. "_" .. bajJailPositionsFileName)

    -- If the user is not a superadmin then dont do anything.
    if(!caller:IsSuperAdmin()) then return end

    -- Makes sure the file to save to exists before saving.
    if(file.IsDir(bajDirectoryName, "DATA") and file.Exists(fullJailPositionsPath, "DATA")) then
        local jsonJailSpawns = util.TableToJSON(jailPositionTable)
        file.Write(fullJailPositionsPath, jsonJailSpawns)
    else
        print("AAJ: Did not have the save file for to save the jail position.")
    end
end

function jailPositions:RemoveAll(caller)
    -- If the user is not a superadmin then dont do anything.
    if(!caller:IsSuperAdmin()) then return end

    table.Empty(jailPositionTable)
end

-- This will create or load the save file. If the file exists then append data to jail position list.
hook.Add("Initialize", "bajail_server_init", function()
    -- Added map to name for diffrent map positions. Then append it to total jail position text file path.
    local fullJailPositionsPath = (bajDirectoryName .. "/" .. game.GetMap() .. "_" .. bajJailPositionsFileName)

    if(!file.IsDir(bajDirectoryName, "DATA")) then
        file.CreateDir(bajDirectoryName, "DATA")
        file.Write(fullJailPositionsPath, 0)

        print("AAJ: Creating jail positions save file for " .. game.GetMap())
    elseif(!file.Exists(fullJailPositionsPath, "DATA")) then
        file.Write(fullJailPositionsPath, 0)

        print("AAJ: Creating jail positions save file for " .. game.GetMap())
    else
        jailPositionTable = util.JSONToTable(file.Read(fullJailPositionsPath, "DATA" ))
    end
end)

concommand.Add("aaj_saveJailPositions", function(caller)
    jailPositions:Save(caller)
end)

concommand.Add("aaj_removeAllJailPositions", function(caller)
    jailPositions:RemoveAll(caller)
end)

bAdminJail.jailPositions = jailPositions