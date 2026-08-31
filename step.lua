-- AUTO FARM BLOX FRUITS - BANDIT ONLY
-- ฟาร์ม Bandit อย่างเดียว ไม่เปลี่ยนเกาะ

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
local CommF_ = nil
local RegAttack = nil
local RegHit = nil

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

if not CommF_ or not RegAttack or not RegHit then
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v.Name == "CommF_" then CommF_ = v end
        if v.Name == "RE/RegisterAttack" then RegAttack = v end
        if v.Name == "RE/RegisterHit" then RegHit = v end
    end
end

local V3 = Vector3.new
local CF = CFrame.new

-- ============================================================
-- 📌 DATA BANDIT
-- ============================================================
local MOB = "Bandit"
local NPC_NAME = "Bandit Quest Giver"
local QUEST_NAME = "BanditQuest1"
local QUEST_LEVEL = 1

-- ตำแหน่ง NPC (ยืนยันแล้ว)
local NPC_POS = V3(1058.9923095703125, 12.710777282714844, 1551.7332763671875)

-- ตำแหน่ง Spawn Bandit 10 จุด
local SPAWNS = {
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

-- ============================================================
-- WEAPON SYSTEM
-- ============================================================
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
    
    -- เช็ค Attribute
    local attr = Tool:GetAttribute("WeaponType")
    if typeof(attr) == "string" and SupportedWeaponTypes[attr] then
        return attr
    end
    
    -- เช็ค StringValue
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
local FarmHeight = 20
local CurrentFarmPos = nil

local function Teleport(pos)
    if not HRP then return end
    pcall(function()
        HRP.CFrame = CF(pos + V3(0, FarmHeight, 0))
        HRP.Velocity = V3(0, 0, 0)
        HRP.AssemblyLinearVelocity = V3(0, 0, 0)
    end)
end

local function AcceptQuest()
    if not CommF_ then return false end
    local success = pcall(function()
        CommF_:InvokeServer("StartQuest", QUEST_NAME, QUEST_LEVEL)
    end)
    return success
end

local function AttackLoop()
    if not RegAttack or not RegHit then return end
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    local mobs = {}
    
    for _, e in ipairs(enemies:GetChildren()) do
        if e.Name == MOB then
            if e:FindFirstChild("Humanoid") and e:FindFirstChild("HumanoidRootPart") then
                if e.Humanoid.Health > 0 then
                    table.insert(mobs, e)
                end
            end
        end
    end
    
    if #mobs == 0 then return end
    
    -- ดึงมอนมาใกล้ๆ
    local centerPos = HRP.Position + V3(0, -FarmHeight, 0)
    
    for i, e in ipairs(mobs) do
        local part = e.HumanoidRootPart
        local humanoid = e.Humanoid
        
        local angle = (i - 1) * (2 * math.pi / #mobs)
        local offsetX = math.cos(angle) * 2
        local offsetZ = math.sin(angle) * 2
        
        local targetPos = centerPos + V3(offsetX, 0, offsetZ)
        local direction = (targetPos - part.Position) * 2
        
        pcall(function()
            part.AssemblyLinearVelocity = direction
            part.Velocity = direction
        end)
    end
    
    -- Attack
    pcall(function()
        for i = 1, 20 do
            RegAttack:FireServer(0.5, AttackCombo)
            AttackCombo = AttackCombo == 1 and 2 or 1
        end
        
        for _, e in ipairs(mobs) do
            local part = e:FindFirstChild("HumanoidRootPart")
            if part then
                for i = 1, 10 do
                    RegHit:FireServer(part, {})
                end
            end
        end
    end)
end

local function CheckMobs()
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return false  -- ยังไม่รู้ว่าโหลดเสร็จหรือยัง
    
    for _, e in ipairs(enemies:GetChildren()) do
        if e.Name == MOB then
            if e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                return false
            end
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
            print("✅ เริ่มฟาร์ม Bandit!")
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

FarmTab:CreateSlider({
    Name = "Farm Height",
    Range = {10, 40},
    Increment = 1,
    CurrentValue = FarmHeight,
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
            
            -- รับเควส
            if not QuestDone then
                print("📍 บินไปรับเควส...")
                Teleport(NPC_POS)
                task.wait(0.5)
                local success = AcceptQuest()
                if success then
                    QuestDone = true
                    print("✅ รับเควสแล้ว!")
                    Teleport(SPAWNS[1])
                    task.wait(0.3)
                else
                    print("❌ รับเควสไม่สำเร็จ ลองใหม่...")
                    task.wait(1)
                end
                return
            end
            
            -- เปลี่ยนจุดฟาร์ม
            if not CurrentFarmPos then
                CurrentFarmPos = SPAWNS[SpawnIndex]
            end
            
            Teleport(CurrentFarmPos)
            
            -- เปลี่ยนตำแหน่งช้าๆ
            SpawnIndex = SpawnIndex + 1
            if SpawnIndex > #SPAWNS then
                SpawnIndex = 1
            end
            CurrentFarmPos = SPAWNS[SpawnIndex]
            
            -- เช็คมอนตาย
            if CheckMobs() then
                print("🔄 มอนตายหมด รับเควสใหม่...")
                QuestDone = false
                Teleport(NPC_POS)
                task.wait(0.5)
            end
            
            task.wait(0.5)
        end)
    end
end)

-- Attack Loop
task.spawn(function()
    while task.wait(0.01) do
        if not Farming or not QuestDone then continue end
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

task.spawn(function()
    while task.wait(0.2) do  -- ช้าลง
        if Points.Value <= 0 then continue end
        
        local statsToAdd = {}
        if AutoMelee then table.insert(statsToAdd, "Melee") end
        if AutoDefense then table.insert(statsToAdd, "Defense") end
        if AutoSword then table.insert(statsToAdd, "Sword") end
        if AutoGun then table.insert(statsToAdd, "Gun") end
        
        if #statsToAdd == 0 then continue end
        
        for _, statName in ipairs(statsToAdd) do
            if Points.Value <= 0 then break end
            pcall(function()
                if CommF_ then
                    CommF_:InvokeServer("AddPoint", statName, 1)
                end
            end)
            task.wait(0.05)  -- ช้าลง
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
    CurrentFarmPos = nil
end)

Rayfield:Notify({
    Title = "✅ AUTO FARM",
    Content = "เปิด Auto Farm เพื่อเริ่มฟาร์ม Bandit!",
    Duration = 5,
})

print("🔥 AUTO FARM LOADED!")
print("🎯 มอน: Bandit")
print("📍 Spawn: 10 จุด")
