local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- ลบ GUI เดิม
if player:WaitForChild("PlayerGui"):FindFirstChild("StepControl_Official") then
	player.PlayerGui.StepControl_Official:Destroy()
end

-- ตัวแปรหลัก
_G.FarmDistanceZ = 6
_G.FarmDistanceY = 5
_G.AutoQuest = false
_G.AutoFarmMon = false
_G.SelectWeapon = nil
_G.AutoEquip = false

-- GUI หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StepControl_Official"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

-- Glow
local ShadowFrame = Instance.new("Frame")
ShadowFrame.Size = UDim2.new(0, 580, 0, 380)
ShadowFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
ShadowFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
ShadowFrame.BackgroundTransparency = 0.88
ShadowFrame.BorderSizePixel = 0
ShadowFrame.Parent = ScreenGui

Instance.new("UICorner", ShadowFrame).CornerRadius = UDim.new(0, 14)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, -4, 1, -4)
MainFrame.Position = UDim2.new(0, 2, 0, 2)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 12)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ShadowFrame

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Header
local HeaderBar = Instance.new("Frame")
HeaderBar.Size = UDim2.new(1, 0, 0, 42)
HeaderBar.BackgroundColor3 = Color3.fromRGB(18, 24, 18)
HeaderBar.BorderSizePixel = 0
HeaderBar.Parent = MainFrame

-- ปุ่ม Mac
local MacButtons = Instance.new("Frame")
MacButtons.Size = UDim2.new(0, 90, 1, 0)
MacButtons.Position = UDim2.new(0, 15, 0, 0)
MacButtons.BackgroundTransparency = 1
MacButtons.Parent = HeaderBar

local Layout = Instance.new("UIListLayout")
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.VerticalAlignment = Enum.VerticalAlignment.Center
Layout.Padding = UDim.new(0, 8)
Layout.Parent = MacButtons

local function CreateMacButton(color)
	local hitBoxBtn = Instance.new("TextButton")
	hitBoxBtn.Size = UDim2.new(0, 22, 0, 22)
	hitBoxBtn.BackgroundTransparency = 1
	hitBoxBtn.Text = ""
	hitBoxBtn.Parent = MacButtons

	local visualCircle = Instance.new("Frame")
	visualCircle.Size = UDim2.new(0, 11, 0, 11)
	visualCircle.Position = UDim2.new(0.5, -5.5, 0.5, -5.5)
	visualCircle.BackgroundColor3 = color
	visualCircle.BorderSizePixel = 0
	visualCircle.Parent = hitBoxBtn

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = visualCircle

	return hitBoxBtn
end

local CloseBtn = CreateMacButton(Color3.fromRGB(255, 95, 86))
local MinimizeBtn = CreateMacButton(Color3.fromRGB(255, 189, 46))
local MaximizeBtn = CreateMacButton(Color3.fromRGB(39, 201, 63))

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 110, 0, 0)
Title.BackgroundTransparency = 1
Title.RichText = true
Title.Text = "STEPCONTROL <font color='rgb(0,255,120)'>HUB</font>"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = HeaderBar

-- Content
local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Size = UDim2.new(1, -24, 1, -55)
ContentArea.Position = UDim2.new(0, 12, 0, 48)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.ScrollBarThickness = 3
ContentArea.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 120)
ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentArea.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = ContentArea

-- Open Button
local OpenMainBtn = Instance.new("TextButton")
OpenMainBtn.Size = UDim2.new(0, 100, 0, 32)
OpenMainBtn.Position = UDim2.new(0, 15, 0, 15)
OpenMainBtn.BackgroundColor3 = Color3.fromRGB(15, 22, 15)
OpenMainBtn.Text = "OPEN HUB"
OpenMainBtn.TextColor3 = Color3.fromRGB(0, 255, 120)
OpenMainBtn.Font = Enum.Font.GothamBold
OpenMainBtn.TextSize = 11
OpenMainBtn.Visible = false
OpenMainBtn.Parent = ScreenGui

Instance.new("UICorner", OpenMainBtn).CornerRadius = UDim.new(0, 6)

-- Toggle
local function AddToggle(text, default, callback)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, -6, 0, 48)
	ToggleFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 18)
	ToggleFrame.BorderSizePixel = 0
	ToggleFrame.Parent = ContentArea

	Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -70, 1, 0)
	Label.Position = UDim2.new(0, 14, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(225, 225, 225)
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Font = Enum.Font.GothamSemibold
	Label.TextSize = 13
	Label.Parent = ToggleFrame

	local Switch = Instance.new("TextButton")
	Switch.Size = UDim2.new(0, 42, 0, 22)
	Switch.Position = UDim2.new(1, -55, 0.5, -11)
	Switch.BackgroundColor3 = default and Color3.fromRGB(0, 210, 95) or Color3.fromRGB(45, 50, 45)
	Switch.Text = ""
	Switch.Parent = ToggleFrame

	Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.new(0, 16, 0, 16)
	Circle.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
	Circle.BackgroundColor3 = Color3.new(1,1,1)
	Circle.Parent = Switch

	Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

	local toggled = default

	Switch.MouseButton1Click:Connect(function()
		toggled = not toggled

		TweenService:Create(
			Switch,
			TweenInfo.new(0.2),
			{
				BackgroundColor3 = toggled and Color3.fromRGB(0,210,95)
					or Color3.fromRGB(45,50,45)
			}
		):Play()

		TweenService:Create(
			Circle,
			TweenInfo.new(0.2),
			{
				Position = toggled and UDim2.new(1,-19,0.5,-8)
					or UDim2.new(0,3,0.5,-8)
			}
		):Play()

		callback(toggled)
	end)
end

-- Dropdown
local function AddDropdown(text, list, callback)
	local DropFrame = Instance.new("Frame")
	DropFrame.Size = UDim2.new(1, -6, 0, 48)
	DropFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 18)
	DropFrame.Parent = ContentArea

	Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0, 180, 1, 0)
	Label.Position = UDim2.new(0, 14, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(225,225,225)
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Font = Enum.Font.GothamSemibold
	Label.TextSize = 13
	Label.Parent = DropFrame

	local ChoiceBtn = Instance.new("TextButton")
	ChoiceBtn.Size = UDim2.new(0, 160, 0, 28)
	ChoiceBtn.Position = UDim2.new(1, -174, 0.5, -14)
	ChoiceBtn.BackgroundColor3 = Color3.fromRGB(32,40,32)
	ChoiceBtn.Text = list[1]
	ChoiceBtn.TextColor3 = Color3.fromRGB(0,255,120)
	ChoiceBtn.Font = Enum.Font.GothamSemibold
	ChoiceBtn.TextSize = 12
	ChoiceBtn.Parent = DropFrame

	Instance.new("UICorner", ChoiceBtn).CornerRadius = UDim.new(0, 6)

	local currentIndex = 1

	ChoiceBtn.MouseButton1Click:Connect(function()
		currentIndex += 1

		if currentIndex > #list then
			currentIndex = 1
		end

		local selected = list[currentIndex]

		ChoiceBtn.Text = selected
		callback(selected)
	end)
end

-- Equip Tool
local function EquipTool(toolName)
	local character = player.Character

	if character and character:FindFirstChild("Humanoid") then
		if not character:FindFirstChild(toolName) then
			local backpack = player:FindFirstChild("Backpack")

			if backpack and backpack:FindFirstChild(toolName) then
				character.Humanoid:EquipTool(backpack[toolName])
			end
		end
	end
end

-- UI Controls
AddToggle("Auto Accept Quest", false, function(state)
	_G.AutoQuest = state
end)

AddToggle("Auto Farm Soldier (Lv.1)", false, function(state)
	_G.AutoFarmMon = state
end)

-- Weapon List
local WeaponList = {}

local backpack = player:FindFirstChild("Backpack")

if backpack then
	for _, item in pairs(backpack:GetChildren()) do
		if item:IsA("Tool") then
			table.insert(WeaponList, item.Name)
		end
	end
end

if #WeaponList == 0 then
	table.insert(WeaponList, "Combat")
end

AddDropdown("Select Weapon", WeaponList, function(value)
	_G.SelectWeapon = value
end)

_G.SelectWeapon = WeaponList[1]

AddToggle("Auto Equip Weapon", false, function(state)
	_G.AutoEquip = state
end)

AddDropdown(
	"Farm Distance",
	{
		"Low (Safe)",
		"Medium (Very Safe)",
		"High (God Mode)"
	},
	function(mode)
		if mode == "Low (Safe)" then
			_G.FarmDistanceY = 4
			_G.FarmDistanceZ = 5

		elseif mode == "Medium (Very Safe)" then
			_G.FarmDistanceY = 6
			_G.FarmDistanceZ = 6

		elseif mode == "High (God Mode)" then
			_G.FarmDistanceY = 9
			_G.FarmDistanceZ = 4
		end
	end
)

-- Quest
local function AcceptSoldierQuest()
	local remote = ReplicatedStorage:FindFirstChild("Chest")

	if remote and remote:FindFirstChild("Remotes") then
		local functions = remote.Remotes:FindFirstChild("Functions")

		if functions and functions:FindFirstChild("Quest") then
			functions.Quest:InvokeServer("take", "Kill 4 Soldiers")
		end
	end
end

-- Main Loop
task.spawn(function()
	while task.wait() do

		if _G.AutoEquip and _G.SelectWeapon then
			EquipTool(_G.SelectWeapon)
		end

		if _G.AutoFarmMon then

			local missionGui =
				player.PlayerGui:FindFirstChild("MissionGui")

			local hasQuest =
				missionGui and missionGui.Enabled

			if _G.AutoQuest and not hasQuest then
				AcceptSoldierQuest()
				task.wait(0.3)
			end

			local target = nil

			local monsterFolder = workspace:FindFirstChild("Monster")

			if monsterFolder and monsterFolder:FindFirstChild("Mon") then

				for _, v in pairs(monsterFolder.Mon:GetChildren()) do

					if v.Name == "Soldier"
						and v:FindFirstChild("Humanoid")
						and v.Humanoid.Health > 0 then

						target = v
						break
					end
				end
			end

			local character = player.Character

			if target
				and target:FindFirstChild("HumanoidRootPart")
				and character
				and character:FindFirstChild("HumanoidRootPart") then

				character.HumanoidRootPart.CFrame =
					target.HumanoidRootPart.CFrame
					* CFrame.new(0, _G.FarmDistanceY, _G.FarmDistanceZ)
					* CFrame.Angles(math.rad(-90), 0, 0)

				local chest = ReplicatedStorage:FindFirstChild("Chest")

				if chest and chest:FindFirstChild("Remotes") then
					local functions = chest.Remotes:FindFirstChild("Functions")

					if functions and functions:FindFirstChild("SkillAction") then
						functions.SkillAction:InvokeServer("FS_None_M1")
					end
				end
			end
		end
	end
end)

-- Close
CloseBtn.MouseButton1Click:Connect(function()
	TweenService:Create(
		ShadowFrame,
		TweenInfo.new(0.25),
		{
			Size = UDim2.new(0,580,0,0),
			BackgroundTransparency = 1
		}
	):Play()

	task.wait(0.25)

	ScreenGui:Destroy()
end)

-- Minimize
local isMinimized = false

MinimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized

	TweenService:Create(
		ShadowFrame,
		TweenInfo.new(0.3),
		{
			Size = isMinimized
				and UDim2.new(0,580,0,42)
				or UDim2.new(0,580,0,380)
		}
	):Play()

	ContentArea.Visible = not isMinimized
end)

-- Hide
MaximizeBtn.MouseButton1Click:Connect(function()
	ShadowFrame.Visible = false
	OpenMainBtn.Visible = true
end)

OpenMainBtn.MouseButton1Click:Connect(function()
	ShadowFrame.Visible = true
	OpenMainBtn.Visible = false
end)

-- Drag System
local dragging = false
local dragStart
local startPos

HeaderBar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = ShadowFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	) then

		local delta = input.Position - dragStart

		ShadowFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
