-- =============================================================================
-- STEPCONTROL HUB - ULTIMATE REAPER STYLE (DARK & YELLOW EDITION)
-- FULLY FUNCTIONAL TAB SWITCHING & SMOOTH MOBILE INTERACTION
-- =============================================================================

if game.CoreGui:FindFirstChild("StepControlHub") then
    game.CoreGui.StepControlHub:Destroy()
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TweenInfoFast = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- สร้างหน้าต่างหลัก
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

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- ==================== SIDEBAR (แถบซ้ายมือ) ====================
local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Parent = MainFrame
SideBar.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
SideBar.Size = UDim2.new(0, 160, 1, 0)
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 8)

local Logo = Instance.new("TextLabel")
Logo.Parent = SideBar
Logo.Size = UDim2.new(1, 0, 0, 45)
Logo.BackgroundTransparency = 1
Logo.Text = "  STEPCONTROL"
Logo.TextColor3 = Color3.fromRGB(240, 240, 245)
Logo.TextSize = 14
Logo.Font = Enum.Font.SourceSansBold
Logo.TextXAlignment = Enum.TextXAlignment.Left

-- ที่เก็บปุ่มและหน้าของแต่ละแท็บ
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

-- ฟังก์ชันสร้างปุ่มแท็บสลับหน้าได้จริง
local function AddTab(id, text, yPos)
    -- สร้างหน้าเพจสำหรับแท็บนี้
    local Page = Instance.new("Frame")
    Page.Name = id .. "Page"
    Page.Parent = MainFrame
    Page.Position = UDim2.new(0, 175, 0, 15)
    Page.Size = UDim2.new(0, 490, 0, 430)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    TabPages[id] = Page

    -- แบ่งคอลัมน์ซ้ายขวาในแต่ละหน้า
    local LeftCol = Instance.new("Frame")
    LeftCol.Name = "LeftCol"
    LeftCol.Parent = Page
    LeftCol.Size = UDim2.new(0, 240, 1, 0)
    LeftCol.BackgroundTransparency = 1
    
    local RightCol = Instance.new("Frame")
    RightCol.Name = "RightCol"
    RightCol.Parent = Page
    RightCol.Position = UDim2.new(0, 250, 0, 0)
    RightCol.Size = UDim2.new(0, 240, 1, 0)
    RightCol.BackgroundTransparency = 1

    -- สร้างปุ่มกดด้านซ้าย
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
        -- ซ่อนทุกหน้าและล้างสีปุ่ม
        for k, p in pairs(TabPages) do p.Visible = false end
        for k, b in pairs(TabButtons) do 
            TweenService:Create(b, TweenInfoFast, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(140, 140, 145)}):Play()
        end
        -- เปิดเฉพาะหน้าเพจที่เลือก + ไฮไลต์สีเหลืองสมูท
        Page.Visible = true
        TweenService:Create(Btn, TweenInfoFast, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(28, 24, 15), TextColor3 = Color3.fromRGB(255, 204, 0)}):Play()
    end)

    return LeftCol, RightCol
end

CreateCategoryLabel("General", 55)
local AJ_Left, AJ_Right = AddTab("AutoJoin", "Auto Join", 75)

CreateCategoryLabel("Game Exploit", 115)
local FS_Left, FS_Right = AddTab("FarmSteal", "Farm & Steal", 135)

CreateCategoryLabel("Utilities", 175)
local UT_Left, UT_Right = AddTab("Utilities", "Utilities", 195)
local ST_Left, ST_Right = AddTab("Settings", "Settings", 230)

-- ==================== COMPONENT CREATOR (ฟังก์ชันการ์ดและปุ่ม) ====================
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
            TweenService:Create(ToggleBtn, TweenInfoFast, {BackgroundColor3 = Color3.fromRGB(255, 204, 0)}):Play()
            TweenService:Create(Circle, TweenInfoFast, {Position = UDim2.new(1, -12, 0.5, -5), BackgroundColor3 = Color3.fromRGB(15, 15, 17)}):Play()
        else
            TweenService:Create(ToggleBtn, TweenInfoFast, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
            TweenService:Create(Circle, TweenInfoFast, {Position = UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = Color3.fromRGB(180, 180, 185)}):Play()
        end
    end)
    return Card
end

local function AddCheckbox(card, text, yPos, globalVar)
    local Label = Instance.new("TextLabel", card)
    Label.Position = UDim2.new(0, 12, 0, yPos)
    Label.Size = UDim2.new(0, 150, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(190, 190, 195)
    Label.TextSize = 12
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Box = Instance.new("TextButton", card)
    Box.Position = UDim2.new(1, -26, 0, yPos + 3)
    Box.Size = UDim2.new(0, 14, 0, 14)
    Box.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    Box.Text = ""
    Box.TextColor3 = Color3.fromRGB(15, 15, 17)
    Box.TextSize = 11
    Box.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 3)
    
    _G[globalVar] = false
    Box.Activated:Connect(function()
        _G[globalVar] = not _G[globalVar]
        if _G[globalVar] then
            Box.BackgroundColor3 = Color3.fromRGB(255, 204, 0)
            Box.Text = "✓"
        else
            Box.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            Box.Text = ""
        end
    end)
end

local function AddSlider(card, text, yPos)
    local Label = Instance.new("TextLabel", card)
    Label.Position = UDim2.new(0, 12, 0, yPos)
    Label.Size = UDim2.new(0, 100, 0, 15)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(180, 180, 185)
    Label.TextSize = 12
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local ValLabel = Instance.new("TextLabel", card)
    ValLabel.Position = UDim2.new(1, -45, 0, yPos)
    ValLabel.Size = UDim2.new(0, 35, 0, 15)
    ValLabel.BackgroundTransparency = 1
    ValLabel.Text = "10/s"
    ValLabel.TextColor3 = Color3.fromRGB(130, 130, 135)
    ValLabel.TextSize = 11
    ValLabel.Font = Enum.Font.SourceSans
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local MainBar = Instance.new("TextButton", card)
    MainBar.Position = UDim2.new(0, 12, 0, yPos + 18)
    MainBar.Size = UDim2.new(1, -24, 0, 4)
    MainBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainBar.Text = ""
    MainBar.BorderSizePixel = 0
    
    local FillBar = Instance.new("Frame", MainBar)
    FillBar.Size = UDim2.new(0.33, 0, 1, 0)
    FillBar.BackgroundColor3 = Color3.fromRGB(255, 204, 0)
    FillBar.BorderSizePixel = 0
    
    local Dragging = false
    MainBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            Dragging = false 
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local Percentage = math.clamp((input.Position.X - MainBar.AbsolutePosition.X) / MainBar.AbsoluteSize.X, 0, 1)
            FillBar.Size = UDim2.new(Percentage, 0, 1, 0)
            ValLabel.Text = tostring(math.floor(Percentage * 30)) .. "/s"
        end
    end)
end

-- ==================== ประกอบเนื้อหาลงแต่ละหน้าแท็บ ====================

-- หน้าที่ 1: แท็บ Auto Join (คอลัมน์ซ้าย)
local Card1 = CreateReaperCard(AJ_Left, "Join Settings", "Boost your game's performance", 0, 125, "MasterJoin")
AddCheckbox(Card1, "Auto Start", 48, "AutoStartVar")
AddSlider(Card1, "Join Delay", 76)

-- หน้าที่ 2: แท็บ Farm & Steal (แยกคอลัมน์ซ้าย-ขวา)
local Card2 = CreateReaperCard(FS_Left, "Egg Farm", "Steal An Egg configuration", 0, 110, "MasterSteal")
AddCheckbox(Card2, "Auto Steal Eggs", 48, "StealEggVar")
AddCheckbox(Card2, "Teleport To Base", 74, "TeleportBaseVar")

local Card3 = CreateReaperCard(FS_Right, "Hatch System", "Automatic Hatch Configuration", 0, 110, "MasterHatch")
AddCheckbox(Card3, "Auto Hatch Normal", 48, "HatchNormalVar")
AddCheckbox(Card3, "Auto Equip Best", 74, "EquipBestVar")

-- หน้าที่ 3: แท็บ Utilities
local Card4 = CreateReaperCard(UT_Left, "Base Upgrades", "Treadmill and Rank Configuration", 0, 110, "MasterUpgrade")
AddCheckbox(Card4, "Auto Train Speed", 48, "TrainSpeedVar")
AddCheckbox(Card4, "Auto Rebirth", 74, "RebirthVar")

-- บังคับเปิดหน้าแรกสุดไว้เป็นค่าเริ่มต้นตอนโหลดสคริปต์
TabPages["AutoJoin"].Visible = true
TabButtons["AutoJoin"].BackgroundTransparency = 0
TabButtons["AutoJoin"].BackgroundColor3 = Color3.fromRGB(28, 24, 15)
TabButtons["AutoJoin"].TextColor3 = Color3.fromRGB(255, 204, 0)
