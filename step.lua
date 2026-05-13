-- [[ REAPER X HUB UI FOR DELTA EXECUTOR ]] --

-- ปรับให้เข้ากับระบบของ Delta (ถ้ารันไม่ขึ้นจะสลับไปดึงข้อมูลใน PlayerGui แทน)
local targetParent = game:GetService("CoreGui")
if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- ลบ UI เก่าออกก่อนป้องกันการรันซ้ำแล้วจอบังกัน
if targetParent:FindFirstChild("ReaperXHub") then
    targetParent.ReaperXHub:Destroy()
end

-- 1. สร้างหน้าต่างหลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReaperXHub"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

-- 2. ตัวโครงหน้าต่างเมนูหลัก (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- สำหรับเลื่อนหน้าต่างบนจอมือถือ
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- 3. แถบด้านบน (Top Bar)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Text = "  REAPER X HUB | DELTA VERSION"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Color3.fromRGB(0, 220, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- 4. เมนูด้านซ้าย (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local TabButton = Instance.new("TextButton")
TabButton.Text = "Main ฟาร์ม"
TabButton.Size = UDim2.new(1, -10, 0, 30)
TabButton.Position = UDim2.new(0, 5, 0, 10)
TabButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TabButton.Font = Enum.Font.SourceSansBold
TabButton.TextSize = 14
TabButton.Parent = Sidebar

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 5)
TabCorner.Parent = TabButton

-- 5. พื้นหลังฝั่งขวา (Container)
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -125, 1, -45)
Container.Position = UDim2.new(0, 120, 0, 40)
Container.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Container.BorderSizePixel = 0
Container.Parent = MainFrame

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 6)
ContainerCorner.Parent = Container

-- 6. ปุ่มเปิด/ปิดโปร (Toggle Button)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "Auto Farm: ปิดอยู่"
ToggleButton.Size = UDim2.new(1, -20, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 15
ToggleButton.Parent = Container

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

-- [[ ระบบคำสั่งสำหรับรันบน Delta ]] --
_G.DeltaAutoFarm = false -- ใช้ตัวแปร Global ทั่วไป

ToggleButton.MouseButton1Click:Connect(function()
    _G.DeltaAutoFarm = not _G.DeltaAutoFarm
    
    if _G.DeltaAutoFarm then
        ToggleButton.Text = "Auto Farm: เปิดใช้งาน"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        
        -- จำลองการทำงานลูป
        task.spawn(function()
            while _G.DeltaAutoFarm do
                print("Delta กำลังรันโปรฟาร์ม...")
                task.wait(1)
            end
        end)
    else
        ToggleButton.Text = "Auto Farm: ปิดอยู่"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
end)
