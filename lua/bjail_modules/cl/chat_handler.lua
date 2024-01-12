local bAdminJail = bAdminJail

hook.Add( "OnPlayerChat", "mjailcommandcheck", function( ply, text) 
	if (string.sub(text, 1, 5) == bAdminJail.config.jailCommandPrefix) then
		local args = string.Explode(" ", text)
		net.Start("bjail_start_jail_request")
		net.WriteTable(args)
		net.SendToServer()
		return true
	elseif (string.sub(text, 1, 7) == "#unjail") then
		local args = string.Explode(" ", text)
		--net.Start("munjailServer")
		--net.WriteEntity(ply)
		--net.WriteString(args[2])
		--net.SendToServer()
        return true
	end
end )