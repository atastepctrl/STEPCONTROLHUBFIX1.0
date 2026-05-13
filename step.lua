-- STEPCONTROL HUB V26.1 - PRODUCTION KAVO VERSION (REAPERX THEME FIXED)
_G.StepSpeed = 16
_G.AutoJump = false
_G.NoClip = false
_G.BloxFastAttack = false
_G.BloxBringMob = false
_G.AutoSticks = false

-- [★ แก้ไขจุดพังจุดสำคัญ ★] ดึงคลังฐานข้อมูลหน้าจอ Kavo Library ผ่านลิงก์สากลตัวจริงที่เสถียรที่สุด
local Library = loadstring(game:HttpGet("githubusercontent.com"))()

-- สร้างหน้าต่างหลักคุมโทนสีเทาดำดุดันสไตล์มินิมอลตัดเขียวนีออน
local Window = Library.CreateLib("★ STEPCONTROL HUB v26 ★", "GreenTheme")

-- สร้างหน้าแท็บสลับฝั่งซ้ายสไตล์ ReaperX
local Tab1 = Window:NewTab("⚡ Player Tools")
local Tab2 = Window:NewTab("⚔️ Map Cheats")

local Section1 = Tab1:NewSection("Character Parameters")
local SectionMap = Tab2:NewSection("Automation Farm Engine")

-- 1. แท็บที่ 1: ระบบสไลเดอร์ปรับความเร็ววิ่ง
Section1:NewSlider("WalkSpeed Velocity", "Adjust your character running speeds", 120, 16, function(s)
    _G.StepSpeed = s
end)

-- 2. ระบบสวิตช์เปิด-ปิด กระโดดต่อเนื่องกลางอากาศ (Infinite Jump)
Section1:NewToggle("Infinite Jump Bypass", "Bypass jumping limits values", function(state)
    _G.AutoJump = state
end)

-- 3. ระบบสวิตช์เปิด-ปิด เดินทะลุกำแพงและสิ่งกีดขวาง (No Clip)
Section1:NewToggle("No Clip Mode Enabled", "Walk through all solids objects", function(state)
    _G.NoClip = state
end)

-- 4. แท็บที่ 2: ระบบสวิตช์ฟาร์มเลเวลโกงตามแมพ
local GamePlaceId = game.PlaceId
local IsBloxFruits = false
if GamePlaceId == 2753915549 or game.Workspace:FindFirstChild("Sea") or game.Workspace:FindFirstChild("NPCs") then
    IsBloxFruits = true
end

if IsBloxFruits then
    SectionMap:NewToggle("Auto Fast Attack Combat", "No animation auto attack targets", function(state)
        _G.BloxFastAttack = state
    end)
    SectionMap:NewToggle("Bring Enemies / Mob Magnet", "Locks positions 4.2 studs above enemies", function(state)
        _G.BloxBringMob = state
    end)
else
    SectionMap:NewToggle("Auto Collect Forest Sticks", "Teleports field sticks to your spot", function(state)
        _G.AutoSticks = state
    end)
end

-- [ระบบลูปควบคุมวิชาฟิสิกส์หลบตัวตรวจจับแบนหลังบ้าน]
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

RunService.RenderStepped:Connect(function()
    pcall(function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- เร่งสปีดความเร็ววิ่งเฟรมเรต
            if _G.StepSpeed > 16 and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = _G.StepSpeed
                if character.Humanoid.MoveDirection.Magnitude > 0 then
                    character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + (character.Humanoid.MoveDirection * (_G.StepSpeed / 80))
                end
            end
            -- ลูปเดินทะลุกำแพง
            if _G.NoClip then
                for _, child in pairs(character:GetChildren()) do if child:IsA("BasePart") then child.CanCollide = false end end
            end
            -- ลูปฟาร์มระยะคลาสสิก Blox Fruits 4.2 บล็อก 
            if IsBloxFruits and _G.BloxBringMob then
                local folder = game.Workspace:FindFirstChild("Enemies") or game.Workspace:FindFirstChild("NPCs") or game.Workspace
                for _, mob in pairs(folder:GetChildren()) do
                    if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        if (mob.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude < 180 then
                            character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 4.2, 0)
                            character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                            mob.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                            break
                        end
                    end
                end
            end
            -- ลูปดูดของ 99 คืน
            if not IsBloxFruits and _G.AutoSticks then
                for _, obj in pairs(game.Workspace:GetChildren()) do
                    if obj.Name:lower():match("stick") or obj.Name:lower():match("wood") then obj.CFrame = character.HumanoidRootPart.CFrame end
                end
            end
        end
    end)
end)

-- สัญญาณกระโดดต่อเนื่องกลางอากาศฝั่งโทรศัพท์มือถือ
game:GetService("UserInputService").JumpRequest:Connect(function() 
    if _G.AutoJump then 
        pcall(function() player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) 
    end 
end)

-- ระบบสับดาเมจมาโครความถี่สูง
task.spawn(function()
    while true do
        task.wait(0.04)
        if IsBloxFruits and _G.BloxFastAttack then
            pcall(function()
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                    local net = game:GetService("ReplicatedStorage"):FindFirstChild("CombatRegister") or game:GetService("ReplicatedStorage"):FindFirstChild("remotes")
                    if net then 
                        net:FireServer("Attack", tool, player.Character.HumanoidRootPart.Position) 
                    end
                end
            end)
        end
    end
end)
