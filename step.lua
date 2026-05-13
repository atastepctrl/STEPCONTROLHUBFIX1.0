-- [[ STEPCONTROL HUB - BLOX FRUITS (SUPER FAST ATTACK EDITION) ]] --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local targetParent = game:GetService("CoreGui")
if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

if targetParent:FindFirstChild("StepControlFastAttack") then
    targetParent.StepControlFastAttack:Destroy()
end

-- ========================================================
-- [ ตัวแปรระบบควบคุมของจริง ]
-- ========================================================
_G.AutoFarm = false
_G.FastAttack = false -- ตัวแปรคุมระบบตีเร็วมากก
_G.FarmDistance = 5 

-- 1. ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlFastAttack"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

-- 2. Main Frame (หน้าต่างหลัก)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 380) -- ขยายขนาดหน้าต่างเล็กน้อยเพื่อรองรับปุ่มเพิ่ม
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1.2
MainStroke.Color = Color3.fromRGB(0, 210, 120)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- [ ปุ่มลากปรับขนาดขวาล่าง ]
local ResizeButton = Instance.new("TextButton")
ResizeButton.Size = UDim2.new(0, 16, 0, 16)
ResizeButton.Position = UDim2.new(1, -16, 1, -16)
ResizeButton.BackgroundColor3 = Color3.fromRGB(0, 210, 120)
ResizeButton.BackgroundTransparency = 0.8
ResizeButton.Text = "◢"
ResizeButton.TextColor3 = Color3.fromRGB(0, 210, 120)
ResizeButton.TextSize = 12
ResizeButton.Font = Enum.Font.SourceSansBold
ResizeButton.ZIndex = 10
ResizeButton.Parent = MainFrame

local isResizing = false
local startMousePos, startSize

ResizeButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = true
        startMousePos = UserInputService:GetMouseLocation()
        startSize = MainFrame.Size
        MainFrame.Draggable = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local currentMousePos = UserInputService:GetMouseLocation()
        local diffX = currentMousePos.X - startMousePos.X
        local diffY = currentMousePos.Y - startMousePos.Y
        MainFrame.Size = UDim2.new(0, math.max(400, startSize.X.Offset + diffX), 0, math.max(250, startSize.Y.Offset + diffY))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = false
        MainFrame.Draggable = true
    end
end)

-- Sidebar ด้านซ้าย
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(6, 7, 8)
Sidebar.BorderSizePixel = 0

local SideCorner = Instance.new("UICorner", Sidebar)
SideCorner.CornerRadius = UDim.new(0, 14)

local SidePatch = Instance.new("Frame", Sidebar)
SidePatch.Size = UDim2.new(0, 15, 1, 0)
SidePatch.Position = UDim2.new(1, -15, 0, 0)
SidePatch.BackgroundColor3 = Color3.fromRGB(6, 7, 8)
SidePatch.BorderSizePixel = 0

-- ปุ่ม Mac OS (ปุ่มแดงกดปิดสคริปต์ได้จริง)
local MacButtons = Instance.new("Frame", Sidebar)
MacButtons.Size = UDim2.new(0, 50, 0, 10)
MacButtons.Position = UDim2.new(0, 16, 0, 16)
MacButtons.BackgroundTransparency = 1

local colors = {Color3.fromRGB(255, 85, 80), Color3.fromRGB(255, 180, 40), Color3.fromRGB(35, 200, 60)}
for i, color in ipairs(colors) do
    local Dot = Instance.new("Frame", MacButtons)
    Dot.Size = UDim2.new(0, 10, 0, 10)
    Dot.Position = UDim2.new(0, (i-1) * 16, 0, 0)
    Dot.BackgroundColor3 = color
    Dot.BorderSizePixel = 0
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    local ActionBtn = Instance.new("TextButton", Dot)
    ActionBtn.Size = UDim2.new(1, 0, 1, 0)
    ActionBtn.BackgroundTransparency = 1
    ActionBtn.Text = ""
    if i == 1 then
        ActionBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() _G.AutoFarm = false _G.FastAttack = false end)
    end
end

local Brand = Instance.new("TextLabel", Sidebar)
Brand.Text = "STEPCONTROL"
Brand.Size = UDim2.new(1, -16, 0, 20)
Brand.Position = UDim2.new(0, 16, 0, 38)
Brand.TextColor3 = Color3.fromRGB(0, 230, 110)
Brand.TextSize = 13
Brand.Font = Enum.Font.FredokaOne
Brand.TextXAlignment = Enum.TextXAlignment.Left
Brand.BackgroundTransparency = 1

local function AddSidebarTab(text, icon, y_pos, tabName)
    local Tab = Instance.new("TextButton", Sidebar)
    Tab.Text = "  " .. icon .. "  " .. text
    Tab.Size = UDim2.new(1, -16, 0, 34)
    Tab.Position = UDim2.new(0, 8, 0, y_pos)
    Tab.Font = Enum.Font.SourceSansBold
    Tab.TextSize = 13
    Tab.TextXAlignment = Enum.TextXAlignment.Left
    Tab.BackgroundTransparency = tabName == "Main Farm" and 0 or 1
    Tab.BackgroundColor3 = Color3.fromRGB(12, 35, 22)
    Tab.TextColor3 = tabName == "Main Farm" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 125, 130)
    Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 8)
end
AddSidebarTab("Main Farm", "⚡", 75, "Main Farm")

-- พื้นที่ฟังก์ชันฝั่งขวา
local RightArea = Instance.new("Frame", MainFrame)
RightArea.Size = UDim2.new(1, -150, 1, 0)
RightArea.Position = UDim2.new(0, 150, 0, 0)
RightArea.BackgroundTransparency = 1

local HeaderText = Instance.new("TextLabel", RightArea)
HeaderText.Text = "STEPCONTROL HUB | Fast Attack Edition"
HeaderText.Size = UDim2.new(1, -20, 0, 30)
HeaderText.Position = UDim2.new(0, 20, 0, 14)
HeaderText.TextColor3 = Color3.fromRGB(240, 240, 245)
HeaderText.TextSize = 13
HeaderText.Font = Enum.Font.SourceSansBold
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.BackgroundTransparency = 1

local Card = Instance.new("Frame", RightArea)
Card.Size = UDim2.new(1, -35, 0, 240) -- ขยายขนาดกล่องฟังก์ชันการ์ด
Card.Position = UDim2.new(0, 20, 0, 52)
Card.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
Card.BorderSizePixel = 0
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(26, 32, 30)
CardStroke.Thickness = 1

local SectionTitle = Instance.new("TextLabel", Card)
SectionTitle.Text = "⚡ COMBAT & FARM CONTROLLER"
SectionTitle.Size = UDim2.new(1, -20, 0, 25)
SectionTitle.Position = UDim2.new(0, 16, 0, 10)
SectionTitle.TextColor3 = Color3.fromRGB(100, 105, 115)
SectionTitle.TextSize = 11
SectionTitle.Font = Enum.Font.SourceSansBold
SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
SectionTitle.BackgroundTransparency = 1

-- ฟังก์ชันสร้างปุ่มสวิตช์เปิด/ปิดบนการ์ด
local function CreateToggleOnCard(labelText, yPos, globalVarName)
    local ToggleLabel = Instance.new("TextLabel", Card)
    ToggleLabel.Text = labelText
    ToggleLabel.Size = UDim2.new(0, 250, 0, 30)
    ToggleLabel.Position = UDim2.new(0, 16, 0, yPos)
    ToggleLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
    ToggleLabel.TextSize = 13
    ToggleLabel.Font = Enum.Font.SourceSansBold
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.BackgroundTransparency = 1

    local Switch = Instance.new("TextButton", Card)
    Switch.Text = ""
    Switch.Size = UDim2.new(0, 44, 0, 22)
    Switch.Position = UDim2.new(1, -60, 0, yPos + 4)
    Switch.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local SwitchDot = Instance.new("Frame", Switch)
    SwitchDot.Size = UDim2.new(0, 18, 0, 18)
    SwitchDot.Position = UDim2.new(0, 2, 0, 2)
    SwitchDot.BackgroundColor3 = Color3.fromRGB(140, 145, 150)
    Instance.new("UICorner", SwitchDot).CornerRadius = UDim.new(1, 0)

    Switch.MouseButton1Click:Connect(function()
        _G[globalVarName] = not _G[globalVarName]
        if _G[globalVarName] then
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 200, 95)}):Play()
            TweenService:Create(SwitchDot, TweenInfo.new(0.15), {Position = UDim2.new(0, 24, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 38, 42)}):Play()
            TweenService:Create(SwitchDot, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(140, 145, 150)}):Play()
            ToggleLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
        end
    end)
end

-- ดึงปุ่มเปิดบอท และ ปุ่มตีเร็วมากก ขึ้นมาแสดงผล
CreateToggleOnCard("Auto Farm Level (เปิดบอทเก็บเวล)", 42, "AutoFarm")
CreateToggleOnCard("Super Fast Attack (ตีเร็วมากกกกกกก)", 85, "FastAttack")

-- ========================================================
-- [ กลไกแถบเลื่อน SLIDER ADJUSTMENT ]
-- ========================================================
local SliderLabel = Instance.new("TextLabel", Card)
SliderLabel.Text = "Farm Distance (ระยะห่างจากมอน)"
SliderLabel.Size = UDim2.new(0, 200, 0, 30)
SliderLabel.Position = UDim2.new(0, 16, 0, 140)
SliderLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
SliderLabel.TextSize = 13
SliderLabel.Font = Enum.Font.SourceSansBold
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.BackgroundTransparency = 1

local SliderValueText = Instance.new("TextLabel", Card)
SliderValueText.Text = "5"
SliderValueText.Size = UDim2.new(0, 40, 0, 30)
SliderValueText.Position = UDim2.new(1, -55, 0, 140)
SliderValueText.TextColor3 = Color3.fromRGB(0, 230, 110)
SliderValueText.TextSize = 13
SliderValueText.Font = Enum.Font.SourceSansBold
SliderValueText.TextXAlignment = Enum.TextXAlignment.Right
SliderValueText.BackgroundTransparency = 1

local SliderTrack = Instance.new("TextButton", Card)
SliderTrack.Text = ""
SliderTrack.Size = UDim2.new(1, -32, 0, 6)
SliderTrack.Position = UDim2.new(0, 16, 0, 180)
SliderTrack.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
SliderTrack.BorderSizePixel = 0
Instance.new("UICorner", SliderTrack).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame", SliderTrack)
SliderFill.Size = UDim2.new(0.33, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 95)
SliderFill.BorderSizePixel = 0
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

local SliderDot = Instance.new("Frame", SliderTrack)
SliderDot.Size = UDim2.new(0, 14, 0, 14)
SliderDot.Position = UDim2.new(0.33, -7, 0.5, -7)
SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SliderDot).CornerRadius = UDim.new(1, 0)

local dragging = false
local function updateSlider()
    local mousePos = UserInputService:GetMouseLocation().X
    local trackPos = SliderTrack.AbsolutePosition.X
    local trackWidth = SliderTrack.AbsoluteSize.X
    local percentage = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
    
    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    SliderDot.Position = UDim2.new(percentage, -7, 0.5, -7)
    local calculatedDistance = math.floor(percentage * 15)
    _G.FarmDistance = calculatedDistance
    SliderValueText.Text = tostring(calculatedDistance)
end

SliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        updateSlider()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ========================================================
-- [ ระบบความปลอดภัยและการสวมอาวุธ ]
-- ========================================================
local function EquipWeapon()
    local p = game.Players.LocalPlayer
    local backpack = p:FindFirstChild("Backpack")
    local char = p.Character
    if char and backpack and not char:FindFirstChildOfClass("Tool") then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                char.Humanoid:EquipTool(tool)
                break
            end
        end
    end
end

local function CheckAndGetQuest()
    local level = game.Players.LocalPlayer.Data.Level.Value
    local questName = (level >= 1 and level < 10) and "BanditQuest1" or "MonkeyQuest1"
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui and playerGui:FindFirstChild("Main") and not playerGui.Main:FindFirstChild("Quest") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", questName, 1)
    end
end

-- ========================================================
-- [ 🔥 CORE ลูปสปีดโจมตีทะลุโลก (SUPER FAST ATTACK LOGIC) ]
-- ========================================================
local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
local CameraShaker = require(game:GetService("ReplicatedStorage").Util.CameraShaker)
CameraShaker:Stop() -- สั่งปิดแอนิเมชันหน้าจอสั่นเวลารัวหมัด เพื่อลดอาการกระตุกของตัวเกม

task.spawn(function()
    while true do
        -- ถ้ากดเปิดปุ่ม Fast Attack ระบบจะเร่งความเร็ว Packet แบบไม่มีดีเลย์ (0 วินาที)
        if _G.FastAttack and _G.AutoFarm then
            task.wait() -- รัวสุดขีดตามเฟรมเรตเครื่อง
            pcall(function()
                -- ยิง Remote ดักอนิเมชันโจมตีโดยตรงข้ามขีดจำกัดแอนิเมชันปกติ [^1^]
                local activeController = CombatFramework.activeController
                if activeController and activeController.equippedWeapon then
                    activeController.attackandnoanim = true
                    activeController:attack()
                end
            end)
        else
            task.wait(0.2) -- ความเร็วปกติกรณีปิดปุ่มโปรตีเร็ว
        end
    end
end)

-- ลูปการบินฟาร์มมอนสเตอร์
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarm then
            pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                
                CheckAndGetQuest()
                
                if workspace:FindFirstChild("Enemies") then
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                            character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                            character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, _G.FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            
                            EquipWeapon()
                            
                            -- ออโต้คลิกสำหรับระบบธรรมดา (หรือคอยกดย้ำกรณีฟาสแอดแท็กทำงาน)
                            if not _G.FastAttack then
                                local VirtualUser = game:GetService("VirtualUser")
                                VirtualUser:CaptureController()
                                VirtualUser:ClickButton1(Vector2.new(850, 520))
                            end
                            break
                        end
                    end
                end
            end)
        end
    end
end)
