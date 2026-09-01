-- AUTO FARM BLOX FRUITS - COMPLETE VERSION
-- ใช้ข้อมูลจาก Remote Spy + Workspace Dump + Player Data

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ====== CHARACTER ======
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- ====== DATA ======
local Data = LocalPlayer:WaitForChild("Data")
local Level = Data:WaitForChild("Level")
local Points = Data:WaitForChild("Points")

-- ====== REMOTE EVENTS (จาก Remote Spy) ======
-- CommF_ ใช้รับเควส, AddPoint, SetTeam2
local CommF_ = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("CommF_")
-- RE/RegisterAttack และ RE/RegisterHit ใช้โจมตี
local RegAttack = ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Net"):FindFirstChild("RE/RegisterAttack")
local RegHit = ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Net"):FindFirstChild("RE/RegisterHit")
-- EquipEvent ใช้เปลี่ยนอาวุธ (จาก Backpack.Combat)
local EquipEvent = LocalPlayer:FindFirstChild("Backpack"):FindFirstChild("Combat"):FindFirstChild("EquipEvent")

local V3 = Vector3.new
local CF = CFrame.new

-- ====== ข้อมูลจาก Workspace Dump ======
-- จากไฟล์ player.lua เห็นชื่อมอนและตำแหน่ง
local MONSTERS = {
    ["Bandit"] = {
        Level = 5,
        Quest = "BanditQuest1",
        QuestLevel = 1,
        NPC = "Bandit Quest Giver",
        NPCPos = V3(1058.9923095703125, 12.710777282714844, 1551.7332763671875),
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
    -- เพิ่มมอนอื่นๆ ตามข้อมูลที่มี
    ["Monkey"] = {
        Level = 14,
        Quest = "JungleQuest",
        QuestLevel = 1,
        NPC = "Adventurer",
        NPCPos = V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
        Spawns = {
            V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
            V3(-1202.5, 10.899993896484375, 278.8699951171875),
            V3(-1743.530029296875, 20.979995727539062, -91.27000427246094),
            V3(-1489.25, 20.979995727539062, 88.49000549316406),
            V3(-1579.218994140625, 20.979995727539062, 377.6000061035156),
        }
    },
    ["Gorilla"] = {
        Level = 20,
        Quest = "JungleQuest",
        QuestLevel = 2,
        NPC = "Adventurer",
        NPCPos = V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
        Spawns = {
            V3(-1249.18994140625, 8.229995727539062, -456.19000244140625),
            V3(-1249.18994140625, 8.229995727539062, -549.6799926757812),
            V3(-1363.18994140625, 20.229995727539062, -486.19000244140625),
        }
    },
}

-- ====== WEAPON SYSTEM (จากข้อมูล) ======
local SupportedWeaponTypes = {
    Melee = true,
    Sword = true,
    Gun = true,
    ["Blox Fruit"] = true,
    ["Demon Fruit"] = true,
}

local SelectedWeapon = nil

local function GetWeaponType(Tool)
    if not Tool or not Tool:IsA("Tool") then return nil end
    
    local attr = Tool:GetAttribute("WeaponType")
    if typeof(attr) == "string" and SupportedWeaponTypes[attr] then
        return attr
    end
    
    local typeVal = Tool:FindFirstChild("Type")
    if typeVal and typeVal:IsA("StringValue") then
        local val = typeVal.Value
        if SupportedWeaponTypes[val] then return val end
        if val == "BloxFruit" or val == "DemonFruit" then return "Blox Fruit" end
    end
    
    return nil
end

local function ScanWeapons()
    local list = {}
    local seen = {}
    
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") then
                local wt = GetWeaponType(v)
                if wt and not seen[v.Name] then
                    seen[v.Name] = true
                    table.insert(list, {Name = v.Name, Type = wt})
                end
            end
        end
    end
    
    if Character then
        for _, v in ipairs(Character:GetChildren()) do
            if v:IsA("Tool") then
                local wt = GetWeaponType(v)
                if wt and not seen[v.Name] then
                    seen[v.Name] = true
                    table.insert(list, {Name = v.Name, Type = wt})
                end
            end
        end
    end
    
    table.sort(list, function(a, b) return a.Name < b.Name end)
    
    local names = {}
    for _, w in ipairs(list) do
        names[#names + 1] = w.Name .. " [" .. w.Type .. "]"
    end
    if #names == 0 then names[1] = "None" end
    return names
end

local function EquipWeapon(name)
    if not name or name == "None" then return false end
    if Character and Character:FindFirstChild(name) then return true end
    
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
local SpawnIndex = 1
local FarmHeight = 30
local CurrentMob = nil

local function GetMobByLevel(lvl)
    local mobs = {}
    for name, data in pairs(MONSTERS) do
        table.insert(mobs, {Name = name, Level = data.Level, Data = data})
    end
    table.sort(mobs, function(a, b) return a.Level < b.Level end)
    
    for _, mob in ipairs(mobs) do
        if lvl <= mob.Level then
            return mob.Data
        end
    end
    return MONSTERS["Bandit"]
end

local function Teleport(pos)
    if not HRP then return end
    pcall(function()
        HRP.CFrame = CF(pos + V3(0, FarmHeight, 0))
        HRP.Velocity = V3(0, 0, 0)
        HRP.AssemblyLinearVelocity = V3(0, 0, 0)
    end)
end

local function AcceptQuest()
    if not CommF_ or not CurrentMob then return end
    pcall(function()
        CommF_:InvokeServer("StartQuest", CurrentMob.Quest, CurrentMob.QuestLevel)
        print("✅ รับเควส:", CurrentMob.Quest)
    end)
end

-- ====== ATTACK (จาก Remote Spy) ======
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
    
    local centerPos = HRP.Position + V3(0, -FarmHeight, 0)
    
    for i, e in ipairs(mobs) do
        local part = e.HumanoidRootPart
        local angle = (i - 1) * (2 * math.pi / #mobs)
        local targetPos = centerPos + V3(math.cos(angle) * 1.5, 0, math.sin(angle) * 1.5)
        local direction = (targetPos - part.Position) * 2
        
        pcall(function()
            part.AssemblyLinearVelocity = direction
            part.Velocity = direction
        end)
    end
    
    -- Fast Attack (จาก Remote Spy)
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
            SpawnIndex = 1
            CurrentMob = nil
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

-- Farm Director
task.spawn(function()
    while task.wait(0.1) do
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
                SpawnIndex = 1
                print("🎯 เปลี่ยนเป็น:", CurrentMob.Name, "Level:", Level.Value)
            end
            
            if not CurrentMob then return end
            
            if not QuestDone then
                Teleport(CurrentMob.NPCPos)
                task.wait(0.5)
                AcceptQuest()
                QuestDone = true
                print("✅ รับเควสแล้ว!")
                Teleport(CurrentMob.Spawns[1])
                task.wait(0.3)
                return
            end
            
            local spawns = CurrentMob.Spawns
            if not spawns or #spawns == 0 then return end
            
            local pos = spawns[SpawnIndex]
            if pos then
                Teleport(pos)
                SpawnIndex = SpawnIndex + 1
                if SpawnIndex > #spawns then
                    SpawnIndex = 1
                end
            end
            
            if CheckMobs() then
                print("🔄 มอนตายหมด รับเควสใหม่")
                QuestDone = false
                SpawnIndex = 1
                Teleport(CurrentMob.NPCPos)
                task.wait(0.5)
            end
            
            task.wait(0.2)
        end)
    end
end)

-- Attack Loop
task.spawn(function()
    while task.wait(0.005) do
        if not Farming or not QuestDone or not CurrentMob then continue end
        pcall(AttackLoop)
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
    if Farming then SetNoclip(true) end
    QuestDone = false
    SpawnIndex = 1
    CurrentMob = nil
end)

Rayfield:Notify({
    Title = "✅ PREMIUM HUB",
    Content = "เปิด Auto Farm เพื่อเริ่มฟาร์ม!",
    Duration = 5,
})

print("🔥 PREMIUM HUB LOADED!")
print("📌 ใช้ข้อมูลจาก Remote Spy + Workspace Dump!")
