-- [[ STEPCONTROL HUB - ANIME APOCALYPSE REAPER X STYLE EDITION ]] --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local targetParent = game:GetService("CoreGui")

if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

if targetParent:FindFirstChild("StepControlApocalypseVIP") then
    targetParent.StepControlApocalypseVIP:Destroy()
end

-- ========================================================
-- [ ตัวแปรหลักเชื่อมโยงฟังก์ชันการทำงาน ]
-- ========================================================
_G.AutoClicker = false
_G.AutoFarmMobs = false
_G.FarmDistance = 5 -- ดึงค่าไปใช้ล็อกพิกัดความสูงเหนือหัวมอนจาก Slider

-- 1. ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlApocalypseVIP"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

-- 2. Main Frame (หน้าต่างโครงสร้างหลักสไตล์ REAPER X HUB ดำ-เขียวนีออน)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 13, 15) -- สีดำ Obsidian มืดพรีเมียมแบบ Reaper Hub
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(0, 240, 110) -- ไฟนีออนเขียวพรีเมียมล้อมรอบขอบหน้าต่าง

-- [ ปุ่มลากปรับขนาดขวาล่างสากล ]
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
ResizeButton.InputEnded:Connect(function(input) isResizing = false MainFrame.Draggable = true end)

-- Sidebar แผงเมนูด้านซ้ายสีดำเข้มตัดผิวแมตต์
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(7, 8, 10)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 14)

local SidePatch = Instance.new("Frame", Sidebar)
SidePatch.Size = UDim2.new(0, 15, 1, 0)
SidePatch.Position = UDim2.new(1, -15, 0, 0)
SidePatch.BackgroundColor3 = Color3.fromRGB(7, 8, 10)

-- ปุ่ม 3 สีสไตล์ Mac OS เป๊ะตามแบบฉบับค่าย Reaper (แดงกดปิดโปรหลัก)
local MacButtons = Instance.new("Frame", Sidebar)
MacButtons.Size = UDim2.new(0, 50, 0, 10)
MacButtons.Position = UDim2.new(0, 16, 0, 16)
MacButtons.BackgroundTransparency = 1

local colors = {Color3.fromRGB(255, 85, 80), Color3.fromRGB(255, 180, 40), Color3.fromRGB(35, 200, 60)}
for i, color in ipairs(colors) do
    local Dot = Instance.new("Frame", MacButtons)
    Dot.Size = UDim2.new(0, 10, 0, 10)
    Dot.Position = UDim2.new(0, (i-1) * 16, 0, 0)
    Dot.BackgroundColor3 = color
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    if i == 1 then
        local ActionBtn = Instance.new("TextButton", Dot)
        ActionBtn.Size = UDim2.new(1, 0, 1, 0)
        ActionBtn.BackgroundTransparency = 1
        ActionBtn.Text = ""
        ActionBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() _G.AutoClicker = false _G.AutoFarmMobs = false end)
    end
end

-- ชื่อสคริปต์ตัวหนาใหญ่เต็มตาตามสั่ง (STEPCONTROL HUB)
local Brand = Instance.new("TextLabel", Sidebar)
Brand.Text = "STEPCONTROL"
Brand.Size = UDim2.new(1, -16, 0, 20)
Brand.Position = UDim2.new(0, 16, 0, 40)
Brand.TextColor3 = Color3.fromRGB(0, 240, 110)
Brand.Font = Enum.Font.FredokaOne
Brand.TextSize = 14
Brand.TextXAlignment = Enum.TextXAlignment.Left
Brand.BackgroundTransparency = 1

local Tab = Instance.new("TextButton", Sidebar)
Tab.Text = "  ⚡  Main Farm"
Tab.Size = UDim2.new(1, -16, 0, 34)
Tab.Position = UDim2.new(0, 8, 0, 80)
Tab.BackgroundColor3 = Color3.fromRGB(15, 45, 25) -- สีปุ่ม Active ไฮไลท์เขียวเข้มแบบเจาะจง
Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab.Font = Enum.Font.SourceSansBold
Tab.TextSize = 13
Tab.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Tab)
local TabStroke = Instance.new("UIStroke", Tab)
TabStroke.Color = Color3.fromRGB(0, 240, 110)

-- พื้นที่ฟังก์ชันฝั่งขวา
local RightArea = Instance.new("Frame", MainFrame)
RightArea.Size = UDim2.new(1, -150, 1, 0)
RightArea.Position = UDim2.new(0, 150, 0, 0)
RightArea.BackgroundTransparency = 1

local HeaderText = Instance.new("TextLabel", RightArea)
HeaderText.Text = "STEPCONTROL HUB | Anime Apocalypse VIP"
HeaderText.Size = UDim2.new(1, -20, 0, 30)
HeaderText.Position = UDim2.new(0, 20, 0, 14)
HeaderText.TextColor3 = Color3.fromRGB(240, 240, 245)
HeaderText.Font = Enum.Font.SourceSansBold
HeaderText.TextSize = 13
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.BackgroundTransparency = 1

local Card = Instance.new("Frame", RightArea)
Card.Size = UDim2.new(1, -35, 0, 230)
Card.Position = UDim2.new(0, 20, 0, 52)
Card.BackgroundColor3 = Color3.fromRGB(16, 17, 20)
Instance.new("UICorner", Card)
local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(28, 35, 32)

-- ฟังก์ชันคุมการสร้างสวิตช์เปิด/ปิดขนาดฟอนต์ใหญ่หนาชัดเจน (Responsive Toggles)
local function AddPremiumToggle(labelText, yPos, globalVarName)
    local ToggleLabel = Instance.new("TextLabel", Card)
    ToggleLabel.Text = labelText
    ToggleLabel.Size = UDim2.new(0.65, 0, 0, 30)
    ToggleLabel.Position = UDim2.new(0, 16, 0, yPos)
    ToggleLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
    ToggleLabel.Font = Enum.Font.SourceSansBold
    ToggleLabel.TextSize = 15 -- ขนาดฟอนต์ใหญ่กดง่ายสบายตา
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.BackgroundTransparency = 1

    local Switch = Instance.new("TextButton", Card)
    Switch.Text = ""
    Switch.Size = UDim2.new(0, 44, 0, 22)
    Switch.Position = UDim2.new(1, -60, 0, yPos + 4)
    Switch.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local SwitchDot = Instance.new("Frame", Switch)
    SwitchDot.Size = UDim2.new(0, 18, 0, 18)
    SwitchDot.Position = UDim2.new(0, 2, 0, 2)
    SwitchDot.BackgroundColor3 = Color3.fromRGB(140, 145, 150)
    Instance.new("UICorner", SwitchDot)

    Switch.MouseButton1Click:Connect(function()
        _G[globalVarName] = not _G[globalVarName]
        if _G[globalVarName] then
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 200, 95)}):Play()
            TweenService:Create(SwitchDot, TweenInfo.new(0.15), {Position = UDim2.new(0, 24, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 38, 42)}):Play()
            TweenService:Create(SwitchDot, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(140, 145, 150)}):Play()
            ToggleLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
        end
    end)
end

AddPremiumToggle("Auto Click Power (เปิดระบบคลิกปั๊มพลัง)", 25, "AutoClicker")
AddPremiumToggle("Auto Farm Mobs (บินล็อกหัวตีกระหน่ำมอน)", 70, "AutoFarmMobs")

-- [ แถบเลื่อน SLIDER ADJUSTMENT - ปรับระยะความสูงฟาร์มได้จริง ]
local SliderLabel = Instance.new("TextLabel", Card)
SliderLabel.Text = "Farm Distance (ระยะห่างพิกัดล็อกหัวมอน)"
SliderLabel.Size = UDim2.new(0, 250, 0, 30)
SliderLabel.Position = UDim2.new(0, 16, 0, 125)
SliderLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
SliderLabel.Font = Enum.Font.SourceSansBold
SliderLabel.TextSize = 15
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.BackgroundTransparency = 1

local SliderValueText = Instance.new("TextLabel", Card)
SliderValueText.Text = "5"
SliderValueText.Size = UDim2.new(0, 40, 0, 30)
SliderValueText.Position = UDim2.new(1, -55, 0, 125)
SliderValueText.TextColor3 = Color3.fromRGB(0, 230, 110)
SliderValueText.Font = Enum.Font.SourceSansBold
SliderValueText.TextSize = 15
SliderValueText.TextXAlignment = Enum.TextXAlignment.Right
SliderValueText.BackgroundTransparency = 1

local SliderTrack = Instance.new("TextButton", Card)
SliderTrack.Text = ""
SliderTrack.Size = UDim2.new(1, -32, 0, 6)
SliderTrack.Position = UDim2.new(0, 16, 0, 170)
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
    _G.FarmDistance = math.floor(percentage * 15)
    SliderValueText.Text = tostring(_G.FarmDistance)
end
SliderTrack.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true updateSlider() end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider() end end)
SliderTrack.InputEnded:Connect(function(input) dragging = false end)

-- ========================================================================================================
-- [ 🔥 CORE APOCALYPSE ENGINE: เจาะระบบคลิกปั๊มพลัง และบอทล็อกเป้าของจริงแมพ Anime Apocalypse ]
-- ========================================================================================================

-- ฟังก์ชันค้นหามอนสเตอร์รอบบริเวณตามรหัสโฟลเดอร์จริงของแมพ
local function GetNearestApocalypseMob()
    local target = nil
    local shortestDistance = math.huge
    local char = game.Players.LocalPlayer.Character
    
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- เจาะระบบหาในโฟลเดอร์หลักของค่าย In0_X (มอนสเตอร์ในแมพหลักและดันเจี้ยนจะเกิดตรงนี้)
        local worldsFolder = workspace:FindFirstChild("Worlds") or workspace:FindFirstChild("ActiveMobs")
        if worldsFolder then
            for _, mob in pairs(worldsFolder:GetDescendants()) do
                if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                    return mob
                end
            end
        end
        -- ดักสแกนระบบรอบตัวกรณีหลุดแมพปกติ
        for _, v in pairs(workspace:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and v.Name ~= game.Players.LocalPlayer.Name then
                local distance = (char.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then shortestDistance = distance target = v end
            end
        end
    end
    return target
end

-- 1. ลูปที่ 1: ระบบออโต้คลิกปั๊มขุมพลังเจาะจง Remote (Auto Click Power)
task.spawn(function()
    while true do
        task.wait(0.01) -- สับความเร็วการยิง Packet ปั๊มค่าพลังรวดเร็วขั้นสุด
        if _G.AutoClicker then
            pcall(function()
                -- ยิงคำสั่งตรงเข้าเน็ตเวิร์กคลิกเกอร์ของตัวเกมสากล Bypass แอนิตี้ออโต้คลิกเกอร์นอก
                local clickRemote = ReplicatedStorage:FindFirstChild("Remotes") and (ReplicatedStorage.Remotes:FindFirstChild("ClickRemote") or ReplicatedStorage.Remotes:FindFirstChild("Click"))
                if clickRemote then
                    clickRemote:FireServer()
                else
                    -- แผนสำรองกรณี Remote หลักเข้ารหัสย้ายโฟลเดอร์ ยิงผ่านปุ่มสัมผัสเสถียร
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                end
            end)
        end
    end
end)

-- 2. ลูปที่ 2: ระบบคุมการเคลื่อนที่บินฟาร์มและสั่งโจมตีรัว (Auto Farm Level Mobs)
RunService.Stepped:Connect(function()
    if _G.AutoFarmMobs then
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            
            local targetMob = GetNearestApocalypseMob()
            if targetMonster or targetMob then
                local currentMonster = targetMob or targetMonster
                
                -- ตรึงพิกัดกลางอากาศป้องกันการร่วงตกแมพขณะบอทลอยตัวฟาร์ม
                char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                
                -- วาร์ปไปล็อกพิกัดพุ่งชน/ลอยอยู่เหนือหัวมอนสเตอร์สัมพันธ์กับแถบสไลเดอร์ Distance บนหน้าจอ UI จริง!
                char.HumanoidRootPart.CFrame = currentMonster.HumanoidRootPart.CFrame * CFrame.new(0, _G.FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                
                -- สวมอาวุธอัตโนมัติเข้ามือ
                if not char:FindFirstChildOfClass("Tool") and game.Players.LocalPlayer:FindFirstChild("Backpack") then
                    for _, t in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        if t:IsA("Tool") then char.Humanoid:EquipTool(t) break end
                    end
                end
                
                -- ยิงระบบต่อสู้ (Attack Remote) บังคับสับดาเมจเข้าเป้าหมายทันทีโดยไม่มีดีเลย์แอนิเมชันหน่วง
                local attackRemote = ReplicatedStorage:FindFirstChild("Remotes") and (ReplicatedStorage.Remotes:FindFirstChild("Attack") or ReplicatedStorage.Remotes:FindFirstChild("Damage"))
                if attackRemote then
                    attackRemote:FireServer(currentMonster)
                else
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end)
    end
end)
