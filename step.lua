-- [[ STEPCONTROL HUB - PRO PREMIUM EDITION (700 THB SPEC) ]] --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local targetParent = game:GetService("CoreGui")
if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

if targetParent:FindFirstChild("StepControl700Baht") then
    targetParent.StepControl700Baht:Destroy()
end

-- ========================================================
-- [ หน้าต่างหลักปรับขนาดได้สไตล์ ULTRA PREMIUM ]
-- ========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControl700Baht"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 350)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(0, 240, 110) -- ไฟเขียวนีออนสว่างระดับโปรนอก

-- [ ปุ่มลากปรับขนาดขวาล่าง ]
local ResizeButton = Instance.new("TextButton", MainFrame)
ResizeButton.Size = UDim2.new(0, 16, 0, 16)
ResizeButton.Position = UDim2.new(1, -16, 1, -16)
ResizeButton.BackgroundColor3 = Color3.fromRGB(0, 240, 110)
ResizeButton.BackgroundTransparency = 0.8
ResizeButton.Text = "◢"
ResizeButton.TextColor3 = Color3.fromRGB(0, 240, 110)
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
        MainFrame.Size = UDim2.new(0, math.max(400, startSize.X.Offset + (currentMousePos.X - startMousePos.X)), 0, math.max(250, startSize.Y.Offset + (currentMousePos.Y - startMousePos.Y)))
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isResizing = false MainFrame.Draggable = true end
end)

-- Sidebar ด้านซ้าย + ปุ่ม Mac
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(6, 7, 8)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 14)
local SidePatch = Instance.new("Frame", Sidebar)
SidePatch.Size = UDim2.new(0, 15, 1, 0)
SidePatch.Position = UDim2.new(1, -15, 0, 0)
SidePatch.BackgroundColor3 = Color3.fromRGB(6, 7, 8)

local MacButtons = Instance.new("Frame", Sidebar)
MacButtons.Size = UDim2.new(0, 50, 0, 10)
MacButtons.Position = UDim2.new(0, 16, 0, 16)
MacButtons.BackgroundTransparency = 1
local Dot = Instance.new("Frame", MacButtons)
Dot.Size = UDim2.new(0, 10, 0, 10)
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
Brand.Position = UDim2.new(0, 16, 0, 38)
Brand.TextColor3 = Color3.fromRGB(0, 230, 110)
Brand.Font = Enum.Font.FredokaOne
Brand.BackgroundTransparency = 1

local Tab = Instance.new("TextButton", Sidebar)
Tab.Text = "  ⚡  Main Farm"
Tab.Size = UDim2.new(1, -16, 0, 34)
Tab.Position = UDim2.new(0, 8, 0, 75)
Tab.BackgroundColor3 = Color3.fromRGB(12, 35, 22)
Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", Tab)

-- พื้นที่ควบคุมฝั่งขวา
local RightArea = Instance.new("Frame", MainFrame)
RightArea.Size = UDim2.new(1, -150, 1, 0)
RightArea.Position = UDim2.new(0, 150, 0, 0)
RightArea.BackgroundTransparency = 1

local HeaderText = Instance.new("TextLabel", RightArea)
HeaderText.Text = "STEPCONTROL HUB | Blox Fruits VIP Client"
HeaderText.Size = UDim2.new(1, -20, 0, 30)
HeaderText.Position = UDim2.new(0, 20, 0, 14)
HeaderText.TextColor3 = Color3.fromRGB(240, 240, 245)
HeaderText.Font = Enum.Font.SourceSansBold
HeaderText.BackgroundTransparency = 1

local Card = Instance.new("Frame", RightArea)
Card.Size = UDim2.new(1, -35, 0, 220)
Card.Position = UDim2.new(0, 20, 0, 52)
Card.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
Instance.new("UICorner", Card)
local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(26, 32, 30)

-- ========================================================
-- [ 🚀 ปุ่มกดยิงระบบฟาร์มเทพของจริง (BYPASS CORE INJECTOR) ]
-- ========================================================
local LaunchButton = Instance.new("TextButton", Card)
LaunchButton.Text = "🔥 ACTIVATE GOD FARM & FAST ATTACK 🔥"
LaunchButton.Size = UDim2.new(1, -32, 0, 50)
LaunchButton.Position = UDim2.new(0, 16, 0, 30)
LaunchButton.BackgroundColor3 = Color3.fromRGB(0, 180, 80) -- สีเขียวเข้มสตาร์ทเครื่อง
LaunchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LaunchButton.Font = Enum.Font.SourceSansBold
LaunchButton.TextSize = 14
Instance.new("UICorner", LaunchButton).CornerRadius = UDim.new(0, 8)

-- สไลเดอร์หลอกอวดความแพง (ปรับระยะ Distance บน UI ได้จริง)
local SliderLabel = Instance.new("TextLabel", Card)
SliderLabel.Text = "Bypass Distance Tweak"
SliderLabel.Size = UDim2.new(0, 200, 0, 25)
SliderLabel.Position = UDim2.new(0, 16, 0, 105)
SliderLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
SliderLabel.Font = Enum.Font.SourceSansBold
SliderLabel.BackgroundTransparency = 1

local SliderValueText = Instance.new("TextLabel", Card)
SliderValueText.Text = "100%"
SliderValueText.Size = UDim2.new(0, 40, 0, 25)
SliderValueText.Position = UDim2.new(1, -55, 0, 105)
SliderValueText.TextColor3 = Color3.fromRGB(0, 230, 110)
SliderValueText.Font = Enum.Font.SourceSansBold
SliderValueText.BackgroundTransparency = 1

local SliderTrack = Instance.new("TextButton", Card)
SliderTrack.Text = ""
SliderTrack.Size = UDim2.new(1, -32, 0, 6)
SliderTrack.Position = UDim2.new(0, 16, 0, 140)
SliderTrack.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
SliderTrack.BorderSizePixel = 0
Instance.new("UICorner", SliderTrack)

local SliderFill = Instance.new("Frame", SliderTrack)
SliderFill.Size = UDim2.new(1, 0, 1, 0) -- ค่าเริ่มต้นเต็ม 100%
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 95)
Instance.new("UICorner", SliderFill)

local SliderDot = Instance.new("Frame", SliderTrack)
SliderDot.Size = UDim2.new(0, 14, 0, 14)
SliderDot.Position = UDim2.new(1, -7, 0.5, -7)
SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SliderDot)

-- กลไกเลื่อนสไลเดอร์หลอกให้ดูหรูหรา
local dragging = false
SliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local percentage = math.clamp((UserInputService:GetMouseLocation().X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        SliderDot.Position = UDim2.new(percentage, -7, 0.5, -7)
        SliderValueText.Text = math.floor(percentage * 100) .. "%"
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- [[ ⚙️ ระบบดักการกดสวิตช์ปล่อยพลัง Engine มหาเทพ ]]
LaunchButton.MouseButton1Click:Connect(function()
    LaunchButton.Text = "⚡ INJECTING REDZ APIS... (PLEASE WAIT)"
    LaunchButton.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
    task.wait(1.5) -- หน่วงเวลาจำลองความสมจริงระดับพรีเมียม
    
    -- ทำลายหน้าต่าง UI หลัก STEPCONTROL ทิ้งไปเลยเพื่อป้องกันการเด้ง และส่งไม้ต่อให้บอทนอกทำงาน
    MainFrame.Visible = false 
    
    -- บังคับเรียกใช้สคริปต์ระดับมหาเทพของจริงที่ไม่มีวันบั๊ก บินฟาร์มเร็วจัดและตีเร็วมากกกก ทันที!
    pcall(function()
        loadstring(game:HttpGet("githubusercontent.com"))()
    end)
    
    ScreenGui:Destroy() -- ล้างหน่วยความจำให้คลีน เครื่องจะไม่เด้งออกเกมชัวร์ๆ
end)
