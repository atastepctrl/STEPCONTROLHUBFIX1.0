-- PREMIUM HUB | BLOX FRUITS
-- WORKING 100% - แค่เปลี่ยนชื่อ NPC/Monster ตามที่คุณหาได้

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ✅ รอ Character
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- ✅ รอ Data
local Data = LocalPlayer:WaitForChild("Data")
local Level = Data:WaitForChild("Level")
local Points = Data:WaitForChild("Points")

-- ✅ หา Remote Events
local CommF_ = nil
local RegAttack = nil
local RegHit = nil

for i = 1, 30 do
    pcall(function()
        local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if Remotes then
            CommF_ = Remotes:FindFirstChild("CommF_")
        end
        
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

local V3 = Vector3.new
local CF = CFrame.new

-- ⚙️ ตั้งค่าตามที่คุณหาได้ (แก้ไขตรงนี้!)
local CONFIG = {
    -- เกาะเริ่มต้น (Level 1-9)
    [1] = {
        NPC = "Bandit Quest Giver",  -- ชื่อ NPC รับเควส
        Mob = "Bandit",               -- ชื่อมอนสเตอร์
        Quest = "MarineQuest1",
        Level = 1,
        MinLevel = 0,
        MaxLevel = 9,
        Spawns = {
            V3(-2966.090087890625, 39.337005615234375, 2319.31103515625),
            V3(-2857.823974609375, 41.86199951171875, 2122.800048828125),
        }
    },
    -- เกาะป่า (Level 10-29)
    [2] = {
        NPC = "Adventurer",           -- ชื่อ NPC รับเควส (คุณบอกมา)
        Mob = "Monkey",               -- ชื่อมอนสเตอร์ (Level 10-19)
        Quest = "JungleQuest",
        Level = 1,
        MinLevel = 10,
        MaxLevel = 19,
        Spawns = {
            V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
            V3(-1202.5, 10.899993896484375, 278.8699951171875),
        }
    },
    -- เกาะป่า (Level 20-29)
    [3] = {
        NPC = "Adventurer",           -- ชื่อ NPC รับเควส
        Mob = "Gorilla",              -- ชื่อมอนสเตอร์ (Level 20-29)
        Quest = "JungleQuest",
        Level = 2,
        MinLevel = 20,
        MaxLevel = 29,
        Spawns = {
            V3(-1249.18994140625, 8.229995727539062, -456.19000244140625),
            V3(-1363.18994140625, 20.229995727539062, -486.19000244140625),
        }
    },
}

-- 🔍 ฟังก์ชันหา Config ตาม Level
local function GetConfig(level)
    for _, config in pairs(CONFIG) do
        if level >= config.MinLevel and level <= config.MaxLevel then
            return config
        end
    end
    return CONFIG[1] -- ค่าเริ่มต้น
end

-- ฟังก์ชันหา NPC
local function FindNPC(npcName)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == npcName then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hrp then
                return hrp
            end
        end
    end
    return nil
end

-- ⚔️ Weapon System
local SelectedWeapon = nil

local function GetWeaponType(Tool)
    if not Tool or not Tool:IsA("Tool") then return nil end
    local attr = Tool:GetAttribute("WeaponType")
    if typeof(attr) == "string" and attr ~= "" then return attr end
    local typeVal = Tool:FindFirstChild("Type")
    if typeVal and typeVal:IsA("StringValue") then return typeVal.Value end
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
    if Character and Character:FindFirstChild(name) then return true end
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if bp then
        for _,v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") and v.Name == name then
                if Humanoid then
                    pcall(function() Humanoid:EquipTool(v) end)
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

-- 📊 สถานะ
local S = {
    Farm = false,
    Speed = 325,
    Height = 40,
    Stats = {Melee=false,Defense=false,Sword=false,Gun=false,Fruit=false},
    TargetPos = nil,
    CurrentMob = "",
    IsMoving = false,
    AttackCombo = 1,
    QuestAccepted = false,
    CurrentSpawnIndex = 1,
    CurrentConfig = nil,
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
            S.IsMoving = false
            S.QuestAccepted = false
            S.CurrentConfig = nil
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
            
            -- หา Config ตาม Level
            local config = GetConfig(Level.Value)
            if not config then
                print("❌ No config for level:", Level.Value)
                return
            end
            
            -- ถ้า Config เปลี่ยน ให้รีเซ็ต
            if S.CurrentConfig ~= config then
                S.CurrentConfig = config
                S.QuestAccepted = false
                S.CurrentMob = config.Mob
                S.CurrentSpawnIndex = 1
                print("📌 Switched to:", config.Mob, "with NPC:", config.NPC)
            end
            
            -- 📌 รับเควส
            if not S.QuestAccepted then
                if CommF_ then
                    -- หา NPC และบินไปหา
                    local npc = FindNPC(config.NPC)
                    if npc then
                        local npcPos = npc.Position
                        local targetCF = CF(npcPos + V3(0, 3, 0))
                        local dist = (HRP.Position - targetCF.Position).Magnitude
                        
                        if dist > 5 then
                            local t = math.min(dist / S.Speed, 2)
                            local tw = TweenService:Create(HRP, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame=targetCF})
                            tw:Play()
                            tw.Completed:Wait()
                        end
                        
                        task.wait(0.5)
                    end
                    
                    pcall(function()
                        CommF_:InvokeServer("StartQuest", config.Quest, config.Level)
                    end)
                    S.QuestAccepted = true
                    S.CurrentMob = config.Mob
                    S.CurrentSpawnIndex = 1
                    print("✅ Quest accepted:", config.Quest)
                end
                task.wait(1)
                return
            end
            
            -- 📍 หาตำแหน่งมอน
            local spawns = config.Spawns
            if not spawns or #spawns == 0 then
                S.QuestAccepted = false
                return
            end
            
            if S.CurrentSpawnIndex > #spawns then
                S.CurrentSpawnIndex = 1
            end
            
            local targetPos = spawns[S.CurrentSpawnIndex]
            if not targetPos then return end
            
            local height = S.Height or 40
            local targetCF = CF(targetPos + V3(0, height, 0))
            S.TargetPos = targetPos + V3(0, height, 0)
            
            -- 🚀 บินไปที่ตำแหน่ง
            local dist = (HRP.Position - targetCF.Position).Magnitude
            if dist > 3 then
                local t = math.min(dist / S.Speed, 2)
                local tw = TweenService:Create(HRP, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame=targetCF})
                tw:Play()
                tw.Completed:Wait()
                S.CurrentSpawnIndex = S.CurrentSpawnIndex + 1
            else
                S.CurrentSpawnIndex = S.CurrentSpawnIndex + 1
            end
            
            -- 🧊 รักษาตำแหน่ง
            if S.TargetPos then
                HRP.CFrame = CF(S.TargetPos)
                HRP.Velocity = V3(0,0,0)
                HRP.AssemblyLinearVelocity = V3(0,0,0)
                if Humanoid then
                    Humanoid.Sit = false
                    Humanoid.PlatformStand = false
                end
            end
        end)
    end
end)

-- ⚔️ Mob Stack & Attack
task.spawn(function()
    while task.wait(0.02) do
        if not S.Farm or not Character or not HRP then continue end
        
        pcall(function()
            local currentMob = S.CurrentMob
            if currentMob == "" then return end
            
            local enemies = workspace:FindFirstChild("Enemies")
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
            
            -- 🔥 โจมตี
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
            
            local enemies = workspace:FindFirstChild("Enemies")
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
    S.IsMoving = false
    S.CurrentSpawnIndex = 1
    S.CurrentConfig = nil
end)

-- ✅ แจ้งเตือน
Rayfield:Notify({Title="✅ Premium Hub",Content="Script Loaded! Enable Auto Farm.",Duration=5})
print("🔥 Premium Hub loaded successfully!")
print("📌 Enable Auto Farm to start farming!")
print("📌 Current Level:", Level.Value)
