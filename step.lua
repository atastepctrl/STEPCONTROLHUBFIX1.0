-- [[ STEPCONTROL HUB - LIGHTWEIGHT PREMIUM UI ]] --

-- ระบบคัดกรองโฟลเดอร์สำหรับแสดงผล UI เพื่อความปลอดภัยบน Delta
local targetParent = game:GetService("CoreGui")
if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- บังคับลบหน้าต่างเก่าออกทุกครั้งก่อนรันใหม่ ป้องกันปัญหาจอบั๊กค้าง
if targetParent:FindFirstChild("StepControlFinal") then
    targetParent.StepControlFinal:Destroy()
end

-- 1. ตัวครอบหน้าจอทั้งหมด (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlFinal"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

-- 2. โครงเมนูหลัก (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 340) -- ขนาดหน้าต่างกะทัดรัด ไม่กินทรัพยากรเครื่อง
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 16) -- สีดำ Obsidian พรีเมียม
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- สามารถกดค้างแล้วลากขยับเมนูบนจอมือถือได้
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- เส้นขอบเรืองแสงสีเขียวจางๆ เพิ่มความหรูหรา (Glow Border)
local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1
MainStroke.Color = Color3.fromRGB(0, 180, 80)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- ========================================================
-- [ ฝั่งซ้าย: SIDEBAR & MAC BUTTONS ]
-- ========================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 10) -- สีดำเนื้อแมตต์เข้มข้น
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 12)
SideCorner.Parent = Sidebar

-- ถมมุมขวาของ Sidebar เพื่อให้ขอบต่อฝั่งขวาเรียบเนียนเป๊ะตามภาพ
local SidePatch = Instance.new("Frame")
SidePatch.Size = UDim2.new(0, 12, 1, 0)
SidePatch.Position = UDim2.new(1, -12, 0, 0)
SidePatch.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
SidePatch.BorderSizePixel = 0
SidePatch.Parent = Sidebar

-- ปุ่ม 3 สีระดับพรีเมียมสไตล์ Mac OS (แดง, เหลือง, เขียว)
local MacButtons = Instance.new("Frame")
MacButtons.Size = UDim2.new(0, 50, 0, 10)
MacButtons.Position = UDim2.new(0, 14, 0, 14)
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
    
    -- กดปุ่มแดงเพื่อเปิด/ปิดหน้าต่าง UI ได้จริง
    if i == 1 then
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(1, 0, 1, 0)
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.Text = ""
        CloseBtn.Parent = Dot
        CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    end
end

-- ชื่อสคริปต์ตัวหนาเน้นๆ (Brand Logo)
local Brand = Instance.new("TextLabel")
Brand.Text = "STEPCONTROL"
Brand.Size = UDim2.new(1, -14, 0, 20)
Brand.Position = UDim2.new(0, 14, 0, 36)
Brand.TextColor3 = Color3.fromRGB(0, 240, 100) -- เขียวนีออนเกรดพรีเมียม
Brand.TextSize = 13
Brand.Font = Enum.Font.FredokaOne
Brand.TextXAlignment = Enum.TextXAlignment.Left
Brand.BackgroundTransparency = 1
Brand.Parent = Sidebar

-- ปุ่มหมวดหมู่แบบหรูหรา (ตัวอย่างปุ่มเปิดไฟสีเขียว)
local Tab1 = Instance.new("TextButton")
Tab1.Text = "  ⚡  Main Farm"
Tab1.Size = UDim2.new(1, -14, 0, 32)
Tab1.Position = UDim2.new(0, 7, 0, 75)
Tab1.BackgroundColor3 = Color3.fromRGB(15, 40, 25) -- สีเขียวเข้มสไตล์ปุ่ม Active
Tab1.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab1.Font = Enum.Font.SourceSansBold
Tab1.TextSize = 13
Tab1.TextXAlignment = Enum.TextXAlignment.Left
Tab1.Parent = Sidebar
Instance.new("UICorner", Tab1).CornerRadius = UDim.new(0, 6)

local TabStroke = Instance.new("UIStroke", Tab1)
TabStroke.Color = Color3.fromRGB(0, 200, 90) -- เส้นขอบตองอ่อนเพิ่มมิติให้กับปุ่ม
TabStroke.Thickness = 1

-- ปุ่มหมวดหมู่อื่นๆ แบบมินิมอล (ยังไม่กดเลือก)
local Tab2 = Instance.new("TextButton")
Tab2.Text = "  ⚙️  Settings"
Tab2.Size = UDim2.new(1, -14, 0, 32)
Tab2.Position = UDim2.new(0, 7, 0, 115)
Tab2.BackgroundTransparency = 1
Tab2.TextColor3 = Color3.fromRGB(130, 130, 135)
Tab2.Font = Enum.Font.SourceSansBold
Tab2.TextSize = 13
Tab2.TextXAlignment = Enum.TextXAlignment.Left
Tab2.Parent = Sidebar

-- ========================================================
-- [ ฝั่งขวา: CONTENT AREA & CONTROL BOX ]
-- ========================================================
local RightArea = Instance.new("Frame")
RightArea.Size = UDim2.new(1, -140, 1, 0)
RightArea.Position = UDim2.new(0, 140, 0, 0)
RightArea.BackgroundTransparency = 1
RightArea.Parent = MainFrame

-- หัวข้อขวาบนแสดงชื่อเกม
local HeaderText = Instance.new("TextLabel")
HeaderText.Text = "Attack on Titan Revolution  v2.4"
HeaderText.Size = UDim2.new(1, -20, 0, 30)
HeaderText.Position = UDim2.new(0, 20, 0, 15)
HeaderText.TextColor3 = Color3.fromRGB(240, 240, 245)
HeaderText.TextSize = 13
HeaderText.Font = Enum.Font.SourceSansBold
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.BackgroundTransparency = 1
HeaderText.Parent = RightArea

-- การ์ดพื้นหลังสำหรับจัดกลุ่มฟังก์ชัน (Premium Section Box)
local Card = Instance.new("Frame")
Card.Size = UDim2.new(1, -35, 0, 100)
Card.Position = UDim2.new(0, 20, 0, 50)
Card.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
Card.BorderSizePixel = 0
Card.Parent = RightArea
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(30, 30, 35)
CardStroke.Thickness = 1

local SectionTitle = Instance.new("TextLabel")
SectionTitle.Text = "MAIN CONTROLLER"
SectionTitle.Size = UDim2.new(1, -20, 0, 25)
SectionTitle.Position = UDim2.new(0, 15, 0, 8)
SectionTitle.TextColor3 = Color3.fromRGB(110, 115, 125)
SectionTitle.TextSize = 11
SectionTitle.Font = Enum.Font.SourceSansBold
SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
SectionTitle.BackgroundTransparency = 1
SectionTitle.Parent = Card

-- ตัวหนังสือบอกรายละเอียดข้างปุ่มสวิตช์
local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Text = "Auto Farm (ระบบปิดรับคำสั่งชั่วคราว)"
ToggleLabel.Size = UDim2.new(0, 200, 0, 30)
ToggleLabel.Position = UDim2.new(0, 15, 0, 42)
ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
ToggleLabel.TextSize = 13
ToggleLabel.Font = Enum.Font.SourceSansBold
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Parent = Card

-- ปุ่มสวิตช์เปิด/ปิด (Switch) ดีไซน์พรีเมียมสีเขียว
local Switch = Instance.new("TextButton")
Switch.Text = ""
Switch.Size = UDim2.new(0, 42, 0, 20)
Switch.Position = UDim2.new(1, -55, 0, 47)
Switch.BackgroundColor3 = Color3.fromRGB(0, 200, 90) -- เปิดเป็นสีเขียวนีออนสว่างทันทีตามต้องการ
Switch.Parent = Card
Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

local SwitchDot = Instance.new("Frame")
SwitchDot.Size = UDim2.new(0, 16, 0, 16)
SwitchDot.Position = UDim2.new(0, 24, 0, 2) -- ตั้งค่าให้อยู่ฝั่งขวา (ON) ไว้ล่วงหน้า
SwitchDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SwitchDot.Parent = Switch
Instance.new("UICorner", SwitchDot).CornerRadius = UDim.new(1, 0)
