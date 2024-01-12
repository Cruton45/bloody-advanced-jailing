
function startJailHUD()
    local baJailPlayer = LocalPlayer()

    local jailingAdminName = net.ReadString()
    local jailingReason = net.ReadString()
    local jailingTime = net.ReadInt(20)

    local x, y = ScrW() * 0.5, 80

    hook.Add("HUDPaint", "bajail_PaintJailHUD", function()
        draw.SimpleText( "You are jailed.", "HudHintTextLarge", x, y, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.SimpleText( "Time left: " .. jailingTime, "HudHintTextLarge", x, y + 20, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.SimpleText( "Jailing Admin: " .. jailingAdminName, "HudHintTextLarge", x, y + 40, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.SimpleText( "Reason: " .. jailingReason, "HudHintTextLarge", x, y + 60, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
    end )
end

net.Receive("baj_StartJailClient", startJailHUD)