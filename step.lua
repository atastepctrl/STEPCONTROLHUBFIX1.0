-- STEPCONTROL HUB V7.5 - ULTIMATE CROSS-PLATFORM (BLOX FRUITS & 99 NIGHTS)
pcall(function() game.Players.LocalPlayer.PlayerGui.StepControlUI:Destroy() end)

_G.StepSpeed = 16
_G.AutoJump = false
_G.NoClip = false
_G.AutoClick = false
_G.SavedSpeed = 16

_G.AutoSticks = false
_G.BloxFastAttack = false
_G.BloxBringMob = false
_G.BloxInfEnergy = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- [1. ระบบ BYPASS กันแบนสำหรับเซิร์ฟเวอร์จริง]
pcall(function()
    game:GetService("ScriptContext").Error:Connect(function() return true end)
    local mt = getrawmetatable(game)
    if mt and setreadonly then
        setreadonly(mt, false)
        local oldNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then return nil end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
end)

-- [2. หน้าต่างหลักดีไซน์ดาร์กโหมดตัดเขียวนีออน]
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 300)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150) -- โผล่ตรงกลางจอมือถือพอดี
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 10) MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke") MainStroke.Thickness = 1.2 MainStroke.Color = Color3.fromRGB(0, 255, 100) MainStroke.Parent = MainFrame

-- ระบบลากหน้าจออัจฉริยะ (รองรับมือถือ)
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

-- ปุ่มลอย SC เรียกเมนูกลับมาตอนย่อหน้าต่าง
local OpenMenuBtn = Instance.new("TextButton")
OpenMenuBtn.Size = UDim2.new(0, 42, 0, 42)
OpenMenuBtn.Position = UDim2.new(0, 20, 0, 20)
OpenMenuBtn.Text = "SC"
OpenMenuBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
OpenMenuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenMenuBtn.Font = Enum.Font.GothamBold OpenMenuBtn.TextSize = 12 OpenMenuBtn.Visible = false OpenMenuBtn.Parent = ScreenGui
local OpenCorner = Instance.new("UICorner") OpenCorner.CornerRadius = UDim.new(1, 0) OpenCorner.Parent = OpenMenuBtn
local OpenStroke = Instance.new("UIStroke") OpenStroke.Thickness = 1.2 OpenStroke.Color = Color3.fromRGB(0, 255, 100) OpenStroke.Parent = OpenMenuBtn
OpenMenuBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenMenuBtn.Visible = false end)

-- ปุ่มสามจุดสไตล์ Mac (แดง ปิด / เหลือง ย่อ / เขียว รีเซ็ต)
local MacButtons = Instance.new("Frame")
MacButtons.Size = UDim2.new(0, 60, 0, 30)
MacButtons.Position = UDim2.new(0, 15, 0, 10)
MacButtons.BackgroundTransparency = 1
MacButtons.Parent = MainFrame

local function CreateMacClickableDot(color, posX, callback)
    local DotButton = Instance.new("TextButton")
    DotButton.Size = UDim2.new(0, 11, 0, 11)
    DotButton.Position = UDim2.new(0, posX, 0, 10)
    DotButton.BackgroundColor3 = color
    DotButton.BorderSizePixel = 0 DotButton.Text = "" DotButton.Parent = MacButtons
    local DC = Instance.new("UICorner") DC.CornerRadius = UDim.new(1, 0) DC.Parent = DotButton
    DotButton.MouseButton1Click:Connect(callback)
end

CreateMacClickableDot(Color3.fromRGB(255, 95, 86), 0, function() pcall(function() ScreenGui:Destroy() end) end) 
CreateMacClickableDot(Color3.fromRGB(255, 189, 46), 16, function() MainFrame.Visible = false OpenMenuBtn.Visible = true end) 
CreateMacClickableDot(Color3.fromRGB(0, 255, 100), 32, function() 
    _G.StepSpeed = 16
    pcall(function()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 end
        MainFrame.Container1.SliderRow.SliderBar.SliderFill.Size = UDim2.new(0, 0, 1, 0)
        MainFrame.Container1.SliderRow.SliderBar.Knob.Position = UDim2.new(0, -5, 0, -3)
        MainFrame.Container1.SliderRow.WalkSpeedLabel.Text = "WalkSpeed Parameter ( 16 )"
    end)
end)

local GameTitle = Instance.new("TextLabel")
GameTitle.Size = UDim2.new(0, 200, 0, 30)
GameTitle.Position = UDim2.new(0, 140, 0, 5)
GameTitle.Text = "STEPCONTROL HUB"
GameTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
GameTitle.Font = Enum.Font.GothamBold GameTitle.TextSize = 12 GameTitle.TextXAlignment = Enum.TextXAlignment.Left GameTitle.BackgroundTransparency = 1 GameTitle.Parent = MainFrame

-- [3. เมนูแถบข้างด้านซ้าย (Sidebar)]
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 120, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.BorderSizePixel = 0 Sidebar.ScrollBarThickness = 0 Sidebar.CanvasSize = UDim2.new(0, 0, 0, 300) Sidebar.Parent = MainFrame

local SBLine = Instance.new("Frame")
SBLine.Size = UDim2.new(0, 1, 1, 0)
SBLine.Position = UDim2.new(0, 120, 0, 0)
SBLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SBLine.BorderSizePixel = 0 SBLine.Parent = MainFrame

local function CreateSidebarCategory(name, posY)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 12, 0, posY)
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(90, 90, 95)
    Label.Font = Enum.Font.GothamBold Label.TextSize = 9 Label.TextXAlignment = Enum.TextXAlignment.Left Label.BackgroundTransparency = 1 Label.Parent = Sidebar
end

local function CreateSidebarTab(name, posY, isSelected)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -16, 0, 26)
    Btn.Position = UDim2.new(0, 8, 0, posY)
    Btn.Text = "   " .. name
    Btn.Font = Enum.Font.GothamMedium Btn.TextSize = 10 Btn.TextXAlignment = Enum.TextXAlignment.Left Btn.Parent = Sidebar
    local BC = Instance.new("UICorner") BC.CornerRadius = UDim.new(0, 5) BC.Parent = Btn
    if isSelected then Btn.TextColor3 = Color3.fromRGB(0, 0, 0) Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 100) else Btn.TextColor3 = Color3.fromRGB(160, 160, 165) Btn.BackgroundTransparency = 1 end
    return Btn
end

-- สร้างหน้าเก็บปุ่มฝั่งขวาแยกชิ้น 3 แท็บแบบดิบตรงระบบ
local function CreateMainContainer(name, isVisible)
    local Container = Instance.new("ScrollingFrame")
    Container.Name = name
    Container.Size = UDim2.new(1, -135, 1, -55)
    Container.Position = UDim2.new(0, 130, 0, 50)
    Container.BackgroundTransparency = 1; Container.BorderSizePixel = 0; Container.ScrollBarThickness = 2; Container.CanvasSize = UDim2.new(0, 0, 0, 400)
    Container.Visible = isVisible
    Container.Parent = MainFrame
    return Container
end

local Container1 = CreateMainContainer("Container1", true)
local Container2 = CreateMainContainer("Container2", false)
local ContainerMapSpecific = CreateMainContainer("ContainerMapSpecific", false)

CreateSidebarCategory("MAIN CHEATS", 5)
local Tab1 = CreateSidebarTab("⚡ Player Tools", 25, true)
CreateSidebarCategory("SETTINGS", 60)
local Tab2 = CreateSidebarTab("🌀 Miscellaneous", 80, false)

-- ดักจับระบบสลับแมพเพื่อสร้างชื่อแถบอัตโนมัติ
local GamePlaceId = game.PlaceId
local MapTabName = "🌲 99 Nights"
if GamePlaceId == 2753915549 or game.Workspace:FindFirstChild("Sea") or game.Workspace:FindFirstChild("NPCs") then MapTabName = "⚔️ Blox Fruits" end

CreateSidebarCategory("MAP DETECTED", 115)
local TabMap = CreateSidebarTab(MapTabName, 135, false)

local function ResetTabVisuals()
    Tab1.BackgroundTransparency = 1 Tab1.TextColor3 = Color3.fromRGB(160, 160, 165)
    Tab2.BackgroundTransparency = 1 Tab2.TextColor3 = Color3.fromRGB(160, 160, 165)
    TabMap.BackgroundTransparency = 1 TabMap.TextColor3 = Color3.fromRGB(160, 160, 165)
    Container1.Visible = false Container2.Visible = false ContainerMapSpecific.Visible = false
end

Tab1.MouseButton1Click:Connect(function() ResetTabVisuals() Container1.Visible = true Tab1.BackgroundTransparency = 0 Tab1.BackgroundColor3 = Color3.fromRGB(0, 255, 100) Tab1.TextColor3 = Color3.fromRGB(0, 0, 0) end)
Tab2.MouseButton1Click:Connect(function() ResetTabVisuals() Container2.Visible = true Tab2.BackgroundTransparency = 0 Tab2.BackgroundColor3 = Color3.fromRGB(0, 255, 100) Tab2.TextColor3 = Color3.fromRGB(0, 0, 0) end)
TabMap.MouseButton1Click:Connect(function() ResetTabVisuals() ContainerMapSpecific.Visible = true TabMap.BackgroundTransparency = 0 TabMap.BackgroundColor3 = Color3.fromRGB(0, 255, 100) TabMap.TextColor3 = Color3.fromRGB(0, 0, 0) end)

-- [4. ฟังก์ชันสร้างกล่องตัวเลือกสวิตช์เปิด-ปิด]
local function CreateReaperRowToggle(title, subText, posY, parent, startState, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -15, 0, 45)
    Row.Position = UDim2.new(0, 0, 0, posY)
    Row.BackgroundTransparency = 1; Row.Parent = parent

    local Txt = Instance.new("TextLabel")
    Txt.Size = UDim2.new(0, 220, 0, 18)
    Txt.Text = title
    Txt.TextColor3 = Color3.fromRGB(230, 230, 230)
    Txt.Font = Enum.Font.GothamMedium Txt.TextSize = 10 Txt.TextXAlignment = Enum.TextXAlignment.Left Txt.BackgroundTransparency = 1 Txt.Parent = Row

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 32, 0, 18)
    Switch.Position = UDim2.new(1, -35, 0, 12)
    Switch.Text = ""
    Switch.BackgroundColor3 = startState and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(45, 45, 45)
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

-- [5. แถบเลื่อนสไลเดอร์ความเร็ว]
local SliderRow = Instance.new("Frame")
SliderRow.Name = "SliderRow"
SliderRow.Size = UDim2.new(1, -15, 0, 45)
SliderRow.Position = UDim2.new(0, 0, 0, 5)
SliderRow.BackgroundTransparency = 1; SliderRow.Parent = Container1

local SLbl = Instance.new("TextLabel")
SLbl.Name = "WalkSpeedLabel"
SLbl.Size = UDim2.new(0, 180, 0, 18)
SLbl.Text = "WalkSpeed Parameter ( 16 )"
SLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
SLbl.Font = Enum.Font.GothamMedium SLbl.TextSize = 10 SLbl.TextXAlignment = Enum.TextXAlignment.Left SLbl.BackgroundTransparency = 1 SLbl.Parent = SliderRow

local SliderBar = Instance.new("TextButton")
SliderBar.Name = "SliderBar"
SliderBar.Size = UDim2.new(0, 90, 0, 4)
SliderBar.Position = UDim2.new(1, -95, 0, 20)
SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SliderBar.Text = ""
SliderBar.Parent = SliderRow
local SBC = Instance.new("UICorner") SBC.CornerRadius = UDim.new(0, 2) SBC.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
SliderFill.BorderSizePixel = 0 SliderFill.Parent = SliderBar

local Knob = Instance.new("Frame")
Knob.Name = "Knob"
Knob.Size = UDim2.new(0, 10, 0, 10)
Knob.Position = UDim2.new(0, -5, 0, -3)
Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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

CreateReaperRowToggle("Infinite Jump Bypass", "Toggle to activate jumping loop", 55, Container1, false, function(v) _G.AutoJump = v end)
CreateReaperRowToggle("No Clip Mode Enabled", "Bypass block walls detection parameters", 105, Container1, false, function(v) _G.NoClip = v end)
CreateReaperRowToggle("Auto Clicker Macro", "Trigger mouse left clicks per second", 10, Container2, false, function(v) _G.AutoClick = v end)

-- ปุ่มเซฟค่า
local ConfigRow = Instance.new("Frame")
ConfigRow.Size = UDim2.new(1, -15, 0, 50)
ConfigRow.Position = UDim2.new(0, 0, 0, 160)
ConfigRow.BackgroundTransparency = 1; ConfigRow.Parent = Container1

local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(0, 105, 0, 30)
SaveBtn.Position = UDim2.new(0, 0, 0, 10)
SaveBtn.Text = "💾 Save Speed"
SaveBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
SaveBtn.Font = Enum.Font.GothamBold; SaveBtn.TextSize = 10; SaveBtn.Parent = ConfigRow
local SC1 = Instance.new("UICorner") SC1.CornerRadius = UDim.new(0, 5) SC1.Parent = SaveBtn

local LoadBtn = Instance.new("TextButton")
LoadBtn.Size = UDim2.new(0, 105, 0, 30)
LoadBtn.Position = UDim2.new(0, 120, 0, 10)
LoadBtn.Text = "🔄 Load Speed"
LoadBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
LoadBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
LoadBtn.Font = Enum.Font.GothamBold; LoadBtn.TextSize = 10; LoadBtn.Parent = ConfigRow
local SC2 = Instance.new("UICorner") SC2.CornerRadius = UDim.new(0, 5) SC2.Parent = LoadBtn

local function LocalUpdateSlider(speedValue)
    local percentage = math.clamp((speedValue - 16) / (120 - 16), 0, 1)
    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    Knob.Position = UDim2.new(percentage, -5, 0, -3)
    SLbl.Text = "WalkSpeed Parameter ( " .. tostring(speedValue) .. " )"
end

SaveBtn.MouseButton1Click:Connect(function() _G.SavedSpeed = _G.StepSpeed SaveBtn.Text = "✅ Saved!" task.wait(1) SaveBtn.Text = "💾 Save Speed" end)
LoadBtn.MouseButton1Click:Connect(function() _G.StepSpeed = _G.SavedSpeed LocalUpdateSlider(_G.StepSpeed) LoadBtn.Text = "🔄 Loaded!" task.wait(1) LoadBtn.Text = "🔄 Load Speed" end)

-- โหมดจำเพาะแมพ
if MapTabName == "⚔️ Blox Fruits" then
    CreateReaperRowToggle("Auto Fast Attack Combat", "No animation auto attack targets", 10, ContainerMapSpecific, false, function(v) _G.BloxFastAttack = v end)
    CreateReaperRowToggle("Bring Enemies / Mob Magnet", "Magnet clusters monsters to your front CFrame", 60, ContainerMapSpecific, false, function(v) _G.BloxBringMob = v end)
    CreateReaperRowToggle("Infinite Energy Bypass", "Locks energy gauges values to max permanently", 110, ContainerMapSpecific, false, function(v) _G.BloxInfEnergy = v end)
else
    CreateReaperRowToggle("Auto Collect Sticks", "Teleports all forest sticks items to you", 10, ContainerMapSpecific, false, function(v) _G.AutoSticks = v end)
end

-- [7. ระบบลูปฟิสิกส์หลังบ้าน]
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
            
            -- Blox Fruits Magnet Logic (เจาะลึก NPC ทุกเกาะ)
            if _G.BloxInfEnergy and character:FindFirstChild("Energy") then character.Energy.Value = character.Energy.MaxValue end
            if _G.BloxBringMob then
                local folder = game.Workspace:FindFirstChild("Enemies") or game.Workspace:FindFirstChild("NPCs") or game.Workspace
                for _, mob in pairs(folder:GetChildren()) do
                    if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        if (mob.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude < 180 then
                            mob.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
                            mob.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                        end
                    end
                end
            end
            
            -- 99 Nights Logic
            if _G.AutoSticks then
                for _, obj in pairs(game.Workspace:GetChildren()) do
                    if obj.Name:lower():match("stick") or obj.Name:lower():match("wood") then obj.CFrame = character.HumanoidRootPart.CFrame end
                end
            end
        end
    end)
end)

UserInputService.JumpRequest:Connect(function() if _G.AutoJump pcall(function() game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end)
task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    while true do
        task.wait(0.04)
        if _G.AutoClick or _G.BloxFastAttack then pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton1(Vector2.new(0, 0)) end) end
    end
end)
