-- AUTO FARM BLOX FRUITS - AUTO LEVEL UP
-- เปลี่ยนเกาะอัตโนมัติตามเลเวล

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
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
        Spawns = {
            V3(1341.8013916015625, 14.971686363220215, 1568.908935546875),
            V3(1331.8433837890625, 14.971686363220215, 1497.990966796875),
            V3(1019.77685546875, 14.971871376037598, 1566.628662109375),
            V3(1232.5172119140625, 14.970709800720215, 1539.788818359375),
            V3(1123.51806640625, 14.970709800720215, 1665.0887451171875),
            V3(950.2855834960938, 14.97115421295166, 1625.227294921875),
            V3(934.4271850585938, 15.017585754394531, 1517.141357421875),
            V3(1102.04052734375, 14.971070289611816, 1589.462646484375),
            V3(1219.0181884765625, 14.970709800720215, 1677.4891357421875),
            V3(1284.3336181640625, 14.970709800720215, 1627.645263671875),
        }
    },
    -- เกาะป่า (Level 10-29)
    [2] = {
        Name = "Jungle Island",
        MinLevel = 10,
        MaxLevel = 19,
        NPC = "Adventurer",
        NPCPos = V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
        Mob = "Monkey",
        Quest = "JungleQuest",
        QuestLevel = 1,
        Spawns = {
            V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
            V3(-1202.5, 10.899993896484375, 278.8699951171875),
            V3(-1743.530029296875, 20.979995727539062, -91.27000427246094),
            V3(-1489.25, 20.979995727539062, 88.49000549316406),
            V3(-1579.218994140625, 20.979995727539062, 377.6000061035156),
        }
    },
    [3] = {
        Name = "Jungle Island",
        MinLevel = 20,
        MaxLevel = 29,
        NPC = "Adventurer",
        NPCPos = V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
        Mob = "Gorilla",
        Quest = "JungleQuest",
        QuestLevel = 2,
        Spawns = {
            V3(-1249.18994140625, 8.229995727539062, -456.19000244140625),
            V3(-1249.18994140625, 8.229995727539062, -549.6799926757812),
            V3(-1363.18994140625, 20.229995727539062, -486.19000244140625),
            V3(-1186.6190185546875, 11.067001342773438, -650.2750244140625),
        }
    },
    -- เกาะโจรสลัด (Level 30-59)
    [4] = {
        Name = "Pirate Island",
        MinLevel = 30,
        MaxLevel = 39,
        NPC = "Buggy Quest Giver",
        NPCPos = V3(-1182.512939453125, 5.600006103515625, 3972.157958984375),
        Mob = "Pirate",
        Quest = "BuggyQuest1",
        QuestLevel = 1,
        Spawns = {
            V3(-1182.512939453125, 5.600006103515625, 3972.157958984375),
            V3(-1289.512939453125, 5.600006103515625, 3940.157958984375),
            V3(-1140.512939453125, 5.600006103515625, 3902.157958984375),
            V3(-972.4329833984375, 13.600006103515625, 3939.2470703125),
        }
    },
    [5] = {
        Name = "Pirate Island",
        MinLevel = 40,
        MaxLevel = 59,
        NPC = "Buggy Quest Giver",
        NPCPos = V3(-1182.512939453125, 5.600006103515625, 3972.157958984375),
        Mob = "Brute",
        Quest = "BuggyQuest1",
        QuestLevel = 2,
        Spawns = {
            V3(-862.8900146484375, 15.600006103515625, 4281.9560546875),
            V3(-979.7150268554688, 15.600006103515625, 4234.755859375),
            V3(-1048.6429443359375, 15.600006103515625, 4405.35888671875),
            V3(-1230.3709716796875, 15.600006103515625, 4331.93701171875),
        }
    },
    -- ทะเลทราย (Level 60-89)
    [6] = {
        Name = "Desert Island",
        MinLevel = 60,
        MaxLevel = 74,
        NPC = "Desert Quest Giver",
        NPCPos = V3(1001.0549926757812, 7.56500244140625, 4488.61083984375),
        Mob = "Desert Bandit",
        Quest = "DesertQuest",
        QuestLevel = 1,
        Spawns = {
            V3(1001.0549926757812, 7.56500244140625, 4488.61083984375),
            V3(859.8150024414062, 7.56500244140625, 4488.06005859375),
            V3(931.7050170898438, 7.56500244140625, 4534.033203125),
        }
    },
    [7] = {
        Name = "Desert Island",
        MinLevel = 75,
        MaxLevel = 89,
        NPC = "Desert Quest Giver",
        NPCPos = V3(1001.0549926757812, 7.56500244140625, 4488.61083984375),
        Mob = "Desert Officer",
        Quest = "DesertQuest",
        QuestLevel = 2,
        Spawns = {
            V3(1664.676025390625, 14.748001098632812, 4317.791015625),
            V3(1578.365966796875, 3.8849945068359375, 4299.23291015625),
            V3(1671.76904296875, 9.748001098632812, 4392.88818359375),
        }
    },
    -- เกาะหิมะ (Level 90-119)
    [8] = {
        Name = "Snow Island",
        MinLevel = 90,
        MaxLevel = 99,
        NPC = "Snow Quest Giver",
        NPCPos = V3(1273.748046875, 88.79000854492188, -1345.8399658203125),
        Mob = "Snow Bandit",
        Quest = "SnowQuest",
        QuestLevel = 1,
        Spawns = {
            V3(1273.748046875, 88.79000854492188, -1345.8399658203125),
            V3(1458.7080078125, 88.79000854492188, -1447.1500244140625),
            V3(1381.324951171875, 88.79000854492188, -1464.9429931640625),
        }
    },
    [9] = {
        Name = "Snow Island",
        MinLevel = 100,
        MaxLevel = 119,
        NPC = "Snow Quest Giver",
        NPCPos = V3(1273.748046875, 88.79000854492188, -1345.8399658203125),
        Mob = "Snowman",
        Quest = "SnowQuest",
        QuestLevel = 2,
        Spawns = {
            V3(1190.0889892578125, 106.80999755859375, -1626.5810546875),
            V3(1148.2490234375, 106.80999755859375, -1429.3199462890625),
            V3(1035.97900390625, 106.80999755859375, -1489.3599853515625),
        }
    },
}

-- ============================================================
-- ฟังก์ชันหา Island ตาม Level
-- ============================================================
local function GetIslandByLevel(level)
    for _, island in pairs(IslandData) do
        if level >= island.MinLevel and level <= island.MaxLevel then
            return island
        end
    end
    return IslandData[1] -- ค่าเริ่มต้น
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
local SpawnIndex = 1
local FarmHeight = 30
local CurrentTarget = nil
local CurrentIsland = nil

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

-- Fly
local function FlyTo(pos)
    if not HRP then return end
    pcall(function()
        local tween = TweenService:Create(HRP, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = CF(pos)})
        tween:Play()
        tween.Completed:Wait()
        HRP.CFrame = CF(pos)
        HRP.Velocity = V3(0, 0, 0)
        HRP.AssemblyLinearVelocity = V3(0, 0, 0)
    end)
end

-- Lock Position
local function LockPosition()
    if not HRP or not CurrentTarget then return end
    pcall(function()
        HRP.CFrame = CF(CurrentTarget)
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
local function AcceptQuest(island)
    if not CommF_ then return end
    pcall(function()
        CommF_:InvokeServer("StartQuest", island.Quest, island.QuestLevel)
        print("✅ รับเควส:", island.Quest, "| มอน:", island.Mob)
    end)
end

-- ====== 🔥 ULTRA FAST ATTACK ======
local function UltraAttack()
    if not RegAttack or not RegHit or not CurrentIsland then return end
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    local mobs = {}
    local mobName = CurrentIsland.Mob
    
    for _, e in ipairs(enemies:GetChildren()) do
        if e.Name == mobName and e:FindFirstChild("Humanoid") and e:FindFirstChild("HumanoidRootPart") then
            local humanoid = e.Humanoid
            if humanoid.Health > 0 then
                table.insert(mobs, e)
            end
        end
    end
    
    if #mobs == 0 then return end
    
    -- รวมมอนที่พื้น
    local centerPos = HRP.Position + V3(0, -FarmHeight, 0)
    
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
    
    local mobName = CurrentIsland.Mob
    for _, e in ipairs(enemies:GetChildren()) do
        if e.Name == mobName and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
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
            SpawnIndex = 1
            CurrentTarget = nil
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

-- Farm Loop
task.spawn(function()
    while task.wait(0.05) do
        if not Farming then
            SetNoclip(false)
            continue
        end
        
        pcall(function()
            SetNoclip(true)
            
            -- ✅ เช็ค Level และเปลี่ยนเกาะอัตโนมัติ
            local currentLevel = Level.Value
            local newIsland = GetIslandByLevel(currentLevel)
            
            -- ถ้าเกาะเปลี่ยน ให้รีเซ็ต
            if CurrentIsland ~= newIsland then
                CurrentIsland = newIsland
                QuestDone = false
                SpawnIndex = 1
                CurrentTarget = nil
                print("🏝️ เปลี่ยนเกาะ:", CurrentIsland.Name, "| มอน:", CurrentIsland.Mob, "| Level:", currentLevel)
            end
            
            if not CurrentIsland then return end
            
            -- รับเควส
            if not QuestDone then
                Teleport(CurrentIsland.NPCPos + V3(0, 3, 0))
                task.wait(0.5)
                AcceptQuest(CurrentIsland)
                QuestDone = true
                SpawnIndex = 1
                print("✅ รับเควสแล้ว! กำลังฟาร์ม", CurrentIsland.Mob)
                return
            end
            
            -- บินไปฟาร์ม
            local spawns = CurrentIsland.Spawns
            if not spawns or #spawns == 0 then return end
            
            local pos = spawns[SpawnIndex]
            if pos then
                local targetPos = pos + V3(0, FarmHeight, 0)
                
                if not CurrentTarget or (CurrentTarget - targetPos).Magnitude > 1 then
                    CurrentTarget = targetPos
                    FlyTo(targetPos)
                end
                
                LockPosition()
                
                SpawnIndex = SpawnIndex + 1
                if SpawnIndex > #spawns then
                    SpawnIndex = 1
                end
                task.wait(0.5)
            end
            
            -- เช็ค mob ตาย
            if CheckMobs() then
                print("🔄 มอนตายหมด รับเควสใหม่")
                QuestDone = false
                SpawnIndex = 1
                CurrentTarget = nil
            end
        end)
    end
end)

-- Ultra Fast Attack Loop
task.spawn(function()
    while task.wait(0.005) do
        if not Farming or not QuestDone or not CurrentIsland then continue end
        pcall(UltraAttack)
    end
end)

-- Lock Position Loop
task.spawn(function()
    while task.wait(0.02) do
        if not Farming or not QuestDone or not CurrentTarget then continue end
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

-- Auto Stats
local AutoMelee = false
local AutoDefense = false
local AutoSword = false
local AutoGun = false
local AutoFruit = false

task.spawn(function()
    while task.wait(0.1) do
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
            task.wait(0.02)
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
    SpawnIndex = 1
    CurrentTarget = nil
end)

-- Notify
Rayfield:Notify({
    Title = "✅ AUTO FARM",
    Content = "เปิด Auto Farm เพื่อเริ่มฟาร์ม!",
    Duration = 5,
})

print("🔥 AUTO FARM LOADED!")
print("⚡ ULTRA FAST ATTACK ENABLED!")
print("🔄 AUTO LEVEL UP ENABLED!")
