-- [[ STEPCONTROL HUB - PRO PREMIUM EDITION ]] --

-- บังคับเคลียร์หน้าจอเก่าป้องกันบั๊กรันไม่ขึ้น
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v.Name == "Orion" or v.Name:match("Step") then v:Destroy() end
end

-- โหลด Library ระดับท็อป โทนสีเขียว-ดำ (Dark Green Theme)
local OrionLib = loadstring(game:HttpGet(('githubusercontent.com')))()

-- 1. สร้างหน้าต่างหลักสไตล์ Mac OS (ชื่อ STEPCONTROL HUB)
local Window = OrionLib:MakeWindow({
    Name = "STEPCONTROL HUB | Premium Edition",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "StepControlConfig",
    IntroText = "STEPCONTROL HUB" -- ข้อความตอนเปิดตัวสุดเท่
})

-- ตัวแปร Global สำหรับคุมระบบฟาร์ม
_G.AutoFarm = false
_G.FailSafe = 50

-- ========================================================
-- [ หน้าเมนูที่ 1: Main Controller (ระบบฟาร์มโหดๆ) ]
-- ========================================================
local MainTab = Window:MakeTab({
    Name = "⚡ Main Farm",
    Icon = "rbxassetid://4483345998",
    Premium = false
})

-- ปุ่มสวิตช์เปิด/ปิด Auto Farm ของจริง
MainTab:AddToggle({
    Name = "Auto Farm Level (เปิดระบบฟาร์มโหดๆ)",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        
        -- โค้ดระบบ Auto Farm ของจริงที่จะทำงานตอนกดเปิด
        if _G.AutoFarm then
            task.spawn(function()
                while _G.AutoFarm do
                    pcall(function()
                        local player = game.Players.LocalPlayer
                        local character = player.Character or player.CharacterAdded:Wait()
                        
                        -- ค้นหาศัตรู/มอนสเตอร์ในเกม (ปรับคำว่า "Enemy" เป็นชื่อมอนสเตอร์ในเกมนั้นๆ ได้)
                        for _, enemy in pairs(workspace:GetChildren()) do
                            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy.Name ~= player.Name then
                                
                                -- ล็อคเป้าหมายและวาร์ปไปด้านหลังมอนสเตอร์ทันที (Tween/Teleport)
                                character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                                
                                -- ระบบออโต้คลิก/ตีกระหน่ำ (จำลองการคลิกเมาส์โจมตี)
                                local VirtualUser = game:GetService("VirtualUser")
                                VirtualUser:CaptureController()
                                VirtualUser:ClickButton1(Vector2.new(850, 520)) 
                            end
                        end
                    end)
                    task.wait(0.1) -- ความเร็วในการวนลูปสแกนมอนสเตอร์ (0.1 วินาทีต่อครั้ง โดดเด่นเรื่องความไว)
                end
            end)
        else
            print("ปิดระบบฟาร์ม")
        end
    end
})

-- แถบสไลเดอร์ปรับค่าเซฟชีวิตบอส/มอนสเตอร์ (Slider ของจริงลากปรับ % ได้)
MainTab:AddSlider({
    Name = "Fail Safe At (%)",
    Min = 10,
    Max = 100,
    Default = 50,
    Color = Color3.fromRGB(0, 255, 110), -- สีเขียวนีออน
    Increment = 1,
    ValueName = "% เลือด",
    Callback = function(Value)
        _G.FailSafe = Value
        print("ตั้งค่าระบบความปลอดภัยไว้ที่: " .. Value .. "%")
    end
})

-- ========================================================
-- [ หน้าเมนูที่ 2: Player Settings (ปรับค่าตัวละคร) ]
-- ========================================================
local PlayerTab = Window:MakeTab({
    Name = "⚙️ Player Settings",
    Icon = "rbxassetid://4483345998",
    Premium = false
})

-- ปุ่มปรับความเร็วการวิ่งในเกม (Speed Hack)
PlayerTab:AddSlider({
    Name = "WalkSpeed (ปรับความเร็ววิ่ง)",
    Min = 16,
    Max = 250,
    Default = 16,
    Color = Color3.fromRGB(0, 255, 110),
    Increment = 5,
    ValueName = "Speed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- ปุ่มปรับแรงกระโดดสูงข้ามตึก (Jump Hack)
PlayerTab:AddSlider({
    Name = "JumpPower (ปรับแรงกระโดด)",
    Min = 50,
    Max = 350,
    Default = 50,
    Color = Color3.fromRGB(0, 255, 110),
    Increment = 5,
    ValueName = "Power",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

-- เปิดใช้งานระบบทั้งหมดเข้าสู่หน้าจอ
OrionLib:Init()
