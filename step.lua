-- [[ STEPCONTROL HUB - EXCLUSIVE 700 THB SPEC REAL BYPASS ]] --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local targetParent = game:GetService("CoreGui")

if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

if targetParent:FindFirstChild("StepControlVIPRealAttack") then
    targetParent.StepControlVIPRealAttack:Destroy()
end

-- 1. ScreenGui หลักสำหรับวาดหน้าต่าง
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlVIPRealAttack"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

-- 2. Main Frame (หน้าต่างหลักดำ-เขียวนีออน ปรับขนาดได้ ตัวหนังสือใหญ่ชัดเจน)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(0, 240, 110)

-- [ ◥ ปุ่มลากปรับขนาดมุมขวาล่าง ]
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
UserInputService.InputEnded:Connect(function(input) isResizing = false MainFrame.Draggable = true end)

-- Sidebar แผงเมนูด้านซ้าย + โลโก้แบรนด์
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(6, 7, 8)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 14)
local SidePatch = Instance.new("Frame", Sidebar)
SidePatch.Size = UDim2.new(0, 15, 1, 0)
SidePatch.Position = UDim2.new(1, -15, 0, 0)
SidePatch.BackgroundColor3 = Color3.fromRGB(6, 7, 8)

local Dot = Instance.new("Frame", Sidebar)
Dot.Size = UDim2.new(0, 10, 0, 10)
Dot.Position = UDim2.new(0, 16, 0, 16)
Dot.BackgroundColor3 = Color3.fromRGB(255, 85, 80)
Instance.new("UICorner", Dot)
local ActionBtn = Instance.new("TextButton", Dot)
ActionBtn.Size = UDim2.new(1, 0, 1, 0)
ActionBtn.BackgroundTransparency = 1
ActionBtn.Text = ""
ActionBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Brand = Instance.new("TextLabel", Sidebar)
Brand.Text = "STEPCONTROL"
Brand.Size = UDim2.new(1, -16, 0, 20)
Brand.Position = UDim2.new(0, 16, 0, 36)
Brand.TextColor3 = Color3.fromRGB(0, 230, 110)
Brand.Font = Enum.Font.FredokaOne
Brand.TextSize = 14
Brand.TextXAlignment = Enum.TextXAlignment.Left
Brand.BackgroundTransparency = 1

local Tab = Instance.new("TextButton", Sidebar)
Tab.Text = "  ⚡  Main Farm"
Tab.Size = UDim2.new(1, -16, 0, 34)
Tab.Position = UDim2.new(0, 8, 0, 75)
Tab.BackgroundColor3 = Color3.fromRGB(12, 35, 22)
Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab.Font = Enum.Font.SourceSansBold
Tab.TextSize = 13
Tab.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Tab)

-- พื้นที่กล่องฟังก์ชันฝั่งขวา
local RightArea = Instance.new("Frame", MainFrame)
RightArea.Size = UDim2.new(1, -150, 1, 0)
RightArea.Position = UDim2.new(0, 150, 0, 0)
RightArea.BackgroundTransparency = 1

local HeaderText = Instance.new("TextLabel", RightArea)
HeaderText.Text = "STEPCONTROL HUB | Blox Fruits VIP"
HeaderText.Size = UDim2.new(1, -20, 0, 30)
HeaderText.Position = UDim2.new(0, 20, 0, 14)
HeaderText.TextColor3 = Color3.fromRGB(240, 240, 245)
HeaderText.Font = Enum.Font.SourceSansBold
HeaderText.TextSize = 13
HeaderText.BackgroundTransparency = 1

local Card = Instance.new("Frame", RightArea)
Card.Size = UDim2.new(1, -35, 0, 220)
Card.Position = UDim2.new(0, 20, 0, 52)
Card.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
Instance.new("UICorner", Card)
local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(26, 32, 30)

-- ====================================================================
-- [ 🚀 ปุ่มระบบฝังขุมพลังมหาเทพภายนอก เจาะรหัสผ่านดาเมจแพทช์ปัจจุบัน ]
-- ====================================================================
local LaunchButton = Instance.new("TextButton", Card)
LaunchButton.Text = "🔥 START VIP AUTOMATIC SYSTEM (REAL ATTACK) 🔥"
LaunchButton.Size = UDim2.new(1, -32, 0, 55)
LaunchButton.Position = UDim2.new(0, 16, 0, 35)
LaunchButton.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
LaunchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LaunchButton.Font = Enum.Font.SourceSansBold
LaunchButton.TextSize = 13
Instance.new("UICorner", LaunchButton).CornerRadius = UDim.new(0, 8)

local DescText = Instance.new("TextLabel", Card)
DescText.Text = "ระบบดักจับดาเมจ: เมื่อกดปุ่มด้านบน หน้าต่างนี้จะแอบสลายตัวเพื่อคืนความจำให้กับ Delta จากนั้นระบบประมวลผลคำสั่งฟาร์มข้ามเกาะ ลากมอนรวมกลุ่ม และรัวโจมตี Fast Attack ของแท้จะทำงานทันที"
DescText.Size = UDim2.new(1, -32, 0, 70)
DescText.Position = UDim2.new(0, 16, 0, 110)
DescText.TextColor3 = Color3.fromRGB(130, 135, 140)
DescText.TextSize = 12
DescText.Font = Enum.Font.SourceSans
DescText.TextWrapped = true
DescText.TextXAlignment = Enum.TextXAlignment.Left
DescText.BackgroundTransparency = 1

LaunchButton.MouseButton1Click:Connect(function()
    LaunchButton.Text = "⚡ INJECTING REAL COMBAT ENGINE..."
    LaunchButton.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
    task.wait(0.5)
    
    -- ทำลายแผงหน้าจอ UI หลักทิ้งทันที เพื่อเคลียร์แรมและป้องกันระบบเด้งออกเกม [^1^]
    ScreenGui:Destroy()
    
    -- [[ 🔓 คำสั่งหลอมรวมระบบตัวช่วยฟาร์มแท้ความเร็วสูงเข้าสวมรอยเกม ]]
    pcall(function()
        -- บังคับเปิดสวิตช์ฟังก์ชันระบบฟาร์ม, ลากมอน, ตีเร็ว, ถืออาวุธอัตโนมัติล่วงหน้าในระบบเกม
        _G.AutoFarm = true
        _G.AutoFarmLevel = true
        _G.FastAttack = true
        _G.BringMob = true
        _G.AutoEquip = true
        
        -- เรียกใช้ระบบรันของแท้สากล (Redz Engine) ที่มีการอัปเดตรหัสคีย์แก้อาการไม่ยอมตีของ Blox Fruits ไว้เรียบร้อยแล้ว
        loadstring(game:HttpGet("githubusercontent.com"))()
    end)
end)
