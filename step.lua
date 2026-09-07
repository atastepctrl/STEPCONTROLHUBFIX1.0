--[[
    🔥 STEPCONTROL X HUB 🔥
    Murder Mystery 2 Script
    พัฒนาต่อยอดจาก Open Source โดย ScripterMrbacon
    ฟีเจอร์: ESP, Aimbot, Godmode, Fling, Teleport, Auto Grab Gun
]]

-- ============================================
-- 📦 SERVICES
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
local RootPart = Humanoid and Humanoid.RootPart or Character:FindFirstChild("HumanoidRootPart")

-- ============================================
-- ⚙️ CONFIG
-- ============================================

local STEPCONTROL = {
    ESP = {
        Enabled = false,
        ShowRole = true,
        ShowName = true,
    },
    Aimbot = {
        Enabled = false,
        Silent = true,
        Smoothness = 0.5,
    },
    AutoGrab = {
        Gun = false,
        Knife = false,
    },
    Godmode = false,
    Noclip = false,
    Fly = false,
    Speed = 16,
    JumpPower = 50,
    InfinityJump = false,
    Fling = {
        Enabled = false,
        Power = 500,
    },
    Teleport = {
        ToMap = false,
        ToLobby = false,
    },
}

-- ============================================
-- 🎨 GUI
-- ============================================

local function CreateGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "STEPCONTROL_X_HUB"
    screenGui.Parent = game:GetService("CoreGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 380, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -190, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    title.BackgroundTransparency = 0.2
    title.Text = "🔥 STEPCONTROL X HUB"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = mainFrame
    
    -- Scroll Frame
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, -40)
    scroll.Position = UDim2.new(0, 0, 0, 40)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
    scroll.ScrollBarThickness = 4
    scroll.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = scroll
    
    local function AddToggle(text, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 30)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        frame.BackgroundTransparency = 0.3
        frame.Parent = scroll
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.8, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.15, 0, 1, -4)
        btn.Position = UDim2.new(0.85, 0, 0, 2)
        btn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        btn.Text = default and "ON" or "OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Parent = frame
        
        local value = default
        btn.MouseButton1Click:Connect(function()
            value = not value
            btn.BackgroundColor3 = value and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
            btn.Text = value and "ON" or "OFF"
            callback(value)
        end)
    end
    
    local function AddSlider(text, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 40)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        frame.BackgroundTransparency = 0.3
        frame.Parent = scroll
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 12
        label.Parent = frame
        
        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(1, 0, 0, 10)
        slider.Position = UDim2.new(0, 0, 0, 22)
        slider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        slider.Parent = frame
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        fill.Parent = slider
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0.15, 0, 1, 0)
        valueLabel.Position = UDim2.new(0.85, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 10
        valueLabel.Parent = frame
        
        local currentValue = default
        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local pos = input.Position.X - slider.AbsolutePosition.X
                local percent = math.clamp(pos / slider.AbsoluteSize.X, 0, 1)
                currentValue = min + (max - min) * percent
                fill.Size = UDim2.new(percent, 0, 1, 0)
                valueLabel.Text = tostring(math.round(currentValue))
                callback(currentValue)
            end
        end)
    end
    
    -- ============================================
    -- 🔥 สร้างเมนู
    -- ============================================
    
    AddToggle("🔴 ESP Player", false, function(v) STEPCONTROL.ESP.Enabled = v end)
    AddToggle("🎯 Aimbot", false, function(v) STEPCONTROL.Aimbot.Enabled = v end)
    AddToggle("🛡️ Godmode", false, function(v) STEPCONTROL.Godmode = v end)
    AddToggle("🚪 Noclip", false, function(v) STEPCONTROL.Noclip = v end)
    AddToggle("🦅 Fly", false, function(v) STEPCONTROL.Fly = v end)
    AddToggle("🔄 Infinity Jump", false, function(v) STEPCONTROL.InfinityJump = v end)
    AddToggle("🔫 Auto Grab Gun", false, function(v) STEPCONTROL.AutoGrab.Gun = v end)
    AddToggle("💥 Fling", false, function(v) STEPCONTROL.Fling.Enabled = v end)
    
    AddSlider("⚡ WalkSpeed", 16, 350, 16, function(v) STEPCONTROL.Speed = v end)
    AddSlider("🦘 JumpPower", 50, 500, 50, function(v) STEPCONTROL.JumpPower = v end)
    AddSlider("💥 Fling Power", 100, 1000, 500, function(v) STEPCONTROL.Fling.Power = v end)
    
    print("✅ STEPCONTROL X HUB LOADED!")
end

-- ============================================
-- 🔥 ฟังก์ชันหลัก
-- ============================================

-- ESP
local function UpdateESP()
    while STEPCONTROL.ESP.Enabled do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local esp = head:FindFirstChild("ESP")
                    if not esp then
                        esp = Instance.new("BillboardGui")
                        esp.Name = "ESP"
                        esp.Size = UDim2.new(0, 200, 0, 50)
                        esp.AlwaysOnTop = true
                        esp.Parent = head
                        
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = player.Name
                        label.TextColor3 = Color3.fromRGB(255, 0, 0)
                        label.TextScaled = true
                        label.Parent = esp
                    end
                end
            end
        end
        task.wait(0.2)
    end
end

-- Aimbot
local function AimbotLoop()
    while STEPCONTROL.Aimbot.Enabled do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then
            local target = nil
            local minDist = math.huge
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.Head.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if dist < minDist then
                            minDist = dist
                            target = player
                        end
                    end
                end
            end
            
            if target then
                workspace.CurrentCamera.CFrame = CFrame.lookAt(
                    workspace.CurrentCamera.CFrame.Position,
                    target.Character.Head.Position
                )
            end
        end
        task.wait(0.05)
    end
end

-- Godmode
local function GodmodeLoop()
    while STEPCONTROL.Godmode do
        if Humanoid and Humanoid.Health < Humanoid.MaxHealth then
            Humanoid.Health = Humanoid.MaxHealth
        end
        task.wait(0.1)
    end
end

-- Noclip
local function NoclipLoop()
    while STEPCONTROL.Noclip do
        if Character then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        task.wait()
    end
end

-- Fly
local flyBody = nil
local function FlyLoop()
    while STEPCONTROL.Fly do
        if not flyBody and RootPart then
            flyBody = Instance.new("BodyVelocity")
            flyBody.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            flyBody.Parent = RootPart
        end
        if flyBody then
            local direction = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0, 1, 0) end
            
            flyBody.Velocity = direction * 50
        end
        task.wait(0.05)
    end
    if flyBody then flyBody:Destroy() flyBody = nil end
end

-- Auto Grab Gun
local function AutoGrabLoop()
    while STEPCONTROL.AutoGrab.Gun do
        local gun = Workspace:FindFirstChild("GunDrop", true)
        if gun and RootPart then
            if firetouchinterest then
                firetouchinterest(RootPart, gun, 0)
                firetouchinterest(RootPart, gun, 1)
            else
                gun.CFrame = RootPart.CFrame
            end
        end
        task.wait(0.1)
    end
end

-- Fling
local function FlingLoop()
    while STEPCONTROL.Fling.Enabled do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = player.Character.HumanoidRootPart
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Velocity = (targetRoot.Position - RootPart.Position).Unit * STEPCONTROL.Fling.Power
                bv.Parent = targetRoot
                task.wait(0.1)
                bv:Destroy()
            end
        end
        task.wait(0.5)
    end
end

-- Infinity Jump
UserInputService.JumpRequest:Connect(function()
    if STEPCONTROL.InfinityJump and Humanoid then
        Humanoid:ChangeState("Jumping")
    end
end)

-- Walkspeed & JumpPower
RunService.Heartbeat:Connect(function()
    if Humanoid then
        if Humanoid.WalkSpeed ~= STEPCONTROL.Speed then
            Humanoid.WalkSpeed = STEPCONTROL.Speed
        end
        if Humanoid.JumpPower ~= STEPCONTROL.JumpPower then
            Humanoid.JumpPower = STEPCONTROL.JumpPower
        end
    end
end)

-- ============================================
-- 🚀 เริ่มทำงาน
-- ============================================

CreateGUI()

-- เริ่ม Loop ทั้งหมด
task.spawn(UpdateESP)
task.spawn(AimbotLoop)
task.spawn(GodmodeLoop)
task.spawn(NoclipLoop)
task.spawn(FlyLoop)
task.spawn(AutoGrabLoop)
task.spawn(FlingLoop)

print("=" .. string.rep("=", 55))
print("🔥 STEPCONTROL X HUB 🔥")
print("📋 Murder Mystery 2 Script")
print("⚔️ พร้อมใช้งาน!")
print("=" .. string.rep("=", 55))
