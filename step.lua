-- [[ STEPCONTROL HUB - HYPER RESPONSIVE TEXT & FUNCTIONAL FARM EDITION ]] --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local targetParent = game:GetService("CoreGui")

if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

if targetParent:FindFirstChild("StepControlResponsive") then
    targetParent.StepControlResponsive:Destroy()
end

-- ========================================================
-- [ ตัวแปรระบบกลไกภายใน ]
-- ========================================================
_G.AutoFarm = false
_G.SuperFastAttack = false
_G.FarmDistance = 5

-- 1. ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlResponsive"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

-- 2. Main Frame (หน้าต่างหลักปรับขนาดได้)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
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
MainStroke.Color = Color3.fromRGB(0, 240, 110)

-- [ ◥ ปุ่มลากปรับขนาดมุมขวาล่าง ]
local ResizeButton = Instance.new("TextButton", MainFrame)
ResizeButton.Size = UDim2.new(0, 20, 0, 20)
ResizeButton.Position = UDim2.new(1, -20, 1, -20)
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
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isResizing = false MainFrame.Draggable = true end
end)

-- Sidebar ฝั่งซ้าย
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0.27, 0, 1, 0) -- ใช้ค่า % แทนเพื่อขยายตามขนาดโครงสร้างหลัก
Sidebar.BackgroundColor3 = Color3.fromRGB(6, 7, 8)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 14)

local SidePatch = Instance.new("Frame", Sidebar)
SidePatch.Size = UDim2.new(0, 15, 1, 0)
SidePatch.Position = UDim2.new(1, -15, 0, 0)
SidePatch.BackgroundColor3 = Color3.fromRGB(6, 7, 8)

-- ปุ่มแดง Mac OS กดปิดโปร
local MacButtons = Instance.new("Frame", Sidebar)
MacButtons.Size = UDim2.new(0.3, 0, 0.04, 0)
MacButtons.Position = UDim2.new(0, 16, 0, 16)
MacButtons.BackgroundTransparency = 1
local Dot = Instance.new("Frame", MacButtons)
Dot.Size = UDim2.new(0, 12, 0, 12)
Dot.BackgroundColor3 = Color3.fromRGB(255, 85, 80)
Instance.new("UICorner", Dot)
local ActionBtn = Instance.new("TextButton", Dot)
ActionBtn.Size = UDim2.new(1, 0, 1, 0)
ActionBtn.BackgroundTransparency = 1
ActionBtn.Text = ""
ActionBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() _G.AutoFarm = false _G.SuperFastAttack = false end)

-- โลโก้ STEPCONTROL (ปรับให้ขยายใหญ่ตามหน้าจอ)
local Brand = Instance.new("TextLabel", Sidebar)
Brand.Text = "STEPCONTROL"
Brand.Size = UDim2.new(1, -20, 0.08, 0)
Brand.Position = UDim2.new(0, 14, 0, 36)
Brand.TextColor3 = Color3.fromRGB(0, 230, 110)
Brand.Font = Enum.Font.FredokaOne
Brand.TextScaled = true -- ขยายตัวหนังสือใหญ่ตาม UI
Brand.TextXAlignment = Enum.TextXAlignment.Left
Brand.BackgroundTransparency = 1

local Tab = Instance.new("TextButton", Sidebar)
Tab.Text = "  ⚡  Main Farm"
Tab.Size = UDim2.new(1, -16, 0.1, 0)
Tab.Position = UDim2.new(0, 8, 0, 80)
Tab.BackgroundColor3 = Color3.fromRGB(12, 35, 22)
Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab.Font = Enum.Font.SourceSansBold
Tab.TextScaled = true
Tab.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Tab)

-- พื้นที่ฟังก์ชันฝั่งขวา
local RightArea = Instance.new("Frame", MainFrame)
RightArea.Size = UDim2.new(0.73, 0, 1, 0)
RightArea.Position = UDim2.new(0.27, 0, 0, 0)
RightArea.BackgroundTransparency = 1

local HeaderText = Instance.new("TextLabel", RightArea)
HeaderText.Text = "STEPCONTROL HUB | Blox Fruits VIP"
HeaderText.Size = UDim2.new(1, -20, 0.08, 0)
HeaderText.Position = UDim2.new(0, 20, 0, 14)
HeaderText.TextColor3 = Color3.fromRGB(240, 240, 245)
HeaderText.Font = Enum.Font.SourceSansBold
HeaderText.TextScaled = true
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.BackgroundTransparency = 1

local Card = Instance.new("Frame", RightArea)
Card.Size = UDim2.new(1, -35, 0.75, 0)
Card.Position = UDim2.new(0, 20, 0, 52)
Card.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
Instance.new("UICorner", Card)
local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(26, 32, 30)

-- ========================================================
-- [ กลไกสร้างปุ่มแบบ TEXT SCALED ขยายใหญ่ตามขนาด UI ]
-- ========================================================
local function AddPremiumToggle(labelText, yPosPercent, globalVarName)
    local ToggleLabel = Instance.new("TextLabel", Card)
    ToggleLabel.Text = labelText
    ToggleLabel.Size = UDim2.new(0.65, 0, 0.12, 0)
    ToggleLabel.Position = UDim2.new(0, 16, yPosPercent, 0)
    ToggleLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
    ToggleLabel.Font = Enum.Font.SourceSansBold
    ToggleLabel.TextScaled = true -- ตัวหนังสือฟังก์ชันใหญ่ตามขนาดหน้าต่าง
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.BackgroundTransparency = 1

    local Switch = Instance.new("TextButton", Card)
    Switch.Text = ""
    Switch.Size = UDim2.new(0.15, 0, 0.1, 0)
    Switch.Position = UDim2.new(0.8, 0, yPosPercent + 0.01, 0)
    Switch.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local SwitchDot = Instance.new("Frame", Switch)
    SwitchDot.Size = UDim2.new(0.4, 0, 0.8, 0)
    SwitchDot.Position = UDim2.new(0.1, 0, 0.1, 0)
    SwitchDot.BackgroundColor3 = Color3.fromRGB(140, 145, 150)
    Instance.new("UICorner", SwitchDot)

    Switch.MouseButton1Click:Connect(function()
        _G[globalVarName] = not _G[globalVarName]
        if _G[globalVarName] then
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 200, 95)}):Play()
            TweenService:Create(SwitchDot, TweenInfo.new(0.15), {Position = UDim2.new(0.5, 0, 0.1, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 38, 42)}):Play()
            TweenService:Create(SwitchDot, TweenInfo.new(0.15), {Position = UDim2.new(0.1, 0, 0.1, 0), BackgroundColor3 = Color3.fromRGB(140, 145, 150)}):Play()
            ToggleLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
        end
    end)
end

AddPremiumToggle("Auto Farm Level (เปิดบอทเก็บเวล)", 0.1, "AutoFarm")
AddPremiumToggle("Super Fast Attack (ตีเร็วมากกกกกกก)", 0.3, "SuperFastAttack")

-- [ แถบเลื่อนปรับระยะห่าง DISTANCE SLIDER แบบขยายใหญ่ตามกรอบ ]
local SliderLabel = Instance.new("TextLabel", Card)
SliderLabel.Text = "Farm Distance (ระยะห่างพิกัดจากมอน)"
SliderLabel.Size = UDim2.new(0.6, 0, 0.12, 0)
SliderLabel.Position = UDim2.new(0, 16, 0.5, 0)
SliderLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
SliderLabel.Font = Enum.Font.SourceSansBold
SliderLabel.TextScaled = true
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.BackgroundTransparency = 1

local SliderValueText = Instance.new("TextLabel", Card)
SliderValueText.Text = "5"
SliderValueText.Size = UDim2.new(0.15, 0, 0.12, 0)
SliderValueText.Position = UDim2.new(0.8, 0, 0.5, 0)
SliderValueText.TextColor3 = Color3.fromRGB(0, 230, 110)
SliderValueText.Font = Enum.Font.SourceSansBold
SliderValueText.TextScaled = true
SliderValueText.TextXAlignment = Enum.TextXAlignment.Right
SliderValueText.BackgroundTransparency = 1

local SliderTrack = Instance.new("TextButton", Card)
SliderTrack.Text = ""
SliderTrack.Size = UDim2.new(0.9, 0, 0.03, 0)
SliderTrack.Position = UDim2.new(0, 16, 0.7, 0)
SliderTrack.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
SliderTrack.BorderSizePixel = 0
Instance.new("UICorner", SliderTrack)

local SliderFill = Instance.new("Frame", SliderTrack)
SliderFill.Size = UDim2.new(0.33, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 95)
Instance.new("UICorner", SliderFill)

local SliderDot = Instance.new("Frame", SliderTrack)
SliderDot.Size = UDim2.new(0.04, 0, 3, 0)
SliderDot.Position = UDim2.new(0.33, 0, -1, 0)
SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SliderDot)

local dragging = false
local function updateSlider()
    local mousePos = UserInputService:GetMouseLocation().X
    local trackPos = SliderTrack.AbsolutePosition.X
    local trackWidth = SliderTrack.AbsoluteSize.X
    local percentage = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    SliderDot.Position = UDim2.new(percentage, 0, -1, 0)
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

-- ========================================================
-- [ 🔥 CORE FUNCTION: สมองกลล็อกเป้าฟาร์มและสั่งตีรัวไร้บั๊ก ]
-- ========================================================
local function FindValidMonster()
    -- ระบบสแกนหาเป้าหมายมอนสเตอร์ในตัวเกมแบบเรียลไทม์
    if workspace:FindFirstChild("Enemies") then
        for _, v in pairs(workspace.Enemies:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then return v end
        end
    end
    for _, v in pairs(workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and (v.Name:match("Bandit") or v.Name:match("Monkey") or v:AttributeExists("Enemy")) then
            return v
        end
    end
    return nil
end

local function ForceEquipTool()
    local p = game.Players.LocalPlayer
    if p.Character and p:FindFirstChild("Backpack") and not p.Character:FindFirstChildOfClass("Tool") then
        for _, tool in pairs(p.Backpack:GetChildren()) do
            if tool:IsA("Tool") then p.Character.Humanoid:EquipTool(tool) break end
        end
    end
end

-- สั่งรันคำสั่งโจมตีรวดเร็วและวาร์ปแบบสมบูรณ์ผ่าน Stepped
RunService.Stepped:Connect(function()
    if _G.AutoFarm then
        pcall(function()
            local p = game.Players.LocalPlayer
            local char = p.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            
            local monster = FindValidMonster()
            if monster then
                -- ล็อกพิกัดกลางอากาศไม่ให้ร่วงตกแมพ
                char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                
                -- [[ ระบบวาร์ปดึงค่าจาก Slider ]]: ย้ายไปล็อกเหนือกหัวมอนสเตอร์ตามระยะห่างจริง
                char.HumanoidRootPart.CFrame = monster.HumanoidRootPart.CFrame * CFrame.new(0, _G.FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                
                -- บังคับถืออาวุธเข้ามือชัวร์ๆ
                ForceEquipTool()
                
                -- [[ แก้ระบบกดตีของจริง ]]: สั่งส่ง Packet ดับเบิ้ลโจมตีผ่านตัวแอปและจำลองเมาส์คลิกพร้อมกันทันที
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then 
                    tool:Activate() -- ยิงดาเมจที่ตัวอาวุธโดยตรง
                end
                
                -- สั่งทำงานร่วมกับระบบ Fast Attack ความเร็วสูง
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
            end
        end)
    end
end)
