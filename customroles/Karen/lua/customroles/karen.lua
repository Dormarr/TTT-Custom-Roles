local ROLE = {}

ROLE.nameraw = "karen"
ROLE.name = "Karen"
ROLE.nameplural = "Karens"
ROLE.nameext = "a Karen"
ROLE.nameshort = "krn"

ROLE.desc = [[You are a {role}!
Hassle the {detective} for an item before they get demoted!
Keep in mind, you will only be satisfied 2/3 times...]]

ROLE.shortdesc = "Recieve an item from the {detective} to become {innocent}."

ROLE.team = ROLE_TEAM_JESTER

ROLE.shop = {}
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

local KAREN_REQUEST_TIME = 60 -- time to satisfy condition
local KAREN_UNSATISFIED_CHANCE = 1/3

local karenPlayer = nil
local karenRequestItem = nil
local karenRequestTimer = nil

local function StartKarenRequest(ply)
    if not IsValid(ply) or ply:GetRole() ~= ROLE_KAREN then return end

    for _, detective in ipairs(player.GetAll()) do
        if detective:IsDetectiveLike() then
            detective:PrintMessage(HUD_PRINTTALK, "The Karen is demanding an item from you.")
        end
    end

    -- Start timer
    karenRequestTimer = timer.Create("KarenRequestTimer", KAREN_REQUEST_TIME, 1, function()
    if IsValid(ply) then
        -- Demote detective
        for _, detective in ipairs(player.GetAll()) do
            if detective:IsDetectiveLike() then
                detective:SetRole(ROLE_INNOCENT)
                detective:PrintMessage(HUD_PRINTTALK, "You have been demoted for failing to satisfy the Karen!")
            end
        end

        ply:SetRole(ROLE_TRAITOR)
        ply:PrintMessage(HUD_PRINTTALK, "You have joined the Traitors due to the Detective's incompitence!")
        end
    end)
end


hook.Add("TTTBeginRound", "StartKarenRequest", function()
    karenPlayer = nil
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetRole() == ROLE_KAREN then
            karenPlayer = ply
            StartKarenRequest(ply)
            break
        end
    end
end)

hook.Add("TTTPlayerRoleChanged", "StartKarenRequest", function(ply, oldRole, newRole)
    if newRole == ROLE_KAREN then
    StartKarenRequest(ply)
    end
end)

hook.Add("PlayerCanPickupWeapon", "KarenWeaponPickup", function(ply, weapon)
    if not IsValid(karenPlayer) or karenPlayer:GetRole() ~= ROLE_KAREN then return end
    if ply ~= karenPlayer then return end

    local owner = weapon.BoughtBy
    if IsValid(owner) and owner:IsDetectiveLike() then
        -- Satisfaction check
        if math.random() < KAREN_UNSATISFIED_CHANCE then
            ply:PrintMessage(HUD_PRINTTALK, "The Karen is not satisfied and wants another item!")
            StartKarenRequest(ply)
        else
            ply:PrintMessage(HUD_PRINTTALK, "The Karen is satisfied!")
            timer.Remove("KarenRequestTimer")
            karenPlayer = nil
        end
    end
end)

hook.Add("PlayerCanPickupItem", "KarenItemPickup", function(ply, item)
    if not IsValid(karenPlayer) or karenPlayer:GetRole() ~= ROLE_KAREN then return end
    if ply ~= karenPlayer then return end

    local owner = item.BoughtBy
    if IsValid(owner) and owner:IsDetectiveLike() then
        -- Satisfaction check
        if math.random() < KAREN_UNSATISFIED_CHANCE then
            ply:PrintMessage(HUD_PRINTTALK, "The Karen is not satisfied and wants another item!")
            StartKarenRequest(ply)
        else
            ply:PrintMessage(HUD_PRINTTALK, "The Karen is satisfied!")
            timer.Remove("KarenRequestTimer")
            karenPlayer = nil
        end
    end
end)


-- No damage dealt, look into jester behaviour ConVar.
-- Recieve item, 2/3 chance to turn innocent.
-- Begin timer on spawn before forcing detective demotion.

RegisterRole(ROLE)

if SERVER then
    AddCSLuaFile()
end