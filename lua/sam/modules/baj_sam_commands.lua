local maxJailTimeInMinutes = 8640 -- 6 days. Might just use bAdminJail globals instead.

sam.command.set_category("Advanced Jailing")

sam.command.new("ajail")
    :SetPermission("ajail", "admin")

    :AddArg("player", {single_target = true})
    :AddArg("length", {optional = true, default = 0})
    :AddArg("text", {hint = "reason", optional = true, default = sam.language.get("default_reason")})

    :GetRestArgs()

    :Help("Advanced jails a player.")

    :OnExecute(function(ply, targets, length, reason) -- Length is in minutes
		local target = targets[1]

        if(target.bajJailData and target.bajJailData.isJailed) then return end -- Make this notify later. This means target is already jailed.

        if(length > maxJailTimeInMinutes) then
            length = maxJailTimeInMinutes
        end

        local commandInfo = {
            admin = ply,
            target = target,
            time = length * 60,
            reason = reason
        }

        target:bajJailPlayer(commandInfo)
		
		sam.player.send_message(nil, "{A} advanced jailed {T} for {V}({V_2})!", {
			A = ply, T = target:Name(), V = sam.format_length(length), V_2 = reason
		})
	end)
:End()

sam.command.new("aunjail")
    :SetPermission("aunjail", "admin")

    :AddArg("player", {single_target = true})

    :GetRestArgs()

    :Help("Advanced unjails a player.")

    :OnExecute(function(ply, targets) -- Length is in minutes
		local target = targets[1]

        if(!target.bajJailData or !target.bajJailData.isJailed) then return end -- Make this notify later. This means target isn't jailed.

        local commandInfo = {
            admin = ply,
            target = target
        }

        target:bajUnJailPlayer(true, commandInfo)
		
		sam.player.send_message(nil, "{A} advanced unjailed {T}!", {
			A = ply, T = target:Name()
		})
	end)
:End()