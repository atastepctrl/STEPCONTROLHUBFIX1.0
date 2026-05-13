-- STEPCONTROL HUB - REAPERX UI OFFICIAL FIX (BUTTONS WORKING 100%)
local player = game.Players.LocalPlayer
pcall(function() player.PlayerGui.StepControlUI:Destroy() end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

-- [ประกาศตัวแปรหน้าต่างหลักไว้ด้านบนสุด เพื่อให้ปุ่ม Mac ดึงไปใช้งานได้จริง]
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 270)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -135) -- โผล่กลางจอมือถือชัวร์
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 8) MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke") MainStroke.Thickness = 1.2 MainStroke.Color = Color3.fromRGB(0, 255, 100) MainStroke.Parent = MainFrame

-- ปุ่มลอยตัว "SC" สำหรับกดเรียกเมนูกลับมาตอนย่อหน้าต่าง
local OpenMenuBtn = Instance.new("TextButton")
OpenMenuBtn.Size = UDim2.new(0, 40, 0, 40)
OpenMenuBtn.Position = UDim2.new(0, 15, 0, 15)
OpenMenuBtn.Text = "SC"
OpenMenuBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
OpenMenuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenMenuBtn.Font = Enum.Font.GothamBold OpenMenuBtn.TextSize = 11 OpenMenuBtn.Visible = false OpenMenuBtn.Parent = ScreenGui
local OpenCorner = Instance.new("UICorner") OpenCorner.CornerRadius = UDim.new(1, 0) OpenCorner.Parent = OpenMenuBtn
local OpenStroke = Instance.new("UIStroke") OpenStroke.Thickness = 1.2 OpenStroke.Color = Color3.fromRGB(0, 255, 100) OpenStroke.Parent = OpenMenuBtn

OpenMenuBtn.MouseButton1Click:Connect(function() 
    MainFrame.Visible = true 
    OpenMenuBtn.Visible = false 
end)

-- แถบสามปุ่มบนซ้ายสไตล์เครื่อง Mac ที่เชื่อมต่อสัญญาณแก้บั๊กแล้ว
local MacButtons = Instance.new("Frame")
MacButtons.Size = UDim2.new(0, 60, 0, 30)
MacButtons.Position = UDim2.new(0, 15, 0, 10)
MacButtons.BackgroundTransparency = 1
MacButtons.Parent = MainFrame

local function CreateMacClickableDot(color, posX, callback)
    local DotButton = Instance.new("TextButton")
    DotButton.Size = UDim2.new(0, 10, 0, 10)
    DotButton.Position = UDim2.new(0, posX, 0, 10)
    DotButton.BackgroundColor3 = color
    DotButton.BorderSizePixel = 0 DotButton.Text = "" DotButton.Parent = MacButtons
    local DC = Instance.new("UICorner") DC.CornerRadius = UDim.new(1, 0) DC.Parent = DotButton
    DotButton.MouseButton1Click:Connect(callback)
end

-- 🔴 ปุ่มสีแดง: สั่งทำลายลบสคริปต์ทิ้งแบบถาวรเคลียร์จอภาพ
CreateMacClickableDot(Color3.fromRGB(255, 95, 86), 0, function() 
    pcall(function() ScreenGui:Destroy() end) 
end)

-- 🟡 ปุ่มสีเหลือง: สั่งซ่อนหน้าต่างหลักเพื่อโชว์ปุ่มลอย "SC" ขึ้นมาแทนอัตโนมัติ
CreateMacClickableDot(Color3.fromRGB(255, 189, 46), 15, function() 
    MainFrame.Visible = false 
    OpenMenuBtn.Visible = true 
end)

-- 🟢 ปุ่มสีเขียว: ปุ่มคุมโทนความสวยงามมินิมอลตามบรีฟ
CreateMacClickableDot(Color3.fromRGB(0, 255, 100), 30, function() end)

-- ระบบลากหน้าจออัจฉริยะ (เสถียรข้ามอุปกรณ์)
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Position = UDim2.new(0, 120, 0, 5)
Title.Text = "STEPCONTROL HUB"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.Font = Enum.Font.GothamBold Title.TextSize = 11 Title.TextXAlignment = Enum.TextXAlignment.Left Title.BackgroundTransparency = 1 Title.Parent = MainFrame

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.BorderSizePixel = 0 Sidebar.Parent = MainFrame
local SBCorner = Instance.new("UICorner") SBCorner.CornerRadius = UDim.new(0, 8) SBCorner.Parent = Sidebar

local SBLine = Instance.new("Frame")
SBLine.Size = UDim2.new(0, 1, 1, 0)
SBLine.Position = UDim2.new(0, 110, 0, 0)
SBLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SBLine.BorderSizePixel = 0 SBLine.Parent = MainFrame

local function CreateSidebarTab(name, posY)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -12, 0, 26)
    Btn.Position = UDim2.new(0, 6, 0, posY)
    Btn.Text = "   " .. name
    Btn.Font = Enum.Font.GothamMedium Btn.TextSize = 10 Btn.TextXAlignment = Enum.TextXAlignment.Left Btn.Parent = Sidebar
    local BC = Instance.new("UICorner") BC.CornerRadius = UDim.new(0, 4) BC.Parent = Btn
    return Btn
end

local Tab1 = CreateSidebarTab("⚡ Main Profile", 15)
Tab1.BackgroundColor3 = Color3.fromRGB(0, 255, 100) Tab1.TextColor3 = Color3.fromRGB(0, 0, 0)

local Tab2 = CreateSidebarTab("🛡️ Anti-Cheat", 48)
Tab2.BackgroundTransparency = 1 Tab2.TextColor3 = Color3.fromRGB(140, 140, 145)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -125, 1, -50)
Container.Position = UDim2.new(0, 120, 0, 45)
Container.BackgroundTransparency = 1 Container.Parent = MainFrame

local Slider = Instance.new("Frame")
Slider.Size = UDim2.new(1, -10, 0, 40)
Slider.Position = UDim2.new(0, 0, 0, 5)
Slider.BackgroundColor3 = Color3.fromRGB(20, 20, 20) Slider.BorderSizePixel = 0 Slider.Parent = Container
local SC = Instance.new("UICorner") SC.CornerRadius = UDim.new(0, 4) SC.Parent = Slider

local SLbl = Instance.new("TextLabel")
SLbl.Size = UDim2.new(0, 150, 0, 16)
SLbl.Position = UDim2.new(0, 10, 0, 2)
SLbl.Text = "WalkSpeed Custom Settings"
SLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
SLbl.Font = Enum.Font.GothamMedium SLbl.TextSize = 10 SLbl.TextXAlignment = Enum.TextXAlignment.Left SLbl.BackgroundTransparency = 1 SLbl.Parent = Slider

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(0, 80, 0, 4)
SliderBar.Position = UDim2.new(1, -90, 0, 18)
SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderBar.BorderSizePixel = 0 SliderBar.Parent = Slider

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0, 45, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
SliderFill.BorderSizePixel = 0 SliderFill.Parent = SliderBar

local Knob = Instance.new("Frame")
Knob.Size = UDim2.new(0, 10, 0, 10)
Knob.Position = UDim2.new(0, 40, 0, -3)
Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255) Knob.Parent = SliderBar
local KC = Instance.new("UICorner") KC.CornerRadius = UDim.new(1, 0) KC.Parent = Knob

local function CreateVisualToggle(title, posY, isActive)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -10, 0, 40)
    Row.Position = UDim2.new(0, 0, 0, posY)
    Row.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Row.BorderSizePixel = 0 Row.Parent = Container
    local RC = Instance.new("UICorner") RC.CornerRadius = UDim.new(0, 4) RC.Parent = Row

    local Txt = Instance.new("TextLabel")
    Txt.Size = UDim2.new(0, 150, 1, 0)
    Txt.Position = UDim2.new(0, 10, 0, 0)
    Txt.Text = title
    Txt.TextColor3 = Color3.fromRGB(230, 230, 230)
    Txt.Font = Enum.Font.GothamMedium Txt.TextSize = 10 Txt.TextXAlignment = Enum.TextXAlignment.Left Txt.BackgroundTransparency = 1 Txt.Parent = Row

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 32, 0, 18)
    Switch.Position = UDim2.new(1, -40, 0, 11)
    Switch.BackgroundColor3 = isActive and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(50, 50, 50)
    Switch.Parent = Row
    local SwC = Instance.new("UICorner") SwC.CornerRadius = UDim.new(1, 0) SwC.Parent = Switch

    local SKnob = Instance.new("Frame")
    SKnob.Size = UDim2.new(0, 12, 0, 12)
    SKnob.Position = isActive and UDim2.new(1, -15, 0, 3) or UDim2.new(0, 3, 0, 3)
    SKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SKnob.BorderSizePixel = 0 SKnob.Parent = Switch
    local SKC = Instance.new("UICorner") SKC.CornerRadius = UDim.new(1, 0) SKC.Parent = SKnob
end

CreateVisualToggle("Infinite Jump Engine", 50, true)
CreateVisualToggle("No Clip Parameters Bypass", 95, false)
