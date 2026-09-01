Config = {
    Team = "Pirates",
    Configuration = {
        HopWhenIdle = true,
        AutoHop = true,
        AutoHopDelay = 60 * 60,
        FpsBoost = false,
        blackscreen = false,
        LowGraphics = true
    },
    Items = {
        AutoFullyMelees = true,
        Saber = true,
        CursedDualKatana = true,
        SoulGuitar = true,
        RaceV2 = true
    },
    Settings = {
        StayInSea2UntilHaveDarkFragments = true
    },
    AutoSea2 = true,
    AutoSea3 = true,
    AutoRaidIce_TargetFragments = 5000
}
print("[Tiro] Script da duoc nap, dang cho game load...")
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer

print("[Main] Bắt đầu Tiro Kaitun Modulo v2.2...")
timeee = os.time()
local W_angle = 30
local lastChange = tick()

-- ============================================================
-- [ADDED] CHỌN VŨ KHÍ (TỪ T-REX HUB)
-- ============================================================
_G.ChooseWP = "Melee"  -- Mặc định Melee (có thể đổi thành Sword, Gun, Blox Fruit)
_G.SelectWeapon = nil

-- Luồng tự động cập nhật vũ khí
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if not bp then return end
            if _G.ChooseWP == "Melee" then
                for _, v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Melee" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            elseif _G.ChooseWP == "Sword" then
                for _, v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Sword" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            elseif _G.ChooseWP == "Gun" then
                for _, v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Gun" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            elseif _G.ChooseWP == "Blox Fruit" then
                for _, v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            end
        end)
    end
end)

function hoangtuveu()
    local W = {Instances = {}}
    repeat task.wait() until game.CoreGui

    -- ============================================================
    -- UI TỪ DYNAMICISLAND_AXIOM-1.LUA (CÓ DISCORD + CONTAINER)
    -- ============================================================
    local gui = Instance.new('ScreenGui')
    gui.Name = "KaitunUI"
    gui.Parent = game:GetService('CoreGui')
    gui.Enabled = true
    gui.ResetOnSpawn = true
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = false

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Parent = gui
    container.AnchorPoint = Vector2.new(0.5, 0)
    container.Position = UDim2.new(0.5, 0, 0.01, 0)
    container.AutomaticSize = Enum.AutomaticSize.XY
    container.Size = UDim2.new(0, 0, 0, 0)
    container.BackgroundTransparency = 1

    local containerLayout = Instance.new("UIListLayout", container)
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 4)
    containerLayout.FillDirection = Enum.FillDirection.Vertical
    containerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local discordLabel = Instance.new("TextLabel")
    discordLabel.Name = "DiscordLabel"
    discordLabel.Parent = container
    discordLabel.LayoutOrder = 1
    discordLabel.AutomaticSize = Enum.AutomaticSize.XY
    discordLabel.Size = UDim2.new(0, 0, 0, 0)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "https://discord.gg/ZH7qdJMvR"
    discordLabel.TextSize = 13
    discordLabel.Font = Enum.Font.Highway
    discordLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    discordLabel.TextXAlignment = Enum.TextXAlignment.Center

    local frame = Instance.new("Frame")
    frame.Name = "Frame"
    frame.Parent = container
    frame.LayoutOrder = 2
    frame.AutomaticSize = Enum.AutomaticSize.XY
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(12, 28, 18)
    frame.BackgroundTransparency = 0.25
    frame.BorderSizePixel = 0

    local padding = Instance.new("UIPadding", frame)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0

    local layout = Instance.new("UIListLayout", frame)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.FillDirection = Enum.FillDirection.Vertical

    local features = Instance.new("Frame")
    features.Name = "Features"
    features.Parent = frame
    features.LayoutOrder = 1
    features.AutomaticSize = Enum.AutomaticSize.XY
    features.Size = UDim2.new(0, 0, 0, 0)
    features.BackgroundTransparency = 1

    local featLayout = Instance.new("UIListLayout", features)
    featLayout.SortOrder = Enum.SortOrder.LayoutOrder
    featLayout.Padding = UDim.new(0, 2)
    featLayout.FillDirection = Enum.FillDirection.Vertical

    local taskLabel = Instance.new("TextLabel")
    taskLabel.Name = "Task"
    taskLabel.Parent = features
    taskLabel.LayoutOrder = 1
    taskLabel.AutomaticSize = Enum.AutomaticSize.XY
    taskLabel.Size = UDim2.new(0, 0, 0, 0)
    taskLabel.BackgroundTransparency = 1
    taskLabel.Text = "Status :"
    taskLabel.TextSize = 14
    taskLabel.Font = Enum.Font.Ubuntu
    taskLabel.TextColor3 = Color3.fromRGB(220, 255, 230)
    taskLabel.TextXAlignment = Enum.TextXAlignment.Left

    local subTaskLabel = Instance.new("TextLabel")
    subTaskLabel.Name = "SubTask"
    subTaskLabel.Parent = features
    subTaskLabel.LayoutOrder = 2
    subTaskLabel.AutomaticSize = Enum.AutomaticSize.XY
    subTaskLabel.Size = UDim2.new(0, 0, 0, 0)
    subTaskLabel.BackgroundTransparency = 1
    subTaskLabel.Text = "Sub Task :"
    subTaskLabel.TextSize = 13
    subTaskLabel.Font = Enum.Font.Ubuntu
    subTaskLabel.TextColor3 = Color3.fromRGB(220, 255, 230)
    subTaskLabel.TextTransparency = 0
    subTaskLabel.TextXAlignment = Enum.TextXAlignment.Left

    W.Instances['Task1'] = taskLabel
    W.Instances['Task2'] = subTaskLabel
    W.Instances['MainTextLabel'] = taskLabel

    function SetText(key, text)
        task.spawn(function()
            local label = W.Instances[key]
            if not label then return end
            if label.Text == text then return end
            local ts = game:GetService("TweenService")
            local fadeOut = ts:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1, TextStrokeTransparency = 1})
            fadeOut:Play()
            fadeOut.Completed:Wait()
            label.Text = text
            local t = 0
            local fadeIn = ts:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = t, TextStrokeTransparency = t})
            fadeIn:Play()
        end)
    end
    getgenv().alert = function() end
    W.SetText = SetText
    W.ToggleUI = function() end
    W.ToggleInterface = function() end
    W.RegisterForBlur = function() end

    -- ============================================================
    -- LOGIC TỪ TEST.TXT (GIỮ NGUYÊN, BAO GỒM FAST ATTACK VÀ EQUIP)
    -- ============================================================
    if false then
        spawn(function()
            pcall(loadstring(game:HttpGet("https://raw.githubusercontent.com/sucvatthieunang/Trackstat/refs/heads/main/cac")))
        end)
    end
    alert("cac", "Endpoint reached")
    OldSessionTime = isfile and readfile and isfile('.tdif-' .. game.Players.LocalPlayer.Name) and tonumber(readfile(".tdif-" .. game.Players.LocalPlayer.Name)) or 0
    repeat
        task.wait()
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", Config.Team)
    until game.Players.LocalPlayer.Character
    alert("team assembled")
    repeat wait() until game.Players.LocalPlayer.Character
    spawn(function()
        game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild('NewIslandLOD', 9999):Destroy()
        game:GetService("Players")
        LocalPlayer.PlayerScripts:WaitForChild('IslandLOD', 9999):Destroy()
    end)
    alert('wait 1', 'ok')
    local J = {'RawConstants', "Utilly", "QuestManager", 'SpawnRegionLoader', 'TweenController', "AttackController", 'CombatController', 'FunctionsHandler', "Hooks", "Debug", "Hop", "Storage"}
    StartTick = tick()
    repeat
        task.wait()
    until SetText
    alert('load 2')
    SetText('MainTextLabel', 'Initalizing Script..')
    local J = "Rua_Hub/Blox_Fruit/Assets/"
    ScriptStorage = {IsInitalized = false, PlayerData = {}, Melees = {}, CurrentMeleeData = {}, Enemies = {}, Tools = {}, Backpack = {}, IgnoreStoreFruits = {}, Connections = {LocalPlayer = {}}, Task = {}, Tracebacks = {}, TaskController = {}, TracebackUpdater = {}, Interface = W, NPCs = {}, Map = {}}
    Players = game.Players
    LocalPlayer = Players.LocalPlayer
    Character = Players.LocalPlayer.Character
    Humanoid = Character:WaitForChild('Humanoid')
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    PlayerGui = LocalPlayer:WaitForChild('PlayerGui', 10)
    Lighting = game:GetService('Lighting')
    Services = {}
    setmetatable(Services, {__index = function(J, J) return game:GetService(J) end})
    setmetatable(ScriptStorage.Enemies, {__index = function(J, J) return Services.Workspace.Enemies:FindFirstChild(J) or Services.ReplicatedStorage:FindFirstChild(J) end})
    setmetatable(ScriptStorage.Map, {__index = function(J, J) return Services.Workspace.Map:FindFirstChild(J) or Services.Workspace:FindFirstChild(J) end})
    setmetatable(ScriptStorage.Tools, {__index = function(J, J) return LocalPlayer.Character:FindFirstChild(J) or (LocalPlayer:FindFirstChild('Backpack') and LocalPlayer.Backpack:FindFirstChild(J)) end})
    setmetatable(ScriptStorage.NPCs, {__index = function(J, J) if not J then return end; return workspace.NPCs:FindFirstChild(J) or game.ReplicatedStorage.NPCs:FindFirstChild(J) end})
    function CreateTraceback(J, W) table.insert(ScriptStorage.Tracebacks, (GetCurrentDateTime() .. ' ( ' .. DispTime(os.time() - os.time(), true) .. ' ) after execution | ' .. J .. " | " .. W)) end
    function Report(message)
        pcall(function()
            print("[Kaitun Report]", tostring(message))
            CreateTraceback("Report", tostring(message))
        end)
    end
    function SetTask(J, W)
        if ScriptStorage.Task[J] == W then return end
        local a = {MainTask = "Task1", SubTask = 'Task2'}
        if a[J] then if SetText then SetText(a[J], J .. ' : ' .. W) end end
        ScriptStorage.Task[J] = W
        ScriptStorage.Task[J .. '-d'] = os.time()
    end
    Remotes = {}
    BindedMeleeNPCNames = {BlackLeg = 'Dark Step Teacher', Electro = "Mad Scientist", FishmanKarate = "Water Kung-fu Teacher", DeathStep = "Phoeyu, the Reformed", SharkmanKarate = 'Sharkman Teacher', DragonTalon = "Uzoth", ElectricClaw = 'Previous Hero', Godhuman = "Ancient Monk"}
    local J = {}
    setmetatable(Remotes, {__index = function(W, W)
        if W ~= 'CommF_' then
            print('captured unregistered signal', key)
            return Services.ReplicatedStorage.Remotes[W]
        end
        local W = {InvokeServer = function(a, ...)
            print('remote fired', ...)
            local a, h = ...
            if string.find(a, "Buy") == 1 and not h then
                local h = string.gsub(a, 'Buy', "")
                if BindedMeleeNPCNames then
                    if table.find(J, h) then
                        local a = ScriptStorage.NPCs[BindedMeleeNPCNames[h]]
                        if a then
                            local h = a.WorldPivot
                            if CaculateDistance(h) > 10 then
                                repeat
                                    wait(1)
                                    TweenController.Create(h.Position)
                                until CaculateDistance(h) < 10
                                task.wait(3)
                                Services.ReplicatedStorage.Remotes.CommF_:InvokeServer(...)
                            end
                        end
                    end
                end
            end
            return Services.ReplicatedStorage.Remotes.CommF_:InvokeServer(...)
        end}
        return W
    end})
    Tasks = {}
    function AwaitUntilPlayerLoaded(W, a)
        repeat task.wait() until W.Character and W.Character:FindFirstChild('Humanoid')
        local hum = W.Character.Humanoid
        repeat task.wait() until hum.Health > 0
    end
    function AddPoint()
        local W = {}
        local a
        for h, h in LocalPlayer.Data.Stats:GetChildren() do
            if h and h:FindFirstChild('Level') then W[h.Name] = h.Level.Value end
        end
        if W.Defense < MaxLevel and (W.Defense < (ScriptStorage.PlayerData.Level / 80) or MaxLevel - W.Melee < 100) then
            a = 'Defense'
        elseif W.Melee < MaxLevel then
            a = "Melee"
        else
            a = 'Sword'
        end
        Remotes.CommF_:InvokeServer("AddPoint", a, 999)
    end
    local W = {Currencies = {Level = "#00BFFF", Beli = "#00BFFF", Fragments = "#00BFFF"}, Races = {}}
function RefreshPlayerData()
    pcall(function()
        for a, a in LocalPlayer.Data:GetChildren() do 
            pcall(function() ScriptStorage.PlayerData[a.Name] = a.Value end) 
        end
    end)
    local a = ""
    for h, X in ScriptStorage.PlayerData do
        local w = W.Currencies[h]
        if w then a = a .. '<font color="' .. w .. '">' .. h .. "</font>: " .. X .. ' ' end
    end
    if ScriptStorage.Interface then SetText('Currencies', a) end
end
    function RefreshRace()
        local W, a = Remotes.CommF_:InvokeServer('Alchemist', "1"), Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
        ScriptStorage.PlayerData.RaceLevel = 1
        if LocalPlayer.Character:FindFirstChild("RaceTransformed") then
            ScriptStorage.PlayerData.RaceLevel = 4
        elseif a == -2.0 then
            ScriptStorage.PlayerData.RaceLevel = 3
        elseif W == -2.0 then
            ScriptStorage.PlayerData.RaceLevel = 2
        end
    end
    function RefreshInventory()
        ScriptStorage.Backpack = {}
        local LP = game.Players.LocalPlayer
        local ok, Items = pcall(function() return require(game.ReplicatedStorage.ItemReplicationService)._UserCache[LP.UserId] end)
        if not ok or not Items then
            for W, W in Remotes.CommF_:InvokeServer('getInventory') do ScriptStorage.Backpack[W.Name] = W end
            return
        end
        local Q = Items:GetItems("Quantity")
        local M = Items:GetItems("Mastery")
        local C = require(game.ReplicatedStorage.ItemConfig)
        local W = require(game.ReplicatedStorage.Modules.CombatUtil)
        local mas = {}
        if M then for _, v in pairs(M) do mas[v.ItemId] = v.Value end end
        local function clean(s) return s:gsub(" %[.-%]", "") end
        for _, v in pairs(Q) do
            local id, qt = v.ItemId, v.Value
            local ty, dn = "?", ""
            pcall(function()
                local c = C.match(id):unwrap()
                if c and c.Index then ty = c.Index.IdType; dn = c.Index.DebugLabel end
            end)
            local name = clean(dn)
            if name ~= "" then
                local entry = {Name = name, Count = qt, ItemId = id}
                ScriptStorage.Backpack[name] = entry
                if ty == "Moveset" or ty == "PhysicalMoveset" then
                    local md = mas[id]
                    if md then
                        local wd = W:GetWeaponData(name)
                        if wd then
                            if tostring(wd.WeaponType):find("Sword") then
                                entry.Type = "Sword"
                                entry.Mastery = md
                                entry.MasteryRequirements = {[1] = 350}
                            else
                                ScriptStorage.Melees[name] = md
                            end
                        end
                    end
                end
            end
        end
    end
    function ResearchMoves(W)
        if W and tostring(W) == 'V' then
            if ScriptStorage.Connections.BurstCheck then
                ScriptStorage.Connections.BurstCheck:Disconnect()
                task.wait(1)
            end
            print('[ Debug ] Registering burst', W)
            ScriptStorage.Connections.BurstCheck = W.Cooldown:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                if EnablingBurstDebounce and os.time() - EnablingBurstDebounce < 10 then return end
                local a = W.Cooldown.AbsoluteSize.X
                if a < 3 then
                    EnablingBurstDebounce = os.time()
                    task.wait(5)
                    SendKey('V', 0)
                end
            end)
        end
    end
    function CheckMeleeBurstMove(W)
        if W.Name == "Black Leg" or W.Name == "Death Step" then
            local a = PlayerGui.Main.Skills:WaitForChild(W.Name, 9)
            ResearchMoves(a:WaitForChild("V"))
        end
    end
    function RefreshMelees(W)
        local a = ''
        for h, X in ScriptStorage.Melees do a = a .. h .. ": " .. X .. " " end
        a = a == '' and '[0]' or a
        if W then return a end
        if ScriptStorage.Interface then SetText('Melees', a) end
    end
    function MeleeCheck(W)
        print('Melee check', W)
        if W and typeof(W) == "Instance" and W:IsA("Tool") then
            if W.ToolTip == "Melee" then
                if ScriptStorage.Connections.Melees then ScriptStorage.Connections.Melees:Disconnect() end
                ScriptStorage.CurrentMeleeData.Name = W.Name
                pcall(function() ScriptStorage.Connections.Melees:Destroy() end)
                local lv = W:FindFirstChild("Level")
                if lv then
                    ScriptStorage.Connections.Melees = lv.Changed:Connect(function(a)
                        ScriptStorage.Melees[W.Name] = a
                        RefreshMelees()
                    end)
                    ScriptStorage.Melees[W.Name] = lv.Value
                end
                RefreshMelees()
            elseif string.find(tostring(W), "Fruit") then
                task.spawn(function()
                    if table.find(ScriptStorage.IgnoreStoreFruits, W:GetAttribute('OriginalName')) then return end
                    local a = Remotes.CommF_:InvokeServer("StoreFruit", W:GetAttribute("OriginalName"), W)
                end)
            end
        end
    end
    SetText('MainTextLabel', 'Refreshing Player Data')
    MeleeCheck(LocalPlayer.Character:FindFirstChildOfClass('Tool'))
    RefreshPlayerData()
    function RegisterLocalPlayerEventsConnection()
        task.spawn(function()
            task.wait(6)
            if LocalPlayer.Character:FindFirstChild('HasBuso') then return end
            Remotes.CommF_:InvokeServer("Buso")
        end)
        for W, W in ScriptStorage.Connections.LocalPlayer do pcall(function() W:Disconnect() end) end
        AwaitUntilPlayerLoaded(LocalPlayer)
        LocalPlayer:SetAttribute("IsAvailable", true)
        ScriptStorage.Connections.LocalPlayer["HealthCheck"] = LocalPlayer.Character:WaitForChild("Humanoid"):GetPropertyChangedSignal("Health"):Connect(function()
            local W = LocalPlayer.Character.Humanoid.Health
            LocalPlayer:SetAttribute("IsAvailable", W > 10)
            ScriptStorage.LocalPlayerHealth = W
        end)
        ScriptStorage.Connections.LocalPlayer['Melee'] = LocalPlayer.Character.ChildAdded:Connect(MeleeCheck)
        local bp = LocalPlayer:WaitForChild("Backpack")
        ScriptStorage.Connections.LocalPlayer['Fruit'] = bp.ChildAdded:Connect(MeleeCheck)
        for _, c in ipairs(bp:GetChildren()) do MeleeCheck(c) end
        LastIdleCheck = os.time()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        ScriptStorage.Connections.LocalPlayer.PositionChecker = hrp:GetPropertyChangedSignal('CFrame'):Connect(function()
            if os.time() == LastIdleCheck then return end
            LastIdleCheck = os.time()
            if oldPos then
                if (hrp.CFrame.p - oldPos).magnitude < 2 then return end
            end
            oldPos = (hrp.CFrame.p)
            LastIdling = os.time()
        end)
        local W = LocalPlayer.Data:WaitForChild('Points')
        ScriptStorage.Connections.LocalPlayer.PointConnection = W:GetPropertyChangedSignal('Value'):Connect(function()
            local W = LocalPlayer.Data:WaitForChild('Points')
            if OldPointValue == W then return end
            OldPointValue = W
            AddPoint()
        end)
    end
    RegisterLocalPlayerEventsConnection(LocalPlayer)
    game.Players.LocalPlayer.CharacterAdded:Connect(function(W)
        print('[ Debug ] re-registering events')
        RegisterLocalPlayerEventsConnection(LocalPlayer)
    end)
    task.spawn(function()
        task.wait(3)
        if LocalPlayer.Character:FindFirstChild("HasBuso") then return end
        Remotes.CommF_:InvokeServer("Buso")
    end)
    print(1)

    -- ============================================================
    -- BẢNG MELEE & DATA (GIỮ NGUYÊN)
    -- ============================================================
    MeleesTable = {"Black Leg", 'Electro', "Fishman Karate", "Dragon Claw", "Superhuman", 'Death Step', 'Electric Claw', 'Sharkman Karate', 'Dragon Talon', "Godhuman"}
    MeleesId = {'BlackLeg', "Electro", 'FishmanKarate', "DragonClaw", "Superhuman", 'DeathStep', "ElectricClaw", "SharkmanKarate", 'DragonTalon', 'Godhuman'}
    MeleePrices = {["Black Leg"] = {Price = {Beli = 150000}, Id = "BlackLeg", NextLevelRequirement = 300, position = CFrame.new(), Requirements = function() return true end, Buy = function(W) return BuyMelee("BlackLeg", W, 'Dark Step Teacher') end}, ['Electro'] = {Price = {Beli = 500000}, Id = 'Electro', NextLevelRequirement = 300, Requirements = function() return true end, Buy = function(W) return BuyMelee('Electro', W, "Mad Scientist") end}, ['Fishman Karate'] = {Price = {Beli = 750000}, NextLevelRequirement = 300, Requirements = function() return true end, Buy = function(W) return BuyMelee('FishmanKarate', W, 'Water Kung-fu Teacher') end}, ['Dragon Claw'] = {Price = {Fragments = 1500}, NextLevelRequirement = 300, Requirements = function() return true end, Buy = function(W) return BuyMelee("DragonClaw", W, "Sabi") end}, ["Superhuman"] = {Price = {Beli = 3000000}, NextLevelRequirement = nil, Requirements = function() return true end, Buy = function(W) return BuyMelee("Superhuman", W, "Martial Arts Master") end}, ["Death Step"] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("DeathStep", W, "Phoeyu, the Reformed") end}, ['Sharkman Karate'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee('SharkmanKarate', W, 'Sharkman Teacher') end}, ['Electric Claw'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("ElectricClaw", W, 'Previous Hero') end}, ['Dragon Talon'] = {Price = {Beli = 2500000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("DragonTalon", W, 'Uzoth') end}, ["Godhuman"] = {Price = {Beli = 5000000, Fragments = 5000}, NextLevelRequirement = 400, Requirements = function() return true end, Buy = function(W) return BuyMelee("Godhuman", W, 'Ancient Monk') end}}
    DropItemData = {['Buddy Sword'] = {Sea = 3, Level = 1500, Boss = "Cake Queen"}, ['Canvander'] = {Sea = 3, Level = 1500, Boss = "Beautiful Pirate"}, ['Twin Hooks'] = {Sea = 3, Level = 1500, Boss = 'Captain Elephant'}, ["Venom Bow"] = {Sea = 3, Level = 1500, Boss = "Hydra Leader"}}
    GodhumanMaterials = {['Fish Tail'] = {20, 3, {"Fishman Raider", "Fishman Captain"}, {'DeepForestIsland3', 1, 1775, 'Turtle Adventure Quest Giver'}}, ['Dragon Scale'] = {10, 3, {"Dragon Crew Warrior", "Dragon Crew Archer"}, {'DragonCrewQuest', 1, 1575, 'Dragon Crew Quest Giver'}}, ["Magma Ore"] = {20, 2, {'Magma Ninja'}, {"FireSideQuest", 1, 1100, "Fire Quest Giver"}}, ["Mystic Droplet"] = {10, 2, {'Sea Soldier', 'Water Fighter'}, {'ForgottenQuest', 2, 1425, 'Forgotten Quest Giver'}}}
    SeaIndexes = {"Main", "Dressrosa", "Zou"}
    TasksOrder = {"LevelFarm", "Tushita", 'Yama', "SpecialBossesTask", "RaidController", "AutoRaidIce", 'Trevor', "UtillyItemsActivitation", 'ColosseumPuzzle', "Wenlocktoad", "ThirdSeaPuzzle", "PirateRaid", "SecondSeaPuzzle", 'ThirdSeaPuzzle', "CollectDrops", 'BossesTask', "ExpRedeem", "MeleesController"}
    MaxLevel = 2800
    placeId = game.PlaceId
    if placeId == 85211729168715 or placeId == 2753915549 then
        Sea = 'Main'
        SeaIndex = 1
    elseif placeId == 79091703265657 or placeId == 4442272183 then
        Sea = "Dressrosa"
        SeaIndex = 2
    elseif placeId == 100117331123089 or placeId == 7449423635 then
        Sea = "Zou"
        SeaIndex = 3
    end
    Portals = ({{Vector3.new(-7894.6201171875, 5545.49169921875, -380.246346191406), Vector3.new(-4607.82275390625, 872.5422973632812, -1667.556884765625), Vector3.new(61163.8515625, 11.759522438049316, 1819.7841796875), Vector3.new(3876.280517578125, 35.10614013671875, -1939.3201904296875)}, {Vector3.new(-288.46246337890625, 306.130615234375, 597.9988403320312), Vector3.new(2284.912109375, 15.152046203613281, 905.48291015625), Vector3.new(923.21252441406, 126.9760055542, 32852.83203125), Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422)}, {}})[SeaIndex]
    BossesOrder = {"Awakened Ice Admiral", "Tide Keeper", 'Deandre', "Urban", "Diablo", 'Soul Reaper', 'Cake Prince'}
    BossesOrderLevel = {['Awakened Ice Admiral'] = 700, ['Tide Keeper'] = 700, ['Deandre'] = 1500, ['Urban'] = 1500, ['Diablo'] = 1500, ["Cake Prince"] = 1500, ['Soul Reaper'] = 1500}
    BossesOrderWL = {["Deandre"] = 1500, ["Urban"] = 1500, ["Diablo"] = 1500, ['Cake Prince'] = 1500, ['Don Swan'] = 1100, ["Awakened Ice Admiral"] = 700, ['Tide Keeper'] = 700}
    SpecialBossesOrder = {["Core"] = 700, ['Darkbeard'] = 700}
    BlankTablets = {"Segment6", 'Segment2', 'Segment8', "Segment9", 'Segment5'}
    Trophy = {["Segment1"] = "Trophy1", ["Segment3"] = "Trophy2", ['Segment4'] = "Trophy3", ['Segment7'] = "Trophy4", ["Segment10"] = "Trophy5"}
    Pipes = {['Part1'] = 'Really black', ['Part2'] = 'Really black', ["Part3"] = "Dusty Rose", ['Part4'] = "Storm blue", ['Part5'] = 'Really black', ['Part6'] = "Parsley green", ["Part7"] = 'Really black', ["Part8"] = "Dusty Rose", ["Part9"] = 'Really black', ['Part10'] = 'Storm blue'}
    function GenerateUUID()
        local W = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
        return string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", '[xy]', function(W)
            local W = (Idx == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
            return string.format('%x', W)
        end)
    end
    function CheckIsPlayerAlive(W) W = W or LocalPlayer; return W and W.Character and W.Character.Humanoid and W.Character.HumanoidRootPart and W.Character.Head and W.Character.Humanoid.Health > 0 end
    function ConvertTo(W, a) return W.new(a.X, a.Y, a.Z) end
    function CaculateDistance(W, a)
        if not W then return 0 end
        a = a or game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        local h, X = ConvertTo(Vector3, W), ConvertTo(Vector3, a)
        return (h - X).magnitude
    end
    function DispTime(W, a)
        W = tonumber(W)
        if not W then return "[err]" end
        local h = math.floor(W / 86400)
        local X = math.floor(math.fmod(W, 86400) / 3600)
        local w = math.floor(math.fmod(W, 3600) / 60)
        local D = math.floor(math.fmod(W, 60))
        if a then return (h .. "day, " .. X .. "hrs, " .. w .. "min, " .. D .. 'sec.') end
        return (h .. 'day, ' .. X .. "hrs.")
    end
    function GetCurrentDateTime()
        local W = os.date("*t")
        local a = W.hour
        local h = W.min
        local X = W.day
        local w = W.month
        local D = W.year
        local y = W.wday
        local W = string.format('%02d:%02d ', a, h)
        local a = {'Sun', "Mon", 'Tue', "Wed", 'Thu', "Fri", 'Sat'}
        local h = a[y]
        local a = {"Jan", "Feb", "Mar", 'Apr', "May", 'Jun', "Jul", 'Aug', 'Sep', "Oct", 'Nov', "Dec"}
        local y = a[w]
        local a = string.format('%s, %s %d %d', h, y, X, D)
        return W .. a
    end
    function RandomArguments(...) local W = {...}; return W[math.random(0, #W)] end
    function RoundVector3Down(W) return Vector3.new(math.floor(W.X / 10) * 10, math.floor(W.Y / 10) * 10, math.floor(W.Z / 10) * 10) end

    -- ============================================================
    -- XOAY VÒNG TRÒN CŨ (DÙNG TICK)
    -- ============================================================
    CaculateCircreDirection = function(a)
        if W_angle > 50000 then W_angle = 60 end
        W_angle = W_angle + ((tick() - lastChange) > 0.4 and 80 or 0)
        if tick() - lastChange > 0.4 then lastChange = tick() end
        local h = a + Vector3.new(math.cos(math.rad(W_angle)) * 40, 0, math.sin(math.rad(W_angle)) * 40)
        return CFrame.new(RoundVector3Down(h.p))
    end

    function GetMonAsSortedRange()
        local W = {}
        table.foreach(Services.Workspace.Enemies:GetChildren(), function(a, a)
            if a and a:FindFirstChild('Humanoid') and a:FindFirstChild("HumanoidRootPart") and a.Humanoid.Health > 0 then
                table.insert(W, a)
            end
        end)
        table.foreach(game.ReplicatedStorage:GetChildren(), function(a, a)
            if a and a:FindFirstChild('Humanoid') and a:FindFirstChild("HumanoidRootPart") and a.Humanoid.Health > 0 then
                table.insert(W, a)
            end
        end)
        table.sort(W, function(a, h) return CaculateDistance(a.HumanoidRootPart.CFrame) < CaculateDistance(h.HumanoidRootPart.CFrame) end)
        return W
    end
    print(1.5)
    function GetMeleeIdByName(W) for a, h in MeleesTable do if h == W then return MeleesId[a] end end end
    function FindMeleeNPC(npcName)
        for _, npc in pairs(workspace.NPCs:GetChildren()) do
            if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
                return npc.HumanoidRootPart.Position
            end
        end
        return nil
    end
    function getpos(W)
        for a, a in game:GetService("ReplicatedStorage").NPCs:GetChildren() do if a.Name == W then return a.HumanoidRootPart.CFrame end end
        for a, a in workspace.NPCs:GetChildren() do if a.Name == W then return a.HumanoidRootPart.CFrame end end
    end

    -- ============================================================
    -- HÀM HỖ TRỢ AUTO FULL MELEE
    -- ============================================================
    function GetBP(meleeName)
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp and bp:FindFirstChild(meleeName) then return bp[meleeName] end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild(meleeName) then return char[meleeName] end
        return nil
    end

    function GetM(matName)
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if not bp then return 0 end
        for _, v in pairs(bp:GetChildren()) do
            if v.Name == matName and v:FindFirstChild("Count") then
                return v.Count.Value
            end
        end
        return 0
    end

    function GetConnectionEnemies(enemyName)
        local nearest, dist = nil, math.huge
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy.Name == enemyName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                local root = enemy:FindFirstChild("HumanoidRootPart")
                if root then
                    local d = (root.Position - hrp.Position).Magnitude
                    if d < dist then
                        dist = d
                        nearest = enemy
                    end
                end
            end
        end
        return nearest
    end

    function BuyMelee(W, a)
        if W == "DragonClaw" then
            if workspace.NPCs:FindFirstChild('Sabi') then
                if a then
                    if type(Remotes.CommF_:InvokeServer("BlackbeardReward", 'DragonClaw', '1') == 1) == "number" and Remotes.CommF_:InvokeServer('BlackbeardReward', 'DragonClaw', '1') == 1 == 1 and not table.find(J, W) then table.insert(J, W) end
                    return Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
                end
                return Remotes.CommF_:InvokeServer('BlackbeardReward', "DragonClaw", '2')
            end
        end
        if a then
            local a = Remotes.CommF_:InvokeServer('Buy' .. W, true)
            print("Response_", a == 1, typeof(a))
            if type(a) == 'number' and not table.find(J, W) then table.insert(J, W) end
            return a == 1
        end
        return Remotes.CommF_:InvokeServer("Buy" .. W)
    end

    function SendKey(J, W)
        (function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, J, false, game)
            task.wait(W)
            game:GetService('VirtualInputManager'):SendKeyEvent(false, J, false, game)
        end)()
    end

    function FruitIdToName(J)
        local W = string.match(J, "((%u)[^%-]+)$")
        return W .. ' Fruit'
    end
    function Split(J, W)
        if W == nil then W = "%s" end
        local a = {}
        for h in string.gmatch(J, '([^' .. W .. ']+)') do table.insert(a, h) end
        return a
    end
    function FruitNameToId(J)
        local W = Split(J)[1]
        return W .. '-' .. W
    end

    -- ============================================================
    -- J QUESTS
    -- ============================================================
    local J = {CurrentLevel = 2, DoubleQuest = true, CurrentQuests = {}, BlacklistedQuestIds = {BartiloQuest = 1, CitizenQuest = 1, Trainees = 1, MarineQuest = 1, ImpelQuest = 1}}
    local W = require(game.ReplicatedStorage.GuideModule).Data.NPCList
    repeat task.wait() until game.Players.LocalPlayer.DataLoaded and ScriptStorage
    J.Quests = require(game.ReplicatedStorage.Quests)
    function J.Set(W, a, h) W[a] = h end
    function J.RefreshQuest(W)
        local timeout = os.time()
        while not ScriptStorage.PlayerData.Level do
            task.wait(1)
            print('[ Debug ] Waiting for LocalPlayer datas.')
            if os.time() - timeout > 30 then
                print('[ Debug ] Timeout waiting for player data, skipping quest refresh')
                return
            end
        end
        local a = 0
        local h
        for X, w in J.Quests do
            if not J.BlacklistedQuestIds[X] then
                if (w[1].LevelReq >= a and w[1].LevelReq <= ScriptStorage.PlayerData.Level) then
                    a = w[1].LevelReq
                    h = w
                    W.CurrentQuestId = X
                    if ScriptStorage.PlayerData.Level >= 1500 and SeaIndex == 2 and X == 'ForgottenQuest' then break end
                end
            end
        end
        local a = h[#h]
        for X, X in a.Task do if X == 1 then table.remove(h, #h) end end
        for a, X in require(game.ReplicatedStorage.GuideModule).Data.NPCList do
            for w, w in X.Levels do if w == h[#h].LevelReq then W.CurrentNpc = a.CFrame end end
        end
        W.CurrentQuests = h
    end
    function J.GetCurrentQuest(W)
        local a = W.CurrentQuests[W.CurrentLevel] and W.CurrentQuests[W.CurrentLevel].LevelReq <= ScriptStorage.PlayerData.Level and W.CurrentLevel or 1
        for h in W.CurrentQuests[a].Task do return h, W.CurrentNpc, W.CurrentQuestId, a, W.CurrentQuests[a].Name end
    end
    function J.MarkAsCompleted(W) W.CurrentLevel = W.CurrentLevel == 2 and 1 or 2 end
    function J.AbandonQuest()
        print('Abandon Quest')
        Remotes.CommF_:InvokeServer("AbandonQuest")
    end
    function J.GetCurrentClaimQuest(W)
        local W = game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:gsub("%s*Defeat%s*(%d*)%s*(.-)%s*%b()", '%2')
        return (type(W) == "string" and string.gsub(W, "Military ", "Mil. ") or W), game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
    end
    function J.StartQuest(W, a)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer('ColorsDealer', "2")
        return Remotes.CommF_:InvokeServer("StartQuest", W, a)
    end

    -- ============================================================
    -- SCRIPTSTORAGE MOB REGIONS
    -- ============================================================
    ScriptStorage.MobRegions = {}
    for W, W in game:GetService("ReplicatedStorage").FortBuilderReplicatedSpawnPositionsFolder:GetChildren() do
        ScriptStorage.MobRegions[tostring(W)] = ScriptStorage.MobRegions[tostring(W)] or {}
        table.insert(ScriptStorage.MobRegions[tostring(W)], W.CFrame)
    end

    -- ============================================================
    -- TWEEN CONTROLLER
    -- ============================================================
    TweenController = {}
    local W = 0
    local W = {}
    for a, a in game.ReplicatedStorage.NPCs:GetChildren() do if a.Name == 'Set Home Point' then table.insert(W, a:GetModelCFrame()) end end
    function TweenController.Update()
        local a = game.Players.LocalPlayer.Character.HumanoidRootPart
        HumanoidRootPart = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        if CaculateDistance(a.CFrame) > 250 then
            pcall(function() TweenInstance:Cancel() end)
            TweenDebounce = true
            a.CFrame = HumanoidRootPart.CFrame
            TweenDebounce = false
        end
        HumanoidRootPart.CFrame = a.CFrame + Vector3.new(0, 3, 0)
    end
    function GetPortal(a)
        local h, X = 9e9, nil
        for w, w in Portals do
            local D = CaculateDistance(w, a)
            if D < (CaculateDistance(a) - 300) and D < h then
                h = D
                X = w
            end
        end
        if X then
            Remotes.CommF_:InvokeServer("requestEntrance", X)
            return task.wait()
        end
    end
    function GetEntries(a)
        local h, X = 9e9, nil
        for w, w in W do
            local W = CaculateDistance(w, a)
            if W < (CaculateDistance(a) - 700) and W < h then
                h = W
                X = w
            end
        end
        if X then if os.time() - 0 > 30 then for W = 1, 10, 1 do task.wait() end end end
    end
    function TweenController.Tween2(W, a)
        TweenInstance2 = Services.TweenService:Create(W, TweenInfo.new(CaculateDistance(W.CFrame, a) / 50, Enum.EasingStyle.Linear), {CFrame = ConvertTo(CFrame, a) - Vector3.new(0, 0, 0)})
        TweenInstance2:Play()
    end
    function CheckItem(itemName)
        local bp = game.Players.LocalPlayer:FindFirstChild('Backpack')
        for _, v in next, bp and bp:GetChildren() or {} do
            if v:IsA('Tool') and (v.Name == itemName or string.find(v.Name, itemName)) then return v end
        end
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in next, char:GetChildren() do
                if v:IsA('Tool') and (v.Name == itemName or string.find(v.Name, itemName)) then return v end
            end
        end
        return false
    end
    function CheckLegendaryItems()
        return CheckItem("God's Chalice") or CheckItem("Fist of Darkness") or CheckItem("Sweet Chalice") or CheckItem("Hallow Essence") or CheckItem("Flower1")
    end
    function InArea(pos)
        local WorldOrigin = workspace:FindFirstChild("_WorldOrigin")
        if not WorldOrigin or not WorldOrigin:FindFirstChild("Locations") then return nil end
        local posVec = typeof(pos) == "CFrame" and pos.Position or pos
        local best, bestScale = nil, 0
        for _, v in next, WorldOrigin.Locations:GetChildren() do
            if v:FindFirstChild("Mesh") and (posVec - v.Position).Magnitude <= (v.Mesh.Scale.X / 2) + 500 then
                if v.Mesh.Scale.X > bestScale then
                    bestScale = v.Mesh.Scale.X
                    best = v
                end
            end
        end
        return best
    end
    function GetSpawnPoint(pos)
        local spawns = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("PlayerSpawns") and workspace._WorldOrigin.PlayerSpawns:FindFirstChild(game.Players.LocalPlayer.Team.Name)
        if not spawns then return nil end
        local posVec = typeof(pos) == "CFrame" and pos.Position or typeof(pos) == "Vector3" and pos or pos.Position
        for _, v in next, spawns:GetChildren() do
            if v:FindFirstChild("Part") and (v.Part.Position - posVec).Magnitude <= 2500 then
                return v
            end
        end
        return nil
    end
    function CanBypassTeleport(targetPos)
        local area = InArea(targetPos)
        if not area then return false end
        local areaName = area.Name
        if areaName:find("Dimension") or areaName:find("Submerged") or areaName == "Sealed Cavern" or areaName:lower():find("under") then return false end
        if CheckLegendaryItems() then return false end
        local data = game.Players.LocalPlayer:FindFirstChild("Data")
        local lso = data and data:FindFirstChild("LastSpawnPoint")
        if lso and lso.Value == "SubmergedIsland" then return false end
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        if (targetPos - hrp.Position).Magnitude <= 3500 then return false end
        return true
    end
    function GetBypassCFrame(targetPos)
        local bestVal, bestSpawn = math.huge, nil
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local spawns = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("PlayerSpawns") and workspace._WorldOrigin.PlayerSpawns:FindFirstChild(game.Players.LocalPlayer.Team.Name)
        if not spawns then return nil end
        local currentSpawn = GetSpawnPoint(hrp)
        for _, v in next, spawns:GetChildren() do
            if v:FindFirstChild("Part") then
                local toTarget = (targetPos - hrp.Position).Magnitude
                local spawnToPlayer = (v.Part.Position - hrp.Position).Magnitude
                local spawnToTarget = (v.Part.Position - targetPos).Magnitude
                local spawnPoint = GetSpawnPoint(v.Part)
                if toTarget >= 3000 and spawnPoint ~= currentSpawn and spawnToPlayer <= 10000 and spawnToTarget <= bestVal then
                    bestVal = spawnToTarget
                    bestSpawn = v
                end
            end
        end
        return bestSpawn
    end
    function BypassTP(targetPos)
        if not CanBypassTeleport(targetPos) then return false end
        local targetSpawn = GetBypassCFrame(targetPos)
        if not targetSpawn then return false end
        local char = game.Players.LocalPlayer.Character
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        pcall(function() char.LastSpawnPoint.Disabled = true end)
        Remotes.CommF_:InvokeServer("SetLastSpawnPoint", targetSpawn.Name)
        Remotes.CommF_:InvokeServer("SetSpawnPoint")
        char:PivotTo(targetSpawn.Part.CFrame)
        hum:ChangeState(15)
        repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0
        return true
    end

    -- ============================================================
    -- [FIXED] TWEEN CONTROLLER - GIỮ NGUYÊN 200/190
    -- ============================================================
    function TweenController.Create(W)
        if not W or TweenDebounce then return end
        local a = typeof(W) ~= 'CFrame' and ConvertTo(CFrame, W) or W
        if TweenInstance then pcall(function() TweenInstance:Cancel() end) end
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local dist = CaculateDistance(a)
        if dist >= 5000 then
            if BypassTP(a.Position) then return end
        end
        for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        local head = game.Players.LocalPlayer.Character:WaitForChild("Head")
        if not head:FindFirstChild("eltrul") then
            local bv = Instance.new('BodyVelocity')
            bv.Name = "eltrul"
            bv.MaxForce = Vector3.new(0, math.huge, 0)
            bv.Velocity = Vector3.zero
            bv.Parent = head
        end
        if CaculateDistance(a) > 500 then
            if SeaIndex == 3 and not ScriptStorage.Backpack['Valkyrie Helm'] then
            elseif SeaIndex ~= 3 then
                print(a)
                GetPortal(a)
            end
        end
        if CaculateDistance(Vector3.new(11256, -2138.0, 9888), a) < (CaculateDistance(a) - 700) and SeaIndex == 3 then
            local gatePos = CFrame.new(-16269.0, 23, 1371)
            if CaculateDistance(gatePos) > 60 then
                TweenController.Create(gatePos)
                task.wait(1)
                return
            end
            local net = require(game.ReplicatedStorage.Modules.Net)
            net:RemoteFunction('SubmarineWorkerSpeak'):InvokeServer('TravelToSubmergedIsland')
        end
        a = CFrame.new(a.Position)
        local W = CaculateDistance(hrp.CFrame, a)
        local h = hrp.CFrame
        hrp.CFrame = CFrame.new(h.x, a.y, h.z)
        if W <= 5 then
            hrp.CFrame = a
            return
        end
        local divisor
        if W < 100 then
            divisor = 200
        else
            divisor = 190
        end
        local duration = W / divisor
        TweenInstance = Services.TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Sine), {CFrame = a})
        TweenInstance:Play()
    end

    -- ============================================================
    -- FAST ATTACK & EQUIP WEAPON (LẤY TỪ TEST.TXT - GIỮ NGUYÊN)
    -- ============================================================
    local W = {}
    local a = game:GetService('Players')
    local h = game:GetService("RunService")
    local h = game:GetService('ReplicatedStorage')
    local X = game:GetService("Workspace")
    local X = game:GetService("VirtualInputManager")
    local X = a.LocalPlayer
    local X = h:WaitForChild('Modules')
    local w = X:WaitForChild("Net")
    local X = w:WaitForChild("RE/RegisterAttack")
    local X = w:WaitForChild('RE/RegisterHit')
    local X = w:WaitForChild('RE/ShootGunEvent')
    local X = h:WaitForChild("Remotes"):WaitForChild('Validator2')
    local h = game.ReplicatedStorage.Modules
    local X = h.Net
    local h, h = X:WaitForChild("RE/RegisterHit"), X:WaitForChild('RE/RegisterAttack')
    local h = {}
    function GetAllBladeHits()
        bladehits = {}
        for X, X in pairs(workspace.Enemies:GetChildren()) do
            if X:FindFirstChild('Humanoid') and X:FindFirstChild('HumanoidRootPart') and X.Humanoid.Health > 0 and (X.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 65 then
                table.insert(bladehits, X)
            end
        end
        return bladehits
    end
    function Getplayerhit()
        bladehits = {}
        for X, X in pairs(workspace.Characters:GetChildren()) do
            if X.Name ~= game.Players.LocalPlayer.Name and X:FindFirstChild('Humanoid') and X:FindFirstChild('HumanoidRootPart') and X.Humanoid.Health > 0 and (X.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 65 then
                table.insert(bladehits, X)
            end
        end
        return bladehits
    end
    local X = (Services.ReplicatedStorage.Modules.Net)
    local w = require(X):RemoteEvent("RegisterAttack", true)
    local D = require(X):RemoteEvent("RegisterHit", true)
    function h:Attack()
        local X = {}
        for y, y in pairs(GetAllBladeHits()) do table.insert(X, y) end
        for y, y in pairs(Getplayerhit()) do table.insert(X, y) end
        if #X == 0 then return end
        local y = {[1] = nil, [2] = {}, [4] = "078da5141"}
        for L, L in pairs(X) do
            w:FireServer(0)
            if not y[1] then y[1] = L.Head end
            table.insert(y[2], {[1] = L, [2] = L.HumanoidRootPart})
            table.insert(y[2], L)
        end
        D:FireServer(unpack(y))
    end
    task.spawn(function()
        while task.wait(.06) do if _G.FastAttack == os.time() then pcall(function() h:Attack() end) end end
    end)
function W.Attack(target) pcall(function() _G.FastAttack = os.time() end) end

    CombatController = {GRAB = false, GRAB_DISTANCE = SeaIndex == 1 and 250 or 350, MAX_ATTACK_DURATION = 2, MAX_ATTACK_DURATION_2 = 60, LEVITATE_TIME = 0, CurrentIndex = 1}
    LastFound = os.time()
    function CombatController.Grab(mobName)
        pcall(sethiddenproperty, game.Players.LocalPlayer, 'SimulationRadius', math.huge)
        if not CombatController.GRAB or GrabDebounce == os.time() then return end
        GrabDebounce = os.time()
        if not MonResult or not MonResult:FindFirstChild('HumanoidRootPart') then return end
        local targetPos = MonResult.HumanoidRootPart.Position
        local AreaMob = false
        for _, enemy in Services.Workspace.Enemies:GetChildren() do
            if enemy ~= MonResult and enemy.Name == mobName then
                local hum = enemy:FindFirstChildOfClass("Humanoid")
                local root = enemy:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.Health > 0 then
                    local dist = (root.Position - targetPos).Magnitude
                    if dist <= 3000 then
                        local bv = root:FindFirstChild('FarmingVelocity')
                        if not bv then
                            bv = Instance.new('BodyVelocity')
                            bv.Name = 'FarmingVelocity'
                            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                            bv.Velocity = Vector3.zero
                            bv.Parent = root
                        end
                        if dist <= 10 then
                            AreaMob = true
                        end
                        if not AreaMob and (not isnetworkowner or pcall(isnetworkowner, root)) then
                            root.CFrame = MonResult.HumanoidRootPart.CFrame
                        end
                        enemy:SetAttribute('IsGrabbed', true)
                    end
                end
            end
        end
    end
    function Sort1(entity) return entity and entity:FindFirstChild("HumanoidRootPart") and math.floor(CaculateDistance(entity.HumanoidRootPart.CFrame)) end
    function CombatController.Search(names)
        local candidates = {}
        local anyFound = false
        for _, entity in GetMonAsSortedRange() do
            if table.find(names, entity.Name) and entity:FindFirstChild("Humanoid") and entity.Humanoid.Health > 0 then
                if (entity:GetAttribute('FailureCount') or 0) < 3 then
                    anyFound = true
                    table.insert(candidates, entity)
                end
            end
        end
        table.sort(candidates, function(entity, other) return Sort1(entity) < Sort1(other) end)
        if anyFound then
            local best = candidates[1]
            return best
        end
        for _, npcName in names do
            local npc = game.ReplicatedStorage:FindFirstChild(npcName)
            if npc then return npc end
        end
    end
    function CombatController.Attack(h, X, w, D)
        if ScriptStorage.Tools["Sweet Chalice"] and getsenv(game.ReplicatedStorage.GuideModule)["_G"]['InCombat'] then
            TweenController.Create(Vector3.new(0, 0, 0))
            return
        end
        sethiddenproperty(game.Players.LocalPlayer, 'SimulationRadius', math.huge)
        h = type(h) == "string" and {h} or (h or {})
        for y, L in (h) do
            local b = tostring(L)
            if b == 'Deandre' or b == "Urban" or b == "Diablo" and (os.time() - (LastFire12 or 0)) > 180 then
                LastFire12 = os.time()
                Remotes.CommF_:InvokeServer("EliteHunter")
            end
            if X then
                local b = GetMonAsSortedRange()[1]
                local C = b and b:FindFirstChild('HumanoidRootPart') and b.HumanoidRootPart.Position
                if C and CaculateDistance(C) < w then MonResult = b end
            else
                MonResult = CombatController.Search(h)
            end
            if MonResult then
                LastFound = os.time()
                local h, w = 0, os.time()
                SetTask('SubTask', '⚔️ Attacking ' .. tostring(MonResult.Name))
                local w, b = 0, os.time()
                while task.wait() do
                    if _G.Stop then return end
                    if ScriptStorage.Tools["Sweet Chalice"] and getsenv(game.ReplicatedStorage.GuideModule)["_G"]["InCombat"] then
                        TweenController.Create(Vector3.new(0, 0, 0))
                        return
                    end
                    local C = MonResult:FindFirstChild('Humanoid')
                    local p = MonResult:FindFirstChild('HumanoidRootPart')
                    if not C or C.Health <= 0 then
                        if MonResult.Name == "Don Swan" then Storage:Set("SwanDefeated", true) end
                        break
                    end
                    TweenController.Create(CaculateCircreDirection(p.CFrame) + Vector3.new(0, 35, 0))
                    if CaculateDistance(p.Position + Vector3.new(0, 35, 0)) < 150 then
                        y = D and D()
                        CombatController.Grab(L or '')
                        if MonResult.Name ~= "Core" then
                            if ScriptStorage.PlayerData.Level > 100 and w >= CombatController.MAX_ATTACK_DURATION_2 and C.Health - C.MaxHealth == 0 then
                                SetTask('SubTask', 'Hop Server - Mob Health Unchanged ( ' .. C.Health .. ' / ' .. C.MaxHealth .. ')')
                                alert("stuck", "Mob health unchanged")
                                _G.Stop = true
                                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
                            end
                            if h >= CombatController.MAX_ATTACK_DURATION and C.Health - C.MaxHealth == 0 then
                                h = 0
                                local D = MonResult:GetAttribute('OldPosition')
                                if D then
                                    MonResult:SetPrimaryPartCFrame(CFrame.new(D))
                                    MonResult:SetAttribute('IgnoreGrab', true)
                                    MonResult:SetAttribute('FailureCount', (MonResult:GetAttribute("FailureCount") or 0) + 1)
                                    alert('Failed to attack', "Returning to the old posiiton ( #" .. MonResult:GetAttribute("FailureCount") .. " )")
                                    MonResult.HumanoidRootPart.CFrame = (CFrame.new(D))
                                    task.wait()
                                    return
                                end
                            end
                        end
                        if (FarmFruitMastery or math.huge) - os.time() < 3 and math.floor(MonResult.Humanoid.Health / MonResult.Humanoid.MaxHealth * 100) < 30 and not FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
                            TweenController.Create((p.CFrame) + Vector3.new(0, 25, 0))
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Blox Fruit')
                            LockAimPositionTo(MonResult.HumanoidRootPart.CFrame.p)
                            local D = {'Z', 'X', "C", 'V'}
                            local y = D[math.random(1, #D)]
                            SendKey(y, .31)
                        else
                            -- [FIXED] Ưu tiên dùng _G.SelectWeapon nếu có
                            if _G.SelectWeapon and CheckItem(_G.SelectWeapon) then
                                FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(_G.SelectWeapon)
                            else
                                FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(ScriptStorage.ForceToUseSword and 'Sword' or "Melee")
                            end
                        end
                        W:Attack(MonResult)
                        if os.time() ~= b then
                            b = os.time()
                            h = h + 1
                            w = w + 1
                        end
                        if h > 30 and MonResult.Name ~= "Core" then
                            alert("Take more than 30s to attack, canceling")
                            break
                        end
                    end
                end
            elseif not X then
                if (os.time() - LastFound) > 200 then
                    alert('MeyyHub', 'Error while farming, rejoin')
                    game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
                    return
                end
                local h = ScriptStorage.MobRegions[L]
                if not h then
                    local X = Services.Workspace.Enemies:FindFirstChild(L) or game.ReplicatedStorage:FindFirstChild(L)
                    h = X and {X:GetPrimaryPartCFrame().p}
                end
                if not h then
                    Report('[ Game data error ] Mob with name ' .. tostring(L) .. ' have no spawn region datas')
                    return
                end
                local X
                if not h[CombatController.CurrentIndex] then CombatController.CurrentIndex = 1 end
                X = h[CombatController.CurrentIndex]
                local h = os.time()
                TweenController.Create(X + Vector3.new(0, 35, 35))
                if CaculateDistance(X + Vector3.new(0, 35, 35)) < 15 then CombatController.CurrentIndex = CombatController.CurrentIndex + 1 end
            end
        end
    end
    LevelFarmTTL = 0
    LastTravel = os.time()
    FunctionsHandler = {Initalized = false}
    print(3000)
    setmetatable(FunctionsHandler, {__index = function(h, X)
        QueryResult = rawget(h, X)
        if not QueryResult then
            return {
                Register = function(w)
                    if w == false then return end
                    Result = {CacheListener = {}, RealCache = {}, Methods = {}, Constants = {}, Events = {}, Initalized = true}
                    function Result.RegisterMethod(w, D, y)
                        w.Methods[D] = {Name = D, Callback = y, Call = function(w, ...) return w.Callback(...) end, Events = {}}
                        return true
                    end
                    setmetatable(Result.Constants, {__newindex = function() assert(false, 'cannot change constant value!') end})
                    if h.Constants[Key] then
                        function Result.SaveConstant(w, w, w) return assert(false, 'constant name was used before!') end
                        rawset(h.Constants, Key, Value)
                    end
                    function Result.Set(h, w, D)
                        h.CacheListener[w] = D
                        return D
                    end
                    function Result.Get(h, w) return h.Constants[w] or h.RealCache[w] end
                    function Result.AddVariableChangeListener(h, w, D) h.Events[w] = D end
                    Result.CacheListener.__parent = Result
                    setmetatable(Result.CacheListener, {__newindex = function(h, w, D)
                        _ = h.__parent.Events[w] and h.__parent.Events[w](w, D)
                        h.__parent.RealCache[w] = D
                    end})
                    FunctionsHandler[X] = Result
                end, Initalized = false
            }
        end
        return QueryResult
    end})
    function FunctionsHandler.SynchorizeUntilModuleLoaded(h, X)
        local w = os.time()
        while not h.Initalized do
            task.wait()
            local h = os.time() - w
            assert(not (X and h > X), "timed out")
        end
    end
    function GetCurrentClaimQuest(h)
        local h = game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:gsub("%s*Defeat%s*(%d*)%s*(.-)%s*%b()", "%2")
        return (type(h) == "string" and string.gsub(h, "Military ", "Mil. ") or h), game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
    end
    FunctionsHandler.LocalPlayerController.Register()
    FunctionsHandler.ExpRedeem:Register()
    FunctionsHandler.LevelFarm:Register()
    FunctionsHandler.Saber:Register()
    FunctionsHandler.Rengoku:Register()
    FunctionsHandler.Yama:Register()
    FunctionsHandler.Tushita:Register()
    FunctionsHandler.SpikeyTrident:Register()
    FunctionsHandler.SharkAchor:Register()
    FunctionsHandler.Pole:Register()
    FunctionsHandler.FoxLamp:Register()
    FunctionsHandler.DarkDagger:Register()
    FunctionsHandler.Canvander:Register()
    FunctionsHandler.BuddySword:Register()
    FunctionsHandler.HallowScythe:Register()
    FunctionsHandler.CursedDualKatana:Register()
    FunctionsHandler.AcidumRifle:Register()
    FunctionsHandler.Kabucha:Register()
    FunctionsHandler.VenomBow:Register()
    FunctionsHandler.SoulGuitar:Register()
    FunctionsHandler.DragonStorm:Register()
    FunctionsHandler.InsictV2:Register()
    FunctionsHandler.RainbowSaviour:Register()
    FunctionsHandler.DarkBladeV2:Register()
    FunctionsHandler.SecondSeaPuzzle:Register()
    FunctionsHandler.ColosseumPuzzle:Register()
    FunctionsHandler.Trevor:Register()
    FunctionsHandler.EvoRace:Register()
    FunctionsHandler.Wenlocktoad:Register()
    FunctionsHandler.DarkBladeV3:Register()
    FunctionsHandler.ThirdSeaPuzzle:Register()
    FunctionsHandler.DojoQuest:Register()
    FunctionsHandler.RaceAwakening:Register()
    FunctionsHandler.PirateRaid:Register()
    FunctionsHandler.RaidController:Register()
    FunctionsHandler.AutoRaidIce:Register()
    FunctionsHandler.MeleesController:Register()
    FunctionsHandler.Superhuman:Register()
    FunctionsHandler.DeathStep:Register()
    FunctionsHandler.SharkmanKarate:Register()
    FunctionsHandler.ElectricClaw:Register()
    FunctionsHandler.DragonTalon:Register()
    FunctionsHandler.Godhuman:Register()
    FunctionsHandler.BossesTask:Register()
    FunctionsHandler.SpecialBossesTask:Register()
    FunctionsHandler.CollectDrops:Register()
    FunctionsHandler.CollectBerries:Register()
    FunctionsHandler.UtillyItemsActivitation:Register()

    -- ============================================================
    -- AUTO FULL MELEE - TƯƠNG THÍCH VỚI LEVEL FARM
    -- ============================================================
    FunctionsHandler.MeleesController:RegisterMethod("Refresh", function()
        if not Config.Items.AutoFullyMelees then return nil end
        if ScriptStorage.PlayerData.Level < 200 then return nil end
        if _G.Level then return nil end

        local allMelees = {"Black Leg", "Electro", "Fishman Karate", "Dragon Claw", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman"}
        local hasAll = true
        for _, name in ipairs(allMelees) do
            if not CheckItem(name) then
                hasAll = false
                break
            end
        end
        if hasAll then
            SetTask('MainTask', 'Auto Full Melee | ✅ Đã có tất cả!')
            return nil
        end
        return true
    end)

    FunctionsHandler.MeleesController:RegisterMethod("Start", function()
        if not Config.Items.AutoFullyMelees then return end
        if ScriptStorage.PlayerData.Level < 200 then return end
        if _G.Level then return end

        local meleeList = {
            {name = "Black Leg", key = "BuyBlackLeg", price = {Beli = 150000}, levelReq = 300},
            {name = "Electro", key = "BuyElectro", price = {Beli = 500000}, levelReq = 300},
            {name = "Fishman Karate", key = "BuyFishmanKarate", price = {Beli = 750000}, levelReq = 300},
            {name = "Dragon Claw", key = "BuyDragonClaw", price = {Fragments = 1500}, levelReq = 300},
            {name = "Superhuman", key = "BuySuperhuman", price = {Beli = 3000000}, levelReq = nil},
            {name = "Death Step", key = "BuyDeathStep", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400, needKey = "Library Key"},
            {name = "Sharkman Karate", key = "BuySharkmanKarate", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400, needKey = "Water Key"},
            {name = "Electric Claw", key = "BuyElectricClaw", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400},
            {name = "Dragon Talon", key = "BuyDragonTalon", price = {Beli = 2500000, Fragments = 5000}, levelReq = 400, needFireEssence = true},
            {name = "Godhuman", key = "BuyGodhuman", price = {Beli = 5000000, Fragments = 5000}, levelReq = 400, needMaterials = true},
        }

        for _, melee in ipairs(meleeList) do
            if _G.Stop then return end
            if _G.Level then return end

            local bp = CheckItem(melee.name)
            if not bp then
                local canBuy = true
                for currency, amount in pairs(melee.price) do
                    local have = (currency == "Beli" and ScriptStorage.PlayerData.Beli) or
                                 (currency == "Fragments" and ScriptStorage.PlayerData.Fragments) or 0
                    if have < amount then canBuy = false end
                end
                if canBuy then
                    SetTask('MainTask', 'Auto Full Melee | Mua ' .. melee.name)
                    BuyMelee(melee.key, true)
                    task.wait(1)
                    if CheckItem(melee.name) then
                        SetTask('MainTask', 'Auto Full Melee | ✅ Mua thành công ' .. melee.name)
                    end
                else
                    SetTask('MainTask', 'Auto Full Melee | Cần farm tiền cho ' .. melee.name)
                    _G.Level = true
                    return
                end
            else
                if melee.levelReq and bp:FindFirstChild("Level") and bp.Level.Value < melee.levelReq then
                    SetTask('MainTask', 'Auto Full Melee | Farm level cho ' .. melee.name .. ' (' .. bp.Level.Value .. '/' .. melee.levelReq .. ')')
                    _G.Level = true
                    return
                end

                if melee.needKey then
                    if not CheckItem(melee.needKey) then
                        SetTask('MainTask', 'Auto Full Melee | Lấy ' .. melee.needKey .. ' cho ' .. melee.name)
                        if melee.needKey == "Library Key" then
                            local admiral = GetConnectionEnemies("Awakened Ice Admiral")
                            if admiral then
                                CombatController.Attack("Awakened Ice Admiral")
                                task.wait(2)
                                return
                            else
                                TweenController.Create(CFrame.new(5668.978, 28.52, -6483.352))
                                return
                            end
                        elseif melee.needKey == "Water Key" then
                            local tide = GetConnectionEnemies("Tide Keeper")
                            if tide then
                                CombatController.Attack("Tide Keeper")
                                task.wait(2)
                                return
                            else
                                TweenController.Create(CFrame.new(-3053.981, 237.19, -10145.039))
                                return
                            end
                        end
                        return
                    end
                end

                if melee.needFireEssence then
                    local bones = ScriptStorage.Backpack["Bones"] and ScriptStorage.Backpack["Bones"].Count or 0
                    if bones < 1 then
                        SetTask('MainTask', 'Auto Full Melee | Farm Bones cho Fire Essence')
                        CombatController.Attack({'Reborn Skeleton', 'Living Zombie', 'Demonic Soul', 'Posessed Mummy'})
                        return
                    end
                    Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                    task.wait(1)
                end

                if melee.needMaterials then
                    local materials = {
                        {name = "Dragon Scale", need = 10, sea = 3, mobs = {"Dragon Crew Warrior", "Dragon Crew Archer"}},
                        {name = "Fish Tail", need = 20, sea = 3, mobs = {"Fishman Raider", "Fishman Captain"}},
                        {name = "Mystic Droplet", need = 10, sea = 2, mobs = {"Sea Soldier", "Water Fighter"}},
                        {name = "Magma Ore", need = 20, sea = 2, mobs = {"Magma Ninja"}},
                    }
                    for _, mat in ipairs(materials) do
                        local count = ScriptStorage.Backpack[mat.name] and ScriptStorage.Backpack[mat.name].Count or 0
                        if count < mat.need then
                            if SeaIndex ~= mat.sea then
                                Remotes.CommF_:InvokeServer(mat.sea == 2 and "TravelDressrosa" or "TravelZou")
                                return
                            end
                            SetTask('MainTask', 'Auto Full Melee | Farm ' .. mat.name .. ' (' .. count .. '/' .. mat.need .. ')')
                            CombatController.Attack(mat.mobs)
                            return
                        end
                    end
                end

                SetTask('SubTask', '✅ ' .. melee.name .. ' đã sẵn sàng')
            end
        end

        SetTask('MainTask', 'Auto Full Melee | 🎉 Hoàn thành tất cả!')
        _G.Level = false
    end)

    -- ============================================================
    -- LEVEL FARM - HOÀN CHỈNH
    -- ============================================================
    FunctionsHandler.LevelFarm:RegisterMethod("Refresh", function()
        local lv = ScriptStorage.PlayerData.Level or 0
        if lv < 50 then return 1
        elseif lv < 70 then return 2
        else return 4 end
    end)

    FunctionsHandler.LevelFarm:RegisterMethod("Start", function(h)
        local currentLevel = ScriptStorage.PlayerData.Level
        if currentLevel and currentLevel >= 700 and SeaIndex == 1 then return end

        if SeaIndex == 3 then
            if (ScriptStorage.Backpack.Bones or {Count = 0}).Count >= 50 then
                if os.time() > (BonesCooldown or 0) then
                    local X, X, X, w = Remotes.CommF_:InvokeServer("Bones", 'Check')
                    if tonumber(X or 1) == 0 then
                        local X = Split(w, ":")
                        local w = ((tonumber(X[1]) * 60) + tonumber(X[2])) * 60
                        BonesCooldown = os.time() + w
                    else
                        Remotes.CommF_:InvokeServer('Bones', 'Buy', 1, 1)
                    end
                end
            end
        end

        local X = ScriptStorage.PlayerData.Level
        if GodHumanFlag then
            local w, D = (function()
                getgenv()["   mphm ><<3"] = {}
                for y, L in GodhumanMaterials do
                    if (ScriptStorage.Backpack[y] or {Count = 0}).Count < L[1] then
                        getgenv()['   mphm >< <3'] = {y, L}
                    end
                end
                return unpack(getgenv()["   mphm >< <3"])
            end)()
            if w then
                if SeaIndex ~= D[2] then
                    alert('Material - ' .. w, "Travelling sea " .. D[2])
                    SetTask("MainTask", 'Sea Travel | Godhuman Materials | Travelling to Sea ' .. D[2])
                    Remotes.CommF_:InvokeServer("Travel" .. SeaIndexes[D[2]])
                    return
                end
                SetTask("MainTask", "Material Farming | Godhuman | " .. w .. " | In Progres")
                if X >= D[4][3] then
                    local w, y = GetCurrentClaimQuest()
                    if w then
                        if not string.find(y, D[3][1]) and not string.find(y, D[3][2]) then J.AbandonQuest()
                        else CombatController.Attack(D[3]); return end
                    else
                        local w = ScriptStorage.NPCs[D[4][4]]
                        w = w and w:GetModelCFrame()
                        if w then
                            TweenController.Create(w + Vector3.new(0, 5, 3))
                            if CaculateDistance(w) < 10 then task.wait(1)
                            else return end
                        else
                            Report("NPC HauntedQuest2 not found")
                        end
                        J.StartQuest(D[4][1], D[4][2])
                        return
                    end
                end
                CombatController.Attack(D[3])
            end
            Remotes.CommF_:InvokeServer("BuyGodhuman", true)
            Remotes.CommF_:InvokeServer("BuyGodhuman")
            GodHumanFlag = false
            return true
        end

        if os.time() - LastTravel > 60 then
            LastTravel = os.time()
            if X >= 1500 and SeaIndex == 2 then
                if Config.Settings.StayInSea2UntilHaveDarkFragments and not ScriptStorage.Backpack['Dark Fragment'] then
                elseif not Services.Workspace.Map.IceCastle.Hall.LibraryDoor:FindFirstChild('PhoeyuDoor') then
                    Remotes.CommF_:InvokeServer("TravelZou")
                    SetTask('MainTask', 'Sea Travel | Teleporting to Third Sea')
                end
            elseif X >= 700 and SeaIndex == 1 then
                SetTask('MainTask', 'Sea Travel | Teleporting to Second Sea')
                Remotes.CommF_:InvokeServer("TravelDressrosa")
            end
        end

        if ScriptStorage.Tools['God\'s Chalice'] and not ScriptStorage.Tools['Mirror Fractal'] then
            if (ScriptStorage.Backpack["Conjured Cocoa"] or {Count = 0}).Count < 10 then
                SetTask("MainTask", "Material Farming | Conjured Cocoa | Need 10x | Farming...")
                CombatController.Attack({"Cocoa Warrior", "Chocolate Bar Battler"})
                return
            end
            Remotes.CommF_:InvokeServer("SweetChaliceNpc")
        end

        if ScriptStorage.Tools['Sweet Chalice'] or (X == MaxLevel and (ScriptStorage.Backpack.Bones or {Count = 0}).Count >= 500) then
            SetTask("MainTask", "Fragments Farming | Cake Prince | Dough King")
            if (ScriptStorage.Tools["Sweet Chalice"]) and (not SpawnReflect or os.time() - SpawnReflect > 10) then
                task.spawn(function()
                    while not ScriptStorage.Enemies['Dough King'] and task.wait() and ScriptStorage.Tools["Sweet Chalice"] do
                        SpawnReflect = os.time()
                        Remotes.CommF_:InvokeServer("CakePrinceSpawner")
                    end
                end)
            end
            CombatController.Attack({"Head Baker", 'Baking Staff', 'Cookie Crafter', "Cake Guard"})
            if X >= 2200 then
                local w, D = GetCurrentClaimQuest()
                if w then
                    if not string.find(D, "Cookie") then J.AbandonQuest()
                    else Remotes.CommF_:InvokeServer('CakePrinceSpawner'); return end
                else
                    print('Start Quest')
                    local w = ScriptStorage.NPCs["Cake Quest Giver 1"]
                    w = w and w:GetModelCFrame()
                    if w then
                        TweenController.Create(w + Vector3.new(0, 5, 3))
                        if CaculateDistance(w) < 10 then task.wait(1)
                        else return end
                    else
                        Report("NPC HauntedQuest2 not found")
                    end
                    J.StartQuest("CakeQuest1", 1)
                    return
                end
            end
            return
        end

        if X >= 2025 and (getsenv(game.ReplicatedStorage.GuideModule)._G.ServerData.ExpBoost == 0 or X <= MaxLevel) and (ScriptStorage.Backpack.Bones or {Count = 0}).Count < 500 then
            SetTask('MainTask', "Resource Farming | Bones | For X2 Mastery/Beli")
            CurrentClaimQuest3 = GetCurrentClaimQuest(true)
            if CurrentClaimQuest3 then
                if not string.find(CurrentClaimQuest3, 'Demonic') then J.AbandonQuest(); return
                else CombatController.Attack({'Reborn Skeleton', "Living Zombie", "Demonic Soul", 'Posessed Mummy'}); return end
            else
                print("StartQuest", CurrentClaimQuest3)
                local X = ScriptStorage.NPCs["Haunted Castle Quest Giver 2"]
                X = X and X:GetModelCFrame()
                if X then
                    TweenController.Create(X + Vector3.new(0, 5, 3))
                    if CaculateDistance(X) < 20 then task.wait(1)
                    else return end
                else
                    Report("NPC HauntedQuest2 not found")
                end
                J.StartQuest('HauntedQuest2', 1)
                return
            end
        end

        if h == 1 then
            SetTask('MainTask', 'Level Farming | Skip Mode | Floor ' .. h)
            CombatController.Attack("Sky Bandit")
        elseif h == 2 then
            SetTask('MainTask', 'Level Farming | Skip Mode | Floor ' .. h)
            CombatController.Attack('God\'s Guard')
        elseif h == 4 then
            local h, X, w, D, y = J:GetCurrentQuest()
            SetTask('SubTask', '📋 Quest: ' .. y .. ' | Defeat ' .. h)
            CurrentClaimQuest1 = GetCurrentClaimQuest()
            if CurrentClaimQuest1 then
                if CurrentClaimQuest1 ~= y and CurrentClaimQuest1 ~= (y .. "s") then return J.AbandonQuest() end
            else
                if not X then return J:RefreshQuest() and Report("failed to get npc position quest 528") end
                TweenController.Create(X + Vector3.new(0, 5, 3))
                SetTask("MainTask", "Level Farming | " .. h .. " | Claiming Quest")
                if CaculateDistance(X) > 10 then return end
                task.wait(2)
                LevelFarmTTL = 0
                J.StartQuest(w, D)
                task.wait(1)
            end
            SetTask('MainTask', 'Level Farming | ' .. h .. " | Defeating Enemies")
            local X = os.time()
            CombatController.Attack(h)
            LevelFarmTTL = LevelFarmTTL + os.time() - X
            if LevelFarmTTL > 160 then end
        end
    end)

    -- ============================================================
    -- EQUIP WEAPON (TỪ TEST.TXT - ĐÃ CÓ SẴN TRONG CombatController.Attack)
    -- ============================================================
    FunctionsHandler.LocalPlayerController:RegisterMethod("EquipTool", function(h)
        if not Humanoid then return end
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if not bp then return end
        for X, X in bp:GetChildren() do
            if X:IsA('Tool') and X.Name ~= "Tool" and (X.Name == tostring(h) or X.ToolTip == h) then
                LocalPlayer.Character:WaitForChild('Humanoid'):EquipTool(X)
            end
        end
    end)
    FunctionsHandler.LocalPlayerController:RegisterMethod('ToggleAbilities', function(h, X)
        if h == 'Buso' then
            if LocalPlayer:HasTag('Buso') and not X or X then Remotes.CommF_:InvokeServer('Buso') end
        elseif h == "Observation" then
        end
    end)
    FunctionsHandler.LocalPlayerController:RegisterMethod('ConfigurationAbilitiesToggle', function()
        FunctionsHandler.LocalPlayerController.Methods.ToggleAbilities:Call('Buso', SCRIPT_CONFIG.BUSO)
        FunctionsHandler.LocalPlayerController.Methods.ToggleAbilities:Call('Observation', SCRIPT_CONFIG.OBSERVATION)
    end)
    print(3)

    -- ============================================================
    -- SABER QUEST - HOÀN CHỈNH
    -- ============================================================
    FunctionsHandler.Saber:RegisterMethod('Refresh', function()
        if not Config.Items.Saber then return end
        if ScriptStorage.Backpack.Saber then return end
        if ScriptStorage.PlayerData.Level < 200 then return end
        local X = Remotes.CommF_:InvokeServer('ProQuestProgress')
        local h
        for w, w in X.Plates do if w == false then h = 1 end end
        if not h then
            if not X.UsedTorch then h = 2
            elseif not X.UsedCup then h = 3
            elseif not X.TalkedSon then h = 4
            elseif not X.KilledMob then h = 5
            elseif not X.UsedRelic then h = 6
            elseif not X.KilledShanks and ScriptStorage.Enemies["Saber Expert"] then h = 7 end
        end
        FunctionsHandler.Saber:Set("CurrentProgressLevel", h)
        FunctionsHandler.Saber:Set('LastestRefreshSenque', os.time())
        return h
    end)

    FunctionsHandler.Saber:RegisterMethod('GetQuestplates', function()
        local h = FunctionsHandler.Saber:Get("QuestplatesCache")
        if h then return h end
        local h = Services.Workspace.Map.Jungle
        local X = {}
        table.foreach(h.QuestPlates:GetChildren(), function(h, w) h = w:FindFirstChild("Button") and table.insert(X, w) end)
        FunctionsHandler.Saber:Set('QuestplatesCache', X)
        return X
    end)

    FunctionsHandler.Saber:RegisterMethod('Start', function()
        local h, X = FunctionsHandler.Saber:Get("CurrentProgressLevel"), FunctionsHandler.Saber:Get('LastestRefreshSenque')
        if not h then
            FunctionsHandler.Saber.Methods.Refresh:Call()
            return FunctionsHandler.Saber.Methods.Start:Call()
        elseif h == 0 then
        elseif os.time() - X > 60 then
            FunctionsHandler.Saber.Methods.Refresh:Call()
            return FunctionsHandler.Saber.Methods.Start:Call()
        else
            if h == 1 then
                local X = FunctionsHandler.Saber.Methods.GetQuestplates:Call()
                for w, D in X do
                    SetTask('MainTask', "Saber Quest | Quest Plates | Touching " .. w .. "/5")
                    while CaculateDistance(D.Button.CFrame) > 20 do
                        task.wait()
                        TweenController.Create(D.Button.CFrame)
                    end
                    task.wait(1)
                end
            elseif h == 2 then
                SetTask('MainTask', 'Saber Quest | Torch Puzzle | Using Torch')
                Remotes.CommF_:InvokeServer("ProQuestProgress", 'GetTorch')
                task.wait(1)
                Remotes.CommF_:InvokeServer('ProQuestProgress', "DestroyTorch")
            elseif h == 3 then
                SetTask('MainTask', "Saber Quest | Sick Man | Helping with Cup")
                Remotes.CommF_:InvokeServer('ProQuestProgress', "GetCup")
                if ScriptStorage.Tools.Cup then
                    FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Cup')
                    task.wait(1)
                    Remotes.CommF_:InvokeServer("ProQuestProgress", 'FillCup', LocalPlayer.Character.Cup)
                end
                Remotes.CommF_:InvokeServer("ProQuestProgress", 'SickMan')
            elseif h == 4 then
                SetTask('MainTask', 'Saber Quest | Rich Son | Getting Information')
                Remotes.CommF_:InvokeServer('ProQuestProgress', 'RichSon')
            elseif h == 5 then
                SetTask("MainTask", "Saber Quest | Mob Leader | Defeating Boss")
                CombatController.Attack('Mob Leader')
            elseif h == 6 then
                SetTask("MainTask", 'Saber Quest | Relic | Placing at Location')
                Remotes.CommF_:InvokeServer('ProQuestProgress', 'RichSon')
                Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
            elseif h == 7 then
                SetTask('MainTask', "Saber Quest | Saber Expert | Final Battle")
                CombatController.Attack("Saber Expert")
            end
        end
    end)
    Remotes.RefreshQuestPro.OnClientEvent:Connect(FunctionsHandler.Saber.Methods.Refresh.Callback)

    -- ============================================================
    -- SECOND SEA PUZZLE (DRESSROSA)
    -- ============================================================
    FunctionsHandler.SecondSeaPuzzle:RegisterMethod('Refresh', function()
        if ScriptStorage.PlayerData.Level < 700 or SeaIndex ~= 1 then return end
        if FunctionsHandler.SecondSeaPuzzle:Get('IsCompleted') then return end
        local k = Remotes.CommF_:InvokeServer('DressrosaQuestProgress')
        if not k.TalkedDetective then Result = 1
        elseif not k.KilledIceBoss then Result = 2
        else FunctionsHandler.SecondSeaPuzzle:Set("IsCompleted", true) end
        FunctionsHandler.SecondSeaPuzzle:Set("CurrentProgressLevel", Result)
        FunctionsHandler.SecondSeaPuzzle:Set('LastestRefreshSenque', os.time())
        return Result
    end)

    FunctionsHandler.SecondSeaPuzzle:RegisterMethod("Start", function()
        local k, h = FunctionsHandler.SecondSeaPuzzle:Get('CurrentProgressLevel'), FunctionsHandler.SecondSeaPuzzle:Get('LastestRefreshSenque')
        FunctionsHandler.SecondSeaPuzzle:Set('CurrentProgressLevel', nil)
        if not k then
            FunctionsHandler.SecondSeaPuzzle.Methods.Refresh:Call()
            return FunctionsHandler.SecondSeaPuzzle.Methods.Start:Call()
        elseif k == 1 then
            SetTask('SubTask', '🧩 Sea2: Talk to Detective')
            SetTask('MainTask', "Auto Second Sea - Talk To Detective")
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'Detective')
            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
            task.wait(1)
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'UseKey')
        elseif k == 2 then
            SetTask('SubTask', '🧩 Sea2: Defeat Ice Admiral')
            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'Detective')
            task.wait(1)
            Remotes.CommF_:InvokeServer('DressrosaQuestProgress', 'UseKey')
            SetTask("MainTask", "Auto Second Sea - Defeating Ice Admiral")
            CombatController.Attack("Ice Admiral")
            Remotes.CommF_:InvokeServer('TravelDressrosa')
        end
    end)

    -- ============================================================
    -- COLOSSEUM PUZZLE (BARTILO)
    -- ============================================================
    FunctionsHandler.ColosseumPuzzle:RegisterMethod("Refresh", function()
        if SeaIndex ~= 2 then return end
        if ScriptStorage.PlayerData.Level < 850 or ScriptStorage.Backpack['Warrior Helmet'] then return end
        local k = Remotes.CommF_:InvokeServer("BartiloQuestProgress")
        if not k.KilledBandits then Result = 1
        elseif not k.KilledSpring then
            if ScriptStorage.Enemies.Jeremy then Result = 2 end
        elseif not k.DidPlates then Result = 3 end
        FunctionsHandler.ColosseumPuzzle:Set("CurrentProgressLevel", Result)
        FunctionsHandler.ColosseumPuzzle:Set("LastestRefreshSenque", os.time())
        return Result
    end)

    FunctionsHandler.ColosseumPuzzle:RegisterMethod('Start', function()
        local k, h = FunctionsHandler.ColosseumPuzzle:Get("CurrentProgressLevel"), FunctionsHandler.ColosseumPuzzle:Get("LastestRefreshSenque")
        FunctionsHandler.ColosseumPuzzle:Set("CurrentProgressLevel", nil)
        if not k then
            FunctionsHandler.ColosseumPuzzle.Methods.Refresh:Call()
            return FunctionsHandler.ColosseumPuzzle.Methods.Start:Call()
        elseif k == 1 then
            SetTask("MainTask", 'Auto Bartilo Quest - Defeating 50x Swan Pirate')
            local h, X = J:GetCurrentClaimQuest()
            if h then
                if not string.find(X, '50') then J.AbandonQuest()
                else CombatController.Attack("Swan Pirate") end
            else
                J.StartQuest('BartiloQuest', 1)
            end
        elseif k == 2 then
            SetTask('MainTask', "Auto Bartilo Quest - Defeating Jeremy")
            CombatController.Attack("Jeremy")
        elseif k == 3 then
            SetTask("MainTask", 'Auto Bartilo Quest - Doing Puzzle')
            if CaculateDistance(CFrame.new(-1837.46155, 44.2921753, 1656.1987, 0.999881566, -1.03885048e-22, -0.0153914848, 1.07805858e-22, 1, 2.53909284e-22, 0.0153914848, -2.55538502e-22, 0.999881566)) > 10 then
                alert("tween to")
                TweenController.Create(CFrame.new(-1837.46155, 44.2921753, 1656.1987, 0.999881566, -1.03885048e-22, -0.0153914848, 1.07805858e-22, 1, 2.53909284e-22, 0.0153914848, -2.55538502e-22, 0.999881566))
            else
                LocalPlayer = game.Players.LocalPlayer
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1836.0, 11, 1714)
                alert("1")
                task.wait(.5)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1850.49329, 13.1789551, 1750.89685)
                alert('2')
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1858.87305, 19.3777466, 1712.01807)
                alert("3")
                task.wait(1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1803.94324, 16.5789185, 1750.89685)
                task.wait(1)
                alert("4")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1858.55835, 16.8604317, 1724.79541)
                task.wait(1)
                alert('5')
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1869.54224, 15.987854, 1681.00659)
                task.wait(1)
                alert("6")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1800.0979, 16.4978027, 1684.52368)
                task.wait(1)
                alert("7")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1819.26343, 14.795166, 1717.90625)
                task.wait(1)
                alert("8")
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1813.51843, 14.8604736, 1724.79541)
            end
        end
    end)

    -- ============================================================
    -- EVOLUTION RACE (RACE V2)
    -- ============================================================
    FunctionsHandler.EvoRace:RegisterMethod("Refresh", function()
        if not Config.Items.RaceV2 then return end
        if SeaIndex ~= 2 then return end
        if getsenv(game.ReplicatedStorage.GuideModule)._G.ServerData.ExpBoost ~= 0 or ScriptStorage.PlayerData.Level < 900 or ScriptStorage.PlayerData.Beli < 1000000 or ScriptStorage.PlayerData.RaceLevel ~= 1 then return end
        return true
    end)

    FunctionsHandler.EvoRace:RegisterMethod('Start', function()
        Remotes.CommF_:InvokeServer('Alchemist', "1")
        Remotes.CommF_:InvokeServer('Alchemist', '2')
        for k = 1, 2, 1 do
            SetTask('SubTask', '🌈 Collecting Flower ' .. k .. ' for Race V2')
            local h = ScriptStorage.Tools["Flower " .. k]
            local X = Services.Workspace:FindFirstChild('Flower' .. k)
            if not h then
                if X and X.Transparency == 0 then
                    SetTask('MainTask', 'Auto Race V2 - Collecting Flower ' .. k)
                    while not ScriptStorage.Tools["Flower " .. k] do
                        task.wait()
                        TweenController.Create(X.CFrame + Vector3.new(0, math.random(-1.0, 2), 0))
                    end
                end
            end
        end
        if not ScriptStorage.Tools['Flower 3'] then
            SetTask('SubTask', '🌈 Farming Swan Pirate for Flower 3')
            SetTask('MainTask', 'Auto Race V2 - Collecting Flower ' .. 3)
            CombatController.Attack('Swan Pirate')
        else
            SetTask('SubTask', '🌈 Race V2 completed, idling...')
            SetTask("MainTask", 'Auto Race V2 - Idling')
            if LocalPlayer.Character.HumanoidRootPart.CFrame.Y < 50000 then
                TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 50, 0))
            end
            Remotes.CommF_:InvokeServer("Alchemist", "3")
            RefreshRace()
        end
    end)

    -- ============================================================
    -- BOSSES TASK
    -- ============================================================
    FunctionsHandler.BossesTask:RegisterMethod("Refresh", function()
        local k
        for h, h in BossesOrder do
            local X = BossesOrderLevel[h]
            if ScriptStorage.PlayerData.Level >= X then
                local X = ScriptStorage.Enemies[h]
                if X and X:FindFirstChild("Humanoid") and X.Humanoid.Health > 0 then k = X end
            end
        end
        if k and (CaculateDistance(k.HumanoidRootPart.CFrame) < (SeaIndex == 2 and 3000 or 5000) or BossesOrderWL[tostring(k)] or ScriptStorage.PlayerData.Level == MaxLevel) then
            return k
        end
    end)

    FunctionsHandler.BossesTask:RegisterMethod('Start', function(k)
        if k then
            SetTask("MainTask", "Auto Farm Boss - Defeating " .. k.Name)
            SetTask('SubTask', '👑 Boss: ' .. k.Name .. ' | HP: ' .. math.floor(k.Humanoid.Health / k.Humanoid.MaxHealth * 100) .. '%')
            CombatController.Attack(tostring(k), null, null, function() SpecialItems = nil end)
            SpecialItems = nil
        end
    end)

    -- ============================================================
    -- SPECIAL BOSSES TASK
    -- ============================================================
    FunctionsHandler.SpecialBossesTask:RegisterMethod('Refresh', function()
        local k
        for h, X in SpecialBossesOrder do
            if ScriptStorage.PlayerData.Level >= X then
                local X = ScriptStorage.Enemies[h]
                if X and X:FindFirstChild('Humanoid') and X.Humanoid.Health > 0 then k = X end
            end
        end
        return k
    end)

    FunctionsHandler.SpecialBossesTask:RegisterMethod('Start', function(k)
        if FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
            pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
        end
        if k then
            SetTask('MainTask', "Auto Farm Boss - Defeating " .. k.Name)
            SetTask('SubTask', '👾 Special Boss: ' .. k.Name)
            CombatController.Attack(tostring(k))
        end
    end)

    -- ============================================================
    -- RAID CONTROLLER
    -- ============================================================
    FunctionsHandler.RaidController:RegisterMethod("RefreshRaidType", function()
        for k, k in require(game.ReplicatedStorage.Raids).raids do
            if string.find(ScriptStorage.PlayerData.DevilFruit, k) then
                FunctionsHandler.RaidController:Set('CurrentChip', k)
                return
            end
        end
        FunctionsHandler.RaidController:Set('CurrentChip', 'Flame')
    end)

    FunctionsHandler.RaidController:RegisterMethod('GetRaidableFruit', function()
        for k, k in ScriptStorage.Backpack do
            if string.find(FruitIdToName(k.Name), " Fruit") then
                if k.Value and k.Value < 1000000 then return k end
            end
        end
    end)

    FunctionsHandler.RaidController:RegisterMethod("GetCurrentRaidIsland", function()
        local IslandsList = {{}, {}, {}, {}, {}}
        for k, k in workspace['_WorldOrigin'].Locations:GetChildren() do
            if string.find(k.Name, 'Island ') and CaculateDistance(k.Position, Vector3.new(0, 0, 0)) > 7000 then
                local h = string.gsub(k.Name, "Island ", "")
                local X = tonumber(h)
                table.insert(IslandsList[X], k)
            end
        end
        for k = 5, 1, -1 do
            for h, h in IslandsList[k] do if CaculateDistance(h.Position) < 2000 then return h end end
        end
        return nil
    end)

    function CheckSpecialMicrochip()
        local bp = LocalPlayer:FindFirstChild("Backpack")
        for _, h in {LocalPlayer.Character:GetChildren(), bp and bp:GetChildren() or {}} do
            for _, X in h do if X.Name == "Special Microchip" then return X end end
        end
        return nil
    end

    FunctionsHandler.RaidController:RegisterMethod("Refresh", function()
        local lv = ScriptStorage.PlayerData.Level or 0
        if lv < 1300 then return nil end
        if CheckSpecialMicrochip() then return nil end
        local fr = ScriptStorage.PlayerData.Fragments or 0
        if lv < 1500 and fr > 2000 then return nil end
        if lv < MaxLevel and fr > 5000 then return nil end
        if lv >= MaxLevel and fr > 10000 then return nil end
        local fruit = FunctionsHandler.RaidController.Methods.GetRaidableFruit:Call()
        if fruit then FunctionsHandler.RaidController:Set("CurrentProgressLevel", fruit) end
        return fruit or FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() or CheckSpecialMicrochip()
    end)

    FunctionsHandler.RaidController:RegisterMethod("Start", function()
        if not FunctionsHandler.RaidController:Get('CurrentChip') then FunctionsHandler.RaidController.Methods.RefreshRaidType:Call() end
        local k = FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
        RefreshInventory()
        FunctionsHandler.RaidController:Set("CurrentProgressLevel", nil)
        if not k then
            SetTask('MainTask', 'Auto Raid - Buying Chip - ' .. FunctionsHandler.RaidController:Get("CurrentChip"))
            if not ScriptStorage.Tools['Special Microchip'] then
                local h = FunctionsHandler.RaidController.Methods.GetRaidableFruit:Call()
                table.insert(ScriptStorage.IgnoreStoreFruits, h.Name)
                alert('Load Fruit', h.Name)
                Remotes.CommF_:InvokeServer('LoadFruit', h.Name)
                Remotes.CommF_:InvokeServer("RaidsNpc", 'Select', FunctionsHandler.RaidController:Get('CurrentChip'))
                task.wait(2)
            end
            local h = ({nil, 'Circle Island', "Boat Castle"})[SeaIndex]
            if not ScriptStorage.Map[h] and not ScriptStorage.Map[h] then
                task.wait(1)
                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
            end
            if not ScriptStorage.Map[h]:FindFirstChild('RaidSummon2') then
                task.wait(1)
                TweenController.Create(ScriptStorage.Map[h]:GetModelCFrame() or ScriptStorage.Map[h]:GetModelCFrame())
            end
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Special Microchip')
            fireclickdetector((ScriptStorage.Map[h] or workspace.Map:FindFirstChild(h) or workspace:FindFirstChild(h)).RaidSummon2.Button.Main.ClickDetector)
            local h = os.time()
            SetTask("MainTask", "Auto Raid - Waiting Until Raid Is Started")
            repeat task.wait() until os.time() - (LastRaidAlert2 or 0) < 20 or os.time() - h > 30
            TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
            repeat task.wait() until os.time() - (LastRaidAlert or 0) < 20 or os.time() - h > 30
            alert('cac', "Tween Paused")
            task.wait(.5)
            if os.time() - h > 30 then
                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
                SetTask('MainTask', "Auto Raid - Raid Is Not Stared?")
                Report('[ Raid Error ] Time Limit Reached')
            end
            LastRaidAlert = 0
        else
            SetTask('MainTask', "Auto Raid - " .. k.Name .. " /5")
            SetTask('SubTask', 'Raid Island ' .. k.Name .. ' | Clearing wave...')
            local islandNum = tonumber(string.match(k.Name, "(%d+)"))
            if islandNum and islandNum >= 4 then
                TweenController.Create(k.Position + Vector3.new(0, 50, 0))
                task.wait(0.5)
                for _, v in workspace.Enemies:GetChildren() do
                    pcall(function()
                        if v:FindFirstChild("Humanoid") then v.Humanoid.Health = 0 end
                        if v:FindFirstChild("HumanoidRootPart") then v.HumanoidRootPart.CanCollide = false end
                        v:BreakJoints()
                    end)
                end
            else
                local h = false
                for X, X in GetMonAsSortedRange() do
                    local w = os.time()
                    while X and X:FindFirstChild("HumanoidRootPart") and X.Humanoid.Health > 0 and CaculateDistance(X.HumanoidRootPart.Position) < 1000 and os.time() - w < 60 and task.wait(.05) do
                        h = true
                        if string.find(X.Name, "Master") or true then
                            CombatController.Attack(X.Name)
                        else
                            pcall(sethiddenproperty, LocalPlayer, 'SimulationRadius', math.huge)
                            pcall(function()
                                X.HumanoidRootPart.CanCollide = false
                                X.Humanoid.Health = 0
                                X:BreakJoints()
                            end)
                        end
                    end
                end
                if not h then TweenController.Create(k.Position + Vector3.new(0, 100, 0)) end
            end
        end
    end)

    -- ============================================================
    -- AUTO RAID ICE
    -- ============================================================
    local RAID_ICE_CHIP_COOLDOWN = 2 * 60 * 60

    FunctionsHandler.AutoRaidIce:RegisterMethod("GetCheapestFruit", function(maxPrice)
        maxPrice = maxPrice or 1000000
        local ok1, fruitPrices = pcall(function() return Remotes.CommF_:InvokeServer("GetFruits") end)
        local ok2, inventoryFruits = pcall(function() return Remotes.CommF_:InvokeServer("getInventoryFruits") end)
        if not ok1 or not ok2 then return nil end
        local priceMap = {}
        for _, v in pairs(fruitPrices) do
            if v.Price and v.Price <= maxPrice then
                priceMap[v.Name] = v.Price
            end
        end
        local cheapest, lowestPrice = nil, math.huge
        for _, fruitData in pairs(inventoryFruits) do
            local name = fruitData.Name
            if name and priceMap[name] and priceMap[name] < lowestPrice then
                lowestPrice = priceMap[name]
                cheapest = name
            end
        end
        return cheapest, lowestPrice
    end)

    FunctionsHandler.AutoRaidIce:RegisterMethod("KillAura", function()
        local currentIsland = FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
        pcall(sethiddenproperty, LocalPlayer, 'SimulationRadius', math.huge)
        for _, v in pairs(workspace.Enemies:GetChildren()) do
            pcall(function()
                if currentIsland then
                    local dist = CaculateDistance(v.HumanoidRootPart.Position, currentIsland.Position)
                    if dist > 1500 then return end
                end
                if v:FindFirstChild("Humanoid") then v.Humanoid.Health = 0 end
                if v:FindFirstChild("HumanoidRootPart") then v.HumanoidRootPart.CanCollide = false end
                v:BreakJoints()
            end)
        end
    end)

    FunctionsHandler.AutoRaidIce:RegisterMethod("BuyChip", function()
        local lastBuy = Storage:Get("RaidIceLastChipBuy") or 0
        if os.time() - lastBuy < RAID_ICE_CHIP_COOLDOWN then return false end
        local fruitName = FunctionsHandler.AutoRaidIce.Methods.GetCheapestFruit:Call(1000000)
        if fruitName then
            SetTask('MainTask', 'Auto Raid Ice | Mua chip bang trai ' .. fruitName)
            table.insert(ScriptStorage.IgnoreStoreFruits, fruitName)
            Remotes.CommF_:InvokeServer('LoadFruit', fruitName)
            task.wait(0.5)
            Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Ice")
            task.wait(1)
            RefreshInventory()
            if CheckSpecialMicrochip() then
                Storage:Set("RaidIceLastChipBuy", os.time())
                Storage:Save()
                return true
            else
                for i = 1, 2 do
                    task.wait(2)
                    Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Ice")
                    task.wait(1)
                    RefreshInventory()
                    if CheckSpecialMicrochip() then
                        Storage:Set("RaidIceLastChipBuy", os.time())
                        Storage:Save()
                        return true
                    end
                end
                SetTask('MainTask', 'Auto Raid Ice | Mua chip that bai')
                return false
            end
        elseif (ScriptStorage.PlayerData.Beli or 0) >= 100000 then
            SetTask('MainTask', 'Auto Raid Ice | Mua chip bang Beli')
            Remotes.CommF_:InvokeServer("RaidsNpc", "Select", "Ice")
            task.wait(1)
            RefreshInventory()
            if CheckSpecialMicrochip() then
                Storage:Set("RaidIceLastChipBuy", os.time())
                Storage:Save()
                return true
            end
            return false
        end
        SetTask('MainTask', 'Auto Raid Ice | Khong du tai nguyen mua chip')
        return false
    end)

    FunctionsHandler.AutoRaidIce:RegisterMethod("Refresh", function()
        local lv = ScriptStorage.PlayerData.Level or 0
        local fr = ScriptStorage.PlayerData.Fragments or 0
        local target = Config.AutoRaidIce_TargetFragments or 5000
        if lv < 1300 then return nil end
        if fr >= target then
            SetTask('MainTask', 'Raid Ice | Da dat target: ' .. fr .. '/' .. target)
            return nil
        end
        local hasChip = CheckSpecialMicrochip() ~= nil
        local onRaid = FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
        if onRaid then return true end
        if hasChip then return true end
        local lastBuy = Storage:Get("RaidIceLastChipBuy") or 0
        if os.time() - lastBuy >= RAID_ICE_CHIP_COOLDOWN then return true end
        return nil
    end)

    FunctionsHandler.AutoRaidIce:RegisterMethod("Start", function()
        local currentIsland = FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call()
        local target = Config.AutoRaidIce_TargetFragments or 5000
        local fr = ScriptStorage.PlayerData.Fragments or 0
        if fr >= target then
            SetTask('MainTask', 'Raid Ice | Da dat target fragments')
            return
        end
        if currentIsland then
            local islandNum = tonumber(string.match(currentIsland.Name, "(%d+)"))
            SetTask('MainTask', 'Raid Ice | Fragments: ' .. fr .. '/' .. target .. ' | Dao ' .. (islandNum or "?") .. '/5')
            SetTask('SubTask', 'Raid Ice | Clearing island ' .. (islandNum or "?"))
            if islandNum and islandNum >= 3 then
                SetTask('MainTask', 'Raid Ice | Dao ' .. islandNum .. ' | Kill Aura')
                FunctionsHandler.AutoRaidIce.Methods.KillAura:Call()
                TweenController.Create(currentIsland.Position + Vector3.new(0, 50, 0))
                task.wait(1)
            else
                local hasEnemy = false
                for _, v in GetMonAsSortedRange() do
                    if CaculateDistance(v.HumanoidRootPart.Position) < 1500 then
                        hasEnemy = true
                        CombatController.Attack(v.Name)
                        break
                    end
                end
                if not hasEnemy then
                    TweenController.Create(currentIsland.Position + Vector3.new(0, 100, 0))
                end
            end
            return
        end
        if not CheckSpecialMicrochip() then
            local bought = FunctionsHandler.AutoRaidIce.Methods.BuyChip:Call()
            if not bought then return end
            task.wait(2)
            RefreshInventory()
        end
        if not CheckSpecialMicrochip() then return end
        local mapName = ({nil, 'Circle Island', 'Boat Castle'})[SeaIndex]
        if not mapName then return end
        local mapObj = ScriptStorage.Map[mapName]
        if not mapObj then
            Report('[AutoRaidIce] Khong tim thay Map: ' .. mapName)
            return
        end
        local summonCFrame
        if SeaIndex == 2 then summonCFrame = CFrame.new(-6438.73, 250.64, -4501.50)
        elseif SeaIndex == 3 then summonCFrame = CFrame.new(-5097.93, 316.44, -3142.66) end
        if summonCFrame then
            SetTask('MainTask', 'Raid Ice | Di den summon button')
            TweenController.Create(summonCFrame)
            local t0 = tick()
            repeat task.wait(0.3) until CaculateDistance(summonCFrame) < 25 or tick()-t0 > 20
        end
        if not mapObj:FindFirstChild('RaidSummon2') then
            TweenController.Create(mapObj:GetModelCFrame())
            task.wait(1)
            return
        end
        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Special Microchip')
        local btn = (mapObj or workspace.Map:FindFirstChild(mapName) or workspace:FindFirstChild(mapName))
        local clickSuccess = false
        for retry = 1, 3 do
            if retry > 1 then task.wait(3) end
            pcall(function()
                if btn and btn.RaidSummon2 and btn.RaidSummon2.Button and btn.RaidSummon2.Button.Main and btn.RaidSummon2.Button.Main.ClickDetector then
                    fireclickdetector(btn.RaidSummon2.Button.Main.ClickDetector)
                    clickSuccess = true
                    SetTask('MainTask', 'Raid Ice | Da click start (lan ' .. retry .. ')')
                else
                    SetTask('MainTask', 'Raid Ice | Khong tim thay button (lan ' .. retry .. ')')
                end
            end)
            if clickSuccess then break end
        end
        if not clickSuccess then
            SetTask('MainTask', 'Raid Ice | Khong the click start')
            return
        end
        SetTask('MainTask', 'Raid Ice | Cho raid bat dau...')
        local raidStarted = false
        for attempt = 1, 3 do
            if attempt > 1 then
                SetTask('MainTask', 'Raid Ice | Thu lai lan ' .. attempt)
                pcall(function()
                    if btn and btn.RaidSummon2 and btn.RaidSummon2.Button and btn.RaidSummon2.Button.Main and btn.RaidSummon2.Button.Main.ClickDetector then
                        fireclickdetector(btn.RaidSummon2.Button.Main.ClickDetector)
                    end
                end)
            end
            local h = os.time()
            repeat task.wait(0.5) until
                os.time() - (LastRaidAlert2 or 0) < 20 or
                os.time() - (LastRaidAlert or 0) < 20 or
                os.time() - h > 35
            if os.time() - h <= 35 then
                raidStarted = true
                break
            end
        end
        if raidStarted then
            LastRaidAlert = 0
            SetTask('MainTask', 'Raid Ice | Raid bat dau!')
        else
            Report('[AutoRaidIce] Raid khong bat dau')
            SetTask('MainTask', 'Raid Ice | Raid khong bat dau, thu lai sau...')
        end
    end)

    -- ============================================================
    -- COLLECT DROPS
    -- ============================================================
    FunctionsHandler.CollectDrops:RegisterMethod("Refresh", function()
        local k = {}
        for h in ScriptStorage.Backpack do k[FruitIdToName(h)] = h end
        for h, h in workspace:GetChildren() do
            if string.find(h.Name, 'Fruit') and not a:FindFirstChild(h.Name) and h:FindFirstChild("Handle") and not k[tostring(h)] and not ScriptStorage.Backpack[FruitNameToId(tostring(h))] then
                FunctionsHandler.CollectDrops:Set('CurrentProgressLevel', h)
                return h
            end
        end
    end)

    FunctionsHandler.CollectDrops:RegisterMethod('Start', function()
        local k = FunctionsHandler.CollectDrops:Get('CurrentProgressLevel')
        FunctionsHandler.CollectDrops:Set('CurrentProgressLevel', nil)
        if k then
            SetTask('SubTask', '📦 Collecting: ' .. tostring(k))
            SetTask("MainTask", "Auto Collect Drop Items - " .. tostring(k))
            TweenController.Create(k:GetModelCFrame())
        end
    end)

    -- ============================================================
    -- UTILLY ITEMS ACTIVATION
    -- ============================================================
    FunctionsHandler.UtillyItemsActivitation:RegisterMethod('Refresh', function()
        if os.time() - timeee < 20 then return end
        if not SpecialItems then
            SpecialItems = {}
            local k = {}
            IceAdmiralPassed = true
            if not ScriptStorage.Backpack.Rengoku then
                table.insert(SpecialItems, "Hidden Key")
                IceAdmiralPassed = false
            end
            if SeaIndex == 2 and Services.Workspace.Map.IceCastle.Hall.LibraryDoor:FindFirstChild("PhoeyuDoor") then
                table.insert(SpecialItems, 'Library Key')
                IceAdmiralPassed = false
            end
            if IceAdmiralPassed then table.insert(k, 'Awakened Ice Admiral') end
            local h = not ScriptStorage.Melees['Sharkman Karate'] and Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
            SharkmanPassed = typeof(h) == 'string'
            if typeof(h) == "string" then
                table.insert(SpecialItems, 'Water Key')
            else
                TidePassed = true
                table.insert(k, 'Tide Keeper')
            end
            if ScriptStorage.Backpack.Yama then
                table.insert(k, "Deandre")
                table.insert(k, 'Urban')
                table.insert(k, 'Diablo')
            end
            local function h()
                local X = {}
                for w, w in BossesOrder do
                    local D = true
                    for y, y in k do if y == w then D = false end end
                    if D then table.insert(X, w) end
                end
                local k = #X
                for w = 1, k - 1 do
                    for D = 1, k - w do
                        local k = key and tostring(X[D][key]):lower() or tostring(X[D]):lower()
                        local w = key and tostring(X[D + 1][key]):lower() or tostring(X[D + 1]):lower()
                        if k > w then X[D], X[D + 1] = X[D + 1], X[D] end
                    end
                end
                return X
            end
            BossesOrder = h()
            for k, h in DropItemData do
                if not ScriptStorage.Backpack[k] and SeaIndex == h.Sea then
                    if ScriptStorage.PlayerData.Level >= h.Level then
                        BossesOrderLevel[h.Boss] = h.Level
                        table.insert(BossesOrder, h.Boss)
                    end
                end
            end
            if FunctionsHandler.Trevor:Get("IsCompleted") and not Storage:Get('SwanDefeated') then
                BossesOrderLevel["Don Swan"] = 1100
                table.insert(BossesOrder, 'Don Swan')
                if SeaIndex == 2 and ScriptStorage.PlayerData.Level > 1500 and not ScriptStorage.Enemies['Don Swan'] then
                    alert("Don Swan", 'Hopping for Don Swan')
                    Hop()
                end
            end
        end
        for k, k in SpecialItems do
            if ScriptStorage.Tools[k] then
                FunctionsHandler.UtillyItemsActivitation:Set('CurrentProgressLevel', k)
                return k
            end
        end
        if SeaIndex == 3 and (ScriptStorage.Melees["Death Step"] or 0) >= 400 and (ScriptStorage.Melees["Black Leg"] or 0) >= 400 and ScriptStorage.PlayerData.Beli >= 2500000 and ScriptStorage.PlayerData.Fragments >= 5000 and not ScriptStorage.Melees['Electric Claw'] then
            FunctionsHandler.UtillyItemsActivitation:Set('CurrentProgressLevel', "Previous Hero")
            return 'Previous Hero'
        end
        if ScriptStorage.Tools["Red Key"] then
            FunctionsHandler.UtillyItemsActivitation:Set("CurrentProgressLevel", "Red Key")
            return 'Red Key'
        end
        if ScriptStorage.Tools['Hallow Essence'] then
            FunctionsHandler.UtillyItemsActivitation:Set("CurrentProgressLevel", 'Soul Reaper Spawner')
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Fire Essence")
            return "Soul Reaper Spawner"
        end
        if ScriptStorage.Tools['Fire Essence'] then
            FunctionsHandler.UtillyItemsActivitation:Set('CurrentProgressLevel', "Uzoth")
            return 'Uzoth'
        end
    end)

    FunctionsHandler.UtillyItemsActivitation:RegisterMethod('Start', function()
        local k = FunctionsHandler.UtillyItemsActivitation:Get("CurrentProgressLevel")
        if k == 'Hidden Key' then
            SetTask('SubTask', '🔑 Using Hidden Key for Rengoku')
            Remotes.CommF_:InvokeServer("OpenRengoku")
        elseif k == 'Water Key' then
            SetTask('SubTask', '🔑 Using Water Key for Sharkman Karate')
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Water Key")
            Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
            Remotes.CommF_:InvokeServer("BuySharkmanKarate")
        elseif k == "Library Key" then
            SetTask('SubTask', '🔑 Using Library Key')
            Remotes.CommF_:InvokeServer("OpenLibrary")
            Services.Workspace.Map.IceCastle.Hall.LibraryDoor:FindFirstChild("PhoeyuDoor"):Destroy()
        elseif k == "Red Key" then
            SetTask('SubTask', '🔑 Submitting Red Key to scientist')
            alert('Red Key', "Submitting red key to the scienctist.")
            Remotes.CommF_:InvokeServer('CakeScientist', "Check")
            ScriptStorage.Tools["Red Key"]:Destroy()
        elseif k == 'Previous Hero' then
            SetTask('SubTask', '⚡ Buying Electric Claw from Previous Hero')
            Remotes.CommF_:InvokeServer('BuyElectricClaw', "Start")
            task.wait(3)
            repeat
                task.wait()
                TweenController.Create(CFrame.new(-12548.0, 332.378 + math.random(-2.0, 2), -7617.0))
            until CaculateDistance(CFrame.new(-12548.0, 332.378, -7617.0)) < 30
            Data = MeleePrices["Electric Claw"]
            Data.Buy(1)
            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Melee')
        elseif k == "Uzoth" then
            SetTask('SubTask', '🔥 Using Fire Essence for Dragon Talon')
            print('Use Fire Essence')
            Remotes.CommF_:InvokeServer("BuyDragonTalon", true)
            Remotes.CommF_:InvokeServer('BuyDragonTalon')
            IsFireEssenceGave = true
            Report("Fire Essence Used")
        elseif k == "Soul Reaper Spawner" then
            SetTask('SubTask', '💀 Using Hallow Essence to spawn Soul Reaper')
            print("Use Hallow Essence")
            if CaculateDistance(workspace.Map["Haunted Castle"].Summoner.Detection.CFrame) < 100 then SpecialItems = nil end
            TweenController.Create(workspace.Map["Haunted Castle"].Summoner.Detection.CFrame)
        end
    end)

    -- ============================================================
    -- TREVOR
    -- ============================================================
    FunctionsHandler.Trevor:RegisterMethod('GetFruit', function()
        for k, k in ScriptStorage.Backpack do
            if string.find(FruitIdToName(k.Name), " Fruit") then
                if k.Value and k.Value > 1000000 and k.Value < 2500000 then return k end
            end
        end
    end)

    FunctionsHandler.Trevor:RegisterMethod('Refresh', function()
        if FunctionsHandler.Trevor:Get('IsCompleted') or os.time() - timeee < 1 then return end
        if ScriptStorage.PlayerData.Level < 1100 then return end
        local k = FunctionsHandler.Trevor.Methods.GetFruit:Call()
        if k then FunctionsHandler.Trevor:Set('Fruit', k) end
        TrevorDebounce = os.time()
        if not FunctionsHandler.Trevor:Get('IsCompleted') then
            FunctionsHandler.Trevor:Set('IsCompleted', (Remotes.CommF_:InvokeServer("TalkTrevor", "1") == 0))
        end
        return not FunctionsHandler.Trevor:Get("IsCompleted") and k
    end)

    FunctionsHandler.Trevor:RegisterMethod("Start", function()
        alert('[ cac ]', "Pulling fruit for trevor...")
        local k = FunctionsHandler.Trevor:Get("Fruit")
        FunctionsHandler.Trevor:Set('Fruit', nil)
        table.insert(ScriptStorage.IgnoreStoreFruits, k.Name)
        Remotes.CommF_:InvokeServer('LoadFruit', k.Name)
        task.wait()
        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call(FruitIdToName(k.Name))
        Remotes.CommF_:InvokeServer('TalkTrevor', '1')
        Remotes.CommF_:InvokeServer('TalkTrevor', "2")
        Remotes.CommF_:InvokeServer("TalkTrevor", "3")
        task.wait(1)
        FunctionsHandler.Trevor:Set('IsCompleted', true)
    end)

    -- ============================================================
    -- THIRD SEA PUZZLE (ZOU)
    -- ============================================================
    FunctionsHandler.ThirdSeaPuzzle:RegisterMethod("Refresh", function()
        if ScriptStorage.PlayerData.Level < 1500 or SeaIndex ~= 2 then return end
        if nil == FunctionsHandler.ThirdSeaPuzzle:Get('State') then
            ZQuestProgress = Remotes.CommF_:InvokeServer("ZQuestProgress", 'Check')
            print('ZQuestProgress', ZQuestProgress)
            FunctionsHandler.ThirdSeaPuzzle:Set("State", ZQuestProgress == 0)
        end
        return FunctionsHandler.ThirdSeaPuzzle:Get('State')
    end)

    FunctionsHandler.ThirdSeaPuzzle:RegisterMethod('Start', function()
        local k = FunctionsHandler.ThirdSeaPuzzle:Get("State")
        SetTask('SubTask', '🧩 Sea3: Starting ZQuest...')
        alert('1093', "start")
        if k then
            alert('1095', "case test")
            repeat
                task.wait(1)
                alert('1096', 'fire')
                print('StartResponse', Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin"))
            until CaculateDistance(Vector3.new(0, 0, 0)) > 20000
            task.spawn(function()
                alert("1098", "rejoin")
                task.wait(30)
                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", game.JobId)
            end)
            alert("attack")
            while task.wait() do CombatController.Attack("rip_indra") end
        end
    end)

    -- ============================================================
    -- YAMA
    -- ============================================================
    FunctionsHandler.Yama:RegisterMethod('Refresh', function()
        if SeaIndex ~= 3 then return end
        if ScriptStorage.Backpack.Yama then return end
        if not FunctionsHandler.Yama:Get("EliteCount") then
            FunctionsHandler.Yama:Set("EliteCount", Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
        end
        if FunctionsHandler.Yama:Get('EliteCount') >= 30 then return true end
    end)

    FunctionsHandler.Yama:RegisterMethod("Start", function()
        SetTask('SubTask', '🗡️ Getting Yama...')
        repeat
            task.wait()
            TweenController.Create(game:GetService("ReplicatedStorage").FakeIslands.Waterfall:GetModelCFrame())
        until workspace.Map:FindFirstChild("Waterfall") and workspace.Map.Waterfall:FindFirstChild("SealedKatana")
        fireclickdetector(workspace.Map.Waterfall.SealedKatana.Hitbox.ClickDetector)
    end)

    -- ============================================================
    -- PIRATE RAID
    -- ============================================================
    FunctionsHandler.PirateRaid:RegisterMethod("Refresh", function()
        local k = FunctionsHandler.PirateRaid:Get('Senque')
        return k and os.time() - k < 500
    end)

    FunctionsHandler.PirateRaid:RegisterMethod("Start", function()
        local k = GetMonAsSortedRange()
        local h = Vector3.new(-5543.5327148438, 313.80062866211, -2964.2585449219)
        if k[1] then
            local X, w = k[1]:FindFirstChild("Humanoid"), k[1]:FindFirstChild("HumanoidRootPart")
            if w and X and X.Health > 0 and CaculateDistance(w.CFrame, h) < 500 then
                CombatController.Attack(k[1].Name)
                return
            end
        end
        TweenController.Create(h)
    end)

    -- ============================================================
    -- SOUL GUITAR - SỬA LOGIC TỪ HI.LUA + AUTO CHEST (MỚI)
    -- ============================================================
    -- ========== HÀM HỖ TRỢ ==========
    local _SgSpecialItems = {
        "God's Chalice", "Fist of Darkness", "Sweet Chalice",
        "Hallow Essence", "Mirror Fractal"
    }

    local function _SgHasSpecialItem()
        local bp = LocalPlayer:FindFirstChild("Backpack")
        local char = LocalPlayer.Character
        for _, name in ipairs(_SgSpecialItems) do
            if bp and bp:FindFirstChild(name) then return true, name end
            if char and char:FindFirstChild(name) then return true, name end
        end
        return false, nil
    end

    local function _SgGetChests()
        local chests = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Parent
               and string.find(string.lower(obj.Name), "chest") then
                table.insert(chests, obj)
            end
        end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos = hrp.Position
            table.sort(chests, function(a, b)
                if a and b and a.Parent and b.Parent then
                    return (pos - a.Position).Magnitude < (pos - b.Position).Magnitude
                end
                return false
            end)
        end
        return chests
    end

    local function _SgCollectChest(chest)
        pcall(function()
            if not chest or not chest.Parent then return end
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            local targetCF = chest.CFrame + Vector3.new(0, 3, 0)
            local dist = (hrp.Position - chest.Position).Magnitude
            if dist > 3000 and BypassTP then
                if not BypassTP(chest.Position) then
                    TweenController.Create(targetCF)
                end
            else
                TweenController.Create(targetCF)
            end
            task.wait(0.35)
            if firetouchinterest then
                firetouchinterest(hrp, chest, 0)
                task.wait()
                firetouchinterest(hrp, chest, 1)
            end
        end)
    end

    local _SgChestPhaseDone = false
    local _SgVisited = {}

    local function _SgHopServer()
        SetTask("MainTask", "🎸 Soul Guitar | Hop: Đang tìm server...")
        local ok, servers = pcall(GetServers)
        if ok and servers then
            local list = {}
            for jobId, data in pairs(servers) do
                if jobId ~= game.JobId and not _SgVisited[jobId] then
                    table.insert(list, {id = jobId, players = data.Count or 0})
                end
            end
            table.sort(list, function(a, b) return a.players < b.players end)
            if list[1] then
                _SgVisited[list[1].id] = true
                SetTask("SubTask", "🎸 Hop → " .. list[1].id:sub(1,8) .. "... (" .. list[1].players .. " players)")
                pcall(function()
                    game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", list[1].id)
                end)
                task.wait(8)
                _SgChestPhaseDone = false
                return
            end
        end
        pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local resp = game:HttpGet(url)
            local data = game:GetService("HttpService"):JSONDecode(resp)
            if not data or not data.data then return end
            table.sort(data.data, function(a, b) return (a.playing or 0) < (b.playing or 0) end)
            for _, sv in ipairs(data.data) do
                local slots = (sv.maxPlayers or 0) - (sv.playing or 0)
                if slots >= 2 and sv.id ~= game.JobId and not _SgVisited[sv.id] then
                    _SgVisited[sv.id] = true
                    SetTask("SubTask", "🎸 Hop HTTP → " .. sv.id:sub(1,8) .. " (" .. (sv.playing or 0) .. "/" .. (sv.maxPlayers or 0) .. ")")
                    pcall(function()
                        game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", sv.id)
                    end)
                    task.wait(8)
                    _SgChestPhaseDone = false
                    return
                end
            end
        end)
        SetTask("MainTask", "🎸 Soul Guitar | Hop: Không tìm được server, thử lại...")
        task.wait(5)
    end

    local function _SgRunChestBatch()
        local hasItem, itemName = _SgHasSpecialItem()
        if hasItem then
            SetTask("MainTask", "🎸 Auto Chest: Found " .. itemName .. " — dừng")
            return false
        end
        if ScriptStorage.Backpack["Skull Guitar"] then
            return false
        end
        local chests = _SgGetChests()
        SetTask("SubTask", "🎸 Auto Chest: " .. #chests .. " rương còn lại")
        if #chests == 0 then
            return false
        end
        for _, chest in ipairs(chests) do
            if _G.Stop then return false end
            local hasMid, nameMid = _SgHasSpecialItem()
            if hasMid then
                SetTask("MainTask", "🎸 Auto Chest: Found " .. nameMid)
                return false
            end
            if chest and chest.Parent then
                SetTask("MainTask", "🎸 Collecting: " .. chest.Name)
                _SgCollectChest(chest)
                task.wait(0.2)
            end
        end
        return #_SgGetChests() > 0
    end

    -- ========== LOGIC CHÍNH ==========
    FunctionsHandler.SoulGuitar:RegisterMethod("Refresh", function()
        if not Config.Items.SoulGuitar then return end
        if ScriptStorage.Backpack['Skull Guitar'] then return end
        if ScriptStorage.PlayerData.Level < 2300 then return end

        local ectoCount = (ScriptStorage.Backpack['Ectoplasm'] or {Count = 0}).Count or 0
        local bonesCount = (ScriptStorage.Backpack['Bones'] or {Count = 0}).Count or 0
        local frags = ScriptStorage.PlayerData.Fragments or 0

        -- BƯỚC 1: Farm Ectoplasm đến 250 ở Sea 2
        if ectoCount < 250 then
            _SgChestPhaseDone = false
            return 1
        end

        -- BƯỚC 2: Nếu chưa có Dark Fragment → farm chest → summon Blackbeard → đánh
        if not ScriptStorage.Backpack['Dark Fragment'] then
            if ScriptStorage.Backpack['Fist of Darkness'] then
                return 10   -- summon & đánh Blackbeard
            end
            if not _SgChestPhaseDone then
                local chests = _SgGetChests()
                if #chests > 0 then
                    return 9   -- auto chest
                else
                    _SgChestPhaseDone = true
                    SetTask("MainTask", "🎸 Soul Guitar | Hết rương, hop server để tìm Fist of Darkness")
                    task.spawn(_SgHopServer)
                    return
                end
            else
                _SgChestPhaseDone = false
                return 9
            end
        end

        -- BƯỚC 3: Đã có Dark Fragment, chuyển sang puzzle ở Sea 3
        if SeaIndex ~= 3 then
            SetTask('MainTask', '🎸 Soul Guitar: Teleport to Sea 3')
            Remotes.CommF_:InvokeServer("TravelZou")
            return
        end

        SoulGuitarProcess = Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", 'Check')
        if not SoulGuitarProcess then
            Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
            if not CheckFullMoon() then
                SetTask('MainTask', 'Hopping for full moon (soul guitar)')
                _SgHopServer()
            end
            return 7
        end
        if not SoulGuitarProcess.Swamp      then return 2
        elseif not SoulGuitarProcess.Gravestones then return 3
        elseif not SoulGuitarProcess.Ghost  then return 4
        elseif not SoulGuitarProcess.Trophies   then return 5
        elseif not SoulGuitarProcess.Pipes  then return 6
        elseif bonesCount >= 500 and frags >= 5000 and not ScriptStorage.Backpack["Skull Guitar"] then
            return 8
        end
    end)

    FunctionsHandler.SoulGuitar:RegisterMethod('Start', function(k)
        if k == 9 then
            SetTask("MainTask", "🎸 Soul Guitar | Auto Chest: Nhặt rương...")
            local hasMore = _SgRunChestBatch()
            if not hasMore then
                _SgChestPhaseDone = true
            end

        elseif k == 10 then
            SetTask('SubTask', '🎸 Soul Guitar: Summon Blackbeard')
            local darkArenaPos = CFrame.new(-1742.0, 241.0, 1290.0)
            TweenController.Create(darkArenaPos)
            task.wait(1)
            pcall(function()
                Remotes.CommF_:InvokeServer("Blackbeard", "Spawn")
            end)
            task.wait(1)
            SetTask('MainTask', '🎸 Soul Guitar: Đánh Blackbeard để lấy Dark Fragment')
            CombatController.Attack("Blackbeard")

        elseif k == 7 then
            SetTask('SubTask', '🎸 Soul Guitar: Full moon gravestone')
            while CaculateDistance(CFrame.new(-8654.0, 140, 6167)) > 5 do
                task.wait()
                TweenController.Create(CFrame.new(-8654.0, 140, 6167))
            end
            SoulGuitarProcess = Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)

        elseif k == 1 then
            if SeaIndex ~= 2 then
                SetTask("SubTask", '🎸 Soul Guitar: Teleport Sea 2 để farm ectoplasm')
                SetTask("MainTask", 'Teleport to second sea to farm ectoplasm')
                Remotes.CommF_:InvokeServer("TravelDressrosa")
                return
            else
                local ecto = (ScriptStorage.Backpack['Ectoplasm'] or {Count = 0}).Count or 0
                SetTask("SubTask", '🎸 Soul Guitar: Farming Ectoplasm (' .. ecto .. '/250)')
                SetTask("MainTask", "Soul Guitar | Ectoplasm " .. ecto .. "/250")
                CombatController.Attack({"Ship Deckhand", "Ship Engineer", 'Ship Steward', "Ship Officer"})
                return
            end

        elseif k == 2 then
            SetTask('SubTask', '🎸 Soul Guitar: Kill Living Zombies (Swamp)')
            TTL9 = TTL9 or 0
            if os.time() ~= LastestTime1 then
                TTL9 = TTL9 + 1
                LastestTime1 = os.time()
            end
            if TTL9 > 60 then _SgHopServer() return end

            local zombies = {}
            for _, enemy in ipairs(Services.Workspace.Enemies:GetChildren()) do
                if enemy.Name == "Living Zombie" then
                    table.insert(zombies, enemy)
                end
            end

            if #zombies < 6 then
                SetTask('MainTask', 'Soul Guitar: Waiting Living Zombies (' .. #zombies .. '/6)')
                TweenController.Create(ScriptStorage.MobRegions["Living Zombie"][1] + Vector3.new(0, 30, 0))
            else
                local startT = os.time()
                for idx, zombie in ipairs(zombies) do
                    local hum  = zombie:FindFirstChild("Humanoid")
                    local root = zombie:FindFirstChild("HumanoidRootPart")
                    if not hum or not root then continue end
                    while task.wait() and hum.Health > 7000 do
                        SetTask('MainTask', 'Soul Guitar: Weakening zombie ' .. idx .. '/' .. #zombies)
                        FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call('Melee')
                        if os.time() - startT > 60 then _SgHopServer() return end
                        TweenController.Create(root.CFrame + Vector3.new(0, 50, 0))
                        pcall(function() _G.FastAttack = os.time() end)
                    end
                end
                SetTask("MainTask", 'Soul Guitar: Finishing all Living Zombies')
                local killT = os.time()
                while workspace.Enemies:FindFirstChild("Living Zombie") and task.wait() do
                    if os.time() - killT > 60 then _SgHopServer() return end
                    CombatController.Attack('Living Zombie')
                end
                TTL9 = 0
            end

        elseif k == 3 then
            SetTask('SubTask', '🎸 Soul Guitar: Placard puzzle')
            local castle = workspace.Map["Haunted Castle"]
            while CaculateDistance(CFrame.new(-8800.0, 178, 6033)) > 10 do
                task.wait()
                SetTask("MainTask", "Soul Guitar: Completing placards...")
                TweenController.Create(CFrame.new(-8800.0, 178, 6033))
            end
            for placadName, dir in pairs({
                Placard1 = "Right", Placard2 = "Right", Placard3 = "Left",
                Placard4 = "Right", Placard5 = "Left", Placard6 = "Left", Placard7 = "Left"
            }) do
                pcall(function() fireclickdetector(castle[placadName][dir].ClickDetector) end)
            end

        elseif k == 4 then
            SetTask('SubTask', '🎸 Soul Guitar: Ghost task')
            Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost")

        elseif k == 5 then
            SetTask('SubTask', '🎸 Soul Guitar: Trophy puzzle')
            if CaculateDistance(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375)) > 30 then
                TweenController.Create(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375))
            else
                local tablet = workspace.Map['Haunted Castle'].Tablet
                for _, segName in pairs(BlankTablets) do
                    local seg = tablet[segName]
                    if seg and seg.Line.Rotation.Z ~= 0 then
                        repeat task.wait() fireclickdetector(seg.ClickDetector)
                        until seg.Line.Rotation.Z == 0
                    end
                end
                for segName, trophyName in pairs(Trophy) do
                    pcall(function()
                        local handle = workspace.Map["Haunted Castle"].Trophies.Quest[trophyName].Handle
                        local rotPart = tostring(handle.CFrame):split(", ")[4]
                        local targetRot = (rotPart == "1" or rotPart == "-1") and "90" or "180"
                        local seg = tablet[segName]
                        if seg and not string.find(tostring(seg.Line.Rotation.Z), targetRot) then
                            repeat task.wait() fireclickdetector(seg.ClickDetector)
                            until string.find(tostring(seg.Line.Rotation.Z), targetRot)
                        end
                    end)
                end
            end

        elseif k == 6 then
            SetTask('SubTask', '🎸 Soul Guitar: Pipe puzzle')
            for pipeName, colorName in pairs(Pipes) do
                pcall(function()
                    local pipe = workspace.Map['Haunted Castle']['Lab Puzzle'].ColorFloor.Model[pipeName]
                    if pipe and pipe.BrickColor.Name ~= colorName then
                        repeat task.wait() fireclickdetector(pipe.ClickDetector)
                        until pipe.BrickColor.Name == colorName
                    end
                end)
            end
            Remotes.CommF_:InvokeServer('soulGuitarBuy')

        elseif k == 8 then
            SetTask('SubTask', '🎸 Soul Guitar: Buying Skull Guitar')
            Remotes.CommF_:InvokeServer('soulGuitarBuy')
        end
    end)
    -- ============================================================
    -- KẾT THÚC PHẦN SOUL GUITAR
    -- ============================================================

    -- ============================================================
    -- TUSHITA
    -- ============================================================
    FunctionsHandler.Tushita:RegisterMethod("Refresh", function()
        if ScriptStorage.Backpack.Tushita then return end
        if ScriptStorage.PlayerData.Level < 2000 then return end
        if SeaIndex ~= 3 then return end
        TushitaProgress = TushitaProgress or Remotes.CommF_:InvokeServer("TushitaProgress")
        if not TushitaProgress.OpenedDoor then
            if ScriptStorage.Enemies["rip_indra True Form"] then
                TushitaProgress = nil
                return 1
            end
        else
            if ScriptStorage.Enemies['Longma'] then
                TushitaProgress = nil
                return 2
            end
        end
    end)

    FunctionsHandler.Tushita:RegisterMethod('Start', function(k)
        if k == 1 then
            SetTask('SubTask', '🗡️ Tushita: Placing torches (Step 1)')
            alert('Auto Tushita', 'Placing torches...')
            TweenController.Create(CFrame.new(5714, math.random(19, 21), 256))
            if ScriptStorage.Tools["Holy Torch"] then
                for W = 1, 5 do Remotes.CommF_:InvokeServer("TushitaProgress", "Torch", W) end
                return true
            end
        elseif k == 2 then
            SetTask('SubTask', '🗡️ Tushita: Defeating Longma (Step 2)')
            alert("Auto Tushita", "Defeating Longma")
            CombatController.Attack("Longma")
        end
    end)

    -- ============================================================
    -- CURSED DUAL KATANA (CDK)
    -- ============================================================
    FunctionsHandler.CursedDualKatana:RegisterMethod("Refresh", function()
        if not Config.Items.CursedDualKatana then return end
        local k = ScriptStorage.Backpack
        if ScriptStorage.PlayerData.Level < 2200 then return end
        if k["Cursed Dual Katana"] or not k.Tushita or k.Tushita.Mastery < 350 or not k.Yama or k.Yama.Mastery < 350 then return end
        if SeaIndex ~= 3 then return end
        local k = CdkProgess or Remotes.CommF_:InvokeServer("CDKQuest", 'Progress') or 'uwu'
        if not k or k == 'uwu' then return end
        if workspace.Map.Turtle.Cursed:FindFirstChild("Breakable") then
            alert('Cursed Dual Katana', 'Open Door')
            return {"break"}
        end
        local W = {Good = 'Tushita', Evil = 'Yama'}
        if k.Good == 4 and k.Evil == 4 then
            print("burn 2")
            return {'burn 2'}
        end
        if k.Good == 3 or k.Evil == 3 then
            print('burn 1')
            return {"burn"}
        end
        if k.Opened then
            for h, X in k do
                if h ~= 'Opened' and h ~= "Finished" and X < 3 then
                    print(h, X)
                    ScriptStorage.CdkCache = {h, X + 1}
                    if not ScriptStorage.Tools[W[h]] then Remotes.CommF_:InvokeServer('LoadItem', W[h]) end
                    alert("Cursed Dual Katana", "Start " .. tostring(W[h]) .. ' ' .. tostring(h))
                    Remotes.CommF_:InvokeServer('CDKQuest', 'StartTrial', h)
                    SetTask("MainTask", "Cursed Dual Katana - " .. tostring(W[h]) .. ' ' .. tostring(h))
                    return false
                end
            end
        end
        local k = ScriptStorage.CdkCache
        if not k then return end
        local W, h = k[1], k[2]
        if W == "Evil" and h == 3 then
            if not ScriptStorage.Enemies['Soul Reaper'] then
                ForceToRollBone = true
                return
            end
        elseif W == 'Good' then
            if h == 2 then
                SetTask("SubTask", 'CDK Quest / Waiting until pirate raid started')
                return
            elseif h == 3 and not ScriptStorage.Enemies["Cake Queen"] then
                Hop()
                SetTask('SubTask', "CDK Quest / Waiting until Cake Queen boss spawned")
                return
            end
        end
        return k
    end)

    FunctionsHandler.CursedDualKatana:RegisterMethod("GetHazeMon", function()
        local k = {}
        for W, W in LocalPlayer.QuestHaze:GetChildren() do if W.Value > 0 then table.insert(k, W) end end
        table.sort(k, function(W, h) return CaculateDistance(W:GetAttribute('Position')) < CaculateDistance(h:GetAttribute('Position')) end)
        return tostring(k[1])
    end)

    FunctionsHandler.CursedDualKatana:RegisterMethod("DoDimension", function(k)
        local W = string.gsub(k, ' ', "")
        local k = os.time()
        repeat
            task.wait()
            TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
            if os.time() - k > 60 then return end
        until os.time() - TorchEnabledTime < 10
        repeat
            task.wait()
            local k = workspace.Map:WaitForChild(W, 10)
            if k then
                for h, h in k:GetChildren() do
                    if h and string.find(h.Name, "Torch") and h:FindFirstChild('ProximityPrompt') and h.ProximityPrompt.Enabled then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = h.CFrame
                        h.ProximityPrompt.HoldDuration = 0
                        task.wait(1)
                        local X = game:GetService("VirtualInputManager")
                        X:SendKeyEvent(true, "E", 0, game)
                        X:SendKeyEvent(false, "E", 0, game)
                        fireproximityprompt(workspace.Map:WaitForChild(W, 10):FindFirstChild(tostring(h)).ProximityPrompt)
                    end
                    for W, W in workspace.Enemies:GetChildren() do
                        local h = W:FindFirstChild("HumanoidRootPart")
                        local X = W:FindFirstChild("Humanoid")
                        if h and X and CaculateDistance(h.CFrame) < 1000 then CombatController.Attack(W.Name) end
                    end
                end
                ExitDoor = k:FindFirstChild("Exit")
                print("exit door", ExitDoor)
                if ExitDoor then
                    PortalBrick = tostring(ExitDoor.BrickColor)
                    print("Brick color", ExitDoor, ExitDoor.BrickColor, PortalBrick)
                end
            else
                print('no island idk wt-')
            end
            print('loop damn', PortalBrick)
        until PortalBrick == 'Olive' or PortalBrick == "Cloudy grey"
        print('leave')
        while os.time() - DoneCdkTick > 15 do
            TweenController.Create(ExitDoor.CFrame + Vector3.new(0, math.random(1, 5), 0))
            task.wait()
        end
        Hop()
    end)

    FunctionsHandler.CursedDualKatana:RegisterMethod("Start", function(k)
        local W = workspace.Map.Turtle.Cursed
        if k[1] == 'break' then
            SetTask('SubTask', '⚔️ CDK: Opening door')
            TweenController.Create(workspace.Map.Turtle.Cursed.Breakable.CFrame)
            Remotes.CommF_:InvokeServer('CDKQuest', "OpenDoor")
            Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
            workspace.Map.Turtle.Cursed.Breakable:Destroy()
            CdkProgess = nil
            return
        end
        if k[1] == "burn 2" then
            SetTask('SubTask', '⚔️ CDK: Burning pedestals (step 2)')
            if workspace.Map.Turtle.Cursed.Pedestal3.ProximityPrompt.Enabled then
                fireproximityprompt(workspace.Map.Turtle.Cursed.Pedestal3.ProximityPrompt)
                task.wait(1)
                pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                task.wait(10)
            else
                CDKAttempts = (CDKAttempts or 0) + 1
                TweenController.Create(CFrame.new(-12341.66796875, 603.3455810546875, -6550.6064453125))
                task.wait(5)
                pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                task.wait(5)
                if CDKAttempts > 5 then Hop() end
                CdkProgess = nil
            end
        elseif k[1] == "burn" then
            SetTask('SubTask', '⚔️ CDK: Burning pedestals')
            for W = 1, 3, 1 do
                local h = workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. W)
                if workspace.Map.Turtle.Cursed:FindFirstChild('Pedestal' .. W).ProximityPrompt.Enabled then
                    repeat
                        task.wait()
                        TweenController.Create(workspace.Map.Turtle.Cursed:FindFirstChild('Pedestal' .. W).CFrame)
                    until CaculateDistance(workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. W).CFrame) < 5
                    fireproximityprompt(workspace.Map.Turtle.Cursed:FindFirstChild("Pedestal" .. W).ProximityPrompt)
                    task.wait(3)
                    pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                end
                CdkProgess = nil
            end
        elseif k[1] == 'Evil' then
            if k[2] == 1 then
                SetTask('SubTask', '⚔️ CDK: Evil trial - Forest Pirate')
                local W = ScriptStorage.Enemies["Forest Pirate"]
                TweenController.Create((W and W.HumanoidRootPart.CFrame) or ScriptStorage.MobRegions["Forest Pirate"][0])
                CdkProgess = nil
            elseif k[2] == 2 then
                SetTask('SubTask', '⚔️ CDK: Evil trial - Haze monster')
                CombatController.Attack(FunctionsHandler.CursedDualKatana.Methods.GetHazeMon:Call())
                CdkProgess = nil
            elseif k[2] == 3 then
                SetTask('SubTask', '⚔️ CDK: Evil trial - Soul Reaper')
                Report("found cdk yama 3")
                while not (os.time() - TorchEnabledTime < 100 or not ScriptStorage.Enemies["Soul Reaper"]) do
                    print("tweening to soul reaper")
                    task.wait()
                    if FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
                        pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                    end
                    TweenController.Create(ScriptStorage.Enemies["Soul Reaper"]:GetModelCFrame())
                end
                if not ScriptStorage.Enemies["Soul Reaper"] then return end
                FunctionsHandler.CursedDualKatana.Methods.DoDimension.Callback("Hell Dimension")
                CdkProgess = nil
            end
        else
            if k[2] == 1 then
                SetTask('SubTask', '⚔️ CDK: Good trial - Boat Dealer')
                for W, W in game.ReplicatedStorage.NPCs:GetChildren() do
                    if W.Name == "Luxury Boat Dealer" then
                        repeat
                            task.wait()
                            if os.time() - DoneCdkTick < 15 then return end
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = (W:GetModelCFrame())
                            RealNPC = nil
                            for h, h in workspace.NPCs:GetChildren() do
                                if CaculateDistance(h:GetModelCFrame(), W:GetModelCFrame()) < 20 then
                                    RealNPC = h
                                    break
                                end
                            end
                        until CaculateDistance(W:GetModelCFrame()) < 5 and RealNPC
                        Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", RealNPC)
                    end
                end
                CdkProgess = nil
            elseif k[2] == 3 then
                SetTask('SubTask', '⚔️ CDK: Good trial - Cake Queen')
                repeat
                    task.wait()
                    print('attacking cage queen')
                    CombatController.Attack("Cage Queen")
                until os.time() - TorchEnabledTime < 10 or not ScriptStorage.Enemies['Cake Queen']
                TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
                Report('Cake Queen')
                FunctionsHandler.CursedDualKatana.Methods.DoDimension.Callback("Heavenly Dimension")
                CdkProgess = nil
            end
        end
    end)

    -- ============================================================
    -- NOTIFICATION LISTENERS
    -- ============================================================
    local k = {Listeners = {}}
    TorchEnabledTime = 0
    DoneCdkTick = 0
    getgenv().NotificationCallBack = (function(W)
        for h, X in k.Listeners do
            if string.find(string.lower(W), string.lower(h)) then X(W) end
        end
    end)
    function k:RegisterNotifyListener(W, h) k.Listeners[W] = h end
    k:RegisterNotifyListener('go!', function() LastRaidAlert = os.time() end)
    k:RegisterNotifyListener('raid', function() LastRaidAlert2 = os.time() end)
    k:RegisterNotifyListener("been spotted approaching", function() FunctionsHandler.PirateRaid:Set('Senque', os.time()) end)
    k:RegisterNotifyListener('job', function() FunctionsHandler.PirateRaid:Set('Senque', 0) end)
    k:RegisterNotifyListener("level", function() AddPoint() end)
    k:RegisterNotifyListener("torch", function() TorchEnabledTime = os.time() end)
    k:RegisterNotifyListener("scroll reacts", function() DoneCdkTick = os.time() end)
    k:RegisterNotifyListener("elite", function()
        FunctionsHandler.Yama:Set('EliteCount', Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
        alert("[MeyyHub ] ", "Elite defeated: " .. tostring(FunctionsHandler.Yama:Get("EliteCount") or 'n/a'))
    end)
    k:RegisterNotifyListener('the raid with', function()
        if ScriptStorage.PlayerData.Level < MaxLevel then return end
        Remotes.CommF_:InvokeServer('Awakener', "Awaken")
    end)
    k:RegisterNotifyListener('quest completed', function()
        J:RefreshQuest()
        task.wait()
        if not J:GetCurrentClaimQuest() then J:MarkAsCompleted() end
    end)
    local k
    k = hookfunction(require(game.ReplicatedStorage.Notification).new, function(W, h)
        v21 = tostring(tostring(W or '') .. tostring(h or "")) or ""
        getgenv().NotificationCallBack(v21)
        return k(W, h)
    end)

    -- ============================================================
    -- SERVER MANAGEMENT
    -- ============================================================
    if SeaIndex ~= 1 then end
    function IfTableHaveIndex(k) for W in k do return true end end
    print(1)
    function GetServers()
        if LastServersDataPulled then
            if os.time() - LastServersDataPulled < 60 then return CachedServers end
        end
        for k = 1, 100, 1 do
            local W = game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser"):InvokeServer(k)
            if IfTableHaveIndex(W) then
                LastServersDataPulled = os.time()
                CachedServers = W
                return W
            end
        end
    end
    spawn(function()
        GetServers()
        while task.wait(180) do GetServers() end
    end)
    function Hop(k, W)
        local h = GetServers()
        local X = {}
        for w, D in h do
            table.insert(X, {JobId = w, Players = D.Count, LastUpdate = D.__LastUpdate, Region = D.Region})
        end
        print(#X, "servers received")
        for h = 1, #X do
            while task.wait() do
                local h = math.random(1, #X)
                ServerData = X[h]
                if ServerData then
                    if not k or ServerData.Players < k then
                        if not W or ServerData.Regoin == W then
                            print("Found Server:", ServerData.JobId, "Player Count:", ServerData.Players, 'Region:', ServerData.Region)
                            break
                        end
                    end
                end
            end
        end
        print('Teleporting to', ServerData.JobId, "..")
        game:GetService("ReplicatedStorage"):WaitForChild('__ServerBrowser'):InvokeServer("teleport", ServerData.JobId)
    end
    LowHop = function(k, k)
        local k = {}
        local W = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true')
        local h = game:GetService("HttpService"):JSONDecode(W)
        if h and h.data then
            for W, W in next, h.data do
                if type(W) == "table" and tonumber(W.playing) and tonumber(W.maxPlayers) and W.playing < 5 and W.id ~= JobId then
                    table.insert(k, 1, W.id)
                end
            end
        end
        if #k > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, k[math.random(1, #k)], game.Players.LocalPlayer)
        else
            return alert('Serverhop', "Couldn't find a server.")
        end
    end

    -- ============================================================
    -- STORAGE
    -- ============================================================
    Storage = {WRITE_DELAY = .5, Data = {}}
    Services = {}
    setmetatable(Services, {__index = function(k, k) return game:GetService(k) end})
    LocalPlayer = game.Players.LocalPlayer
    local k = ".storage_u_" .. tostring(LocalPlayer)
    function Decode(W) return Services.HttpService:JSONDecode(W) end
    function Encode(W) return Services.HttpService:JSONEncode(W) end
    print(5)
    function Storage.Set(W, h, X) W.Data[h] = X end
    function Storage.Get(W, h) return W.Data[h] end
    function Storage.Save(W) pcall(function() if writefile then writefile(k, Encode(W.Data)) end end) end
    if isfile and readfile and not isfile(k) then
        pcall(writefile, k, "{}")
        task.wait(1)
    end
    Storage.Data = {}
    if readfile then pcall(function() Storage.Data = Decode(readfile(k) or '{}') end) end
    spawn(function() while task.wait(Storage.WRITE_DELAY) do Storage:Save() end end)
    CreateTraceback('Initalize', "Initalizing script..")
    local k = {}
    SetTask("MainTask", 'Level Farming')
    SetTask("SubTask", "Idle")
    ParsingTimes = 0
    function RefreshTasksData()
        if _G.Stop then return end
        for W, W in TasksOrder do
            local h = FunctionsHandler[W]
            if not h.Initalized then
                if not k[W] then
                    print("[ Debug ] Task", Name, "is not registered yet")
                    k[W] = true
                end
            else
                local k = h.Methods.Refresh
                local X = h.Methods.Start
                if k then
                    local h = k:Call(ParsingTimes < 100)
                    ParsingTimes = ParsingTimes + 1
                    if h and ParsingTimes > 100 then
                        CurrentTask = CurrentTask ~= W
                        CurrentTask = W
                        ScriptStorage.Interface.SetText('DebugLine', W)
                        X:Call(h)
                        return
                    end
                end
            end
        end
    end
    SetText('MainTextLabel', "Refreshing Player Items..")
    AddPoint()
    J:RefreshQuest()
    RefreshInventory()
    Remotes.CommE.OnClientEvent:Connect(function(...)
        local J = {...}
        if string.find(J[1], 'Item') then RefreshInventory() end
    end)
    RefreshRace()
    a.LocalPlayer.Idled:Connect(function()
        Services.VirtualUser:CaptureController()
        Services.VirtualUser:ClickButton2(Vector2.new())
    end)
    SetText("MainTextLabel", 'Loaded In ' .. tick() - StartTick .. 'ms!')
    local function EnableFpsBoost()
        if true then return end
        spawn(function()
            pcall(function()
                local effect = game:GetService("ReplicatedStorage"):FindFirstChild("Effect")
                if effect then effect:Destroy() end
                local fastBtn = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main")
                if fastBtn and fastBtn:FindFirstChild("Settings") and fastBtn.Settings:FindFirstChild("Buttons") then
                    local btn = fastBtn.Settings.Buttons:FindFirstChild("FastModeButton")
                    if btn then
                        for _, conn in pairs(getconnections(btn.Activated)) do
                            conn.Function()
                        end
                    end
                end
                local function shouldKeep(part)
                    if part:IsDescendantOf(workspace.Enemies) then return true end
                    if part:IsDescendantOf(workspace.NPCs) then return true end
                    if part:IsDescendantOf(workspace.Map) then
                        if part.Name == "QuestPlates" or part.Name == "Plate1" or part.Name == "Plate2" then return true end
                        if part.Name == "Door" or part.Name == "Keyhole" then return true end
                        if part.Name == "Button" then return true end
                        if part.Name == "RaidSummon2" then return true end
                        if part.Name == "Summoner" then return true end
                        if part.Name == "Cursed" then return true end
                        if part.Name == "HeavenlyDimension" or part.Name == "HellDimension" then return true end
                        if part.Name == "MysticIsland" then return true end
                        if part.Name == "Waterfall" then return true end
                        if part.Name == "SealedKatana" then return true end
                        if part:FindFirstChild("ClickDetector") then return true end
                        if part:FindFirstChild("ProximityPrompt") then return true end
                        for _, v in pairs(workspace.Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and (part.Position - v.HumanoidRootPart.Position).Magnitude < 10 then
                                return true
                            end
                        end
                        return false
                    end
                    return true
                end
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") or obj:IsA("SpawnLocation") or obj:IsA("WedgePart") or obj:IsA("Terrain") or obj:IsA("MeshPart") then
                        if not shouldKeep(obj) then
                            obj.Material = Enum.Material.Plastic
                            obj.Reflectance = 0
                            obj.CastShadow = false
                        end
                    elseif obj:IsA("Decal") or obj:IsA("Texture") then
                        if not shouldKeep(obj) then
                            obj.Texture = ""
                            obj.Transparency = 1
                        end
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                        obj.LightInfluence = 0
                        obj.Texture = ""
                        obj.Lifetime = NumberRange.new(0)
                    elseif obj:IsA("Explosion") then
                        obj.BlastPressure = 0
                        obj.BlastRadius = 0
                    elseif obj:IsA("Fire") or obj:IsA("SpotLight") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                        obj.Enabled = false
                    elseif obj:IsA("MeshPart") then
                        obj.Material = Enum.Material.Plastic
                        obj.Reflectance = 0
                        obj.TextureID = ""
                        obj.CastShadow = false
                        obj.RenderFidelity = Enum.RenderFidelity.Performance
                    elseif obj:IsA("SpecialMesh") then
                        obj.TextureId = ""
                    elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("Accessory") then
                        if obj:IsDescendantOf(game.Players.LocalPlayer.Character) then
                            obj:Destroy()
                        end
                    end
                end
                local lighting = game:GetService("Lighting")
                lighting.GlobalShadows = false
                lighting.FogEnd = 9000000000
                lighting.Brightness = 0
                for _, v in pairs(lighting:GetDescendants()) do
                    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                        v.Enabled = false
                    end
                end
                local notif = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Notifications")
                if notif then notif.Enabled = false end
                local terrain = workspace.Terrain
                if terrain then
                    terrain.WaterWaveSize = 0
                    terrain.WaterWaveSpeed = 0
                    terrain.WaterReflectance = 0
                    terrain.WaterTransparency = 0
                end
                if settings and settings().Rendering then
                    settings().Rendering.QualityLevel = "Level01"
                    settings().Rendering.GraphicsMode = "NoGraphics"
                end
                print("[✅ FPS Boost] Đã áp dụng tối ưu đồ họa toàn diện!")
            end)
        end)
    end
    EnableFpsBoost()
    QueueList = {}
    function NearbyHopHandler()
        do return end
        if NearbyHopHandlerDebounce and os.time() - NearbyHopHandlerDebounce < 10 then return end
        NearbyHopHandlerDebounce = os.time()
        for J, J in a:GetPlayers() do
            local k = J and J.Character and J.Character:FindFirstChild("HumanoidRootPart") and J.Character.HumanoidRootPart.Position
            if k then
                local W = QueueList[J.Name]
                if not W then
                    QueueList[J.Name] = os.time()
                else
                    if os.time() - W > 30 then
                        if CaculateDistance(k) < 100 then
                            Hop('nearby plr')
                            task.wait(5)
                        else
                            QueueList[J.Name] = nil
                        end
                    end
                end
            end
        end
    end
    task.spawn(function()
        while task.wait() do
            if not _G.Stop then
                NearbyHopHandler()
                if LocalPlayer.Character:FindFirstChild('Humanoid') and LocalPlayer.Character.Humanoid.Sit then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                pcall(RefreshPlayerData)
                local J = os.time() - timeee
                local r = J + OldSessionTime
                if writefile then pcall(writefile, ".tdif-" .. game.Players.LocalPlayer.Name, tostring(r)) end
                if ScriptStorage.Interface then
                    SetText('LiveTime', "Total Elapsed Time: " .. DispTime(r, true) .. ' Elapsed Time: ' .. DispTime(J, true))
                end
                RefreshDebounce = os.time()
            end
        end
    end)
    AddPoint()
    Remotes.CommF_:InvokeServer("Cousin", 'Buy')
    task.spawn(function()
        task.wait(Config.Configuration.AutoHopDelay)
        if not Config.Configuration.AutoHop then Hop('Autohop') end
    end)

    -- ============================================================
    -- AUTO SEA 2 & 3 (CÁC THREAD RIÊNG)
    -- ============================================================
    task.spawn(function()
        while task.wait(0.5) do
            if Config.AutoSea2 then
                pcall(function()
                    if ScriptStorage.PlayerData.Level >= 700 and SeaIndex ~= 2 then
                        local iceDoor = workspace.Map.Ice.Door
                        if iceDoor and iceDoor.CanCollide == true and iceDoor.Transparency == 0 then
                            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
                            FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Key")
                            TweenController.Create(CFrame.new(1347.71, 37.38, -1325.65))
                            repeat task.wait() until not Config.AutoSea2 or (HumanoidRootPart and (HumanoidRootPart.Position - Vector3.new(1347.71, 37.38, -1325.65)).Magnitude < 5)
                        elseif iceDoor and iceDoor.CanCollide == false and iceDoor.Transparency == 1 then
                            if workspace.Enemies:FindFirstChild("Ice Admiral") then
                                CombatController.Attack("Ice Admiral")
                                repeat task.wait() until not Config.AutoSea2 or not workspace.Enemies:FindFirstChild("Ice Admiral") or workspace.Enemies["Ice Admiral"].Humanoid.Health <= 0
                                Remotes.CommF_:InvokeServer("TravelDressrosa")
                            else
                                TweenController.Create(CFrame.new(1347.71, 37.38, -1325.65))
                            end
                        else
                            Remotes.CommF_:InvokeServer("TravelDressrosa")
                        end
                    end
                end)
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.5) do
            if Config.AutoSea3 then
                pcall(function()
                    if ScriptStorage.PlayerData.Level >= 1500 then
                        local bartiloProgress = Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo")
                        if bartiloProgress == 0 then
                            local questText = game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                            if string.find(questText, "Swan Pirates") and string.find(questText, "50") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then
                                local swan = workspace.Enemies:FindFirstChild("Swan Pirate")
                                if swan and swan:FindFirstChild("Humanoid") and swan.Humanoid.Health > 0 then
                                    CombatController.Attack("Swan Pirate")
                                else
                                    TweenController.Create(CFrame.new(1057.93, 137.61, 1242.08))
                                end
                            else
                                TweenController.Create(CFrame.new(-456.29, 73.02, 299.90))
                            end
                        elseif bartiloProgress == 1 then
                            local jeremy = workspace.Enemies:FindFirstChild("Jeremy")
                            if jeremy and jeremy:FindFirstChild("Humanoid") and jeremy.Humanoid.Health > 0 then
                                CombatController.Attack("Jeremy")
                            else
                                TweenController.Create(CFrame.new(2099.88, 448.93, 648.00))
                            end
                        elseif bartiloProgress == 2 then
                            TweenController.Create(CFrame.new(-1836, 11, 1714))
                            if CaculateDistance(CFrame.new(-1836, 11, 1714)) < 5 then
                                local positions = {
                                    CFrame.new(-1850.49, 13.18, 1750.90),
                                    CFrame.new(-1858.87, 19.38, 1712.02),
                                    CFrame.new(-1803.94, 16.58, 1750.90),
                                    CFrame.new(-1858.56, 16.86, 1724.80),
                                    CFrame.new(-1869.54, 15.99, 1681.01),
                                    CFrame.new(-1800.10, 16.50, 1684.52),
                                    CFrame.new(-1819.26, 14.80, 1717.91),
                                    CFrame.new(-1813.52, 14.86, 1724.80)
                                }
                                for _, pos in ipairs(positions) do
                                    if not Config.AutoSea3 then break end
                                    HumanoidRootPart.CFrame = pos
                                    task.wait(0.1)
                                end
                            end
                        elseif bartiloProgress == 3 then
                            local unlockables = Remotes.CommF_:InvokeServer("GetUnlockables")
                            if unlockables.FlamingoAccess == nil then
                                local inventoryFruits = Remotes.CommF_:InvokeServer("getInventoryFruits")
                                local fruitStore = {}
                                for _, v in pairs(inventoryFruits) do
                                    for i1, v1 in pairs(v) do
                                        if i1 == "Name" then table.insert(fruitStore, v1) end
                                    end
                                end
                                local fruitPrices = Remotes.CommF_:InvokeServer("GetFruits")
                                local availableFruits = {}
                                for _, v in next, fruitPrices do
                                    if v.Price >= 1000000 then table.insert(availableFruits, v.Name) end
                                end
                                for _, fruitName in pairs(availableFruits) do
                                    for _, storeFruit in pairs(fruitStore) do
                                        if fruitName == storeFruit and unlockables.FlamingoAccess == nil then
                                            if not game.Players.LocalPlayer.Backpack:FindFirstChild(fruitName) then
                                                Remotes.CommF_:InvokeServer("LoadFruit", fruitName)
                                            else
                                                Remotes.CommF_:InvokeServer("TalkTrevor", "1")
                                                Remotes.CommF_:InvokeServer("TalkTrevor", "2")
                                                Remotes.CommF_:InvokeServer("TalkTrevor", "3")
                                            end
                                        end
                                    end
                                end
                                Remotes.CommF_:InvokeServer("TalkTrevor", "1")
                                Remotes.CommF_:InvokeServer("TalkTrevor", "2")
                                Remotes.CommF_:InvokeServer("TalkTrevor", "3")
                            else
                                local zCheck = Remotes.CommF_:InvokeServer("ZQuestProgress", "Check")
                                if zCheck == 0 then
                                    local rip_indra = workspace.Enemies:FindFirstChild("rip_indra")
                                    if rip_indra and rip_indra:FindFirstChild("Humanoid") and rip_indra.Humanoid.Health > 0 then
                                        CombatController.Attack("rip_indra")
                                    else
                                        Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
                                        TweenController.Create(CFrame.new(2288.80, 15.19, 863.03))
                                    end
                                elseif zCheck == 1 then
                                    Remotes.CommF_:InvokeServer("TravelZou")
                                else
                                    local donSwan = workspace.Enemies:FindFirstChild("Don Swan")
                                    if donSwan and donSwan:FindFirstChild("Humanoid") and donSwan.Humanoid.Health > 0 then
                                        CombatController.Attack("Don Swan")
                                    else
                                        TweenController.Create(CFrame.new(2288.80, 15.19, 863.03))
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    -- ============================================================
    -- ANTI LAG / LOW GRAPHICS
    -- ============================================================
    if Config.Configuration and Config.Configuration.LowGraphics ~= false then
        task.spawn(function()
            pcall(function()
                local lighting = game:GetService("Lighting")
                lighting.GlobalShadows = false
                lighting.FogEnd = 9e9
                lighting.Brightness = 0
                for _, v in pairs(lighting:GetDescendants()) do
                    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                        v.Enabled = false
                    end
                end
                local terrain = workspace.Terrain
                if terrain then
                    terrain.WaterWaveSize = 0
                    terrain.WaterWaveSpeed = 0
                    terrain.WaterReflectance = 0
                    terrain.WaterTransparency = 0
                end
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                        obj.Lifetime = NumberRange.new(0)
                    elseif obj:IsA("Fire") or obj:IsA("SpotLight") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                        obj.Enabled = false
                    end
                end
                if settings and settings().Rendering then
                    settings().Rendering.QualityLevel = "Level01"
                    settings().Rendering.GraphicsMode = "NoGraphics"
                end
                print("[✅ Anti Lag] Đã áp dụng tối ưu đồ họa!")
            end)
        end)
    end

    -- ============================================================
    -- VÒNG LẶP CHÍNH
    -- ============================================================
    while task.wait() do
        if Config.Configuration.HopWhenIdle and LastIdling and os.time() - LastIdling > 300.0 then
            SetTask('MainTask', "Rejoining due idle in 10 min!")
            task.wait(1)
            while task.wait() do game:GetService('TeleportService'):Teleport(game.PlaceId) end
        end
        if not AnimationDelay or os.time() - AnimationDelay > 60 then
            AnimationDelay = os.time()
        end
        if ScriptStorage.PlayerData.Level and ScriptStorage.PlayerData.Level > 0 then
            local J, r = xpcall(RefreshTasksData, debug.traceback)
            if not J then 
                print('[ Error ]', r)
                task.wait(1)
            end
        else
            task.wait(1)
            pcall(RefreshPlayerData)
        end
    end
end

hoangtuveu()
