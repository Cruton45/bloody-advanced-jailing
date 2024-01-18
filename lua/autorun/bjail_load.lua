bAdminJail = {}
bAdminJail.MAX_JAIL_TIME_IN_BITS = 20 -- Make this on shared realm so it can be used on chat_handler.
bAdminJail.MAX_JAIL_TIME_IN_SECONDS = 518400

----------------------------- Module Loading -------------------------------------------
-- Shared ------------------------------------------------------------------------------
if SERVER then
    AddCSLuaFile("bjail_modules/sh/util.lua")
    AddCSLuaFile("bjail_config.lua")
end

include("bjail_modules/sh/util.lua")
include("bjail_config.lua")
-- Server ------------------------------------------------------------------------------
if SERVER then
    include("bjail_modules/sv/jailspawnpoints.lua")
    include("bjail_modules/sv/player_manager.lua")
    include("bjail_modules/sv/command_manager.lua")
    include("bjail_modules/sv/gamemode_hook.lua")
    include("bjail_modules/sv/event_handling.lua")
end
-- Client ------------------------------------------------------------------------------
if SERVER then
    AddCSLuaFile("bjail_modules/cl/chat_handler.lua")
    AddCSLuaFile("bjail_modules/cl/baj_jail_ui.lua")
end
if CLIENT then
    include("bjail_modules/cl/chat_handler.lua")
    include("bjail_modules/cl/baj_jail_ui.lua")
end
-----------------------------------------------------------------------------------------
bAdminJail.IsLoaded = true