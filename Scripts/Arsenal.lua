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
        local fullId = "rbxassetid://" .. assetId
        if obj:IsA("StringValue") then
            obj.Value = fullId
        elseif obj:IsA("Sound") then
            obj.SoundId = fullId
        end
    end
end

local function SetAmbientColor(color)
    game.Lighting.Ambient = color
    game.Lighting.OutdoorAmbient = color
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
    Name = "Gun Mods",
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
            if v:IsA("NumberValue") and v.Name == "ReloadTime" then v.Value = 1 end
            if v:IsA("NumberValue") and v.Name == "FireRate" then v.Value = 0.05 end
            if v:IsA("NumberValue") and v.Name == "Crit" then v.Value = 20 end
            if v:IsA("NumberValue") and v.Name == "Ammo" then v.Value = 999 end
            if v:IsA("NumberValue") and v.Name == "StoredAmmo" then v.Value = 999 end
        end
    end
})

local SoundsSection = MiscTab:CreateSection({ Name = "Sound Effects", Side = "Left" })
local AmbientSection = MiscTab:CreateSection({ Name = "Ambient Lighting", Side = "Right" })

local hitSoundEnabled = false
local currentHitSound = "1129547534"

local hitSoundOptions = {
    {Name = "Tap", Value = "1129547534"},
    {Name = "Black Ops 6", Value = "137166459647708"},
    {Name = "Futuristic", Value = "17724151829"},
    {Name = "Quake", Value = "1455817260"},
    {Name = "Minecraft", Value = "75603051950982"},
    {Name = "Bonk", Value = "5148302439"},
    {Name = "UwU", Value = "8679659744"},
    {Name = "MW2019", Value = "7172056822"}
}

SoundsSection:AddDropdown({
    Name = "Hit Sound",
    Flag = "SoundsSection_HitSound",
    List = hitSoundOptions,
    Value = "Tap",
    Callback = function(Name)
        for _, option in ipairs(hitSoundOptions) do
            if option.Name == Name then
                currentHitSound = option.Value
                if hitSoundEnabled then
                    local obj = game.Players.LocalPlayer.Settings:FindFirstChild("HitSound")
                    SetSoundValue(obj, currentHitSound)
                end
                break
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
            local obj = game.Players.LocalPlayer.Settings:FindFirstChild("HitSound")
            SetSoundValue(obj, currentHitSound)
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
    Format = function(Value)
        return "Hit Volume: " .. tostring(Value)
    end,
    Callback = function(Value)
        local volumeObj = game.Players.LocalPlayer.Settings:FindFirstChild("HitVolume")
        if volumeObj and volumeObj:IsA("NumberValue") then
            volumeObj.Value = Value
        end
    end
})

SoundsSection:AddButton({
    Name = "Test Hit Sound",
    Callback = function()
        local obj = game.Players.LocalPlayer.Settings:FindFirstChild("HitSound")
        local volumeObj = game.Players.LocalPlayer.Settings:FindFirstChild("HitVolume")
        PlaySoundFromStringValue(obj, volumeObj)
    end
})

local killSoundEnabled = false
local currentKillSound = "7172055941"

local killSoundOptions = {
    {Name = "MW2019", Value = "7172055941"},
    {Name = "Among Us", Value = "7227567562"},
    {Name = "Bonk", Value = "5148302439"},
    {Name = "Metal Pipe", Value = "72093859793611"}
}

SoundsSection:AddDropdown({
    Name = "Kill Sound",
    Flag = "SoundsSection_KillSound",
    List = killSoundOptions,
    Value = "MW2019",
    Callback = function(Name)
        for _, option in ipairs(killSoundOptions) do
            if option.Name == Name then
                currentKillSound = option.Value
                if killSoundEnabled then
                    local obj = game.Players.LocalPlayer.Settings:FindFirstChild("KillSound")
                    SetSoundValue(obj, currentKillSound)
                end
                break
            end
        end
    end
})

SoundsSection:AddToggle({
    Name = "Enable Kill Sound",
    Flag = "SoundsSection_KillSoundToggle",
    Callback = function(state)
        killSoundEnabled = state
        if killSoundEnabled then
            local obj = game.Players.LocalPlayer.Settings:FindFirstChild("KillSound")
            SetSoundValue(obj, currentKillSound)
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
    Format = function(Value)
        return "Kill Volume: " .. tostring(Value)
    end,
    Callback = function(Value)
        local volumeObj = game.Players.LocalPlayer.Settings:FindFirstChild("KillVolume")
        if volumeObj and volumeObj:IsA("NumberValue") then
            volumeObj.Value = Value
        end
    end
})

SoundsSection:AddButton({
    Name = "Test Kill Sound",
    Callback = function()
        local obj = game.Players.LocalPlayer.Settings:FindFirstChild("KillSound")
        local volumeObj = game.Players.LocalPlayer.Settings:FindFirstChild("KillVolume")
        PlaySoundFromStringValue(obj, volumeObj)
    end
})

local ambientEnabled = false
local currentAmbientColor = Color3.fromRGB(255, 255, 255)

AmbientSection:AddColorPicker({
    Name = "Ambient Color",
    Flag = "AmbientSection_ColorPicker",
    Default = currentAmbientColor,
    Callback = function(color)
        currentAmbientColor = color
        if ambientEnabled then
            SetAmbientColor(currentAmbientColor)
        end
    end
})

AmbientSection:AddToggle({
    Name = "Enable Ambient Lighting",
    Flag = "AmbientSection_EnableToggle",
    Callback = function(state)
        ambientEnabled = state
        if ambientEnabled then
            SetAmbientColor(currentAmbientColor)
        else
            SetAmbientColor(Color3.fromRGB(0, 0, 0))
        end
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Settings = LocalPlayer:WaitForChild("Settings", 5)
local FOVSection = MiscTab:CreateSection({ Name = "Field of View", Side = "Right" })

local defaultFOV = 70
local currentFOV = defaultFOV
local fovEnabled = true

if not Settings then
    warn("LocalPlayer.Settings not found, using Camera.FieldOfView as fallback")
end

FOVSection:AddSlider({
    Name = "World FOV",
    Flag = "FOVSection_WorldFOV",
    Value = defaultFOV,
    Min = 50,
    Max = 120,
    Precise = 1,
    Format = function(Value)
        return "FOV: " .. tostring(Value)
    end,
    Callback = function(Value)
        currentFOV = Value
        fovEnabled = true
        local fovObj = Settings and Settings:FindFirstChild("FOV")
        if fovObj then
            fovObj.Value = Value
        elseif game.Workspace.CurrentCamera then
            game.Workspace.CurrentCamera.FieldOfView = Value
        end
    end
})

FOVSection:AddButton({
    Name = "Reset FOV",
    Callback = function()
        currentFOV = defaultFOV
        fovEnabled = false
        local fovObj = Settings and Settings:FindFirstChild("FOV")
        if fovObj then
            fovObj.Value = defaultFOV
        elseif game.Workspace.CurrentCamera then
            game.Workspace.CurrentCamera.FieldOfView = defaultFOV
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

local SettingsTab = SkidsWorld:CreateTab({ Name = "UI Settings" })
local MenuSection = SettingsTab:CreateSection({ Name = "Menu", Side = "Left" })

MenuSection:AddButton({
    Name = "Unload GUI",
    Callback = function()
        library:Unload()
    end
})

MenuSection:AddKeybind({
    Name = "Menu Toggle",
    Flag = "MenuSection_MenuKeybind",
    Default = Enum.KeyCode.End,
    Mode = "Toggle",
    Callback = function()
        library:Toggle()
    end
})

MenuSection:AddDropdown({
    Name = "Theme",
    Flag = "MenuSection_Theme",
    List = {"Default", "Dark", "Light"},
    Value = "Default",
    Callback = function(value)
        if library.SetTheme then
            library:SetTheme(value:lower())
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
        else
            warn("Config saving not supported by this library version")
        end
    end
})
