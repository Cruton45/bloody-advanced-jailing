local function SecondsToClock()
	local ply = LocalPlayer()

	if timer.Exists("baj_JailTimer_" .. tostring(ply:SteamID64())) then
		local totalTimeInSeconds = math.Round(timer.TimeLeft("baj_JailTimer_" .. tostring(ply:SteamID64())))

		if totalTimeInSeconds <= 0 or totalTimeInSeconds == nil then
			return "00:00"
		else
			local days = math.floor(totalTimeInSeconds / (24 * 3600))
			local hours = math.floor(totalTimeInSeconds % (24 * 3600) / 3600)
			local minutes = math.floor(totalTimeInSeconds % 3600 / 60)
			local seconds = math.floor(totalTimeInSeconds % 60)

			local timeString = ""

			if(days > 0) then
				timeString = timeString .. tostring(days) .. " Days "
			end

            if(hours > 0) then
                timeString = timeString .. tostring(hours) .. " Hours " 
            end

            if(minutes > 0) then
                timeString = timeString .. tostring(minutes) .. " Minutes "
            end

            if(seconds > 0) then
                timeString = timeString .. tostring(seconds) .. " Seconds"
            end

			return timeString
		end
	end
end


local function startJailHUD()
    local baJailPlayer = LocalPlayer()

    local jailingAdminName = net.ReadString()
    local jailingReason = net.ReadString()
    local jailingTime = net.ReadInt(20)

    local x, y = ScrW() * 0.5, 80

    timer.Create("baj_JailTimer_" .. tostring(LocalPlayer():SteamID64()), jailingTime, 1, function(arguments)
        hook.Remove("HUDPaint", "bajail_PaintJailHUD")
        timer.Remove("baj_JailTimer_" .. tostring(LocalPlayer():SteamID64()))
    end)

    hook.Add("HUDPaint", "bajail_PaintJailHUD", function()
        local jailTimeLeft = SecondsToClock() or "None"

        draw.SimpleText( "You are jailed.", "HudHintTextLarge", x, y, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.SimpleText( "Time left: " .. jailTimeLeft, "HudHintTextLarge", x, y + 20, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.SimpleText( "Jailing Admin: " .. jailingAdminName, "HudHintTextLarge", x, y + 40, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.SimpleText( "Reason: " .. jailingReason, "HudHintTextLarge", x, y + 60, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
    end )
end

net.Receive("baj_StartJailClient", startJailHUD)