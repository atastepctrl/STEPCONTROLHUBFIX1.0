-- [[ STEPCONTROL HUB - RAYFIELD PRO PLATFORM (FIXED DIRECT LINK) ]] --

-- ใช้ลิงก์ดิบสายตรงดึงโค้ดสถาปัตยกรรม 6,000 บรรทัดผ่าน GitHub ป้องกัน Delta แปลง URL พัง
local Rayfield = loadstring(game:HttpGet('githubusercontent.com'))()

-- สร้างหน้าต่างโปรหลักสไตล์ Cyberpunk ดำ-เขียวนีออน ตัวหนังสือใหญ่คมชัดอัตโนมัติ
local Window = Rayfield:CreateWindow({
   Name = "STEPCONTROL HUB | Blox Fruits VIP",
   LoadingTitle = "STEPCONTROL HUB",
   LoadingSubtitle = "by Premium Client",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "StepControlData", -- ระบบออโต้เซฟปุ่มกดในเครื่อง
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false -- ปิดระบบคีย์ตามสั่งเปิดใช้งานได้ทันที
})

-- ตัวแปรควบคุมระบบฟาร์มจริง
_G.AutoFarm = false
_G.FarmDistance = 5

-- สร้างแท็บเมนูด้านซ้าย (Sidebar Tabs)
local MainTab = Window:CreateTab("⚡ Main Farm", 4483363487)

-- สร้างปุ่มสวิตช์เปิด/ปิดฟาร์มของจริง (Toggle)
MainTab:CreateToggle({
   Name = "Auto Farm Level (ระบบบอทเก็บเวลของจริง)",
   CurrentValue = false,
   Flag = "ToggleFarm", 
   Callback = function(Value)
      _G.AutoFarm = Value
      
      if _G.AutoFarm then
         task.spawn(function()
            while _G.AutoFarm do
               task.wait(0.1)
               pcall(function()
                  local p = game.Players.LocalPlayer
                  local char = p.Character
                  if char and char:FindFirstChild("HumanoidRootPart") then
                     
                     -- ค้นหามอนสเตอร์ที่เกิดในแมพ
                     for _, v in pairs(workspace:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and (v.Name:match("Bandit") or v.Name:match("Monkey") or v:AttributeExists("Enemy")) then
                           
                           -- ล็อกพิกัดกลางอากาศตามระยะห่างที่ปรับจาก Slider
                           char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                           char.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, _G.FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                           
                           -- บังคับถืออาวุธและสั่งตีกระหน่ำผ่านคลิกจำลองระบบสัมผัส (Bypass Protection)
                           if not char:FindFirstChildOfClass("Tool") and p:FindFirstChild("Backpack") then
                              for _, tool in pairs(p.Backpack:GetChildren()) do
                                 if tool:IsA("Tool") then char.Humanoid:EquipTool(tool) break end
                              end
                           end
                           
                           local tool = char:FindFirstChildOfClass("Tool")
                           if tool then tool:Activate() end
                           game:GetService("VirtualUser"):CaptureController()
                           game:GetService("VirtualUser"):Button1Down(Vector2.new(1,1))
                           break
                        end
                     end
                  end
               end)
            end
         end)
      end
   end,
})

-- สร้างแถบเลื่อนปรับระยะห่างของจริง (Slider)
MainTab:CreateSlider({
   Name = "Farm Distance Adjust (ปรับระยะห่างตัวละคร)",
   Min = 0,
   Max = 15,
   DefaultValue = 5,
   Increment = 1,
   ValueName = "Distance",
   Flag = "SliderDistance", 
   Callback = function(Value)
      _G.FarmDistance = Value
   end,
})
