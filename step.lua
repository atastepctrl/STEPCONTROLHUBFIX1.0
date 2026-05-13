-- STEPCONTROL HUB V13.0 - WHITEX FRAMEWORK EDITION (PC & MOBILE)
pcall(function() game.Players.LocalPlayer.PlayerGui.StepControlUI:Destroy() end)

_G.StepSpeed = 16
_G.AutoJump = false
_G.NoClip = false
_G.BloxFastAttack = false
_G.BloxBringMob = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- [1. โครงหน้าต่างหลัก - พิกัดเป๊ะกลางจอ สไตล์กระจกดำขอบเขียวนีออน]
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 300)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 10) MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke") MainStroke.Thickness = 1.2 MainStroke.Color = Color3.fromRGB(0, 255, 100) MainStroke.Parent = MainFrame

-- แถบสามปุ่มบนซ้ายสไตล์ Mac (กดได้จริง)
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

CreateMacClickableDot(Color3.fromRGB(255, 95, 86), 0, function() pcall(function() ScreenGui:Destroy() end) end) -- แดง ปิดลบ
CreateMacClickableDot(Color3.fromRGB(255, 189, 46), 16, function() MainFrame.Visible = not MainFrame.Visible end) -- เหลือง ย่อ/เปิด

local GameTitle = Instance.new("TextLabel")
GameTitle.Size = UDim2.new(0, 200, 0, 30)
GameTitle.Position = UDim2.new(0, 140, 0, 5)
GameTitle.Text = "STEPCONTROL x WHITEX v13"
GameTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
GameTitle.Font = Enum.Font.GothamBold GameTitle.TextSize = 12 GameTitle.TextXAlignment = Enum.TextXAlignment.Left GameTitle.BackgroundTransparency = 1 GameTitle.Parent = MainFrame

-- [2. แถบข้างสลับหน้าแท็บ Sidebar]
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 120, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.BorderSizePixel = 0 Sidebar.ScrollBarThickness = 0 Sidebar.CanvasSize = UDim2.new(0, 0, 0, 200) Sidebar.Parent = MainFrame

local SBLine = Instance.new("Frame")
SBLine.Size = UDim2.new(0, 1, 1, 0)
SBLine.Position = UDim2.new(0, 120, 0, 0)
SBLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SBLine.BorderSizePixel = 0 SBLine.Parent = MainFrame

local function CreateSidebarTab(name, posY)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -16, 0, 28)
    Btn.Position = UDim2.new(0, 8, 0, posY)
    Btn.Text = "  " .. name
    Btn.Font = Enum.Font.GothamMedium Btn.TextSize = 10 Btn.TextXAlignment = Enum.TextXAlignment.Left Btn.Parent = Sidebar
    local BC = Instance.new("UICorner") BC.CornerRadius = UDim.new(0, 5) BC.Parent = Btn
    return Btn
end

local Tab1 = CreateSidebarTab("⚡ Player Tools", 15)
local Tab2 = CreateSidebarTab("⚔️ Blox Fruits", 50)

Tab1.BackgroundColor3 = Color3.fromRGB(0, 255, 100) Tab1.TextColor3 = Color3.fromRGB(0, 0, 0)
Tab2.BackgroundTransparency = 1 Tab2.TextColor3 = Color3.fromRGB(160, 160, 165)

-- กล่องคอนเทนเนอร์แสดงปุ่มด้านขวา
local Container1 = Instance.new("ScrollingFrame")
Container1.Size = UDim2.new(1, -135, 1, -55)
Container1.Position = UDim2.new(0, 130, 0, 50)
Container1.BackgroundTransparency = 1; Container1.BorderSizePixel = 0; Container1.ScrollBarThickness = 0; Container1.CanvasSize = UDim2.new(0, 0, 0, 300); Container1.Parent = MainFrame

local Container2 = Container1:Clone() Container2.Name = "Container2" Container2.Visible = false Container2.Parent = MainFrame

Tab1.MouseButton1Click:Connect(function()
    Container1.Visible = true Container2.Visible = false
    Tab1.BackgroundTransparency = 0 Tab1.BackgroundColor3 = Color3.fromRGB(0, 255, 100) Tab1.TextColor3 = Color3.fromRGB(0, 0, 0)
    Tab2.BackgroundTransparency = 1 Tab2.TextColor3 = Color3.fromRGB(160, 160, 165)
end)
Tab2.MouseButton1Click:Connect(function()
    Container1.Visible = false Container2.Visible = true
    Tab2.BackgroundTransparency = 0 Tab2.BackgroundColor3 = Color3.fromRGB(0, 255, 100) Tab2.TextColor3 = Color3.fromRGB(0, 0, 0)
    Tab1.BackgroundTransparency = 1 Tab1.TextColor3 = Color3.fromRGB(160, 160, 165)
end)

-- [3. ฟังก์ชันสร้างปุ่มตัวเลือกสวิตช์แบบแถวหรูหราคุมโทนเขียว-ดำ]
local function CreateReaperRowToggle(title, posY, parent, startState, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -15, 0, 40)
    Row.Position = UDim2.new(0, 0, 0, posY)
    Row.BackgroundTransparency = 1; Row.Parent = parent

    local Txt = Instance.new("TextLabel")
    Txt.Size = UDim2.new(0, 200, 1, 0)
    Txt.Text = title
    Txt.TextColor3 = Color3.fromRGB(230, 230, 230)
    Txt.Font = Enum.Font.GothamMedium Txt.TextSize = 11 Txt.TextXAlignment = Enum.TextXAlignment.Left Txt.BackgroundTransparency = 1 Txt.Parent = Row

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 32, 0, 18)
    Switch.Position = UDim2.new(1, -35, 0, 11)
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
        Knob:TweenPosition(state and UDim2.new(1, -15, 0, 3) or UDim2.new(0, 3, 0, 3), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
        callback(state)
    end)
end

-- ติดตั้งปุ่มหน้าแรก (Tools)
CreateReaperRowToggle("WalkSpeed Boost (Speed 75)", 10, Container1, false, function(v) if v then _G.StepSpeed = 75 else _G.StepSpeed = 16 end end)
CreateReaperRowToggle("Infinite Jump Bypass", 55, Container1, false, function(v) _G.AutoJump = v end)
CreateReaperRowToggle("No Clip Mode Enabled", 100, Container1, false, function(v) _G.NoClip = v end)

-- ติดตั้งปุ่มหน้าสอง (★ ดึงฟังก์ชัน WhiteX Framework มาแกะใส่สวิตช์ ★)
CreateReaperRowToggle("Auto Fast Attack Combat", 10, Container2, false, function(v) _G.BloxFastAttack = v end)
CreateReaperRowToggle("Bring Enemies / Mob Magnet", 55, Container2, false, function(v) _G.BloxBringMob = v end)

-- [4. ระบบประมวลผลความเร็วและระบบแม่เหล็กล็อกพิกัดแบบฝั่งเซิร์ฟเวอร์นับ 100%]
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

RunService.RenderStepped:Connect(function()
    pcall(function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- วิ่งเร็วเสถียรข้ามแพลตฟอร์ม
            if _G.StepSpeed > 16 and character:FindFirstChild("Humanoid") and character.Humanoid.MoveDirection.Magnitude > 0 then
                character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + (character.Humanoid.MoveDirection * (_G.StepSpeed / 80))
            end
            -- เดินทะลุกำแพง
            if _G.NoClip then
                for _, child in pairs(character:GetChildren()) do if child:IsA("BasePart") then child.CanCollide = false end end
            end
            -- [★ ระบบดูดมอนสูตรลับ WhiteX ★] ตรึงพิกัดมอนสเตอร์ค้างกลางอากาศตรงหน้า 4.2 บล็อกพอดีเป๊ะ ดาเมจเข้าชัวร์
            if _G.BloxBringMob then
                local folder = game.Workspace:FindFirstChild("Enemies") or game.Workspace:FindFirstChild("NPCs") or game.Workspace
                for _, mob in pairs(folder:GetChildren()) do
                    if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        if (mob.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude < 180 then
                            mob.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4.2)
                            mob.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                            mob.HumanoidRootPart.Anchored = true -- ล็อกตัวมอนสเตอร์ให้แข็งทื่อกันดีดกลับเซิร์ฟเวอร์
                        end
                    end
                end
            end
        end
    end)
end)

-- ลูปกระโดดต่อเนื่องสากล
game:GetService("UserInputService").JumpRequest:Connect(function() if _G.AutoJump pcall(function() game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end)

-- [★ ระบบสับดาเมจความถี่สูงข้ามอนิเมชันสูตรลับ WhiteX Hub ★]
task.spawn(function()
    while true do
        task.wait(0.01) -- เร่งความเร็วโจมตีคอมโบสูงสุดระดับ Top-Tier 
        if _G.BloxFastAttack then
            pcall(function()
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    -- สั่ง Activate อาวุธในมือกดฟัน และยิงคำสั่งดาเมจตรงเข้าเซิร์ฟเวอร์หลักไปพร้อม ๆ กัน บายพาสดาเมจระเบิดสีเหลืองเข้าเนื้อ 100%
                    tool:Activate()
                    local net = game:GetService("ReplicatedStorage"):FindFirstChild("CombatRegister") or game:GetService("ReplicatedStorage"):FindFirstChild("remotes")
                    if net then
                        net:FireServer("Attack", tool)
                    end
                end
            end)
        end
    end
end)
