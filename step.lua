-- AUTO FARM BLOX FRUITS - WORKING VERSION
-- ใช้ Teleport + CFrame ล็อคตำแหน่ง + Attack จริง

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

-- ====== DATA ======
-- ใช้ชื่อมอนแบบที่เกมใช้จริง (ไม่มี [Lv.])
local MOB_DATA = {
    ["Bandit"] = {
        Level = 5,
        Quest = "BanditQuest1",
        QuestLevel = 1,
        NPC = "Bandit Quest Giver",
        NPCPos = V3(1058.9923095703125, 12.710777282714844, 1551.7332763671875),
        FarmPos = V3(1341.8013916015625, 14.971686363220215, 1568.908935546875),
    },
    ["Monkey"] = {
        Level = 14,
        Quest = "JungleQuest",
        QuestLevel = 1,
        NPC = "Adventurer",
        NPCPos = V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
        FarmPos = V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
    },
    ["Gorilla"] = {
        Level = 20,
        Quest = "JungleQuest",
        QuestLevel = 2,
        NPC = "Adventurer",
        NPCPos = V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
        FarmPos = V3(-1249.18994140625, 8.229995727539062, -456.19000244140625),
    },
    ["Pirate"] = {
        Level = 35,
        Quest = "BuggyQuest1",
        QuestLevel = 1,
        NPC = "Buggy Quest Giver",
        NPCPos = V3(-1182.512939453125, 5.600006103515625, 3972.157958984375),
        FarmPos = V3(-1182.512939453125, 5.600006103515625, 3972.157958984375),
    },
    ["Brute"] = {
        Level = 45,
        Quest = "BuggyQuest1",
        QuestLevel = 2,
        NPC = "Buggy Quest Giver",
        NPCPos = V3(-1182.512939453125, 5.600006103515625, 3972.157958984375),
        FarmPos = V3(-862.8900146484375, 15.600006103515625, 4281.9560546875),
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
local TargetPos = nil

-- ✅ เลือกมอนตาม Level
local function GetMobByLevel(lvl)
    local best = nil
    local bestDiff = 999
    
    for name, data in pairs(MOB_DATA) do
        if lvl <= data.Level then
            local diff = data.Level - lvl
            if diff < bestDiff then
                bestDiff = diff
                best = data
            end
        end
    end
    
    return best or MOB_DATA["Bandit"]
end

-- ✅ Teleport พร้อมล็อคตำแหน่ง
local function Teleport(pos)
    if not HRP then return end
    pcall(function()
        local target = pos + V3(0, FarmHeight, 0)
        HRP.CFrame = CF(target)
        HRP.Velocity = V3(0, 0, 0)
        HRP.AssemblyLinearVelocity = V3(0, 0, 0)
        HRP.RotVelocity = V3(0, 0, 0)
        if Humanoid then
            Humanoid.Sit = false
            Humanoid.PlatformStand = false
            Humanoid.WalkSpeed = 0
            Humanoid.JumpPower = 0
        end
        TargetPos = target
    end)
end

-- ✅ ล็อคตำแหน่งให้อยู่กับที่
local function LockPosition()
    if not HRP or not TargetPos then return end
    pcall(function()
        HRP.CFrame = CF(TargetPos)
        HRP.Velocity = V3(0, 0, 0)
        HRP.AssemblyLinearVelocity = V3(0, 0, 0)
        HRP.RotVelocity = V3(0, 0, 0)
        if Humanoid then
            Humanoid.Sit = false
            Humanoid.PlatformStand = false
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

-- ====== ATTACK ======
local function AttackLoop()
    if not RegAttack or not RegHit or not CurrentMob then return end
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    local mobs = {}
    local mobName = CurrentMob.Name
    
    for _, e in ipairs(enemies:GetChildren()) do
        if e.Name == mobName and e:FindFirstChild("Humanoid") and e:FindFirstChild("HumanoidRootPart") then
            if e.Humanoid.Health > 0 then
                table.insert(mobs, e)
            end
        end
    end
    
    if #mobs == 0 then return end
    
    -- ✅ ดึงมอนมาใต้เท้า
    local centerPos = HRP.Position + V3(0, -FarmHeight, 0)
    
    for i, e in ipairs(mobs) do
        local part = e.HumanoidRootPart
        local humanoid = e.Humanoid
        local angle = (i - 1) * (2 * math.pi / #mobs)
        local target = centerPos + V3(math.cos(angle) * 1.5, 0, math.sin(angle) * 1.5)
        
        pcall(function()
            part.CFrame = CF(target)
            part.Velocity = V3(0, 0, 0)
            part.AssemblyLinearVelocity = V3(0, 0, 0)
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end)
    end
    
    -- ✅ Attack
    pcall(function()
        RegAttack:FireServer(0.5, AttackCombo)
        AttackCombo = AttackCombo == 1 and 2 or 1
        
        for _, e in ipairs(mobs) do
            local part = e:FindFirstChild("HumanoidRootPart")
            if part then
                RegHit:FireServer(part, {})
            end
        end
    end)
end

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
            CurrentMob = nil
            TargetPos = nil
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

-- ✅ Farm Director
task.spawn(function()
    while task.wait(0.15) do
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
                TargetPos = nil
                print("🎯 เปลี่ยนเป็น:", CurrentMob.Name, "Level:", Level.Value)
            end
            
            if not CurrentMob then return end
            
            -- รับเควส
            if not QuestDone then
                Teleport(CurrentMob.NPCPos)
                task.wait(0.5)
                AcceptQuest()
                QuestDone = true
                print("✅ รับเควสแล้ว!")
                Teleport(CurrentMob.FarmPos)
                task.wait(0.3)
                return
            end
            
            -- ✅ อยู่ที่จุดฟาร์ม (ล็อคตำแหน่ง)
            if TargetPos then
                LockPosition()
            end
            
            -- ✅ เช็คมอนตาย
            if CheckMobs() then
                print("🔄 มอนตายหมด รับเควสใหม่")
                QuestDone = false
                Teleport(CurrentMob.NPCPos)
                task.wait(0.5)
            end
        end)
    end
end)

-- ✅ Attack Loop
task.spawn(function()
    while task.wait(0.01) do
        if not Farming or not QuestDone or not CurrentMob then continue end
        pcall(AttackLoop)
    end
end)

-- ✅ Lock Position Loop (กันตก)
task.spawn(function()
    while task.wait(0.01) do
        if not Farming or not QuestDone or not TargetPos then continue end
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
    if Farming then
        task.wait(0.5)
        SetNoclip(true)
        QuestDone = false
        CurrentMob = nil
        TargetPos = nil
    end
end)

Rayfield:Notify({
    Title = "✅ AUTO FARM",
    Content = "เปิด Auto Farm เพื่อเริ่มฟาร์ม!",
    Duration = 5,
})

print("🔥 AUTO FARM LOADED!")
print("📍 ใช้ CFrame ล็อคตำแหน่ง")
print("⚡ Attack ทุก 0.01 วินาที")
