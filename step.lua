-- ============================================================
-- ⚡ STEPCONTROL HUB X KAITUN (FULL SOURCE)
-- VERSION: 4.0.0 | PINK THEME | AUTO START
-- ============================================================

Config = {
    Team = "Pirates",
    Configuration = {
        HopWhenIdle = true,
        AutoHop = true,
        AutoHopDelay = 60 * 60,
        FpsBoost = false,
        blackscreen = false,
        LowGraphics = true
    },
    Items = {
        AutoFullyMelees = true,
        Saber = true,
        CursedDualKatana = true,
        SoulGuitar = true,
        RaceV2 = true
    },
    Settings = {
        StayInSea2UntilHaveDarkFragments = true
    },
    AutoSea2 = true,
    AutoSea3 = true,
    AutoRaidIce_TargetFragments = 5000
}

-- ตั้งค่าให้เริ่มฟาร์มอัตโนมัติทันที (ไม่ต้องกดปุ่ม)
_G.KaitunEnabled = true
_G.Stop = false

-- ฟังก์ชัน Dummy (กัน Error nil)
function alert(...) print("[Alert]", ...) end
function SetText(...) end 

-- สร้าง Storage ไว้ก่อน (กัน Error nil)
Storage = {
    Data = {},
    Get = function(self, key) return self.Data[key] end,
    Set = function(self, key, val) self.Data[key] = val end,
    Save = function() end
}

print("[StepControl] Script loaded, waiting for game load...")
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer

print("[Main] Starting StepControl Kaitun v4.0...")
timeee = os.time()
local W_angle = 30
local lastChange = tick()

_G.ChooseWP = "Melee"
_G.SelectWeapon = nil

function hoangtuveu()
    local W = {Instances = {}}
    repeat task.wait() until game.CoreGui

    OldSessionTime = isfile and readfile and isfile('.tdif-' .. game.Players.LocalPlayer.Name) and tonumber(readfile(".tdif-" .. game.Players.LocalPlayer.Name)) or 0
    repeat
        task.wait()
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", Config.Team)
    until game.Players.LocalPlayer.Character
    print("team assembled")

    repeat wait() until game.Players.LocalPlayer.Character
    spawn(function()
        pcall(function()
            local plr = game:GetService("Players").LocalPlayer
            if plr and plr:FindFirstChild("PlayerScripts") then
                local scripts = plr.PlayerScripts
                local lod1 = scripts:FindFirstChild('NewIslandLOD')
                if lod1 then lod1:Destroy() end
                local lod2 = scripts:FindFirstChild('IslandLOD')
                if lod2 then lod2:Destroy() end
            end
        end)
    end)

    print('wait 1', 'ok')
    local J = {'RawConstants', "Utilly", "QuestManager", 'SpawnRegionLoader', 'TweenController', "AttackController", 'CombatController', 'FunctionsHandler', "Hooks", "Debug", "Hop", "Storage"}
    StartTick = tick()

    print('load 2')
    print('Initializing Script...')
    local J = "Rua_Hub/Blox_Fruit/Assets/"
    ScriptStorage = {IsInitalized = false, PlayerData = {}, Melees = {}, CurrentMeleeData = {}, Enemies = {}, Tools = {}, Backpack = {}, IgnoreStoreFruits = {}, Connections = {LocalPlayer = {}}, Task = {}, Tracebacks = {}, TaskController = {}, TracebackUpdater = {}, Interface = W, NPCs = {}, Map = {}}
    Players = game.Players
    LocalPlayer = Players.LocalPlayer
    Character = Players.LocalPlayer.Character
    Humanoid = Character:WaitForChild('Humanoid')
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    PlayerGui = LocalPlayer:WaitForChild('PlayerGui', 10)
    Lighting = game:GetService('Lighting')
    Services = {}
    setmetatable(Services, {__index = function(J, J) return game:GetService(J) end})
    setmetatable(ScriptStorage.Enemies, {__index = function(J, J) return Services.Workspace.Enemies:FindFirstChild(J) or Services.ReplicatedStorage:FindFirstChild(J) end})
    setmetatable(ScriptStorage.Map, {__index = function(J, J) return Services.Workspace.Map:FindFirstChild(J) or Services.Workspace:FindFirstChild(J) end})
    setmetatable(ScriptStorage.Tools, {__index = function(J, J) return LocalPlayer.Character:FindFirstChild(J) or (LocalPlayer:FindFirstChild('Backpack') and LocalPlayer.Backpack:FindFirstChild(J)) end})
    setmetatable(ScriptStorage.NPCs, {__index = function(J, J) if not J then return end; return workspace.NPCs:FindFirstChild(J) or game.ReplicatedStorage.NPCs:FindFirstChild(J) end})
    function CreateTraceback(J, W) table.insert(ScriptStorage.Tracebacks, (GetCurrentDateTime() .. ' ( ' .. DispTime(os.time() - os.time(), true) .. ' ) after execution | ' .. J .. " | " .. W)) end
    function Report(message)
        pcall(function()
            print("[Kaitun Report]", tostring(message))
            CreateTraceback("Report", tostring(message))
        end)
    end
    function SetTask(J, W)
        if ScriptStorage.Task[J] == W then return end
        local a = {MainTask = "Task1", SubTask = 'Task2'}
        if a[J] then if SetText then SetText(a[J], J .. ' : ' .. W) end end
        ScriptStorage.Task[J] = W
        ScriptStorage.Task[J .. '-d'] = os.time()
    end

    Remotes = {}
    BindedMeleeNPCNames = {BlackLeg = 'Dark Step Teacher', Electro = "Mad Scientist", FishmanKarate = "Water Kung-fu Teacher", DeathStep = "Phoeyu, the Reformed", SharkmanKarate = 'Sharkman Teacher', DragonTalon = "Uzoth", ElectricClaw = 'Previous Hero', Godhuman = "Ancient Monk"}

    Tasks = {}
    function AwaitUntilPlayerLoaded(W, a)
        repeat task.wait() until W.Character and W.Character:FindFirstChild('Humanoid')
        local hum = W.Character.Humanoid
        repeat task.wait() until hum.Health > 0
    end
    function AddPoint()
        local W = {}
        local a
        for h, h in LocalPlayer.Data.Stats:GetChildren() do
            if h and h:FindFirstChild('Level') then W[h.Name] = h.Level.Value end
        end
        if W.Defense < MaxLevel and (W.Defense < (ScriptStorage.PlayerData.Level / 80) or MaxLevel - W.Melee < 100) then
            a = 'Defense'
        elseif W.Melee < MaxLevel then
            a = "Melee"
        else
            a = 'Sword'
        end
        Remotes.CommF_:InvokeServer("AddPoint", a, 999)
    end
    local W = {Currencies = {Level = "#FF69B4", Beli = "#FF69B4", Fragments = "#FF69B4"}, Races = {}}
    function RefreshPlayerData()
        pcall(function()
            for a, a in LocalPlayer.Data:GetChildren() do 
                pcall(function() ScriptStorage.PlayerData[a.Name] = a.Value end) 
            end
        end)
        local a = ""
        for h, X in ScriptStorage.PlayerData do
            local w = W.Currencies[h]
            if w then a = a .. '<font color="' .. w .. '">' .. h .. "</font>: " .. X .. ' ' end
        end
        if ScriptStorage.Interface then SetText('Currencies', a) end
    end
    function RefreshRace()
        local W, a = Remotes.CommF_:InvokeServer('Alchemist', "1"), Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
        ScriptStorage.PlayerData.RaceLevel = 1
        if LocalPlayer.Character:FindFirstChild("RaceTransformed") then
            ScriptStorage.PlayerData.RaceLevel = 4
        elseif a == -2.0 then
            ScriptStorage.PlayerData.RaceLevel = 3
        elseif W == -2.0 then
            ScriptStorage.PlayerData.RaceLevel = 2
        end
    end
    function RefreshInventory()
        ScriptStorage.Backpack = {}
        local LP = game.Players.LocalPlayer
        local ok, Items = pcall(function() return require(game.ReplicatedStorage.ItemReplicationService)._UserCache[LP.UserId] end)
        if not ok or not Items then
            for W, W in Remotes.CommF_:InvokeServer('getInventory') do ScriptStorage.Backpack[W.Name] = W end
            return
        end
        local Q = Items:GetItems("Quantity")
        local M = Items:GetItems("Mastery")
        local C = require(game.ReplicatedStorage.ItemConfig)
        local W = require(game.ReplicatedStorage.Modules.CombatUtil)
        local mas = {}
        if M then for _, v in pairs(M) do mas[v.ItemId] = v.Value end end
        local function clean(s) return s:gsub(" %[.-%]", "") end
        for _, v in pairs(Q) do
            local id, qt = v.ItemId, v.Value
            local ty, dn = "?", ""
            pcall(function()
                local c = C.match(id):unwrap()
                if c and c.Index then ty = c.Index.IdType; dn = c.Index.DebugLabel end
            end)
            local name = clean(dn)
            if name ~= "" then
                local entry = {Name = name, Count = qt, ItemId = id}
                ScriptStorage.Backpack[name] = entry
                if ty == "Moveset" or ty == "PhysicalMoveset" then
                    local md = mas[id]
                    if md then
                        local wd = W:GetWeaponData(name)
                        if wd then
                            if tostring(wd.WeaponType):find("Sword") then
                                entry.Type = "Sword"
                                entry.Mastery = md
                                entry.MasteryRequirements = {[1] = 350}
                            else
                                ScriptStorage.Melees[name] = md
                            end
                        end
                    end
                end
            end
        end
    end
    function ResearchMoves(W)
        if W and tostring(W) == 'V' then
            if ScriptStorage.Connections.BurstCheck then
                ScriptStorage.Connections.BurstCheck:Disconnect()
                task.wait(1)
            end
            print('[ Debug ] Registering burst', W)
            ScriptStorage.Connections.BurstCheck = W.Cooldown:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                if EnablingBurstDebounce and os.time() - EnablingBurstDebounce < 10 then return end
                local a = W.Cooldown.AbsoluteSize.X
                if a < 3 then
                    EnablingBurstDebounce = os.time()
                    task.wait(5)
                    SendKey('V', 0)
                end
            end)
        end
    end
    function CheckMeleeBurstMove(W)
        if W.Name == "Black Leg" or W.Name == "Death Step" then
            local a = PlayerGui.Main.Skills:WaitForChild(W.Name, 9)
            ResearchMoves(a:WaitForChild("V"))
        end
    end
    function RefreshMelees(W)
        local a = ''
        for h, X in ScriptStorage.Melees do a = a .. h .. ": " .. X .. " " end
        a = a == '' and '[0]' or a
        if W then return a end
        if ScriptStorage.Interface then SetText('Melees', a) end
    end
    function MeleeCheck(W)
        print('Melee check', W)
        if W and typeof(W) == "Instance" and W:IsA("Tool") then
            if W.ToolTip == "Melee" then
                if ScriptStorage.Connections.Melees then ScriptStorage.Connections.Melees:Disconnect() end
                ScriptStorage.CurrentMeleeData.Name = W.Name
                pcall(function() ScriptStorage.Connections.Melees:Destroy() end)
                local lv = W:FindFirstChild("Level")
                if lv then
                    ScriptStorage.Connections.Melees = lv.Changed:Connect(function(a)
                        ScriptStorage.Melees[W.Name] = a
                        RefreshMelees()
                    end)
                    ScriptStorage.Melees[W.Name] = lv.Value
                end
                RefreshMelees()
            elseif string.find(tostring(W), "Fruit") then
                task.spawn(function()
                    if table.find(ScriptStorage.IgnoreStoreFruits, W:GetAttribute('OriginalName')) then return end
                    local a = Remotes.CommF_:InvokeServer("StoreFruit", W:GetAttribute("OriginalName"), W)
                end)
            end
        end
    end
    print('Refreshing Player Data')
    MeleeCheck(LocalPlayer.Character:FindFirstChildOfClass('Tool'))
    RefreshPlayerData()
    function RegisterLocalPlayerEventsConnection()
        task.spawn(function()
            task.wait(6)
            if LocalPlayer.Character:FindFirstChild('HasBuso') then return end
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
        end)
    end
    RegisterLocalPlayerEventsConnection(LocalPlayer)
    game.Players.LocalPlayer.CharacterAdded:Connect(function(W)
        print('[ Debug ] re-registering events')
        RegisterLocalPlayerEventsConnection(LocalPlayer)
    end)
    task.spawn(function()
        task.wait(3)
        if LocalPlayer.Character:FindFirstChild("HasBuso") then return end
        Remotes.CommF_:InvokeServer("Buso")
    end)
    print(1)

    -- ============================================================
    -- MELEE TABLE & DATA
    -- ============================================================
    MeleesTable = {"Black Leg", 'Electro', "Fishman Karate", "Dragon Claw", "Superhuman", 'Death Step', 'Electric Claw', 'Sharkman Karate', 'Dragon Talon', "Godhuman"}
    MeleesId = {'BlackLeg', "Electro", 'FishmanKarate', "DragonClaw", "Superhuman", 'DeathStep', "ElectricClaw", "SharkmanKarate", 'DragonTalon', 'Godhuman'}
    MeleePrices = {["Black Leg"] = {Price = {Beli = 150000}, Id = "BlackLeg", NextLevelRequirement = 300, position = CFrame.new(), Requirements = function() return true end, Buy = function(W) return BuyMelee("BlackLeg", W, 'Dark Step Teacher') end}, ['Electro'] = {Price = {Beli = 500000}, Id = 'Electro', NextLevelRequirement = 300, Requirements = function() return true end, Buy = function(W) return BuyMelee('Electro', W, "Mad Scientist") end}, ['Fishman Karate'] = {Price = {Beli = 750000}, NextLevelRequirement = 300, Requirements = function() return true end, Buy = function(W) return BuyMelee('FishmanKarate', W, 'Water Kung-fu Teacher') end}, ['Dragon Claw'] = {Price = {Fragments = 1500}, NextLevelRequirement = 300, Requirements = function() return true end, Buy = function(W) return BuyMelee("DragonClaw", W, "Sabi") end}, ["Superhuman"] = {Price = {Beli = 3000000}, NextLevelRequirement = nil, Requirements = function() return true end, Buy = function(W) return BuyMelee("Superhuman", W, "Martial Arts Master") end}, ["Death Step"] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("DeathStep", W, "Phoeyu, the Reformed") end}, ['Sharkman Karate'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee('SharkmanKarate', W, 'Sharkman Teacher') end}, ['Electric Claw'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("ElectricClaw", W, 'Previous Hero') end}, ['Dragon Talon'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("DragonTalon", W, 'Uzoth') end}, ["Godhuman"] = {Price = {Beli = 5000000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("Godhuman", W, 'Ancient Monk') end}}
    DropItemData = {['Buddy Sword'] = {Sea = 3, Level = 1500, Boss = "Cake Queen"}, ['Canvander'] = {Sea = 3, Level = 1500, Boss = "Beautiful Pirate"}, ['Twin Hooks'] = {Sea = 3, Level = 1500, Boss = 'Captain Elephant'}, ["Venom Bow"] = {Sea = 3, Level = 1500, Boss = "Hydra Leader"}}
    GodhumanMaterials = {['Fish Tail'] = {20, 3, {"Fishman Raider", "Fishman Captain"}, {'DeepForestIsland3', 1, 1775, 'Turtle Adventure Quest Giver'}}, ['Dragon Scale'] = {10, 3, {"Dragon Crew Warrior", "Dragon Crew Archer"}, {'DragonCrewQuest', 1, 1575, 'Dragon Crew Quest Giver'}}, ["Magma Ore"] = {20, 2, {'Magma Ninja'}, {"FireSideQuest", 1, 1100, "Fire Quest Giver"}}, ["Mystic Droplet"] = {10, 2, {'Sea Soldier', 'Water Fighter'}, {'ForgottenQuest', 2, 1425, 'Forgotten Quest Giver'}}}
    SeaIndexes = {"Main", "Dressrosa", "Zou"}
    TasksOrder = {"LevelFarm", "Tushita", 'Yama', "SpecialBossesTask", "RaidController", "AutoRaidIce", 'Trevor', "UtilityItemsActivation", 'ColosseumPuzzle', "Wenlocktoad", "ThirdSeaPuzzle", "PirateRaid", "SecondSeaPuzzle", 'ThirdSeaPuzzle', "CollectDrops", 'BossesTask', "ExpRedeem", "MeleesController"}
    MaxLevel = 2800
    placeId = game.PlaceId
    if placeId == 85211729168715 or placeId == 2753915549 then
        Sea = 'Main'
        SeaIndex = 1
    elseif placeId == 79091703265657 or placeId == 4442272183 then
        Sea = "Dressrosa"
        SeaIndex = 2
    elseif placeId == 100117331123089 or placeId == 7449423635 then
        Sea = "Zou"
        SeaIndex = 3
    end
    Portals = ({{Vector3.new(-7894.6201171875, 5545.49169921875, -380.246346191406), Vector3.new(-4607.82275390625, 872.5422973632812, -1667.556884765625), Vector3.new(61163.8515625, 11.759522438049316, 1819.7841796875), Vector3.new(3876.280517578125, 35.10614013671875, -1939.3201904296875)}, {Vector3.new(-288.46246337890625, 306.130615234375, 597.9988403320312), Vector3.new(2284.912109375, 15.152046203613281, 905.48291015625), Vector3.new(923.21252441406, 126.9760055542, 32852.83203125), Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422)}, {}})[SeaIndex]
    BossesOrder = {"Awakened Ice Admiral", "Tide Keeper", 'Deandre', "Urban", "Diablo", 'Soul Reaper', 'Cake Prince'}
    BossesOrderLevel = {['Awakened Ice Admiral'] = 700, ['Tide Keeper'] = 700, ['Deandre'] = 1500, ['Urban'] = 1500, ['Diablo'] = 1500, ["Cake Prince"] = 1500, ['Soul Reaper'] = 1500}
    BossesOrderWL = {["Deandre"] = 1500, ["Urban"] = 1500, ["Diablo"] = 1500, ['Cake Prince'] = 1500, ['Don Swan'] = 1100, ["Awakened Ice Admiral"] = 700, ['Tide Keeper'] = 700}
    SpecialBossesOrder = {["Core"] = 700, ['Darkbeard'] = 700}
    BlankTablets = {"Segment6", 'Segment2', 'Segment8', "Segment9", 'Segment5'}
    Trophy = {["Segment1"] = "Trophy1", ["Segment3"] = "Trophy2", ['Segment4'] = "Trophy3", ['Segment7'] = "Trophy4", ["Segment10"] = "Trophy5"}
    Pipes = {['Part1'] = 'Really black', ['Part2'] = 'Really black', ["Part3"] = "Dusty Rose", ['Part4'] = "Storm blue", ['Part5'] = 'Really black', ['Part6'] = "Parsley green", ["Part7"] = 'Really black', ["Part8"] = "Dusty Rose", ["Part9"] = 'Really black', ['Part10'] = 'Storm blue'}
    function GenerateUUID()
        local W = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
        return string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", '[xy]', function(W)
            local W = (Idx == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
            return string.format('%x', W)
        end)
    end
    function CheckIsPlayerAlive(W) W = W or LocalPlayer; return W and W.Character and W.Character.Humanoid and W.Character.HumanoidRootPart and W.Character.Head and W.Character.Humanoid.Health > 0 end
    function ConvertTo(W, a) return W.new(a.X, a.Y, a.Z) end
    function CaculateDistance(W, a)
        if not W then return 0 end
        a = a or game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        local h, X = ConvertTo(Vector3, W), ConvertTo(Vector3, a)
        return (h - X).magnitude
    end
    function DispTime(W, a)
        W = tonumber(W)
        if not W then return "[err]" end
        local h = math.floor(W / 86400)
        local X = math.floor(math.fmod(W, 86400) / 3600)
        local w = math.floor(math.fmod(W, 3600) / 60)
        local D = math.floor(math.fmod(W, 60))
        if a then return (h .. "day, " .. X .. "hrs, " .. w .. "min, " .. D .. 'sec.') end
        return (h .. 'day, ' .. X .. "hrs.")
    end
    function GetCurrentDateTime()
        local W = os.date("*t")
        local a = W.hour
        local h = W.min
        local X = W.day
        local w = W.month
        local D = W.year
        local y = W.wday
        local W = string.format('%02d:%02d ', a, h)
        local a = {'Sun', "Mon", 'Tue', "Wed", 'Thu', "Fri", 'Sat'}
        local h = a[y]
        local a = {"Jan", "Feb", "Mar", 'Apr', "May", 'Jun', "Jul", "Aug", 'Sep', "Oct", 'Nov', "Dec"}
        local y = a[w]
        local a = string.format('%s, %s %d %d', h, y, X, D)
        return W .. a
    end
    function RandomArguments(...) local W = {...}; return W[math.random(0, #W)] end
    function RoundVector3Down(W) return Vector3.new(math.floor(W.X / 10) * 10, math.floor(W.Y / 10) * 10, math.floor(W.Z / 10) * 10) end
    
-- ============================================================
-- CIRCLE DIRECTION
-- ============================================================
CaculateCircreDirection = function(a)
    if W_angle > 50000 then W_angle = 60 end
    W_angle = W_angle + ((tick() - lastChange) > 0.4 and 80 or 0)
    if tick() - lastChange > 0.4 then lastChange = tick() end
    local h = a + Vector3.new(math.cos(math.rad(W_angle)) * 40, 0, math.sin(math.rad(W_angle)) * 40)
    return CFrame.new(RoundVector3Down(h.p))
end

function GetMonAsSortedRange()
    local W = {}
    table.foreach(Services.Workspace.Enemies:GetChildren(), function(a, a)
        if a and a:FindFirstChild('Humanoid') and a:FindFirstChild("HumanoidRootPart") and a.Humanoid.Health > 0 then
            table.insert(W, a)
        end
    end)
    table.foreach(game.ReplicatedStorage:GetChildren(), function(a, a)
        if a and a:FindFirstChild('Humanoid') and a:FindFirstChild("HumanoidRootPart") and a.Humanoid.Health > 0 then
            table.insert(W, a)
        end
    end)
    table.sort(W, function(a, h) return CaculateDistance(a.HumanoidRootPart.CFrame) < CaculateDistance(h.HumanoidRootPart.CFrame) end)
    return W
end
print(1.5)
function GetMeleeIdByName(W) for a, h in MeleesTable do if h == W then return MeleesId[a] end end end
function FindMeleeNPC(npcName)
    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
            return npc.HumanoidRootPart.Position
        end
    end
    return nil
end
function getpos(W)
    for a, a in game:GetService("ReplicatedStorage").NPCs:GetChildren() do if a.Name == W then return a.HumanoidRootPart.CFrame end end
    for a, a in workspace.NPCs:GetChildren() do if a.Name == W then return a.HumanoidRootPart.CFrame end end
end

-- ============================================================
-- AUTO FULL MELEE HELPERS
-- ============================================================
function GetBP(meleeName)
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp and bp:FindFirstChild(meleeName) then return bp[meleeName] end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild(meleeName) then return char[meleeName] end
    return nil
end

function GetM(matName)
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if not bp then return 0 end
    for _, v in pairs(bp:GetChildren()) do
        if v.Name == matName and v:FindFirstChild("Count") then
            return v.Count.Value
        end
    end
    return 0
end

function GetConnectionEnemies(enemyName)
    local nearest, dist = nil, math.huge
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        if enemy.Name == enemyName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            local root = enemy:FindFirstChild("HumanoidRootPart")
            if root then
                local d = (root.Position - hrp.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = enemy
                end
            end
        end
    end
    return nearest
end

function BuyMelee(W, a)
    if W == "DragonClaw" then
        if workspace.NPCs:FindFirstChild('Sabi') then
            if a then
                if type(Remotes.CommF_:InvokeServer("BlackbeardReward", 'DragonClaw', '1') == 1) == "number" and Remotes.CommF_:InvokeServer('BlackbeardReward', 'DragonClaw', '1') == 1 == 1 and not table.find(J, W) then table.insert(J, W) end
                return Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
            end
            return Remotes.CommF_:InvokeServer('BlackbeardReward', "DragonClaw", '2')
        end
    end
    if a then
        local a = Remotes.CommF_:InvokeServer('Buy' .. W, true)
        print("Response_", a == 1, typeof(a))
        if type(a) == 'number' and not table.find(J, W) then table.insert(J, W) end
        return a == 1
    end
    return Remotes.CommF_:InvokeServer("Buy" .. W)
end

function SendKey(J, W)
    (function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, J, false, game)
        task.wait(W)
        game:GetService('VirtualInputManager'):SendKeyEvent(false, J, false, game)
    end)()
end

function FruitIdToName(J)
    local W = string.match(J, "((%u)[^%-]+)$")
    return W .. ' Fruit'
end
function Split(J, W)
    if W == nil then W = "%s" end
    local a = {}
    for h in string.gmatch(J, '([^' .. W .. ']+)') do table.insert(a, h) end
    return a
end
function FruitNameToId(J)
    local W = Split(J)[1]
    return W .. '-' .. W
end

-- ============================================================
-- J QUESTS
-- ============================================================
local J = {CurrentLevel = 2, DoubleQuest = true, CurrentQuests = {}, BlacklistedQuestIds = {BartiloQuest = 1, CitizenQuest = 1, Trainees = 1, MarineQuest = 1, ImpelQuest = 1}}
local W = require(game.ReplicatedStorage.GuideModule).Data.NPCList
repeat task.wait() until game.Players.LocalPlayer.DataLoaded and ScriptStorage
J.Quests = require(game.ReplicatedStorage.Quests)
function J.Set(W, a, h) W[a] = h end
function J.RefreshQuest(W)
    local timeout = os.time()
    while not ScriptStorage.PlayerData.Level do
        task.wait(1)
        print('[ Debug ] Waiting for LocalPlayer datas.')
        if os.time() - timeout > 30 then
            print('[ Debug ] Timeout waiting for player data, skipping quest refresh')
            return
        end
    end
    local a = 0
    local h
    for X, w in J.Quests do
        if not J.BlacklistedQuestIds[X] then
            if (w[1].LevelReq >= a and w[1].LevelReq <= ScriptStorage.PlayerData.Level) then
                a = w[1].LevelReq
                h = w
                W.CurrentQuestId = X
                if ScriptStorage.PlayerData.Level >= 1500 and SeaIndex == 2 and X == 'ForgottenQuest' then break end
            end
        end
    end
    local a = h[#h]
    for X, X in a.Task do if X == 1 then table.remove(h, #h) end end
    for a, X in require(game.ReplicatedStorage.GuideModule).Data.NPCList do
        for w, w in X.Levels do if w == h[#h].LevelReq then W.CurrentNpc = a.CFrame end end
    end
    W.CurrentQuests = h
end
function J.GetCurrentQuest(W)
    local a = W.CurrentQuests[W.CurrentLevel] and W.CurrentQuests[W.CurrentLevel].LevelReq <= ScriptStorage.PlayerData.Level and W.CurrentLevel or 1
    for h in W.CurrentQuests[a].Task do return h, W.CurrentNpc, W.CurrentQuestId, a, W.CurrentQuests[a].Name end
end
function J.MarkAsCompleted(W) W.CurrentLevel = W.CurrentLevel == 2 and 1 or 2 end
function J.AbandonQuest()
    print('Abandon Quest')
    Remotes.CommF_:InvokeServer("AbandonQuest")
end
function J.GetCurrentClaimQuest(W)
    local W = game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:gsub("%s*Defeat%s*(%d*)%s*(.-)%s*%b()", '%2')
    return (type(W) == "string" and string.gsub(W, "Military ", "Mil. ") or W), game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
end
function J.StartQuest(W, a)
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer('ColorsDealer', "2")
    return Remotes.CommF_:InvokeServer("StartQuest", W, a)
end

-- ============================================================
-- SCRIPTSTORAGE MOB REGIONS
-- ============================================================
ScriptStorage.MobRegions = {}
for W, W in game:GetService("ReplicatedStorage").FortBuilderReplicatedSpawnPositionsFolder:GetChildren() do
    ScriptStorage.MobRegions[tostring(W)] = ScriptStorage.MobRegions[tostring(W)] or {}
    table.insert(ScriptStorage.MobRegions[tostring(W)], W.CFrame)
end

-- ============================================================
-- TWEEN CONTROLLER
-- ============================================================
TweenController = {}
local W = 0
local W = {}
for a, a in game.ReplicatedStorage.NPCs:GetChildren() do if a.Name == 'Set Home Point' then table.insert(W, a:GetModelCFrame()) end end
function TweenController.Update()
    local a = game.Players.LocalPlayer.Character.HumanoidRootPart
    HumanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    if CaculateDistance(a.CFrame) > 250 then
        pcall(function() TweenInstance:Cancel() end)
        TweenDebounce = true
        a.CFrame = HumanoidRootPart.CFrame
        TweenDebounce = false
    end
    HumanoidRootPart.CFrame = a.CFrame + Vector3.new(0, 3, 0)
end
function GetPortal(a)
    local h, X = 9e9, nil
    for w, w in Portals do
        local D = CaculateDistance(w, a)
        if D < (CaculateDistance(a) - 300) and D < h then
            h = D
            X = w
        end
    end
    if X then
        Remotes.CommF_:InvokeServer("requestEntrance", X)
        return task.wait()
    end
end
function GetEntries(a)
    local h, X = 9e9, nil
    for w, w in W do
        local W = CaculateDistance(w, a)
        if W < (CaculateDistance(a) - 700) and W < h then
            h = W
            X = w
        end
    end
    if X then if os.time() - 0 > 30 then for W = 1, 10, 1 do task.wait() end end end
end
function TweenController.Tween2(W, a)
    TweenInstance2 = Services.TweenService:Create(W, TweenInfo.new(CaculateDistance(W.CFrame, a) / 50, Enum.EasingStyle.Linear), {CFrame = ConvertTo(CFrame, a) - Vector3.new(0, 0, 0)})
    TweenInstance2:Play()
end
function CheckItem(itemName)
    local bp = game.Players.LocalPlayer:FindFirstChild('Backpack')
    for _, v in next, bp and bp:GetChildren() or {} do
        if v:IsA('Tool') and (v.Name == itemName or string.find(v.Name, itemName)) then return v end
    end
    local char = game.Players.LocalPlayer.Character
    if char then
        for _, v in next, char:GetChildren() do
            if v:IsA('Tool') and (v.Name == itemName or string.find(v.Name, itemName)) then return v end
        end
    end
    return false
end
function CheckLegendaryItems()
    return CheckItem("God's Chalice") or CheckItem("Fist of Darkness") or CheckItem("Sweet Chalice") or CheckItem("Hallow Essence") or CheckItem("Flower1")
end
function InArea(pos)
    local WorldOrigin = workspace:FindFirstChild("_WorldOrigin")
    if not WorldOrigin or not WorldOrigin:FindFirstChild("Locations") then return nil end
    local posVec = typeof(pos) == "CFrame" and pos.Position or pos
    local best, bestScale = nil, 0
    for _, v in next, WorldOrigin.Locations:GetChildren() do
        if v:FindFirstChild("Mesh") and (posVec - v.Position).Magnitude <= (v.Mesh.Scale.X / 2) + 500 then
            if v.Mesh.Scale.X > bestScale then
                bestScale = v.Mesh.Scale.X
                best = v
            end
        end
    end
    return best
end
function GetSpawnPoint(pos)
    local spawns = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("PlayerSpawns") and workspace._WorldOrigin.PlayerSpawns:FindFirstChild(game.Players.LocalPlayer.Team.Name)
    if not spawns then return nil end
    local posVec = typeof(pos) == "CFrame" and pos.Position or typeof(pos) == "Vector3" and pos or pos.Position
    for _, v in next, spawns:GetChildren() do
        if v:FindFirstChild("Part") and (v.Part.Position - posVec).Magnitude <= 2500 then
            return v
        end
    end
    return nil
end
function CanBypassTeleport(targetPos)
    local area = InArea(targetPos)
    if not area then return false end
    local areaName = area.Name
    if areaName:find("Dimension") or areaName:find("Submerged") or areaName == "Sealed Cavern" or areaName:lower():find("under") then return false end
    if CheckLegendaryItems() then return false end
    local data = game.Players.LocalPlayer:FindFirstChild("Data")
    local lso = data and data:FindFirstChild("LastSpawnPoint")
    if lso and lso.Value == "SubmergedIsland" then return false end
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    if (targetPos - hrp.Position).Magnitude <= 3500 then return false end
    return true
end
function GetBypassCFrame(targetPos)
    local bestVal, bestSpawn = math.huge, nil
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local spawns = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("PlayerSpawns") and workspace._WorldOrigin.PlayerSpawns:FindFirstChild(game.Players.LocalPlayer.Team.Name)
    if not spawns then return nil end
    local currentSpawn = GetSpawnPoint(hrp)
    for _, v in next, spawns:GetChildren() do
        if v:FindFirstChild("Part") then
            local toTarget = (targetPos - hrp.Position).Magnitude
            local spawnToPlayer = (v.Part.Position - hrp.Position).Magnitude
            local spawnToTarget = (v.Part.Position - targetPos).Magnitude
            local spawnPoint = GetSpawnPoint(v.Part)
            if toTarget >= 3000 and spawnPoint ~= currentSpawn and spawnToPlayer <= 10000 and spawnToTarget <= bestVal then
                bestVal = spawnToTarget
                bestSpawn = v
            end
        end
    end
    return bestSpawn
end
function BypassTP(targetPos)
    if not CanBypassTeleport(targetPos) then return false end
    local targetSpawn = GetBypassCFrame(targetPos)
    if not targetSpawn then return false end
    local char = game.Players.LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    pcall(function() char.LastSpawnPoint.Disabled = true end)
    Remotes.CommF_:InvokeServer("SetLastSpawnPoint", targetSpawn.Name)
    Remotes.CommF_:InvokeServer("SetSpawnPoint")
    char:PivotTo(targetSpawn.Part.CFrame)
    hum:ChangeState(15)
    repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0
    return true
end

-- ============================================================
-- FIXED TWEEN CONTROLLER
-- ============================================================
function TweenController.Create(W)
    if not W or TweenDebounce then return end
    local a = typeof(W) ~= 'CFrame' and ConvertTo(CFrame, W) or W
    if TweenInstance then pcall(function() TweenInstance:Cancel() end) end
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = CaculateDistance(a)
    if dist >= 5000 then
        if BypassTP(a.Position) then return end
    end
    for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    local head = game.Players.LocalPlayer.Character:WaitForChild("Head")
    if not head:FindFirstChild("eltrul") then
        local bv = Instance.new('BodyVelocity')
        bv.Name = "eltrul"
        bv.MaxForce = Vector3.new(0, math.huge, 0)
        bv.Velocity = Vector3.zero
        bv.Parent = head
    end
    if CaculateDistance(a) > 500 then
        if SeaIndex == 3 and not ScriptStorage.Backpack['Valkyrie Helm'] then
        elseif SeaIndex ~= 3 then
            print(a)
            GetPortal(a)
        end
    end
    if CaculateDistance(Vector3.new(11256, -2138.0, 9888), a) < (CaculateDistance(a) - 700) and SeaIndex == 3 then
        local gatePos = CFrame.new(-16269.0, 23, 1371)
        if CaculateDistance(gatePos) > 60 then
            TweenController.Create(gatePos)
            task.wait(1)
            return
        end
        local net = require(game.ReplicatedStorage.Modules.Net)
        net:RemoteFunction('SubmarineWorkerSpeak'):InvokeServer('TravelToSubmergedIsland')
    end
    a = CFrame.new(a.Position)
    local W = CaculateDistance(hrp.CFrame, a)
    local h = hrp.CFrame
    hrp.CFrame = CFrame.new(h.x, a.y, h.z)
    if W <= 5 then
        hrp.CFrame = a
        return
    end
    local divisor
    if W < 100 then
        divisor = 200
    else
        divisor = 190
    end
    local duration = W / divisor
    TweenInstance = Services.TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Sine), {CFrame = a})
    TweenInstance:Play()
end

-- ============================================================
-- FAST ATTACK & EQUIP WEAPON
-- ============================================================
local W = {}
local a = game:GetService('Players')
local h = game:GetService("RunService")
local h = game:GetService('ReplicatedStorage')
local X = game:GetService("Workspace")
local X = game:GetService("VirtualInputManager")
local X = a.LocalPlayer
local X = h:WaitForChild('Modules')
local w = X:WaitForChild("Net")
local X = w:WaitForChild("RE/RegisterAttack")
local X = w:WaitForChild('RE/RegisterHit')
local X = w:WaitForChild('RE/ShootGunEvent')
local X = h:WaitForChild("Remotes"):WaitForChild('Validator2')
local h = game.ReplicatedStorage.Modules
local X = h.Net
local h, h = X:WaitForChild("RE/RegisterHit"), X:WaitForChild('RE/RegisterAttack')
local h = {}
function GetAllBladeHits()
    bladehits = {}
    for X, X in pairs(workspace.Enemies:GetChildren()) do
        if X:FindFirstChild('Humanoid') and X:FindFirstChild('HumanoidRootPart') and X.Humanoid.Health > 0 and (X.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 65 then
            table.insert(bladehits, X)
        end
    end
    return bladehits
end
function Getplayerhit()
    bladehits = {}
    for X, X in pairs(workspace.Characters:GetChildren()) do
        if X.Name ~= game.Players.LocalPlayer.Name and X:FindFirstChild('Humanoid') and X:FindFirstChild('HumanoidRootPart') and X.Humanoid.Health > 0 and (X.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 65 then
            table.insert(bladehits, X)
        end
    end
    return bladehits
end
local X = (Services.ReplicatedStorage.Modules.Net)
local w = require(X):RemoteEvent("RegisterAttack", true)
local D = require(X):RemoteEvent("RegisterHit", true)
function h:Attack()
    local X = {}
    for y, y in pairs(GetAllBladeHits()) do table.insert(X, y) end
    for y, y in pairs(Getplayerhit()) do table.insert(X, y) end
    if #X == 0 then return end
    local y = {[1] = nil, [2] = {}, [4] = "078da5141"}
    for L, L in pairs(X) do
        w:FireServer(0)
        if not y[1] then y[1] = L.Head end
        table.insert(y[2], {[1] = L, [2] = L.HumanoidRootPart})
        table.insert(y[2], L)
    end
    D:FireServer(unpack(y))
end
task.spawn(function()
    while task.wait(.06) do if _G.FastAttack == os.time() then pcall(function() h:Attack() end) end end
end)
function W.Attack(target) pcall(function() _G.FastAttack = os.time() end) end

CombatController = {GRAB = false, GRAB_DISTANCE = SeaIndex == 1 and 250 or 350, MAX_ATTACK_DURATION = 2, MAX_ATTACK_DURATION_2 = 60, LEVITATE_TIME = 0, CurrentIndex = 1}
LastFound = os.time()
function CombatController.Grab(mobName)
    pcall(sethiddenproperty, game.Players.LocalPlayer, 'SimulationRadius', math.huge)
    if not CombatController.GRAB or GrabDebounce == os.time() then return end
    GrabDebounce = os.time()
    if not MonResult or not MonResult:FindFirstChild('HumanoidRootPart') then return end
    local targetPos = MonResult.HumanoidRootPart.Position
    local AreaMob = false
    for _, enemy in Services.Workspace.Enemies:GetChildren() do
        if enemy ~= MonResult and enemy.Name == mobName then
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            local root = enemy:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                local dist = (root.Position - targetPos).Magnitude
                if dist <= 3000 then
                    local bv = root:FindFirstChild('FarmingVelocity')
                    if not bv then
                        bv = Instance.new('BodyVelocity')
                        bv.Name = 'FarmingVelocity'
                        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                        bv.Velocity = Vector3.zero
                        bv.Parent = root
                    end
                    if dist <= 10 then
                        AreaMob = true
                    end
                    if not AreaMob and (not isnetworkowner or pcall(isnetworkowner, root)) then
                        root.CFrame = MonResult.HumanoidRootPart.CFrame
                    end
                    enemy:SetAttribute('IsGrabbed', true)
                end
            end
        end
    end
end
function Sort1(entity) return entity and entity:FindFirstChild("HumanoidRootPart") and math.floor(CaculateDistance(entity.HumanoidRootPart.CFrame)) end
function CombatController.Search(names)
    local candidates = {}
    local anyFound = false
    for _, entity in GetMonAsSortedRange() do
        if table.find(names, entity.Name) and entity:FindFirstChild("Humanoid") and entity.Humanoid.Health > 0 then
            if (entity:GetAttribute('FailureCount') or 0) < 3 then
                anyFound = true
                table.insert(candidates, entity)
            end
        end
    end
    table.sort(candidates, function(entity, other) return Sort1(entity) < Sort1(other) end)
    if anyFound then
        local best = candidates[1]
        return best
    end
    for _, npcName in names do
        local npc = game.ReplicatedStorage:FindFirstChild(npcName)
        if npc then return npc end
    end
end
function CombatController.Attack(h, X, w, D)
    if ScriptStorage.Tools["Sweet Chalice"] and getsenv(game.ReplicatedStorage.GuideModule)["_G"]['InCombat'] then
        TweenController.Create(Vector3.new(0, 0, 0))
        return
    end
    sethiddenproperty(game.Players.LocalPlayer, 'SimulationRadius', math.huge)
    h = type(h) == "string" and {h} or (h or {})
    for y, L in (h) do
        local b = tostring(L)
        if b == 'Deandre' or b == "Urban" or b == "Diablo" and (os.time() - (LastFire12 or 0)) > 180 then
            LastFire12 = os.time()
            Remotes.CommF_:InvokeServer("EliteHunter")
        end
        if X then
            local b = GetMonAsSortedRange()[1]
            local C = b and b:FindFirstChild('HumanoidRootPart') and b.HumanoidRootPart.Position
            if C and CaculateDistance(C) < w then MonResult = b end
        else
            MonResult = CombatController.Search(h)
        end
        if MonResult then
            LastFound = os.time()
            local h, w = 0, os.time()
            SetTask('SubTask', '⚔️ Attacking ' .. tostring(MonResult.Name))
            local w, b = 0, os.time()
            while task.wait() do
                if _G.Stop then return end
                if ScriptStorage.Tools["Sweet Chalice"] and getsenv(game.ReplicatedStorage.GuideModule)["_G"]["InCombat"] then
                    TweenController.Create(Vector3.new(0, 0, 0))
                    return
                end
                local C = MonResult:FindFirstChild('Humanoid')
                local p = MonResult:FindFirstChild('HumanoidRootPart')
                if not C or C.Health <= 0 then
                    if MonResult.Name == "Don Swan" then Storage:Set("SwanDefeated", true) end
                    break
                end
                TweenController.Create(CaculateCircreDirection(p.CFrame) + Vector3.new(0, 35, 0))
                if CaculateDistance(p.Position + Vector3.new(0, 35, 0)) < 150 then
                    y = D and D()
                    CombatController.Grab(L or '')
                    if MonResult.Name ~= "Core" then
                        if ScriptStorage.PlayerData.Level > 100 and w >= CombatController.MAX_ATTACK_DURATION_2 and C.Health - C.MaxHealth == 0 then
                            SetTask('SubTask', 'Hop Server - Mob Health Unchanged ( ' .. C.Health .. ' / ' .. C.MaxHealth .. ')')
                            alert("stuck", "Mob health unchanged")
                            _G.Stop = true
                            game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
                        end
                        if h >= CombatController.MAX_ATTACK_DURATION and C.Health - C.MaxHealth == 0 then
                            h = 0
                            local D = MonResult:GetAttribute('OldPosition')
                            if D then
                                MonResult:SetPrimaryPartCFrame(CFrame.new(D))
                                MonResult:SetAttribute('IgnoreGrab', true)
                                MonResult:SetAttribute('FailureCount', (MonResult:GetAttribute("FailureCount") or 0) + 1)
                                alert('Failed to attack', "Returning to the old posiiton ( #" .. MonResult:GetAttribute("FailureCount") .. " )")
                                MonResult.HumanoidRootPart.CFrame = (CFrame.new(D))
                                task.wait()
                                return
                            end
                        end
                    end
                    if (FarmFruitMastery or math.huge) - os.time() < 3 and math.floor(MonResult.Humanoid.Health / MonResult.Humanoid.MaxHealth * 100) < 30 and not FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
                        TweenController.Create((p.CFrame) + Vector3.new(0, 25, 0))
                        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Blox Fruit')
                        LockAimPositionTo(MonResult.HumanoidRootPart.CFrame.p)
                        local D = {'Z', 'X', "C", 'V'}
                        local y = D[math.random(1, #D)]
                        SendKey(y, .31)
                    else
                        if _G.SelectWeapon and CheckItem(_G.SelectWeapon) then
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(_G.SelectWeapon)
                        else
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(ScriptStorage.ForceToUseSword and 'Sword' or "Melee")
                        end
                    end
                    W:Attack(MonResult)
                    if os.time() ~= b then
                        b = os.time()
                        h = h + 1
                        w = w + 1
                    end
                    if h > 30 and MonResult.Name ~= "Core" then
                        alert("Take more than 30s to attack, canceling")
                        break
                    end
                end
            end
        elseif not X then
            if (os.time() - LastFound) > 200 then
                alert('MeyyHub', 'Error while farming, rejoin')
                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
                return
            end
            local h = ScriptStorage.MobRegions[L]
            if not h then
                local X = Services.Workspace.Enemies:FindFirstChild(L) or game.ReplicatedStorage:FindFirstChild(L)
                h = X and {X:GetPrimaryPartCFrame().p}
            end
            if not h then
                Report('[ Game data error ] Mob with name ' .. tostring(L) .. ' have no spawn region datas')
                return
            end
            local X
            if not h[CombatController.CurrentIndex] then CombatController.CurrentIndex = 1 end
            X = h[CombatController.CurrentIndex]
            local h = os.time()
            TweenController.Create(X + Vector3.new(0, 35, 35))
            if CaculateDistance(X + Vector3.new(0, 35, 35)) < 15 then CombatController.CurrentIndex = CombatController.CurrentIndex + 1 end
        end
    end
end
LevelFarmTTL = 0
LastTravel = os.time()
FunctionsHandler = {Initalized = false}
print(3000)
setmetatable(FunctionsHandler, {__index = function(h, X)
    QueryResult = rawget(h, X)
    if not QueryResult then
        return {
            Register = function(w)
                if w == false then return end
                Result = {CacheListener = {}, RealCache = {}, Methods = {}, Constants = {}, Events = {}, Initalized = true}
                function Result.RegisterMethod(w, D, y)
                    w.Methods[D] = {Name = D, Callback = y, Call = function(w, ...) return w.Callback(...) end, Events = {}}
                    return true
                end
                setmetatable(Result.Constants, {__newindex = function() assert(false, 'cannot change constant value!') end})
                if h.Constants[Key] then
                    function Result.SaveConstant(w, w, w) return assert(false, 'constant name was used before!') end
                    rawset(h.Constants, Key, Value)
                end
                function Result.Set(h, w, D)
                    h.CacheListener[w] = D
                    return D
                end
                function Result.Get(h, w) return h.Constants[w] or h.RealCache[w] end
                function Result.AddVariableChangeListener(h, w, D) h.Events[w] = D end
                Result.CacheListener.__parent = Result
                setmetatable(Result.CacheListener, {__newindex = function(h, w, D)
                    _ = h.__parent.Events[w] and h.__parent.Events[w](w, D)
                    h.__parent.RealCache[w] = D
                end})
                FunctionsHandler[X] = Result
            end, Initalized = false
        }
    end
    return QueryResult
end})
function FunctionsHandler.SynchorizeUntilModuleLoaded(h, X)
    local w = os.time()
    while not h.Initalized do
        task.wait()
        local h = os.time() - w
        assert(not (X and h > X), "timed out")
    end
end
function GetCurrentClaimQuest(h)
    local h = game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:gsub("%s*Defeat%s*(%d*)%s*(.-)%s*%b()", "%2")
    return (type(h) == "string" and string.gsub(h, "Military ", "Mil. ") or h), game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
end
FunctionsHandler.LocalPlayerController.Register()
FunctionsHandler.ExpRedeem:Register()
FunctionsHandler.LevelFarm:Register()
FunctionsHandler.Saber:Register()
FunctionsHandler.Rengoku:Register()
FunctionsHandler.Yama:Register()
FunctionsHandler.Tushita:Register()
FunctionsHandler.SpikeyTrident:Register()
FunctionsHandler.SharkAchor:Register()
FunctionsHandler.Pole:Register()
FunctionsHandler.FoxLamp:Register()
FunctionsHandler.DarkDagger:Register()
FunctionsHandler.Canvander:Register()
FunctionsHandler.BuddySword:Register()
FunctionsHandler.HallowScythe:Register()
FunctionsHandler.CursedDualKatana:Register()
FunctionsHandler.AcidumRifle:Register()
FunctionsHandler.Kabucha:Register()
FunctionsHandler.VenomBow:Register()
FunctionsHandler.SoulGuitar:Register()
FunctionsHandler.DragonStorm:Register()
FunctionsHandler.InsictV2:Register()
FunctionsHandler.RainbowSaviour:Register()
FunctionsHandler.DarkBladeV2:Register()
FunctionsHandler.SecondSeaPuzzle:Register()
FunctionsHandler.ColosseumPuzzle:Register()
FunctionsHandler.Trevor:Register()
FunctionsHandler.EvoRace:Register()
FunctionsHandler.Wenlocktoad:Register()
FunctionsHandler.DarkBladeV3:Register()
FunctionsHandler.ThirdSeaPuzzle:Register()
FunctionsHandler.DojoQuest:Register()
FunctionsHandler.RaceAwakening:Register()
FunctionsHandler.PirateRaid:Register()
FunctionsHandler.RaidController:Register()
FunctionsHandler.AutoRaidIce:Register()
FunctionsHandler.MeleesController:Register()
FunctionsHandler.Superhuman:Register()
FunctionsHandler.DeathStep:Register()
FunctionsHandler.SharkmanKarate:Register()
FunctionsHandler.ElectricClaw:Register()
FunctionsHandler.DragonTalon:Register()
FunctionsHandler.Godhuman:Register()
FunctionsHandler.BossesTask:Register()
FunctionsHandler.SpecialBossesTask:Register()
FunctionsHandler.CollectDrops:Register()
FunctionsHandler.CollectBerries:Register()
FunctionsHandler.UtilityItemsActivation:Register()
    
    -- ============================================================
    -- AUTO FULL MELEE
    -- ============================================================
    FunctionsHandler.MeleesController:RegisterMethod("Refresh", function()
        if not Config.Items.AutoFullyMelees then return nil end
        if ScriptStorage.PlayerData.Level < 200 then return nil end
        if _G.Level then return nil end

        local allMelees = {"Black Leg", "Electro", "Fishman Karate", "Dragon Claw", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman"}
        local hasAll = true
        for _, name in ipairs(allMelees) do
            if not CheckItem(name) then
                hasAll = false
                break
            end
        end
        if hasAll then
            SetTask('MainTask', 'Auto Full Melee | ✅ Have all!')
            return nil
        end
        return true
    end)

    FunctionsHandler.MeleesController:RegisterMethod("Start", function()
        if not Config.Items.AutoFullyMelees then return end
        if ScriptStorage.PlayerData.Level < 200 then return end
        if _G.Level then return end

        local meleeList = {
            {name = "Black Leg", key = "BuyBlackLeg", price = {Beli = 150000}, levelReq = 300},
            {name = "Electro", key = "BuyElectro", price = {Beli = 500000}, levelReq = 300},
            {name = "Fishman Karate", key = "BuyFishmanKarate", price = {Beli = 750000}, levelReq = 300},
            {name = "Dragon Claw", key = "BuyDragonClaw", price = {Fragments = 1500}, levelReq = 300},
            {name = "Superhuman", key = "BuySuperhuman", price = {Beli = 3000000}, levelReq = nil},
            {name = "Death Step", key = "BuyDeathStep", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400, needKey = "Library Key"},
            {name = "Sharkman Karate", key = "BuySharkmanKarate", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400, needKey = "Water Key"},
            {name = "Electric Claw", key = "BuyElectricClaw", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400},
            {name = "Dragon Talon", key = "BuyDragonTalon", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400, needFireEssence = true},
            {name = "Godhuman", key = "BuyGodhuman", price = {Beli = 5000000, Fragments = 5000}, levelReq = 400, needMaterials = true},
        }

        for _, melee in ipairs(meleeList) do
            if _G.Stop then return end
            if _G.Level then return end

            local bp = CheckItem(melee.name)
            if not bp then
                local canBuy = true
                for currency, amount in pairs(melee.price) do
                    local have = (currency == "Beli" and ScriptStorage.PlayerData.Beli) or
                                 (currency == "Fragments" and ScriptStorage.PlayerData.Fragments) or 0
                    if have < amount then canBuy = false end
                end
                if canBuy then
                    SetTask('MainTask', 'Auto Full Melee | Buying ' .. melee.name)
                    BuyMelee(melee.key, true)
                    task.wait(1)
                    if CheckItem(melee.name) then
                        SetTask('MainTask', 'Auto Full Melee | ✅ Bought ' .. melee.name)
                    end
                else
                    SetTask('MainTask', 'Auto Full Melee | Need farm for ' .. melee.name)
                    _G.Level = true
                    return
                end
            else
                if melee.levelReq and bp:FindFirstChild("Level") and bp.Level.Value < melee.levelReq then
                    SetTask('MainTask', 'Auto Full Melee | Farming level for ' .. melee.name .. ' (' .. bp.Level.Value .. '/' .. melee.levelReq .. ')')
                    _G.Level = true
                    return
                end

                if melee.needKey then
                    if not CheckItem(melee.needKey) then
                        SetTask('MainTask', 'Auto Full Melee | Getting ' .. melee.needKey .. ' for ' .. melee.name)
                        if melee.needKey == "Library Key" then
                            local admiral = GetConnectionEnemies("Awakened Ice Admiral")
                            if admiral then
                                CombatController.Attack("Awakened Ice Admiral")
                                task.wait(2)
                                return
                            else
                                TweenController.Create(CFrame.new(5668.978, 28.52, -6483.352))
                                return
                            end
                        elseif melee.needKey == "Water Key" then
                            local tide = GetConnectionEnemies("Tide Keeper")
                            if tide then
                                CombatController.Attack("Tide Keeper")
                                task.wait(2)
                                return
                            else
                                TweenController.Create(CFrame.new(-3053.981, 237.19, -10145.039))
                                return
                            end
                        end
                        return
                    end
                end

                if melee.needFireEssence then
                    local bones = ScriptStorage.Backpack["Bones"] and ScriptStorage.Backpack["Bones"].Count or 0
                    if bones < 1 then
                        SetTask('MainTask', 'Auto Full Melee | Farming Bones for Fire Essence')
                        CombatController.Attack({'Reborn Skeleton', 'Living Zombie', 'Demonic Soul', 'Posessed Mummy'})
                        return
                    end
                    Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                    task.wait(1)
                end

                if melee.needMaterials then
                    local materials = {
                        {name = "Dragon Scale", need = 10, sea = 3, mobs = {"Dragon Crew Warrior", "Dragon Crew Archer"}},
                        {name = "Fish Tail", need = 20, sea = 3, mobs = {"Fishman Raider", "Fishman Captain"}},
                        {name = "Mystic Droplet", need = 10, sea = 2, mobs = {"Sea Soldier", "Water Fighter"}},
                        {name = "Magma Ore", need = 20, sea = 2, mobs = {"Magma Ninja"}},
                    }
                    for _, mat in ipairs(materials) do
                        local count = ScriptStorage.Backpack[mat.name] and ScriptStorage.Backpack[mat.name].Count or 0
                        if count < mat.need then
                            if SeaIndex ~= mat.sea then
                                Remotes.CommF_:InvokeServer(mat.sea == 2 and "TravelDressrosa" or "TravelZou")
                                return
                            end
                            SetTask('MainTask', 'Auto Full Melee | Farming ' .. mat.name .. ' (' .. count .. '/' .. mat.need .. ')')
                            CombatController.Attack(mat.mobs)
                            return
                        end
                    end
                end

                SetTask('SubTask', '✅ ' .. melee.name .. ' ready')
            end
        end

        SetTask('MainTask', 'Auto Full Melee | 🎉 All complete!')
        _G.Level = false
    end)

    -- ============================================================
    -- LEVEL FARM
    -- ============================================================
    FunctionsHandler.LevelFarm:RegisterMethod("Refresh", function()
        local lv = ScriptStorage.PlayerData.Level or 0
        if lv < 50 then return 1
        elseif lv < 70 then return 2
        else return 4 end
    end)

    FunctionsHandler.LevelFarm:RegisterMethod("Start", function(h)
        local currentLevel = ScriptStorage.PlayerData.Level
        if currentLevel and currentLevel >= 700 and SeaIndex == 1 then return end

        if SeaIndex == 3 then
            if (ScriptStorage.Backpack.Bones or {Count = 0}).Count >= 50 then
                if os.time() > (BonesCooldown or 0) then
                    local X, X, X, w = Remotes.CommF_:InvokeServer("Bones", 'Check')
                    if tonumber(X or 1) == 0 then
                        local X = Split(w, ":")
                        local w = ((tonumber(X[1]) * 60) + tonumber(X[2])) * 60
                        BonesCooldown = os.time() + w
                    else
                        Remotes.CommF_:InvokeServer('Bones', 'Buy', 1, 1)
                    end
                end
            end
        end

        local X = ScriptStorage.PlayerData.Level
        if GodHumanFlag then
            local w, D = (function()
                getgenv()["   mphm ><<3"] = {}
                for y, L in GodhumanMaterials do
                    if (ScriptStorage.Backpack[y] or {Count = 0}).Count < L[1] then
                        getgenv()['   mphm >< <3'] = {y, L}
                    end
                end
                return unpack(getgenv()["   mphm >< <3"])
            end)()
            if w then
                if SeaIndex ~= D[2] then
                    alert('Material - ' .. w, "Travelling sea " .. D[2])
                    SetTask("MainTask", 'Sea Travel | Godhuman Materials | Travelling to Sea ' .. D[2])
                    Remotes.CommF_:InvokeServer("Travel" .. SeaIndexes[D[2]])
                    return
                end
                SetTask("MainTask", "Material Farming | Godhuman | " .. w .. " | In Progress")
                if X >= D[4][3] then
                    local w, y = GetCurrentClaimQuest()
                    if w then
                        if not string.find(y, D[3][1]) and not string.find(y, D[3][2]) then J.AbandonQuest()
                        else CombatController.Attack(D[3]); return end
                    else
                        local w = ScriptStorage.NPCs[D[4][4]]
                        w = w and w:GetModelCFrame()
                        if w then
                            TweenController.Create(w + Vector3.new(0, 5, 3))
                            if CaculateDistance(w) < 10 then task.wait(1)
                            else return end
                        else
                            Report("NPC HauntedQuest2 not found")
                        end
                        J.StartQuest(D[4][1], D[4][2])
                        return
                    end
                end
                CombatController.Attack(D[3])
            end
            Remotes.CommF_:InvokeServer("BuyGodhuman", true)
            Remotes.CommF_:InvokeServer("BuyGodhuman")
            GodHumanFlag = false
            return true
        end

        if os.time() - LastTravel > 60 then
            LastTravel = os.time()
            if X >= 1500 and SeaIndex == 2 then
                if Config.Settings.StayInSea2UntilHaveDarkFragments and not ScriptStorage.Backpack['Dark Fragment'] then
                elseif not Services.Workspace.Map.IceCastle.Hall.LibraryDoor:FindFirstChild('PhoeyuDoor') then
                    Remotes.CommF_:InvokeServer("TravelZou")
                    SetTask('MainTask', 'Sea Travel | Teleporting to Third Sea')
                end
            elseif X >= 700 and SeaIndex == 1 then
                SetTask('MainTask', 'Sea Travel | Teleporting to Second Sea')
                Remotes.CommF_:InvokeServer("TravelDressrosa")
            end
        end

        if ScriptStorage.Tools['God\'s Chalice'] and not ScriptStorage.Tools['Mirror Fractal'] then
            if (ScriptStorage.Backpack["Conjured Cocoa"] or {Count = 0}).Count < 10 then
                SetTask("MainTask", "Material Farming | Conjured Cocoa | Need 10x | Farming...")
                CombatController.Attack({"Cocoa Warrior", "Chocolate Bar Battler"})
                return
            end
            Remotes.CommF_:InvokeServer("SweetChaliceNpc")
        end

        if ScriptStorage.Tools['Sweet Chalice'] or (X == MaxLevel and (ScriptStorage.Backpack.Bones or {Count = 0}).Count >= 500) then
            SetTask("MainTask", "Fragments Farming | Cake Prince | Dough King")
            if (ScriptStorage.Tools["Sweet Chalice"]) and (not SpawnReflect or os.time() - SpawnReflect > 10) then
                task.spawn(function()
                    while not ScriptStorage.Enemies['Dough King'] and task.wait() and ScriptStorage.Tools["Sweet Chalice"] do
                        SpawnReflect = os.time()
                        Remotes.CommF_:InvokeServer("CakePrinceSpawner")
                    end
                end)
            end
            CombatController.Attack({"Head Baker", 'Baking Staff', 'Cookie Crafter', "Cake Guard"})
            if X >= 2200 then
                local w, D = GetCurrentClaimQuest()
                if w then
                    if not string.find(D, "Cookie") then J.AbandonQuest()
                    else Remotes.CommF_:InvokeServer('CakePrinceSpawner'); return end
                else
                    print('Start Quest')
                    local w = ScriptStorage.NPCs["Cake Quest Giver 1"]
                    w = w and w:GetModelCFrame()
                    if w then
                        TweenController.Create(w + Vector3.new(0, 5, 3))
                        if CaculateDistance(w) < 10 then task.wait(1)
                        else return end
                    else
                        Report("NPC HauntedQuest2 not found")
                    end
                    J.StartQuest("CakeQuest1", 1)
                    return
                end
            end
            return
        end

        if X >= 2025 and (getsenv(game.ReplicatedStorage.GuideModule)._G.ServerData.ExpBoost == 0 or X <= MaxLevel) and (ScriptStorage.Backpack.Bones or {Count = 0}).Count < 500 then
            SetTask('MainTask', "Resource Farming | Bones | For X2 Mastery/Beli")
            CurrentClaimQuest3 = GetCurrentClaimQuest(true)
            if CurrentClaimQuest3 then
                if not string.find(CurrentClaimQuest3, 'Demonic') then J.AbandonQuest(); return
                else CombatController.Attack({'Reborn Skeleton', "Living Zombie", "Demonic Soul", 'Posessed Mummy'}); return end
            else
                print("StartQuest", CurrentClaimQuest3)
                local X = ScriptStorage.NPCs["Haunted Castle Quest Giver 2"]
                X = X and X:GetModelCFrame()
                if X then
                    TweenController.Create(X + Vector3.new(0, 5, 3))
                    if CaculateDistance(X) < 20 then task.wait(1)
                    else return end
                else
                    Report("NPC HauntedQuest2 not found")
                end
                J.StartQuest('HauntedQuest2', 1)
                return
            end
        end

        if h == 1 then
            SetTask('MainTask', 'Level Farming | Skip Mode | Floor ' .. h)
            CombatController.Attack("Sky Bandit")
        elseif h == 2 then
            SetTask('MainTask', 'Level Farming | Skip Mode | Floor ' .. h)
            CombatController.Attack('God\'s Guard')
        elseif h == 4 then
            local h, X, w, D, y = J:GetCurrentQuest()
            SetTask('SubTask', '📋 Quest: ' .. y .. ' | Defeat ' .. h)
            CurrentClaimQuest1 = GetCurrentClaimQuest()
            if CurrentClaimQuest1 then
                if CurrentClaimQuest1 ~= y and CurrentClaimQuest1 ~= (y .. "s") then return J.AbandonQuest() end
            else
                if not X then return J:RefreshQuest() and Report("failed to get npc position quest 528") end
                TweenController.Create(X + Vector3.new(0, 5, 3))
                SetTask("MainTask", "Level Farming | " .. h .. " | Claiming Quest")
                if CaculateDistance(X) > 10 then return end
                task.wait(2)
                LevelFarmTTL = 0
                J.StartQuest(w, D)
                task.wait(1)
            end
            SetTask('MainTask', 'Level Farming | ' .. h .. " | Defeating Enemies")
            local X = os.time()
            CombatController.Attack(h)
            LevelFarmTTL = LevelFarmTTL + os.time() - X
            if LevelFarmTTL > 160 then end
        end
    end)

    -- ============================================================
    -- NOTIFICATION LISTENERS, HOP, STORAGE, MAIN LOOP
    -- ============================================================
    local k = {Listeners = {}}
    TorchEnabledTime = 0
    DoneCdkTick = 0
    getgenv().NotificationCallBack = (function(W)
        for h, X in k.Listeners do
            if string.find(string.lower(W), string.lower(h)) then X(W) end
        end
    end)
    function k:RegisterNotifyListener(W, h) k.Listeners[W] = h end
    k:RegisterNotifyListener('go!', function() LastRaidAlert = os.time() end)
    k:RegisterNotifyListener('raid', function() LastRaidAlert2 = os.time() end)
    k:RegisterNotifyListener("been spotted approaching", function() FunctionsHandler.PirateRaid:Set('Senque', os.time()) end)
    k:RegisterNotifyListener('job', function() FunctionsHandler.PirateRaid:Set('Senque', 0) end)
    k:RegisterNotifyListener("level", function() AddPoint() end)
    k:RegisterNotifyListener("torch", function() TorchEnabledTime = os.time() end)
    k:RegisterNotifyListener("scroll reacts", function() DoneCdkTick = os.time() end)
    k:RegisterNotifyListener("elite", function()
        FunctionsHandler.Yama:Set('EliteCount', Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
        alert("[MeyyHub ] ", "Elite defeated: " .. tostring(FunctionsHandler.Yama:Get("EliteCount") or 'n/a'))
    end)
    k:RegisterNotifyListener('the raid with', function()
        if ScriptStorage.PlayerData.Level < MaxLevel then return end
        Remotes.CommF_:InvokeServer('Awakener', "Awaken")
    end)
    k:RegisterNotifyListener('quest completed', function()
        J:RefreshQuest()
        task.wait()
        if not J:GetCurrentClaimQuest() then J:MarkAsCompleted() end
    end)
    local k
    k = hookfunction(require(game.ReplicatedStorage.Notification).new, function(W, h)
        v21 = tostring(tostring(W or '') .. tostring(h or "")) or ""
        getgenv().NotificationCallBack(v21)
        return k(W, h)
    end)

    -- ============================================================
    -- SERVER MANAGEMENT
    -- ============================================================
    function IfTableHaveIndex(k) for W in k do return true end end
    print(1)
    function GetServers()
        if LastServersDataPulled then
            if os.time() - LastServersDataPulled < 60 then return CachedServers end
        end
        for k = 1, 100, 1 do
            local W = game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer(k)
            if IfTableHaveIndex(W) then
                LastServersDataPulled = os.time()
                CachedServers = W
                return W
            end
        end
    end
    spawn(function()
        GetServers()
        while task.wait(180) do GetServers() end
    end)
    function Hop(k, W)
        local h = GetServers()
        local X = {}
        for w, D in h do
            table.insert(X, {JobId = w, Players = D.Count, LastUpdate = D.__LastUpdate, Region = D.Region})
        end
        print(#X, "servers received")
        for h = 1, #X do
            while task.wait() do
                local h = math.random(1, #X)
                ServerData = X[h]
                if ServerData then
                    if not k or ServerData.Players < k then
                        if not W or ServerData.Regoin == W then
                            print("Found Server:", ServerData.JobId, "Player Count:", ServerData.Players, 'Region:', ServerData.Region)
                            break
                        end
                    end
                end
            end
        end
        print('Teleporting to', ServerData.JobId, "..")
        game:GetService("ReplicatedStorage"):WaitForChild('__ServerBrowser'):InvokeServer("teleport", ServerData.JobId)
    end

    Storage = {WRITE_DELAY = .5, Data = {}}
    local k = ".storage_u_" .. tostring(LocalPlayer)
    function Decode(W) return Services.HttpService:JSONDecode(W) end
    function Encode(W) return Services.HttpService:JSONEncode(W) end
    print(5)
    function Storage.Set(W, h, X) W.Data[h] = X end
    function Storage.Get(W, h) return W.Data[h] end
    function Storage.Save(W) pcall(function() if writefile then writefile(k, Encode(W.Data)) end end) end
    if isfile and readfile and not isfile(k) then
        pcall(writefile, k, "{}")
        task.wait(1)
    end
    Storage.Data = {}
    if readfile then pcall(function() Storage.Data = Decode(readfile(k) or '{}') end) end
    spawn(function() while task.wait(Storage.WRITE_DELAY) do Storage:Save() end end)
    CreateTraceback('Initalize', "Initalizing script..")
    local k = {}
    SetTask("MainTask", 'Level Farming')
    SetTask("SubTask", "Idle")
    ParsingTimes = 0
    function RefreshTasksData()
        if _G.Stop then return end
        for W, W in TasksOrder do
            local h = FunctionsHandler[W]
            if not h.Initalized then
                if not k[W] then
                    print("[ Debug ] Task", Name, "is not registered yet")
                    k[W] = true
                end
            else
                local k = h.Methods.Refresh
                local X = h.Methods.Start
                if k then
                    local h = k:Call(ParsingTimes < 100)
                    ParsingTimes = ParsingTimes + 1
                    if h and ParsingTimes > 100 then
                        CurrentTask = CurrentTask ~= W
                        CurrentTask = W
                        ScriptStorage.Interface.SetText('DebugLine', W)
                        X:Call(h)
                        return
                    end
                end
            end
        end
    end
    AddPoint()
    J:RefreshQuest()
    RefreshInventory()
    Remotes.CommE.OnClientEvent:Connect(function(...)
        local J = {...}
        if string.find(J[1], 'Item') then RefreshInventory() end
    end)
    RefreshRace()
    a.LocalPlayer.Idled:Connect(function()
        Services.VirtualUser:CaptureController()
        Services.VirtualUser:ClickButton2(Vector2.new())
    end)
    local function EnableFpsBoost()
        if true then return end
        spawn(function()
            pcall(function()
                local effect = game:GetService("ReplicatedStorage"):FindFirstChild("Effect")
                if effect then effect:Destroy() end
                local fastBtn = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main")
                if fastBtn and fastBtn:FindFirstChild("Settings") and fastBtn.Settings:FindFirstChild("Buttons") then
                    local btn = fastBtn.Settings.Buttons:FindFirstChild("FastModeButton")
                    if btn then
                        for _, conn in pairs(getconnections(btn.Activated)) do
                            conn.Function()
                        end
                    end
                end
                local lighting = game:GetService("Lighting")
                lighting.GlobalShadows = false
                lighting.FogEnd = 9000000000
                lighting.Brightness = 0
                for _, v in pairs(lighting:GetDescendants()) do
                    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                        v.Enabled = false
                    end
                end
                local terrain = workspace.Terrain
                if terrain then
                    terrain.WaterWaveSize = 0
                    terrain.WaterWaveSpeed = 0
                    terrain.WaterReflectance = 0
                    terrain.WaterTransparency = 0
                end
                if settings and settings().Rendering then
                    settings().Rendering.QualityLevel = "Level01"
                    settings().Rendering.GraphicsMode = "NoGraphics"
                end
                print("[✅ FPS Boost] Applied full optimization!")
            end)
        end)
    end
    EnableFpsBoost()
    QueueList = {}
    function NearbyHopHandler()
        do return end
        if NearbyHopHandlerDebounce and os.time() - NearbyHopHandlerDebounce < 10 then return end
        NearbyHopHandlerDebounce = os.time()
        for J, J in a:GetPlayers() do
            local k = J and J.Character and J.Character:FindFirstChild("HumanoidRootPart") and J.Character.HumanoidRootPart.Position
            if k then
                local W = QueueList[J.Name]
                if not W then
                    QueueList[J.Name] = os.time()
                else
                    if os.time() - W > 30 then
                        if CaculateDistance(k) < 100 then
                            Hop('nearby plr')
                            task.wait(5)
                        else
                            QueueList[J.Name] = nil
                        end
                    end
                end
            end
        end
    end
    task.spawn(function()
        while task.wait() do
            if not _G.Stop then
                NearbyHopHandler()
                if LocalPlayer.Character:FindFirstChild('Humanoid') and LocalPlayer.Character.Humanoid.Sit then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                pcall(RefreshPlayerData)
                local J = os.time() - timeee
                local r = J + OldSessionTime
                if writefile then pcall(writefile, ".tdif-" .. game.Players.LocalPlayer.Name, tostring(r)) end
                RefreshDebounce = os.time()
            end
        end
    end)
    AddPoint()
    Remotes.CommF_:InvokeServer("Cousin", 'Buy')
    task.spawn(function()
        task.wait(Config.Configuration.AutoHopDelay)
        if not Config.Configuration.AutoHop then Hop('Autohop') end
    end)

    -- ============================================================
    -- MAIN LOOP (Logic)
    -- ============================================================
    while task.wait() do
        if Config.Configuration.HopWhenIdle and LastIdling and os.time() - LastIdling > 300.0 then
            SetTask('MainTask', "Rejoining due idle in 10 min!")
            task.wait(1)
            while task.wait() do game:GetService('TeleportService'):Teleport(game.PlaceId) end
        end
        if not AnimationDelay or os.time() - AnimationDelay > 60 then
            AnimationDelay = os.time()
        end
        if ScriptStorage.PlayerData.Level and ScriptStorage.PlayerData.Level > 0 then
            local J, r = xpcall(RefreshTasksData, debug.traceback)
            if not J then 
                print('[ Error ]', r)
                task.wait(1)
            end
        else
            task.wait(1)
            pcall(RefreshPlayerData)
        end
    end
end

-- ============================================================
-- 💖 STEPCONTROL HUB X KAITUN ULTIMATE UI
-- ============================================================
task.spawn(function()
    local ok, err = xpcall(hoangtuveu, debug.traceback)
    if not ok then
        warn("[StepControl] Logic Error:", err)
    end
end)

task.wait(2)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local GUI_NAME = "STEPCONTROL_HUB_X_KAITUN"

local Theme = {
    Background = Color3.fromRGB(7, 4, 9),
    Header = Color3.fromRGB(16, 7, 17),
    Panel = Color3.fromRGB(23, 9, 24),
    PanelHover = Color3.fromRGB(30, 11, 31),
    Pink = Color3.fromRGB(255, 65, 155),
    PinkLight = Color3.fromRGB(255, 125, 195),
    White = Color3.fromRGB(248, 241, 247),
    Gray = Color3.fromRGB(173, 151, 168),
    Green = Color3.fromRGB(130, 230, 140),
    Red = Color3.fromRGB(245, 75, 105),
    Border = Color3.fromRGB(91, 27, 65),
}

local TweenFast = TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TweenNormal = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TweenOpen = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TweenPulse = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

local Old = PlayerGui:FindFirstChild(GUI_NAME)
if Old then Old:Destroy() end

local function New(Class, Properties, Parent)
    local Object = Instance.new(Class)
    for Property, Value in pairs(Properties or {}) do Object[Property] = Value end
    Object.Parent = Parent
    return Object
end

local function Corner(Object, Radius)
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, Radius)
    C.Parent = Object
    return C
end

local function Stroke(Object, Color, Thickness, Transparency)
    local S = Instance.new("UIStroke")
    S.Color = Color or Theme.Border
    S.Thickness = Thickness or 1
    S.Transparency = Transparency or 0
    S.Parent = Object
    return S
end

local Gui = New("ScreenGui", {
    Name = GUI_NAME,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100,
}, PlayerGui)

local OpenButton = New("TextButton", {
    Name = "OpenButton",
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 18, 0.5, 0),
    Size = UDim2.fromOffset(55, 55),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    Text = "S",
    TextColor3 = Theme.PinkLight,
    Font = Enum.Font.GothamBlack,
    TextSize = 23,
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 50,
}, Gui)

Corner(OpenButton, 16)
local OpenGlow = Stroke(OpenButton, Theme.Pink, 2, 0.65)
TweenService:Create(OpenGlow, TweenPulse, {Transparency = 0.15}):Play()

local Main = New("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.88, 0.84),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 10,
}, Gui)
Corner(Main, 15)
Stroke(Main, Theme.Border, 1.2, 0.05)

local Header = New("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 65),
    BackgroundColor3 = Theme.Header,
    BorderSizePixel = 0,
    ZIndex = 20,
}, Main)

local Title = New("TextLabel", {
    Position = UDim2.new(0, 21, 0, 7),
    Size = UDim2.new(0.7, 0, 0, 28),
    BackgroundTransparency = 1,
    Text = "STEPCONTROL HUB X KAITUN",
    TextColor3 = Theme.White,
    Font = Enum.Font.GothamBlack,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 25,
}, Header)

local Subtitle = New("TextLabel", {
    Position = UDim2.new(0, 22, 0, 36),
    Size = UDim2.new(0.7, 0, 0, 18),
    BackgroundTransparency = 1,
    Text = "⚡ AUTO FARM RUNNING",
    TextColor3 = Theme.PinkLight,
    Font = Enum.Font.GothamMedium,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 25,
}, Header)

local function WindowButton(Text, X, Background)
    local Button = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, X, 0.5, 0),
        Size = UDim2.fromOffset(31, 31),
        BackgroundColor3 = Background,
        BorderSizePixel = 0,
        Text = Text,
        TextColor3 = Theme.White,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        AutoButtonColor = false,
        ZIndex = 30,
    }, Header)
    Corner(Button, 10)
    return Button
end

local Minimize = WindowButton("—", -54, Color3.fromRGB(48, 25, 52))
local Close = WindowButton("×", -16, Color3.fromRGB(61, 22, 39))

local Scroll = New("ScrollingFrame", {
    Name = "Content",
    Position = UDim2.new(0, 8, 0, 72),
    Size = UDim2.new(1, -16, 1, -80),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Theme.Pink,
    ScrollBarImageTransparency = 0.1,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ElasticBehavior = Enum.ElasticBehavior.Always,
    ZIndex = 15,
}, Main)

local Columns = New("Frame", {
    Name = "Columns",
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    ZIndex = 15,
}, Scroll)

local ColumnLayout = New("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    Padding = UDim.new(0, 12),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, Columns)

local Left = New("Frame", {Size = UDim2.new(0.48, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 15}, Columns)
local Right = New("Frame", {Size = UDim2.new(0.48, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 15}, Columns)
for _, Column in ipairs({Left, Right}) do
    New("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, Column)
end

local SectionIndex = 0
local function Section(Parent, SectionName)
    SectionIndex += 1
    local Frame = New("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.Panel, BorderSizePixel = 0, ZIndex = 18}, Parent)
    Corner(Frame, 9)
    Stroke(Frame, Theme.Border, 1, 0.2)
    local Accent = New("Frame", {Position = UDim2.new(0, 11, 0, 11), Size = UDim2.fromOffset(3, 18), BackgroundColor3 = Theme.Pink, BorderSizePixel = 0, ZIndex = 20}, Frame)
    Corner(Accent, 2)
    local Label = New("TextLabel", {Position = UDim2.new(0, 22, 0, 8), Size = UDim2.new(1, -32, 0, 24), BackgroundTransparency = 1, Text = string.upper(SectionName), TextColor3 = Theme.PinkLight, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 20}, Frame)
    local Content = New("Frame", {Position = UDim2.new(0, 12, 0, 37), Size = UDim2.new(1, -24, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 20}, Frame)
    New("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}, Content)
    return Content
end

local function InfoRow(Parent, Name, Value)
    local Row = New("Frame", {Size = UDim2.new(1, 0, 0, 29), BackgroundTransparency = 1, ZIndex = 22}, Parent)
    New("TextLabel", {Size = UDim2.new(0.52, 0, 1, 0), BackgroundTransparency = 1, Text = Name, TextColor3 = Theme.Gray, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 23}, Row)
    local ValueLabel = New("TextLabel", {Position = UDim2.new(0.52, 0, 0, 0), Size = UDim2.new(0.48, 0, 1, 0), BackgroundTransparency = 1, Text = Value, TextColor3 = Theme.White, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 23}, Row)
    return ValueLabel
end

-- BUILD UI
local Time = Section(Left, "Time")
local PlayTimeLabel = InfoRow(Time, "Play Time", "00h 00m 00s")

local Status = Section(Left, "Status")
local WorldLabel = InfoRow(Status, "World", "1")
local FruitLabel = InfoRow(Status, "Fruit", "—")

local Currencies = Section(Left, "Currencies")
local LevelLabel = InfoRow(Currencies, "Level", "0")
local BeliLabel = InfoRow(Currencies, "Beli", "0")
local FragmentsLabel = InfoRow(Currencies, "Fragments", "0")
local BonesLabel = InfoRow(Currencies, "Bones", "0")

local AutoFarmSection = Section(Right, "Auto Farm")
local AutoFarmLabel = InfoRow(AutoFarmSection, "Status", "✅ Running")
local FarmStatusLabel = InfoRow(AutoFarmSection, "Task", "Idle")

local MiscSection = Section(Right, "Miscellaneous")
local AutoSea2Label = InfoRow(MiscSection, "Auto Sea 2", "✅ Active")
local AutoSea3Label = InfoRow(MiscSection, "Auto Sea 3", "✅ Active")
local AutoHopLabel = InfoRow(MiscSection, "Auto Hop", "✅ Active")
local LowGraphLabel = InfoRow(MiscSection, "Low Graphics", "✅ On")

local Dragging, DragStart, StartPosition = false, nil, nil
Header.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position
    end
end)
Header.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
end)
UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then return end
    if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end
    local Delta = Input.Position - DragStart
    Main.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
end)

local Minimized, FullSize = false, Main.Size
Minimize.MouseButton1Click:Connect(function()
    if Minimized then return end
    Minimized = true
    Scroll.Visible = false
    TweenService:Create(Main, TweenNormal, {Size = UDim2.new(FullSize.X.Scale, FullSize.X.Offset, 0, 65)}):Play()
end)
Close.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TweenNormal, {Size = UDim2.fromScale(0, 0)}):Play()
    task.wait(0.3)
    Main.Visible = false
    OpenButton.Visible = true
    OpenButton.Size = UDim2.fromOffset(0, 0)
    TweenService:Create(OpenButton, TweenNormal, {Size = UDim2.fromOffset(55, 55)}):Play()
end)
OpenButton.MouseButton1Click:Connect(function()
    OpenButton.Visible = false
    Main.Visible = true
    if Minimized then Minimized = false Scroll.Visible = true end
    Main.Size = UDim2.fromScale(0, 0)
    TweenService:Create(Main, TweenOpen, {Size = FullSize}):Play()
end)

Main.Size = UDim2.fromScale(0, 0)
task.wait(0.1)
TweenService:Create(Main, TweenOpen, {Size = FullSize}):Play()

local FarmingStatus = "🟢 Running"
local StartTime = os.time()
local AutoFarmEnabled = true

local function UpdateUI()
    pcall(function()
        if PlayTimeLabel then
            local elapsed = os.time() - StartTime
            PlayTimeLabel.Text = string.format("%02dh %02dm %02ds", math.floor(elapsed / 3600), math.floor((elapsed % 3600) / 60), elapsed % 60)
        end
        if ScriptStorage and ScriptStorage.PlayerData then
            if WorldLabel then WorldLabel.Text = tostring(ScriptStorage.PlayerData.Level or 0) >= 700 and "2" or (tostring(ScriptStorage.PlayerData.Level or 0) >= 1500 and "3" or "1") end
            if FruitLabel then FruitLabel.Text = ScriptStorage.PlayerData.DevilFruit or "—" end
            if LevelLabel then LevelLabel.Text = tostring(ScriptStorage.PlayerData.Level or 0) end
            if BeliLabel then BeliLabel.Text = tostring(ScriptStorage.PlayerData.Beli or 0) end
            if FragmentsLabel then FragmentsLabel.Text = tostring(ScriptStorage.PlayerData.Fragments or 0) end
        end
        if ScriptStorage and ScriptStorage.Backpack then
            if BonesLabel then
                local bones = ScriptStorage.Backpack["Bones"]
                BonesLabel.Text = bones and tostring(bones.Count) or "0"
            end
        end
        if AutoFarmLabel then
            AutoFarmLabel.Text = AutoFarmEnabled and "✅ Running" or "❌ Disabled"
            AutoFarmLabel.TextColor3 = AutoFarmEnabled and Theme.Green or Theme.Red
        end
        if FarmStatusLabel then
            local taskName = ScriptStorage and ScriptStorage.Task and ScriptStorage.Task.MainTask
            FarmStatusLabel.Text = taskName or "Idle"
        end
        if LowGraphLabel then LowGraphLabel.Text = Config.Configuration.LowGraphics and "✅ On" or "❌ Off" end
        if AutoSea2Label then AutoSea2Label.Text = Config.AutoSea2 and "✅ Active" or "❌ Off" end
        if AutoSea3Label then AutoSea3Label.Text = Config.AutoSea3 and "✅ Active" or "❌ Off" end
        if AutoHopLabel then AutoHopLabel.Text = Config.Configuration.AutoHop and "✅ Active" or "❌ Off" end
    end)
end

task.spawn(function() while task.wait(1) do pcall(UpdateUI) end end)

print("✅ STEPCONTROL HUB X KAITUN - ULTIMATE UI LOADED!")
print("💖 UI Connected to Kaitun Logic")
print("⚡ Auto Farm is running automatically!")
