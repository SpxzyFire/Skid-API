local library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()
local Wait = library.subs.Wait

local SkidsWorld = library:CreateWindow({
    Name = "Skid Softworks - Arsenal",
    Themeable = {
        Info = "Skid Softworks Arsenal GUI"
    }
})

local function SetSoundValue(obj, assetId)
    if obj and assetId then
        local fullId = "rbxassetid://" .. tostring(assetId)
        if obj:IsA("StringValue") then
            obj.Value = fullId
        elseif obj:IsA("Sound") then
            obj.SoundId = fullId
        end
    end
end

local function SetAmbientColor(color)
    local lighting = game:GetService("Lighting")
    lighting.Ambient = color
    lighting.OutdoorAmbient = color
end

local function PlaySoundFromStringValue(strValue, volumeObj)
    if not strValue or not strValue:IsA("StringValue") or not volumeObj or not volumeObj:IsA("NumberValue") then return end
    local soundId = strValue.Value
    if soundId == "" then return end

    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = volumeObj.Value
    sound.Parent = workspace
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

local MiscTab = SkidsWorld:CreateTab({ Name = "Misc" })

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GunModSection = MiscTab:CreateSection({ Name = "Gun Mods", Side = "Right" })

GunModSection:AddButton({
    Name = "Apply Gun Mods",
    Callback = function()
        local weapons = ReplicatedStorage:FindFirstChild("Weapons")
        if not weapons then
            warn("Weapons folder not found in ReplicatedStorage")
            return
        end
        for _, v in pairs(weapons:GetDescendants()) do
            if v:IsA("BoolValue") and v.Name == "Auto" then v.Value = true end
            if v:IsA("NumberValue") and v.Name == "RecoilControl" then v.Value = 0 end
            if v:IsA("NumberValue") and v.Name == "MaxSpread" then v.Value = 0 end
            if v:IsA("NumberValue") and v.Name == "ReloadTime" then v.Value = 0.5 end
            if v:IsA("NumberValue") and v.Name == "FireRate" then v.Value = 0.05 end
            if v:IsA("NumberValue") and v.Name == "Crit" then v.Value = 20 end
            if v:IsA("NumberValue") and v.Name == "Ammo" then v.Value = 999 end
            if v:IsA("NumberValue") and v.Name == "StoredAmmo" then v.Value = 999 end
        end
        print("Gun mods applied successfully")
    end
})

local SoundsSection = MiscTab:CreateSection({ Name = "Sound Effects", Side = "Left" })
local AmbientSection = MiscTab:CreateSection({ Name = "Ambient Lighting", Side = "Right" })

local SoundsSection = MiscTab:CreateSection({ Name = "Sound Effects", Side = "Left" })

local hitSoundEnabled = false
local currentHitSound = "1129547534"

SoundsSection:AddDropdown({
    Name = "Hit Sound",
    Flag = "SoundsSection_HitSound",
    List = {"Tap", "BO6", "Futuristic", "Quake", "UwU", "MW2019", "TF2"},
    Value = "Tap",
    Callback = function(selected)
        local hitSoundMap = {
            ["Tap"] = "1129547534",
            ["BO6"] = "137166459647708",
            ["Futuristic"] = "17724151829",
            ["Quake"] = "1455817260",
            ["UwU"] = "8679659744",
            ["MW2019"] = "7172056822",
            ["TF2"] = "6909318500"
        }
        currentHitSound = hitSoundMap[selected] or "1129547534" -- Default to "Tap" if not found
        if hitSoundEnabled then
            local settings = game:GetService("Players").LocalPlayer:FindFirstChild("Settings")
            local obj = settings and settings:FindFirstChild("HitSound")
            if obj then
                SetSoundValue(obj, currentHitSound)
                print("HitSound updated to:", currentHitSound) -- Debug print
            else
                warn("HitSound object not found")
            end
        end
    end
})

SoundsSection:AddToggle({
    Name = "Enable Hit Sound",
    Flag = "SoundsSection_HitSoundToggle",
    Callback = function(state)
        hitSoundEnabled = state
        if hitSoundEnabled then
            local settings = game:GetService("Players").LocalPlayer:FindFirstChild("Settings")
            local obj = settings and settings:FindFirstChild("HitSound")
            if obj then
                SetSoundValue(obj, currentHitSound)
                print("HitSound enabled with:", currentHitSound) -- Debug print
            else
                warn("HitSound not found")
            end
        end
    end
})

SoundsSection:AddSlider({
    Name = "Hit Volume",
    Flag = "SoundsSection_HitVolume",
    Value = 1,
    Min = 0.1,
    Max = 10,
    Precise = 2,
    Format = function(Value) return "Hit Volume: " .. tostring(Value) end,
    Callback = function(Value)
        local settings = game:GetService("Players").LocalPlayer:FindFirstChild("Settings")
        local volumeObj = settings and settings:FindFirstChild("HitVolume")
        if volumeObj and volumeObj:IsA("NumberValue") then volumeObj.Value = Value end
    end
})

SoundsSection:AddButton({
    Name = "Test Hit Sound",
    Callback = function()
        local settings = game:GetService("Players").LocalPlayer:FindFirstChild("Settings")
        local obj = settings and settings:FindFirstChild("HitSound")
        local volumeObj = settings and settings:FindFirstChild("HitVolume")
        if obj and volumeObj then
            PlaySoundFromStringValue(obj, volumeObj)
            print("Testing hit sound with ID:", currentHitSound) -- Debug print
        else
            warn("Cannot test hit sound: Settings or objects not found")
        end
    end
})


local killSoundEnabled = false
local currentKillSound = "7172055941"

SoundsSection:AddDropdown({
    Name = "Kill Sound",
    Flag = "SoundsSection_KillSound",
    List = {"MW2019", "Among Us", "Bonk", "Metal Pipe", "Laser Gun"},
    Value = "MW2019",
    Callback = function(selected)
        local killSoundMap = {
            ["MW2019"] = "7172055941",
            ["Among Us"] = "7227567562",
            ["Bonk"] = "5148302439",
            ["Metal Pipe"] = "6729922069",
            ["Laser Gun"] = "8561505457"
        }
        currentKillSound = killSoundMap[selected] or "7172055941" -- Default to "MW2019" if not found
        if killSoundEnabled then
            local settings = game:GetService("Players").LocalPlayer:FindFirstChild("Settings")
            local obj = settings and settings:FindFirstChild("KillSound")
            if obj then SetSoundValue(obj, currentKillSound) end
        end
    end
})

SoundsSection:AddToggle({
    Name = "Enable Kill Sound",
    Flag = "SoundsSection_KillSoundToggle",
    Callback = function(state)
        killSoundEnabled = state
        if killSoundEnabled then
            local settings = game:GetService("Players").LocalPlayer:FindFirstChild("Settings")
            local obj = settings and settings:FindFirstChild("KillSound")
            if obj then SetSoundValue(obj, currentKillSound) else warn("KillSound not found") end
        end
    end
})

SoundsSection:AddSlider({
    Name = "Kill Volume",
    Flag = "SoundsSection_KillVolume",
    Value = 1,
    Min = 0.1,
    Max = 10,
    Precise = 2,
    Format = function(Value) return "Kill Volume: " .. tostring(Value) end,
    Callback = function(Value)
        local settings = game:GetService("Players").LocalPlayer:FindFirstChild("Settings")
        local volumeObj = settings and settings:FindFirstChild("KillVolume")
        if volumeObj and volumeObj:IsA("NumberValue") then volumeObj.Value = Value end
    end
})

SoundsSection:AddButton({
    Name = "Test Kill Sound",
    Callback = function()
        local settings = game:GetService("Players").LocalPlayer:FindFirstChild("Settings")
        local obj = settings and settings:FindFirstChild("KillSound")
        local volumeObj = settings and settings:FindFirstChild("KillVolume")
        if obj and volumeObj then PlaySoundFromStringValue(obj, volumeObj)
        else warn("Cannot test kill sound: Settings or objects not found") end
    end
})
local ambientEnabled = false
local currentAmbientColor = Color3.fromRGB(255, 255, 255)

AmbientSection:AddColorpicker({
    Name = "Ambient Color",
    Flag = "AmbientSection_ColorPicker",
    Value = currentAmbientColor,
    Callback = function(color)
        currentAmbientColor = color
        if ambientEnabled then SetAmbientColor(currentAmbientColor) end
    end
})

AmbientSection:AddToggle({
    Name = "Enable Ambient Lighting",
    Flag = "AmbientSection_EnableToggle",
    Callback = function(state)
        ambientEnabled = state
        if ambientEnabled then SetAmbientColor(currentAmbientColor)
        else SetAmbientColor(Color3.fromRGB(0, 255, 255)) end
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Settings = LocalPlayer:FindFirstChild("Settings")
local FOVSection = MiscTab:CreateSection({ Name = "Field of View", Side = "Right" })

local defaultFOV = 70
local currentFOV = defaultFOV
local fovEnabled = false

if not Settings then warn("LocalPlayer.Settings not found, using Camera.FieldOfView as fallback") end

FOVSection:AddSlider({
    Name = "World FOV",
    Flag = "FOVSection_WorldFOV",
    Value = defaultFOV,
    Min = 50,
    Max = 120,
    Precise = 1,
    Format = function(Value) return "FOV: " .. tostring(Value) end,
    Callback = function(Value)
        currentFOV = Value
        fovEnabled = true
        local fovObj = Settings and Settings:FindFirstChild("FOV")
        if fovObj then fovObj.Value = Value
        elseif game.Workspace.CurrentCamera then game.Workspace.CurrentCamera.FieldOfView = Value end
    end
})

FOVSection:AddButton({
    Name = "Reset FOV",
    Callback = function()
        currentFOV = defaultFOV
        fovEnabled = false
        local fovObj = Settings and Settings:FindFirstChild("FOV")
        if fovObj then fovObj.Value = defaultFOV
        elseif game.Workspace.CurrentCamera then game.Workspace.CurrentCamera.FieldOfView = defaultFOV end
    end
})

local ESPTab = SkidsWorld:CreateTab({ Name = "ESP" })

local GlobalSection = ESPTab:CreateSection({ Name = "Global" })
GlobalSection:AddToggle({
    Name = "Enable ESP",
    Flag = "ESP_Enabled",
    Value = false,
    Callback = function() end
})

local BoxSection = ESPTab:CreateSection({ Name = "2D Box" })
BoxSection:AddToggle({ Name = "Enable 2D Box", Flag = "ESP_BoxEnabled", value = true, Callback = function() end })
BoxSection:AddToggle({ Name = "Team Check", Flag = "ESP_BoxTeamCheck", Value = true })
BoxSection:AddColorpicker({ Name = "Color Outline", Flag = "ESP_BoxOutlineColor", Value = Color3.fromRGB(0, 0, 0), Callback = function() end })
BoxSection:AddColorpicker({ Name = "Color Inline", Flag = "ESP_BoxColor", Value = Color3.fromRGB(255, 0, 0), Callback = function() end })

local HealthSection = ESPTab:CreateSection({ Name = "Healthbar" })
HealthSection:AddToggle({ Name = "Enable Healthbar", Flag = "ESP_HealthBarEnabled", Value = true })
HealthSection:AddColorpicker({ Name = "Healthbar Color", Flag = "ESP_HealthBarColor", Value = Color3.fromRGB(0, 255, 0), Callback = function() end })

local TracerSection = ESPTab:CreateSection({ Name = "Tracers" })
TracerSection:AddToggle({ Name = "Enable Tracers", Flag = "ESP_TracerEnabled", Callback = function() end })
TracerSection:AddToggle({ Name = "Team Check", Flag = "ESP_TracerTeamCheck", Value = true })
TracerSection:AddColorpicker({ Name = "Color", Flag = "ESP_TracerColor", Value = Color3.fromRGB(255, 0, 0), Callback = function() end })

local InfoSection = ESPTab:CreateSection({ Name = "Distance ESP" })
InfoSection:AddToggle({ Name = "Show Distance", Flag = "ESP_ShowDistance", Value = true })
InfoSection:AddToggle({ Name = "Show Names", Flag = "ESP_ShowNames", Value = true })
InfoSection:AddColorpicker({ Name = "Color", Flag = "ESP_InfoColor", Value = Color3.fromRGB(255, 255, 255), Callback = function() end })
InfoSection:AddToggle({ Name = "Team Check", Flag = "ESP_InfoTeamCheck", Value = true })

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local ESPObjects = {}

local function CreateESP(player)
    local ESP = {
        Player = player,
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        NameLabel = Drawing.new("Text"),
        DistanceLabel = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthBarOutline = Drawing.new("Square"),
        Tracer = Drawing.new("Line")
    }
    
    ESP.Box.Visible = false
    ESP.Box.Thickness = 1
    ESP.Box.Filled = false
    
    ESP.BoxOutline.Visible = false
    ESP.BoxOutline.Thickness = 2
    ESP.BoxOutline.Filled = false
    
    ESP.NameLabel.Visible = false
    ESP.NameLabel.Size = 14
    ESP.NameLabel.Center = true
    ESP.NameLabel.Outline = true
    
    ESP.DistanceLabel.Visible = false
    ESP.DistanceLabel.Size = 14
    ESP.DistanceLabel.Center = true
    ESP.DistanceLabel.Outline = true
    
    ESP.HealthBar.Visible = false
    ESP.HealthBar.Thickness = 1
    ESP.HealthBar.Filled = true
    
    ESP.HealthBarOutline.Visible = false
    ESP.HealthBarOutline.Thickness = 1
    ESP.HealthBarOutline.Filled = false
    ESP.HealthBarOutline.Color = Color3.fromRGB(0, 0, 0)
    
    ESP.Tracer.Visible = false
    ESP.Tracer.Thickness = 1
    
    ESPObjects[player] = ESP
    return ESP
end

local function RemoveESP(player)
    if ESPObjects[player] then
        for _, drawing in pairs(ESPObjects[player]) do
            if typeof(drawing) == "Drawing" and drawing.Remove then
                drawing:Remove()
            end
        end
        ESPObjects[player] = nil
    end
end

local function UpdateESP()
    if not library.flags.ESP_Enabled then
        for _, ESP in pairs(ESPObjects) do
            ESP.Box.Visible = false
            ESP.BoxOutline.Visible = false
            ESP.NameLabel.Visible = false
            ESP.DistanceLabel.Visible = false
            ESP.HealthBar.Visible = false
            ESP.HealthBarOutline.Visible = false
            ESP.Tracer.Visible = false
        end
        return
    end
    
    local localChar = LocalPlayer.Character
    if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then return end
    
    for player, ESP in pairs(ESPObjects) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
            local char = player.Character
            local rootPart = char.HumanoidRootPart
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local boxSize = Vector2.new(2000 / rootPos.Z, 3000 / rootPos.Z)
                local boxPosition = Vector2.new(rootPos.X - boxSize.X / 2, rootPos.Y - boxSize.Y / 2)
                
                if library.flags.ESP_BoxEnabled then
                    local isTeammate = library.flags.ESP_BoxTeamCheck and player.Team == LocalPlayer.Team
                    if not isTeammate then
                        ESP.Box.Size = boxSize
                        ESP.Box.Position = boxPosition
                        ESP.Box.Color = library.flags.ESP_BoxColor
                        ESP.Box.Visible = true
                        ESP.BoxOutline.Size = boxSize + Vector2.new(2, 2)
                        ESP.BoxOutline.Position = boxPosition - Vector2.new(1, 1)
                        ESP.BoxOutline.Color = library.flags.ESP_BoxOutlineColor
                        ESP.BoxOutline.Visible = true
                    else
                        ESP.Box.Visible = false
                        ESP.BoxOutline.Visible = false
                    end
                else
                    ESP.Box.Visible = false
                    ESP.BoxOutline.Visible = false
                end
                
                if library.flags.ESP_HealthBarEnabled then
                    local isTeammate = library.flags.ESP_BoxTeamCheck and player.Team == LocalPlayer.Team
                    if not isTeammate then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        local barHeight = boxSize.Y * healthPercent
                        ESP.HealthBar.Size = Vector2.new(3, barHeight)
                        ESP.HealthBar.Position = Vector2.new(boxPosition.X - 8, boxPosition.Y + (boxSize.Y - barHeight))
                        ESP.HealthBar.Color = library.flags.ESP_HealthBarColor
                        ESP.HealthBar.Visible = true
                        ESP.HealthBarOutline.Size = Vector2.new(5, boxSize.Y + 2)
                        ESP.HealthBarOutline.Position = Vector2.new(boxPosition.X - 9, boxPosition.Y - 1)
                        ESP.HealthBarOutline.Visible = true
                    else
                        ESP.HealthBar.Visible = false
                        ESP.HealthBarOutline.Visible = false
                    end
                else
                    ESP.HealthBar.Visible = false
                    ESP.HealthBarOutline.Visible = false
                end
                
                if library.flags.ESP_TracerEnabled then
                    local isTeammate = library.flags.ESP_TracerTeamCheck and player.Team == LocalPlayer.Team
                    if not isTeammate then
                        ESP.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        ESP.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                        ESP.Tracer.Color = library.flags.ESP_TracerColor
                        ESP.Tracer.Visible = true
                    else
                        ESP.Tracer.Visible = false
                    end
                else
                    ESP.Tracer.Visible = false
                end
                
                if library.flags.ESP_ShowDistance or library.flags.ESP_ShowNames then
                    local isTeammate = library.flags.ESP_InfoTeamCheck and player.Team == LocalPlayer.Team
                    if not isTeammate then
                        if library.flags.ESP_ShowDistance then
                            local distance = (rootPart.Position - localChar.HumanoidRootPart.Position).Magnitude
                            ESP.DistanceLabel.Text = string.format("%.1f studs", distance)
                            ESP.DistanceLabel.Position = Vector2.new(rootPos.X, boxPosition.Y + boxSize.Y + 5)
                            ESP.DistanceLabel.Color = library.flags.ESP_InfoColor
                            ESP.DistanceLabel.Visible = true
                        else
                            ESP.DistanceLabel.Visible = false
                        end
                        if library.flags.ESP_ShowNames then
                            ESP.NameLabel.Text = player.Name
                            ESP.NameLabel.Position = Vector2.new(rootPos.X, boxPosition.Y - 20)
                            ESP.NameLabel.Color = library.flags.ESP_InfoColor
                            ESP.NameLabel.Visible = true
                        else
                            ESP.NameLabel.Visible = false
                        end
                    else
                        ESP.DistanceLabel.Visible = false
                        ESP.NameLabel.Visible = false
                    end
                else
                    ESP.DistanceLabel.Visible = false
                    ESP.NameLabel.Visible = false
                end
            else
                ESP.Box.Visible = false
                ESP.BoxOutline.Visible = false
                ESP.NameLabel.Visible = false
                ESP.DistanceLabel.Visible = false
                ESP.HealthBar.Visible = false
                ESP.HealthBarOutline.Visible = false
                ESP.Tracer.Visible = false
            end
        end
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then CreateESP(player) end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then CreateESP(player) end
end)

Players.PlayerRemoving:Connect(RemoveESP)

RunService.Heartbeat:Connect(UpdateESP)

library.OnUnload:Connect(function()
    ESPObjects = ESPObjects or {}
    for _, ESP in pairs(ESPObjects) do
        for _, drawing in pairs(ESP) do
            if typeof(drawing) == "Drawing" and drawing.Remove then drawing:Remove() end
        end
    end
    ESPObjects = {}
end)

local SettingsTab = SkidsWorld:CreateTab({ Name = "UI Settings" })
local MenuSection = SettingsTab:CreateSection({ Name = "Menu", Side = "Left" })

MenuSection:AddButton({
    Name = "Unload GUI",
    Callback = function() library:Unload() end
})

MenuSection:AddKeybind({
    Name = "Toggle Menu",
    Flag = "MenuSection_MenuKeybind",
    Default = Enum.KeyCode.End,
    Mode = "Toggle",
    Callback = function() library:Toggle() end
})

MenuSection:AddDropdown({
    Name = "Theme",
    Flag = "MenuSection_Theme",
    List = {"Default", "Dark", "Light"},
    Value = "Default",
    Callback = function(value)
        if library.SetTheme then
            library:SetTheme(value:lower())
            print("Theme set to: " .. value)
        else
            warn("Theme setting not supported by this library version")
        end
    end
})

MenuSection:AddButton({
    Name = "Save Config",
    Callback = function()
        if library.SaveConfig then
            library:SaveConfig()
            print("Config saved successfully")
        else
            warn("Config saving not supported by this library version")
        end
    end
})

game:GetService("RunService").Heartbeat:Connect(function()
    if not Settings then return end
    if hitSoundEnabled then
        local obj = Settings:FindFirstChild("HitSound")
        if obj and obj:IsA("StringValue") and obj.Value ~= "rbxassetid://" .. currentHitSound then
            SetSoundValue(obj, currentHitSound)
        end
    end
    if killSoundEnabled then
        local obj = Settings:FindFirstChild("KillSound")
        if obj and obj:IsA("StringValue") and obj.Value ~= "rbxassetid://" .. currentKillSound then
            SetSoundValue(obj, currentKillSound)
        end
    end
    if ambientEnabled then
        SetAmbientColor(currentAmbientColor)
    end
    if fovEnabled then
        local fovObj = Settings:FindFirstChild("FOV")
        if fovObj and fovObj.Value ~= currentFOV then
            fovObj.Value = currentFOV
        elseif game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.FieldOfView ~= currentFOV then
            game.Workspace.CurrentCamera.FieldOfView = currentFOV
        end
    end
end)
