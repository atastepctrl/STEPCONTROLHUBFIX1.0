-- =================================================================
-- BLOX FRUITS KAITUN V4 ULTIMATE (FULL FARM SYSTEM)
-- =================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- [1] CONFIGURATION
_G.KaitunEnabled = false
_G.BringMobEnabled = true
_G.FastAttackEnabled = true
_G.TweenSpeed = 350
_G.SafeDistance = 5
_G.AutoCollect = true
_G.AutoBuyAbilities = true

-- [2] COMPLETE QUEST DATABASE (ทุกช่วงเลเวล)
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
}

-- [3] REMOTE SPY DATA (จากข้อมูลจริง)
local Remotes = {
    CommF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_"),
    StartQuest = "StartQuest",
    AddPoint = "AddPoint",
    BuyHaki = "BuyHaki",
    BuyFruit = "BuyFruit",
}

-- [4] NOCLIP ENGINE
RunService.Stepped:Connect(function()
    if _G.KaitunEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- [5] COMBAT FRAMEWORK BYPASS (จาก RemoteSpy)
local CombatFramework = nil
local CameraShaker = nil

task.spawn(function()
    while not CombatFramework do
        pcall(function()
            CombatFramework = require(LocalPlayer.PlayerScripts.CombatFramework)
            CameraShaker = require(LocalPlayer.PlayerScripts.CombatFramework.CameraShaker)
        end)
        task.wait(0.1)
    end
end)

-- [6] FAST ATTACK ENGINE (จำลองการคลิกจริง)
task.spawn(function()
    RunService.RenderStepped:Connect(function()
        if _G.KaitunEnabled and _G.FastAttackEnabled and CombatFramework then
            pcall(function()
                local ac = CombatFramework.activeController
                if ac then
                    ac.timeToNextAttack = 0
                    ac.increment = 3
                    ac.hitboxMagnitude = 40
                    ac.attacking = false
                    ac.blocking = false
                    
                    -- จำลองการคลิกซ้าย
                    VirtualUser:CaptureController()
                    VirtualUser:Button1Down(Vector2.new(1280, 672))
                    
                    -- ส่ง Remote แทนการตี
                    local args = {
                        [1] = "Hit",
                        [2] = {
                            ["Size"] = 30,
                            ["Position"] = LocalPlayer.Character.HumanoidRootPart.Position,
                            ["Time"] = tick(),
                        }
                    }
                    ReplicatedStorage.Remotes.CommF_:FireServer(unpack(args))
                end
            end)
        end
    end)
end)

-- [7] HARD BRING MOB ENGINE
local CurrentFarmCenter = nil
local CurrentTargetMobName = nil
local MobList = {}

-- ดึงมอนทุกตัว
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            MobList = {}
            for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                    table.insert(MobList, mob)
                end
            end
        end)
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.KaitunEnabled and _G.BringMobEnabled and CurrentFarmCenter and CurrentTargetMobName then
        pcall(function()
            for _, mob in ipairs(MobList) do
                if mob.Name == CurrentTargetMobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    local hrp = mob.HumanoidRootPart
                    hrp.CFrame = CurrentFarmCenter
                    hrp.CanCollide = false
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    mob.Humanoid.WalkSpeed = 0
                    mob.Humanoid.JumpPower = 0
                    
                    if mob:FindFirstChild("Head") then mob.Head.CanCollide = false end
                end
            end
        end)
    end
end)

-- [8] TWEEN ENGINE (ใช้ BodyVelocity จริง)
local currentTween = nil
local function MoveTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    
    if distance < 3 then
        if currentTween then currentTween:Cancel() end
        hrp.CFrame = targetCFrame
        return
    end

    -- สร้าง BodyVelocity
    local bv = hrp:FindFirstChild("KaitunBV") or Instance.new("BodyVelocity")
    bv.Name = "KaitunBV"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = (targetCFrame.Position - hrp.Position).Unit * math.min(_G.TweenSpeed, distance * 2)
    bv.Parent = hrp
    
    -- หมุนหันหน้า
    hrp.CFrame = CFrame.lookAt(hrp.Position, targetCFrame.Position)
end

-- [9] AUTO COLLECT ITEMS
task.spawn(function()
    while task.wait(0.5) do
        if _G.KaitunEnabled and _G.AutoCollect then
            pcall(function()
                for _, item in ipairs(Workspace:GetChildren()) do
                    if item:IsA("Tool") and item:FindFirstChild("Handle") and not item.Parent then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - item.Handle.Position).Magnitude
                        if distance < 30 then
                            fireclickdetector(item:FindFirstChild("ClickDetector"))
                        end
                    end
                end
            end)
        end
    end
end)

-- [10] AUTO BUY HAKI
task.spawn(function()
    while task.wait(5) do
        if _G.KaitunEnabled and _G.AutoBuyAbilities then
            pcall(function()
                local playerLevel = LocalPlayer.Data.Level.Value
                if playerLevel >= 1000 then
                    local args = {
                        [1] = "BuyHaki",
                        [2] = "Enhancement",
                    }
                    ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
                end
            end)
        end
    end
end)

-- [11] AUTO EQUIP BEST WEAPON
local function EquipBestWeapon()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    if not backpack or not char then return end

    local bestTool = nil
    local bestDamage = 0
    
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            -- เช็คจากค่า Damage หรือ Level
            local damage = 0
            if tool:FindFirstChild("Damage") then
                damage = tool.Damage.Value
            elseif tool:FindFirstChild("Level") then
                damage = tool.Level.Value * 10
            end
            
            if damage > bestDamage then
                bestDamage = damage
                bestTool = tool
            end
        end
    end
    
    if bestTool then
        char.Humanoid:EquipTool(bestTool)
    end
end

-- [12] AUTO STATS (จาก RemoteSpy)
task.spawn(function()
    while task.wait(1) do
        if _G.KaitunEnabled then
            pcall(function()
                local points = LocalPlayer.Data.Points.Value
                if points > 0 then
                    local meleePoints = math.floor(points * 0.6)
                    local defPoints = math.floor(points * 0.3)
                    local swordPoints = math.floor(points * 0.1)
                    
                    if meleePoints > 0 then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", meleePoints)
                    end
                    if defPoints > 0 then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", defPoints)
                    end
                    if swordPoints > 0 then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", swordPoints)
                    end
                end
            end)
        end
    end
end)

-- [13] MAIN FARM LOOP (ด้วย RemoteSpy)
local currentQuest = nil
local questStatus = ""

task.spawn(function()
    while task.wait(0.03) do
        if _G.KaitunEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
                if char.Humanoid.Health <= 0 then return end
                
                local playerLevel = LocalPlayer.Data.Level.Value
                
                -- หาเควสที่เหมาะสม
                local currentQ = QuestData[1]
                for _, q in ipairs(QuestData) do
                    if playerLevel >= q.Min and playerLevel <= q.Max then
                        currentQ = q
                        break
                    end
                end
                
                -- ตรวจสอบสถานะเควสจาก Remote
                if not currentQuest or currentQuest.Quest ~= currentQ.Quest then
                    currentQuest = currentQ
                end
                
                -- ตรวจสอบว่ามีเควสหรือไม่ (ผ่าน Remote)
                local hasQuest = false
                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
                if questGui then
                    local questFrame = questGui:FindFirstChild("Quest")
                    if questFrame then
                        hasQuest = questFrame.Visible
                    end
                end
                
                if not hasQuest then
                    CurrentFarmCenter = nil
                    CurrentTargetMobName = nil
                    MoveTo(currentQ.NPC)
                    
                    if (char.HumanoidRootPart.Position - currentQ.NPC.Position).Magnitude < 12 then
                        -- รับเควส
                        local success = ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", currentQ.Quest, currentQ.QLevel)
                        if success then
                            questStatus = "Quest Started"
                        else
                            questStatus = "Quest Failed"
                        end
                    end
                else
                    CurrentTargetMobName = currentQ.Mob
                    
                    -- หามอน
                    local targetMob = nil
                    for _, mob in ipairs(MobList) do
                        if mob.Name == currentQ.Mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            targetMob = mob
                            break
                        end
                    end
                    
                    if targetMob then
                        CurrentFarmCenter = targetMob.HumanoidRootPart.CFrame
                        EquipBestWeapon()
                        
                        -- ตำแหน่งโจมตี
                        local attackPos = CurrentFarmCenter.Position + Vector3.new(0, _G.SafeDistance, 0)
                        MoveTo(CFrame.lookAt(attackPos, CurrentFarmCenter.Position))
                    else
                        CurrentFarmCenter = nil
                        MoveTo(currentQ.FarmPos * CFrame.new(0, 15, 0))
                    end
                end
            end)
        end
    end)
end)

-- [14] ANTI AFK
task.spawn(function()
    while task.wait(300) do
        if _G.KaitunEnabled then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(1280, 672))
                VirtualUser:Button1Down(Vector2.new(1280, 672))
            end)
        end
    end
end)

-- [15] UI CONTROL PANEL
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "KaitunV4Ultimate"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 180)
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Active = true
MainFrame.Draggable = true

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "KAITUN V4 ULTIMATE"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

-- Status
local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0.3, 0)
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 14

-- Toggle Button
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleBtn.Text = "START FARM"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16

ToggleBtn.MouseButton1Click:Connect(function()
    _G.KaitunEnabled = not _G.KaitunEnabled
    if _G.KaitunEnabled then
        ToggleBtn.Text = "FARMING..."
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
        StatusLabel.Text = "Status: Farming"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        ToggleBtn.Text = "START FARM"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
        StatusLabel.Text = "Status: Stopped"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        CurrentFarmCenter = nil
        CurrentTargetMobName = nil
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("KaitunBV")
            if bv then bv:Destroy() end
        end
    end
end)

-- Level Display
local LevelLabel = Instance.new("TextLabel", MainFrame)
LevelLabel.Size = UDim2.new(0.5, 0, 0, 25)
LevelLabel.Position = UDim2.new(0, 0, 0.8, 0)
LevelLabel.Text = "Level: 0"
LevelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LevelLabel.BackgroundTransparency = 1
LevelLabel.Font = Enum.Font.SourceSans
LevelLabel.TextSize = 14

-- Update Level
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            LevelLabel.Text = "Level: " .. tostring(LocalPlayer.Data.Level.Value)
        end)
    end
end)

print("Kaitun V4 Ultimate Loaded!")
print("Status: Ready to Farm!")
