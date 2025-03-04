local ROLE = {}

ROLE.nameraw = "boomer"
ROLE.name = "Boomer"
ROLE.nameplural = "Boomers"
ROLE.nameext = "a Boomer"
ROLE.nameshort = "bmr"

ROLE.desc = [[Ok, {role}. {comrades}
You only have access to the original {traitor} buy menu.
You can also see what weapons the {detective} buys.
You will also EXPLODE on death.
Press {menukey} to buy special equipment!]]

ROLE.shortdesc = "Can only buy original traitor items. Explodes on death."

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
--- Might keep it though.

hook.Add("PlayerDeath", "GlobalDeathMessage", function(victim, inflictor, attacker)
    if victim == attacker and attacker:GetRole() == ROLE_BOOMER then
        PrintMessage(HUD_PRINTTALK, victim:Nick() .. " committed suicide.")
    elseif IsValid(attacker) and attacker:GetRole() == ROLE_BOOMER then
        PrintMessage(HUD_PRINTTALK, victim:Nick() .. " was killed by the Boomer!")
    end

    if IsValid(victim) and victim:GetRole() == ROLE_BOOMER then
        if not IsValid(victim) then return end
        local pos = victim:GetPos()

        local explode = ents.Create("env_explosion")
        explode:SetPos(pos)
        explode:SetOwnmer(owner)
        explode:Spawn()
        explode:SetKeyValue("iMagnitude", "230")
        explode:Fire("Explode", 0, 0)
        explode:EmitSound("ambient/explosions/explode_4.wav", 400, 400)
    end
end )

-- I'll get round to printing this nicely instead of class eventually.

hook.Add("TTTOrderedEquipment", "NotifyDetectivePurchase", function(ply, equipment, is_item)
    if ply:IsDetectiveLike() then
        for _, boomer in ipairs(player.GetAll()) do
            if boomer:GetRole() == ROLE_BOOMER then
                boomer:PrintMessage(HUD_PRINTTALK, "The Detective bought " .. equipment .. ".")
            end
        end
    end
end )

-- Add stuff for tutorial menu thing.

RegisterRole(ROLE)

if SERVER then
    AddCSLuaFile()
end