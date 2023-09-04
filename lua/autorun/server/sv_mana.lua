util.AddNetworkString("UpdatePlayerMana")

-- Default values
local defaultMaxMana = 100
local defaultRegenRate = 1  -- Amount of mana regenerated per second

-- Custom values for specific jobs
local jobMaxMana = {
    [TEAM_KNIGHT] = 150,
    [TEAM_MAGE] = 200,
    -- ... Add other jobs as needed
}

local jobRegenRate = {
    [TEAM_MAGE] = 2,  -- Mages regenerate mana faster
    -- ... Add other jobs as needed
}

local weaponManaCost = {
    ["weapon_fireball"] = 10,
    ["weapon_lightning"] = 20,
    -- ... Add other weapons and their mana costs
}

-- Initialize mana for players when they spawn
hook.Add("PlayerInitialSpawn", "InitializePlayerMana", function(ply)
    local job = ply:Team()
    ply:SetNWInt("PlayerMana", jobMaxMana[job] or defaultMaxMana)
    ply:SetNWInt("MaxPlayerMana", jobMaxMana[job] or defaultMaxMana)
    ply:SetNWInt("ManaRegenRate", jobRegenRate[job] or defaultRegenRate)
end)

-- Mana regeneration over time
timer.Create("ManaRegen", 1, 0, function()
    for _, ply in ipairs(player.GetAll()) do
        local currentMana = ply:GetNWInt("PlayerMana")
        local maxMana = ply:GetNWInt("MaxPlayerMana")
        local regenRate = ply:GetNWInt("ManaRegenRate")
        
        if currentMana < maxMana then
            ply:SetNWInt("PlayerMana", math.min(currentMana + regenRate, maxMana))
        end
    end
end)

-- Deduct mana when using specific weapons
hook.Add("PlayerSwitchWeapon", "DeductManaOnWeaponUse", function(ply, oldWeapon, newWeapon)
    local weaponClass = newWeapon:GetClass()
    local manaCost = weaponManaCost[weaponClass]
    
    if manaCost then
        local currentMana = ply:GetNWInt("PlayerMana")
        
        if currentMana < manaCost then
            ply:StripWeapon(weaponClass)  -- Remove the weapon if not enough mana
            ply:ChatPrint("Not enough mana to use this weapon!")
        else
            ply:SetNWInt("PlayerMana", currentMana - manaCost)
        end
    end
end)