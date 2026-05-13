-- [[ STEPCONTROL HUB - HYPER PREMIUM EDITION (NO MAP LINKED) ]] --

local targetParent = game:GetService("CoreGui")
if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

if targetParent:FindFirstChild("StepControlHyper") then
    targetParent.StepControlHyper:Destroy()
end

-- 1. ตัวครอบหน้าจอทั้งหมด
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlHyper"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

-- 2. ตัวโครงเมนูหลัก (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 350)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 11, 13) -- ดำเนื้อออบซิเดียนเงา
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

-- เส้นขอบนีออนไล่เฉดเรืองแสง (Premium Outline)
local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.2
MainStroke.Color = Color3.fromRGB(0, 210, 120) -- เขียวนีออนมินต์
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- ========================================================
-- [ ฝั่งซ้าย: DEEP SIDEBAR & LOGO ]
-- ========================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(6, 7, 8) -- ดำมืดสนิทเพื่อขับตัวปุ่ม
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 14)
SideCorner.Parent = Sidebar

local SidePatch = Instance.new("Frame")
SidePatch.Size = UDim2.new(0, 15, 1, 0)
SidePatch.Position = UDim2.new(1, -15, 0, 0)
SidePatch.BackgroundColor3 = Color3.fromRGB(6, 7, 8)
SidePatch.BorderSizePixel = 0
SidePatch.Parent = Sidebar

-- ปุ่ม 3 สีสไตล์ Mac OS (Premium Glossy)
local MacButtons = Instance.new("Frame")
MacButtons.Size = UDim2.new(0, 50, 0, 10)
MacButtons.Position = UDim2.new(0, 16, 0, 16)
MacButtons.BackgroundTransparency = 1
MacButtons.Parent = Sidebar

local colors = {Color3.fromRGB(255, 85, 80), Color3.fromRGB(255, 180, 40), Color3.fromRGB(35, 200, 60)}
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

-- ชื่อสคริปต์สไตล์แบรนด์พรีเมียม (Neon Logo)
local Brand = Instance.new("TextLabel")
Brand.Text = "STEPCONTROL"
Brand.Size = UDim2.new(1, -16, 0, 20)
Brand.Position = UDim2.new(0, 16, 0, 38)
Brand.TextColor3 = Color3.fromRGB(0, 230, 110)
Brand.TextSize = 13
Brand.Font = Enum.Font.FredokaOne
Brand.TextXAlignment = Enum.TextXAlignment.Left
Brand.BackgroundTransparency = 1
Brand.Parent = Sidebar

-- แถบเส้นใต้โลโก้เพิ่มความหรู
local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, -32, 0, 1)
Line.Position = UDim2.new(0, 16, 0, 62)
Line.BackgroundColor3 = Color3.fromRGB(25, 30, 35)
Line.BorderSizePixel = 0
Line.Parent = Sidebar

-- ฟังก์ชันสร้างปุ่มใน Sidebar พร้อมลูกเล่นเรืองแสง (Hover Effect)
local function AddSidebarTab(text, icon, y_pos, isActive)
    local Tab = Instance.new("TextButton")
    Tab.Text = "  " .. icon .. "  " .. text
    Tab.Size = UDim2.new(1, -16, 0, 34)
    Tab.Position = UDim2.new(0, 8, 0, y_pos)
    Tab.Font = Enum.Font.SourceSansBold
    Tab.TextSize = 13
    Tab.TextXAlignment = Enum.TextXAlignment.Left
    Tab.Parent = Sidebar
    Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 8)

    if isActive then
        Tab.BackgroundColor3 = Color3.fromRGB(12, 35, 22)
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        local TabStroke = Instance.new("UIStroke", Tab)
        TabStroke.Color = Color3.fromRGB(0, 200, 95)
        TabStroke.Thickness = 0.8
    else
        Tab.BackgroundTransparency = 1
        Tab.TextColor3 = Color3.fromRGB(120, 125, 130)
        
        -- แอนิเมชันเวลาเมาส์ชี้
        Tab.MouseEnter:Connect(function()
            Tab.BackgroundTransparency = 0.95
            Tab.BackgroundColor3 = Color3.fromRGB(0, 230, 110)
            Tab.TextColor3 = Color3.fromRGB(240, 240, 240)
        end)
        Tab.MouseLeave:Connect(function()
            Tab.BackgroundTransparency = 1
            Tab.TextColor3 = Color3.fromRGB(120, 125, 130)
        end)
    end
end

AddSidebarTab("Main Farm", "⚡", 75, true)
AddSidebarTab("Auto Quest", "📜", 115, false)
AddSidebarTab("Teleport", "🌀", 155, false)
AddSidebarTab("Settings", "⚙️", 195, false)

-- ========================================================
-- [ ฝั่งขวา: CONTENT CONTAINER & ELEMENTS ]
-- ========================================================
local RightArea = Instance.new("Frame")
RightArea.Size = UDim2.new(1, -150, 1, 0)
RightArea.Position = UDim2.new(0, 150, 0, 0)
RightArea.BackgroundTransparency = 1
RightArea.Parent = MainFrame

-- หัวข้อขวาบนสไตล์โปรพรีเมียม
local HeaderText = Instance.new("TextLabel")
HeaderText.Text = "Premium Client v2.5 [Beta Experience]"
HeaderText.Size = UDim2.new(1, -20, 0, 30)
HeaderText.Position = UDim2.new(0, 20, 0, 14)
HeaderText.TextColor3 = Color3.fromRGB(240, 240, 245)
HeaderText.TextSize = 13
HeaderText.Font = Enum.Font.SourceSansBold
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.BackgroundTransparency = 1
HeaderText.Parent = RightArea

-- การ์ดกลุ่มฟังก์ชัน (Premium Glossy Card)
local Card = Instance.new("Frame")
Card.Size = UDim2.new(1, -35, 0, 120)
Card.Position = UDim2.new(0, 20, 0, 52)
Card.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
Card.BorderSizePixel = 0
Card.Parent = RightArea
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(26, 32, 30)
CardStroke.Thickness = 1

local SectionTitle = Instance.new("TextLabel")
SectionTitle.Text = "⚡ MAIN CONTROLLER"
SectionTitle.Size = UDim2.new(1, -20, 0, 25)
SectionTitle.Position = UDim2.new(0, 16, 0, 10)
SectionTitle.TextColor3 = Color3.fromRGB(100, 105, 115)
SectionTitle.TextSize = 11
SectionTitle.Font = Enum.Font.SourceSansBold
SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
SectionTitle.BackgroundTransparency = 1
SectionTitle.Parent = Card

-- 🔘 รายละเอียดฟังก์ชันที่ 1
local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Text = "Enable Custom System (ทดสอบปุ่มเปิด)"
ToggleLabel.Size = UDim2.new(0, 250, 0, 30)
ToggleLabel.Position = UDim2.new(0, 16, 0, 42)
ToggleLabel.TextColor3 = Color3.fromRGB(200, 205, 210)
ToggleLabel.TextSize = 13
ToggleLabel.Font = Enum.Font.SourceSansBold
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Parent = Card

-- สวิตช์ปุ่มเลื่อนสีเขียว (Interactive Switch)
local Switch = Instance.new("TextButton")
Switch.Text = ""
Switch.Size = UDim2.new(0, 44, 0, 22)
Switch.Position = UDim2.new(1, -60, 0, 46)
Switch.BackgroundColor3 = Color3.fromRGB(0, 200, 95)
Switch.Parent = Card
Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

local SwitchDot = Instance.new("Frame")
SwitchDot.Size = UDim2.new(0, 18, 0, 18)
SwitchDot.Position = UDim2.new(0, 24, 0, 2) -- เซ็ตให้อยู่ฝั่งขวา (ON) ไว้อวดความสวยงาม
SwitchDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SwitchDot.Parent = Switch
Instance.new("UICorner", SwitchDot).CornerRadius = UDim.new(1, 0)

-- 🔘 รายละเอียดฟังก์ชันที่ 2 (แบบสถานะปิด)
local ToggleLabel2 = Instance.new("TextLabel")
ToggleLabel2.Text = "Bypass Anticheat Security (ทดสอบปุ่มปิด)"
ToggleLabel2.Size = UDim2.new(0, 250, 0, 30)
ToggleLabel2.Position = UDim2.new(0, 16, 0, 78)
ToggleLabel2.TextColor3 = Color3.fromRGB(150, 155, 160)
ToggleLabel2.TextSize = 13
ToggleLabel2.Font = Enum.Font.SourceSansBold
ToggleLabel2.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel2.BackgroundTransparency = 1
ToggleLabel2.Parent = Card

local Switch2 = Instance.new("TextButton")
Switch2.Text = ""
Switch2.Size = UDim2.new(0, 44, 0, 22)
Switch2.Position = UDim2.new(1, -60, 0, 82)
Switch2.BackgroundColor3 = Color3.fromRGB(35, 38, 42) -- สีเทามืดสนิทตอนปิดใช้งาน
Switch2.Parent = Card
Instance.new("UICorner", Switch2).CornerRadius = UDim.new(1, 0)

local SwitchDot2 = Instance.new("Frame")
SwitchDot2.Size = UDim2.new(0, 18, 0, 18)
SwitchDot2.Position = UDim2.new(0, 2, 0, 2) -- ชิดซ้ายชวนกด (OFF)
SwitchDot2.BackgroundColor3 = Color3.fromRGB(140, 145, 150)
SwitchDot2.Parent = Switch2
Instance.new("UICorner", SwitchDot2).CornerRadius = UDim.new(1, 0)
