--[[
	mLogs 2 (M4D Logs 2)
	Created by M4D | http://m4d.one/ | http://steamcommunity.com/id/m4dhead |
	Copyright © 2023 M4D.one All Rights Reserved
	All 3rd party content is public domain or used with permission
	M4D.one is the copyright holder of all code below. Do not distribute in any circumstances.
--]]

mLogs.addCategory(
	"Advanced Jailing", -- Name
	"ajail", 
	Color(255, 0, 0), -- Color
	function() -- Check
		return bAdminJail != nil
	end
)

mLogs.addCategoryDefinitions("ajail", {
	advancedjailcommand = function(data) return mLogs.doLogReplace({"^player1","jailed", "^player2", "for", "^time", "seconds", "(", "^reason", ")"},data) end,
	advancedunjailcommand = function(data) return mLogs.doLogReplace({"^player1","unjailed", "^player2"},data) end,
})