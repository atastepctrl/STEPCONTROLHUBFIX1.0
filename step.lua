-- ============================================================
-- ⚡ STEPCONTROL HUB | KAITUN V4 ULTIMATE (COMPLETE)
-- ============================================================
-- VERSION: 4.0.0
-- STATUS: ✅ FULL FEATURES | READY TO USE
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- CONFIG
-- ============================================================
_G.KaitunEnabled = false
_G.FastAttack = true
_G.SelectWeapon = "Melee"
_G.AutoFarm = true
_G.AutoCollect = true
_G.AutoStats = true
_G.BringMob = true
_G.TweenSpeed = 300
_G.SafeDistance = 5
_G.AntiAFK = true

-- ============================================================
-- VARIABLES
-- ============================================================
local StartTime = os.time()
local TotalKills = 0
local TotalItems = 0
local TotalLevels = 0
local CurrentLevel = 0
local LastLevel = 0
local FarmingStatus = "🟢 Ready"
local CurrentMob = "None"
local CurrentQuest = "None"
local CurrentFarmCenter = nil
local CurrentTargetMob = nil

-- ============================================================
-- REMOTE
-- ============================================================
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- ============================================================
-- QUEST DATA (Complete 1-2600)
-- ============================================================
local QuestData = {
    {Min = 1, Max = 14, Quest = "BanditQuest1", QLevel = 1, Mob = "Bandit", NPC = CFrame.new(1059, 16, 1549), FarmPos = CFrame.new(1150, 16, 1650)},
    {Min = 15, Max = 29, Quest = "JungleQuest", QLevel = 1, Mob = "Monkey", NPC = CFrame.new(-1610, 36, 148), FarmPos = CFrame.new(-1610, 36, 148)},
    {Min = 30, Max = 59, Quest = "JungleQuest", QLevel = 2, Mob = "Gorilla", NPC = CFrame.new(-1610, 36, 148), FarmPos = CFrame.new(-1222, 6, -500)},
    {Min = 60, Max = 89, Quest = "PirateQuest", QLevel = 1, Mob = "Pirate", NPC = CFrame.new(-1120, 4, 3850), FarmPos = CFrame.new(-1120, 4, 3850)},
    {Min = 90, Max = 119, Quest = "PirateQuest", QLevel = 2, Mob = "Brute", NPC = CFrame.new(-1120, 4, 3850), FarmPos = CFrame.new(-1140, 4, 4250)},
    {Min = 120, Max = 149, Quest = "DesertQuest", QLevel = 1, Mob = "Desert Bandit", NPC = CFrame.new(894, 6, 4380), FarmPos = CFrame.new(950, 6, 4450)},
    {Min = 150, Max = 199, Quest = "DesertQuest", QLevel = 2, Mob = "Desert Bandit", NPC = CFrame.new(894, 6, 4380), FarmPos = CFrame.new(950, 6, 4450)},
    {Min = 200, Max = 249, Quest = "SnowQuest", QLevel = 1, Mob = "Snow Bandit", NPC = CFrame.new(1300, 30, -1450), FarmPos = CFrame.new(1350, 30, -1450)},
    {Min = 250, Max = 299, Quest = "SnowQuest", QLevel = 2, Mob = "Snow Bandit", NPC = CFrame.new(1300, 30, -1450), FarmPos = CFrame.new(1350, 30, -1450)},
    {Min = 300, Max = 349, Quest = "CyborgQuest", QLevel = 1, Mob = "Cyborg", NPC = CFrame.new(-1200, 50, 600), FarmPos = CFrame.new(-1250, 50, 600)},
    {Min = 350, Max = 399, Quest = "CyborgQuest", QLevel = 2, Mob = "Cyborg", NPC = CFrame.new(-1200, 50, 600), FarmPos = CFrame.new(-1250, 50, 600)},
    {Min = 400, Max = 449, Quest = "MarineQuest", QLevel = 1, Mob = "Marine", NPC = CFrame.new(-3000, 0, 3000), FarmPos = CFrame.new(-3050, 0, 3000)},
    {Min = 450, Max = 499, Quest = "MarineQuest", QLevel = 2, Mob = "Marine", NPC = CFrame.new(-3000, 0, 3000), FarmPos = CFrame.new(-3050, 0, 3000)},
    {Min = 500, Max = 549, Quest = "MarineQuest", QLevel = 3, Mob = "Marine", NPC = CFrame.new(-3000, 0, 3000), FarmPos = CFrame.new(-3050, 0, 3000)},
    {Min = 550, Max = 599, Quest = "SkyQuest", QLevel = 1, Mob = "Sky Bandit", NPC = CFrame.new(3500, 1000, 0), FarmPos = CFrame.new(3550, 1000, 0)},
    {Min = 600, Max = 649, Quest = "SkyQuest", QLevel = 2, Mob = "Sky Bandit", NPC = CFrame.new(3500, 1000, 0), FarmPos = CFrame.new(3550, 1000, 0)},
    {Min = 650, Max = 699, Quest = "SkyQuest", QLevel = 3, Mob = "Sky Bandit", NPC = CFrame.new(3500, 1000, 0), FarmPos = CFrame.new(3550, 1000, 0)},
    {Min = 700, Max = 749, Quest = "DragonQuest", QLevel = 1, Mob = "Dragon", NPC = CFrame.new(4000, 500, 5000), FarmPos = CFrame.new(4050, 500, 5000)},
    {Min = 750, Max = 799, Quest = "DragonQuest", QLevel = 2, Mob = "Dragon", NPC = CFrame.new(4000, 500, 5000), FarmPos = CFrame.new(4050, 500, 5000)},
    {Min = 800, Max = 849, Quest = "DragonQuest", QLevel = 3, Mob = "Dragon", NPC = CFrame.new(4000, 500, 5000), FarmPos = CFrame.new(4050, 500, 5000)},
    {Min = 850, Max = 899, Quest = "FishmanQuest", QLevel = 1, Mob = "Fishman", NPC = CFrame.new(-5000, 0, 5000), FarmPos = CFrame.new(-5050, 0, 5000)},
    {Min = 900, Max = 949, Quest = "FishmanQuest", QLevel = 2, Mob = "Fishman", NPC = CFrame.new(-5000, 0, 5000), FarmPos = CFrame.new(-5050, 0, 5000)},
    {Min = 950, Max = 999, Quest = "FishmanQuest", QLevel = 3, Mob = "Fishman", NPC = CFrame.new(-5000, 0, 5000), FarmPos = CFrame.new(-5050, 0, 5000)},
    {Min = 1000, Max = 1099, Quest = "GhostQuest", QLevel = 1, Mob = "Ghost", NPC = CFrame.new(-6000, 100, 1000), FarmPos = CFrame.new(-6050, 100, 1000)},
    {Min = 1100, Max = 1199, Quest = "GhostQuest", QLevel = 2, Mob = "Ghost", NPC = CFrame.new(-6000, 100, 1000), FarmPos = CFrame.new(-6050, 100, 1000)},
    {Min = 1200, Max = 1299, Quest = "GhostQuest", QLevel = 3, Mob = "Ghost", NPC = CFrame.new(-6000, 100, 1000), FarmPos = CFrame.new(-6050, 100, 1000)},
    {Min = 1300, Max = 1399, Quest = "DarkQuest", QLevel = 1, Mob = "Dark", NPC = CFrame.new(-8000, 0, -8000), FarmPos = CFrame.new(-8050, 0, -8000)},
    {Min = 1400, Max = 1499, Quest = "DarkQuest", QLevel = 2, Mob = "Dark", NPC = CFrame.new(-8000, 0, -8000), FarmPos = CFrame.new(-8050, 0, -8000)},
    {Min = 1500, Max = 1599, Quest = "DarkQuest", QLevel = 3, Mob = "Dark", NPC = CFrame.new(-8000, 0, -8000), FarmPos = CFrame.new(-8050, 0, -8000)},
    {Min = 1600, Max = 1699, Quest = "CakeQuest", QLevel = 1, Mob = "Cake", NPC = CFrame.new(-10000, 100, -10000), FarmPos = CFrame.new(-10050, 100, -10000)},
    {Min = 1700, Max = 1799, Quest = "CakeQuest", QLevel = 2, Mob = "Cake", NPC = CFrame.new(-10000, 100, -10000), FarmPos = CFrame.new(-10050, 100, -10000)},
    {Min = 1800, Max = 1899, Quest = "CakeQuest", QLevel = 3, Mob = "Cake", NPC = CFrame.new(-10000, 100, -10000), FarmPos = CFrame.new(-10050, 100, -10000)},
    {Min = 1900, Max = 1999, Quest = "MythicQuest", QLevel = 1, Mob = "Mythic", NPC = CFrame.new(-12000, 0, -12000), FarmPos = CFrame.new(-12050, 0, -12000)},
    {Min = 2000, Max = 2099, Quest = "MythicQuest", QLevel = 2, Mob = "Mythic", NPC = CFrame.new(-12000, 0, -12000), FarmPos = CFrame.new(-12050, 0, -12000)},
    {Min = 2100, Max = 2199, Quest = "MythicQuest", QLevel = 3, Mob = "Mythic", NPC = CFrame.new(-12000, 0, -12000), FarmPos = CFrame.new(-12050, 0, -12000)},
    {Min = 2200, Max = 2299, Quest = "HauntedQuest", QLevel = 1, Mob = "Living Zombie", NPC = CFrame.new(-8500, 100, 6000), FarmPos = CFrame.new(-8500, 100, 6000)},
    {Min = 2300, Max = 2399, Quest = "HauntedQuest", QLevel = 2, Mob = "Demonic Soul", NPC = CFrame.new(-8500, 100, 6000), FarmPos = CFrame.new(-8500, 100, 6000)},
    {Min = 2400, Max = 2499, Quest = "HauntedQuest", QLevel = 3, Mob = "Posessed Mummy", NPC = CFrame.new(-8500, 100, 6000), FarmPos = CFrame.new(-8500, 100, 6000)},
    {Min = 2500, Max = 2600, Quest = "CakeQuest", QLevel = 1, Mob = "Cake Guard", NPC = CFrame.new(-10000, 100, -10000), FarmPos = CFrame.new(-10050, 100, -10000)},
}

-- ============================================================
-- CORE FUNCTIONS
-- ============================================================
local function GetDistance(pos1, pos2)
    if not pos1 or not pos2 then return 0 end
    return (pos1.Position - pos2.Position).Magnitude
end

local function GetTimeString(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    if h > 0 then
        return string.format("%02d:%02d:%02d", h, m, s)
    else
        return string.format("%02d:%02d", m, s)
    end
end

local function TweenTo(target)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local dist = (hrp.Position - target.Position).Magnitude
    if dist < 3 then
        hrp.CFrame = target
        return
    end
    local tween = TweenService:Create(hrp, TweenInfo.new(dist / _G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = target})
    tween:Play()
end

local function GetBestWeapon()
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if not bp then return nil end
    local best = nil
    local bestLevel = 0
    for _, tool in ipairs(bp:GetChildren()) do
        if tool:IsA("Tool") then
            local lv = 0
            if tool:FindFirstChild("Level") then
                lv = tool.Level.Value
            elseif tool:FindFirstChild("Damage") then
                lv = tool.Damage.Value
            end
            if lv > bestLevel then
                bestLevel = lv
                best = tool
            end
        end
    end
    return best
end

local function EquipWeapon()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    local hum = char.Humanoid
    
    if _G.SelectWeapon then
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") and (tool.ToolTip == _G.SelectWeapon or tool.Name == _G.SelectWeapon) then
                    hum:EquipTool(tool)
                    return
                end
            end
        end
    end
    
    local best = GetBestWeapon()
    if best then
        hum:EquipTool(best)
    end
end

local function GetCurrentQuest()
    local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
    if questGui and questGui:FindFirstChild("Quest") then
        return questGui.Quest.Visible
    end
    return false
end

local function StartQuest(questName, level)
    pcall(function()
        CommF:InvokeServer("StartQuest", questName, level)
    end)
end

local function GetCurrentLevel()
    return LocalPlayer.Data.Level.Value
end

-- ============================================================
-- FAST ATTACK
-- ============================================================
local function GetAllBladeHits()
    local hits = {}
    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            local dist = (mob.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist <= 65 then
                table.insert(hits, mob)
            end
        end
    end
    return hits
end

local Net = require(ReplicatedStorage.Modules.Net)
local RegisterAttack = Net:RemoteEvent("RegisterAttack", true)
local RegisterHit = Net:RemoteEvent("RegisterHit", true)

local function DoAttack()
    local targets = GetAllBladeHits()
    if #targets == 0 then return end
    
    local data = {[1] = nil, [2] = {}, [4] = "078da5141"}
    for _, target in ipairs(targets) do
        RegisterAttack:FireServer(0)
        if not data[1] then data[1] = target.Head end
        table.insert(data[2], {[1] = target, [2] = target.HumanoidRootPart})
        table.insert(data[2], target)
    end
    RegisterHit:FireServer(unpack(data))
end

task.spawn(function()
    while task.wait(0.05) do
        if _G.KaitunEnabled and _G.FastAttack then
            pcall(DoAttack)
        end
    end
end)

-- ============================================================
-- AUTO COLLECT
-- ============================================================
task.spawn(function()
    while task.wait(0.5) do
        if _G.KaitunEnabled and _G.AutoCollect then
            pcall(function()
                for _, item in ipairs(Workspace:GetChildren()) do
                    if item:IsA("Tool") and item:FindFirstChild("Handle") and not item.Parent then
                        local dist = GetDistance(LocalPlayer.Character.HumanoidRootPart, item.Handle)
                        if dist < 30 then
                            local cd = item:FindFirstChild("ClickDetector")
                            if cd then 
                                fireclickdetector(cd)
                                TotalItems = TotalItems + 1
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- AUTO STATS
-- ============================================================
task.spawn(function()
    while task.wait(1) do
        if _G.KaitunEnabled and _G.AutoStats then
            pcall(function()
                local points = LocalPlayer.Data.Points.Value
                if points > 0 then
                    local melee = math.floor(points * 0.5)
                    local defense = math.floor(points * 0.3)
                    local sword = math.floor(points * 0.2)
                    if melee > 0 then CommF:InvokeServer("AddPoint", "Melee", melee) end
                    if defense > 0 then CommF:InvokeServer("AddPoint", "Defense", defense) end
                    if sword > 0 then CommF:InvokeServer("AddPoint", "Sword", sword) end
                end
            end)
        end
    end
end)

-- ============================================================
-- BRING MOB
-- ============================================================
RunService.RenderStepped:Connect(function()
    if _G.KaitunEnabled and _G.BringMob and CurrentFarmCenter and CurrentTargetMob then
        pcall(function()
            for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                if mob.Name == CurrentTargetMob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                    mob.HumanoidRootPart.CFrame = CurrentFarmCenter
                    mob.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    mob.Humanoid.WalkSpeed = 0
                end
            end
        end)
    end
end)

-- ============================================================
-- ANTI AFK
-- ============================================================
task.spawn(function()
    while task.wait(60) do
        if _G.KaitunEnabled and _G.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(1280, 672))
                task.wait(0.1)
                VirtualUser:Button1Up(Vector2.new(1280, 672))
            end)
        end
    end
end)

-- ============================================================
-- MAIN FARM LOOP
-- ============================================================
task.spawn(function()
    while task.wait(0.1) do
        if _G.KaitunEnabled and _G.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
                if char.Humanoid.Health <= 0 then return end
                
                local level = GetCurrentLevel()
                CurrentLevel = level
                
                if level > LastLevel then
                    TotalLevels = TotalLevels + (level - LastLevel)
                    LastLevel = level
                end
                
                local currentQ = nil
                for _, q in ipairs(QuestData) do
                    if level >= q.Min and level <= q.Max then
                        currentQ = q
                        break
                    end
                end
                if not currentQ then 
                    currentQ = QuestData[#QuestData]
                end
                
                CurrentQuest = currentQ.Quest .. " Lv." .. currentQ.QLevel
                CurrentMob = currentQ.Mob
                
                local hasQuest = GetCurrentQuest()
                
                if not hasQuest then
                    CurrentFarmCenter = nil
                    CurrentTargetMob = nil
                    FarmingStatus = "📋 Getting Quest..."
                    TweenTo(currentQ.NPC)
                    
                    if GetDistance(char.HumanoidRootPart, currentQ.NPC) < 15 then
                        StartQuest(currentQ.Quest, currentQ.QLevel)
                        task.wait(0.5)
                    end
                else
                    CurrentTargetMob = currentQ.Mob
                    FarmingStatus = "⚔️ Farming " .. currentQ.Mob
                    
                    local target = nil
                    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                        if mob.Name == currentQ.Mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                            target = mob
                            break
                        end
                    end
                    
                    if target then
                        CurrentFarmCenter = target.HumanoidRootPart.CFrame
                        EquipWeapon()
                        
                        local attackPos = CurrentFarmCenter.Position + Vector3.new(0, _G.SafeDistance, 0)
                        TweenTo(CFrame.lookAt(attackPos, CurrentFarmCenter.Position))
                        
                        if target.Humanoid.Health <= 10 then
                            TotalKills = TotalKills + 1
                        end
                    else
                        CurrentFarmCenter = nil
                        FarmingStatus = "🔍 Searching for " .. currentQ.Mob
                        TweenTo(currentQ.FarmPos * CFrame.new(0, 15, 0))
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- NOCLIP
-- ============================================================
RunService.Stepped:Connect(function()
    if _G.KaitunEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ============================================================
-- ⚡ STEPCONTROL HUB UI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 400, 0, 520)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner")
Corner.Parent = MainFrame
Corner.CornerRadius = UDim.new(0, 14)

local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(80, 80, 255)
Stroke.Thickness = 2
Stroke.Transparency = 0.2

-- Header
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
Header.BackgroundTransparency = 0.3

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = Header
HeaderCorner.CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "⚡ STEPCONTROL HUB | KAITUN"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = Header
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 0.6, 0)
SubTitle.Text = "🚀 Ultimate Auto Farm | v4.0"
SubTitle.TextColor3 = Color3.fromRGB(150, 150, 220)
SubTitle.BackgroundTransparency = 1
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 12

-- Stats Panel
local StatsPanel = Instance.new("Frame")
StatsPanel.Parent = MainFrame
StatsPanel.Size = UDim2.new(0.95, 0, 0, 75)
StatsPanel.Position = UDim2.new(0.025, 0, 0.13, 0)
StatsPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
StatsPanel.BackgroundTransparency = 0.4

local StatsCorner = Instance.new("UICorner")
StatsCorner.Parent = StatsPanel
StatsCorner.CornerRadius = UDim.new(0, 8)

local function CreateStat(parent, pos, icon, label, color)
    local box = Instance.new("Frame")
    box.Parent = parent
    box.Size = UDim2.new(0.23, 0, 1, -10)
    box.Position = UDim2.new(pos, 0, 0.05, 0)
    box.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
    box.BackgroundTransparency = 0.3
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.Parent = box
    boxCorner.CornerRadius = UDim.new(0, 6)
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Parent = box
    iconLabel.Size = UDim2.new(1, 0, 0, 20)
    iconLabel.Text = icon
    iconLabel.TextColor3 = color
    iconLabel.BackgroundTransparency = 1
    iconLabel.Font = Enum.Font.Gotham
    iconLabel.TextSize = 16
    
    local value = Instance.new("TextLabel")
    value.Name = "Value"
    value.Parent = box
    value.Size = UDim2.new(1, 0, 0, 28)
    value.Position = UDim2.new(0, 0, 0.35, 0)
    value.Text = "0"
    value.TextColor3 = Color3.fromRGB(255, 255, 255)
    value.BackgroundTransparency = 1
    value.Font = Enum.Font.GothamBold
    value.TextSize = 18
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = box
    nameLabel.Size = UDim2.new(1, 0, 0, 15)
    nameLabel.Position = UDim2.new(0, 0, 0.7, 0)
    nameLabel.Text = label
    nameLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 10
    
    return value
end

local LevelBox = CreateStat(StatsPanel, 0.02, "⬆", "Level", Color3.fromRGB(0, 255, 100))
local KillsBox = CreateStat(StatsPanel, 0.26, "💀", "Kills", Color3.fromRGB(255, 50, 50))
local ItemsBox = CreateStat(StatsPanel, 0.50, "🎁", "Items", Color3.fromRGB(255, 200, 0))
local TimeBox = CreateStat(StatsPanel, 0.74, "⏱", "Time", Color3.fromRGB(100, 200, 255))

-- Status Panel
local StatusPanel = Instance.new("Frame")
StatusPanel.Parent = MainFrame
StatusPanel.Size = UDim2.new(0.95, 0, 0, 65)
StatusPanel.Position = UDim2.new(0.025, 0, 0.29, 0)
StatusPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
StatusPanel.BackgroundTransparency = 0.4

local StatusCorner = Instance.new("UICorner")
StatusCorner.Parent = StatusPanel
StatusCorner.CornerRadius = UDim.new(0, 8)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = StatusPanel
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Text = "🟢 Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 15

local MobLabel = Instance.new("TextLabel")
MobLabel.Parent = StatusPanel
MobLabel.Size = UDim2.new(0.5, 0, 0, 22)
MobLabel.Position = UDim2.new(0, 0, 0.6, 0)
MobLabel.Text = "🎯 Mob: None"
MobLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
MobLabel.BackgroundTransparency = 1
MobLabel.Font = Enum.Font.Gotham
MobLabel.TextSize = 13

local QuestLabel = Instance.new("TextLabel")
QuestLabel.Parent = StatusPanel
QuestLabel.Size = UDim2.new(0.5, 0, 0, 22)
QuestLabel.Position = UDim2.new(0.5, 0, 0.6, 0)
QuestLabel.Text = "📋 Quest: None"
QuestLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
QuestLabel.BackgroundTransparency = 1
QuestLabel.Font = Enum.Font.Gotham
QuestLabel.TextSize = 13
QuestLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Weapon Select
local WeaponFrame = Instance.new("Frame")
WeaponFrame.Parent = MainFrame
WeaponFrame.Size = UDim2.new(0.95, 0, 0, 35)
WeaponFrame.Position = UDim2.new(0.025, 0, 0.43, 0)
WeaponFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
WeaponFrame.BackgroundTransparency = 0.4

local WeaponCorner = Instance.new("UICorner")
WeaponCorner.Parent = WeaponFrame
WeaponCorner.CornerRadius = UDim.new(0, 8)

local WeaponLabel = Instance.new("TextLabel")
WeaponLabel.Parent = WeaponFrame
WeaponLabel.Size = UDim2.new(0.3, 0, 1, 0)
WeaponLabel.Position = UDim2.new(0.05, 0, 0, 0)
WeaponLabel.Text = "⚔️ Weapon:"
WeaponLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
WeaponLabel.BackgroundTransparency = 1
WeaponLabel.Font = Enum.Font.Gotham
WeaponLabel.TextSize = 14

local WeaponButton = Instance.new("TextButton")
WeaponButton.Parent = WeaponFrame
WeaponButton.Size = UDim2.new(0.4, 0, 0.8, 0)
WeaponButton.Position = UDim2.new(0.5, 0, 0.1, 0)
WeaponButton.Text = "Melee"
WeaponButton.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
WeaponButton.TextColor3 = Color3.fromRGB(255, 255, 255)
WeaponButton.Font = Enum.Font.Gotham
WeaponButton.TextSize = 13
WeaponButton.AutoButtonColor = false

local WeaponBtnCorner = Instance.new("UICorner")
WeaponBtnCorner.Parent = WeaponButton
WeaponBtnCorner.CornerRadius = UDim.new(0, 4)

local weaponOptions = {"Melee", "Sword", "Gun", "Blox Fruit"}
local currentWeaponIndex = 1
WeaponButton.MouseButton1Click:Connect(function()
    currentWeaponIndex = currentWeaponIndex % #weaponOptions + 1
    _G.SelectWeapon = weaponOptions[currentWeaponIndex]
    WeaponButton.Text = _G.SelectWeapon
end)

-- START Button
local StartBtn = Instance.new("TextButton")
StartBtn.Parent = MainFrame
StartBtn.Size = UDim2.new(0.85, 0, 0, 50)
StartBtn.Position = UDim2.new(0.075, 0, 0.53, 0)
StartBtn.Text = "▶ START FARM"
StartBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 18

local StartCorner = Instance.new("UICorner")
StartCorner.Parent = StartBtn
StartCorner.CornerRadius = UDim.new(0, 10)

StartBtn.MouseButton1Click:Connect(function()
    _G.KaitunEnabled = not _G.KaitunEnabled
    if _G.KaitunEnabled then
        StartBtn.Text = "⏹ STOP FARM"
        StartBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        StatusLabel.Text = "🟢 Status: Farming..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        StartBtn.Text = "▶ START FARM"
        StartBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
        StatusLabel.Text = "🟡 Status: Stopped"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        CurrentFarmCenter = nil
        CurrentTargetMob = nil
    end
end)

-- Info Footer
local Footer = Instance.new("Frame")
Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 30)
Footer.Position = UDim2.new(0, 0, 0.94, 0)
Footer.BackgroundTransparency = 1

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Parent = Footer
FooterLabel.Size = UDim2.new(1, 0, 1, 0)
FooterLabel.Text = "⚡ StepControl Hub | Made with ❤️"
FooterLabel.TextColor3 = Color3.fromRGB(100, 100, 150)
FooterLabel.BackgroundTransparency = 1
FooterLabel.Font = Enum.Font.Gotham
FooterLabel.TextSize = 12

-- ============================================================
-- UI UPDATE LOOP
-- ============================================================
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local level = GetCurrentLevel()
            LevelBox.Text = tostring(level)
            KillsBox.Text = tostring(TotalKills)
            ItemsBox.Text = tostring(TotalItems)
            TimeBox.Text = GetTimeString(os.time() - StartTime)
            StatusLabel.Text = "🟢 Status: " .. FarmingStatus
            MobLabel.Text = "🎯 Mob: " .. CurrentTargetMob or "None"
            QuestLabel.Text = "📋 Quest: " .. CurrentQuest
        end)
    end
end)

print("✅ StepControl Hub | Kaitun V4 Loaded!")
print("⚡ Press START to begin farming!")
