local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()
local win = DiscordLib:Window("SkidAPIXeno - Supported Scripts")
DiscordLib:Notification("Notification", "As of 2025-06-18 | Every Scripts are Keyless and supported by SkidAPIXeno", "Okay!")

local serv = win:Server("Main", "")
local Featured = serv:Channel("Featured")
local universal = serv:Channel("Universal")
local arsenal = serv:Channel("Arsenal")
local muscle = serv:Channel("Muscle Legends")
local ninja = serv:Channel("Ninja Legends 1")
local speed = serv:Channel("Legend of Speed")
local prison = serv:Channel("Prison Life")
local rails = serv:Channel("Dead Rails")
local tsgb = serv:Channel("TSBG")
local mm2 = serv:Channel("MM2")

Featured:Button("Skid Softworks - Zombie Story", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/SpxzyFire/Skid-API/refs/heads/main/Scripts/Zombie%20Story.lua"))()
end)

Featured:Button("Skid Softworks - Arsenal | In Dev", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/SpxzyFire/Skid-API/refs/heads/main/Scripts/Arsenal.lua"))()
end)

universal:Button("UNC Test", function()
    loadstring(game:HttpGet("https://github.com/ltseverydayyou/uuuuuuu/blob/main/UNC%20test?raw=true"))()
end)
universal:Button("Executor vuln test", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/aihkw/exe-test/refs/heads/main/executor_vuln_test.lua"))()
end)

arsenal:Button("Quotos Hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Insertl/QuotasHub/main/BETAv1.3"))()
end)

arsenal:Button("Tbao Hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/thaibao/refs/heads/main/TbaoHubArsenal"))()
end)

arsenal:Button("CHEATER.FUN", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/14xXHZQW"))()
end)

muscle:Button("Tokattk", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/2581235867/21/refs/heads/main/By%20Tokattk"))()
end)

muscle:Button("Simple Script", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/rndmq/Serverlist/refs/heads/main/Loader"))()
end)

muscle:Button("Plutonium", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/PawsThePaw/Plutonium.AA/main/Plutonium.Loader.lua", true))()
end)

muscle:Button("Unique Hub", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Unique-Hub-(14-Gmes)_521"))() 
end)

ninja:Button("Simple Autofarm", function()
    local Owner = "Zepsyy"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Zepsyy2/asd/main/Ninja%20Legends.lua"))()
end)

ninja:Button("Apple Hub", function()
    loadstring(game:HttpGet(("https://raw.githubusercontent.com/AppleScript001/Ninjas_Legends/main/README.md"),true))()
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

rails:Button("Simple Script", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/refs/heads/main/DeadRails", true))()
end)

tsgb:Button("Animations", function()
    loadstring(game.HttpGet(game,'https://raw.githubusercontent.com/Mautiku/ehh/main/strong%20guest.lua.txt'))()
end)

mm2:Button("MM2", function()
    loadstring(game.HttpGet(game,'https://raw.githubusercontent.com/Au0yX/Community/main/XhubMM2'))()
end)
