local bAdminJail = bAdminJail
local chatPrefix = "AAJ: "
local chatPrefixColor = Color(255, 0, 0)

hook.Add( "OnPlayerChat", "mjailcommandcheck", function( ply, text) 
	if (string.sub(text, 1, 5) == bAdminJail.config.jailCommandPrefix) then
		local args = string.Explode(" ", text)
		net.Start("bjail_start_jail_request")
		net.WriteTable(args)
		net.SendToServer()
		return true
	elseif (string.sub(text, 1, 7) == bAdminJail.config.unjailCommandPrefix) then
		local args = string.Explode(" ", text)
		net.Start("bjail_start_unjail_request")
		net.WriteTable(args)
		net.SendToServer()
        return true
	end
end)

-- Brodcast for all players to see valid jail commands used.
net.Receive("baj_OnJailedChatBroadcast", function()
	local adminName = net.ReadString()
	local targetName = net.ReadString()
	local jailTime = tostring(net.ReadInt(20))
	local reason = net.ReadString()

	chat.AddText(chatPrefixColor, chatPrefix, Color(51, 255, 0), adminName, Color(255,255,255), " jailed ", Color(255,0,0), targetName, Color(255,255,255), " for " .. jailTime .. " seconds " .. "(" .. reason .. ")")
end)

-- Brodcast for all players to see valid unjail commands used.
net.Receive("baj_OnAdminUnjailChatBrodcast", function()
	local adminName = net.ReadString()
	local targetName = net.ReadString()

	chat.AddText(chatPrefixColor, chatPrefix, Color(51, 255, 0), adminName, Color(255,255,255), " unjailed ", Color(255,0,0), targetName)
end)

-- Net message that is used for alerting admins of command error.
net.Receive("baj_CommandErrorNotify", function()
	local commandErrorString = net.ReadString()
	if(commandErrorString == nil or commandErrorString == '') then commandErrorString = 'ERROR' end -- Check if net.read returned and empty string

	chat.AddText(chatPrefixColor, chatPrefix, Color(255, 255, 255), commandErrorString)
end)