-- PREMIUM HUB | BLOX FRUITS
-- WORKING 100% FOR DELTA EXECUTOR

-- 🔥 โหลด Rayfield ก่อนทุกอย่าง
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ✅ รอ Character โหลด
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- ✅ รอ Data
local Data = LocalPlayer:WaitForChild("Data")
local Level = Data:WaitForChild("Level")
local Points = Data:WaitForChild("Points")

-- ✅ หา Remote Events แบบตรงๆ
local CommF_ = nil
local RegAttack = nil
local RegHit = nil

-- รอให้ Remote Events โหลด
for i = 1, 30 do
    pcall(function()
        -- หา CommF_
        local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if Remotes then
            CommF_ = Remotes:FindFirstChild("CommF_")
        end
        
        -- หา RegisterAttack และ RegisterHit
        local Modules = ReplicatedStorage:FindFirstChild("Modules")
        if Modules then
            local Net = Modules:FindFirstChild("Net")
            if Net then
                RegAttack = Net:FindFirstChild("RE/RegisterAttack")
                RegHit = Net:FindFirstChild("RE/RegisterHit")
            end
        end
    end)
    
    if CommF_ and RegAttack and RegHit then
        print("✅ Found all remote events!")
        break
    end
    task.wait(0.5)
end

-- ถ้ายังไม่เจอ ให้ค้นหาแบบละเอียด
if not CommF_ or not RegAttack or not RegHit then
    print("🔍 Searching for remote events...")
    pcall(function()
        for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v.Name == "CommF_" then CommF_ = v end
            if v.Name == "RE/RegisterAttack" then RegAttack = v end
            if v.Name == "RE/RegisterHit" then RegHit = v end
        end
    end)
end

-- ถ้ายังไม่เจอ แจ้งเตือน
if not CommF_ then
    warn("❌ CommF_ not found!")
end
if not RegAttack then
    warn("❌ RE/RegisterAttack not found!")
end
if not RegHit then
    warn("❌ RE/RegisterHit not found!")
end

local V3 = Vector3.new
local CF = CFrame.new

-- 📍 Monster Database - ใช้ชื่อให้ตรงกับในเกมเป๊ะๆ
local Sea1Monsters = {
   ["Bandit [Lv. 5]"] = {
       false,
       {
           V3(-2966.090087890625, 39.337005615234375, 2319.31103515625),
           V3(-2857.823974609375, 41.86199951171875, 2122.800048828125),
           V3(-2965.823974609375, 41.86199951171875, 2170.800048828125),
       }
   },
   ["Monkey [Lv. 14]"] = {
       false,
       {
           V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
           V3(-1202.5, 10.899993896484375, 278.8699951171875),
           V3(-1743.530029296875, 20.979995727539062, -91.27000427246094),
       }
   },
   ["Gorilla [Lv. 20]"] = {
       false,
       {
           V3(-1249.18994140625, 8.229995727539062, -456.19000244140625),
           V3(-1249.18994140625, 8.229995727539062, -549.6799926757812),
           V3(-1363.18994140625, 20.229995727539062, -486.19000244140625),
       }
   },
   ["Pirate [Lv. 35]"] = {
       false,
       {
           V3(-1182.512939453125, 5.600006103515625, 3972.157958984375),
           V3(-1289.512939453125, 5.600006103515625, 3940.157958984375),
           V3(-1140.512939453125, 5.600006103515625, 3902.157958984375),
       }
   },
   ["Brute [Lv. 45]"] = {
       false,
       {
           V3(-862.8900146484375, 15.600006103515625, 4281.9560546875),
           V3(-979.7150268554688, 15.600006103515625, 4234.755859375),
           V3(-1048.6429443359375, 15.600006103515625, 4405.35888671875),
       }
   },
   ["Desert Bandit [Lv. 60]"] = {
       false,
       {
           V3(1001.0549926757812, 7.56500244140625, 4488.61083984375),
           V3(859.8150024414062, 7.56500244140625, 4488.06005859375),
           V3(931.7050170898438, 7.56500244140625, 4534.033203125),
       }
   },
   ["Desert Officer [Lv. 70]"] = {
       false,
       {
           V3(1664.676025390625, 14.748001098632812, 4317.791015625),
           V3(1578.365966796875, 3.8849945068359375, 4299.23291015625),
           V3(1671.76904296875, 9.748001098632812, 4392.88818359375),
       }
   },
   ["Snow Bandit [Lv. 90]"] = {
       false,
       {
           V3(1273.748046875, 88.79000854492188, -1345.8399658203125),
           V3(1458.7080078125, 88.79000854492188, -1447.1500244140625),
           V3(1381.324951171875, 88.79000854492188, -1464.9429931640625),
       }
   },
   ["Snowman [Lv. 100]"] = {
       false,
       {
           V3(1190.0889892578125, 106.80999755859375, -1626.5810546875),
           V3(1148.2490234375, 106.80999755859375, -1429.3199462890625),
           V3(1035.97900390625, 106.80999755859375, -1489.3599853515625),
       }
   },
   ["Chief Petty Officer [Lv. 120]"] = {
       false,
       {
           V3(-4989.31298828125, 20.5, 3947.639892578125),
           V3(-5121.35107421875, 20.5, 4059.597900390625),
           V3(-4805.2421875, 20.5, 3993.881103515625),
       }
   },
   ["Sky Bandit [Lv. 150]"] = {
       false,
       {
           V3(-4860.96923828125, 277.9150085449219, -2904.906005859375),
           V3(-5081.96923828125, 277.9150085449219, -2938.906005859375),
           V3(-4944.96923828125, 277.9150085449219, -2784.906005859375),
       }
   },
   ["Dark Master [Lv. 175]"] = {
       false,
       {
           V3(-5244.18017578125, 389.5, -2155.013916015625),
           V3(-5234.18017578125, 389.5, -2367.013916015625),
           V3(-5171.18017578125, 389.5, -2243.013916015625),
       }
   },
   ["Prisoner [Lv. 190]"] = {
       false,
       {
           V3(5224.7568359375, -0.3000030517578125, 449.4490051269531),
           V3(4937.31884765625, -0.5, 649.5750122070312),
           V3(5067.125, -0.3000030517578125, 546.4660034179688),
       }
   },
   ["Dangerous Prisoner [Lv. 210]"] = {
       false,
       {
           V3(4955.9150390625, -0.5, 925.530029296875),
           V3(5645.55712890625, -0.5, 764.614013671875),
           V3(5485.283203125, -0.5, 468.0660095214844),
       }
   },
   ["Toga Warrior [Lv. 250]"] = {
       false,
       {
           V3(-2128.410888671875, 7.878997802734375, -2853.248046875),
           V3(-1799.862060546875, 7.878997802734375, -2852.52490234375),
           V3(-1672.97900390625, 7.878997802734375, -2683.60498046875),
       }
   },
   ["Gladiator [Lv. 275]"] = {
       false,
       {
           V3(-1370.3580322265625, 7.9459991455078125, -3377.35888671875),
           V3(-1228.0870361328125, 7.9459991455078125, -3051.791015625),
           V3(-1125.071044921875, 7.9459991455078125, -3270.25),
       }
   },
   ["Military Soldier [Lv. 300]"] = {
       false,
       {
           V3(-5565.60205078125, 9.100006103515625, 8327.5693359375),
           V3(-5287.2001953125, 9.100006103515625, 8659.865234375),
           V3(-5413.60107421875, 9.100006103515625, 8591.2646484375),
       }
   },
   ["Military Spy [Lv. 325]"] = {
       false,
       {
           V3(-5857.30419921875, 78.5, 8775.9677734375),
           V3(-5917.7041015625, 78.5, 8844.5693359375),
           V3(-5806.701171875, 78.5, 8904.4697265625),
       }
   },
   ["Fishman Warrior [Lv. 375]"] = {
       false,
       {
           V3(60841.90234375, 17.949005126953125, 1651.1109619140625),
           V3(60840.90234375, 17.949005126953125, 1301.1109619140625),
           V3(60943.90234375, 17.949005126953125, 1744.1109619140625),
       }
   },
   ["Fishman Commando [Lv. 400]"] = {
       false,
       {
           V3(61785.90234375, 18.080001831054688, 1284.1109619140625),
           V3(62051.90234375, 18.080001831054688, 1422.1109619140625),
           V3(61760.8984375, 18.080001831054688, 1460.1109619140625),
       }
   },
   ["God's Guard [Lv. 450]"] = {
       false,
       {
           V3(-4830.60888671875, 844.135009765625, -1779.0909423828125),
           V3(-4616.88720703125, 844.135009765625, -2043.1910400390625),
           V3(-4583.8720703125, 843.1959838867188, -1938.4339599609375),
       }
   },
   ["Shanda [Lv. 475]"] = {
       false,
       {
           V3(-7725.43017578125, 5546.3408203125, -586.8939819335938),
           V3(-7710.76513671875, 5546.3408203125, -336.4460144042969),
           V3(-7564.56201171875, 5546.3408203125, -417.35198974609375),
       }
   },
   ["Royal Squad [Lv. 525]"] = {
       false,
       {
           V3(-7669.9501953125, 5606.93701171875, -1379.012939453125),
           V3(-7513.9501953125, 5606.93701171875, -1421.012939453125),
           V3(-7842.9501953125, 5606.93701171875, -1403.012939453125),
       }
   },
   ["Royal Soldier [Lv. 550]"] = {
       false,
       {
           V3(-7759.458984375, 5606.93701171875, -1862.7030029296875),
           V3(-7946.9501953125, 5606.93701171875, -1824.012939453125),
           V3(-7936.9501953125, 5606.93701171875, -1625.012939453125),
       }
   },
   ["Galley Pirate [Lv. 625]"] = {
       false,
       {
           V3(5348.283203125, 39.3489990234375, 3953.2548828125),
           V3(5654.0732421875, 39.3489990234375, 3914.322021484375),
           V3(5483.0732421875, 55.3489990234375, 4059.322021484375),
       }
   },
   ["Galley Captain [Lv. 650]"] = {
       false,
       {
           V3(5352.0078125, 39.3489990234375, 4929.39892578125),
           V3(5792.35400390625, 58.93499755859375, 4823.9228515625),
           V3(5584.0078125, 60.3489990234375, 4856.39892578125),
       }
   },
}

-- 📋 Quest Database
local QuestDB = {
   {Min=0,Max=9,Quest="MarineQuest1",Level=1,Mob="Bandit [Lv. 5]"},
   {Min=10,Max=19,Quest="JungleQuest",Level=1,Mob="Monkey [Lv. 14]"},
   {Min=20,Max=29,Quest="JungleQuest",Level=2,Mob="Gorilla [Lv. 20]"},
   {Min=30,Max=39,Quest="BuggyQuest1",Level=1,Mob="Pirate [Lv. 35]"},
   {Min=40,Max=59,Quest="BuggyQuest1",Level=2,Mob="Brute [Lv. 45]"},
   {Min=60,Max=74,Quest="DesertQuest",Level=1,Mob="Desert Bandit [Lv. 60]"},
   {Min=75,Max=89,Quest="DesertQuest",Level=2,Mob="Desert Officer [Lv. 70]"},
   {Min=90,Max=99,Quest="SnowQuest",Level=1,Mob="Snow Bandit [Lv. 90]"},
   {Min=100,Max=119,Quest="SnowQuest",Level=2,Mob="Snowman [Lv. 100]"},
   {Min=120,Max=149,Quest="MarineQuest2",Level=1,Mob="Chief Petty Officer [Lv. 120]"},
   {Min=150,Max=174,Quest="SkyQuest",Level=1,Mob="Sky Bandit [Lv. 150]"},
   {Min=175,Max=189,Quest="SkyQuest",Level=2,Mob="Dark Master [Lv. 175]"},
   {Min=190,Max=209,Quest="PrisonQuest",Level=1,Mob="Prisoner [Lv. 190]"},
   {Min=210,Max=249,Quest="PrisonQuest",Level=2,Mob="Dangerous Prisoner [Lv. 210]"},
   {Min=250,Max=274,Quest="ColosseumQuest",Level=1,Mob="Toga Warrior [Lv. 250]"},
   {Min=275,Max=299,Quest="ColosseumQuest",Level=2,Mob="Gladiator [Lv. 275]"},
   {Min=300,Max=324,Quest="MagmaQuest",Level=1,Mob="Military Soldier [Lv. 300]"},
   {Min=325,Max=374,Quest="MagmaQuest",Level=2,Mob="Military Spy [Lv. 325]"},
   {Min=375,Max=399,Quest="FishmanQuest",Level=1,Mob="Fishman Warrior [Lv. 375]"},
   {Min=400,Max=449,Quest="FishmanQuest",Level=2,Mob="Fishman Commando [Lv. 400]"},
   {Min=450,Max=474,Quest="SkyQuest2",Level=1,Mob="God's Guard [Lv. 450]"},
   {Min=475,Max=524,Quest="SkyQuest2",Level=2,Mob="Shanda [Lv. 475]"},
   {Min=525,Max=549,Quest="FountainQuest",Level=1,Mob="Royal Squad [Lv. 525]"},
   {Min=550,Max=624,Quest="FountainQuest",Level=2,Mob="Royal Soldier [Lv. 550]"},
   {Min=625,Max=649,Quest="FountainQuest",Level=3,Mob="Galley Pirate [Lv. 625]"},
   {Min=650,Max=699,Quest="FountainQuest",Level=3,Mob="Galley Captain [Lv. 650]"},
}

-- ⚔️ Weapon System
local SelectedWeapon = nil

local function GetWeaponType(Tool)
    if not Tool or not Tool:IsA("Tool") then return nil end
    
    local attr = Tool:GetAttribute("WeaponType")
    if typeof(attr) == "string" and attr ~= "" then
        return attr
    end
    
    local typeVal = Tool:FindFirstChild("Type")
    if typeVal and typeVal:IsA("StringValue") then
        return typeVal.Value
    end
    
    return nil
end

local function ScanWeapons()
    local list = {}
    local seen = {}
    
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if bp then
        for _,v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") then
                local wt = GetWeaponType(v)
                if wt and not seen[v.Name] then
                    seen[v.Name] = true
                    table.insert(list, {Name=v.Name, Type=wt})
                end
            end
        end
    end
    
    if Character then
        for _,v in ipairs(Character:GetChildren()) do
            if v:IsA("Tool") then
                local wt = GetWeaponType(v)
                if wt and not seen[v.Name] then
                    seen[v.Name] = true
                    table.insert(list, {Name=v.Name, Type=wt})
                end
            end
        end
    end
    
    table.sort(list, function(a,b) return a.Name < b.Name end)
    
    local names = {}
    for _,w in ipairs(list) do
        names[#names+1] = w.Name .. " [" .. w.Type .. "]"
    end
    if #names == 0 then names[1] = "None" end
    return names
end

local function EquipWeapon(name)
    if not name or name == "None" then return false end
    
    if Character and Character:FindFirstChild(name) then
        return true
    end
    
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if bp then
        for _,v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") and v.Name == name then
                if Humanoid then
                    pcall(function()
                        Humanoid:EquipTool(v)
                    end)
                    return true
                end
            end
        end
    end
    return false
end

local function KeepWeaponEquipped()
    if SelectedWeapon and SelectedWeapon ~= "None" and Character and Humanoid then
        if not Character:FindFirstChild(SelectedWeapon) then
            EquipWeapon(SelectedWeapon)
        end
    end
end

local function GetQuestForLevel(lvl)
    if lvl >= 0 and lvl <= 9 then
        return {Min=0,Max=9,Quest="MarineQuest1",Level=1,Mob="Bandit [Lv. 5]"}
    end
    
    for _,v in ipairs(QuestDB) do
        if lvl >= v.Min and lvl <= v.Max then
            return v
        end
    end
    return nil
end

-- 📊 สถานะ
local S = {
    Farm = false,
    Speed = 325,
    Height = 40,
    Stats = {Melee=false,Defense=false,Sword=false,Gun=false,Fruit=false},
    TargetPos = nil,
    CurrentMob = "",
    IsTweening = false,
    AttackCombo = 1,
    QuestAccepted = false,
    CurrentSpawnIndex = 1,
}

-- 🎨 UI
local Window = Rayfield:CreateWindow({
    Name = "PREMIUM HUB",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Delta Mobile",
    Theme = "Default",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
})

local FarmTab = Window:CreateTab("Auto Farm")
local StatsTab = Window:CreateTab("Stats")
local SettingsTab = Window:CreateTab("Settings")

-- Weapon Dropdown
local function RefreshWeaponList()
    local names = ScanWeapons()
    WepDrop:Refresh(names)
    if #names > 0 then
        local first = names[1]:match("^(.-) %[")
        if first then
            SelectedWeapon = first:gsub("%s+$", "")
        else
            SelectedWeapon = names[1]
        end
    end
end

local WepNames = ScanWeapons()
local WepDrop = FarmTab:CreateDropdown({
    Name = "Weapon Selector",
    Options = WepNames,
    CurrentOption = WepNames[1] or "None",
    Flag = "WeaponSelector",
    Callback = function(opt)
        local name = opt:match("^(.-) %[")
        if name then
            SelectedWeapon = name:gsub("%s+$", "")
        else
            SelectedWeapon = opt
        end
        EquipWeapon(SelectedWeapon)
    end,
})

FarmTab:CreateButton({
    Name = "Refresh Weapons",
    Callback = function()
        RefreshWeaponList()
    end,
})

FarmTab:CreateToggle({
    Name = "Main Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(v)
        S.Farm = v
        if not v then
            S.TargetPos = nil
            S.CurrentMob = ""
            S.IsTweening = false
            S.QuestAccepted = false
            S.CurrentSpawnIndex = 1
        end
    end,
})

StatsTab:CreateToggle({Name="Auto Melee",CurrentValue=false,Flag="Melee",Callback=function(v) S.Stats.Melee=v end})
StatsTab:CreateToggle({Name="Auto Defense",CurrentValue=false,Flag="Defense",Callback=function(v) S.Stats.Defense=v end})
StatsTab:CreateToggle({Name="Auto Sword",CurrentValue=false,Flag="Sword",Callback=function(v) S.Stats.Sword=v end})
StatsTab:CreateToggle({Name="Auto Gun",CurrentValue=false,Flag="Gun",Callback=function(v) S.Stats.Gun=v end})
StatsTab:CreateToggle({Name="Auto Blox Fruit",CurrentValue=false,Flag="Fruit",Callback=function(v) S.Stats.Fruit=v end})

SettingsTab:CreateSlider({
    Name="Tween Speed",Range={250,400},Increment=5,CurrentValue=325,Flag="TweenSpeed",
    Callback=function(v) S.Speed=v end,
})
SettingsTab:CreateSlider({
    Name="Farm Height",Range={20,60},Increment=1,CurrentValue=40,Flag="FarmHeight",
    Callback=function(v) S.Height=v end,
})

-- 🛡️ Noclip
local NoclipCon = nil
local function SetNoclip(on)
    if NoclipCon then NoclipCon:Disconnect() NoclipCon = nil end
    if on and Character then
        NoclipCon = RunService.Stepped:Connect(function()
            if Character then
                for _,p in ipairs(Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end
end

-- 🏃 Main Farm Loop
task.spawn(function()
    while task.wait(0.15) do
        if not S.Farm or not Character or not HRP then
            SetNoclip(false)
            continue
        end
        
        pcall(function()
            SetNoclip(true)
            
            local q = GetQuestForLevel(Level.Value)
            if not q then return end
            
            -- ✅ รับเควส
            if not S.QuestAccepted then
                if CommF_ then
                    pcall(function()
                        CommF_:InvokeServer("StartQuest", q.Quest, q.Level)
                    end)
                    S.QuestAccepted = true
                    S.CurrentMob = q.Mob
                    S.CurrentSpawnIndex = 1
                    print("✅ Quest accepted: " .. q.Quest)
                end
                task.wait(0.5)
                return
            end
            
            -- 📍 หา spawn mob
            local mobData = Sea1Monsters[S.CurrentMob]
            if not mobData or not mobData[2] or #mobData[2] == 0 then
                S.QuestAccepted = false
                return
            end
            
            local spawns = mobData[2]
            if #spawns == 0 then
                S.QuestAccepted = false
                return
            end
            
            if S.CurrentSpawnIndex > #spawns then
                S.CurrentSpawnIndex = 1
            end
            
            local targetPos = spawns[S.CurrentSpawnIndex]
            if not targetPos then return end
            
            local targetCF = CF(targetPos + V3(0, S.Height, 0))
            S.TargetPos = targetPos + V3(0, S.Height, 0)
            
            -- 🚀 Tween
            if not S.IsTweening then
                local dist = (HRP.Position - targetCF.Position).Magnitude
                if dist > 2 then
                    S.IsTweening = true
                    local t = math.min(dist / S.Speed, 1.5)
                    local tw = TweenService:Create(HRP, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame=targetCF})
                    tw:Play()
                    tw.Completed:Wait()
                    S.IsTweening = false
                    S.CurrentSpawnIndex = S.CurrentSpawnIndex + 1
                else
                    S.CurrentSpawnIndex = S.CurrentSpawnIndex + 1
                end
            end
        end)
    end
end)

-- 🧊 Physics Stabilizer
task.spawn(function()
    while task.wait(0.02) do
        if not S.Farm or S.IsTweening or not Character or not HRP then continue end
        
        pcall(function()
            if S.TargetPos then
                HRP.CFrame = CF(S.TargetPos)
                HRP.Velocity = V3(0,0,0)
                HRP.AssemblyLinearVelocity = V3(0,0,0)
                HRP.RotVelocity = V3(0,0,0)
                if Humanoid then
                    Humanoid.Sit = false
                    Humanoid.PlatformStand = false
                end
            end
        end)
    end
end)

-- ⚔️ Mob Stack & Attack - สำคัญที่สุด!
task.spawn(function()
    while task.wait(0.01) do
        if not S.Farm or S.IsTweening or not Character or not HRP then continue end
        
        pcall(function()
            local currentMob = S.CurrentMob
            if currentMob == "" then return end
            
            local enemies = Workspace:FindFirstChild("Enemies")
            if not enemies then return end
            
            local mobsToAttack = {}
            
            for _,e in ipairs(enemies:GetChildren()) do
                if e.Name == currentMob and e:FindFirstChild("Humanoid") and e:FindFirstChild("HumanoidRootPart") then
                    local humanoid = e.Humanoid
                    if humanoid.Health > 0 then
                        table.insert(mobsToAttack, e)
                        
                        local h = e.HumanoidRootPart
                        local targetPos = HRP.Position + V3(0, -5, 0)
                        h.CFrame = CF(targetPos)
                        h.CanCollide = false
                        h.Velocity = V3(0,0,0)
                        h.AssemblyLinearVelocity = V3(0,0,0)
                        humanoid.WalkSpeed = 0
                        humanoid.JumpPower = 0
                    end
                end
            end
            
            -- 🔥 โจมตี!
            if #mobsToAttack > 0 then
                if RegAttack then
                    pcall(function()
                        RegAttack:FireServer(0.5, S.AttackCombo)
                        S.AttackCombo = S.AttackCombo == 1 and 2 or 1
                    end)
                end
                
                if RegHit then
                    for _,e in ipairs(mobsToAttack) do
                        local part = e:FindFirstChild("HumanoidRootPart")
                        if part then
                            pcall(function()
                                RegHit:FireServer(part, {})
                            end)
                        end
                    end
                end
            end
        end)
    end
end)

-- 🔄 Auto Equip
task.spawn(function()
    while task.wait(0.3) do
        if S.Farm and SelectedWeapon and SelectedWeapon ~= "None" then
            pcall(KeepWeaponEquipped)
        end
    end
end)

-- 📊 Auto Stats
task.spawn(function()
    while task.wait() do
        if Points.Value > 0 then
            local activeStat = nil
            for stat,en in pairs(S.Stats) do
                if en then
                    activeStat = stat
                    break
                end
            end
            
            if activeStat then
                local s = activeStat == "Fruit" and "Demon Fruit" or activeStat
                while Points.Value > 0 do
                    pcall(function()
                        if CommF_ then
                            CommF_:InvokeServer("AddPoint", s, 1)
                        end
                    end)
                    task.wait(0.05)
                end
            end
        end
        task.wait(0.1)
    end
end)

-- 🔍 Check mob death
task.spawn(function()
    while task.wait(0.5) do
        if not S.Farm then continue end
        
        pcall(function()
            local currentMob = S.CurrentMob
            if currentMob == "" then return end
            
            local enemies = Workspace:FindFirstChild("Enemies")
            if not enemies then
                S.QuestAccepted = false
                return
            end
            
            local alive = false
            for _,e in ipairs(enemies:GetChildren()) do
                if e.Name == currentMob and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                    alive = true
                    break
                end
            end
            
            if not alive then
                S.QuestAccepted = false
                S.CurrentMob = ""
                S.CurrentSpawnIndex = 1
                print("🔄 All mobs dead, re-questing...")
            end
        end)
    end
end)

-- 🔄 Character respawn
LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid")
    HRP = c:WaitForChild("HumanoidRootPart")
    if S.Farm then SetNoclip(true) end
    S.QuestAccepted = false
    S.CurrentMob = ""
    S.TargetPos = nil
    S.IsTweening = false
    S.CurrentSpawnIndex = 1
end)

-- ✅ แจ้งเตือน
Rayfield:Notify({Title="✅ Premium Hub",Content="Script Loaded! Enable Auto Farm.",Duration=5})
print("🔥 Premium Hub loaded successfully!")
print("📌 Enable Auto Farm to start farming!")
