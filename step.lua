-- AUTO FARM BLOX FRUITS - FIXED ALL ISSUES
-- แก้ตามข้อ 1-10 ที่วิเคราะห์

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Character
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- Data
local Data = LocalPlayer:WaitForChild("Data")
local Level = Data:WaitForChild("Level")
local Points = Data:WaitForChild("Points")

-- Remote Events
local CommF_ = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("CommF_")
local RegAttack = ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Net"):FindFirstChild("RE/RegisterAttack")
local RegHit = ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Net"):FindFirstChild("RE/RegisterHit")

-- EquipEvent จาก Remote Spy: Workspace.Characters.[ชื่อ].Combat.EquipEvent
local EquipEvent = nil
local CharacterName = LocalPlayer.Name
local Characters = Workspace:FindFirstChild("Characters")
if Characters then
    local playerChar = Characters:FindFirstChild(CharacterName)
    if playerChar then
        local combat = playerChar:FindFirstChild("Combat")
        if combat then
            EquipEvent = combat:FindFirstChild("EquipEvent")
        end
    end
end

local V3 = Vector3.new
local CF = CFrame.new

-- ====== ข้อมูลจาก Workspace Dump (ใช้ชื่อเต็มตามในเกม) ======
-- ✅ ใช้ชื่อตาม dump: "Bandit [Lv. 5]", "Monkey [Lv. 14]" ฯลฯ
local MONSTERS = {
    ["Bandit [Lv. 5]"] = {
        Level = 5,
        Quest = "BanditQuest1",
        QuestLevel = 1,
        NPC = "Bandit Quest Giver",
        NPCPos = V3(1058.9923095703125, 12.710777282714844, 1551.7332763671875),
        -- ✅ แยก FarmPos ออกจาก NPCPos
        FarmPos = V3(1341.8013916015625, 14.971686363220215, 1568.908935546875),
    },
    ["Monkey [Lv. 14]"] = {
        Level = 14,
        Quest = "JungleQuest",
        QuestLevel = 1,
        NPC = "Adventurer",
        NPCPos = V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
        FarmPos = V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
    },
    ["Gorilla [Lv. 20]"] = {
        Level = 20,
        Quest = "JungleQuest",
        QuestLevel = 2,
        NPC = "Adventurer",
        NPCPos = V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
        FarmPos = V3(-1249.18994140625, 8.229995727539062, -456.19000244140625),
    },
    ["Pirate [Lv. 35]"] = {
        Level = 35,
        Quest = "BuggyQuest1",
        QuestLevel = 1,
        NPC = "Buggy Quest Giver",
        NPCPos = V3(-1182.512939453125, 5.600006103515625, 3972.157958984375),
        FarmPos = V3(-1182.512939453125, 5.600006103515625, 3972.157958984375),
    },
    ["Brute [Lv. 45]"] = {
        Level = 45,
        Quest = "BuggyQuest1",
        QuestLevel = 2,
        NPC = "Buggy Quest Giver",
        NPCPos = V3(-1182.512939453125, 5.600006103515625, 3972.157958984375),
        FarmPos = V3(-862.8900146484375, 15.600006103515625, 4281.9560546875),
    },
    ["Desert Bandit [Lv. 60]"] = {
        Level = 60,
        Quest = "DesertQuest",
        QuestLevel = 1,
        NPC = "Desert Quest Giver",
        NPCPos = V3(1001.0549926757812, 7.56500244140625, 4488.61083984375),
        FarmPos = V3(1001.0549926757812, 7.56500244140625, 4488.61083984375),
    },
    ["Desert Officer [Lv. 70]"] = {
        Level = 70,
        Quest = "DesertQuest",
        QuestLevel = 2,
        NPC = "Desert Quest Giver",
        NPCPos = V3(1001.0549926757812, 7.56500244140625, 4488.61083984375),
        FarmPos = V3(1664.676025390625, 14.748001098632812, 4317.791015625),
    },
}

-- ====== WEAPON SYSTEM ======
local SelectedWeapon = nil

local function ScanWeapons()
    local list = {}
    local seen = {}
    
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") and not seen[v.Name] then
                seen[v.Name] = true
                table.insert(list, v.Name)
            end
        end
    end
    
    if Character then
        for _, v in ipairs(Character:GetChildren()) do
            if v:IsA("Tool") and not seen[v.Name] then
                seen[v.Name] = true
                table.insert(list, v.Name)
            end
        end
    end
    
    table.sort(list)
    if #list == 0 then table.insert(list, "None") end
    return list
end

local function EquipWeapon(name)
    if not name or name == "None" then return false end
    if Character and Character:FindFirstChild(name) then return true end
    
    -- ✅ ใช้ EquipEvent ตาม path จาก Remote Spy
    if EquipEvent then
        pcall(function()
            EquipEvent:FireServer(true)
            task.wait(0.1)
        end)
    end
    
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
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

-- ====== FARM SYSTEM ======
local Farming = false
local QuestDone = false
local AttackCombo = 1
local FarmHeight = 30
local CurrentMob = nil
local CurrentFarmPos = nil
local AttackTimer = 0

-- ✅ แก้ GetMobByLevel: เลือกมอนที่เหมาะสมตาม Level
local function GetMobByLevel(lvl)
    local bestMob = nil
    local bestDiff = math.huge
    
    for name, data in pairs(MONSTERS) do
        if lvl <= data.Level then
            local diff = data.Level - lvl
            if diff < bestDiff then
                bestDiff = diff
                bestMob = data
            end
        end
    end
    
    -- ถ้าไม่มีมอนที่เหมาะสม ให้ใช้ Bandit
    return bestMob or MONSTERS["Bandit [Lv. 5]"]
end

local function Teleport(pos)
    if not HRP then return end
    pcall(function()
        HRP.CFrame = CF(pos + V3(0, FarmHeight, 0))
        HRP.Velocity = V3(0, 0, 0)
        HRP.AssemblyLinearVelocity = V3(0, 0, 0)
        HRP.RotVelocity = V3(0, 0, 0)
    end)
end

local function LockPosition()
    if not HRP or not CurrentFarmPos then return end
    pcall(function()
        local targetPos = CurrentFarmPos + V3(0, FarmHeight, 0)
        HRP.CFrame = CF(targetPos)
        HRP.Velocity = V3(0, 0, 0)
        HRP.AssemblyLinearVelocity = V3(0, 0, 0)
        HRP.RotVelocity = V3(0, 0, 0)
        if Humanoid then
            Humanoid.Sit = false
            Humanoid.PlatformStand = false
            Humanoid.WalkSpeed = 0
            Humanoid.JumpPower = 0
        end
    end)
end

local function AcceptQuest()
    if not CommF_ or not CurrentMob then return end
    pcall(function()
        CommF_:InvokeServer("StartQuest", CurrentMob.Quest, CurrentMob.QuestLevel)
        print("✅ รับเควส:", CurrentMob.Quest)
    end)
end

-- ====== ATTACK (ลดความถี่ลง) ======
local function AttackLoop()
    if not RegAttack or not RegHit or not CurrentMob then return end
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    local mobs = {}
    local mobName = CurrentMob.Name
    
    -- ✅ ใช้ชื่อเต็มตาม dump
    for _, e in ipairs(enemies:GetChildren()) do
        if e.Name == mobName and e:FindFirstChild("Humanoid") and e:FindFirstChild("HumanoidRootPart") then
            if e.Humanoid.Health > 0 then
                table.insert(mobs, e)
            end
        end
    end
    
    if #mobs == 0 then return end
    
    -- ✅ ไม่แก้ Physics มอนโดยตรง (ลดการรบกวน)
    -- แค่ดึงมอนมาใกล้ๆ ด้วย Velocity เบาๆ
    local centerPos = HRP.Position + V3(0, -FarmHeight, 0)
    
    for i, e in ipairs(mobs) do
        local part = e.HumanoidRootPart
        local angle = (i - 1) * (2 * math.pi / #mobs)
        local targetPos = centerPos + V3(math.cos(angle) * 2, 0, math.sin(angle) * 2)
        local direction = (targetPos - part.Position) * 1.5
        
        pcall(function()
            part.AssemblyLinearVelocity = direction
            part.Velocity = direction
        end)
    end
    
    -- ✅ Attack (ตาม Remote Spy: 0.5, 1)
    pcall(function()
        -- ลดจำนวนรอบลง (Remote Spy แค่ 1-2 รอบ)
        for i = 1, 3 do
            RegAttack:FireServer(0.5, AttackCombo)
            AttackCombo = AttackCombo == 1 and 2 or 1
        end
        
        for _, e in ipairs(mobs) do
            local part = e:FindFirstChild("HumanoidRootPart")
            if part then
                RegHit:FireServer(part, {})
            end
        end
    end)
end

-- ✅ CheckMobs ใช้ชื่อเต็ม
local function CheckMobs()
    if not CurrentMob then return true end
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return true end
    
    for _, e in ipairs(enemies:GetChildren()) do
        if e.Name == CurrentMob.Name and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
            return false
        end
    end
    return true
end

-- ====== UI ======
local Window = Rayfield:CreateWindow({
    Name = "PREMIUM HUB",
    LoadingTitle = "Loading...",
    Theme = "Default",
    DisableRayfieldPrompts = true,
})

local FarmTab = Window:CreateTab("Farm")

-- Weapon Dropdown
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
        local names = ScanWeapons()
        WepDrop:Refresh(names)
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "Farm",
    Callback = function(v)
        Farming = v
        if v then
            QuestDone = false
            CurrentMob = nil
            CurrentFarmPos = nil
            print("✅ เริ่มฟาร์ม!")
            print("📌 Level:", Level.Value)
        else
            print("⏹ หยุดฟาร์ม")
        end
    end,
})

-- Auto Stats (ชื่อตาม StarterGui)
FarmTab:CreateToggle({
    Name = "Auto Melee",
    CurrentValue = false,
    Flag = "AutoMelee",
    Callback = function(v) AutoMelee = v end,
})

FarmTab:CreateToggle({
    Name = "Auto Defense",
    CurrentValue = false,
    Flag = "AutoDefense",
    Callback = function(v) AutoDefense = v end,
})

FarmTab:CreateToggle({
    Name = "Auto Sword",
    CurrentValue = false,
    Flag = "AutoSword",
    Callback = function(v) AutoSword = v end,
})

FarmTab:CreateToggle({
    Name = "Auto Gun",
    CurrentValue = false,
    Flag = "AutoGun",
    Callback = function(v) AutoGun = v end,
})

FarmTab:CreateToggle({
    Name = "Auto Demon Fruit",
    CurrentValue = false,
    Flag = "AutoFruit",
    Callback = function(v) AutoFruit = v end,
})

FarmTab:CreateSlider({
    Name = "Farm Height",
    Range = {20, 60},
    Increment = 1,
    CurrentValue = 30,
    Flag = "Height",
    Callback = function(v)
        FarmHeight = v
    end,
})

-- ====== NOCLIP ======
local NoclipCon = nil
local function SetNoclip(on)
    if NoclipCon then NoclipCon:Disconnect() NoclipCon = nil end
    if on and Character then
        NoclipCon = RunService.Stepped:Connect(function()
            if Character then
                for _, p in ipairs(Character:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- ====== MAIN LOOPS ======

-- Farm Director
task.spawn(function()
    while task.wait(0.2) do
        if not Farming then
            SetNoclip(false)
            continue
        end
        
        pcall(function()
            SetNoclip(true)
            
            local newMob = GetMobByLevel(Level.Value)
            
            if CurrentMob ~= newMob then
                CurrentMob = newMob
                QuestDone = false
                CurrentFarmPos = CurrentMob.FarmPos
                print("🎯 ฟาร์ม:", CurrentMob.Name, "Level:", Level.Value)
            end
            
            if not CurrentMob then return end
            
            if not QuestDone then
                Teleport(CurrentMob.NPCPos)
                task.wait(0.5)
                AcceptQuest()
                QuestDone = true
                Teleport(CurrentMob.FarmPos)
                task.wait(0.3)
                return
            end
            
            if CurrentFarmPos then
                LockPosition()
            end
            
            if CheckMobs() then
                QuestDone = false
                Teleport(CurrentMob.NPCPos)
                task.wait(0.5)
            end
        end)
    end
end)

-- ✅ Attack Loop (ช้าลง)
task.spawn(function()
    while task.wait(0.05) do  -- ช้าลงจาก 0.005 เป็น 0.05
        if not Farming or not QuestDone or not CurrentMob then continue end
        pcall(AttackLoop)
    end
end)

-- Lock Position
task.spawn(function()
    while task.wait(0.02) do
        if not Farming or not QuestDone or not CurrentFarmPos then continue end
        pcall(LockPosition)
    end
end)

-- Auto Equip
task.spawn(function()
    while task.wait(0.3) do
        if Farming and SelectedWeapon and SelectedWeapon ~= "None" then
            pcall(KeepWeaponEquipped)
        end
    end
end)

-- ====== AUTO STATS ======
local AutoMelee = false
local AutoDefense = false
local AutoSword = false
local AutoGun = false
local AutoFruit = false

task.spawn(function()
    while task.wait(0.2) do  -- ช้าลง
        if Points.Value <= 0 then continue end
        
        local statsToAdd = {}
        if AutoMelee then table.insert(statsToAdd, "Melee") end
        if AutoDefense then table.insert(statsToAdd, "Defense") end
        if AutoSword then table.insert(statsToAdd, "Sword") end
        if AutoGun then table.insert(statsToAdd, "Gun") end
        if AutoFruit then table.insert(statsToAdd, "Demon Fruit") end
        
        if #statsToAdd == 0 then continue end
        
        for _, statName in ipairs(statsToAdd) do
            if Points.Value <= 0 then break end
            pcall(function()
                if CommF_ then
                    CommF_:InvokeServer("AddPoint", statName, 1)
                end
            end)
            task.wait(0.05)
        end
    end
end)

-- Character Respawn
LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid")
    HRP = c:WaitForChild("HumanoidRootPart")
    if Farming then
        task.wait(0.5)
        SetNoclip(true)
        QuestDone = false
        CurrentMob = nil
        CurrentFarmPos = nil
    end
end)

Rayfield:Notify({
    Title = "✅ PREMIUM HUB",
    Content = "เปิด Auto Farm เพื่อเริ่มฟาร์ม!",
    Duration = 5,
})

print("🔥 PREMIUM HUB LOADED!")
print("✅ แก้ไขตามข้อ 1-10 เรียบร้อย")
