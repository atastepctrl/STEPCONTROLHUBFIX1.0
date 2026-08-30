-- PREMIUM HUB | BLOX FRUITS
-- FIXED - ตำแหน่งมอนถูกต้อง ไม่วาปไปมา

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

-- ⚙️ CONFIG - ตำแหน่งที่ถูกต้อง ไม่สลับเกาะ
local CONFIG = {
    -- เกาะโจรสลัด (Pirate Island) - Level 1-9
    [1] = {
        NPC = "Bandit Quest Giver",
        Mob = "Bandit",
        Quest = "BanditQuest1",
        Level = 1,
        MinLevel = 0,
        MaxLevel = 9,
        Spawns = {
            V3(-1182.512939453125, 5.600006103515625, 3972.157958984375),
            V3(-1289.512939453125, 5.600006103515625, 3940.157958984375),
            V3(-1140.512939453125, 5.600006103515625, 3902.157958984375),
            V3(-972.4329833984375, 13.600006103515625, 3939.2470703125),
            V3(-967.4329833984375, 13.600006103515625, 4034.2470703125),
            V3(-1269.512939453125, 5.600006103515625, 3857.157958984375),
        }
    },
    -- เกาะป่า (Jungle) - Level 10-19
    [2] = {
        NPC = "Adventurer",
        Mob = "Monkey",
        Quest = "JungleQuest",
        Level = 1,
        MinLevel = 10,
        MaxLevel = 19,
        Spawns = {
            V3(-1292.6700439453125, 10.899993896484375, -4.850006103515625),
            V3(-1202.5, 10.899993896484375, 278.8699951171875),
            V3(-1743.530029296875, 20.979995727539062, -91.27000427246094),
            V3(-1489.25, 20.979995727539062, 88.49000549316406),
            V3(-1579.218994140625, 20.979995727539062, 377.6000061035156),
            V3(-1801.0799560546875, 20.979995727539062, 111.29000854492188),
        }
    },
    -- เกาะป่า (Jungle) - Level 20-29
    [3] = {
        NPC = "Adventurer",
        Mob = "Gorilla",
        Quest = "JungleQuest",
        Level = 2,
        MinLevel = 20,
        MaxLevel = 29,
        Spawns = {
            V3(-1249.18994140625, 8.229995727539062, -456.19000244140625),
            V3(-1249.18994140625, 8.229995727539062, -549.6799926757812),
            V3(-1363.18994140625, 20.229995727539062, -486.19000244140625),
            V3(-1186.6190185546875, 11.067001342773438, -650.2750244140625),
        }
    },
}

local function GetConfig(level)
    for _, config in pairs(CONFIG) do
        if level >= config.MinLevel and level <= config.MaxLevel then
            return config
        end
    end
    return CONFIG[1]
end

local function TeleportTo(pos)
    if not HRP then return end
    pcall(function()
        HRP.CFrame = CF(pos)
        HRP.Velocity = V3(0,0,0)
        HRP.AssemblyLinearVelocity = V3(0,0,0)
    end)
end

local function FindNPC(npcName)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == npcName then
            return obj
        end
    end
    return nil
end

-- Weapon System
local SelectedWeapon = nil

local function ScanWeapons()
    local list = {}
    local seen = {}
    
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if bp then
        for _,v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") and not seen[v.Name] then
                seen[v.Name] = true
                table.insert(list, v.Name)
            end
        end
    end
    
    if Character then
        for _,v in ipairs(Character:GetChildren()) do
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

-- สถานะ
local S = {
    Farm = false,
    Height = 40,
    Stats = {Melee=false,Defense=false,Sword=false,Gun=false,Fruit=false},
    CurrentMob = "",
    AttackCombo = 1,
    QuestAccepted = false,
    CurrentSpawnIndex = 1,
    CurrentConfig = nil,
    Step = 0,
}

-- UI
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
        SelectedWeapon = names[1]
    end
end

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
            S.CurrentMob = ""
            S.QuestAccepted = false
            S.CurrentConfig = nil
            S.Step = 0
        else
            S.Step = 0
            print("✅ Auto Farm ENABLED!")
        end
    end,
})

StatsTab:CreateToggle({Name="Auto Melee",CurrentValue=false,Flag="Melee",Callback=function(v) S.Stats.Melee=v end})
StatsTab:CreateToggle({Name="Auto Defense",CurrentValue=false,Flag="Defense",Callback=function(v) S.Stats.Defense=v end})
StatsTab:CreateToggle({Name="Auto Sword",CurrentValue=false,Flag="Sword",Callback=function(v) S.Stats.Sword=v end})
StatsTab:CreateToggle({Name="Auto Gun",CurrentValue=false,Flag="Gun",Callback=function(v) S.Stats.Gun=v end})
StatsTab:CreateToggle({Name="Auto Blox Fruit",CurrentValue=false,Flag="Fruit",Callback=function(v) S.Stats.Fruit=v end})

SettingsTab:CreateSlider({
    Name="Farm Height",Range={20,60},Increment=1,CurrentValue=40,Flag="FarmHeight",
    Callback=function(v) S.Height=v end,
})

-- Noclip
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

-- Main Loop
task.spawn(function()
    while task.wait(0.2) do
        if not S.Farm or not Character or not HRP then
            SetNoclip(false)
            continue
        end
        
        pcall(function()
            SetNoclip(true)
            
            local config = GetConfig(Level.Value)
            if not config then return end
            
            if S.CurrentConfig ~= config then
                S.CurrentConfig = config
                S.QuestAccepted = false
                S.CurrentMob = config.Mob
                S.CurrentSpawnIndex = 1
                S.Step = 0
                print("📌 Switched to:", config.Mob, "Level:", Level.Value)
            end
            
            -- STEP 0: หา NPC และรับเควส
            if S.Step == 0 then
                print("🔍 Looking for NPC:", config.NPC)
                local npc = FindNPC(config.NPC)
                if npc then
                    print("✅ Found NPC!")
                    local npcPart = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Head")
                    if npcPart then
                        TeleportTo(npcPart.Position + V3(0, 3, 0))
                        task.wait(0.5)
                    end
                    
                    if CommF_ then
                        print("📌 Accepting quest:", config.Quest, config.Level)
                        pcall(function()
                            CommF_:InvokeServer("StartQuest", config.Quest, config.Level)
                        end)
                        S.QuestAccepted = true
                        S.Step = 1
                        print("✅ Quest accepted!")
                    end
                else
                    print("❌ NPC not found!")
                    task.wait(0.5)
                end
                return
            end
            
            -- STEP 1: บินไปฟาร์ม
            if S.Step == 1 then
                local spawns = config.Spawns
                if not spawns or #spawns == 0 then
                    S.Step = 0
                    return
                end
                
                if S.CurrentSpawnIndex > #spawns then
                    S.CurrentSpawnIndex = 1
                end
                
                local targetPos = spawns[S.CurrentSpawnIndex]
                if targetPos then
                    local height = S.Height or 40
                    TeleportTo(targetPos + V3(0, height, 0))
                    task.wait(0.2)
                    S.CurrentSpawnIndex = S.CurrentSpawnIndex + 1
                    S.Step = 2
                end
                return
            end
            
            -- STEP 2: ฟาร์ม (รักษาตำแหน่ง)
            if S.Step == 2 then
                -- รักษาตำแหน่งให้อยู่ที่ spawn ปัจจุบัน
                local spawns = S.CurrentConfig.Spawns
                if spawns and #spawns > 0 then
                    local idx = S.CurrentSpawnIndex - 1
                    if idx < 1 then idx = 1 end
                    if idx > #spawns then idx = #spawns end
                    local pos = spawns[idx]
                    if pos then
                        TeleportTo(pos + V3(0, S.Height, 0))
                    end
                end
                
                -- เช็ค mob ตาย
                local enemies = workspace:FindFirstChild("Enemies")
                if enemies then
                    local alive = false
                    for _,e in ipairs(enemies:GetChildren()) do
                        if e.Name == S.CurrentMob and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                            alive = true
                            break
                        end
                    end
                    if not alive then
                        print("🔄 All mobs dead! Re-questing...")
                        S.Step = 0
                        S.QuestAccepted = false
                        S.CurrentSpawnIndex = 1
                    end
                end
            end
        end)
    end
end)

-- Attack Loop
task.spawn(function()
    while task.wait(0.02) do
        if not S.Farm or S.Step ~= 2 then continue end
        
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

-- Auto Equip
task.spawn(function()
    while task.wait(0.3) do
        if S.Farm and SelectedWeapon and SelectedWeapon ~= "None" then
            pcall(KeepWeaponEquipped)
        end
    end
end)

-- Auto Stats
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

-- Character respawn
LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    Humanoid = c:WaitForChild("Humanoid")
    HRP = c:WaitForChild("HumanoidRootPart")
    if S.Farm then SetNoclip(true) end
    S.QuestAccepted = false
    S.CurrentMob = ""
    S.CurrentConfig = nil
    S.Step = 0
    S.CurrentSpawnIndex = 1
end)

-- Notify
Rayfield:Notify({Title="✅ Premium Hub",Content="Script Loaded! Enable Auto Farm.",Duration=5})
print("🔥 Premium Hub loaded!")
print("📌 Current Level:", Level.Value)
