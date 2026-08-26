-- =============================================================================
-- STEPCONTROL HUB - OFFICIAL REAPER X MAC HYBRID INTERFACE
-- DEVELOPED FOR: STEAL AN EGG (MOBILE OPTIMIZED)
-- =============================================================================

if game.CoreGui:FindFirstChild("StepControlHub") then
    game.CoreGui.StepControlHub:Destroy()
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenInfoSmooth = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- สร้างหน้าต่างหลัก (ScreenGui & MainFrame)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 13)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -230)
MainFrame.Size = UDim2.new(0, 680, 0, 460)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- ==================== 0. ระบบปุ่มลอยน้ำวงกลมเมื่อย่อสคริปต์ ====================
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinimizeButton"
MinBtn.Parent = ScreenGui
MinBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
MinBtn.Size = UDim2.new(0, 48, 0, 48)
MinBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
MinBtn.Text = "SC"
MinBtn.TextColor3 = Color3.fromRGB(255, 204, 0)
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.Visible = false
MinBtn.Active = true
MinBtn.Draggable = true

Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)
local MinStroke = Instance.new("UIStroke", MinBtn)
MinStroke.Color = Color3.fromRGB(255, 204, 0)
MinStroke.Thickness = 1.5

-- ==================== 1. ระบบปุ่มไฟจราจร 3 สี สไตล์ MAC (ด้านบนซ้าย) ====================
local MacBar = Instance.new("Frame")
MacBar.Name = "MacBar"
MacBar.Parent = MainFrame
MacBar.Size = UDim2.new(0, 160, 0, 35)
MacBar.BackgroundTransparency = 1

local function CreateMacCircle(color, xPos, callback)
    local CircleBtn = Instance.new("TextButton")
    CircleBtn.Parent = MacBar
    CircleBtn.Position = UDim2.new(0, xPos, 0.5, -6)
    CircleBtn.Size = UDim2.new(0, 12, 0, 12)
    CircleBtn.BackgroundColor3 = color
    CircleBtn.Text = ""
    Instance.new("UICorner", CircleBtn).CornerRadius = UDim.new(1, 0)
    CircleBtn.Activated:Connect(callback)
    return CircleBtn
end

-- 🔴 ปุ่มสีแดง: ปิดทำลายสคริปต์ทิ้งทันที
CreateMacCircle(Color3.fromRGB(255, 95, 87), 16, function()
    _G.MasterSteal = false; _G.MasterJoin = false; _G.MasterHatch = false; _G.MasterUpgrade = false
    TweenService:Create(MainFrame, TweenInfoSmooth, {Size = UDim2.fromOffset(0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}):Play()
    task.wait(0.25)
    ScreenGui:Destroy()
end)

-- 🟡 ปุ่มสีเหลือง: ย่อหน้าต่างใหญ่กลายเป็นปุ่มลอยน้ำวงกลมสมูทๆ
CreateMacCircle(Color3.fromRGB(254, 188, 46), 34, function()
    TweenService:Create(MainFrame, TweenInfoSmooth, {Size = UDim2.fromOffset(0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}):Play()
    task.wait(0.2)
    MainFrame.Visible = false
    MinBtn.Size = UDim2.fromOffset(0, 0)
    MinBtn.Visible = true
    TweenService:Create(MinBtn, TweenInfoSmooth, {Size = UDim2.fromOffset(48, 48)}):Play()
end)

-- ลอจิกเวลากดปุ่มลอยน้ำกลับมาเปิดหน้าใหญ่
MinBtn.Activated:Connect(function()
    local TweenMin = TweenService:Create(MinBtn, TweenInfoSmooth, {Size = UDim2.fromOffset(0, 0)})
    TweenMin:Play()
    TweenMin.Completed:Wait()
    MinBtn.Visible = false
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfoSmooth, {Size = UDim2.fromOffset(680, 460), Position = UDim2.new(0.5, -340, 0.5, -230), BackgroundTransparency = 0}):Play()
end)

-- 🟢 ปุ่มสีเขียว: ขยายหน้าต่างเพื่อดูบอร์ดเสริมหลังบ้าน
local isExpanded = false
CreateMacCircle(Color3.fromRGB(40, 200, 64), 52, function()
    isExpanded = not isExpanded
    if isExpanded then
        TweenService:Create(MainFrame, TweenInfoSmooth, {Size = UDim2.fromOffset(850, 460)}):Play()
    else
        TweenService:Create(MainFrame, TweenInfoSmooth, {Size = UDim2.fromOffset(680, 460)}):Play()
    end
end)

-- ==================== 2. SIDEBAR แถบเลือกเมนูฝั่งซ้าย ====================
local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Parent = MainFrame
SideBar.Position = UDim2.new(0, 0, 0, 35)
SideBar.Size = UDim2.new(0, 160, 1, -35)
SideBar.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 8)

local TabButtons = {}
local TabPages = {}

local function CreateCategoryLabel(text, yPos)
    local Label = Instance.new("TextLabel")
    Label.Parent = SideBar
    Label.Position = UDim2.new(0, 12, 0, yPos)
    Label.Size = UDim2.new(0, 130, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(90, 90, 95)
    Label.TextSize = 11
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
end

local function AddTab(id, text, yPos)
    local Page = Instance.new("Frame")
    Page.Name = id .. "Page"
    Page.Parent = MainFrame
    Page.Position = UDim2.new(0, 175, 0, 15)
    Page.Size = UDim2.new(0, 490, 0, 430)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    TabPages[id] = Page

    local LeftCol = Instance.new("Frame", Page)
    LeftCol.Name = "LeftCol"
    LeftCol.Size = UDim2.new(0, 240, 1, 0)
    LeftCol.BackgroundTransparency = 1
    
    local RightCol = Instance.new("Frame", Page)
    RightCol.Name = "RightCol"
    RightCol.Position = UDim2.new(0, 250, 0, 0)
    RightCol.Size = UDim2.new(0, 240, 1, 0)
    RightCol.BackgroundTransparency = 1

    local Btn = Instance.new("TextButton")
    Btn.Parent = SideBar
    Btn.Position = UDim2.new(0, 10, 0, yPos)
    Btn.Size = UDim2.new(0, 140, 0, 32)
    Btn.Text = "     " .. text
    Btn.TextSize = 13
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.TextColor3 = Color3.fromRGB(140, 140, 145)
    Btn.BackgroundTransparency = 1
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    TabButtons[id] = Btn

    Btn.Activated:Connect(function()
        for k, p in pairs(TabPages) do p.Visible = false end
        for k, b in pairs(TabButtons) do 
            TweenService:Create(b, TweenInfoSmooth, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(140, 140, 145)}):Play()
        end
        Page.Visible = true
        TweenService:Create(Btn, TweenInfoSmooth, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(28, 24, 15), TextColor3 = Color3.fromRGB(255, 204, 0)}):Play()
    end)

    return LeftCol, RightCol
end

CreateCategoryLabel("General", 15)
local AJ_Left, AJ_Right = AddTab("AutoJoin", "Auto Join", 35)

CreateCategoryLabel("Game Exploit", 75)
local FS_Left, FS_Right = AddTab("FarmSteal", "Farm & Steal", 95)

CreateCategoryLabel("Utilities", 135)
local UT_Left, UT_Right = AddTab("Utilities", "Utilities", 155)
local ST_Left, ST_Right = AddTab("Settings", "Settings", 190)

-- ==================== 3. SYSTEM COMPONENTS (การ์ด, สวิตช์, สไลเดอร์) ====================
local function CreateReaperCard(parent, title, subtitle, yPos, height, globalMasterVar)
    local Card = Instance.new("Frame", parent)
    Card.Position = UDim2.new(0, 0, 0, yPos)
    Card.Size = UDim2.new(1, 0, 0, height)
    Card.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)
    
    local TitleLabel = Instance.new("TextLabel", Card)
    TitleLabel.Position = UDim2.new(0, 12, 0, 12)
    TitleLabel.Size = UDim2.new(0, 150, 0, 14)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
    TitleLabel.TextSize = 13
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SubLabel = Instance.new("TextLabel", Card)
    SubLabel.Position = UDim2.new(0, 12, 0, 26)
    SubLabel.Size = UDim2.new(0, 150, 0, 12)
    SubLabel.BackgroundTransparency = 1
    SubLabel.Text = subtitle
    SubLabel.TextColor3 = Color3.fromRGB(110, 110, 115)
    SubLabel.TextSize = 10
    SubLabel.Font = Enum.Font.SourceSans
    SubLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleBtn = Instance.new("TextButton", Card)
    ToggleBtn.Position = UDim2.new(1, -38, 0, 14)
    ToggleBtn.Size = UDim2.new(0, 26, 0, 14)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    ToggleBtn.Text = ""
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    
    local Circle = Instance.new("Frame", ToggleBtn)
    Circle.Size = UDim2.new(0, 10, 0, 10)
    Circle.Position = UDim2.new(0, 2, 0.5, -5)
    Circle.BackgroundColor3 = Color3.fromRGB(180, 180, 185)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    
    _G[globalMasterVar] = false
    ToggleBtn.Activated:Connect(function()
        _G[globalMasterVar] = not _G[globalMasterVar]
        if _G[globalMasterVar] then
            TweenService:Create(ToggleBtn, TweenInfoSmooth, {BackgroundColor3 = Color3.fromRGB(255, 204, 0)}):Play()
            TweenService:Create(Circle, TweenInfoSmooth, {Position = UDim2.new(1, -12, 0.5, -5), BackgroundColor3 = Color3.fromRGB(15, 15, 17)}):Play()
        else
            TweenService:Create(ToggleBtn, TweenInfoSmooth, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
            TweenService:Create(Circle, TweenInfoSmooth, {Position = UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = Color3.fromRGB(180, 180, 185)}):Play()
        end
    end)
-- ==================== ประกอบเนื้อหาลงแต่ละหน้าแท็บ ====================

-- หน้าที่ 2: แท็บ Farm & Steal (แยกคอลัมน์ซ้าย-ขวา)
local Card2 = CreateReaperCard(FS_Left, "Egg Farm", "Steal An Egg configuration", 0, 110, "MasterSteal")
AddCheckbox(Card2, "Auto Steal Eggs", 48, "StealEggVar")
AddCheckbox(Card2, "Teleport To Base", 74, "TeleportBaseVar")

local Card3 = CreateReaperCard(FS_Right, "Hatch System", "Automatic Hatch Configuration", 0, 110, "MasterHatch")
AddCheckbox(Card3, "Auto Hatch Normal", 48, "HatchNormalVar")
AddCheckbox(Card3, "Auto Equip Best", 74, "EquipBestVar")

-- หน้าที่ 3: แท็บ Utilities
local Card4 = CreateReaperCard(UtilL, "Base Upgrades", "Treadmill and Rank Configuration", 0, 110, "MasterUpgrade")
AddCheckbox(Card4, "Auto Train Speed", 48, "TrainSpeedVar")
AddCheckbox(Card4, "Auto Rebirth", 74, "RebirthVar")

-- บังคับเปิดหน้าแรกเป็นค่าเริ่มต้นตอนรันสคริปต์
TabPages["AutoJoin"].Visible = true
TabButtons["AutoJoin"].BackgroundTransparency = 0
TabButtons["AutoJoin"].BackgroundColor3 = Color3.fromRGB(28, 24, 15)
TabButtons["AutoJoin"].TextColor3 = Color3.fromRGB(255, 204, 0)


-- ==================== 5. ระบบฟาร์มหลังบ้าน (SCRIPT LOGIC) ====================

-- ฟังก์ชันจัดการวาร์ปตัวละครแบบสมูทกันระบบแบน (Tween Teleport)
local function SmoothTeleport(targetPart)
    if not targetPart or not targetPart:IsA("BasePart") then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local distance = (root.Position - targetPart.Position).Magnitude
        local speed = 80 -- กำหนดความเร็วการเคลื่อนที่แบบปลอดภัย
        local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, info, {CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)})
        tween:Play()
        tween.Completed:Wait()
    end
end

-- ระบบวนลูปตรวจสอบคำสั่งบอทฟาร์มทำงานเบื้องหลัง
task.spawn(function()
    while task.wait(0.5) do
        -- เมื่อเปิดสวิตช์ฟาร์มไข่
        if _G.MasterSteal and _G.StealEggVar then
            pcall(function()
                local TargetFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("DroppedEggs")
                if TargetFolder then
                    local AllEggs = TargetFolder:GetChildren()
                    if #AllEggs > 0 then
                        SmoothTeleport(AllEggs[1]) -- สั่งวาร์ปไปหาไข่ใบแรกในลิสต์
                    end
                end
            end)
        end

        -- เมื่อเปิดสวิตช์ออโต้วิ่งลู่วิ่ง
        if _G.MasterUpgrade and _G.TrainSpeedVar then
            pcall(function()
                local MyBase = workspace:FindFirstChild("Bases") and workspace.Bases:FindFirstChild(LocalPlayer.Name)
                local Treadmill = MyBase and MyBase:FindFirstChild("Treadmill")
                if Treadmill then
                    SmoothTeleport(Treadmill) -- วาร์ปไปขึ้นลู่วิ่งที่ฐานตัวเอง
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new(0, 0)) -- จำลองคลิกหน้าจอ
                end
            end)
        end
    end
end)

