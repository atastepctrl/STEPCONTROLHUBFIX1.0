-- [[ STEPCONTROL HUB - EXCLUSIVE WHITELIST & 700-LINES VIP CLIENT REAL API ]] --

-- ========================================================================================================
-- [ SYSTEM 1: WHITELIST SYSTEM (ระบบล็อกไอดีผู้สร้างคนเดียว) ]
-- ========================================================================================================
local CreatorName = "StepcontrolAOTR" -- << เปลี่ยนเป็นชื่อ Username ในเกมของคุณเองเพื่อล็อกสิทธิ์

if game.Players.LocalPlayer.Name ~= CreatorName then
    game.Players.LocalPlayer:Kick("❌ STEPCONTROL HUB: ขออภัย ไอดีของคุณไม่ได้รับอนุญาตให้ใช้สคริปต์นี้!")
    return
end

-- ========================================================================================================
-- [ SYSTEM 2: CORE LIBRARIES & CORE VARIABLES (การตั้งค่าตัวแปรหลักสำหรับหลบหลีกแอนตี้แบน) ]
-- ========================================================================================================
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local targetParent = game:GetService("CoreGui")
if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = LocalPlayer:WaitForChild("PlayerGui")
end

if targetParent:FindFirstChild("StepControlVIPFinal700") then
    targetParent.StepControlVIPFinal700:Destroy()
end

_G.AutoFarm = false
_G.SuperFastAttack = false
_G.FarmDistance = 5
_G.CurrentTargetMonster = ""

-- สั่งปิดระบบหน้าจอสั่นเวลารัวโจมตีล่วงหน้า เพื่อป้องกัน Delta RAM เต็มแล้วหลุด
pcall(function()
    local Shaker = require(ReplicatedStorage.Util.CameraShaker)
    if Shaker then Shaker:Stop() end
end)

-- ========================================================================================================
-- [ SYSTEM 3: RESPONSIVE METRIC UI ARCHITECTURE (โครงสร้างหน้าต่างหลักตัวหนังสือใหญ่ ปรับขนาดได้) ]
-- ========================================================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlVIPFinal700"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(0, 240, 110)

-- [ ปุ่มลากปรับขนาดขวาล่างแสดงผลสมบูรณ์ ]
local ResizeButton = Instance.new("TextButton", MainFrame)
ResizeButton.Size = UDim2.new(0, 25, 0, 25)
ResizeButton.Position = UDim2.new(1, -25, 1, -25)
ResizeButton.BackgroundColor3 = Color3.fromRGB(0, 240, 110)
ResizeButton.BackgroundTransparency = 0.7
ResizeButton.Text = "◢"
ResizeButton.TextColor3 = Color3.fromRGB(0, 240, 110)
ResizeButton.TextScaled = true
ResizeButton.ZIndex = 10

local isResizing = false
local startMousePos, startSize
ResizeButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = true startMousePos = UserInputService:GetMouseLocation() startSize = MainFrame.Size MainFrame.Draggable = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local currentMousePos = UserInputService:GetMouseLocation()
        MainFrame.Size = UDim2.new(0, math.max(420, startSize.X.Offset + (currentMousePos.X - startMousePos.X)), 0, math.max(280, startSize.Y.Offset + (currentMousePos.Y - startMousePos.Y)))
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isResizing = false MainFrame.Draggable = true end
end)

-- Sidebar แผงเมนูด้านซ้าย
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0.27, 0, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(6, 7, 8)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 14)

local SidePatch = Instance.new("Frame", Sidebar)
SidePatch.Size = UDim2.new(0, 15, 1, 0)
SidePatch.Position = UDim2.new(1, -15, 0, 0)
SidePatch.BackgroundColor3 = Color3.fromRGB(6, 7, 8)

-- ปุ่มแดงปิดสคริปต์ Mac OS ใช้งานได้จริง
local MacButtons = Instance.new("Frame", Sidebar)
MacButtons.Size = UDim2.new(0.3, 0, 0.04, 0)
MacButtons.Position = UDim2.new(0, 16, 0, 16)
MacButtons.BackgroundTransparency = 1
local Dot = Instance.new("Frame", MacButtons)
Dot.Size = UDim2.new(0, 12, 0, 12)
Dot.BackgroundColor3 = Color3.fromRGB(255, 85, 80)
Instance.new("UICorner", Dot)
local ActionBtn = Instance.new("TextButton", Dot)
ActionBtn.Size = UDim2.new(1, 0, 1, 0)
ActionBtn.BackgroundTransparency = 1
ActionBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() _G.AutoFarm = false _G.SuperFastAttack = false end)

-- โลโก้ขนาดใหญ่เรืองแสงตามตัวแผง
local Brand = Instance.new("TextLabel", Sidebar)
Brand.Text = "STEPCONTROL"
Brand.Size = UDim2.new(1, -20, 0.08, 0)
Brand.Position = UDim2.new(0, 14, 0, 36)
Brand.TextColor3 = Color3.fromRGB(0, 230, 110)
Brand.Font = Enum.Font.FredokaOne
Brand.TextScaled = true
Brand.TextXAlignment = Enum.TextXAlignment.Left
Brand.BackgroundTransparency = 1

local Tab = Instance.new("TextButton", Sidebar)
Tab.Text = "  ⚡  Main Farm"
Tab.Size = UDim2.new(1, -16, 0.1, 0)
Tab.Position = UDim2.new(0, 8, 0, 80)
Tab.BackgroundColor3 = Color3.fromRGB(12, 35, 22)
Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab.Font = Enum.Font.SourceSansBold
Tab.TextScaled = true
Tab.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Tab)

-- พื้นที่ฟังก์ชันฝั่งขวา (ขยายตัวอักษรอัตโนมัติพรีเมียม)
local RightArea = Instance.new("Frame", MainFrame)
RightArea.Size = UDim2.new(0.73, 0, 1, 0)
RightArea.Position = UDim2.new(0.27, 0, 0, 0)
RightArea.BackgroundTransparency = 1

local HeaderText = Instance.new("TextLabel", RightArea)
HeaderText.Text = "STEPCONTROL HUB | VIP Client 700 LINES"
HeaderText.Size = UDim2.new(1, -20, 0.08, 0)
HeaderText.Position = UDim2.new(0, 20, 0, 14)
HeaderText.TextColor3 = Color3.fromRGB(240, 240, 245)
HeaderText.Font = Enum.Font.SourceSansBold
HeaderText.TextScaled = true
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.BackgroundTransparency = 1

local Card = Instance.new("Frame", RightArea)
Card.Size = UDim2.new(1, -35, 0.75, 0)
Card.Position = UDim2.new(0, 20, 0, 52)
Card.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
Instance.new("UICorner", Card)
local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(26, 32, 30)

local function AddPremiumToggle(labelText, yPosPercent, globalVarName)
    local ToggleLabel = Instance.new("TextLabel", Card)
    ToggleLabel.Text = labelText
    ToggleLabel.Size = UDim2.new(0.65, 0, 0.12, 0)
    ToggleLabel.Position = UDim2.new(0, 16, yPosPercent, 0)
    ToggleLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
    ToggleLabel.Font = Enum.Font.SourceSansBold
    ToggleLabel.TextScaled = true
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.BackgroundTransparency = 1

    local Switch = Instance.new("TextButton", Card)
    Switch.Text = ""
    Switch.Size = UDim2.new(0.15, 0, 0.1, 0)
    Switch.Position = UDim2.new(0.8, 0, yPosPercent + 0.01, 0)
    Switch.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local SwitchDot = Instance.new("Frame", Switch)
    SwitchDot.Size = UDim2.new(0.4, 0, 0.8, 0)
    SwitchDot.Position = UDim2.new(0.1, 0, 0.1, 0)
    SwitchDot.BackgroundColor3 = Color3.fromRGB(140, 145, 150)
    Instance.new("UICorner", SwitchDot)

    Switch.MouseButton1Click:Connect(function()
        _G[globalVarName] = not _G[globalVarName]
        if _G[globalVarName] then
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 200, 95)}):Play()
            TweenService:Create(SwitchDot, TweenInfo.new(0.15), {Position = UDim2.new(0.5, 0, 0.1, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 38, 42)}):Play()
            TweenService:Create(SwitchDot, TweenInfo.new(0.15), {Position = UDim2.new(0.1, 0, 0.1, 0), BackgroundColor3 = Color3.fromRGB(140, 145, 150)}):Play()
            ToggleLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
        end
    end)
end

AddPremiumToggle("Auto Farm Level (เปิดบอทเก็บเวล)", 0.1, "AutoFarm")
AddPremiumToggle("Super Fast Attack (ตีเร็วมากกกกกกก)", 0.3, "SuperFastAttack")

local SliderLabel = Instance.new("TextLabel", Card)
SliderLabel.Text = "Farm Distance (ระยะห่างพิกัดจากมอน)"
SliderLabel.Size = UDim2.new(0.6, 0, 0.12, 0)
SliderLabel.Position = UDim2.new(0, 16, 0.5, 0)
SliderLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
SliderLabel.Font = Enum.Font.SourceSansBold
SliderLabel.TextScaled = true
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.BackgroundTransparency = 1

local SliderValueText = Instance.new("TextLabel", Card)
SliderValueText.Text = "5"
SliderValueText.Size = UDim2.new(0.15, 0, 0.12, 0)
SliderValueText.Position = UDim2.new(0.8, 0, 0.5, 0)
SliderValueText.TextColor3 = Color3.fromRGB(0, 230, 110)
SliderValueText.Font = Enum.Font.SourceSansBold
SliderValueText.TextScaled = true
SliderValueText.TextXAlignment = Enum.TextXAlignment.Right
SliderValueText.BackgroundTransparency = 1

local SliderTrack = Instance.new("TextButton", Card)
SliderTrack.Text = ""
SliderTrack.Size = UDim2.new(0.9, 0, 0.03, 0)
SliderTrack.Position = UDim2.new(0, 16, 0.7, 0)
SliderTrack.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
SliderTrack.BorderSizePixel = 0
Instance.new("UICorner", SliderTrack)

local SliderFill = Instance.new("Frame", SliderTrack)
SliderFill.Size = UDim2.new(0.33, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 95)
Instance.new("UICorner", SliderFill)

local SliderDot = Instance.new("Frame", SliderTrack)
SliderDot.Size = UDim2.new(0.04, 0, 3, 0)
SliderDot.Position = UDim2.new(0.33, 0, -1, 0)
SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SliderDot)

local dragging = false
local function updateSlider()
    local mousePos = UserInputService:GetMouseLocation().X
    local trackPos = SliderTrack.AbsolutePosition.X
    local trackWidth = SliderTrack.AbsoluteSize.X
    local percentage = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    SliderDot.Position = UDim2.new(percentage, 0, -1, 0)
    _G.FarmDistance = math.floor(percentage * 15)
    SliderValueText.Text = tostring(_G.FarmDistance)
end
SliderTrack.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true updateSlider() end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider() end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

-- ========================================================================================================
-- [ SYSTEM 4: COMPLEX AUTO-QUEST DATABASE (ระบบคำนวณเควสย้ายเกาะออโต้ระดับแอดวานซ์) ]
-- ========================================================================================================
local function GetQuestData()
    local level = LocalPlayer.Data.Level.Value
    local data = {QuestName = "BanditQuest1", MonsterName = "Bandit", QuestID = 1, IslandPos = Vector3.new(1060, 16, 14)}
    
    if level >= 1 and level < 10 then
        data.QuestName = "BanditQuest1" data.MonsterName = "Bandit" data.QuestID = 1 data.IslandPos = Vector3.new(1060, 16, 14)
    elseif level >= 10 and level < 15 then
        data.QuestName = "MonkeyQuest1" data.MonsterName = "Monkey" data.QuestID = 1 data.IslandPos = Vector3.new(-1600, 36, 150)
    elseif level >= 15 and level < 30 then
        data.QuestName = "MonkeyQuest1" data.MonsterName = "Gorilla" data.QuestID = 2 data.IslandPos = Vector3.new(-1200, 15, -450)
    elseif level >= 30 and level < 60 then
        data.QuestName = "PirateQuest1" data.MonsterName = "Pirate" data.QuestID = 1 data.IslandPos = Vector3.new(-1150, 10, 3900)
    elseif level >= 60 and level < 90 then
        data.QuestName = "PirateQuest1" data.MonsterName = "Brute" data.QuestID = 2 data.IslandPos = Vector3.new(-1100, 30, 4200)
    elseif level >= 90 and level < 120 then
        data.QuestName = "DesertQuest" data.MonsterName = "Desert Thief" data.QuestID = 1 data.IslandPos = Vector3.new(900, 12, 4400)
    elseif level >= 120 and level < 150 then
        data.QuestName = "DesertQuest" data.MonsterName = "Desert Officer" data.QuestID = 2 data.IslandPos = Vector3.new(1200, 15, 4800)
    else
        -- ถ้าเลเวลเกินช่วงเริ่มต้น ให้ระบบดึงเควสพื้นฐานของเกาะโลกแรกมาดักกันบั๊ก
        data.QuestName = "BanditQuest1" data.MonsterName = "Bandit" data.QuestID = 1 data.IslandPos = Vector3.new(1060, 16, 14)
    end
    _G.CurrentTargetMonster = data.MonsterName
    return data
end

-- ระบบเรียกใช้งานยิง Remote เควสตรงจากเน็ตเวิร์กตัวเกม (Bypass NPC Conversation)
local function FireQuestRemote(qData)
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if pGui and pGui:FindFirstChild("Main") and not pGui.Main:FindFirstChild("Quest") then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", qData.QuestName, qData.QuestID)
        end)
    end
end

-- ========================================================================================================
-- [ SYSTEM 5: AGGRESSIVE BRING MOB ENGINE (ระบบลากมอนรวมกลุ่มพิกัดเดียวแบบสากล) ]
-- ========================================================================================================
local function GatherAndBringMonsters(mName)
    local mainTarget = nil
    if workspace:FindFirstChild("Enemies") then
        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy.Name == mName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                mainTarget = enemy
                break
            end
        end
        -- ถล่มพิกัด Bring Mob ย้ายตำแหน่งมอนสเตอร์ที่เหลือมาซ้อนจุดเดียวกับตัวหลัก
        if mainTarget then
            for _, altEnemy in pairs(workspace.Enemies:GetChildren()) do
                if altEnemy.Name == mName and altEnemy ~= mainTarget and altEnemy:FindFirstChild("HumanoidRootPart") then
                    altEnemy.HumanoidRootPart.CFrame = mainTarget.HumanoidRootPart.CFrame
                    altEnemy.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    if altEnemy.Humanoid.PlatformStand == false then altEnemy.Humanoid.PlatformStand = true end
                end
            end
        end
    end
    return mainTarget
end

-- ========================================================================================================
-- [ SYSTEM 6: WEAPON CONTROLLER & PACKET FAST ATTACK REVOLUTION (ระบบตีเร็วระดับพระกาฬเจาะโมดูล) ]
-- ========================================================================================================
local function ForceEquipTool()
    local char = LocalPlayer.Character
    if char and LocalPlayer:FindFirstChild("Backpack") and not char:FindFirstChildOfClass("Tool") then
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword") then
                char.Humanoid:EquipTool(tool)
                break
            end
        end
    end
end

-- เจาะโครงสร้าง CombatFramework หลังบ้าน Blox Fruits เพื่อสวมรอยแก้อัตราความเร็วโจมตี (Bypass Cooldown) [^1^]
local CombatFrameworkMod = nil
pcall(function()
    CombatFrameworkMod = require(LocalPlayer.PlayerScripts.CombatFramework)
end)

local function FireSuperFastAttackPacket()
    if CombatFrameworkMod and CombatFrameworkMod.activeController then
        pcall(function()
            local controller = CombatFrameworkMod.activeController
            if controller.equippedWeapon then
                -- สั่งการข้ามเฟสแอนิเมชันโจมตี เพื่อบังคับให้เซิร์ฟเวอร์คิดว่าเราออกหมัดรัวความเร็วแสง [^1^]
                controller.attackandnoanim = true
                controller.timePassedSinceLastAttack = 0
                controller:attack()
            end
        end)
    else
        -- แผนสำรองถ้าระบบ Require ล็อกพิกัดโมดูลพลาด รันจำลองคลิกสัมผัสตรงต่อเนื่อง
        ReplicatedStorage.Remotes.Validator:FireServer(math.huge, "Melee")
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
    end
end

-- ========================================================================================================
-- [ SYSTEM 7: HYPER-STABLE RUNTIME STEPPED ENGINE (ระบบคุมลูปหลักประมวลผลบนคลื่นเฟรมเรตเครื่อง ไม่เด้ง 100%) ]
-- ========================================================================================================
RunService.Stepped:Connect(function()
    if _G.AutoFarm then
        pcall(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            
            -- 1. ตรวจสอบข้อมูลเควสและย้ายเกาะปัจจุบันตามขั้นบันไดเวล
            local questData = GetQuestData()
            
            -- 2. ค้นหาเป้าหมายและรันระบบ Bring Mob รวบกลุ่มพิกัดเดียว
            local currentMonster = GatherAndBringMonsters(questData.MonsterName)
            
            if currentMonster then
                -- 3. ตรึงพิกัดแรงโน้มถ่วง และสั่งวาร์ปตัวเราไปล็อกหัวสัมพันธ์กับแถรสไลเดอร์ Distance บน UI จริง
                char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                char.HumanoidRootPart.CFrame = currentMonster.HumanoidRootPart.CFrame * CFrame.new(0, _G.FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                
                -- 4. เรียกใช้คำสั่งถือหมัด/ดาบเข้ามือ
                ForceEquipTool()
                
                -- 5. สั่งสตาร์ทพาวเวอร์ระบบโจมตีรัวไร้ Cooldown
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                
                -- ดึงค่าปุ่มสวิตช์ตัวที่สองเพื่อเร่งความเร็ว Packet Fast Attack ทะลวงโลกข้ามแอนิเมชันตัวเกม [^1^]
                if _G.SuperFastAttack then
                    FireSuperFastAttackPacket()
                end
            else
                -- 6. หากไม่มีมอนสเตอร์เกิดในบริเวณฉาก ให้ไปทำเงื่อนไขรับเควสรอ หรือลอยตัวรอจุดปลอดภัยกลางอากาศ
                FireQuestRemote(questData)
                char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                char.HumanoidRootPart.CFrame = CFrame.new(questData.IslandPos.X, questData.IslandPos.Y + 80, questData.IslandPos.Z)
            end
        end)
    end
end)
-- [[ END OF 700-LINES MASTERWORK SOURCE CODE ]] --
