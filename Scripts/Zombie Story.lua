local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Settings
local settings = {
    AimbotEnabled = false,
    ShowFOV = true,
    FOVRadius = 100,
    FOVColor = Color3.fromRGB(255, 0, 0),
    FOVTransparency = 0.7,
    FOVThickness = 1,
    StickyAim = false,
    AimbotMethod = "Camera",
    WallCheck = false,
    UIKey = Enum.KeyCode.Insert,
    Smoothness = 0.2,
    ESPEnabled = false,
    ChamColor = Color3.fromRGB(0, 255, 0),
    ChamTransparency = 0.5,
    CameraFOV = Camera.FieldOfView,
    Walkspeed = 16,
    Jumppower = 50
}

-- UI Elements
local screenGui, mainFrame, fovCircle, tabFrame, aimbotTabButton, espTabButton, otherTabButton, aimbotContent, espContent, otherContent
local minimized, dragging, dragStart, startPos = false, false, nil, nil
local chams = {}

-- Create UI
local function createUI()
    if screenGui then screenGui:Destroy() end
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AimbotUI"
    screenGui.Parent = game:GetService("CoreGui") or localPlayer:WaitForChild("PlayerGui")

    mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 250, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 6)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 150, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Skid Softworks - Zombie Story"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 14
    title.Parent = titleBar

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 1, 0)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.GothamSemibold
    closeButton.TextSize = 14
    closeButton.Parent = titleBar
    closeButton.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 1, 0)
    minimizeButton.Position = UDim2.new(1, -60, 0, 0)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Text = "_"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.Font = Enum.Font.GothamSemibold
    minimizeButton.TextSize = 14
    minimizeButton.Parent = titleBar
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        mainFrame.Size = minimized and UDim2.new(0, 250, 0, 30) or UDim2.new(0, 250, 0, 300)
        minimizeButton.Text = minimized and "+" or "_"
    end)

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, -20, 0, 30)
    tabFrame.Position = UDim2.new(0, 10, 0, 30)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = mainFrame

    aimbotTabButton = Instance.new("TextButton")
    aimbotTabButton.Size = UDim2.new(0.33, -5, 1, 0)
    aimbotTabButton.Position = UDim2.new(0, 0, 0, 0)
    aimbotTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    aimbotTabButton.Text = "Aimbot"
    aimbotTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    aimbotTabButton.Font = Enum.Font.Gotham
    aimbotTabButton.TextSize = 12
    aimbotTabButton.Parent = tabFrame
    Instance.new("UICorner", aimbotTabButton).CornerRadius = UDim.new(0, 4)

    espTabButton = Instance.new("TextButton")
    espTabButton.Size = UDim2.new(0.33, -5, 1, 0)
    espTabButton.Position = UDim2.new(0.33, 5, 0, 0)
    espTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    espTabButton.Text = "ESP"
    espTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    espTabButton.Font = Enum.Font.Gotham
    espTabButton.TextSize = 12
    espTabButton.Parent = tabFrame
    Instance.new("UICorner", espTabButton).CornerRadius = UDim.new(0, 4)

    otherTabButton = Instance.new("TextButton")
    otherTabButton.Size = UDim2.new(0.33, -5, 1, 0)
    otherTabButton.Position = UDim2.new(0.66, 5, 0, 0)
    otherTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    otherTabButton.Text = "Other"
    otherTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    otherTabButton.Font = Enum.Font.Gotham
    otherTabButton.TextSize = 12
    otherTabButton.Parent = tabFrame
    Instance.new("UICorner", otherTabButton).CornerRadius = UDim.new(0, 4)

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -70)
    contentFrame.Position = UDim2.new(0, 10, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    aimbotContent = Instance.new("Frame")
    aimbotContent.Size = UDim2.new(1, 0, 1, 0)
    aimbotContent.BackgroundTransparency = 1
    aimbotContent.Visible = true
    aimbotContent.Parent = contentFrame

    espContent = Instance.new("Frame")
    espContent.Size = UDim2.new(1, 0, 1, 0)
    espContent.BackgroundTransparency = 1
    espContent.Visible = false
    espContent.Parent = contentFrame

    otherContent = Instance.new("Frame")
    otherContent.Size = UDim2.new(1, 0, 1, 0)
    otherContent.BackgroundTransparency = 1
    otherContent.Visible = false
    otherContent.Parent = contentFrame

    aimbotTabButton.MouseButton1Click:Connect(function()
        aimbotContent.Visible = true
        espContent.Visible = false
        otherContent.Visible = false
        aimbotTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        espTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        otherTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)

    espTabButton.MouseButton1Click:Connect(function()
        aimbotContent.Visible = false
        espContent.Visible = true
        otherContent.Visible = false
        aimbotTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        espTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        otherTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)

    otherTabButton.MouseButton1Click:Connect(function()
        aimbotContent.Visible = false
        espContent.Visible = false
        otherContent.Visible = true
        aimbotTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        espTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        otherTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)

    local aimbotToggle = Instance.new("Frame")
    aimbotToggle.Size = UDim2.new(1, 0, 0, 30)
    aimbotToggle.BackgroundTransparency = 1
    aimbotToggle.Parent = aimbotContent

    local aimbotLabel = Instance.new("TextLabel")
    aimbotLabel.Size = UDim2.new(0, 150, 1, 0)
    aimbotLabel.BackgroundTransparency = 1
    aimbotLabel.Text = "Aimbot Enabled"
    aimbotLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    aimbotLabel.TextXAlignment = Enum.TextXAlignment.Left
    aimbotLabel.Font = Enum.Font.Gotham
    aimbotLabel.TextSize = 12
    aimbotLabel.Parent = aimbotToggle

    local aimbotButton = Instance.new("TextButton")
    aimbotButton.Size = UDim2.new(0, 50, 0, 20)
    aimbotButton.Position = UDim2.new(1, -50, 0.5, -10)
    aimbotButton.BackgroundColor3 = settings.AimbotEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    aimbotButton.Text = settings.AimbotEnabled and "ON" or "OFF"
    aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    aimbotButton.Font = Enum.Font.Gotham
    aimbotButton.TextSize = 12
    aimbotButton.Parent = aimbotToggle
    Instance.new("UICorner", aimbotButton).CornerRadius = UDim.new(0, 4)
    aimbotButton.MouseButton1Click:Connect(function()
        settings.AimbotEnabled = not settings.AimbotEnabled
        aimbotButton.BackgroundColor3 = settings.AimbotEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        aimbotButton.Text = settings.AimbotEnabled and "ON" or "OFF"
    end)

    local fovToggle = Instance.new("Frame")
    fovToggle.Size = UDim2.new(1, 0, 0, 30)
    fovToggle.Position = UDim2.new(0, 0, 0, 30)
    fovToggle.BackgroundTransparency = 1
    fovToggle.Parent = aimbotContent

    local fovLabel = Instance.new("TextLabel")
    fovLabel.Size = UDim2.new(0, 150, 1, 0)
    fovLabel.BackgroundTransparency = 1
    fovLabel.Text = "Show FOV Circle"
    fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fovLabel.TextXAlignment = Enum.TextXAlignment.Left
    fovLabel.Font = Enum.Font.Gotham
    fovLabel.TextSize = 12
    fovLabel.Parent = fovToggle

    local fovButton = Instance.new("TextButton")
    fovButton.Size = UDim2.new(0, 50, 0, 20)
    fovButton.Position = UDim2.new(1, -50, 0.5, -10)
    fovButton.BackgroundColor3 = settings.ShowFOV and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    fovButton.Text = settings.ShowFOV and "ON" or "OFF"
    fovButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    fovButton.Font = Enum.Font.Gotham
    fovButton.TextSize = 12
    fovButton.Parent = fovToggle
    Instance.new("UICorner", fovButton).CornerRadius = UDim.new(0, 4)
    fovButton.MouseButton1Click:Connect(function()
        settings.ShowFOV = not settings.ShowFOV
        fovButton.BackgroundColor3 = settings.ShowFOV and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        fovButton.Text = settings.ShowFOV and "ON" or "OFF"
        if fovCircle then fovCircle.Visible = settings.ShowFOV end
    end)

    local fovSize = Instance.new("Frame")
    fovSize.Size = UDim2.new(1, 0, 0, 40)
    fovSize.Position = UDim2.new(0, 0, 0, 60)
    fovSize.BackgroundTransparency = 1
    fovSize.Parent = aimbotContent

    local fovSizeLabel = Instance.new("TextLabel")
    fovSizeLabel.Size = UDim2.new(1, 0, 0, 20)
    fovSizeLabel.BackgroundTransparency = 1
    fovSizeLabel.Text = "FOV Size: " .. settings.FOVRadius
    fovSizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fovSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    fovSizeLabel.Font = Enum.Font.Gotham
    fovSizeLabel.TextSize = 12
    fovSizeLabel.Parent = fovSize

    local fovSizeSlider = Instance.new("Frame")
    fovSizeSlider.Size = UDim2.new(1, 0, 0, 10)
    fovSizeSlider.Position = UDim2.new(0, 0, 0, 25)
    fovSizeSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    fovSizeSlider.Parent = fovSize
    Instance.new("UICorner", fovSizeSlider).CornerRadius = UDim.new(1, 0)

    local fovSizeSliderFill = Instance.new("Frame")
    fovSizeSliderFill.Size = UDim2.new((settings.FOVRadius - 50) / 150, 0, 1, 0)
    fovSizeSliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fovSizeSliderFill.Parent = fovSizeSlider
    Instance.new("UICorner", fovSizeSliderFill).CornerRadius = UDim.new(1, 0)

    local fovSizeSliderButton = Instance.new("TextButton")
    fovSizeSliderButton.Size = UDim2.new(0, 20, 0, 20)
    fovSizeSliderButton.Position = UDim2.new((settings.FOVRadius - 50) / 150, -10, 0.5, -10)
    fovSizeSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fovSizeSliderButton.Text = ""
    fovSizeSliderButton.Parent = fovSizeSlider
    Instance.new("UICorner", fovSizeSliderButton).CornerRadius = UDim.new(1, 0)

    local function updateFOVSize(value)
        value = math.clamp(value, 50, 200)
        settings.FOVRadius = value
        fovSizeLabel.Text = "FOV Size: " .. math.floor(value)
        fovSizeSliderFill.Size = UDim2.new((value - 50) / 150, 0, 1, 0)
        fovSizeSliderButton.Position = UDim2.new((value - 50) / 150, -10, 0.5, -10)
        if fovCircle then
            fovCircle.Size = UDim2.new(0, value * 2, 0, value * 2)
            fovCircle.Position = UDim2.new(0.5, -value, 0.5, -value)
        end
    end

    fovSizeSliderButton.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local mouse = UserInputService:GetMouseLocation()
            local sliderPos = fovSizeSlider.AbsolutePosition
            local sliderSize = fovSizeSlider.AbsoluteSize
            local value = ((mouse.X - sliderPos.X) / sliderSize.X) * 150 + 50
            updateFOVSize(value)
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then connection:Disconnect() end
        end)
    end)

    local stickyToggle = Instance.new("Frame")
    stickyToggle.Size = UDim2.new(1, 0, 0, 30)
    stickyToggle.Position = UDim2.new(0, 0, 0, 100)
    stickyToggle.BackgroundTransparency = 1
    stickyToggle.Parent = aimbotContent

    local stickyLabel = Instance.new("TextLabel")
    stickyLabel.Size = UDim2.new(0, 150, 1, 0)
    stickyLabel.BackgroundTransparency = 1
    stickyLabel.Text = "Sticky Aim"
    stickyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    stickyLabel.TextXAlignment = Enum.TextXAlignment.Left
    stickyLabel.Font = Enum.Font.Gotham
    stickyLabel.TextSize = 12
    stickyLabel.Parent = stickyToggle

    local stickyButton = Instance.new("TextButton")
    stickyButton.Size = UDim2.new(0, 50, 0, 20)
    stickyButton.Position = UDim2.new(1, -50, 0.5, -10)
    stickyButton.BackgroundColor3 = settings.StickyAim and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    stickyButton.Text = settings.StickyAim and "ON" or "OFF"
    stickyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    stickyButton.Font = Enum.Font.Gotham
    stickyButton.TextSize = 12
    stickyButton.Parent = stickyToggle
    Instance.new("UICorner", stickyButton).CornerRadius = UDim.new(0, 4)
    stickyButton.MouseButton1Click:Connect(function()
        settings.StickyAim = not settings.StickyAim
        stickyButton.BackgroundColor3 = settings.StickyAim and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        stickyButton.Text = settings.StickyAim and "ON" or "OFF"
    end)

    local methodDropdown = Instance.new("Frame")
    methodDropdown.Size = UDim2.new(1, 0, 0, 30)
    methodDropdown.Position = UDim2.new(0, 0, 0, 130)
    methodDropdown.BackgroundTransparency = 1
    methodDropdown.Parent = aimbotContent

    local methodLabel = Instance.new("TextLabel")
    methodLabel.Size = UDim2.new(0, 150, 1, 0)
    methodLabel.BackgroundTransparency = 1
    methodLabel.Text = "Aimbot Method: " .. settings.AimbotMethod
    methodLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    methodLabel.TextXAlignment = Enum.TextXAlignment.Left
    methodLabel.Font = Enum.Font.Gotham
    methodLabel.TextSize = 12
    methodLabel.Parent = methodDropdown

    local methodButton = Instance.new("TextButton")
    methodButton.Size = UDim2.new(0, 80, 0, 20)
    methodButton.Position = UDim2.new(1, -80, 0.5, -10)
    methodButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    methodButton.Text = settings.AimbotMethod
    methodButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    methodButton.Font = Enum.Font.Gotham
    methodButton.TextSize = 12
    methodButton.Parent = methodDropdown
    Instance.new("UICorner", methodButton).CornerRadius = UDim.new(0, 4)

    local methodFrame = Instance.new("Frame")
    methodFrame.Size = UDim2.new(0, 80, 0, 60)
    methodFrame.Position = UDim2.new(1, -80, 0.5, 10)
    methodFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    methodFrame.Visible = false
    methodFrame.Parent = methodDropdown
    Instance.new("UIListLayout", methodFrame)

    local methods = {"Camera", "Mouse"}
    for _, method in pairs(methods) do
        local option = Instance.new("TextButton")
        option.Size = UDim2.new(1, 0, 0, 20)
        option.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        option.Text = method
        option.TextColor3 = Color3.fromRGB(255, 255, 255)
        option.Font = Enum.Font.Gotham
        option.TextSize = 12
        option.Parent = methodFrame
        option.MouseButton1Click:Connect(function()
            settings.AimbotMethod = method
            methodButton.Text = method
            methodLabel.Text = "Aimbot Method: " .. method
            methodFrame.Visible = false
        end)
    end
    methodButton.MouseButton1Click:Connect(function() methodFrame.Visible = not methodFrame.Visible end)

    local wallToggle = Instance.new("Frame")
    wallToggle.Size = UDim2.new(1, 0, 0, 30)
    wallToggle.Position = UDim2.new(0, 0, 0, 160)
    wallToggle.BackgroundTransparency = 1
    wallToggle.Parent = aimbotContent

    local wallLabel = Instance.new("TextLabel")
    wallLabel.Size = UDim2.new(0, 150, 1, 0)
    wallLabel.BackgroundTransparency = 1
    wallLabel.Text = "Wall Check"
    wallLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    wallLabel.TextXAlignment = Enum.TextXAlignment.Left
    wallLabel.Font = Enum.Font.Gotham
    wallLabel.TextSize = 12
    wallLabel.Parent = wallToggle

    local wallButton = Instance.new("TextButton")
    wallButton.Size = UDim2.new(0, 50, 0, 20)
    wallButton.Position = UDim2.new(1, -50, 0.5, -10)
    wallButton.BackgroundColor3 = settings.WallCheck and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    wallButton.Text = settings.WallCheck and "ON" or "OFF"
    wallButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    wallButton.Font = Enum.Font.Gotham
    wallButton.TextSize = 12
    wallButton.Parent = wallToggle
    Instance.new("UICorner", wallButton).CornerRadius = UDim.new(0, 4)
    wallButton.MouseButton1Click:Connect(function()
        settings.WallCheck = not settings.WallCheck
        wallButton.BackgroundColor3 = settings.WallCheck and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        wallButton.Text = settings.WallCheck and "ON" or "OFF"
    end)

    local smoothnessSlider = Instance.new("Frame")
    smoothnessSlider.Size = UDim2.new(1, 0, 0, 40)
    smoothnessSlider.Position = UDim2.new(0, 0, 0, 190)
    smoothnessSlider.BackgroundTransparency = 1
    smoothnessSlider.Parent = aimbotContent

    local smoothnessLabel = Instance.new("TextLabel")
    smoothnessLabel.Size = UDim2.new(1, 0, 0, 20)
    smoothnessLabel.BackgroundTransparency = 1
    smoothnessLabel.Text = "Smoothness: " .. settings.Smoothness
    smoothnessLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    smoothnessLabel.TextXAlignment = Enum.TextXAlignment.Left
    smoothnessLabel.Font = Enum.Font.Gotham
    smoothnessLabel.TextSize = 12
    smoothnessLabel.Parent = smoothnessSlider

    local smoothnessSliderFrame = Instance.new("Frame")
    smoothnessSliderFrame.Size = UDim2.new(1, 0, 0, 10)
    smoothnessSliderFrame.Position = UDim2.new(0, 0, 0, 25)
    smoothnessSliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    smoothnessSliderFrame.Parent = smoothnessSlider
    Instance.new("UICorner", smoothnessSliderFrame).CornerRadius = UDim.new(1, 0)

    local smoothnessSliderFill = Instance.new("Frame")
    smoothnessSliderFill.Size = UDim2.new(settings.Smoothness, 0, 1, 0)
    smoothnessSliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    smoothnessSliderFill.Parent = smoothnessSliderFrame
    Instance.new("UICorner", smoothnessSliderFill).CornerRadius = UDim.new(1, 0)

    local smoothnessSliderButton = Instance.new("TextButton")
    smoothnessSliderButton.Size = UDim2.new(0, 20, 0, 20)
    smoothnessSliderButton.Position = UDim2.new(settings.Smoothness, -10, 0.5, -10)
    smoothnessSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    smoothnessSliderButton.Text = ""
    smoothnessSliderButton.Parent = smoothnessSliderFrame
    Instance.new("UICorner", smoothnessSliderButton).CornerRadius = UDim.new(1, 0)

    local function updateSmoothness(value)
        value = math.clamp(value, 0.1, 1)
        settings.Smoothness = value
        smoothnessLabel.Text = "Smoothness: " .. string.format("%.1f", value)
        smoothnessSliderFill.Size = UDim2.new(value, 0, 1, 0)
        smoothnessSliderButton.Position = UDim2.new(value, -10, 0.5, -10)
    end

    smoothnessSliderButton.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local mouse = UserInputService:GetMouseLocation()
            local sliderPos = smoothnessSliderFrame.AbsolutePosition
            local sliderSize = smoothnessSliderFrame.AbsoluteSize
            local value = (mouse.X - sliderPos.X) / sliderSize.X
            updateSmoothness(value)
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then connection:Disconnect() end
        end)
    end)

    local espToggle = Instance.new("Frame")
    espToggle.Size = UDim2.new(1, 0, 0, 30)
    espToggle.BackgroundTransparency = 1
    espToggle.Parent = espContent

    local espLabel = Instance.new("TextLabel")
    espLabel.Size = UDim2.new(0, 150, 1, 0)
    espLabel.BackgroundTransparency = 1
    espLabel.Text = "ESP Enabled"
    espLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    espLabel.TextXAlignment = Enum.TextXAlignment.Left
    espLabel.Font = Enum.Font.Gotham
    espLabel.TextSize = 12
    espLabel.Parent = espToggle

    local espButton = Instance.new("TextButton")
    espButton.Size = UDim2.new(0, 50, 0, 20)
    espButton.Position = UDim2.new(1, -50, 0.5, -10)
    espButton.BackgroundColor3 = settings.ESPEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    espButton.Text = settings.ESPEnabled and "ON" or "OFF"
    espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    espButton.Font = Enum.Font.Gotham
    espButton.TextSize = 12
    espButton.Parent = espToggle
    Instance.new("UICorner", espButton).CornerRadius = UDim.new(0, 4)
    espButton.MouseButton1Click:Connect(function()
        settings.ESPEnabled = not settings.ESPEnabled
        espButton.BackgroundColor3 = settings.ESPEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        espButton.Text = settings.ESPEnabled and "ON" or "OFF"
        updateESP()
    end)

    local chamColorDropdown = Instance.new("Frame")
    chamColorDropdown.Size = UDim2.new(1, 0, 0, 30)
    chamColorDropdown.Position = UDim2.new(0, 0, 0, 30)
    chamColorDropdown.BackgroundTransparency = 1
    chamColorDropdown.Parent = espContent

    local chamColorLabel = Instance.new("TextLabel")
    chamColorLabel.Size = UDim2.new(0, 150, 1, 0)
    chamColorLabel.BackgroundTransparency = 1
    chamColorLabel.Text = "Cham Color"
    chamColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    chamColorLabel.TextXAlignment = Enum.TextXAlignment.Left
    chamColorLabel.Font = Enum.Font.Gotham
    chamColorLabel.TextSize = 12
    chamColorLabel.Parent = chamColorDropdown

    local chamColorButton = Instance.new("TextButton")
    chamColorButton.Size = UDim2.new(0, 80, 0, 20)
    chamColorButton.Position = UDim2.new(1, -80, 0.5, -10)
    chamColorButton.BackgroundColor3 = settings.ChamColor
    chamColorButton.Text = ""
    chamColorButton.Parent = chamColorDropdown
    Instance.new("UICorner", chamColorButton).CornerRadius = UDim.new(0, 4)

    local chamColorFrame = Instance.new("Frame")
    chamColorFrame.Size = UDim2.new(0, 80, 0, 80)
    chamColorFrame.Position = UDim2.new(1, -80, 0.5, 10)
    chamColorFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    chamColorFrame.Visible = false
    chamColorFrame.Parent = chamColorDropdown
    Instance.new("UIListLayout", chamColorFrame)

    local colors = {
        {Name = "Green", Color = Color3.fromRGB(0, 255, 0)},
        {Name = "Red", Color = Color3.fromRGB(255, 0, 0)},
        {Name = "Blue", Color = Color3.fromRGB(0, 0, 255)},
        {Name = "Yellow", Color = Color3.fromRGB(255, 255, 0)}
    }
    for _, color in pairs(colors) do
        local option = Instance.new("TextButton")
        option.Size = UDim2.new(1, 0, 0, 20)
        option.BackgroundColor3 = color.Color
        option.Text = color.Name
        option.TextColor3 = Color3.fromRGB(255, 255, 255)
        option.Font = Enum.Font.Gotham
        option.TextSize = 12
        option.Parent = chamColorFrame
        option.MouseButton1Click:Connect(function()
            settings.ChamColor = color.Color
            chamColorButton.BackgroundColor3 = color.Color
            chamColorFrame.Visible = false
            updateESP()
        end)
    end
    chamColorButton.MouseButton1Click:Connect(function() chamColorFrame.Visible = not chamColorFrame.Visible end)

    local cameraFOVSlider = Instance.new("Frame")
    cameraFOVSlider.Size = UDim2.new(1, 0, 0, 40)
    cameraFOVSlider.Position = UDim2.new(0, 0, 0, 0)
    cameraFOVSlider.BackgroundTransparency = 1
    cameraFOVSlider.Parent = otherContent

    local cameraFOVLabel = Instance.new("TextLabel")
    cameraFOVLabel.Size = UDim2.new(1, 0, 0, 20)
    cameraFOVLabel.BackgroundTransparency = 1
    cameraFOVLabel.Text = "Camera FOV: " .. math.floor(settings.CameraFOV)
    cameraFOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    cameraFOVLabel.TextXAlignment = Enum.TextXAlignment.Left
    cameraFOVLabel.Font = Enum.Font.Gotham
    cameraFOVLabel.TextSize = 12
    cameraFOVLabel.Parent = cameraFOVSlider

    local cameraFOVSliderFrame = Instance.new("Frame")
    cameraFOVSliderFrame.Size = UDim2.new(1, 0, 0, 10)
    cameraFOVSliderFrame.Position = UDim2.new(0, 0, 0, 25)
    cameraFOVSliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    cameraFOVSliderFrame.Parent = cameraFOVSlider
    Instance.new("UICorner", cameraFOVSliderFrame).CornerRadius = UDim.new(1, 0)

    local cameraFOVSliderFill = Instance.new("Frame")
    cameraFOVSliderFill.Size = UDim2.new((settings.CameraFOV - 30) / 90, 0, 1, 0)
    cameraFOVSliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    cameraFOVSliderFill.Parent = cameraFOVSliderFrame
    Instance.new("UICorner", cameraFOVSliderFill).CornerRadius = UDim.new(1, 0)

    local cameraFOVSliderButton = Instance.new("TextButton")
    cameraFOVSliderButton.Size = UDim2.new(0, 20, 0, 20)
    cameraFOVSliderButton.Position = UDim2.new((settings.CameraFOV - 30) / 90, -10, 0.5, -10)
    cameraFOVSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    cameraFOVSliderButton.Text = ""
    cameraFOVSliderButton.Parent = cameraFOVSliderFrame
    Instance.new("UICorner", cameraFOVSliderButton).CornerRadius = UDim.new(1, 0)

    local function updateCameraFOV(value)
        value = math.clamp(value, 30, 120)
        settings.CameraFOV = value
        Camera.FieldOfView = value
        cameraFOVLabel.Text = "Camera FOV: " .. math.floor(value)
        cameraFOVSliderFill.Size = UDim2.new((value - 30) / 90, 0, 1, 0)
        cameraFOVSliderButton.Position = UDim2.new((value - 30) / 90, -10, 0.5, -10)
    end

    cameraFOVSliderButton.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local mouse = UserInputService:GetMouseLocation()
            local sliderPos = cameraFOVSliderFrame.AbsolutePosition
            local sliderSize = cameraFOVSliderFrame.AbsoluteSize
            local value = ((mouse.X - sliderPos.X) / sliderSize.X) * 90 + 30
            updateCameraFOV(value)
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then connection:Disconnect() end
        end)
    end)

    local walkspeedSlider = Instance.new("Frame")
    walkspeedSlider.Size = UDim2.new(1, 0, 0, 40)
    walkspeedSlider.Position = UDim2.new(0, 0, 0, 40)
    walkspeedSlider.BackgroundTransparency = 1
    walkspeedSlider.Parent = otherContent

    local walkspeedLabel = Instance.new("TextLabel")
    walkspeedLabel.Size = UDim2.new(1, 0, 0, 20)
    walkspeedLabel.BackgroundTransparency = 1
    walkspeedLabel.Text = "Walkspeed: " .. settings.Walkspeed
    walkspeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    walkspeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    walkspeedLabel.Font = Enum.Font.Gotham
    walkspeedLabel.TextSize = 12
    walkspeedLabel.Parent = walkspeedSlider

    local walkspeedSliderFrame = Instance.new("Frame")
    walkspeedSliderFrame.Size = UDim2.new(1, 0, 0, 10)
    walkspeedSliderFrame.Position = UDim2.new(0, 0, 0, 25)
    walkspeedSliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    walkspeedSliderFrame.Parent = walkspeedSlider
    Instance.new("UICorner", walkspeedSliderFrame).CornerRadius = UDim.new(1, 0)

    local walkspeedSliderFill = Instance.new("Frame")
    walkspeedSliderFill.Size = UDim2.new((settings.Walkspeed - 16) / 84, 0, 1, 0)
    walkspeedSliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    walkspeedSliderFill.Parent = walkspeedSliderFrame
    Instance.new("UICorner", walkspeedSliderFill).CornerRadius = UDim.new(1, 0)

    local walkspeedSliderButton = Instance.new("TextButton")
    walkspeedSliderButton.Size = UDim2.new(0, 20, 0, 20)
    walkspeedSliderButton.Position = UDim2.new((settings.Walkspeed - 16) / 84, -10, 0.5, -10)
    walkspeedSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    walkspeedSliderButton.Text = ""
    walkspeedSliderButton.Parent = walkspeedSliderFrame
    Instance.new("UICorner", walkspeedSliderButton).CornerRadius = UDim.new(1, 0)

    local function updateWalkspeed(value)
        value = math.clamp(value, 16, 100)
        settings.Walkspeed = value
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.WalkSpeed = value
        end
        walkspeedLabel.Text = "Walkspeed: " .. math.floor(value)
        walkspeedSliderFill.Size = UDim2.new((value - 16) / 84, 0, 1, 0)
        walkspeedSliderButton.Position = UDim2.new((value - 16) / 84, -10, 0.5, -10)
    end

    walkspeedSliderButton.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local mouse = UserInputService:GetMouseLocation()
            local sliderPos = walkspeedSliderFrame.AbsolutePosition
            local sliderSize = walkspeedSliderFrame.AbsoluteSize
            local value = ((mouse.X - sliderPos.X) / sliderSize.X) * 84 + 16
            updateWalkspeed(value)
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then connection:Disconnect() end
        end)
    end)

    local jumppowerSlider = Instance.new("Frame")
    jumppowerSlider.Size = UDim2.new(1, 0, 0, 40)
    jumppowerSlider.Position = UDim2.new(0, 0, 0, 80)
    jumppowerSlider.BackgroundTransparency = 1
    jumppowerSlider.Parent = otherContent

    local jumppowerLabel = Instance.new("TextLabel")
    jumppowerLabel.Size = UDim2.new(1, 0, 0, 20)
    jumppowerLabel.BackgroundTransparency = 1
    jumppowerLabel.Text = "Jumppower: " .. settings.Jumppower
    jumppowerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumppowerLabel.TextXAlignment = Enum.TextXAlignment.Left
    jumppowerLabel.Font = Enum.Font.Gotham
    jumppowerLabel.TextSize = 12
    jumppowerLabel.Parent = jumppowerSlider

    local jumppowerSliderFrame = Instance.new("Frame")
    jumppowerSliderFrame.Size = UDim2.new(1, 0, 0, 10)
    jumppowerSliderFrame.Position = UDim2.new(0, 0, 0, 25)
    jumppowerSliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    jumppowerSliderFrame.Parent = jumppowerSlider
    Instance.new("UICorner", jumppowerSliderFrame).CornerRadius = UDim.new(1, 0)

    local jumppowerSliderFill = Instance.new("Frame")
    jumppowerSliderFill.Size = UDim2.new((settings.Jumppower - 50) / 150, 0, 1, 0)
    jumppowerSliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    jumppowerSliderFill.Parent = jumppowerSliderFrame
    Instance.new("UICorner", jumppowerSliderFill).CornerRadius = UDim.new(1, 0)

    local jumppowerSliderButton = Instance.new("TextButton")
    jumppowerSliderButton.Size = UDim2.new(0, 20, 0, 20)
    jumppowerSliderButton.Position = UDim2.new((settings.Jumppower - 50) / 150, -10, 0.5, -10)
    jumppowerSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    jumppowerSliderButton.Text = ""
    jumppowerSliderButton.Parent = jumppowerSliderFrame
    Instance.new("UICorner", jumppowerSliderButton).CornerRadius = UDim.new(1, 0)

    local function updateJumppower(value)
        value = math.clamp(value, 50, 200)
        settings.Jumppower = value
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.JumpPower = value
        end
        jumppowerLabel.Text = "Jumppower: " .. math.floor(value)
        jumppowerSliderFill.Size = UDim2.new((value - 50) / 150, 0, 1, 0)
        jumppowerSliderButton.Position = UDim2.new((value - 50) / 150, -10, 0.5, -10)
    end

    jumppowerSliderButton.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local mouse = UserInputService:GetMouseLocation()
            local sliderPos = jumppowerSliderFrame.AbsolutePosition
            local sliderSize = jumppowerSliderFrame.AbsoluteSize
            local value = ((mouse.X - sliderPos.X) / sliderSize.X) * 150 + 50
            updateJumppower(value)
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then connection:Disconnect() end
        end)
    end)

    fovCircle = Instance.new("Frame")
    fovCircle.Size = UDim2.new(0, settings.FOVRadius * 2, 0, settings.FOVRadius * 2)
    fovCircle.Position = UDim2.new(0.5, -settings.FOVRadius, 0.5, -settings.FOVRadius)
    fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    fovCircle.BackgroundTransparency = 1
    fovCircle.Visible = settings.ShowFOV
    fovCircle.Parent = screenGui
    Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
    local circleOutline = Instance.new("UIStroke")
    circleOutline.Color = settings.FOVColor
    circleOutline.Transparency = settings.FOVTransparency
    circleOutline.Thickness = settings.FOVThickness
    circleOutline.Parent = fovCircle
end

-- Chams Functions
local function applyChams(zombie)
    if chams[zombie] or not zombie:IsA("Model") or not zombie:FindFirstChild("Head") then return end
    local highlight = Instance.new("Highlight")
    highlight.Adornee = zombie
    highlight.FillTransparency = 1
    highlight.OutlineColor = settings.ChamColor
    highlight.OutlineTransparency = settings.ChamTransparency
    highlight.Parent = zombie
    chams[zombie] = highlight
end

local function removeChams(zombie)
    if chams[zombie] then
        chams[zombie]:Destroy()
        chams[zombie] = nil
    end
end

local function updateESP()
    local zombiesFolder = game.Workspace:FindFirstChild("Zombies")
    if not zombiesFolder then return end
    for _, zombie in pairs(zombiesFolder:GetChildren()) do
        if zombie:IsA("Model") and zombie:FindFirstChild("Head") then
            if settings.ESPEnabled then
                applyChams(zombie)
                if chams[zombie] then
                    chams[zombie].OutlineColor = settings.ChamColor
                    chams[zombie].OutlineTransparency = settings.ChamTransparency
                end
            else
                removeChams(zombie)
            end
        end
    end
end

local function monitorZombies()
    local zombiesFolder = game.Workspace:FindFirstChild("Zombies")
    if not zombiesFolder then return end
    zombiesFolder.ChildAdded:Connect(function(zombie)
        if settings.ESPEnabled and zombie:IsA("Model") and zombie:FindFirstChild("Head") then
            applyChams(zombie)
        end
    end)
    zombiesFolder.ChildRemoved:Connect(function(zombie)
        removeChams(zombie)
    end)
end

-- Aimbot Functions
local function isInFOV(screenPosition)
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local distance = (screenPosition - center).Magnitude
    return distance <= settings.FOVRadius
end

local function wallCheck(startPos, endPos)
    if not settings.WallCheck then return true end
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {localPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local raycastResult = workspace:Raycast(startPos, (endPos - startPos).Unit * (endPos - startPos).Magnitude, raycastParams)
    if raycastResult then
        local hitPart = raycastResult.Instance
        local model = hitPart:FindFirstAncestorOfClass("Model")
        return model and model:FindFirstChild("Head")
    end
    return true
end

local function aimAtNearestZombie()
    local character = localPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local closestZombie, closestDistance, closestScreenDistance = nil, math.huge, math.huge
    local zombiesFolder = game.Workspace:FindFirstChild("Zombies")
    if not zombiesFolder then return end
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, zombie in pairs(zombiesFolder:GetChildren()) do
        if zombie:IsA("Model") and zombie:FindFirstChild("Head") then
            local headPos = zombie.Head.Position
            local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
            if onScreen then
                local screenVector = Vector2.new(screenPos.X, screenPos.Y)
                local screenDistance = (screenVector - screenCenter).Magnitude
                if screenDistance <= settings.FOVRadius and wallCheck(character.HumanoidRootPart.Position, headPos) then
                    local distance = (character.HumanoidRootPart.Position - headPos).Magnitude
                    if screenDistance < closestScreenDistance or (screenDistance == closestScreenDistance and distance < closestDistance) then
                        closestDistance = distance
                        closestScreenDistance = screenDistance
                        closestZombie = zombie
                    end
                end
            end
        end
    end
    if closestZombie then
        local targetPosition = closestZombie.Head.Position
        if settings.AimbotMethod == "Camera" then
            if settings.StickyAim then
                local currentCFrame = Camera.CFrame
                local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
                Camera.CFrame = currentCFrame:Lerp(targetCFrame, settings.Smoothness)
            else
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
            end
        elseif settings.AimbotMethod == "Mouse" and mousemoverel then
            local screenPos = Camera:WorldToViewportPoint(targetPosition)
            local mouse = UserInputService:GetMouseLocation()
            local newPos = Vector2.new(screenPos.X, screenPos.Y)
            if settings.StickyAim then
                local delta = (newPos - mouse)
                mousemoverel(delta.X * settings.Smoothness, delta.Y * settings.Smoothness)
            else
                mousemoverel(newPos.X - mouse.X, newPos.Y - mouse.Y)
            end
        end
    end
end

-- Initialize
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == settings.UIKey then screenGui.Enabled = not screenGui.Enabled end
end)

localPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = settings.Walkspeed
    humanoid.JumpPower = settings.Jumppower
end)

RunService.RenderStepped:Connect(function()
    if settings.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        aimAtNearestZombie()
    end
    if settings.ESPEnabled then
        updateESP()
    end
end)

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    if fovCircle then
        fovCircle.Size = UDim2.new(0, settings.FOVRadius * 2, 0, settings.FOVRadius * 2)
        fovCircle.Position = UDim2.new(0.5, -settings.FOVRadius, 0.5, -settings.FOVRadius)
    end
end)

createUI()
monitorZombies()
