-- This is for any helper functions in the addon.
local bAdminJail = bAdminJail
local jailPositions = {} -- This is for the jail position object that holds jail pos functions and properties
local jailPositionTable = {} -- This holds actual jail pos vectors

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

bAdminJail.jailPositions = jailPositions