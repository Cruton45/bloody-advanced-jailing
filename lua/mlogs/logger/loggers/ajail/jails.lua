local category = "ajail"
// SAM Command Logs
mLogs.addLogger("Jails","advancedjailcommand",category)
mLogs.addLogger("Unjails","advancedunjailcommand",category)

mLogs.addHook("baj_OnPlayerJailed", category, function(target, jailData)
	if(not IsValid(target))then return end
	if(!jailData) then return end
	if(not IsValid(jailData.commandInfo.admin)) then return end

	mLogs.log("advancedjailcommand", category, {player1=mLogs.logger.getPlayerData(jailData.commandInfo.admin),
		player2=mLogs.logger.getPlayerData(target),
		time=tostring(jailData.commandInfo.time),
		reason=jailData.commandInfo.reason
	})
end)

mLogs.addHook("baj_OnPlayerAdminUnjailed", category, function(target, admin)
	if(not IsValid(target))then return end
	if(not IsValid(admin)) then return end

	mLogs.log("advancedunjailcommand", category, {player1=mLogs.logger.getPlayerData(admin), player2=mLogs.logger.getPlayerData(target)})
end)