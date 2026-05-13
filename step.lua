-- [[ STEPCONTROL HUB - PREMIUM EDITION (400-700 THB STYLE) ]] --

local TweenService = game:GetService("TweenService")
local targetParent = game:GetService("CoreGui")
if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

if targetParent:FindFirstChild("StepControlPremium") then
    targetParent.StepControlPremium:Destroy()
end

-- 1. หน้าต่างหลัก (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlPremium"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

-- 2. ตัวโครงเมนูหลัก (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 360)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 15) -- สีดำเนื้อ Obsidian มืดลึกพรีเมียม
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

-- ใส่เส้นขอบเรืองแสงจางๆ รอบตัวเมนูหลัก (Glow Border)
local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(30, 45, 35)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- ========================================================
-- [ ฝั่งซ้าย: PREMIUM SIDEBAR ]
-- ========================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 10) -- ดำเงาลึกเพื่อขับฝั่งขวาให้เด่น
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 14)
SideCorner.Parent = Sidebar

local SidePatch = Instance.new("Frame")
SidePatch.Size = UDim2.new(0, 14, 1, 0)
SidePatch.Position = UDim2.new(1, -14, 0, 0)
SidePatch.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
SidePatch.BorderSizePixel = 0
SidePatch.Parent = Sidebar

-- ปุ่ม 3 สีสไตล์ Mac OS (Premium Finish)
local MacButtons = Instance.new("Frame")
MacButtons.Size = UDim2.new(0, 50, 0, 12)
MacButtons.Position = UDim2.new(0, 16, 0, 16)
MacButtons.BackgroundTransparency = 1
MacButtons.Parent = Sidebar

local colors = {Color3.fromRGB(255, 90, 85), Color3.fromRGB(255, 190, 45), Color3.fromRGB(40, 205, 65)}
for i, color in ipairs(colors) do
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 10, 0, 10)
    Dot.Position = UDim2.new(0, (i-1) * 16, 0, 0)
    Dot.BackgroundColor3 = color
    Dot.BorderSizePixel = 0
    Dot.Parent = MacButtons
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    if i == 1 then
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(1, 0, 1, 0)
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.Text = ""
        CloseBtn.Parent = Dot
        CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    end
end

-- ชื่อแบรนด์แบบมินิมอล (Brand Logo Text)
local Brand = Instance.new("TextLabel")
Brand.Text = "STEPCONTROL"
Brand.Size = UDim2.new(1, -16, 0, 20)
Brand.Position = UDim2.new(0, 16, 0, 42)
Brand.TextColor3 = Color3.fromRGB(0, 230, 110) -- เขียวนีออนเกรดพรีเมียม
Brand.TextSize = 13
Brand.Font = Enum.Font.FredokaOne
Brand.TextXAlignment = Enum.TextXAlignment.Left
Brand.BackgroundTransparency = 1
Brand.Parent = Sidebar

-- ฟังก์ชันสำหรับสร้างปุ่มเมนูด้านซ้ายที่มีอนิเมชันสวยงาม
local function CreateTab(name, icon, pos_y, active)
    local Button = Instance.new("TextButton")
    Button.Text = "  " .. icon .. "  " .. name
    Button.Size = UDim2.new(1, -16, 0, 32)
    Button.Position = UDim2.new(0, 8, 0, pos_y)
    Button.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 145)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 13
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.BorderSizePixel = 0
    Button.Parent = Sidebar
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

    if active then
        Button.BackgroundColor3 = Color3.fromRGB(15, 45, 25)
        local TabStroke = Instance.new("UIStroke", Button)
        TabStroke.Color = Color3.fromRGB(0, 200, 90)
        TabStroke.Thickness = 1
    else
        Button.BackgroundTransparency = 1
    end

    -- อนิเมชันเวลาเอาเมาส์มาชี้ (Hover EFFECT)
    Button.MouseEnter:Connect(function()
        if not active then
            TweenService:Create(Button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.9}):Play()
            Button.BackgroundColor3 = Color3.fromRGB(0, 200, 90)
        end
    end)
    Button.MouseLeave:Connect(function()
        if not active then
            TweenService:Create(Button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(140, 140, 145), BackgroundTransparency = 1}):Play()
        end
    end)
    return Button
end

CreateTab("Auto Farm", "⚡", 80, true)
CreateTab("Auto Quest", "📜", 116, false)
CreateTab("Dungeon/Raid", "⚔️", 152, false)
CreateTab("Settings", "⚙️", 188, false)

-- ========================================================
-- [ ฝั่งขวา: HEADERS & PRESETS CONTROLS ]
-- ========================================================
local RightArea = Instance.new("Frame")
RightArea.Size = UDim2.new(1, -150, 1, 0)
RightArea.Position = UDim2.new(0, 150, 0, 0)
RightArea.BackgroundTransparency = 1
RightArea.Parent = MainFrame

local HeaderText = Instance.new("TextLabel")
HeaderText.Text = "Attack on Titan Revolution  v2.4"
HeaderText.Size = UDim2.new(1, -20, 0, 30)
HeaderText.Position = UDim2.new(0, 20, 0, 15)
HeaderText.TextColor3 = Color3.fromRGB(240, 240, 245)
HeaderText.TextSize = 14
HeaderText.Font = Enum.Font.SourceSansBold
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.BackgroundTransparency = 1
HeaderText.Parent = RightArea

-- พื้นที่วางตัวคอนโทรลแบบ Scrollable
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -30, 1, -65)
Container.Position = UDim2.new(0, 20, 0, 50)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 45)
Container.CanvasSize = UDim2.new(0, 0, 0, 350)
Container.Parent = RightArea

-- การแบ่งกลุ่มฟังก์ชันย่อย (Card Section)
local Card = Instance.new("Frame")
Card.Size = UDim2.new(1, -5, 0, 160)
Card.BackgroundColor3 = Color3.fromRGB(18, 18, 22) -- การ์ดพื้นหลังฟังก์ชันสไตล์โมเดิร์น
Card.BorderSizePixel = 0
Card.Parent = Container
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(25, 25, 30)
CardStroke.Thickness = 1

local SectionTitle = Instance.new("TextLabel")
SectionTitle.Text = "MAIN CONTROLLER"
SectionTitle.Size = UDim2.new(1, -20, 0, 25)
SectionTitle.Position = UDim2.new(0, 15, 0, 10)
SectionTitle.TextColor3 = Color3.fromRGB(100, 105, 115) -- หัวข้อสีเทาสุขุม
SectionTitle.TextSize = 11
SectionTitle.Font = Enum.Font.SourceSansBold
SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
SectionTitle.BackgroundTransparency = 1
SectionTitle.Parent = Card

-- ========================================================
-- [ ตัวเลือกที่ 1: PREMIUM TOGGLE SWITCH ]
-- ========================================================
local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Text = "Auto Farm Level"
ToggleLabel.Size = UDim2.new(0, 200, 0, 30)
ToggleLabel.Position = UDim2.new(0, 15, 0, 40)
ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
ToggleLabel.TextSize = 13
ToggleLabel.Font = Enum.Font.SourceSansBold
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Parent = Card

local Switch = Instance.new("TextButton")
Switch.Text = ""
Switch.Size = UDim2.new(0, 42, 0, 20)
Switch.Position = UDim2.new(1, -57, 0, 45)
Switch.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Switch.Parent = Card
local SwCorner = Instance.new("UICorner", Switch)
SwCorner.CornerRadius = UDim.new(1, 0)

local SwitchDot = Instance.new("Frame")
SwitchDot.Size = UDim2.new(0, 16, 0, 16)
SwitchDot.Position = UDim2.new(0, 2, 0, 2)
SwitchDot.BackgroundColor3 = Color3.fromRGB(180, 180, 185)
SwitchDot.Parent = Switch
Instance.new("UICorner", SwitchDot).CornerRadius = UDim.new(1, 0)

local _G_FarmState = false
Switch.MouseButton1Click:Connect(function()
    _G_FarmState = not _G_FarmState
    if _G_FarmState then
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 90)}):Play()
        TweenService:Create(SwitchDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 24, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    else
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        TweenService:Create(SwitchDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(180, 180, 185)}):Play()
    end
end)

-- ========================================================
-- [ ตัวเลือกที่ 2: PREMIUM SLIDER (แถบเลื่อนปรับค่าความปลอดภัย) ]
-- ========================================================
local SliderLabel = Instance.new("TextLabel")
SliderLabel.Text = "Fail Safe At (%)"
SliderLabel.Size = UDim2.new(0, 200, 0, 30)
SliderLabel.Position = UDim2.new(0, 15, 0, 85)
SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
SliderLabel.TextSize = 13
SliderLabel.Font = Enum.Font.SourceSansBold
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.BackgroundTransparency = 1
SliderLabel.Parent = Card

local SliderValueText = Instance.new("TextLabel")
SliderValueText.Text = "50%"
SliderValueText.Size = UDim2.new(0, 40, 0, 30)
SliderValueText.Position = UDim2.new(1, -55, 0, 85)
SliderValueText.TextColor3 = Color3.fromRGB(0, 230, 110)
SliderValueText.TextSize = 13
SliderValueText.Font = Enum.Font.SourceSansBold
SliderValueText.TextXAlignment = Enum.TextXAlignment.Right
SliderValueText.BackgroundTransparency = 1
SliderValueText.Parent = Card

local SliderTrack = Instance.new("TextButton")
SliderTrack.Text = ""
SliderTrack.Size = UDim2.new(1, -30, 0, 5)
SliderTrack.Position = UDim2.new(0, 15, 0, 125)
SliderTrack.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
SliderTrack.BorderSizePixel = 0
SliderTrack.Parent = Card
Instance.new("UICorner", SliderTrack).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.5, 0, 1, 0) -- ค่าเริ่มต้นที่ 50%
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 90)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderTrack
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

local SliderDot = Instance.new("Frame")
SliderDot.Size = UDim2.new(0, 13, 0, 13)
SliderDot.Position = UDim2.new(0.5, -6, 0.5, -6)
SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderDot.Parent = SliderTrack
Instance.new("UICorner", SliderDot).CornerRadius = UDim.new(1, 0)

-- ระบบคำนวณและลาก Slider สมจริงแบบโปรนอก
local UIS = game:GetService("UserInputService")
local dragging = false

local function updateSlider()
    local mousePos = UIS:GetMouseLocation().X
    local trackPos = SliderTrack.AbsolutePosition.X
    local trackWidth = SliderTrack.AbsoluteSize.X
    local percentage = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
    
    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    SliderDot.Position = UDim2.new(percentage, -6, 0.5, -6)
    SliderValueText.Text = math.floor(percentage * 100) .. "%"
end

SliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        updateSlider()
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider()
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
