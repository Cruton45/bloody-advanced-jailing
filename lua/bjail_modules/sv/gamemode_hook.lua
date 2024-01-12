local bAdminJail = bAdminJail

-------------------------------------------------------
-- Hooks to override gamemode functions while jailed --
-------------------------------------------------------

-- Base Gmod Hooks --

hook.Add("CanPlayerSuicide", "bajail_CanSuicide", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then DarkRP.notify(ply, 1, 6, "Cannot suicide while jailed.") return false end
end)

if(bAdminJail.config.CannotSpeakWhileJailed) then 
    hook.Add( "PlayerCanHearPlayersVoice", "bajail_CanSpeak", function( listener, talker )
        if(talker.bajJailData and talker.bajJailData.isCurrentlyJailed) then return false end
    end )
end

-- Sandbox Hooks --

hook.Add("PlayerSpawnObject", "bajail_CanSpawnObject", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then DarkRP.notify(ply, 1, 6, "Cannot spawn objects while jailed.") return false end
end)

hook.Add("PlayerSpawnSENT", "bajail_CanSpawnSENT", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then DarkRP.notify(ply, 1, 6, "Cannot spawn objects while jailed.") return false end
end)

hook.Add("PlayerSpawnSWEP", "bajail_CanSpawnSWEP", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then DarkRP.notify(ply, 1, 6, "Cannot spawn objects while jailed.") return false end
end)

hook.Add("PlayerSpawnVehicle", "bajail_CanSpawnVehicle", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then DarkRP.notify(ply, 1, 6, "Cannot spawn objects while jailed.") return false end
end)

-- DarkRP Hooks --

hook.Add("playerCanChangeTeam", "bajail_CanPlayerChangeTeam", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then return false, "Cannot change teams while jailed." end
end)

hook.Add("PlayerCanPickupWeapon", "bajail_CanPlayerPickupWeapon", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then return false end
end)

hook.Add("canBuyAmmo", "bajail_CanBuyAmmo", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then return false, false, "Cannot buy ammo while jailed." end
end)

hook.Add("canBuyShipment", "bajail_CanBuyShipment", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then return false, false, "Cannot buy shipments while jailed." end
end)

hook.Add("canBuyVehicle", "bajail_CanBuyVehcile", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then return false, false, "Cannot buy vehicles while jailed." end
end)

hook.Add("canBuyCustomEntity", "bajail_CanBuyCustomEntity", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then return false, false, "Cannot buy custom entities while jailed." end
end)

hook.Add("canArrest", "bajail_CanArrest", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then return false, "Cannot arrest while jailed." end
end)

hook.Add("canUnarrest", "bajail_CanArrest", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then return false, "Cannot unarrest while jailed." end
end)

hook.Add("CanChangeRPName", "bajail_CanChangeRPName", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then return false, "Cannot change RP name while jailed." end
end)

hook.Add("canRequestHit", "bajail_CanRequestHit", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then return false, "Cannot request hit while jailed." end
end)

hook.Add("canPocket", "bajail_CanPocket", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then return false, "Cannot pocket while jailed." end
end)

hook.Add("canDropPocketItem", "bajail_CanDropPocket", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then return false, "Cannot drop pocket item while jailed." end
end)

hook.Add("canDarkRPUse", "bajail_CanDarkRPUse", function(ply)
    if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then return false, "Cannot drop pocket item while jailed." end
end)

if(bAdminJail.config.CannotChatCommandWhileJailed) then
    hook.Add("canChatCommand", "bajail_CanChatCommand", function(ply)
        if(ply.bajJailData and ply.bajJailData.isCurrentlyJailed) then DarkRP.notify(ply, 1, 6, "Cannot use chat commands while jailed.") return false end
    end)
end
