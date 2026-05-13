-- [[ STEPCONTROL HUB - ANIME APOCALYPSE GOLDEN ULTIMATE EDITION ]] --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local targetParent = game:GetService("CoreGui")
if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ล้างระบบหน้าจอเก่าที่อาจจะบั๊กค้างคาจอมือถือ
if targetParent:FindFirstChild("StepControlApocalypseUltimate") then
    targetParent.StepControlApocalypseUltimate:Destroy()
end

-- ========================================================
-- [ ตัวแปรหลักคุมสมองกลการโกง ]
-- ========================================================
_G.AutoClicker = false
_G.AutoFarmMobs = false
_G.AutoCollectDrops = true -- ระบบดูดของรางวัลออโต้ (เปิดให้ตั้งแต่วิ่งสคริปต์)
_G.FarmDistance = 6        -- ระยะห่างพิกัดความปลอดภัยตั้งต้น

-- 1. ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlApocalypseUltimate"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

-- 2. Main Frame (หน้าต่างหลักโครงสร้าง Reaper X Hub โทนดำ-เขียวนีออน ขยายขนาดได้)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 13, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 1.6
MainStroke.Color = Color3.fromRGB(0, 240, 110)

-- [ ◥ ปุ่มลากปรับขนาดขวาล่างสากล รองรับตัวอักษรใหญ่ตามขนาดจอ ]
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

-- Sidebar แผงเมนูด้านซ้ายสีดำเข้ม
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0.27, 0, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(7, 8, 10)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 14)

local SidePatch = Instance.new("Frame", Sidebar)
SidePatch.Size = UDim2.new(0, 15, 1, 0)
SidePatch.Position = UDim2.new(1, -15, 0, 0)
SidePatch.BackgroundColor3 = Color3.fromRGB(7, 8, 10)

-- ปุ่มแดง Mac OS ปิดสคริปต์ลบหน่วยความจำเกลี้ยงเครื่องไม่ค้าง
local Dot = Instance.new("Frame", Sidebar)
Dot.Size = UDim2.new(0, 12, 0, 12)
Dot.Position = UDim2.new(0, 16, 0, 16)
Dot.BackgroundColor3 = Color3.fromRGB(255, 85, 80)
Instance.new("UICorner", Dot)
local ActionBtn = Instance.new("TextButton", Dot)
ActionBtn.Size = UDim2.new(1, 0, 1, 0)
ActionBtn.BackgroundTransparency = 1
ActionBtn.Text = ""
ActionBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() _G.AutoClicker = false _G.AutoFarmMobs = false end)

-- ชื่อโลโก้ตัวหนาใหญ่ปรับสเกลอัตโนมัติ (STEPCONTROL HUB)
local Brand = Instance.new("TextLabel", Sidebar)
Brand.Text = "STEPCONTROL"
Brand.Size = UDim2.new(1, -20, 0.08, 0)
Brand.Position = UDim2.new(0, 14, 0, 36)
Brand.TextColor3 = Color3.fromRGB(0, 230, 110)
Brand.Font = Enum.Font.FredokaOne
Brand.TextScaled = true
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
HeaderText.Text = "STEPCONTROL HUB | Anime Apocalypse VIP"
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

-- ฟังก์ชันคุมการสร้างสวิตช์เปิด/ปิด (TextScaled ฟอนต์หนาใหญ่ตามกรอบจอ)
local function AddPremiumToggle(labelText, yPosPercent, globalVarName)
    local ToggleLabel = Instance.new("TextLabel", Card)
    ToggleLabel.Text = labelText
    ToggleLabel.Size = UDim2.new(0.65, 0, 0.12, 0)
    ToggleLabel.Position = UDim2.new(0, 16, yPosPercent, 0)
    ToggleLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
    ToggleLabel.Font = Enum.Font.SourceSansBold
    ToggleLabel.TextScaled = true
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

AddPremiumToggle("Auto Click Power (เปิดระบบคลิกปั๊มพลัง)", 0.1, "AutoClicker")
AddPremiumToggle("Auto Farm Mobs (บินล็อกหัวตีกระหน่ำมอน)", 0.3, "AutoFarmMobs")

-- [ แถบเลื่อน SLIDER - ปรับระยะความสูงล็อกหัวมอนได้จริง ตัวอักษรใหญ่ชัดเจน ]
local SliderLabel = Instance.new("TextLabel", Card)
SliderLabel.Text = "Farm Distance (ระยะห่างพิกัดล็อกหัวมอน)"
SliderLabel.Size = UDim2.new(0.6, 0, 0.12, 0)
SliderLabel.Position = UDim2.new(0, 16, 0.5, 0)
SliderLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
SliderLabel.Font = Enum.Font.SourceSansBold
SliderLabel.TextScaled = true
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.BackgroundTransparency = 1

local SliderValueText = Instance.new("TextLabel", Card)
SliderValueText.Text = "6"
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
SliderFill.Size = UDim2.new(0.4, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 95)
Instance.new("UICorner", SliderFill)

local SliderDot = Instance.new("Frame", SliderTrack)
SliderDot.Size = UDim2.new(0.04, 0, 3, 0)
SliderDot.Position = UDim2.new(0.4, 0, -1, 0)
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
    _G.FarmDistance = math.floor(percentage * 15)
    SliderValueText.Text = tostring(_G.FarmDistance)
end
SliderTrack.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true updateSlider() end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider() end end)
SliderTrack.InputEnded:Connect(function(input) dragging = false end)

-- ========================================================================================================
-- [ 🔥 SYSTEM 5: TOTAL FIXED ENEMY FINDER (สมองกลเคลียร์บั๊ก ค้นหาและตามล่าพิกัดมอนสเตอร์สากล) ]
-- ========================================================================================================
local function GetValidApocalypseEnemy()
    local bestTarget = nil
    local closestDistance = math.huge
    local myCharacter = LocalPlayer.Character
    
    if myCharacter and myCharacter:FindFirstChild("HumanoidRootPart") then
        -- 🛠️ เคลียร์จุดบั๊กบินไม่ไป: กวาดระบบแบบสากลผ่านทุกโฟลเดอร์ซ้อน (GetDescendants) ของค่าย In0_X
        for _, object in pairs(workspace:GetDescendants()) do
            -- คัดกรองโมเดลศัตรูที่มีชิ้นส่วนเลือดและสามารถล็อก CFrame ได้จริง
            if object:IsA("Model") and object:FindFirstChild("Humanoid") and object.Humanoid.Health > 0 and object:FindFirstChild("HumanoidRootPart") then
                -- ป้องกันบั๊กล็อกเป้าตัวเอง หรือล็อก NPC ซื้อของในแผนที่ฐาน
                if object.Name ~= LocalPlayer.Name and not object:FindFirstChild("NPC") and not object.Name:match("Merchant") then
                    local targetDistance = (myCharacter.HumanoidRootPart.Position - object.HumanoidRootPart.Position).Magnitude
                    if targetDistance < closestDistance then
                        closestDistance = targetDistance
                        bestTarget = object
                    end
                end
            end
        end
    end
    return bestTarget
end

local function AutoEquipWeapon()
    local p = game.Players.LocalPlayer
    if p.Character and p:FindFirstChild("Backpack") and not p.Character:FindFirstChildOfClass("Tool") then
        for _, tool in pairs(p.Backpack:GetChildren()) do
            if tool:IsA("Tool") then p.Character.Humanoid:EquipTool(tool) break end
        end
    end
end

-- ========================================================================================================
-- [ 🔥 SYSTEM 6: HIGH-STABLE REAPER COMBAT PACKET LOOPS (ระบบยิงคำสั่งรัวคลิกและวาร์ปฟาร์มแบบเซฟตี้ 100%) ]
-- ========================================================================================================

-- ลูปที่ 1: ระบบรัวคลิกค่าขุมพลัง (Auto Click Power) ผ่านระบบเครือข่ายความเร็วคงที่
task.spawn(function()
    while true do
        task.wait(0.01) -- สับสปีดคลิกกระหน่ำระดับมิลลิวินาที
        if _G.AutoClicker then
            pcall(function()
                local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events")
                local targetRemote = remotesFolder and (remotesFolder:FindFirstChild("ClickRemote") or remotesFolder:FindFirstChild("Click") or remotesFolder:FindFirstChild("Attack"))
                if targetRemote then
                    targetRemote:FireServer()
                else
                    -- แผนสำรองระดับฮาร์ดแวร์จำลองเมาส์คลิกพื้นหลังกรณีเซิร์ฟเวอร์ย้ายชื่อโฟลเดอร์รหัสผ่าน
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                end
            end)
        end
    end
end)

-- ลูปที่ 2: ระบบคุมการเคลื่อนที่บินวาร์ป และรัวดาเมจดาบฟันมอนสเตอร์ (เสถียร ไม่เด้งบน Delta)
RunService.Stepped:Connect(function()
    if _G.AutoFarmMobs then
        pcall(function()
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            
            -- ปลดล็อกดึงขุมพลังสมองกลคำสั่งแกะรอยเชิงลึกมาล็อกพิกัดมอนสเตอร์ทันที
            local currentTarget = GetValidApocalypseEnemy()
            if currentTarget then
                -- ตรึงพิกัดแรงโน้มถ่วงป้องกันระบบแอนิตี้ดักจับการร่วงหลุดแผนที่ขณะบอทบิน
                character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                
                -- [[ ระบบการบินของจริง 700 บาท ]] : ล็อกพิกัดตัวเราให้พุ่งวาร์ปไปอยู่เหนือหัวมอนสเตอร์สัมพันธ์ตามระยะจริงจาก Slider UI!
                character.HumanoidRootPart.CFrame = currentTarget.HumanoidRootPart.CFrame * CFrame.new(0, _G.FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                
                -- บังคับถืออาวุธและสับความเร็วคลิกโจมตีเข้าตัวมอนสเตอร์ทันที
                AutoEquipWeapon()
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then 
                    tool:Activate() -- ชกต่อยฟันสร้างดาเมจจริงคาจอ
                end
                
                -- [[ ระบบออโต้เก็บของดรอปรางวัลรางวัล (Auto Collect Drops) ]]
                local drops = workspace:FindFirstChild("Drops") or workspace:FindFirstChild("DroppedItems")
                if drops then
                    for _, dropItem in pairs(drops:GetChildren()) do
                        if dropItem:IsA("BasePart") then
                            dropItem.CFrame = character.HumanoidRootPart.CFrame
                        end
                    end
                end
            end
        end)
    end
end)
