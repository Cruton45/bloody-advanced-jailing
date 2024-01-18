local MODULE = GAS.Logging:MODULE() -- This creates our module object, which we interface with to define its behaviours and characteristics

MODULE.Category = "Bloody Advanced Jailing " -- The name of the category we want this module to be a part of
MODULE.Name = "Jails" -- The name of the module itself
MODULE.Colour = Color(255,0,0) -- The colour of the module which is seen in the menu, typically this is identical to every module that is in the same category

MODULE:Setup(function()

	MODULE:Hook("baj_OnPlayerJailed", "gas_baj_OnJailed", function(target, jailData)
		MODULE:Log("{1} jailed {2} for " .. tostring(jailData.commandInfo.time) .. " seconds. REASON: " .. jailData.commandInfo.reason, GAS.Logging:FormatPlayer(jailData.commandInfo.admin), GAS.Logging:FormatPlayer(target))
	end)

	MODULE:Hook("baj_OnPlayerAdminUnjailed", "gas_baj_OnAdminUnjailed", function(target, admin)
		MODULE:Log("{1} unjailed {2}", GAS.Logging:FormatPlayer(admin), GAS.Logging:FormatPlayer(target))
	end)
end)

GAS.Logging:AddModule(MODULE) -- This function adds the module object to the registry.