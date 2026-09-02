
    -- ============================================================
    -- AUTO FULL MELEE
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
            SetTask('MainTask', 'Auto Full Melee | ✅ Have all!')
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
                    SetTask('MainTask', 'Auto Full Melee | Buying ' .. melee.name)
                    BuyMelee(melee.key, true)
                    task.wait(1)
                    if CheckItem(melee.name) then
                        SetTask('MainTask', 'Auto Full Melee | ✅ Bought ' .. melee.name)
                    end
                else
                    SetTask('MainTask', 'Auto Full Melee | Need farm for ' .. melee.name)
                    _G.Level = true
                    return
                end
            else
                if melee.levelReq and bp:FindFirstChild("Level") and bp.Level.Value < melee.levelReq then
                    SetTask('MainTask', 'Auto Full Melee | Farming level for ' .. melee.name .. ' (' .. bp.Level.Value .. '/' .. melee.levelReq .. ')')
                    _G.Level = true
                    return
                end

                if melee.needKey then
                    if not CheckItem(melee.needKey) then
                        SetTask('MainTask', 'Auto Full Melee | Getting ' .. melee.needKey .. ' for ' .. melee.name)
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
                        SetTask('MainTask', 'Auto Full Melee | Farming Bones for Fire Essence')
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
                            SetTask('MainTask', 'Auto Full Melee | Farming ' .. mat.name .. ' (' .. count .. '/' .. mat.need .. ')')
                            CombatController.Attack(mat.mobs)
                            return
                        end
                    end
                end

                SetTask('SubTask', '✅ ' .. melee.name .. ' ready')
            end
        end

        SetTask('MainTask', 'Auto Full Melee | 🎉 All complete!')
        _G.Level = false
    end)

    -- ============================================================
    -- LEVEL FARM
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
                SetTask("MainTask", "Material Farming | Godhuman | " .. w .. " | In Progress")
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
    -- NOTIFICATION LISTENERS, HOP, STORAGE, MAIN LOOP
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

    Storage = {WRITE_DELAY = .5, Data = {}}
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
                local lighting = game:GetService("Lighting")
                lighting.GlobalShadows = false
                lighting.FogEnd = 9000000000
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
                if settings and settings().Rendering then
                    settings().Rendering.QualityLevel = "Level01"
                    settings().Rendering.GraphicsMode = "NoGraphics"
                end
                print("[✅ FPS Boost] Applied full optimization!")
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
    -- MAIN LOOP (Logic)
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

-- ============================================================
-- 💖 STEPCONTROL HUB X KAITUN ULTIMATE UI
-- ============================================================
task.spawn(function()
    local ok, err = xpcall(hoangtuveu, debug.traceback)
    if not ok then
        warn("[StepControl] Logic Error:", err)
    end
end)

task.wait(2)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local GUI_NAME = "STEPCONTROL_HUB_X_KAITUN"

local Theme = {
    Background = Color3.fromRGB(7, 4, 9),
    Header = Color3.fromRGB(16, 7, 17),
    Panel = Color3.fromRGB(23, 9, 24),
    PanelHover = Color3.fromRGB(30, 11, 31),
    Pink = Color3.fromRGB(255, 65, 155),
    PinkLight = Color3.fromRGB(255, 125, 195),
    White = Color3.fromRGB(248, 241, 247),
    Gray = Color3.fromRGB(173, 151, 168),
    Green = Color3.fromRGB(130, 230, 140),
    Red = Color3.fromRGB(245, 75, 105),
    Border = Color3.fromRGB(91, 27, 65),
}

local TweenFast = TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TweenNormal = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TweenOpen = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TweenPulse = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

local Old = PlayerGui:FindFirstChild(GUI_NAME)
if Old then Old:Destroy() end

local function New(Class, Properties, Parent)
    local Object = Instance.new(Class)
    for Property, Value in pairs(Properties or {}) do Object[Property] = Value end
    Object.Parent = Parent
    return Object
end

local function Corner(Object, Radius)
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, Radius)
    C.Parent = Object
    return C
end

local function Stroke(Object, Color, Thickness, Transparency)
    local S = Instance.new("UIStroke")
    S.Color = Color or Theme.Border
    S.Thickness = Thickness or 1
    S.Transparency = Transparency or 0
    S.Parent = Object
    return S
end

local Gui = New("ScreenGui", {
    Name = GUI_NAME,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100,
}, PlayerGui)

local OpenButton = New("TextButton", {
    Name = "OpenButton",
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 18, 0.5, 0),
    Size = UDim2.fromOffset(55, 55),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    Text = "S",
    TextColor3 = Theme.PinkLight,
    Font = Enum.Font.GothamBlack,
    TextSize = 23,
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 50,
}, Gui)

Corner(OpenButton, 16)
local OpenGlow = Stroke(OpenButton, Theme.Pink, 2, 0.65)
TweenService:Create(OpenGlow, TweenPulse, {Transparency = 0.15}):Play()

local Main = New("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.88, 0.84),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 10,
}, Gui)
Corner(Main, 15)
Stroke(Main, Theme.Border, 1.2, 0.05)

local Header = New("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 65),
    BackgroundColor3 = Theme.Header,
    BorderSizePixel = 0,
    ZIndex = 20,
}, Main)

local Title = New("TextLabel", {
    Position = UDim2.new(0, 21, 0, 7),
    Size = UDim2.new(0.7, 0, 0, 28),
    BackgroundTransparency = 1,
    Text = "STEPCONTROL HUB X KAITUN",
    TextColor3 = Theme.White,
    Font = Enum.Font.GothamBlack,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 25,
}, Header)

local Subtitle = New("TextLabel", {
    Position = UDim2.new(0, 22, 0, 36),
    Size = UDim2.new(0.7, 0, 0, 18),
    BackgroundTransparency = 1,
    Text = "⚡ CLICK TITLE TO TOGGLE FARM",
    TextColor3 = Theme.PinkLight,
    Font = Enum.Font.GothamMedium,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 25,
}, Header)

local function WindowButton(Text, X, Background)
    local Button = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, X, 0.5, 0),
        Size = UDim2.fromOffset(31, 31),
        BackgroundColor3 = Background,
        BorderSizePixel = 0,
        Text = Text,
        TextColor3 = Theme.White,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        AutoButtonColor = false,
        ZIndex = 30,
    }, Header)
    Corner(Button, 10)
    return Button
end

local Minimize = WindowButton("—", -54, Color3.fromRGB(48, 25, 52))
local Close = WindowButton("×", -16, Color3.fromRGB(61, 22, 39))

local Scroll = New("ScrollingFrame", {
    Name = "Content",
    Position = UDim2.new(0, 8, 0, 72),
    Size = UDim2.new(1, -16, 1, -80),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Theme.Pink,
    ScrollBarImageTransparency = 0.1,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ElasticBehavior = Enum.ElasticBehavior.Always,
    ZIndex = 15,
}, Main)

local Columns = New("Frame", {
    Name = "Columns",
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    ZIndex = 15,
}, Scroll)

local ColumnLayout = New("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    Padding = UDim.new(0, 12),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, Columns)

local Left = New("Frame", {Size = UDim2.new(0.48, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 15}, Columns)
local Right = New("Frame", {Size = UDim2.new(0.48, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 15}, Columns)
for _, Column in ipairs({Left, Right}) do
    New("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, Column)
end

local SectionIndex = 0
local function Section(Parent, SectionName)
    SectionIndex += 1
    local Frame = New("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.Panel, BorderSizePixel = 0, ZIndex = 18}, Parent)
    Corner(Frame, 9)
    Stroke(Frame, Theme.Border, 1, 0.2)
    local Accent = New("Frame", {Position = UDim2.new(0, 11, 0, 11), Size = UDim2.fromOffset(3, 18), BackgroundColor3 = Theme.Pink, BorderSizePixel = 0, ZIndex = 20}, Frame)
    Corner(Accent, 2)
    local Label = New("TextLabel", {Position = UDim2.new(0, 22, 0, 8), Size = UDim2.new(1, -32, 0, 24), BackgroundTransparency = 1, Text = string.upper(SectionName), TextColor3 = Theme.PinkLight, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 20}, Frame)
    local Content = New("Frame", {Position = UDim2.new(0, 12, 0, 37), Size = UDim2.new(1, -24, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 20}, Frame)
    New("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}, Content)
    return Content
end

local function InfoRow(Parent, Name, Value)
    local Row = New("Frame", {Size = UDim2.new(1, 0, 0, 29), BackgroundTransparency = 1, ZIndex = 22}, Parent)
    New("TextLabel", {Size = UDim2.new(0.52, 0, 1, 0), BackgroundTransparency = 1, Text = Name, TextColor3 = Theme.Gray, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 23}, Row)
    local ValueLabel = New("TextLabel", {Position = UDim2.new(0.52, 0, 0, 0), Size = UDim2.new(0.48, 0, 1, 0), BackgroundTransparency = 1, Text = Value, TextColor3 = Theme.White, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 23}, Row)
    return ValueLabel
end

-- ============================================================
-- BUILD UI (เฉพาะฟีเจอร์จริง)
-- ============================================================

local Time = Section(Left, "Time")
local PlayTimeLabel = InfoRow(Time, "Play Time", "00h 00m 00s")

local Status = Section(Left, "Status")
local WorldLabel = InfoRow(Status, "World", "1")
local FruitLabel = InfoRow(Status, "Fruit", "—")

local Currencies = Section(Left, "Currencies")
local LevelLabel = InfoRow(Currencies, "Level", "0")
local BeliLabel = InfoRow(Currencies, "Beli", "0")
local FragmentsLabel = InfoRow(Currencies, "Fragments", "0")
local BonesLabel = InfoRow(Currencies, "Bones", "0")

local AutoFarmSection = Section(Right, "Auto Farm")
local AutoFarmLabel = InfoRow(AutoFarmSection, "Status", "❌ Disabled")
local FarmStatusLabel = InfoRow(AutoFarmSection, "Task", "Idle")

local MiscSection = Section(Right, "Miscellaneous")
local AutoSea2Label = InfoRow(MiscSection, "Auto Sea 2", "✅ Active")
local AutoSea3Label = InfoRow(MiscSection, "Auto Sea 3", "✅ Active")
local AutoHopLabel = InfoRow(MiscSection, "Auto Hop", "✅ Active")
local LowGraphLabel = InfoRow(MiscSection, "Low Graphics", "✅ On")

-- ============================================================
-- DRAG SYSTEM
-- ============================================================
local Dragging, DragStart, StartPosition = false, nil, nil
Header.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position
    end
end)
Header.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
end)
UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then return end
    if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end
    local Delta = Input.Position - DragStart
    Main.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
end)

local Minimized, FullSize = false, Main.Size
Minimize.MouseButton1Click:Connect(function()
    if Minimized then return end
    Minimized = true
    Scroll.Visible = false
    TweenService:Create(Main, TweenNormal, {Size = UDim2.new(FullSize.X.Scale, FullSize.X.Offset, 0, 65)}):Play()
end)
Close.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TweenNormal, {Size = UDim2.fromScale(0, 0)}):Play()
    task.wait(0.3)
    Main.Visible = false
    OpenButton.Visible = true
    OpenButton.Size = UDim2.fromOffset(0, 0)
    TweenService:Create(OpenButton, TweenNormal, {Size = UDim2.fromOffset(55, 55)}):Play()
end)
OpenButton.MouseButton1Click:Connect(function()
    OpenButton.Visible = false
    Main.Visible = true
    if Minimized then Minimized = false Scroll.Visible = true end
    Main.Size = UDim2.fromScale(0, 0)
    TweenService:Create(Main, TweenOpen, {Size = FullSize}):Play()
end)

Main.Size = UDim2.fromScale(0, 0)
task.wait(0.1)
TweenService:Create(Main, TweenOpen, {Size = FullSize}):Play()

-- ============================================================
-- REAL-TIME UPDATE
-- ============================================================
local FarmingStatus = "🟢 Ready"
local StartTime = os.time()
local AutoFarmEnabled = false

local function UpdateUI()
    pcall(function()
        if PlayTimeLabel then
            local elapsed = os.time() - StartTime
            PlayTimeLabel.Text = string.format("%02dh %02dm %02ds", math.floor(elapsed / 3600), math.floor((elapsed % 3600) / 60), elapsed % 60)
        end

        if ScriptStorage and ScriptStorage.PlayerData then
            if WorldLabel then WorldLabel.Text = tostring(ScriptStorage.PlayerData.Level or 0) >= 700 and "2" or (tostring(ScriptStorage.PlayerData.Level or 0) >= 1500 and "3" or "1") end
            if FruitLabel then FruitLabel.Text = ScriptStorage.PlayerData.DevilFruit or "—" end
            if LevelLabel then LevelLabel.Text = tostring(ScriptStorage.PlayerData.Level or 0) end
            if BeliLabel then BeliLabel.Text = tostring(ScriptStorage.PlayerData.Beli or 0) end
            if FragmentsLabel then FragmentsLabel.Text = tostring(ScriptStorage.PlayerData.Fragments or 0) end
        end

        if ScriptStorage and ScriptStorage.Backpack then
            if BonesLabel then
                local bones = ScriptStorage.Backpack["Bones"]
                BonesLabel.Text = bones and tostring(bones.Count) or "0"
            end
        end

        if AutoFarmLabel then
            AutoFarmLabel.Text = AutoFarmEnabled and "✅ Enabled" or "❌ Disabled"
            AutoFarmLabel.TextColor3 = AutoFarmEnabled and Theme.Green or Theme.Red
        end
        if FarmStatusLabel then
            local taskName = ScriptStorage and ScriptStorage.Task and ScriptStorage.Task.MainTask
            FarmStatusLabel.Text = taskName or "Idle"
        end

        if LowGraphLabel then LowGraphLabel.Text = Config.Configuration.LowGraphics and "✅ On" or "❌ Off" end
        if AutoSea2Label then AutoSea2Label.Text = Config.AutoSea2 and "✅ Active" or "❌ Off" end
        if AutoSea3Label then AutoSea3Label.Text = Config.AutoSea3 and "✅ Active" or "❌ Off" end
        if AutoHopLabel then AutoHopLabel.Text = Config.Configuration.AutoHop and "✅ Active" or "❌ Off" end
    end)
end

task.spawn(function() while task.wait(1) do pcall(UpdateUI) end end)

Title.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    _G.KaitunEnabled = AutoFarmEnabled
    
    if AutoFarmEnabled then
        Title.Text = "⚡ FARMING ACTIVE"
        Title.TextColor3 = Theme.Green
        FarmingStatus = "🟢 Farming..."
    else
        Title.Text = "STEPCONTROL HUB X KAITUN"
        Title.TextColor3 = Theme.White
        FarmingStatus = "🟡 Stopped"
    end
end)

print("✅ STEPCONTROL HUB X KAITUN - ULTIMATE UI LOADED!")
print("💖 UI Connected to Kaitun Logic")
print("⚡ Click the title to START/STOP farming!")
