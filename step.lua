-- STEPCONTROL HUB V16.1 - OFFICIAL UI RESIZER FIXED (PC & MOBILE STABLE)
local player = game.Players.LocalPlayer
pcall(function() player.PlayerGui.StepControlUI:Destroy() end)

_G.StepSpeed = 16
_G.AutoJump = false
_G.NoClip = false

local currentScale = 1.0

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

-- หน้าต่างโครงสร้างหลักสไตล์ ReaperX Hub 
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 270)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -135)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- ใช้ UIScale ควบคุมมาตราส่วนสัดส่วนปุ่มภายในทั้งหมดอัตโนมัติแบบไร้บั๊ก
local UI_Scale = Instance.new("UIScale")
UI_Scale.Scale = currentScale
UI_Scale.Parent = MainFrame

local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 8) MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke") MainStroke.Thickness = 1.2 MainStroke.Color = Color3.fromRGB(0, 255, 100) MainStroke.Parent = MainFrame

-- ปุ่มลอยตัว SC เรียกเมนูกลับมาตอนย่อหน้าต่าง
local OpenMenuBtn = Instance.new("TextButton")
OpenMenuBtn.Size = UDim2.new(0, 40, 0, 40)
OpenMenuBtn.Position = UDim2.new(0, 15, 0, 15)
OpenMenuBtn.Text = "SC"
OpenMenuBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
OpenMenuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenMenuBtn.Font = Enum.Font.GothamBold OpenMenuBtn.TextSize = 11 OpenMenuBtn.Visible = false OpenMenuBtn.Parent = ScreenGui
local OpenCorner = Instance.new("UICorner") OpenCorner.CornerRadius = UDim.new(1, 0) OpenCorner.Parent = OpenMenuBtn
local OpenStroke = Instance.new("UIStroke") OpenStroke.Thickness = 1.2 OpenStroke.Color = Color3.fromRGB(0, 255, 100) OpenStroke.Parent = OpenMenuBtn
OpenMenuBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenMenuBtn.Visible = false end)

-- แถบสามปุ่มบนซ้ายสไตล์เครื่อง Mac (แดง ปิด / เหลือง ย่อ)
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

CreateMacClickableDot(Color3.fromRGB(255, 95, 86), 0, function() pcall(function() ScreenGui:Destroy() end) end) 
CreateMacClickableDot(Color3.fromRGB(255, 189, 46), 15, function() MainFrame.Visible = false OpenMenuBtn.Visible = true end) 
CreateMacClickableDot(Color3.fromRGB(0, 255, 100), 30, function() end)

-- ระบบลากหน้าจอเมนูหลบลากนิ้วสัมผัสบนจอมือถือ
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
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (delta.X / currentScale), startPos.Y.Scale, startPos.Y.Offset + (delta.Y / currentScale))
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 140, 0, 30)
Title.Position = UDim2.new(0, 115, 0, 5)
Title.Text = "STEPCONTROL HUB"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.Font = Enum.Font.GothamBold Title.TextSize = 11 Title.TextXAlignment = Enum.TextXAlignment.Left Title.BackgroundTransparency = 1 Title.Parent = MainFrame

-- ปุ่มปรับมาตราขนาดหน้าต่าง UI (➕ ขยาย / ➖ ย่อ)
local ResizeContainer = Instance.new("Frame")
ResizeContainer.Size = UDim2.new(0, 50, 0, 24)
ResizeContainer.Position = UDim2.new(1, -60, 0, 8)
ResizeContainer.BackgroundTransparency = 1
ResizeContainer.Parent = MainFrame

local function CreateScaleButton(text, posX, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 22, 0, 22)
    Btn.Position = UDim2.new(0, posX, 0, 0)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.Parent = ResizeContainer
    local BC = Instance.new("UICorner") BC.CornerRadius = UDim.new(0, 4) BC.Parent = Btn
    Btn.MouseButton1Click:Connect(callback)
end

CreateScaleButton("+", 26, function()
    if currentScale < 1.4 then
        currentScale = currentScale + 0.1
        UI_Scale.Scale = currentScale
    end
end)

CreateScaleButton("-", 0, function()
    if currentScale > 0.7 then
        currentScale = currentScale - 0.1
        UI_Scale.Scale = currentScale
    end
end)

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
    local BC = Instance.new("UICorner") BC.CornerRadius = UDim.new(0, 5) BC.Parent = Btn
    return Btn
end

local Tab1 = CreateSidebarTab("⚡ Main Profile", 15)
Tab1.BackgroundColor3 = Color3.fromRGB(0, 255, 100) Tab1.TextColor3 = Color3.fromRGB(0, 0, 0)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -125, 1, -50)
Container.Position = UDim2.new(0, 120, 0, 45)
Container.BackgroundTransparency = 1 Container.Parent = MainFrame

local Slider = Instance.new("Frame")
Slider.Size = UDim2.new(1, -10, 0, 40)
Slider.Position = UDim2.new(0, 0, 0, 5)
Slider.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Slider.BorderSizePixel = 0
Slider.Parent = Container
local SC = Instance.new("UICorner") SC.CornerRadius = UDim.new(0, 4) SC.Parent = Slider

local SLbl = Instance.new("TextLabel")
SLbl.Size = UDim2.new(0, 150, 0, 16)
SLbl.Position = UDim2.new(0, 10, 0, 2)
SLbl.Text = "WalkSpeed Custom ( 16 )"
SLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
SLbl.Font = Enum.Font.GothamMedium SLbl.TextSize = 10 SLbl.TextXAlignment = Enum.TextXAlignment.Left SLbl.BackgroundTransparency = 1 SLbl.Parent = Slider

local SliderBar = Instance.new("TextButton")
SliderBar.Size = UDim2.new(0, 80, 0, 4)
SliderBar.Position = UDim2.new(1, -90, 0, 18)
SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderBar.Text = "" SliderBar.Parent = Slider
local SBC = Instance.new("UICorner") SBC.CornerRadius = UDim.new(0, 2) SBC.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
SliderFill.BorderSizePixel = 0 SliderFill.Parent = SliderBar

local Knob = Instance.new("Frame")
Knob.Size = UDim2.new(0, 10, 0, 10)
Knob.Position = UDim2.new(0, -5, 0, -3)
Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255) Knob.Parent = SliderBar
local KC = Instance.new("UICorner") KC.CornerRadius = UDim.new(1, 0) KC.Parent = Knob

local s_dragging = false
SliderBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then s_dragging = true end end)
game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then s_dragging = false end end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if s_dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local percentage = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        Knob.Position = UDim2.new(percentage, -5, 0, -3)
        _G.StepSpeed = math.floor(16 + (percentage * (120 - 16)))
        SLbl.Text = "WalkSpeed Custom ( " .. tostring(_G.StepSpeed) .. " )"
    end
end)

local function CreateReaperRowToggle(title, posY, callback)
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

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 32, 0, 18)
    Switch.Position = UDim2.new(1, -40, 0, 11)
    Switch.Text = ""
    Switch.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Switch.Parent = Row
    local SwC = Instance.new("UICorner") SwC.CornerRadius = UDim.new(1, 0) SwC.Parent = Switch

    local SKnob = Instance.new("Frame")
    SKnob.Size = UDim2.new(0, 12, 0, 12)
    SKnob.Position = UDim2.new(0, 3, 0, 3)
    SKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SKnob.BorderSizePixel = 0
    SKnob.Parent = Switch
    local SKC = Instance.new("UICorner") SKC.CornerRadius = UDim.new(1, 0) SKC.Parent = SKnob

    local state = false
    Switch.MouseButton1Click:Connect(function()
        state = not state
        Switch.BackgroundColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(45, 45, 45)
        SKnob:TweenPosition(state and UDim2.new(1, -15, 0, 3) or UDim2.new(0, 3, 0, 3), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
        callback(state)
    end)
end

CreateReaperRowToggle("Infinite Jump Engine", 50, function(v) _G.AutoJump = v end)
CreateReaperRowToggle("No Clip Parameters Bypass", 95, function(v) _G.NoClip = v end)

-- ระบบลูปฟิสิกส์แกนหลักหลังบ้าน ควบคุมตัวละครจริง
local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
    pcall(function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
            if _G.StepSpeed > 16 then
                character.Humanoid.WalkSpeed = _G.StepSpeed
                if character.Humanoid.MoveDirection.Magnitude > 0 then
                    character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + (character.Humanoid.MoveDirection * (_G.StepSpeed / 80))
                end
            end
            if _G.NoClip then
                for _, child in pairs(character:GetChildren()) do if child:IsA("BasePart") then child.CanCollide = false end end
            end
        end
    end)
end)

UserInputService.JumpRequest:Connect(function() if _G.AutoJump pcall(function() player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end)
