-- [[ STEPCONTROL HUB - TOTAL INTEGRATED EDITION 2026 ]] --

-- ========================================================
-- [ 1. ระบบล็อกไอดีผู้สร้าง (WHITELIST SYSTEM) ]
-- ========================================================
local CreatorName = "StepcontrolAOTR" -- << เปลี่ยนเป็นชื่อ Username ในเกมของคุณเอง

if game.Players.LocalPlayer.Name ~= CreatorName then
    game.Players.LocalPlayer:Kick("❌ STEPCONTROL HUB: ขออภัย ไอดีของคุณไม่ได้รับอนุญาตให้ใช้สคริปต์นี้!")
    return
end

-- ========================================================
-- [ 2. ระบบหน้าต่างเช็กคีย์รับรหัส (KEY SYSTEM UI) ]
-- ========================================================
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local targetParent = game:GetService("CoreGui")
if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

if targetParent:FindFirstChild("StepControlKeyGui") then targetParent.StepControlKeyGui:Destroy() end
if targetParent:FindFirstChild("StepControlResizeable") then targetParent.StepControlResizeable:Destroy() end

local CorrectKey = "STEPCONTROL_PASS_2026" -- รหัสผ่านเข้าโปร
local GetKeyURL = "discord.gg/stepcontrol" -- ลิงก์รับรหัส

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "StepControlKeyGui"
KeyGui.Parent = targetParent
KeyGui.ResetOnSpawn = false

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 400, 0, 240)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -120)
KeyFrame.BackgroundColor3 = Color3.fromRGB(12, 13, 15)
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = KeyGui
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
local KeyStroke = Instance.new("UIStroke", KeyFrame)
KeyStroke.Color = Color3.fromRGB(0, 210, 120)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Text = "🔑 STEPCONTROL HUB | KEY SYSTEM"
KeyTitle.Size = UDim2.new(1, 0, 0, 45)
KeyTitle.TextColor3 = Color3.fromRGB(0, 240, 110)
KeyTitle.TextSize = 14
KeyTitle.Font = Enum.Font.FredokaOne
KeyTitle.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.PlaceholderText = "กรอกรหัสผ่านตรงนี้..."
KeyInput.Size = UDim2.new(1, -40, 0, 40)
KeyInput.Position = UDim2.new(0, 20, 0, 65)
KeyInput.BackgroundColor3 = Color3.fromRGB(20, 21, 25)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 13
KeyInput.Font = Enum.Font.SourceSansBold
KeyInput.Text = ""
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

local CheckButton = Instance.new("TextButton", KeyFrame)
CheckButton.Text = "✓ ตรวจสอบรหัสผ่าน"
CheckButton.Size = UDim2.new(0, 170, 0, 40)
CheckButton.Position = UDim2.new(0, 20, 0, 125)
CheckButton.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
CheckButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckButton.Font = Enum.Font.SourceSansBold
CheckButton.TextSize = 13
Instance.new("UICorner", CheckButton).CornerRadius = UDim.new(0, 8)

local GetKeyButton = Instance.new("TextButton", KeyFrame)
GetKeyButton.Text = "🔗 คัดลอกลิงก์รับคีย์"
GetKeyButton.Size = UDim2.new(0, 170, 0, 40)
GetKeyButton.Position = UDim2.new(1, -190, 0, 125)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
GetKeyButton.TextColor3 = Color3.fromRGB(0, 230, 110)
GetKeyButton.Font = Enum.Font.SourceSansBold
GetKeyButton.TextSize = 13
Instance.new("UICorner", GetKeyButton).CornerRadius = UDim.new(0, 8)

local InfoLabel = Instance.new("TextLabel", KeyFrame)
InfoLabel.Text = "กรุณากรอกรหัสผ่านเพื่อปลดล็อกหน้าต่างโปรหลัก"
InfoLabel.Size = UDim2.new(1, -40, 0, 30)
InfoLabel.Position = UDim2.new(0, 20, 0, 185)
InfoLabel.TextColor3 = Color3.fromRGB(120, 125, 130)
InfoLabel.TextSize = 11
InfoLabel.Font = Enum.Font.SourceSans
InfoLabel.BackgroundTransparency = 1

GetKeyButton.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(GetKeyURL) InfoLabel.Text = "✅ คัดลอกลิงก์เรียบร้อย!" InfoLabel.TextColor3 = Color3.fromRGB(0, 230, 110) end
end)

-- ========================================================
-- [ 3. ฟังก์ชันสร้างหน้าต่างหลักเมื่อรหัสคีย์ถูกต้อง (MAIN UI) ]
-- ========================================================
local function LaunchMainHub()
    _G.AutoFarm = false
    _G.FarmDistance = 5 -- ค่าเริ่มต้นรับจาก Slider

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StepControlResizeable"
    ScreenGui.Parent = targetParent
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 560, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -280, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(0, 210, 120)

    -- [ ระบบลากปรับขนาดขวาล่าง ]
    local ResizeButton = Instance.new("TextButton", MainFrame)
    ResizeButton.Size = UDim2.new(0, 16, 0, 16)
    ResizeButton.Position = UDim2.new(1, -16, 1, -16)
    ResizeButton.BackgroundColor3 = Color3.fromRGB(0, 210, 120)
    ResizeButton.BackgroundTransparency = 0.8
    ResizeButton.Text = "◢"
    ResizeButton.TextColor3 = Color3.fromRGB(0, 210, 120)
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

    -- Sidebar ด้านซ้าย
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(6, 7, 8)
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 14)
    local SidePatch = Instance.new("Frame", Sidebar)
    SidePatch.Size = UDim2.new(0, 15, 1, 0)
    SidePatch.Position = UDim2.new(1, -15, 0, 0)
    SidePatch.BackgroundColor3 = Color3.fromRGB(6, 7, 8)

    -- ปุ่มแดงสไตล์ Mac OS กดปิดโปรหลัก
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
    ActionBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() _G.AutoFarm = false end)

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

    -- ฝั่งขวาคอนโทรลเลอร์
    local RightArea = Instance.new("Frame", MainFrame)
    RightArea.Size = UDim2.new(1, -150, 1, 0)
    RightArea.Position = UDim2.new(0, 150, 0, 0)
    RightArea.BackgroundTransparency = 1

    local Card = Instance.new("Frame", RightArea)
    Card.Size = UDim2.new(1, -35, 0, 200)
    Card.Position = UDim2.new(0, 20, 0, 52)
    Card.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
    Instance.new("UICorner", Card)

    local ToggleLabel = Instance.new("TextLabel", Card)
    ToggleLabel.Text = "Auto Farm Level (เปิดบอทเก็บเวล)"
    ToggleLabel.Size = UDim2.new(0, 200, 0, 30)
    ToggleLabel.Position = UDim2.new(0, 16, 0, 25)
    ToggleLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
    ToggleLabel.Font = Enum.Font.SourceSansBold
    ToggleLabel.BackgroundTransparency = 1

    -- [ ปุ่มสวิตช์เปิดปิด Auto Farm ]
    local Switch = Instance.new("TextButton", Card)
    Switch.Text = ""
    Switch.Size = UDim2.new(0, 44, 0, 22)
    Switch.Position = UDim2.new(1, -60, 0, 29)
    Switch.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local SwitchDot = Instance.new("Frame", Switch)
    SwitchDot.Size = UDim2.new(0, 18, 0, 18)
    SwitchDot.Position = UDim2.new(0, 2, 0, 2)
    SwitchDot.BackgroundColor3 = Color3.fromRGB(140, 145, 150)
    Instance.new("UICorner", SwitchDot)

    Switch.MouseButton1Click:Connect(function()
        _G.AutoFarm = not _G.AutoFarm
        if _G.AutoFarm then
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 200, 95)}):Play()
            TweenService:Create(SwitchDot, TweenInfo.new(0.15), {Position = UDim2.new(0, 24, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 38, 42)}):Play()
            TweenService:Create(SwitchDot, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(140, 145, 150)}):Play()
        end
    end)

    -- [ แถบเลื่อนปรับระยะห่าง DISTANCE SLIDER (ดึงกลับมาใช้งานได้จริง) ]
    local SliderLabel = Instance.new("TextLabel", Card)
    SliderLabel.Text = "Farm Distance (ระยะห่างจากมอน)"
    SliderLabel.Size = UDim2.new(0, 200, 0, 30)
    SliderLabel.Position = UDim2.new(0, 16, 0, 85)
    SliderLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
    SliderLabel.Font = Enum.Font.SourceSansBold
    SliderLabel.BackgroundTransparency = 1

    local SliderValueText = Instance.new("TextLabel", Card)
    SliderValueText.Text = "5"
    SliderValueText.Size = UDim2.new(0, 40, 0, 30)
    SliderValueText.Position = UDim2.new(1, -55, 0, 85)
    SliderValueText.TextColor3 = Color3.fromRGB(0, 230, 110)
    SliderValueText.Font = Enum.Font.SourceSansBold
    SliderValueText.BackgroundTransparency = 1

    local SliderTrack = Instance.new("TextButton", Card)
    SliderTrack.Text = ""
    SliderTrack.Size = UDim2.new(1, -32, 0, 6)
    SliderTrack.Position = UDim2.new(0, 16, 0, 125)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
    SliderTrack.BorderSizePixel = 0
    Instance.new("UICorner", SliderTrack)

    local SliderFill = Instance.new("Frame", SliderTrack)
    SliderFill.Size = UDim2.new(0.33, 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 95)
    Instance.new("UICorner", SliderFill)

    local SliderDot = Instance.new("Frame", SliderTrack)
    SliderDot.Size = UDim2.new(0, 14, 0, 14)
    SliderDot.Position = UDim2.new(0.33, -7, 0.5, -7)
    SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", SliderDot)

    local dragging = false
    local function updateSlider()
        local mousePos = UserInputService:GetMouseLocation().X
        local trackPos = SliderTrack.AbsolutePosition.X
        local trackWidth = SliderTrack.AbsoluteSize.X
        local percentage = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        SliderDot.Position = UDim2.new(percentage, -7, 0.5, -7)
        local calculatedDistance = math.floor(percentage * 15)
        _G.FarmDistance = calculatedDistance
        SliderValueText.Text = tostring(calculatedDistance)
    end
    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true updateSlider() end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider() end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- ระบบเช็กความถูกต้องปุ่มกดยืนยันคีย์
CheckButton.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        InfoLabel.Text = "🟢 รหัสผ่านถูกต้อง! กำลังกางแผงโปรหลัก..."
        InfoLabel.TextColor3 = Color3.fromRGB(0, 230, 110)
        task.wait(0.8)
        KeyGui:Destroy()
        LaunchMainHub() -- สั่งรันกางหน้าต่างหลักที่มีตัวปรับ Distance ขึ้นจอ
    else
        InfoLabel.Text = "❌ รหัสผ่านไม่ถูกต้อง! กรุณาลองใหมี่อีกครั้ง"
        InfoLabel.TextColor3 = Color3.fromRGB(235, 80, 80)
    end
end)

-- ========================================================
-- [ 4. สมองกลระบบบินฟาร์ม + ออโต้คลิกโจมตีของจริง ]
-- ========================================================
local function EquipWeapon()
    local p = game.Players.LocalPlayer
    local backpack = p:FindFirstChild("Backpack")
    local char = p.Character
    if char and backpack and not char:FindFirstChildOfClass("Tool") then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then char.Humanoid:EquipTool(tool) break end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.1) -- หน่วงเวลาคงที่เพื่อเซฟระบบ Delta ไม่ให้เด้งออกเกม
        if _G.AutoFarm then
            pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                
                if workspace:FindFirstChild("Enemies") then
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                            
                            -- ล็อกตัวละครไม่ให้ตกแมพขณะบินฟาร์ม
                            character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                            
                            -- [[ แก้วิธีบินและแก้ระยะ Distance ]: ย้ายพิกัดตัวเราไปล็อกไว้เหนือหัวมอนสเตอร์ตามระยะห่างจริงที่ได้จาก Slider บน UI
                            character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, _G.FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            
                            -- เรียกคำสั่งถืออาวุธ
                            EquipWeapon()
                            
                            -- [[ แก้จุดบั๊กไม่ยอมตี ]: บังคับยิง Remote ระบบสแกนคลิกหน้าจอโจมตีของตัวเกม Blox Fruits ทันทีที่วาร์ปถึงตัว
                            local VirtualUser = game:GetService("VirtualUser")
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton1(Vector2.new(850, 520))
                            break
                        end
                    end
                end
            end)
        end
    end
end)
