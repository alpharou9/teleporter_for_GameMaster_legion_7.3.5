-- Legion Teleporter: Quick teleport to Legion dungeons and raids
-- For GM use on Legion 7.3.5

local addonName = "LegionTeleporter"
local frame

-- Legion Dungeon and Raid Locations (coordinates to entrance, not inside instance)
local locations = {
    cities = {
        {name = "Stormwind", map = 0, x = -8833.38, y = 622.62, z = 94.24},
        {name = "Dalaran (Legion)", map = 1220, x = -838.45, y = 4277.20, z = 746.26},
    },
    dungeons = {
        {name = "Eye of Azshara", map = 0, x = -841.83, y = 6483.40, z = 3.75},
        {name = "Darkheart Thicket", map = 1220, x = 3090.27, y = 6065.73, z = 178.68},
        {name = "Black Rook Hold", map = 1, x = 2907.24, y = 5565.30, z = 613.62},
        {name = "Halls of Valor", map = 1, x = 921.32, y = 6943.51, z = 196.53},
        {name = "Neltharion's Lair", map = 1, x = 3261.54, y = 2789.22, z = 443.26},
        {name = "Vault of the Wardens", map = 1, x = 4593.38, y = -437.96, z = 117.82},
        {name = "Maw of Souls", map = 1, x = 2586.97, y = 680.36, z = 0.37},
        {name = "Assault on Violet Hold", map = 1, x = -840.37, y = 4490.33, z = 733.16},
        {name = "Court of Stars", map = 1, x = 1024.79, y = 4382.17, z = 45.08},
        {name = "The Arcway", map = 1, x = -835.88, y = 4278.68, z = 746.25},
        {name = "Cathedral of Eternal Night", map = 1, x = -923.42, y = 4489.75, z = 713.03},
        {name = "Seat of the Triumvirate", map = 1, x = -3582.35, y = 3398.57, z = 74.29},
    },
    raids = {
        {name = "The Emerald Nightmare", map = 1, x = 3445.69, y = 6268.80, z = 149.08},
        {name = "Trial of Valor", map = 1, x = 2594.55, y = 706.88, z = 2.58},
        {name = "The Nighthold", map = 1, x = 1008.82, y = 4591.06, z = 53.03},
        {name = "Tomb of Sargeras", map = 1, x = -1772.06, y = 1342.19, z = 2.51},
        {name = "Antorus, the Burning Throne", map = 1, x = -3464.54, y = 9870.20, z = -14.42},
    }
}

-- Create the main frame
local function CreateMainFrame()
    frame = CreateFrame("Frame", "LegionTeleporterFrame", UIParent)
    frame:SetSize(450, 600)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("HIGH")
    
    -- Backdrop
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 8, right = 8, top = 8, bottom = 8 }
    })
    frame:SetBackdropColor(0.05, 0.05, 0.1, 0.95)
    frame:SetBackdropBorderColor(0.4, 0.6, 0.8, 1)
    
    -- Make it movable
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetClampedToScreen(true)
    frame:Hide()
    
    -- Title bar
    local titleBar = CreateFrame("Frame", nil, frame)
    titleBar:SetPoint("TOPLEFT", 12, -12)
    titleBar:SetPoint("TOPRIGHT", -12, -12)
    titleBar:SetHeight(30)
    titleBar:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    titleBar:SetBackdropColor(0.1, 0.15, 0.25, 1)
    titleBar:SetBackdropBorderColor(0.5, 0.6, 0.8, 1)
    
    local titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleText:SetPoint("CENTER")
    titleText:SetText("|cff66ccffLegion Teleporter|r")
    
    -- Close button
    local closeBtn = CreateFrame("Button", nil, frame)
    closeBtn:SetSize(24, 24)
    closeBtn:SetPoint("TOPRIGHT", -10, -10)
    closeBtn:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
    closeBtn:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
    closeBtn:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
    closeBtn:SetScript("OnClick", function() frame:Hide() end)
    
    -- Cities section
    local citiesLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    citiesLabel:SetPoint("TOPLEFT", 20, -55)
    citiesLabel:SetText("|cff00ccffCities|r")
    
    local yOffset = -80
    for i, loc in ipairs(locations.cities) do
        local btn = CreateFrame("Button", nil, frame)
        btn:SetSize(410, 28)
        btn:SetPoint("TOPLEFT", 20, yOffset)
        
        btn:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        btn:SetBackdropColor(0.05, 0.1, 0.15, 0.9)
        btn:SetBackdropBorderColor(0.3, 0.5, 0.6, 1)
        
        local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        btnText:SetPoint("LEFT", 8, 0)
        btnText:SetText(loc.name)
        btnText:SetTextColor(1, 1, 1)
        
        btn:SetScript("OnEnter", function(self)
            self:SetBackdropColor(0.2, 0.3, 0.5, 1)
            self:SetBackdropBorderColor(0.5, 0.8, 1, 1)
            btnText:SetTextColor(0.5, 1, 1)
        end)
        
        btn:SetScript("OnLeave", function(self)
            self:SetBackdropColor(0.05, 0.1, 0.15, 0.9)
            self:SetBackdropBorderColor(0.3, 0.5, 0.6, 1)
            btnText:SetTextColor(1, 1, 1)
        end)
        
        btn:SetScript("OnClick", function()
            local cmd = string.format(".go xyz %.2f %.2f %.2f %d", loc.x, loc.y, loc.z, loc.map)
            SendChatMessage(cmd, "SAY")
            print("|cff66ccff[Legion Teleporter]|r Teleporting to " .. loc.name)
        end)
        
        yOffset = yOffset - 32
    end
    
    -- Dungeons section
    yOffset = yOffset - 10
    local dungeonsLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dungeonsLabel:SetPoint("TOPLEFT", 20, yOffset)
    dungeonsLabel:SetText("|cff00ff00Dungeons|r")
    
    yOffset = yOffset - 25
    for i, loc in ipairs(locations.dungeons) do
        local btn = CreateFrame("Button", nil, frame)
        btn:SetSize(410, 28)
        btn:SetPoint("TOPLEFT", 20, yOffset)
        
        btn:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        btn:SetBackdropColor(0.1, 0.1, 0.15, 0.9)
        btn:SetBackdropBorderColor(0.4, 0.4, 0.5, 1)
        
        local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        btnText:SetPoint("LEFT", 8, 0)
        btnText:SetText(loc.name)
        btnText:SetTextColor(1, 1, 1)
        
        btn:SetScript("OnEnter", function(self)
            self:SetBackdropColor(0.2, 0.3, 0.4, 1)
            self:SetBackdropBorderColor(0.6, 0.8, 1, 1)
            btnText:SetTextColor(0.5, 1, 0.5)
        end)
        
        btn:SetScript("OnLeave", function(self)
            self:SetBackdropColor(0.1, 0.1, 0.15, 0.9)
            self:SetBackdropBorderColor(0.4, 0.4, 0.5, 1)
            btnText:SetTextColor(1, 1, 1)
        end)
        
        btn:SetScript("OnClick", function()
            local cmd = string.format(".go xyz %.2f %.2f %.2f %d", loc.x, loc.y, loc.z, loc.map)
            SendChatMessage(cmd, "SAY")
            print("|cff66ccff[Legion Teleporter]|r Teleporting to " .. loc.name)
        end)
        
        yOffset = yOffset - 32
    end
    
    -- Raids section
    yOffset = yOffset - 10
    local raidsLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    raidsLabel:SetPoint("TOPLEFT", 20, yOffset)
    raidsLabel:SetText("|cffff8800Raids|r")
    
    yOffset = yOffset - 25
    for i, loc in ipairs(locations.raids) do
        local btn = CreateFrame("Button", nil, frame)
        btn:SetSize(410, 28)
        btn:SetPoint("TOPLEFT", 20, yOffset)
        
        btn:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        btn:SetBackdropColor(0.15, 0.1, 0.05, 0.9)
        btn:SetBackdropBorderColor(0.5, 0.4, 0.3, 1)
        
        local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        btnText:SetPoint("LEFT", 8, 0)
        btnText:SetText(loc.name)
        btnText:SetTextColor(1, 1, 1)
        
        btn:SetScript("OnEnter", function(self)
            self:SetBackdropColor(0.3, 0.2, 0.1, 1)
            self:SetBackdropBorderColor(1, 0.7, 0.3, 1)
            btnText:SetTextColor(1, 0.8, 0.3)
        end)
        
        btn:SetScript("OnLeave", function(self)
            self:SetBackdropColor(0.15, 0.1, 0.05, 0.9)
            self:SetBackdropBorderColor(0.5, 0.4, 0.3, 1)
            btnText:SetTextColor(1, 1, 1)
        end)
        
        btn:SetScript("OnClick", function()
            local cmd = string.format(".go xyz %.2f %.2f %.2f %d", loc.x, loc.y, loc.z, loc.map)
            SendChatMessage(cmd, "SAY")
            print("|cff66ccff[Legion Teleporter]|r Teleporting to " .. loc.name)
        end)
        
        yOffset = yOffset - 32
    end
    
    -- Add to Esc handler
    tinsert(UISpecialFrames, "LegionTeleporterFrame")
end

-- Create minimap button
local function CreateMinimapButton()
    local button = CreateFrame("Button", "LegionTeleporterMinimapButton", Minimap)
    button:SetSize(33, 33)
    button:SetFrameStrata("MEDIUM")
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    
    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetSize(21, 21)
    icon:SetPoint("CENTER", 0, 0)
    icon:SetTexture("Interface\\Icons\\Ability_Argus_PortalNetwork")
    
    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetSize(54, 54)
    border:SetPoint("CENTER")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    
    local angle = 90
    local radius = 80
    button:SetPoint("CENTER", Minimap, "CENTER", radius * cos(angle), radius * sin(angle))
    
    local isDragging = false
    button:RegisterForDrag("RightButton")
    button:RegisterForClicks("LeftButtonUp")
    
    button:SetScript("OnDragStart", function() isDragging = true end)
    button:SetScript("OnDragStop", function() isDragging = false end)
    
    button:SetScript("OnUpdate", function(self)
        if isDragging then
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            px, py = px / scale, py / scale
            local newAngle = math.deg(math.atan2(py - my, px - mx))
            self:ClearAllPoints()
            self:SetPoint("CENTER", Minimap, "CENTER",
                radius * cos(newAngle), radius * sin(newAngle))
        end
    end)
    
    button:SetScript("OnClick", function()
        if frame:IsShown() then
            frame:Hide()
        else
            frame:Show()
        end
    end)
    
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("|cff66ccffLegion Teleporter|r")
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("|cffffffffLeft-click|r to toggle", 0.8, 0.8, 0.8)
        GameTooltip:AddLine("|cffffffffRight-drag|r to move", 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)
    
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

-- Slash commands
SLASH_LEGIONTELEPORTER1 = "/t"
SLASH_LEGIONTELEPORTER2 = "/lt"
SLASH_LEGIONTELEPORTER3 = "/legiontp"

SlashCmdList["LEGIONTELEPORTER"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

-- Initialize
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        CreateMainFrame()
        CreateMinimapButton()
        print("|cff66ccff[Legion Teleporter]|r v1.0 Loaded! Type |cffffffff/t|r to open.")
    end
end)
