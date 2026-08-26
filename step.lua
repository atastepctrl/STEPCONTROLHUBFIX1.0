-- =============================================================================
-- STEPCONTROL HUB - ULTIMATE REAPER STYLE (SMOOTH MINIMIZE VERSION)
-- DEVELOPED BY COLLABORATOR FOR: STEAL AN EGG
-- =============================================================================

if game.CoreGui:FindFirstChild("StepControlHub") then
    game.CoreGui.StepControlHub:Destroy()
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
-- ตั้งค่าแอนิเมชันให้นุ่มนวลสไตล์แอปยุคใหม่ (Quad, Out)
local TweenInfoSmooth = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

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
MainFrame.Draggable = true -- หน้าต่างใหญ่ลากหลบได้
MainFrame.ClipsDescendants = true -- ซ่อนเนื้อหาเวลาหดหน้าต่าง

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- ==================== [ NEW ] ระบบปุ่มลอยน้ำสำหรับย่อ-ขยายหน้าต่างพรีเมี่ยม ====================
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinimizeButton"
MinBtn.Parent = ScreenGui
MinBtn.Position = UDim2.new(0.1, 0, 0.2, 0) -- พิกัดเริ่มต้นลอยบนจอ
MinBtn.Size = UDim2.new(0, 48, 0, 48)
MinBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
MinBtn.Text = "SC" -- อักษรย่อ STEPCONTROL
MinBtn.TextColor3 = Color3.fromRGB(255, 204, 0)
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.Visible = false -- เริ่มต้นซ่อนไว้ก่อน เพราะหน้าต่างใหญ่เปิดอยู่
MinBtn.Active = true
MinBtn.Draggable = true -- ปุ่มลอยใช้นิ้วลากย้ายพิกัดได้อิสระบนมือถือ

Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0) -- รูปทรงวงกลมสมบูรณ์
local MinStroke = Instance.new("UIStroke", MinBtn)
MinStroke.Color = Color3.fromRGB(255, 204, 0) -- เส้นขอบเรืองแสงสีทอง
MinStroke.Thickness = 1.5

-- ปุ่มกากบาทขวาบนหน้าต่างใหญ่สำหรับกดปิดย่อ (Close/Minimize Interface)
local CloseWindowBtn = Instance.new("TextButton")
CloseWindowBtn.Parent = MainFrame
CloseWindowBtn.Position = UDim2.new(1, -30, 0, 10)
CloseWindowBtn.Size = UDim2.new(0, 20, 0, 20)
CloseWindowBtn.BackgroundTransparency = 1
CloseWindowBtn.Text = "×"
CloseWindowBtn.TextColor3 = Color3.fromRGB(150, 150, 155)
CloseWindowBtn.TextSize = 20
CloseWindowBtn.Font = Enum.Font.SourceSansBold

-- แอนิเมชันเปลี่ยนสีเวลานิ้วไปโดนปุ่มกากบาท
CloseWindowBtn.MouseEnter:Connect(function() CloseWindowBtn.TextColor3 = Color3.fromRGB(255, 204, 0) end)
CloseWindowBtn.MouseLeave:Connect(function() CloseWindowBtn.TextColor3 = Color3.fromRGB(150, 150, 155) end)

-- ลอจิกการทำงาน: เมื่อกดปุ่มกากบาท (สั่งย่อหน้าต่างใหญ่)
CloseWindowBtn.Activated:Connect(function()
    -- หน้าต่างใหญ่ค่อยๆ จางและหดตัวลงอย่างนุ่มนวล
    TweenService:Create(MainFrame, TweenInfoSmooth, {Size = UDim2.fromOffset(0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}):Play()
    task.wait(0.15)
    MainFrame.Visible = false
    
    -- เปิดปุ่มลอยน้ำวงกลมขึ้นมา พร้อมแอนิเมชันขยายตัวออก
    MinBtn.Size = UDim2.fromOffset(0, 0)
    MinBtn.Visible = true
    TweenService:Create(MinBtn, TweenInfoSmooth, {Size = UDim2.fromOffset(48, 48)}):Play()
end)

-- ลอจิกการทำงาน: เมื่อกดปุ่มลอยน้ำวงกลม SC (สั่งขยายกลับมาหน้าต่างใหญ่)
MinBtn.Activated:Connect(function()
    -- ปุ่มลอยหดหายไป
    local TweenMin = TweenService:Create(MinBtn, TweenInfoSmooth, {Size = UDim2.fromOffset(0, 0)})
    TweenMin:Play()
    TweenMin.Completed:Wait()
    MinBtn.Visible = false
    
    -- คืนค่าหน้าต่างใหญ่ให้ค่อยๆ ขยายตัวกระจายออกกลางจอสไตล์แอป High-End
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfoSmooth, {Size = UDim2.fromOffset(680, 460), Position = UDim2.new(0.5, -340, 0.5, -230), BackgroundTransparency = 0}):Play()
end)


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
    Page.Position = UDim2.new(0, 175, 0, 35) -- หลบปุ่มกากบาทด้านบนเล็กน้อย
    Page.Size = UDim2.new(0, 490, 0, 410)
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

CreateCategoryLabel("General", 55)
local AJ_Left, AJ_Right = AddTab("AutoJoin", "Auto Join", 75)

CreateCategoryLabel("Game Exploit", 115)
local FS_Left, FS_Right = AddTab("FarmSteal", "Farm & Steal", 135)

CreateCategoryLabel("Utilities", 175)
local UT_Left, UT_Right = AddTab("Utilities", "Utilities", 195)
local ST_Left, ST_Right = AddTab("Settings", "Settings", 230)

-- ==================== COMPONENT CREATOR ====================
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
