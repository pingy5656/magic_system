-- Drawing the mana bar
hook.Add("HUDPaint", "DrawManaBar", function()
    local ply = LocalPlayer()
    local maxMana = ply:GetNWInt("MaxPlayerMana", 100)
    local currentMana = ply:GetNWInt("PlayerMana", maxMana)
    
    -- Positioning and size
    local barWidth = 200
    local barHeight = 20
    local posX = ScrW() * 0.05  -- 5% from the left side of the screen
    local posY = ScrH() * 0.95 - barHeight * 2  -- 5% from the bottom, above the armor bar
    
    -- Colors
    local bgColor = Color(50, 50, 50, 200)
    local manaColor = Color(0, 0, 255, 255)  -- Blue for mana
    
    -- Drawing the background
    draw.RoundedBox(4, posX, posY, barWidth, barHeight, bgColor)
    
    -- Drawing the mana bar
    local manaWidth = (currentMana / maxMana) * barWidth
    draw.RoundedBox(4, posX, posY, manaWidth, barHeight, manaColor)
    
    -- Drawing the text
    draw.SimpleText("Mana: " .. currentMana .. "/" .. maxMana, "Default", posX + barWidth / 2, posY + barHeight / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)
