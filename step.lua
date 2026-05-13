-- STEPCONTROL HUB V8.0 - KAVO ENGINE MOBILE VERSION
_G.StepSpeed = 16
_G.AutoJump = false
_G.NoClip = false
_G.AutoClick = false

-- เรียกใช้งาน Kavo Library ตัวท็อปที่ Delta ยอมรับ (รันขึ้นแน่นอน 100%)
local Library = loadstring(game:HttpGet("githubusercontent.com"))()
local Window = Library.CreateLib("STEPCONTROL HUB V8.0", "DarkTheme") -- ตั้งธีมมืดดุดัน

-- สร้างแท็บเมนูฝั่งซ้าย
local Tab1 = Window:NewTab("⚡ Player Tools")
local Tab2 = Window:NewTab("🌀 Miscellaneous")
local Tab3 = Window:NewTab("⚔️ Map Specific")

-- สร้างหมวดหมู่ด้านขวา
local Section1 = Tab1:NewSection("Character Mod")
local Section2 = Tab2:NewSection("Automation")
local Section3 = Tab3:NewSection("Game Cheats")

-- 1. แท็บที่ 1: ระบบปรับความเร็ววิ่งแบบสไลเดอร์ (ลากปรับเองได้ 16 - 150)
Section1:NewSlider("WalkSpeed Velocity", "Adjust your character move speed", 150, 16, function(s)
    _G.StepSpeed = s
end)

-- 2. ระบบเปิด-ปิด กระโดดต่อเนื่อง (Infinite Jump)
Section1:NewToggle("Infinite Jump Bypass", "Hold space to float", function(state)
    _G.AutoJump = state
end)

-- 3. ระบบเปิด-ปิด เดินทะลุกำแพง (No Clip)
Section1:NewToggle("No Clip Mode Enabled", "Walk through all objects", function(state)
    _G.NoClip = state
end)

-- 4. แท็บที่ 2: ระบบออโต้คลิกเกอร์ตีรัว
Section2:NewToggle("Auto Clicker Macro", "Click 20 times per second", function(state)
    _G.AutoClick = state
end)

-- 5. แท็บที่ 3: ระบบโกงแยกแมพ (ตรวจจับอัตโนมัติ)
local GamePlaceId = game.PlaceId
if GamePlaceId == 2753915549 or game.Workspace:FindFirstChild("Sea") then
    -- ฟังก์ชัน Blox Fruits
    _G.BloxBringMob = false
    _G.BloxFastAttack = false
    
    Section3:NewToggle("Auto Fast Attack Combat", "Speed attack combo", function(state)
        _G.BloxFastAttack = state
    end)
    Section3:NewToggle("Bring Enemies / Mob Magnet", "Drag enemies to front", function(state)
        _G.BloxBringMob = state
    end)
else
    -- ฟังก์ชัน 99 Nights
    _G.AutoSticks = false
    Section3:NewToggle("Auto Collect Sticks", "Teleport sticks to you", function(state)
        _G.AutoSticks = state
    end)
end

-- [ระบบลูปควบคุมฟิสิกส์แกนหลักหลบการแบนบนมือถือ]
local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
    pcall(function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- เร่งสปีดวิ่งด้วยแรงผลักเฟรมเรต หลบระบบตรวจจับแบน WalkSpeed
            if _G.StepSpeed > 16 and character:FindFirstChild("Humanoid") then
                character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + (character.Humanoid.MoveDirection * (_G.StepSpeed / 75))
            end
            
            -- บายพาสเดินทะลุกำแพง
            if _G.NoClip then
                for _, child in pairs(character:GetChildren()) do if child:IsA("BasePart") then child.CanCollide = false end end
            end
            
            -- บายพาสดูดมอนสเตอร์ Blox Fruits
            if _G.BloxBringMob then
                local folder = game.Workspace:FindFirstChild("Enemies") or game.Workspace:FindFirstChild("NPCs") or game.Workspace
                for _, mob in pairs(folder:GetChildren()) do
                    if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        if (mob.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude < 180 then
                            mob.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
                        end
                    end
                end
            end
            
            -- บายพาสดูดกิ่งไม้ 99 Nights
            if _G.AutoSticks then
                for _, obj in pairs(game.Workspace:GetChildren()) do
                    if obj.Name:lower():match("stick") or obj.Name:lower():match("wood") then
                        obj.CFrame = character.HumanoidRootPart.CFrame
                    end
                end
            end
        end
    end)
end)

-- ระบบกระโดดต่อเนื่อง
game:GetService("UserInputService").JumpRequest:Connect(function() if _G.AutoJump pcall(function() game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end)

-- ระบบออโต้คลิก/ตีรัว
task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    while true do
        task.wait(0.04)
        if _G.AutoClick or _G.BloxFastAttack then pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton1(Vector2.new(0, 0)) end) end
    end
end)
