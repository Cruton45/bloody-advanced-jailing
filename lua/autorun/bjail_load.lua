bAdminJail = {}

----------------------------- Module Loading -------------------------------------------
-- Shared ------------------------------------------------------------------------------
if SERVER then
    AddCSLuaFile("modules/sh/util.lua")
    AddCSLuaFile("bjail_config.lua")
end

include("modules/sh/util.lua")
include("bjail_config.lua")
-- Server ------------------------------------------------------------------------------
if SERVER then
    include("modules/sv/jailspawnpoints.lua")
    include("modules/sv/player_manager.lua")
    include("modules/sv/command_manager.lua")
end
-- Client ------------------------------------------------------------------------------
if SERVER then
    AddCSLuaFile("modules/cl/chat_handler.lua")
end
if CLIENT then
    include("modules/cl/chat_handler.lua")
end
-----------------------------------------------------------------------------------------
bAdminJail.IsLoaded = true