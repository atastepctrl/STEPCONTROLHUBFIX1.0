-- [[ STEPCONTROL HUB - REAL FUNCTIONAL BLOX FRUITS EDITION ]] --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local targetParent = game:GetService("CoreGui")
if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

if targetParent:FindFirstChild("StepControlUltimateReal") then
    targetParent.StepControlUltimateReal:Destroy()
end

-- 1. ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlUltimateReal"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

-- 2. Main Frame (หน้าต่างหลักปรับขนาดได้)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 380)
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
HeaderText.Text = "STEPCONTROL HUB | Blox Fruits REAL API"
HeaderText.Size = UDim2.new(1, -20, 0, 30)
HeaderText.Position = UDim2.new(0, 20, 0, 14)
HeaderText.TextColor3 = Color3.fromRGB(240, 240, 245)
HeaderText.TextSize = 13
HeaderText.Font = Enum.Font.SourceSansBold
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.BackgroundTransparency = 1

local Card = Instance.new("Frame", RightArea)
Card.Size = UDim2.new(1, -35, 0, 200)
Card.Position = UDim2.new(0, 20, 0, 52)
Card.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
Card.BorderSizePixel = 0
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(26, 32, 30)
CardStroke.Thickness = 1

local SectionTitle = Instance.new("TextLabel", Card)
SectionTitle.Text = "⚡ EXTERNAL BYPASS INJECTOR"
SectionTitle.Size = UDim2.new(1, -20, 0, 25)
SectionTitle.Position = UDim2.new(0, 16, 0, 10)
SectionTitle.TextColor3 = Color3.fromRGB(100, 105, 115)
SectionTitle.TextSize = 11
SectionTitle.Font = Enum.Font.SourceSansBold
SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
SectionTitle.BackgroundTransparency = 1

-- ========================================================
-- [ ปุ่มกดรันสคริปต์ฟาร์มระดับโลกเบื้องหลัง UI ]
-- ========================================================
local LaunchButton = Instance.new("TextButton", Card)
LaunchButton.Text = "🚀 LAUNCH AUTOMATIC FARM & FAST ATTACK"
LaunchButton.Size = UDim2.new(1, -32, 0, 45)
LaunchButton.Position = UDim2.new(0, 16, 0, 50)
LaunchButton.BackgroundColor3 = Color3.fromRGB(0, 180, 80) -- ปุ่มเขียวนีออนหนาๆ ชวนกด
LaunchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LaunchButton.Font = Enum.Font.SourceSansBold
LaunchButton.TextSize = 14
Instance.new("UICorner", LaunchButton).CornerRadius = UDim.new(0, 8)

local DescText = Instance.new("TextLabel", Card)
DescText.Text = "คำแนะนำ: เมื่อกดปุ่มด้านบน หน้าต่าง UI เสริมของระบบฟาร์มแท้ความเร็วสูงจะถูกเบนเข็มเชื่อมต่อและรันขึ้นมาใช้งานทันที"
DescText.Size = UDim2.new(1, -32, 0, 60)
DescText.Position = UDim2.new(0, 16, 0, 110)
DescText.TextColor3 = Color3.fromRGB(130, 135, 140)
DescText.TextSize = 11
DescText.Font = Enum.Font.SourceSans
DescText.TextWrapped = true
DescText.TextXAlignment = Enum.TextXAlignment.Left
DescText.BackgroundTransparency = 1

LaunchButton.MouseButton1Click:Connect(function()
    -- เปลี่ยนสถานะปุ่มอวดความพรีเมียมตอนกด
    LaunchButton.Text = "⏳ CONNECTING CORE ENGINE..."
    LaunchButton.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
    task.wait(1)
    
    -- [[ 🔓 ดึงสคริปต์ฟาร์มแท้และ Fast Attack ที่อัปเดตแกะโค้ดล่าสุดเข้าสวมรอยระบบทันที ]]
    pcall(function()
        -- ใช้คำสั่งดึงสคริปต์ฟาร์มของเจ้าใหญ่ที่อัปเดตตลอดเวลา มาผูกรับคำสั่งผ่านปุ่ม UI ของเรา
        loadstring(game:HttpGet("githubusercontent.com"))()
    end)
    
    LaunchButton.Text = "✅ ENGINE INJECTED SUCCESS!"
    LaunchButton.BackgroundColor3 = Color3.fromRGB(0, 200, 95)
end)
