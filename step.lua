-- STEPCONTROL HUB V24.0 - OFFICIAL WHITEX & FLUENT FIXED RELEASE
local player = game.Players.LocalPlayer
pcall(function() player.PlayerGui.StepControlUI:Destroy() end)

_G.StepSpeed = 16
_G.AutoJump = false
_G.NoClip = false
_G.BloxFastAttack = false
_G.BloxBringMob = false
_G.AutoSticks = false

-- [★ แก้ไขจุดพลาดจุดสำคัญ ★] ดึงฐานข้อมูล Fluent Library ผ่านลิงก์ดิบเต็มรูปแบบสากล
local Fluent = loadstring(game:HttpGet("githubusercontent.com"))()

-- สร้างหน้าต่างหลักพิกัดเกิดกลางจอภาพสไตล์กึ่งโปร่งใสสีดาร์กโหมด
local Window = Fluent:CreateWindow({
    Title = "STEPCONTROL HUB v24",
    SubTitle = "ReaperX Green Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 300),
    Acrylic = false, -- ปิดระบบเบลอหลังจอกันแอปพลิเคชันมือถือหลุดเกมชวนเด้ง
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- บังคับระบบสีกราฟิกแถบไฟวิ่งให้เป็น "สีเขียวนีออนสะท้อนแสง" คุมโทนยอดนิยม
Fluent:SetThemeColor(Color3.fromRGB(0, 255, 100))

-- สร้างหน้าแท็บสลับชิดซ้าย
local Tab1 = Window:AddTab({ Title = "⚡ Player Tools", Icon = "user" })
local TabMap = Window:AddTab({ Title = "⚔️ Map Cheats", Icon = "gamepad" })

-- 1. หน้าแท็บที่ 1: ระบบสไลเดอร์ปรับความเร็ววิ่ง
Tab1:AddSlider("WalkSpeedSlider", {
    Title = "WalkSpeed Velocity Settings",
    Description = "Adjust your character running speeds",
    Min = 16,
    Max = 120,
    Default = 16,
    Callback = function(Value)
        _G.StepSpeed = Value
    end
})

-- 2. ระบบสวิตช์เปิด-ปิด กระโดดต่อเนื่องกลางอากาศ (Infinite Jump)
Tab1:AddToggle("InfJumpToggle", {
    Title = "Infinite Jump Parameter Bypass",
    Default = false,
    Callback = function(Value)
        _G.AutoJump = Value
    end
})

-- 3. ระบบสวิตช์เปิด-ปิด เดินทะลุกำแพงหิน (No Clip)
Tab1:AddToggle("NoClipToggle", {
    Title = "No Clip Grid Mode Enabled",
    Default = false,
    Callback = function(Value)
        _G.NoClip = Value
    end
})

-- 4. หน้าแท็บที่ 2: ดักจับระบบแยกแมพอัตโนมัติ (Blox Fruits / 99 Nights)
local GamePlaceId = game.PlaceId
local IsBloxFruits = false
if GamePlaceId == 2753915549 or game.Workspace:FindFirstChild("Sea") or game.Workspace:FindFirstChild("NPCs") then
    IsBloxFruits = true
end

if IsBloxFruits then
    TabMap:AddToggle("BloxAttackToggle", {
        Title = "Auto Fast Attack Combat",
        Default = false,
        Callback = function(Value)
            _G.BloxFastAttack = Value
        end
    })
    TabMap:AddToggle("BloxBringToggle", {
        Title = "Bring Enemies / Mob Magnet",
        Default = false,
        Callback = function(Value)
            _G.BloxBringMob = Value
        end
    })
else
    TabMap:AddToggle("SticksToggle", {
        Title = "Auto Collect Forest Sticks",
        Default = false,
        Callback = function(Value)
            _G.AutoSticks = Value
        end
    })
end

-- [ระบบลูปคำนวณวิชาฟิสิกส์หลบแบนเบื้องหลัง]
local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
    pcall(function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- เร่งสปีดวิ่งด้วยวิธีสะกิดพิกัดตามเฟรมเรต
            if _G.StepSpeed > 16 and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = _G.StepSpeed
                if character.Humanoid.MoveDirection.Magnitude > 0 then
                    character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + (character.Humanoid.MoveDirection * (_G.StepSpeed / 80))
                end
            end
            -- เดินทะลุกำแพง
            if _G.NoClip then
                for _, child in pairs(character:GetChildren()) do if child:IsA("BasePart") then child.CanCollide = false end end
            end
            -- ล็อกพิกัดดูดมอนสเตอร์สูตร WhiteX Hub ระยะ 4.2 บล็อก ดาเมจเข้าชัวร์
            if IsBloxFruits and _G.BloxBringMob then
                local folder = game.Workspace:FindFirstChild("Enemies") or game.Workspace:FindFirstChild("NPCs") or game.Workspace
                for _, mob in pairs(folder:GetChildren()) do
                    if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        if (mob.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude < 180 then
                            mob.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4.2)
                            mob.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                            mob.HumanoidRootPart.Anchored = true 
                            break
                        end
                    end
                end
            end
            -- ลูปดูดกิ่งไม้ 99 คืน
            if not IsBloxFruits and _G.AutoSticks then
                for _, obj in pairs(game.Workspace:GetChildren()) do
                    if obj.Name:lower():match("stick") or obj.Name:lower():match("wood") then obj.CFrame = character.HumanoidRootPart.CFrame end
                end
            end
        end
    end)
end)

-- ระบบกระโดดต่อเนื่องลอยบนฟ้า
game:GetService("UserInputService").JumpRequest:Connect(function() 
    if _G.AutoJump then
        pcall(function() player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end 
end)

-- ระบบสับดาเมจมาโครความถี่สูงยิงรีโมทพร้อมส่งพิกัดเป้าหมายแบบ WhiteX
task.spawn(function()
    while true do
        task.wait(0.01)
        if IsBloxFruits and _G.BloxFastAttack then
            pcall(function()
                local character = player.Character
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                    local net = game:GetService("ReplicatedStorage"):FindFirstChild("CombatRegister") or game:GetService("ReplicatedStorage"):FindFirstChild("remotes")
                    if net then 
                        net:FireServer("Attack", tool, character.HumanoidRootPart.Position) 
                    end
                end
            end)
        end
    end
end)

Window:SelectTab(1)
