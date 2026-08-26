-- ==================== 4. AUTO JOIN - RIGHT COLUMN ====================

local Card2 = CreateReaperCard(AJ_Right, "Join Options", "Additional join controls", 0, 125, "MasterHatch")
AddCheckbox(Card2, "Rejoin Server", 48, "RejoinVar")
AddCheckbox(Card2, "Notify Join", 76, "NotifyJoinVar")

local Card3 = CreateReaperCard(AJ_Left, "Status", "Current system status", 140, 90, "MasterUpgrade")
AddCheckbox(Card3, "Enable Status", 48, "StatusVar")

-- ==================== 5. FARM & STEAL PAGE ====================

local FarmCard1 = CreateReaperCard(
    FS_Left,
    "Farm Settings",
    "Automation settings",
    0,
    125,
    "MasterSteal"
)

AddCheckbox(FarmCard1, "Auto Farm", 48, "AutoFarmVar")
AddCheckbox(FarmCard1, "Auto Collect", 76, "AutoCollectVar")

local FarmCard2 = CreateReaperCard(
    FS_Right,
    "Farm Options",
    "Extra controls",
    0,
    125,
    "FarmMaster"
)

AddCheckbox(FarmCard2, "Auto Sell", 48, "AutoSellVar")
AddCheckbox(FarmCard2, "Auto Upgrade", 76, "AutoUpgradeVar")

-- ==================== 6. UTILITIES PAGE ====================

local UtilCard1 = CreateReaperCard(
    UT_Left,
    "Utilities",
    "General utilities",
    0,
    125,
    "UtilityMaster"
)

AddCheckbox(UtilCard1, "FPS Display", 48, "FPSDisplayVar")
AddCheckbox(UtilCard1, "Performance Mode", 76, "PerformanceVar")

local UtilCard2 = CreateReaperCard(
    UT_Right,
    "Interface",
    "UI preferences",
    0,
    125,
    "InterfaceMaster"
)

AddCheckbox(UtilCard2, "Notifications", 48, "NotificationsVar")
AddCheckbox(UtilCard2, "Animations", 76, "AnimationsVar")

-- ==================== 7. SETTINGS PAGE ====================

local SettingsCard1 = CreateReaperCard(
    ST_Left,
    "Interface Settings",
    "Customize the hub",
    0,
    125,
    "SettingsMaster"
)

AddCheckbox(SettingsCard1, "Smooth Animation", 48, "SmoothAnimationVar")
AddCheckbox(SettingsCard1, "Floating Button", 76, "FloatingButtonVar")

local SettingsCard2 = CreateReaperCard(
    ST_Right,
    "System",
    "Hub controls",
    0,
    125,
    "SystemMaster"
)

AddCheckbox(SettingsCard2, "Debug Mode", 48, "DebugModeVar")
AddCheckbox(SettingsCard2, "Auto Load", 76, "AutoLoadVar")

-- ==================== 8. DEFAULT TAB ====================

for _, Page in pairs(TabPages) do
    Page.Visible = false
end

for _, Btn in pairs(TabButtons) do
    Btn.BackgroundTransparency = 1
    Btn.TextColor3 = Color3.fromRGB(140, 140, 145)
end

if TabPages["AutoJoin"] and TabButtons["AutoJoin"] then
    TabPages["AutoJoin"].Visible = true

    TabButtons["AutoJoin"].BackgroundTransparency = 0
    TabButtons["AutoJoin"].BackgroundColor3 = Color3.fromRGB(28, 24, 15)
    TabButtons["AutoJoin"].TextColor3 = Color3.fromRGB(255, 204, 0)
end

-- ==================== 9. HEADER TITLE ====================

local HubTitle = Instance.new("TextLabel")
HubTitle.Name = "HubTitle"
HubTitle.Parent = MainFrame
HubTitle.Position = UDim2.new(0, 205, 0, 7)
HubTitle.Size = UDim2.new(0, 300, 0, 22)
HubTitle.BackgroundTransparency = 1
HubTitle.Text = "StepControl Hub"
HubTitle.TextColor3 = Color3.fromRGB(235, 235, 240)
HubTitle.TextSize = 15
HubTitle.Font = Enum.Font.SourceSansBold
HubTitle.TextXAlignment = Enum.TextXAlignment.Center

-- ==================== 10. VERSION LABEL ====================

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Name = "Version"
VersionLabel.Parent = MainFrame
VersionLabel.Position = UDim2.new(1, -85, 0, 10)
VersionLabel.Size = UDim2.new(0, 70, 0, 16)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v1.0.0"
VersionLabel.TextColor3 = Color3.fromRGB(90, 90, 95)
VersionLabel.TextSize = 10
VersionLabel.Font = Enum.Font.SourceSans
VersionLabel.TextXAlignment = Enum.TextXAlignment.Right

-- ==================== 11. SIMPLE STATUS BAR ====================

local StatusBar = Instance.new("Frame")
StatusBar.Name = "StatusBar"
StatusBar.Parent = MainFrame
StatusBar.Position = UDim2.new(0, 175, 1, -25)
StatusBar.Size = UDim2.new(0, 490, 0, 16)
StatusBar.BackgroundTransparency = 1

local StatusDot = Instance.new("Frame")
StatusDot.Parent = StatusBar
StatusDot.Position = UDim2.new(0, 2, 0.5, -4)
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.BackgroundColor3 = Color3.fromRGB(70, 200, 90)

Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

local StatusText = Instance.new("TextLabel")
StatusText.Parent = StatusBar
StatusText.Position = UDim2.new(0, 16, 0, 0)
StatusText.Size = UDim2.new(0, 200, 1, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Ready"
StatusText.TextColor3 = Color3.fromRGB(110, 110, 115)
StatusText.TextSize = 10
StatusText.Font = Enum.Font.SourceSans
StatusText.TextXAlignment = Enum.TextXAlignment.Left

-- ==================== 12. SAFE CLEANUP ====================

ScreenGui.Destroying:Connect(function()
    _G.MasterSteal = false
    _G.MasterJoin = false
    _G.MasterHatch = false
    _G.MasterUpgrade = false
end)
