local ROLE = {}

ROLE.nameraw = "boomer"
ROLE.name = "Boomer"
ROLE.nameplural = "Boomers"
ROLE.nameext = "a Boomer"
ROLE.nameshort = "bmr"

ROLE.desc = [[Ok, {role}. {comrades}
You only have access to the original {traitor} buy menu.
You can also see what weapons the {detective} buys.
Press {menukey} to buy special equipment!]]

ROLE.shortdesc = "Can only buy original traitor items."

ROLE.team = ROLE_TEAM_TRAITOR

ROLE.shop = {"weapon_ttt_sipistol"}
ROLE.loadout = {}

ROLE.startingcredits = 2

ROLE.startinghealth = nil
ROLE.maxhealth = nil

ROLE.isactive = nil
ROLE.selectionpredicate = nil
ROLE.shouldactlikejester = nil

ROLE.translations = {}

ROLE.convars = {}

---------------------
--- Role Features ---
---------------------

--- I only added this to ensure the code was actually working.

hook.Add("PlayerDeath", "GlobalDeathMessage", function(victim, inflictor, attacker)
    if victim == attacker and attacker:GetRole() == ROLE_BOOMER then
        PrintMessage(HUD_PRINTTALK, victim:Nick() .. " committed suicide.")
    elseif IsValid(attacker) and attacker:GetRole() == ROLE_BOOMER then
        PrintMessage(HUD_PRINTTALK, victim:Nick() .. " was killed by the Boomer!")
    end
end )

hook.Add("TTTOrderedEquipment", "NotifyDetectivePurchase", function(ply, equipment, is_item)
    if ply:IsDetective() then
        for _, boomer in ipairs(player.GetAll()) do
            if boomer:GetRole() == ROLE_BOOMER then
                boomer:PrintMessage(HUD_PRINTTALK, "The {detective} bought " .. equipment .. ".")
            end
        end
    end
end )

RegisterRole(ROLE)

if SERVER then
    AddCSLuaFile()
end