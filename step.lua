-- [[ STEPCONTROL HUB - MAC-STYLE ULTRA PRECISION UI ]] --

local targetParent = game:GetService("CoreGui")
if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

if targetParent:FindFirstChild("StepControlHub") then
    targetParent.StepControlHub:Destroy()
end

-- 1. หน้าต่างรวมทั้งหมด (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlHub"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

-- 2. ตัวโครงเมนูหลัก (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 380) -- ขนาดกว้างสัดส่วนตรงตามภาพ
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- สีเทาเข้มเนื้อแมตต์แบบในภาพ
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- ========================================================
-- [ ฝั่งซ้าย: SIDEBAR & MAC BUTTONS ]
-- ========================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 24) -- สี Sidebar มืดกว่าพื้นหลังขวา
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 12)
SideCorner.Parent = Sidebar

-- บล็อกสี่เหลี่ยมถมมุมขวาของ Sidebar ไม่ให้มนตามขอบหลัก
local SidePatch = Instance.new("Frame")
SidePatch.Size = UDim2.new(0, 12, 1, 0)
SidePatch.Position = UDim2.new(1, -12, 0, 0)
SidePatch.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
SidePatch.BorderSizePixel = 0
SidePatch.Parent = Sidebar

-- ปุ่ม 3 สีสไตล์ Mac OS (แดง, เหลือง, เขียว)
local MacButtons = Instance.new("Frame")
MacButtons.Size = UDim2.new(0, 60, 0, 20)
MacButtons.Position = UDim2.new(0, 16, 0, 16)
MacButtons.BackgroundTransparency = 1
MacButtons.Parent = Sidebar

local colors = {Color3.fromRGB(255, 95, 87), Color3.fromRGB(254, 188, 46), Color3.fromRGB(40, 200, 64)}
for i, color in ipairs(colors) do
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 12, 0, 12)
    Dot.Position = UDim2.new(0, (i-1) * 18, 0, 0)
    Dot.BackgroundColor3 = color
    Dot.BorderSizePixel = 0
    Dot.Parent = MacButtons
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0) -- ทำเป็นทรงกลมเป๊ะๆ
    DotCorner.Parent = Dot
    
    -- พิเศษ: กดปุ่มสีแดงเพื่อปิดสคริปต์ทันที
    if i == 1 then
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(1, 0, 1, 0)
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.Text = ""
        CloseBtn.Parent = Dot
        CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    end
end

-- หัวข้อหมวดหมู่ใน Sidebar (เช่น In-Game)
local CategoryLabel = Instance.new("TextLabel")
CategoryLabel.Text = "In-Game"
CategoryLabel.Size = UDim2.new(1, -16, 0, 20)
CategoryLabel.Position = UDim2.new(0, 16, 0, 45)
CategoryLabel.TextColor3 = Color3.fromRGB(90, 90, 90) -- สีเทาจางตามภาพตัวอย่าง
CategoryLabel.TextSize = 11
CategoryLabel.Font = Enum.Font.SourceSansBold
CategoryLabel.TextXAlignment = Enum.TextXAlignment.Left
CategoryLabel.BackgroundTransparency = 1
CategoryLabel.Parent = Sidebar

-- ปุ่มเมนูหลัก Auto Farm (ดีไซน์แถบสีเขียวนีออนตัดขอบมนยาว)
local TabAutoFarm = Instance.new("TextButton")
TabAutoFarm.Text = "  ⚡  Auto Farm"
TabAutoFarm.Size = UDim2.new(1, -16, 0, 34)
TabAutoFarm.Position = UDim2.new(0, 8, 0, 70)
TabAutoFarm.BackgroundColor3 = Color3.fromRGB(0, 180, 70) -- สีเขียวสดระดับสายตาหลัก
TabAutoFarm.TextColor3 = Color3.fromRGB(255, 255, 255)
TabAutoFarm.Font = Enum.Font.SourceSansBold
TabAutoFarm.TextSize = 13
TabAutoFarm.TextXAlignment = Enum.TextXAlignment.Left
TabAutoFarm.Parent = Sidebar

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabAutoFarm

-- ========================================================
-- [ ฝั่งขวา: TOPBAR TITLE & CONTENT AREA ]
-- ========================================================
local RightArea = Instance.new("Frame")
RightArea.Name = "RightArea"
RightArea.Size = UDim2.new(1, -160, 1, 0)
RightArea.Position = UDim2.new(0, 160, 0, 0)
RightArea.BackgroundTransparency = 1
RightArea.Parent = MainFrame

-- แถบแสดงชื่อสคริปต์ด้านบนขวา
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = RightArea

local Title = Instance.new("TextLabel")
Title.Text = "STEPCONTROL HUB"
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Position = UDim2.new(0, 0, 0, 12)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Center -- อยู่ตรงกลางเป๊ะตามสไตล์ Mac UI
Title.BackgroundTransparency = 1
Title.Parent = TitleBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Text = "Attack on Titan Revolution"
SubTitle.Size = UDim2.new(1, 0, 0, 15)
SubTitle.Position = UDim2.new(0, 0, 0, 28)
SubTitle.TextColor3 = Color3.fromRGB(130, 130, 130) -- ตัวหนังสือซับไตเติ้ลสีเทาเล็ก
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.SourceSans
SubTitle.TextXAlignment = Enum.TextXAlignment.Center
SubTitle.BackgroundTransparency = 1
SubTitle.Parent = TitleBar

-- พื้นที่แสดงผลคำสั่งต่างๆ (Container) พร้อม Scrollbar เลื่อนขึ้นลงได้แบบของจริง
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -20, 1, -65)
ContentScroll.Position = UDim2.new(0, 10, 0, 55)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 4
ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
ContentScroll.Parent = RightArea

-- หัวข้อ Game Options ในหน้าหลัก
local SectionLabel = Instance.new("TextLabel")
SectionLabel.Text = "🛠️ Game Options"
SectionLabel.Size = UDim2.new(1, 0, 0, 30)
SectionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SectionLabel.TextSize = 14
SectionLabel.Font = Enum.Font.SourceSansBold
SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
SectionLabel.BackgroundTransparency = 1
SectionLabel.Parent = ContentScroll

-- ========================================================
-- [ ปุ่ม TOGGLE SWITCH ดีไซน์กลมมนแบบในภาพ ]
-- ========================================================
local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
ToggleFrame.Position = UDim2.new(0, 0, 0, 35)
ToggleFrame.BackgroundTransparency = 1
ToggleFrame.Parent = ContentScroll

local ToggleText = Instance.new("TextLabel")
ToggleText.Text = "Auto Retry (เปิดระบบท้าทายใหม่อัตโนมัติ)"
ToggleText.Size = UDim2.new(0, 300, 1, 0)
ToggleText.TextColor3 = Color3.fromRGB(230, 230, 230)
ToggleText.TextSize = 13
ToggleText.Font = Enum.Font.SourceSans
ToggleText.TextXAlignment = Enum.TextXAlignment.Left
ToggleText.BackgroundTransparency = 1
ToggleText.Parent = ToggleFrame

-- ตัวสวิตช์วงรี (Switch BG)
local Switch = Instance.new("TextButton")
Switch.Text = ""
Switch.Size = UDim2.new(0, 45, 0, 22)
Switch.Position = UDim2.new(1, -55, 0, 9)
Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 65) -- สีเทาตอนปิด
Switch.Parent = ToggleFrame

local SwitchCorner = Instance.new("UICorner")
SwitchCorner.CornerRadius = UDim.new(1, 0)
SwitchCorner.Parent = Switch

-- ปุ่มกลมด้านในสวิตช์ (Slider Dot)
local SwitchDot = Instance.new("Frame")
SwitchDot.Size = UDim2.new(0, 18, 0, 18)
SwitchDot.Position = UDim2.new(0, 2, 0, 2)
SwitchDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SwitchDot.Parent = Switch

local DotCorner2 = Instance.new("UICorner")
DotCorner2.CornerRadius = UDim.new(1, 0)
DotCorner2.Parent = SwitchDot

-- [[ ระบบสลับสถานะสวิตช์ (สไตล์แอนิเมชันเปิด/ปิดสีเขียว) ]]
_G.StepControlAuto = false
Switch.MouseButton1Click:Connect(function()
    _G.StepControlAuto = not _G.StepControlAuto
    if _G.StepControlAuto then
        Switch.BackgroundColor3 = Color3.fromRGB(0, 200, 80) -- เปลี่ยนเป็นสีเขียวเมื่อเปิด
        SwitchDot:TweenPosition(UDim2.new(0, 25, 0, 2), "Out", "Quad", 0.15) -- เลื่อนปุ่มกลมไปทางขวา
    else
        Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 65) -- กลับเป็นสีเทาเมื่อปิด
        SwitchDot:TweenPosition(UDim2.new(0, 2, 0, 2), "Out", "Quad", 0.15) -- เลื่อนกลับไปทางซ้าย
    end
end)
