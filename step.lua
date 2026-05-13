-- [[ REAPER X HUB - DARK GREEN THEME FOR DELTA ]] --

-- ตรวจสอบและเลือกโฟลเดอร์สำหรับแสดงผล UI ให้ปลอดภัยบน Delta
local targetParent = game:GetService("CoreGui")
if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- ลบ UI เก่าออกอัตโนมัติหากมีการรันซ้ำ
if targetParent:FindFirstChild("ReaperGreenHub") then
    targetParent.ReaperGreenHub:Destroy()
end

-- 1. หน้าต่างหลัก (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReaperGreenHub"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

-- 2. โครงเมนูหลัก (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- สีพื้นหลังดำสนิท
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- 3. แถบหัวข้อด้านบน (Top Bar)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Text = "  Attack on Titan Revolution | ReaperX"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Color3.fromRGB(0, 255, 100) -- ตัวหนังสือสีเขียวนีออน
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- 4. แถบเมนูด้านซ้าย (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18) -- แถบเมนูด้านซ้ายสีดำเทา
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- ปุ่มเมนู Auto Farm (ไฮไลท์สีเขียวตามรูปภาพตัวอย่าง)
local TabAutoFarm = Instance.new("TextButton")
TabAutoFarm.Text = "⚡ Auto Farm"
TabAutoFarm.Size = UDim2.new(1, -16, 0, 32)
TabAutoFarm.Position = UDim2.new(0, 8, 0, 12)
TabAutoFarm.BackgroundColor3 = Color3.fromRGB(0, 200, 80) -- สีเขียวตองอ่อนแถบสว่าง
TabAutoFarm.TextColor3 = Color3.fromRGB(255, 255, 255)
TabAutoFarm.Font = Enum.Font.SourceSansBold
TabAutoFarm.TextSize = 14
TabAutoFarm.TextXAlignment = Enum.TextXAlignment.Left
TabAutoFarm.Parent = Sidebar

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 6)
TabCorner.Parent = TabAutoFarm

-- ปุ่มเมนูอื่นๆ แบบโปร่งแสง (ตัวอย่างเมนูย่อย)
local TabSettings = Instance.new("TextButton")
TabSettings.Text = "⚙️ Settings"
TabSettings.Size = UDim2.new(1, -16, 0, 32)
TabSettings.Position = UDim2.new(0, 8, 0, 50)
TabSettings.BackgroundTransparency = 1 -- โปร่งแสงเพราะยังไม่ได้เลือก
TabSettings.TextColor3 = Color3.fromRGB(180, 180, 180)
TabSettings.Font = Enum.Font.SourceSans
TabSettings.TextSize = 14
TabSettings.TextXAlignment = Enum.TextXAlignment.Left
TabSettings.Parent = Sidebar

-- 5. พื้นที่ใส่ฟังก์ชันหลักด้านขวา (Content Container)
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -155, 1, -55)
Container.Position = UDim2.new(0, 145, 0, 48)
Container.BackgroundColor3 = Color3.fromRGB(24, 24, 24) -- พื้นหลังกล่องฟังก์ชัน
Container.BorderSizePixel = 0
Container.Parent = MainFrame

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 8)
ContainerCorner.Parent = Container

-- 6. หัวข้อกลุ่มฟังก์ชันภายในกล่องขวา (Section Title)
local SectionTitle = Instance.new("TextLabel")
SectionTitle.Text = "⚙️ Game Options"
SectionTitle.Size = UDim2.new(1, -20, 0, 25)
SectionTitle.Position = UDim2.new(0, 10, 0, 10)
SectionTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SectionTitle.TextSize = 14
SectionTitle.Font = Enum.Font.SourceSansBold
SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
SectionTitle.BackgroundTransparency = 1
SectionTitle.Parent = Container

-- 7. ปุ่มสวิตช์เปิด/ปิดฟาร์ม (Toggle Button)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "Auto Retry : OFF"
ToggleButton.Size = UDim2.new(1, -20, 0, 35)
ToggleButton.Position = UDim2.new(0, 10, 0, 45)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- สีเทาตอนปิด
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14
ToggleButton.Parent = Container

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

-- [[ ระบบควบคุมสถานะปุ่ม ]] --
_G.AutoRetry = false

ToggleButton.MouseButton1Click:Connect(function()
    _G.AutoRetry = not _G.AutoRetry
    if _G.AutoRetry then
        ToggleButton.Text = "Auto Retry : ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 70) -- เปลี่ยนเป็นสีเขียวเมื่อเปิดใช้งาน
        print("เปิดระบบ Auto Retry แล้ว")
    else
        ToggleButton.Text = "Auto Retry : OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- กลับเป็นสีเทามืด
        print("ปิดระบบ Auto Retry แล้ว")
    end
end)

