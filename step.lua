-- [[ STEPCONTROL HUB - NO-CRASH FIX FOR DELTA ]] --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local targetParent = game:GetService("CoreGui")
if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

if targetParent:FindFirstChild("StepControlNoCrash") then
    targetParent.StepControlNoCrash:Destroy()
end

-- 1. ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlNoCrash"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

-- 2. Main Frame (หน้าต่างหลักปรับขนาดได้)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 340)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1.2
MainStroke.Color = Color3.fromRGB(0, 210, 120)

-- [ ปุ่มลากปรับขนาดขวาล่าง ]
local ResizeButton = Instance.new("TextButton", MainFrame)
ResizeButton.Size = UDim2.new(0, 16, 0, 16)
ResizeButton.Position = UDim2.new(1, -16, 1, -16)
ResizeButton.BackgroundColor3 = Color3.fromRGB(0, 210, 120)
ResizeButton.BackgroundTransparency = 0.8
ResizeButton.Text = "◢"
ResizeButton.TextColor3 = Color3.fromRGB(0, 210, 120)
ResizeButton.TextSize = 12
ResizeButton.ZIndex = 10

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

-- Sidebar ด้านซ้าย + ปุ่มสามสี Mac
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(6, 7, 8)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar)

local SidePatch = Instance.new("Frame", Sidebar)
SidePatch.Size = UDim2.new(0, 15, 1, 0)
SidePatch.Position = UDim2.new(1, -15, 0, 0)
SidePatch.BackgroundColor3 = Color3.fromRGB(6, 7, 8)

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
    Instance.new("UICorner", Dot)
    
    local ActionBtn = Instance.new("TextButton", Dot)
    ActionBtn.Size = UDim2.new(1, 0, 1, 0)
    ActionBtn.BackgroundTransparency = 1
    ActionBtn.Text = ""
    if i == 1 then
        ActionBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
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

local Tab = Instance.new("TextButton", Sidebar)
Tab.Text = "  ⚡  Main Farm"
Tab.Size = UDim2.new(1, -14, 0, 32)
Tab.Position = UDim2.new(0, 7, 0, 75)
Tab.BackgroundColor3 = Color3.fromRGB(12, 35, 22)
Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab.Font = Enum.Font.SourceSansBold
Tab.TextSize = 13
Tab.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Tab)

local TabStroke = Instance.new("UIStroke", Tab)
TabStroke.Color = Color3.fromRGB(0, 200, 90)

-- พื้นที่ฟังก์ชันฝั่งขวา
local RightArea = Instance.new("Frame", MainFrame)
RightArea.Size = UDim2.new(1, -140, 1, 0)
RightArea.Position = UDim2.new(0, 140, 0, 0)
RightArea.BackgroundTransparency = 1

local HeaderText = Instance.new("TextLabel", RightArea)
HeaderText.Text = "STEPCONTROL HUB | Safe Loader v2.5"
HeaderText.Size = UDim2.new(1, -20, 0, 30)
HeaderText.Position = UDim2.new(0, 20, 0, 15)
HeaderText.TextColor3 = Color3.fromRGB(240, 240, 245)
HeaderText.TextSize = 13
HeaderText.Font = Enum.Font.SourceSansBold
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.BackgroundTransparency = 1

local Card = Instance.new("Frame", RightArea)
Card.Size = UDim2.new(1, -35, 0, 150)
Card.Position = UDim2.new(0, 20, 0, 50)
Card.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
Instance.new("UICorner", Card)

local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(30, 30, 35)

local SectionTitle = Instance.new("TextLabel", Card)
SectionTitle.Text = "⚡ LOCAL FARM CORE"
SectionTitle.Size = UDim2.new(1, -20, 0, 25)
SectionTitle.Position = UDim2.new(0, 15, 0, 8)
SectionTitle.TextColor3 = Color3.fromRGB(110, 115, 125)
SectionTitle.TextSize = 11
SectionTitle.Font = Enum.Font.SourceSansBold
SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
SectionTitle.BackgroundTransparency = 1

-- ========================================================
-- [ ปุ่ม LAUNCHER แบบเซฟเครื่องสูงสุด โค้ดดิบไม่ผ่านเว็บนอก ]
-- ========================================================
local LaunchButton = Instance.new("TextButton", Card)
LaunchButton.Text = "🚀 LAUNCH AUTOMATIC ENGINE"
LaunchButton.Size = UDim2.new(1, -30, 0, 45)
LaunchButton.Position = UDim2.new(0, 15, 0, 45)
LaunchButton.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
LaunchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LaunchButton.Font = Enum.Font.SourceSansBold
LaunchButton.TextSize = 14
Instance.new("UICorner", LaunchButton).CornerRadius = UDim.new(0, 8)

local DescText = Instance.new("TextLabel", Card)
DescText.Text = "ระบบเซฟตี้ทำงาน: เปิดใช้งานระบบควบคุมความปลอดภัยเพื่อประมวลผลคำสั่งฟาร์มผ่านความจุ CPU ภายในเครื่องโดยตรง"
DescText.Size = UDim2.new(1, -30, 0, 40)
DescText.Position = UDim2.new(0, 15, 0, 100)
DescText.TextColor3 = Color3.fromRGB(130, 135, 140)
DescText.TextSize = 11
DescText.Font = Enum.Font.SourceSans
DescText.TextWrapped = true
DescText.TextXAlignment = Enum.TextXAlignment.Left
DescText.BackgroundTransparency = 1

-- ระบบคุมการสตาร์ทสมองกลภายในโค้ด (Local Engine Activation)
local running = false
LaunchButton.MouseButton1Click:Connect(function()
    running = not running
    if running then
        LaunchButton.Text = "🟢 ENGINE IS RUNNING... (CLICK TO STOP)"
        LaunchButton.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
        
        -- บังคับปิดฉากสั่นลดความหน่วง
        pcall(function()
            require(game:GetService("ReplicatedStorage").Util.CameraShaker):Stop()
        end)
        
        -- คำสั่งลูปบินฟาร์มและสแกนมอนสเตอร์ในตัวเกมแบบเขียนดิบ (ปลอดภัยต่อหน่วยความจำ)
        task.spawn(function()
            while running do
                task.wait(0.5) -- ตั้งความเร็วแบบเสถียรป้องกัน Delta เด้ง
                pcall(function()
                    local p = game.Players.LocalPlayer
                    local char = p.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        
                        -- ตรวจสอบและสวมใส่อาวุธ
                        if not char:FindFirstChildOfClass("Tool") and p:FindFirstChild("Backpack") then
                            for _, tool in pairs(p.Backpack:GetChildren()) do
                                if tool:IsA("Tool") then char.Humanoid:EquipTool(tool) break end
                            end
                        end
                        
                        -- ตรวจสอบและวาร์ปไปหามอนสเตอร์ที่มีเลือด > 0 ในเกาะ
                        if workspace:FindFirstChild("Enemies") then
                            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                                if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                                    char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                                    char.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                    
                                    -- คำสั่งตีกระหน่ำผ่านระบบจำลองคลิกความเร็วคงที่
                                    local VU = game:GetService("VirtualUser")
                                    VU:CaptureController()
                                    VU:ClickButton1(Vector2.new(850, 520))
                                    break
                                end
                            end
                        end
                    end
                end)
            end
        end)
    else
        LaunchButton.Text = "🚀 LAUNCH AUTOMATIC ENGINE"
        LaunchButton.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    end
end)

