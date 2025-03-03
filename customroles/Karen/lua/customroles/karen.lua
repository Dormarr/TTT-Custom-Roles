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

ROLE.team = ROLE_TEAM_TRAITOR

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

-- No damage dealt, look into jester behaviour ConVar.
-- Recieve item, 2/3 chance to turn innocent.
-- Begin timer on spawn before forcing detective demotion.

RegisterRole(ROLE)

if SERVER then
    AddCSLuaFile()
end