local bAdminJail = bAdminJail
local config = {}

config.__index = config

-- Jail Command Config -----------------------
config.jailCommandPrefix = "#jail"
config.unjailCommandPrefix = "#unjail"

-- Jail Negations -----------------------
config.CannotSpeakWhileJailed = true -- Somewhat non-performant, if you have issues change to false but should be fine.
config.CannotChatCommandWhileJailed = true

bAdminJail.config = config