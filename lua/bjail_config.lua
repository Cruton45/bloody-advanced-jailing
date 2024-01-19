local bAdminJail = bAdminJail
local config = {}

config.__index = config

-- Jail Misc ---------------------------------
config.jailPosition = Vector(-827.441956, -1441.969238, 7144.031250) -- This is temp, jail pos will be set with tool gun.
-- Jail Command Config -----------------------
config.jailCommandPrefix = "#jail"
config.unjailCommandPrefix = "#unjail"

-- Jail Negations ----------------------------
config.CannotSpeakWhileJailed = true -- Somewhat non-performant, if you have issues change to false but should be fine.
config.CannotChatCommandWhileJailed = true

bAdminJail.config = config