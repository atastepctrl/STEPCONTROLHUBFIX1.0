-- STEPCONTROL HUB - OFFICIAL REAPERX REWRITE (PC & MOBILE STABLE)
pcall(function() game.Players.LocalPlayer.PlayerGui.StepControlUI:Destroy() end)

_G.StepSpeed = 16
_G.AutoJump = false
_G.NoClip = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- [1. หน้าต่างโครงสร้างหลักถอดแบบพิกัดจาก ReaperX Hub เป๊ะๆ]
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 340) -- ขนาดสัดส่วนเท่าหน้าต่างจริง
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170) -- ล็อกพิกัดโผล่กลางจอภาพชัวร์ทุกอุปกรณ์
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24) -- สีพื้นหลังดาร์กโทนอุ่นสไตล์ ReaperX
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 10) MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke") MainStroke.Thickness = 1.2 MainStroke.Color = Color3.fromRGB(45, 45, 45) MainStroke.Parent = MainFrame

-- แถบสามจุดจำลองสไตล์ Mac บนมุมซ้าย (ปุ่มแดงกดปิดถาวร / ปุ่มเหลืองกดย่อหน้าต่าง)
local MacButtons = Instance.new("Frame")
MacButtons.Size = UDim2.new(0, 60, 0, 30)
MacButtons.Position = UDim2.new(0, 15, 0, 10)
MacButtons.BackgroundTransparency = 1
MacButtons.Parent = MainFrame

-- ปุ่มลอยตัว "SC" เรืองแสงเขียวนีออนสำหรับกดขยายเมนูกลับมาตอนย่อจอ
local OpenMenuBtn = Instance.new("TextButton")
OpenMenuBtn.Size = UDim2.new(0, 42, 0, 42)
OpenMenuBtn.Position = UDim2.new(0, 20, 0, 20)
OpenMenuBtn.Text = "SC"
OpenMenuBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
OpenMenuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenMenuBtn.Font = Enum.Font.GothamBold OpenMenuBtn.TextSize = 12 OpenMenuBtn.Visible = false OpenMenuBtn.Active = true OpenMenuBtn.Draggable = true OpenMenuBtn.Parent = ScreenGui
local OpenCorner = Instance.new("UICorner") OpenCorner.CornerRadius = UDim.new(1, 0) OpenCorner.Parent = OpenMenuBtn
local OpenStroke = Instance.new("UIStroke") OpenStroke.Thickness = 1.2 OpenStroke.Color = Color3.fromRGB(0, 255, 100) OpenStroke.Parent = OpenMenuBtn
OpenMenuBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenMenuBtn.Visible = false end)

local function CreateMacClickableDot(color, posX, callback)
    local DotButton = Instance.new("TextButton")
    DotButton.Size = UDim2.new(0, 11, 0, 11)
    DotButton.Position = UDim2.new(0, posX, 0, 10)
    DotButton.BackgroundColor3 = color
    DotButton.BorderSizePixel = 0 DotButton.Text = "" DotButton.Parent = MacButtons
    local DC = Instance.new("UICorner") DC.CornerRadius = UDim.new(1, 0) DC.Parent = DotButton
    DotButton.MouseButton1Click:Connect(callback)
end

CreateMacClickableDot(Color3.fromRGB(255, 95, 86), 0, function() pcall(function() ScreenGui:Destroy() end) end) -- แดง ปิดสคริปต์
CreateMacClickableDot(Color3.fromRGB(255, 189, 46), 16, function() MainFrame.Visible = false OpenMenuBtn.Visible = true end) -- เหลือง ย่อซ่อนเมนู
CreateMacClickableDot(Color3.fromRGB(0, 255, 100), 32, function() _G.StepSpeed = 16 MainFrame.Container1.SliderRow.SliderBar.SliderFill.Size = UDim2.new(0, 0, 1, 0) MainFrame.Container1.SliderRow.SliderBar.Knob.Position = UDim2.new(0, -5, 0, -3) MainFrame.Container1.SliderRow.WalkSpeedLabel.Text = "WalkSpeed Parameter ( 16 )" end) -- เขียว รีเซ็ตความเร็ว

-- ระบบลากหน้าจออัจฉริยะแบบใหม่หมดจด รองรับทั้งนิ้วสัมผัสและเมาส์คลิกคอม
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

-- หัวข้อชื่อค่ายด้านบนสุดชิดซ้าย
local GameTitle = Instance.new("TextLabel")
GameTitle.Size = UDim2.new(0, 200, 0, 30)
GameTitle.Position = UDim2.new(0, 150, 0, 10)
GameTitle.Text = "STEPCONTROL HUB"
GameTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
GameTitle.Font = Enum.Font.GothamBold GameTitle.TextSize = 12 GameTitle.TextXAlignment = Enum.TextXAlignment.Left GameTitle.BackgroundTransparency = 1 GameTitle.Parent = MainFrame

-- [2. แถบข้าง Sidebar สีดำมืดตัดกับตัวขวาชิดซ้าย]
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 135, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Sidebar.BorderSizePixel = 0 Sidebar.ScrollBarThickness = 0 Sidebar.CanvasSize = UDim2.new(0, 0, 0, 200) Sidebar.Parent = MainFrame

local SBLine = Instance.new("Frame")
SBLine.Size = UDim2.new(0, 1, 1, 0)
SBLine.Position = UDim2.new(0, 135, 0, 0)
SBLine.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SBLine.BorderSizePixel = 0 SBLine.Parent = MainFrame

local function CreateSidebarCategory(name, posY)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 12, 0, posY)
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(90, 90, 95)
    Label.Font = Enum.Font.GothamBold Label.TextSize = 9 Label.TextXAlignment = Enum.TextXAlignment.Left Label.BackgroundTransparency = 1 Label.Parent = Sidebar
end

local function CreateSidebarTab(name, posY)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -16, 0, 26)
    Btn.Position = UDim2.new(0, 8, 0, posY)
    Btn.Text = "   " .. name
    Btn.Font = Enum.Font.GothamMedium Btn.TextSize = 10 Btn.TextXAlignment = Enum.TextXAlignment.Left Btn.Parent = Sidebar
    local BC = Instance.new("UICorner") BC.CornerRadius = UDim.new(0, 5) BC.Parent = Btn
    return Btn
end

CreateSidebarCategory("MAIN CHEATS", 5)
local Tab1 = CreateSidebarTab("⚡ Player Tools", 25)
Tab1.BackgroundColor3 = Color3.fromRGB(0, 255, 100) Tab1.TextColor3 = Color3.fromRGB(0, 0, 0) -- ปุ่มสีเขียวนีออนตัดอักษรดำตามบรีฟรูปภาพ

-- กล่องแสดงรายการฟังก์ชันขวาแบบระเบียบกริ๊บ
local Container1 = Instance.new("ScrollingFrame")
Container1.Name = "Container1"
Container1.Size = UDim2.new(1, -150, 1, -55)
Container1.Position = UDim2.new(0, 145, 0, 50)
Container1.BackgroundTransparency = 1; Container1.BorderSizePixel = 0; Container1.ScrollBarThickness = 0; Container1.CanvasSize = UDim2.new(0, 0, 0, 350); Container1.Parent = MainFrame

-- [3. สไลเดอร์ปรับความเร็ววิ่งสีเขียวนีออนคาดปุ่มขาวขวาตามต้นฉบับ]
local SliderRow = Instance.new("Frame")
local SliderRow = Instance.new("Frame")
SliderRow.Name = "SliderRow"
SliderRow.Size = UDim2.new(1, -15, 0, 45)
SliderRow.Position = UDim2.new(0, 0, 0, 5)
SliderRow.BackgroundTransparency = 1; SliderRow.Parent = Container1

local SLbl = Instance.new("TextLabel")
SLbl.Name = "WalkSpeedLabel"
SLbl.Size = UDim2.new(0, 200, 0, 18)
SLbl.Text = "WalkSpeed Parameter ( 16 )"
SLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
SLbl.Font = Enum.Font.GothamMedium SLbl.TextSize = 11 SLbl.TextXAlignment = Enum.TextXAlignment.Left SLbl.BackgroundTransparency = 1 SLbl.Parent = SliderRow

local SliderBar = Instance.new("TextButton")
SliderBar.Name = "SliderBar"
SliderBar.Size = UDim2.new(0, 100, 0, 4)
SliderBar.Position = UDim2.new(1, -105, 0, 20)
SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderBar.Text = ""
SliderBar.Parent = SliderRow
local SBC = Instance.new("UICorner") SBC.CornerRadius = UDim.new(0, 2) SBC.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100) -- เฉดเขียวนีออนสว่างสะท้อนแสงเวลารูด
SliderFill.BorderSizePixel = 0 SliderFill.Parent = SliderBar

local Knob = Instance.new("Frame")
Knob.Name = "Knob"
Knob.Size = UDim2.new(0, 10, 0, 10)
Knob.Position = UDim2.new(0, -5, 0, -3)
Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- ก้อนกลมรูดสไลเดอร์สีขาวพรีเมียม
Knob.Parent = SliderBar
local KC = Instance.new("UICorner") KC.CornerRadius = UDim.new(1, 0) KC.Parent = Knob

local dragging = false
SliderBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local percentage = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        Knob.Position = UDim2.new(percentage, -5, 0, -3)
        _G.StepSpeed = math.floor(16 + (percentage * (120 - 16)))
        SLbl.Text = "WalkSpeed Parameter ( " .. tostring(_G.StepSpeed) .. " )"
    end
end)

-- [4. ฟังก์ชันสร้างกล่องตัวเลือกสวิตช์เลื่อนเปิด-ปิดตามรูปเป๊ะๆ (Row Toggle Widget)]
local function CreateReaperRowToggle(title, subText, posY, parent, startState, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -15, 0, 45)
    Row.Position = UDim2.new(0, 0, 0, posY)
    Row.BackgroundTransparency = 1; Row.Parent = parent

    local Txt = Instance.new("TextLabel")
    Txt.Size = UDim2.new(0, 250, 0, 18)
    Txt.Text = title
    Txt.TextColor3 = Color3.fromRGB(230, 230, 230)
    Txt.Font = Enum.Font.GothamMedium Txt.TextSize = 11 Txt.TextXAlignment = Enum.TextXAlignment.Left Txt.BackgroundTransparency = 1 Txt.Parent = Row

    local Sub = Instance.new("TextLabel")
    Sub.Size = UDim2.new(0, 250, 0, 15)
    Sub.Position = UDim2.new(0, 0, 0, 16)
    Sub.Text = subText
    Sub.TextColor3 = Color3.fromRGB(110, 110, 115)
    Sub.Font = Enum.Font.GothamMedium Sub.TextSize = 9 Sub.TextXAlignment = Enum.TextXAlignment.Left Sub.BackgroundTransparency = 1 Sub.Parent = Row

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 32, 0, 18)
    Switch.Position = UDim2.new(1, -35, 0, 12)
    Switch.Text = ""
    Switch.BackgroundColor3 = startState and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(45, 45, 45) -- เปิดสีเขียวนีออน ปิดสีเทาเข้ม
    Switch.Parent = Row
    local SC = Instance.new("UICorner") SC.CornerRadius = UDim.new(1, 0) SC.Parent = Switch

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = startState and UDim2.new(1, -15, 0, 3) or UDim2.new(0, 3, 0, 3)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0 Knob.Parent = Switch
    local KC = Instance.new("UICorner") KC.CornerRadius = UDim.new(1, 0) KC.Parent = Knob

    local state = startState
    Switch.MouseButton1Click:Connect(function()
        state = not state
        Switch.BackgroundColor3 = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(45, 45, 45)
        Knob:TweenPosition(state and UDim2.new(1, -15, 0, 3) or UDim2.new(0, 3, 0, 3), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        callback(state)
    end)
end

CreateReaperRowToggle("Infinite Jump Bypass", "Toggle to activate jumping without landing", 55, Container1, false, function(v) _G.AutoJump = v end)
CreateReaperRowToggle("No Clip Mode Enabled", "Bypass solid parts blocks walls parameters", 105, Container1, false, function(v) _G.NoClip = v end)

-- [5. ระบบลูปประมวลผลฟิสิกส์และความเร็ววิ่งหลบแบนหลังบ้าน]
local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
    pcall(function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            if _G.StepSpeed > 16 and character:FindFirstChild("Humanoid") then
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

UserInputService.JumpRequest:Connect(function() if _G.AutoJump pcall(function() game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end)
