-- AUTO FARM BLOX FRUITS - FULL VERSION
-- รวมทุกระบบที่แก้แล้ว

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

local V3 = Vector3.new
local CF = CFrame.new

-- ============================================================
-- 📌 DATA ALL ISLAND (Level 1 - 700+)
-- ============================================================
local IslandData = {
    -- เกาะเริ่มต้น (Level 1-9)
    [1] = {
        Name = "Bandit Island",
        MinLevel = 0,
        MaxLevel = 9,
        NPC = "Bandit Quest Giver",
        NPCPos = V3(1058.9923095703125, 12.710777282714844, 1551.7332763671875),
        Mob = "Bandit",
        Quest = "BanditQuest1",
        QuestLevel = 1,
        FarmPos = V3(1341.8013916015625, 14.971686363220215, 1568.908935546875) + V3(0, 30, 0),
    },
    -- เกาะป่า (Level 10-19)
    [2] = {
        Name = "Jungle Island",
        MinLevel = 10,
        MaxLevel = 19,
        NPC = "Adventurer",
        NPCPos = V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
        Mob = "Monkey",
        Quest = "JungleQuest",
        QuestLevel = 1,
        FarmPos = V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625) + V3(0, 30, 0),
    },
    -- เกาะป่า (Level 20-29)
    [3] = {
        Name = "Jungle Island",
        MinLevel = 20,
        MaxLevel = 29,
        NPC = "Adventurer",
        NPCPos = V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
        Mob = "Gorilla",
        Quest = "JungleQuest",
        QuestLevel = 2,
        FarmPos = V3(-1249.18994140625, 8.229995727539062, -456.19000244140625) + V3(0, 30, 0),
    },
    -- เกาะโจรสลัด (Level 30-39)
    [4] = {
        Name = "Pirate Island",
        MinLevel = 30,
        MaxLevel = 39,
        NPC = "Buggy Quest Giver",
        NPCPos = V3(-1182.512939453125, 5.600006103515625, 3972.157958984375),
        Mob = "Pirate",
        Quest = "BuggyQuest1",
        QuestLevel = 1,
        FarmPos = V3(-1182.512939453125, 5.600006103515625, 3972.157958984375) + V3(0, 30, 0),
    },
    -- เกาะโจรสลัด (Level 40-59)
    [5] = {
        Name = "Pirate Island",
        MinLevel = 40,
        MaxLevel = 59,
        NPC = "Buggy Quest Giver",
        NPCPos = V3(-1182.512939453125, 5.600006103515625, 3972.157958984375),
        Mob = "Brute",
        Quest = "BuggyQuest1",
        QuestLevel = 2,
        FarmPos = V3(-862.8900146484375, 15.600006103515625, 4281.9560546875) + V3(0, 30, 0),
    },
    -- ทะเลทราย (Level 60-74)
    [6] = {
        Name = "Desert Island",
        MinLevel = 60,
        MaxLevel = 74,
        NPC = "Desert Quest Giver",
        NPCPos = V3(1001.0549926757812, 7.56500244140625, 4488.61083984375),
        Mob = "Desert Bandit",
        Quest = "DesertQuest",
        QuestLevel = 1,
        FarmPos = V3(1001.0549926757812, 7.56500244140625, 4488.61083984375) + V3(0, 30, 0),
    },
    -- ทะเลทราย (Level 75-89)
    [7] = {
        Name = "Desert Island",
        MinLevel = 75,
        MaxLevel = 89,
        NPC = "Desert Quest Giver",
        NPCPos = V3(1001.0549926757812, 7.56500244140625, 4488.61083984375),
        Mob = "Desert Officer",
        Quest = "DesertQuest",
        QuestLevel = 2,
        FarmPos = V3(1664.676025390625, 14.748001098632812, 4317.791015625) + V3(0, 30, 0),
    },
    -- เกาะหิมะ (Level 90-99)
    [8] = {
        Name = "Snow Island",
        MinLevel = 90,
        MaxLevel = 99,
        NPC = "Snow Quest Giver",
        NPCPos = V3(1273.748046875, 88.79000854492188, -1345.8399658203125),
        Mob = "Snow Bandit",
        Quest = "SnowQuest",
        QuestLevel = 1,
        FarmPos = V3(1273.748046875, 88.79000854492188, -1345.8399658203125) + V3(0, 30, 0),
    },
    -- เกาะหิมะ (Level 100-119)
    [9] = {
        Name = "Snow Island",
        MinLevel = 100,
        MaxLevel = 119,
        NPC = "Snow Quest Giver",
        NPCPos = V3(1273.748046875, 88.79000854492188, -1345.8399658203125),
        Mob = "Snowman",
        Quest = "SnowQuest",
        QuestLevel = 2,
        FarmPos = V3(1190.0889892578125, 106.80999755859375, -1626.5810546875) + V3(0, 30, 0),
    },
}

local function GetIslandByLevel(level)
    for _, island in pairs(IslandData) do
        if level >= island.MinLevel and level <= island.MaxLevel then
            return island
        end
    end
    return IslandData[1]
end

-- ============================================================
-- WEAPON SYSTEM
-- ============================================================
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

-- ============================================================
-- FARM SYSTEM
-- ============================================================
local Farming = false
local QuestDone = false
local AttackCombo = 1
local CurrentIsland = nil
local FarmPos = nil
local NPCPos = nil
local MobName = nil

-- Teleport
local function Teleport(pos)
    if not HRP then return end
    pcall(function()
        HRP.CFrame = CF(pos)
        HRP.Velocity = V3(0, 0, 0)
        HRP.AssemblyLinearVelocity = V3(0, 0, 0)
        HRP.RotVelocity = V3(0, 0, 0)
    end)
end

-- Lock Position
local function LockPosition()
    if not HRP or not FarmPos then return end
    pcall(function()
        HRP.CFrame = CF(FarmPos)
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

-- Accept Quest
local function AcceptQuest()
    if not CommF_ or not CurrentIsland then return end
    pcall(function()
        CommF_:InvokeServer("StartQuest", CurrentIsland.Quest, CurrentIsland.QuestLevel)
        print("✅ รับเควส:", CurrentIsland.Quest, "| มอน:", CurrentIsland.Mob)
    end)
end

-- Farm Loop
local function FarmLoop()
    if not RegAttack or not RegHit or not CurrentIsland then return end
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    local mobs = {}
    
    for _, e in ipairs(enemies:GetChildren()) do
        if e.Name == CurrentIsland.Mob and e:FindFirstChild("Humanoid") and e:FindFirstChild("HumanoidRootPart") then
            local humanoid = e.Humanoid
            if humanoid.Health > 0 then
                table.insert(mobs, e)
            end
        end
    end
    
    if #mobs == 0 then return end
    
    -- รวมมอนที่จุดเดียว
    local centerPos = HRP.Position + V3(0, -30, 0)
    
    for i, e in ipairs(mobs) do
        local part = e.HumanoidRootPart
        local humanoid = e.Humanoid
        
        local angle = (i - 1) * (2 * math.pi / math.min(#mobs, 8))
        local offsetX = math.cos(angle) * 1.5
        local offsetZ = math.sin(angle) * 1.5
        
        local targetPos = centerPos + V3(offsetX, 0, offsetZ)
        
        pcall(function()
            part.CFrame = CF(targetPos)
            part.Velocity = V3(0, 0, 0)
            part.AssemblyLinearVelocity = V3(0, 0, 0)
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end)
    end
    
    -- Fast Attack
    pcall(function()
        for i = 1, 10 do
            RegAttack:FireServer(0.5, AttackCombo)
            AttackCombo = AttackCombo == 1 and 2 or 1
        end
        
        for _, e in ipairs(mobs) do
            local part = e:FindFirstChild("HumanoidRootPart")
            if part then
                for i = 1, 5 do
                    RegHit:FireServer(part, {})
                end
            end
        end
    end)
end

-- Check mobs
local function CheckMobs()
    if not CurrentIsland then return true end
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return true end
    
    for _, e in ipairs(enemies:GetChildren()) do
        if e.Name == CurrentIsland.Mob and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
            return false
        end
    end
    return true
end

-- ============================================================
-- UI
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "AUTO FARM",
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
        SelectedWeapon = opt
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
            CurrentIsland = nil
            print("✅ เริ่มฟาร์ม!")
        else
            print("⏹ หยุดฟาร์ม")
        end
    end,
})

-- Auto Stats
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

-- ============================================================
-- NOCLIP
-- ============================================================
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

-- ============================================================
-- MAIN LOOPS
-- ============================================================

-- Farm Director
task.spawn(function()
    while task.wait(0.05) do
        if not Farming then
            SetNoclip(false)
            continue
        end
        
        pcall(function()
            SetNoclip(true)
            
            -- เช็ค Level และเปลี่ยนเกาะ
            local newIsland = GetIslandByLevel(Level.Value)
            if CurrentIsland ~= newIsland then
                CurrentIsland = newIsland
                FarmPos = CurrentIsland.FarmPos
                NPCPos = CurrentIsland.NPCPos + V3(0, 3, 0)
                MobName = CurrentIsland.Mob
                QuestDone = false
                print("🏝️ เปลี่ยนเกาะ:", CurrentIsland.Name, "| มอน:", MobName, "| Level:", Level.Value)
            end
            
            if not CurrentIsland then return end
            
            -- รับเควส
            if not QuestDone then
                print("📍 บินไปรับเควส...")
                Teleport(NPCPos)
                task.wait(0.5)
                AcceptQuest()
                QuestDone = true
                print("✅ รับเควสแล้ว! บินไปฟาร์ม...")
                Teleport(FarmPos)
                task.wait(0.3)
                return
            end
            
            -- อยู่ที่จุดฟาร์ม
            LockPosition()
            
            -- เช็คมอนตาย
            if CheckMobs() then
                print("🔄 มอนตายหมด ไปรับเควสใหม่...")
                QuestDone = false
                Teleport(NPCPos)
                task.wait(0.5)
            end
            
            task.wait(0.1)
        end)
    end
end)

-- Fast Attack Loop
task.spawn(function()
    while task.wait(0.002) do
        if not Farming or not QuestDone then continue end
        pcall(FarmLoop)
    end
end)

-- Lock Position Loop
task.spawn(function()
    while task.wait(0.01) do
        if not Farming or not QuestDone then continue end
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

-- ============================================================
-- AUTO STATS
-- ============================================================
local AutoMelee = false
local AutoDefense = false
local AutoSword = false
local AutoGun = false
local AutoFruit = false

task.spawn(function()
    while task.wait(0.05) do
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
            task.wait(0.01)
        end
    end
end)

-- Character Respawn
LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid")
    HRP = c:WaitForChild("HumanoidRootPart")
    if Farming then SetNoclip(true) end
    QuestDone = false
end)

-- Notify
Rayfield:Notify({
    Title = "✅ AUTO FARM",
    Content = "เปิด Auto Farm เพื่อเริ่มฟาร์ม!",
    Duration = 5,
})

print("🔥 AUTO FARM LOADED!")
print("📍 เปลี่ยนเกาะอัตโนมัติตาม Level")
print("⚡ FAST ATTACK: ทุก 0.002 วินาที")
