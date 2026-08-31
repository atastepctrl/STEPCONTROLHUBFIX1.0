-- AUTO FARM BLOX FRUITS - FIXED 100%
-- แก้ทุกอย่างที่ทำให้ไม่ตี

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

-- ✅ Remote Events (หาแบบละเอียด)
local CommF_ = nil
local RegAttack = nil
local RegHit = nil

-- หา CommF_
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
if Remotes then
    CommF_ = Remotes:FindFirstChild("CommF_")
end

-- หา RegAttack และ RegHit
local Modules = ReplicatedStorage:FindFirstChild("Modules")
if Modules then
    local Net = Modules:FindFirstChild("Net")
    if Net then
        RegAttack = Net:FindFirstChild("RE/RegisterAttack")
        RegHit = Net:FindFirstChild("RE/RegisterHit")
    end
end

-- ถ้าไม่เจอ ให้ค้นหาทั้งหมด
if not CommF_ or not RegAttack or not RegHit then
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v.Name == "CommF_" then CommF_ = v end
        if v.Name == "RE/RegisterAttack" then RegAttack = v end
        if v.Name == "RE/RegisterHit" then RegHit = v end
    end
end

print("✅ CommF_:", CommF_ and "Found" or "Not Found")
print("✅ RegAttack:", RegAttack and "Found" or "Not Found")
print("✅ RegHit:", RegHit and "Found" or "Not Found")

local V3 = Vector3.new
local CF = CFrame.new

-- ====== DATA ======
-- ✅ ใช้ชื่อมอนให้ตรงกับในเกม (จาก Screenshot เห็น "Bandit [Lv. 5]")
local MOB = "Bandit"  -- หรือ "Bandit [Lv. 5]" แล้วแต่ว่าอันไหนตรง

-- จุดหลัก
local NPC_POSITION = V3(1058.9923095703125, 12.710777282714844, 1551.7332763671875) + V3(0, 3, 0)
local FARM_POSITION = V3(1341.8013916015625, 14.971686363220215, 1568.908935546875) + V3(0, 30, 0)

local QuestData = {
    QuestName = "BanditQuest1",
    QuestLevel = 1,
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

local function Teleport(pos)
    if not HRP then return end
    pcall(function()
        HRP.CFrame = CF(pos)
        HRP.Velocity = V3(0, 0, 0)
        HRP.AssemblyLinearVelocity = V3(0, 0, 0)
        HRP.RotVelocity = V3(0, 0, 0)
    end)
end

local function LockPosition()
    if not HRP then return end
    pcall(function()
        HRP.CFrame = CF(FARM_POSITION)
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
    if not CommF_ then 
        print("❌ CommF_ not found!")
        return 
    end
    pcall(function()
        local result = CommF_:InvokeServer("StartQuest", QuestData.QuestName, QuestData.QuestLevel)
        print("✅ รับเควส:", QuestData.QuestName, "Result:", result)
    end)
end

-- ✅ แก้ Attack ให้ตีได้ทุกตัว
local function AttackLoop()
    if not RegAttack or not RegHit then 
        print("❌ RegAttack or RegHit not found!")
        return 
    end
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then 
        return 
    end
    
    local mobs = {}
    
    -- ✅ หามอนแบบละเอียด (เผื่อชื่อมี [Lv.])
    for _, e in ipairs(enemies:GetChildren()) do
        local name = e.Name
        -- ตรวจสอบทั้งชื่อตรงและชื่อที่มี [Lv.]
        if name == MOB or name:find(MOB) then
            if e:FindFirstChild("Humanoid") and e:FindFirstChild("HumanoidRootPart") then
                local humanoid = e.Humanoid
                if humanoid.Health > 0 then
                    table.insert(mobs, e)
                end
            end
        end
    end
    
    if #mobs == 0 then 
        return 
    end
    
    -- ✅ รวมมอนที่จุดเดียว
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
    
    -- ✅ Fast Attack
    pcall(function()
        -- Attack 20 รอบ (เร็วขึ้น)
        for i = 1, 20 do
            RegAttack:FireServer(0.5, AttackCombo)
            AttackCombo = AttackCombo == 1 and 2 or 1
        end
        
        -- Hit ทุกตัว 10 รอบ
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
    if not enemies then return true end
    
    for _, e in ipairs(enemies:GetChildren()) do
        local name = e.Name
        if name == MOB or name:find(MOB) then
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
            print("✅ เริ่มฟาร์ม!")
            print("📍 มอน:", MOB)
            print("📍 เควส:", QuestData.QuestName)
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
    while task.wait(0.05) do
        if not Farming then
            SetNoclip(false)
            continue
        end
        
        pcall(function()
            SetNoclip(true)
            
            -- รับเควส
            if not QuestDone then
                print("📍 บินไปรับเควส...")
                Teleport(NPC_POSITION)
                task.wait(0.5)
                AcceptQuest()
                QuestDone = true
                print("✅ รับเควสแล้ว! บินไปฟาร์ม...")
                Teleport(FARM_POSITION)
                task.wait(0.3)
                return
            end
            
            -- อยู่ที่จุดฟาร์ม
            LockPosition()
            
            -- เช็คมอนตาย
            if CheckMobs() then
                print("🔄 มอนตายหมด ไปรับเควสใหม่...")
                QuestDone = false
                Teleport(NPC_POSITION)
                task.wait(0.5)
            end
            
            task.wait(0.1)
        end)
    end
end)

-- ✅ Attack Loop (เร็วมาก)
task.spawn(function()
    while task.wait(0.001) do  -- เร็วขึ้นอีก
        if not Farming or not QuestDone then continue end
        pcall(AttackLoop)
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

-- ====== AUTO STATS ======
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
print("📍 มอน:", MOB)
print("📍 เควส:", QuestData.QuestName)
print("⚡ FAST ATTACK: ทุก 0.001 วินาที")
