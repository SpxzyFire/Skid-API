local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()
local win = DiscordLib:Window("SkidAPIXeno - Supported Scripts")
DiscordLib:Notification("Notification", "As of 2025-06-18 | Every Scripts are Keyless and supported by SkidAPIXeno", "Okay!")

local serv = win:Server("Main", "")
local Featured = serv:Channel("Featured")
local arsenal = serv:Channel("Arsenal")
local muscle = serv:Channel("Muscle Legends")
local ninja = serv:Channel("Ninja Legends 1")
local speed = serv:Channel("Legend of Speed")
local prison = serv:Channel("Prison Life")

Featured:Button("Skid Softworks - Zombie Story", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/SpxzyFire/Skid-API/refs/heads/main/Scripts/Zombie%20Story.lua"))()
end)

Featured:Button("Skid Softworks - Arsenal (IN DEV)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/SpxzyFire/Skid-API/refs/heads/main/Scripts/Arsenal.lua"))()
end)

arsenal:Button("Quotos Hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Insertl/QuotasHub/main/BETAv1.3"))()
end)

arsenal:Button("Tbao Hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/thaibao/refs/heads/main/TbaoHubArsenal"))()
end)

ninja:Button("Simple Autofarm", function()
    local Owner = "Zepsyy"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Zepsyy2/asd/main/Ninja%20Legends.lua"))()
end)

ninja:Button("Blank", function()

end)

speed:Button("Vynixius", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Legends%20Of%20Speed/Script.lua"))()
end)


prison:Button("Darkones GUI", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/TheDarkoneMarcillisePex/Other-Scripts/main/Prison%20Life%20GUI'))()
end)

prison:Button("Nexus", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GwnStefano/NexusHub/main/Main", true))()
end)
