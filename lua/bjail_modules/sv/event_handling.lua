local bAdminJail = bAdminJail

hook.Add("baj_OnPlayerJailed", "baj_OnJailed", function(target, jailData)
    if(!target or !jailData) then print("Target or jailData was nil in events.") return end

    local commandInfo = jailData.commandInfo
    if(!commandInfo) then print("There was no command info in events.") return end

    local adminName = commandInfo.admin:Nick() or "nil"
    local targetName = target:Nick() or "nil"
    local jailTime = commandInfo.time or -1
    local reason = commandInfo.reason or "None"

    net.Start("baj_OnJailedChatBroadcast")
    net.WriteString(adminName)
    net.WriteString(targetName)
    net.WriteInt(jailTime, bAdminJail.MAX_JAIL_TIME_IN_BITS)
    net.WriteString(reason)
    net.Broadcast()
end)

hook.Add("baj_OnPlayerAdminUnjailed", "baj_OnAdminUnjailed", function(target, admin)
    local adminName = admin:Nick() or "nil"
    local targetName = target:Nick() or "nil"

    net.Start("baj_OnAdminUnjailChatBrodcast")
    net.WriteString(adminName)
    net.WriteString(targetName)
    net.Broadcast()
end)

util.AddNetworkString("baj_OnJailedChatBroadcast")
util.AddNetworkString("baj_OnAdminUnjailChatBrodcast")