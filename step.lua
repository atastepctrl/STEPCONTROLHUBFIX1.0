-- [[ STEPCONTROL HUB - PREMIUM UI WITH REAL-TIME RESIZE SYSTEM ]] --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local targetParent = game:GetService("CoreGui")
if not pcall(function() local a = game.CoreGui.Name end) then
    targetParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

if targetParent:FindFirstChild("StepControlResizeable") then
    targetParent.StepControlResizeable:Destroy()
end

-- 1. ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControlResizeable"
ScreenGui.Parent = targetParent
ScreenGui.ResetOnSpawn = false

-- 2. Main Frame (หน้าต่างหลัก)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 350) -- ขนาดเริ่มต้น
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- ลากย้ายตำแหน่งหน้าต่างได้
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.2
MainStroke.Color = Color3.fromRGB(0, 210, 120)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- ========================================================
-- [ ระบบลากเพิ่ม/ลดขนาดหน้าต่าง (PREMIUM RESIZE SYSTEM) ]
-- ========================================================
local ResizeButton = Instance.new("TextButton")
ResizeButton.Name = "ResizeButton"
ResizeButton.Size = UDim2.new(0, 16, 0, 16)
ResizeButton.Position = UDim2.new(1, -16, 1, -16) -- ตรึงไว้มุมขวาล่างสุดเป๊ะๆ
ResizeButton.BackgroundColor3 = Color3.fromRGB(0, 210, 120)
ResizeButton.BackgroundTransparency = 0.8 -- โปร่งแสงเนียนๆ ไม่กวนตา
ResizeButton.Text = "◢" -- สัญลักษณ์มุมลากขยายสไตล์สากล
ResizeButton.TextColor3 = Color3.fromRGB(0, 210, 120)
ResizeButton.TextSize = 12
ResizeButton.Font = Enum.Font.SourceSansBold
ResizeButton.ZIndex = 10
ResizeButton.Parent = MainFrame

local ResizeCorner = Instance.new("UICorner")
ResizeCorner.CornerRadius = UDim.new(0, 4)
ResizeCorner.Parent = ResizeButton

-- กลไกคำนวณการลากขยายหน้าต่างแบบ Real-time บนมือถือและคอม
local isResizing = false
local startMousePos, startSize

ResizeButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = true
        startMousePos = UserInputService:GetMouseLocation()
        startSize = MainFrame.Size
        MainFrame.Draggable = false -- ปิดระบบลากย้ายชั่วคราวขณะกำลังขยายขนาด
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local currentMousePos = UserInputService:GetMouseLocation()
        local diffX = currentMousePos.X - startMousePos.X
        local diffY = currentMousePos.Y - startMousePos.Y
        
        -- คำนวณขนาดใหม่ โดยตั้งค่าจำกัดขนาดขั้นต่ำไว้ที่ 400x250 ไม่ให้เมนูบั๊กเบี้ยว
        local newWidth = math.max(400, startSize.X.Offset + diffX)
        local newHeight = math.max(250, startSize.Y.Offset + diffY)
        
        MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = false
        MainFrame.Draggable = true -- เปิดระบบลากย้ายหน้าต่างกลับมาปกติเมื่อปล่อยนิ้ว
    end
end)

-- ========================================================
-- [ ปุ่มลอยด่วนตอนกดลดขนาด (MINI FLOATING BUTTON) ]
-- ========================================================
local MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniButton"
MiniButton.Size = UDim2.new(0, 50, 0, 50)
MiniButton.Position = UDim2.new(0, 20, 0, 20)
MiniButton.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
MiniButton.Text = "⚡"
MiniButton.TextColor3 = Color3.fromRGB(0, 240, 110)
MiniButton.Font = Enum.Font.FredokaOne
MiniButton.TextSize = 22
MiniButton.Visible = false
MiniButton.Active = true
MiniButton.Draggable = true
MiniButton.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = MiniButton

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Thickness = 1.5
MiniStroke.Color = Color3.fromRGB(0, 210, 120)
MiniStroke.Parent = MiniButton

-- ========================================================
-- [ ฝั่งซ้าย: SIDEBAR & NAV ]
-- ========================================================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0) -- ตัวบาร์จะยืดสูงตามขนาดหน้าต่างหลักอัตโนมัติ
Sidebar.BackgroundColor3 = Color3.fromRGB(6, 7, 8)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 14)
SideCorner.Parent = Sidebar

local SidePatch = Instance.new("Frame")
SidePatch.Size = UDim2.new(0, 15, 1, 0)
SidePatch.Position = UDim2.new(1, -15, 0, 0)
SidePatch.BackgroundColor3 = Color3.fromRGB(6, 7, 8)
SidePatch.BorderSizePixel = 0
SidePatch.Parent = Sidebar

-- แผงปุ่ม 3 สี Mac OS ใช้งานได้จริง
local MacButtons = Instance.new("Frame")
MacButtons.Size = UDim2.new(0, 50, 0, 10)
MacButtons.Position = UDim2.new(0, 16, 0, 16)
MacButtons.BackgroundTransparency = 1
MacButtons.Parent = Sidebar

local colors = {Color3.fromRGB(255, 85, 80), Color3.fromRGB(255, 180, 40), Color3.fromRGB(35, 200, 60)}
for i, color in ipairs(colors) do
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 10, 0, 10)
    Dot.Position = UDim2.new(0, (i-1) * 16, 0, 0)
    Dot.BackgroundColor3 = color
    Dot.BorderSizePixel = 0
    Dot.Parent = MacButtons
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    
    local ActionBtn = Instance.new("TextButton")
    ActionBtn.Size = UDim2.new(1, 0, 1, 0)
    ActionBtn.BackgroundTransparency = 1
    ActionBtn.Text = ""
    ActionBtn.Parent = Dot
    
    if i == 1 then
        ActionBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    elseif i == 2 or i == 3 then
        ActionBtn.MouseButton1Click:Connect(function()
            MainFrame.Visible = false
            MiniButton.Visible = true
        end)
    end
end

MiniButton.MouseButton1Click:Connect(function()
    MiniButton.Visible = false
    MainFrame.Visible = true
end)

local Brand = Instance.new("TextLabel")
Brand.Text = "STEPCONTROL"
Brand.Size = UDim2.new(1, -16, 0, 20)
Brand.Position = UDim2.new(0, 16, 0, 38)
Brand.TextColor3 = Color3.fromRGB(0, 230, 110)
Brand.TextSize = 13
Brand.Font = Enum.Font.FredokaOne
Brand.TextXAlignment = Enum.TextXAlignment.Left
Brand.BackgroundTransparency = 1
Brand.Parent = Sidebar

-- ========================================================
-- [ ฝั่งขวา: CONTENT & INTERACTIVE TOGGLES ]
-- ========================================================
local RightArea = Instance.new("Frame")
RightArea.Size = UDim2.new(1, -150, 1, 0)
RightArea.Position = UDim2.new(0, 150, 0, 0)
RightArea.BackgroundTransparency = 1
RightArea.Parent = MainFrame

local HeaderText = Instance.new("TextLabel")
HeaderText.Text = "Premium Client v2.5 > Main Farm"
HeaderText.Size = UDim2.new(1, -20, 0, 30)
HeaderText.Position = UDim2.new(0, 20, 0, 14)
HeaderText.TextColor3 = Color3.fromRGB(240, 240, 245)
HeaderText.TextSize = 13
HeaderText.Font = Enum.Font.SourceSansBold
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.BackgroundTransparency = 1
HeaderText.Parent = RightArea

-- กล่องฟังก์ชันแบบขยายขนาดตามกว้างหน้าต่างหลัก (Responsive Card)
local Card = Instance.new("Frame")
Card.Size = UDim2.new(1, -35, 0, 120)
Card.Position = UDim2.new(0, 20, 0, 52)
Card.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
Card.BorderSizePixel = 0
Card.Parent = RightArea
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color = Color3.fromRGB(26, 32, 30)
CardStroke.Thickness = 1

local SectionTitle = Instance.new("TextLabel")
SectionTitle.Text = "⚡ MAIN CONTROLLER"
SectionTitle.Size = UDim2.new(1, -20, 0, 25)
SectionTitle.Position = UDim2.new(0, 16, 0, 10)
SectionTitle.TextColor3 = Color3.fromRGB(100, 105, 115)
SectionTitle.TextSize = 11
SectionTitle.Font = Enum.Font.SourceSansBold
SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
SectionTitle.BackgroundTransparency = 1
SectionTitle.Parent = Card

local function CreatePremiumToggle(parent, labelText, yPos, globalVarName)
    _G[globalVarName] = false
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Text = labelText
    ToggleLabel.Size = UDim2.new(0, 250, 0, 30)
    ToggleLabel.Position = UDim2.new(0, 16, 0, yPos)
    ToggleLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
    ToggleLabel.TextSize = 13
    ToggleLabel.Font = Enum.Font.SourceSansBold
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Parent = parent

    local Switch = Instance.new("TextButton")
    Switch.Text = ""
    Switch.Size = UDim2.new(0, 44, 0, 22)
    Switch.Position = UDim2.new(1, -60, 0, yPos + 4) -- ตัวปุ่มสวิตช์จะเขยิบตามความกว้างของการ์ดอัตโนมัติ
    Switch.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
    Switch.Parent = parent
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local SwitchDot = Instance.new("Frame")
    SwitchDot.Size = UDim2.new(0, 18, 0, 18)
    SwitchDot.Position = UDim2.new(0, 2, 0, 2)
    SwitchDot.BackgroundColor3 = Color3.fromRGB(140, 145, 150)
    SwitchDot.Parent = Switch
    Instance.new("UICorner", SwitchDot).CornerRadius = UDim.new(1, 0)

    Switch.MouseButton1Click:Connect(function()
        _G[globalVarName] = not _G[globalVarName]
        if _G[globalVarName] then
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 200, 95)}):Play()
            TweenService:Create(SwitchDot, TweenInfo.new(0.15), {Position = UDim2.new(0, 24, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 38, 42)}):Play()
            TweenService:Create(SwitchDot, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(140, 145, 150)}):Play()
            ToggleLabel.TextColor3 = Color3.fromRGB(160, 165, 170)
        end
    end)
end

CreatePremiumToggle(Card, "Enable Custom System", 40, "CustomSystemActive")
CreatePremiumToggle(Card, "Bypass Anticheat Security", 75, "BypassActive")

-- ระบบแถบแท็บด้านซ้าย
local activeTabButton = nil
local function AddSidebarTab(text, icon, y_pos, tabName)
    local Tab = Instance.new("TextButton")
    Tab.Text = "  " .. icon .. "  " .. text
    Tab.Size = UDim2.new(1, -16, 0, 34)
    Tab.Position = UDim2.new(0, 8, 0, y_pos)
    Tab.Font = Enum.Font.SourceSansBold
    Tab.TextSize = 13
    Tab.TextXAlignment = Enum.TextXAlignment.Left
    Tab.BorderSizePixel = 0
    Tab.Parent = Sidebar
    Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 8)

    local TabStroke = Instance.new("UIStroke", Tab)
    TabStroke.Thickness = 0.8
    TabStroke.Enabled = false
    
    if tabName == "Main Farm" then
        Tab.BackgroundColor3 = Color3.fromRGB(12, 35, 22)
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabStroke.Color = Color3.fromRGB(0, 200, 95)
        TabStroke.Enabled = true
        activeTabButton = Tab
    else
        Tab.BackgroundTransparency = 1
        Tab.TextColor3 = Color3.fromRGB(120, 125, 130)
    end

    Tab.MouseButton1Click:Connect(function()
        if activeTabButton and activeTabButton ~= Tab then
            activeTabButton.BackgroundTransparency = 1
            activeTabButton.TextColor3 = Color3.fromRGB(120, 125, 130)
            local oldStroke = activeTabButton:FindFirstChildOfClass("UIStroke")
            if oldStroke then oldStroke.Enabled = false end
        end
        Tab.BackgroundTransparency = 0
        Tab.BackgroundColor3 = Color3.fromRGB(12, 35, 22)
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabStroke.Color = Color3.fromRGB(0, 200, 95)
        TabStroke.Enabled = true
        activeTabButton = Tab
        HeaderText.Text = "Premium Client v2.5 > " .. tabName
    end)
end

AddSidebarTab("Main Farm", "⚡", 75, "Main Farm")
AddSidebarTab("Auto Quest", "📜", 115, "Auto Quest")
AddSidebarTab("Teleport", "🌀", 155, "Teleport")
AddSidebarTab("Settings", "⚙️", 195, "Settings")
