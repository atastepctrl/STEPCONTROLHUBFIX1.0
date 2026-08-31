-- AUTO FARM BLOX FRUITS - FIXED ตัวละครไม่ตก
-- ใช้ TweenService + ล็อคตำแหน่งแบบต่อเนื่อง

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

-- ====== DATA ======
local MOB = "Bandit"

local BanditPositions = {
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

local QuestNPC = "Bandit Quest Giver"
local QuestNPCPosition = V3(1058.9923095703125, 12.710777282714844, 1551.7332763671875)

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
local SpawnIndex = 1
local FarmHeight = 30
local CurrentTarget = nil
local IsFloating = false

-- ✅ Teleport แบบทันที
local function Teleport(pos)
    if not HRP then return end
    pcall(function()
        HRP.CFrame = CF(pos)
        HRP.Velocity = V3(0, 0, 0)
        HRP.AssemblyLinearVelocity = V3(0, 0, 0)
        HRP.RotVelocity = V3(0, 0, 0)
    end)
end

-- ✅ Tween บินไป
local function FlyTo(pos)
    if not HRP then return end
    pcall(function()
        local tween = TweenService:Create(HRP, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = CF(pos)})
        tween:Play()
        tween.Completed:Wait()
        -- ล็อคตำแหน่ง
        HRP.CFrame = CF(pos)
        HRP.Velocity = V3(0, 0, 0)
        HRP.AssemblyLinearVelocity = V3(0, 0, 0)
    end)
end

-- ✅ ล็อคตำแหน่งไม่ให้ตก
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

-- รับเควส
local function AcceptQuest()
    if not CommF_ then return end
    pcall(function()
        CommF_:InvokeServer("StartQuest", QuestData.QuestName, QuestData.QuestLevel)
        print("✅ รับเควส:", QuestData.QuestName)
    end)
end

-- ✅ รวมมอนที่พื้น + โจมตี
local function Attack()
    if not RegAttack or not RegHit then return end
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    local mobs = {}
    
    for _, e in ipairs(enemies:GetChildren()) do
        if e.Name == MOB and e:FindFirstChild("Humanoid") and e:FindFirstChild("HumanoidRootPart") then
            local humanoid = e.Humanoid
            if humanoid.Health > 0 then
                table.insert(mobs, e)
            end
        end
    end
    
    if #mobs == 0 then return end
    
    -- รวมมอนที่พื้นใต้เท้า
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

-- เช็ค mob ตาย
local function CheckMobs()
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return true end
    
    for _, e in ipairs(enemies:GetChildren()) do
        if e.Name == MOB and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
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
            SpawnIndex = 1
            CurrentTarget = nil
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

-- ✅ Farm Loop - ใช้ Lock Position
task.spawn(function()
    while task.wait(0.05) do  -- เร็วขึ้นเพื่อล็อคตำแหน่ง
        if not Farming then
            SetNoclip(false)
            continue
        end
        
        pcall(function()
            SetNoclip(true)
            
            -- รับเควส
            if not QuestDone then
                Teleport(QuestNPCPosition + V3(0, 3, 0))
                task.wait(0.5)
                AcceptQuest()
                QuestDone = true
                SpawnIndex = 1
                print("✅ รับเควสแล้ว!")
                return
            end
            
            -- บินไปฟาร์ม
            local pos = BanditPositions[SpawnIndex]
            if pos then
                local targetPos = pos + V3(0, FarmHeight, 0)
                
                -- ถ้ายังไม่ถึง หรือเปลี่ยนตำแหน่ง
                if not CurrentTarget or (CurrentTarget - targetPos).Magnitude > 1 then
                    CurrentTarget = targetPos
                    FlyTo(targetPos)
                end
                
                -- ✅ ล็อคตำแหน่งทุกเฟรม (ไม่ให้ตก)
                LockPosition()
                
                -- เปลี่ยนตำแหน่งช้าๆ
                SpawnIndex = SpawnIndex + 1
                if SpawnIndex > #BanditPositions then
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

-- ✅ Attack Loop
task.spawn(function()
    while task.wait(0.01) do
        if not Farming or not QuestDone then continue end
        pcall(Attack)
    end
end)

-- ✅ Lock Position Loop (ล็อคตลอดเวลาขณะฟาร์ม)
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

-- ====== AUTO STATS ======
local AutoMelee = false
local AutoDefense = false
local AutoSword = false
local AutoGun = false
local AutoFruit = false

task.spawn(function()
    while task.wait(0.3) do
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
