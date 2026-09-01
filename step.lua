-- ============================================================
-- KAITUN MASTER SCRIPT (1-2600) - PART 1/2
-- FIXED BUGS, ANTI-CRASH, FAST LEVELING INTEGRATION
-- ============================================================

local a = game:GetService("Players")
local LocalPlayer = a.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10) or ReplicatedStorage

-- Global Variables & State
_G.Stop = false
local QueueList = {}
local NearbyHopHandlerDebounce = 0
local OldSessionTime = 0
local timeee = os.time()
local RefreshDebounce = 0
local AnimationDelay = 0
local LastIdling = os.time()

-- Configuration Defaults
if not Config then
    Config = {
        AutoSea2 = true,
        AutoSea3 = true,
        Configuration = {
            AutoHop = false,
            AutoHopDelay = 30,
            LowGraphics = true,
            HopWhenIdle = true
        }
    }
end

-- Helper Functions
local function GetCharacter()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
        return char, char.HumanoidRootPart, char.Humanoid
    end
    return nil, nil, nil
end

local function CaculateDistance(pos)
    local _, root = GetCharacter()
    if root then
        if typeof(pos) == "CFrame" then pos = pos.Position end
        return (root.Position - pos).Magnitude
    end
    return 999999
end

local function DispTime(seconds, detailed)
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    if detailed then
        return string.format("%02dh:%02dm:%02ds", hours, mins, secs)
    end
    return string.format("%02d:%02d:%02d", hours, mins, secs)
end

local function Hop(reason)
    pcall(function()
        print("[Hop System] Hopping server due to: " .. tostring(reason))
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end)
end

local function SetText(element, text)
    pcall(function()
        if ScriptStorage and ScriptStorage.Interface and ScriptStorage.Interface:FindFirstChild(element) then
            ScriptStorage.Interface[element].Text = text
        end
    end)
end

local function SetTask(taskName, status)
    print("[" .. tostring(taskName) .. "] " .. tostring(status))
end

-- Auto Stats System
local function AddPoint()
    pcall(function()
        local points = LocalPlayer.Data.StatsPoints.Value
        if points > 0 then
            Remotes.CommF_:InvokeServer("AddPoint", "Melee", math.floor(points * 0.5))
            Remotes.CommF_:InvokeServer("AddPoint", "Defense", math.floor(points * 0.5))
        end
    end)
end

-- Fix: NearbyHopHandler Variable Shadowing Bug
function NearbyHopHandler()
    if NearbyHopHandlerDebounce and os.time() - NearbyHopHandlerDebounce < 10 then return end
    NearbyHopHandlerDebounce = os.time()
    
    for _, plr in pairs(a:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            local k = char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position
            if k then
                local W = QueueList[plr.Name]
                if not W then
                    QueueList[plr.Name] = os.time()
                else
                    if os.time() - W > 30 then
                        if CaculateDistance(k) < 100 then
                            Hop('nearby plr')
                            task.wait(5)
                        else
                            QueueList[plr.Name] = nil
                        end
                    end
                end
            end
        end
    end
end

-- System Background Threads
task.spawn(function()
    while task.wait() do
        if not _G.Stop then
            NearbyHopHandler()
            local char, root, humanoid = GetCharacter()
            if humanoid and humanoid.Sit then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            pcall(RefreshPlayerData)
            local J = os.time() - timeee
            local r = J + OldSessionTime
            if writefile then pcall(writefile, ".tdif-" .. LocalPlayer.Name, tostring(r)) end
            if ScriptStorage and ScriptStorage.Interface then
                SetText('LiveTime', "Total Elapsed Time: " .. DispTime(r, true) .. ' Elapsed Time: ' .. DispTime(J, true))
            end
            RefreshDebounce = os.time()
        end
    end
end)

AddPoint()
pcall(function() Remotes.CommF_:InvokeServer("Cousin", 'Buy') end)

task.spawn(function()
    task.wait(Config.Configuration.AutoHopDelay or 30)
    -- Fix: Replaced incorrect "not Config.Configuration.AutoHop" condition
    if Config.Configuration.AutoHop then Hop('Autohop') end
end)-- ============================================================
-- KAITUN MASTER SCRIPT (1-2600) - PART 2/2
-- AUTO SEA 2/3, ANTI LAG, MAIN LOOP & AUTO EXECUTE
-- ============================================================

function hoangtuveu()
    -- AUTO SEA 2 & SEA 3 THREADS
    task.spawn(function()
        while task.wait(0.5) do
            if Config.AutoSea2 then
                pcall(function()
                    local level = LocalPlayer.Data.Level.Value
                    if level >= 700 and game.PlaceId == 2753915549 then
                        local iceDoor = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ice") and workspace.Map.Ice:FindFirstChild("Door")
                        if iceDoor and iceDoor.CanCollide == true and iceDoor.Transparency == 0 then
                            Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
                            if FunctionsHandler and FunctionsHandler.LocalPlayerController then
                                FunctionsHandler.LocalPlayerController.Methods.EquipTool:Call("Key")
                            end
                            if TweenController then TweenController.Create(CFrame.new(1347.71, 37.38, -1325.65)) end
                        elseif iceDoor and iceDoor.CanCollide == false and iceDoor.Transparency == 1 then
                            local enemies = workspace:FindFirstChild("Enemies")
                            if enemies and enemies:FindFirstChild("Ice Admiral") then
                                if CombatController then CombatController.Attack("Ice Admiral") end
                            else
                                if TweenController then TweenController.Create(CFrame.new(1347.71, 37.38, -1325.65)) end
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
                    local level = LocalPlayer.Data.Level.Value
                    if level >= 1500 and game.PlaceId == 4442272183 then
                        local bartiloProgress = Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo")
                        if bartiloProgress == 0 then
                            local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
                            local questText = mainGui and mainGui.Quest.Container.QuestTitle.Title.Text or ""
                            if string.find(questText, "Swan Pirates") and string.find(questText, "50") then
                                if CombatController then CombatController.Attack("Swan Pirate") end
                            else
                                if TweenController then TweenController.Create(CFrame.new(-456.29, 73.02, 299.90)) end
                            end
                        elseif bartiloProgress == 1 then
                            if CombatController then CombatController.Attack("Jeremy") end
                        elseif bartiloProgress == 2 then
                            if TweenController then TweenController.Create(CFrame.new(-1836, 11, 1714)) end
                        elseif bartiloProgress == 3 then
                            local unlockables = Remotes.CommF_:InvokeServer("GetUnlockables")
                            if unlockables and unlockables.FlamingoAccess == nil then
                                local inventoryFruits = Remotes.CommF_:InvokeServer("getInventoryFruits") or {}
                                local fruitStore = {}
                                for _, v in pairs(inventoryFruits) do
                                    if typeof(v) == "table" and v.Name then table.insert(fruitStore, v.Name) end
                                end
                                local fruitPrices = Remotes.CommF_:InvokeServer("GetFruits") or {}
                                for _, v in next, fruitPrices do
                                    if v.Price and v.Price >= 1000000 then
                                        for _, storeFruit in pairs(fruitStore) do
                                            if v.Name == storeFruit then
                                                Remotes.CommF_:InvokeServer("LoadFruit", v.Name)
                                                task.wait(0.5)
                                                Remotes.CommF_:InvokeServer("TalkTrevor", "1")
                                                Remotes.CommF_:InvokeServer("TalkTrevor", "2")
                                                Remotes.CommF_:InvokeServer("TalkTrevor", "3")
                                            end
                                        end
                                    end
                                end
                            else
                                local zCheck = Remotes.CommF_:InvokeServer("ZQuestProgress", "Check")
                                if zCheck == 0 then
                                    if CombatController then CombatController.Attack("rip_indra") end
                                elseif zCheck == 1 then
                                    Remotes.CommF_:InvokeServer("TravelZou")
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    -- OPTIMIZED ANTI LAG / LOW GRAPHICS
    if Config.Configuration and Config.Configuration.LowGraphics ~= false then
        task.spawn(function()
            pcall(function()
                local lighting = game:GetService("Lighting")
                lighting.GlobalShadows = false
                lighting.FogEnd = 9e9
                lighting.Brightness = 0
                for _, v in pairs(lighting:GetDescendants()) do
                    if v:IsA("PostEffect") or v:IsA("BlurEffect") then v.Enabled = false end
                end
                local terrain = workspace:FindFirstChildOfClass("Terrain")
                if terrain then
                    terrain.WaterWaveSize = 0
                    terrain.WaterWaveSpeed = 0
                    terrain.WaterReflectance = 0
                    terrain.WaterTransparency = 0
                end
                if settings and settings().Rendering then
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                end
                print("[✅ Anti Lag] Optimized Graphics successfully applied!")
            end)
        end)
    end

    -- MAIN LOOP
    while task.wait() do
        pcall(function()
            if Config.Configuration.HopWhenIdle and LastIdling and os.time() - LastIdling > 300.0 then
                SetTask('MainTask', "Rejoining due to idle!")
                task.wait(1)
                game:GetService('TeleportService'):Teleport(game.PlaceId)
            end
            
            local level = LocalPlayer.Data.Level.Value
            if level and level > 0 then
                if RefreshTasksData then
                    xpcall(RefreshTasksData, function(err) print('[ Task Error ]', err) end)
                end
            else
                task.wait(1)
                if RefreshPlayerData then pcall(RefreshPlayerData) end
            end
        end)
    end
end

-- AUTO EXECUTE MAIN FUNCTION
hoangtuveu()    if hasChip then return true end

    -- ============================================================
    -- AUTO RAID ICE
    -- ============================================================
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
    -- COLLECT DROPS (FIXED NIL VARIABLE & LOOP ERROR)
    -- ============================================================
    FunctionsHandler.CollectDrops:RegisterMethod("Refresh", function()
        local k = {}
        if ScriptStorage.Backpack then
            for h in pairs(ScriptStorage.Backpack) do 
                k[FruitIdToName(h)] = h 
            end
        end
        
        for _, h in pairs(workspace:GetChildren()) do
            if string.find(h.Name, 'Fruit') and h:FindFirstChild("Handle") then
                local itemName = tostring(h)
                if not k[itemName] and not (ScriptStorage.Backpack and ScriptStorage.Backpack[FruitNameToId(itemName)]) then
                    FunctionsHandler.CollectDrops:Set('CurrentProgressLevel', h)
                    return h
                end
            end
        end
    end)

    FunctionsHandler.CollectDrops:RegisterMethod('Start', function()
        local k = FunctionsHandler.CollectDrops:Get('CurrentProgressLevel')
        FunctionsHandler.CollectDrops:Set('CurrentProgressLevel', nil)
        if k and k.Parent then
            SetTask('SubTask', '📦 Collecting: ' .. tostring(k))
            SetTask("MainTask", "Auto Collect Drop Items - " .. tostring(k))
            TweenController.Create(k:GetModelCFrame())
        end
    end)

    -- ============================================================
    -- YAMA
    -- ============================================================
    FunctionsHandler.Yama:RegisterMethod('Refresh', function()
        if SeaIndex ~= 3 then return end
        if ScriptStorage.Backpack and ScriptStorage.Backpack.Yama then return end
        if not FunctionsHandler.Yama:Get("EliteCount") then
            FunctionsHandler.Yama:Set("EliteCount", Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
        end
        if (FunctionsHandler.Yama:Get('EliteCount') or 0) >= 30 then return true end
    end)

    FunctionsHandler.Yama:RegisterMethod("Start", function()
        SetTask('SubTask', '🗡️ Getting Yama...')
        repeat
            task.wait()
            TweenController.Create(game:GetService("ReplicatedStorage").FakeIslands.Waterfall:GetModelCFrame())
        until workspace.Map:FindFirstChild("Waterfall") and workspace.Map.Waterfall:FindFirstChild("SealedKatana")
        if workspace.Map.Waterfall.SealedKatana:FindFirstChild("Hitbox") and workspace.Map.Waterfall.SealedKatana.Hitbox:FindFirstChild("ClickDetector") then
            fireclickdetector(workspace.Map.Waterfall.SealedKatana.Hitbox.ClickDetector)
        end
    end)

    -- ============================================================
    -- SOUL GUITAR
    -- ============================================================
    FunctionsHandler.SoulGuitar:RegisterMethod("Refresh", function()
        if not Config.Items or not Config.Items.SoulGuitar then return end
        if ScriptStorage.Backpack and ScriptStorage.Backpack['Skull Guitar'] then return end
        if (ScriptStorage.PlayerData.Level or 0) < 2300 then return end

        local ectoCount = (ScriptStorage.Backpack and ScriptStorage.Backpack['Ectoplasm'] or {Count = 0}).Count or 0
        local bonesCount = (ScriptStorage.Backpack and ScriptStorage.Backpack['Bones'] or {Count = 0}).Count or 0
        local frags = ScriptStorage.PlayerData.Fragments or 0

        if ectoCount < 250 then return 1 end

        if not (ScriptStorage.Backpack and ScriptStorage.Backpack['Dark Fragment']) then
            if ScriptStorage.Backpack and ScriptStorage.Backpack['Fist of Darkness'] then return 10 end
            return 9
        end

        if SeaIndex ~= 3 then
            SetTask('MainTask', '🎸 Soul Guitar: Teleport to Sea 3')
            Remotes.CommF_:InvokeServer("TravelZou")
            return
        end

        SoulGuitarProcess = Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", 'Check')
        if not SoulGuitarProcess then
            Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
            return 7
        end
        if not SoulGuitarProcess.Swamp then return 2
        elseif not SoulGuitarProcess.Gravestones then return 3
        elseif not SoulGuitarProcess.Ghost then return 4
        elseif not SoulGuitarProcess.Trophies then return 5
        elseif not SoulGuitarProcess.Pipes then return 6
        elseif bonesCount >= 500 and frags >= 5000 and not (ScriptStorage.Backpack and ScriptStorage.Backpack["Skull Guitar"]) then return 8
        end
    end)

    FunctionsHandler.SoulGuitar:RegisterMethod('Start', function(k)
        if k == 9 then
            SetTask("MainTask", "🎸 Soul Guitar | Auto Chest: Nhặt rương...")
            if _SgRunChestBatch then _SgRunChestBatch() end
        elseif k == 10 then
            SetTask('SubTask', '🎸 Soul Guitar: Summon Blackbeard')
            local darkArenaPos = CFrame.new(-1742.0, 241.0, 1290.0)
            TweenController.Create(darkArenaPos)
            task.wait(1)
            pcall(function() Remotes.CommF_:InvokeServer("Blackbeard", "Spawn") end)
            task.wait(1)
            CombatController.Attack("Blackbeard")
        elseif k == 7 then
            SetTask('SubTask', '🎸 Soul Guitar: Full moon gravestone')
            while CaculateDistance(CFrame.new(-8654.0, 140, 6167)) > 5 do
                task.wait()
                TweenController.Create(CFrame.new(-8654.0, 140, 6167))
            end
            Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)
        elseif k == 1 then
            if SeaIndex ~= 2 then
                Remotes.CommF_:InvokeServer("TravelDressrosa")
                return
            else
                local ecto = (ScriptStorage.Backpack and ScriptStorage.Backpack['Ectoplasm'] or {Count = 0}).Count or 0
                SetTask("MainTask", "Soul Guitar | Ectoplasm " .. ecto .. "/250")
                CombatController.Attack({"Ship Deckhand", "Ship Engineer", 'Ship Steward', "Ship Officer"})
                return
            end
        elseif k == 2 then
            CombatController.Attack("Living Zombie")
        elseif k == 3 then
            local castle = workspace.Map and workspace.Map:FindFirstChild("Haunted Castle")
            if castle then
                while CaculateDistance(CFrame.new(-8800.0, 178, 6033)) > 10 do
                    TweenController.Create(CFrame.new(-8800.0, 178, 6033))
                end
                for placadName, dir in pairs({
                    Placard1 = "Right", Placard2 = "Right", Placard3 = "Left",
                    Placard4 = "Right", Placard5 = "Left", Placard6 = "Left", Placard7 = "Left"
                }) do
                    pcall(function() fireclickdetector(castle[placadName][dir].ClickDetector) end)
                end
            end
        elseif k == 4 then
            Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost")
        elseif k == 5 then
            if CaculateDistance(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375)) > 30 then
                TweenController.Create(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375))
            else
                local tablet = workspace.Map and workspace.Map:FindFirstChild('Haunted Castle') and workspace.Map['Haunted Castle']:FindFirstChild('Tablet')
                if tablet then
                    for _, segName in pairs({"Segment6", 'Segment2', 'Segment8', "Segment9", 'Segment5'}) do
                        local seg = tablet:FindFirstChild(segName)
                        if seg and seg:FindFirstChild("Line") and seg.Line.Rotation.Z ~= 0 then
                            repeat task.wait() fireclickdetector(seg.ClickDetector)
                            until not seg:FindFirstChild("Line") or seg.Line.Rotation.Z == 0
                        end
                    end
                end
            end
        elseif k == 6 then
            local lab = workspace.Map and workspace.Map:FindFirstChild('Haunted Castle') and workspace.Map['Haunted Castle']:FindFirstChild('Lab Puzzle')
            if lab and lab:FindFirstChild("ColorFloor") and lab.ColorFloor:FindFirstChild("Model") then
                for pipeName, colorName in pairs({
                    ['Part1'] = 'Really black', ['Part2'] = 'Really black', ["Part3"] = "Dusty Rose",
                    ['Part4'] = "Storm blue", ['Part5'] = 'Really black', ['Part6'] = "Parsley green",
                    ["Part7"] = 'Really black', ["Part8"] = "Dusty Rose", ["Part9"] = 'Really black',
                    ['Part10'] = 'Storm blue'
                }) do
                    pcall(function()
                        local pipe = lab.ColorFloor.Model:FindFirstChild(pipeName)
                        if pipe and pipe.BrickColor.Name ~= colorName then
                            repeat task.wait() fireclickdetector(pipe.ClickDetector)
                            until not pipe or pipe.BrickColor.Name == colorName
                        end
                    end)
                end
            end
            Remotes.CommF_:InvokeServer('soulGuitarBuy')
        elseif k == 8 then
            Remotes.CommF_:InvokeServer('soulGuitarBuy')
        end
    end)

    -- ============================================================
    -- CDK (CURSED DUAL KATANA)
    -- ============================================================
    FunctionsHandler.CursedDualKatana:RegisterMethod("Refresh", function()
        if not Config.Items or not Config.Items.CursedDualKatana then return end
        local k = ScriptStorage.Backpack
        if not k or (ScriptStorage.PlayerData.Level or 0) < 2200 then return end
        if k["Cursed Dual Katana"] or not k.Tushita or (k.Tushita.Mastery or 0) < 350 or not k.Yama or (k.Yama.Mastery or 0) < 350 then return end
        if SeaIndex ~= 3 then return end
        
        local cdkProgess = CdkProgess or Remotes.CommF_:InvokeServer("CDKQuest", 'Progress') or 'uwu'
        if not cdkProgess or cdkProgess == 'uwu' then return end
        
        if workspace.Map and workspace.Map.Turtle and workspace.Map.Turtle:FindFirstChild("Cursed") and workspace.Map.Turtle.Cursed:FindFirstChild("Breakable") then
            return {"break"}
        end
        
        local W = {Good = 'Tushita', Evil = 'Yama'}
        if type(cdkProgess) == "table" then
            if cdkProgess.Good == 4 and cdkProgess.Evil == 4 then
                return {'burn 2'}
            end
            if cdkProgess.Good == 3 or cdkProgess.Evil == 3 then
                return {"burn"}
            end
            
            if cdkProgess.Opened then
                for h, X in pairs(cdkProgess) do
                    if h ~= 'Opened' and h ~= "Finished" and type(X) == "number" and X < 3 then
                        ScriptStorage.CdkCache = {h, X + 1}
                        if not (ScriptStorage.Tools and ScriptStorage.Tools[W[h]]) then Remotes.CommF_:InvokeServer('LoadItem', W[h]) end
                        Remotes.CommF_:InvokeServer('CDKQuest', 'StartTrial', h)
                        SetTask("MainTask", "Cursed Dual Katana - " .. tostring(W[h]) .. ' ' .. tostring(h))
                        return false
                    end
                end
            end
        end
        
        local cache = ScriptStorage.CdkCache
        if not cache then return end
        
        local typeKey, step = cache[1], cache[2]
        if typeKey == "Evil" and step == 3 then
            if not (ScriptStorage.Enemies and ScriptStorage.Enemies['Soul Reaper']) then return end
        elseif typeKey == 'Good' and step == 3 and not (ScriptStorage.Enemies and ScriptStorage.Enemies["Cake Queen"]) then
            if Hop then Hop() end
            return
        end
        return cache
    end)

    FunctionsHandler.CursedDualKatana:RegisterMethod("Start", function(k)
        local cursed = workspace.Map and workspace.Map.Turtle and workspace.Map.Turtle:FindFirstChild("Cursed")
        if not cursed then return end

        if k[1] == 'break' then
            SetTask('SubTask', '⚔️ CDK: Opening door')
            if cursed:FindFirstChild("Breakable") then
                TweenController.Create(cursed.Breakable.CFrame)
                Remotes.CommF_:InvokeServer('CDKQuest', "OpenDoor")
                Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
                cursed.Breakable:Destroy()
            end
            CdkProgess = nil
            return
        end
        if k[1] == "burn 2" then
            SetTask('SubTask', '⚔️ CDK: Burning pedestals (step 2)')
            if cursed:FindFirstChild("Pedestal3") and cursed.Pedestal3:FindFirstChild("ProximityPrompt") and cursed.Pedestal3.ProximityPrompt.Enabled then
                fireproximityprompt(cursed.Pedestal3.ProximityPrompt)
                task.wait(1)
                pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                task.wait(10)
            else
                CDKAttempts = (CDKAttempts or 0) + 1
                TweenController.Create(CFrame.new(-12341.66796875, 603.3455810546875, -6550.6064453125))
                task.wait(5)
                pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                task.wait(5)
                if CDKAttempts > 5 and Hop then Hop() end
                CdkProgess = nil
            end
        elseif k[1] == "burn" then
            SetTask('SubTask', '⚔️ CDK: Burning pedestals')
            for i = 1, 3 do
                local ped = cursed:FindFirstChild("Pedestal" .. i)
                if ped and ped:FindFirstChild("ProximityPrompt") and ped.ProximityPrompt.Enabled then
                    repeat
                        task.wait()
                        TweenController.Create(ped.CFrame)
                    until CaculateDistance(ped.CFrame) < 5
                    fireproximityprompt(ped.ProximityPrompt)
                    task.wait(3)
                    pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                end
                CdkProgess = nil
            end
        elseif k[1] == 'Evil' then
            if k[2] == 1 then
                SetTask('SubTask', '⚔️ CDK: Evil trial - Forest Pirate')
                local enemy = ScriptStorage.Enemies and ScriptStorage.Enemies["Forest Pirate"]
                local targetCF = enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy.HumanoidRootPart.CFrame
                if not targetCF and ScriptStorage.MobRegions and ScriptStorage.MobRegions["Forest Pirate"] then
                    targetCF = ScriptStorage.MobRegions["Forest Pirate"][0]
                end
                if targetCF then TweenController.Create(targetCF) end
                CdkProgess = nil
            elseif k[2] == 2 then
                SetTask('SubTask', '⚔️ CDK: Evil trial - Haze monster')
                local hazeMon = FunctionsHandler.CursedDualKatana.Methods.GetHazeMon:Call()
                if hazeMon then CombatController.Attack(hazeMon) end
                CdkProgess = nil
            elseif k[2] == 3 then
                SetTask('SubTask', '⚔️ CDK: Evil trial - Soul Reaper')
                while not (os.time() - (TorchEnabledTime or 0) < 100 or not (ScriptStorage.Enemies and ScriptStorage.Enemies["Soul Reaper"])) do
                    task.wait()
                    if FunctionsHandler.RaidController.Methods.GetCurrentRaidIsland:Call() then
                        pcall(function() LocalPlayer.Character.Humanoid.Health = 0 end)
                    end
                    if ScriptStorage.Enemies["Soul Reaper"] then
                        TweenController.Create(ScriptStorage.Enemies["Soul Reaper"]:GetModelCFrame())
                    end
                end
                if not (ScriptStorage.Enemies and ScriptStorage.Enemies["Soul Reaper"]) then return end
                FunctionsHandler.CursedDualKatana.Methods.DoDimension:Call("Hell Dimension")
                CdkProgess = nil
            end
        else
            if k[2] == 1 then
                SetTask('SubTask', '⚔️ CDK: Good trial - Boat Dealer')
                local npcsFolder = game:GetService("ReplicatedStorage"):FindFirstChild("NPCs")
                if npcsFolder then
                    for _, npc in pairs(npcsFolder:GetChildren()) do
                        if npc.Name == "Luxury Boat Dealer" then
                            repeat
                                task.wait()
                                if os.time() - (DoneCdkTick or 0) < 15 then return end
                                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = npc:GetModelCFrame()
                                end
                                local realNPC = nil
                                if workspace:FindFirstChild("NPCs") then
                                    for _, n in pairs(workspace.NPCs:GetChildren()) do
                                        if CaculateDistance(n:GetModelCFrame(), npc:GetModelCFrame()) < 20 then
                                            realNPC = n
                                            break
                                        end
                                    end
                                end
                            until CaculateDistance(npc:GetModelCFrame()) < 5 and realNPC
                            Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", realNPC)
                        end
                    end
                end
                CdkProgess = nil
            elseif k[2] == 3 then
                SetTask('SubTask', '⚔️ CDK: Good trial - Cake Queen')
                repeat
                    task.wait()
                    CombatController.Attack("Cake Queen")
                until os.time() - (TorchEnabledTime or 0) < 10 or not (ScriptStorage.Enemies and ScriptStorage.Enemies['Cake Queen'])
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    TweenController.Create(LocalPlayer.Character.HumanoidRootPart.CFrame)
                end
                FunctionsHandler.CursedDualKatana.Methods.DoDimension:Call("Heavenly Dimension")
                CdkProgess = nil
            end
        end
    end)

    -- ============================================================
    -- NOTIFICATION LISTENERS
    -- ============================================================
    local listeners = {Listeners = {}}
    TorchEnabledTime = TorchEnabledTime or 0
    DoneCdkTick = DoneCdkTick or 0
    
    getgenv().NotificationCallBack = function(msg)
        if not msg then return end
        for key, callback in pairs(listeners.Listeners) do
            if string.find(string.lower(msg), string.lower(key)) then
                callback(msg)
            end
        end
    end
    
    function listeners:RegisterNotifyListener(key, callback)
        self.Listeners[key] = callback
    end
    
    listeners:RegisterNotifyListener('go!', function() LastRaidAlert = os.time() end)
    listeners:RegisterNotifyListener('raid', function() LastRaidAlert2 = os.time() end)
    listeners:RegisterNotifyListener("level", function() if AddPoint then AddPoint() end end)
    listeners:RegisterNotifyListener("torch", function() TorchEnabledTime = os.time() end)
    listeners:RegisterNotifyListener("scroll reacts", function() DoneCdkTick = os.time() end)
    listeners:RegisterNotifyListener("elite", function()
        FunctionsHandler.Yama:Set('EliteCount', Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
    end)
    
    -- ============================================================
    -- SERVER MANAGEMENT
    -- ============================================================
    local cachedServers = nil
    local lastServersPull = 0
    
    function GetServers()
        if lastServersPull and os.time() - lastServersPull < 60 then
            return cachedServers
        end
        for page = 1, 100 do
            local success, data = pcall(function()
                return game:GetService("ReplicatedStorage"):WaitForChild("__ServerBrowser", 5):InvokeServer(page)
            end)
            if success and data and next(data) then
                lastServersPull = os.time()
                cachedServers = data
                return data
            end
        end
    end
    
    task.spawn(function()
        GetServers()
        while task.wait(180) do GetServers() end
    end)

    -- ============================================================
    -- STORAGE
    -- ============================================================
    Storage = {WRITE_DELAY = 0.5, Data = {}}
    local storageFile = ".storage_u_" .. tostring(LocalPlayer and LocalPlayer.Name or "Player")
    
    function Storage.Set(key, value) Storage.Data[key] = value end
    function Storage.Get(key) return Storage.Data[key] end
    
    function Storage.Save()
        pcall(function()
            if writefile and HttpService then writefile(storageFile, HttpService:JSONEncode(Storage.Data)) end
        end)
    end
    
    if isfile and readfile and not isfile(storageFile) then
        pcall(writefile, storageFile, "{}")
    end
    if readfile and HttpService then
        pcall(function() Storage.Data = HttpService:JSONEncode(readfile(storageFile) or '{}') end)
    end
    
    task.spawn(function()
        while task.wait(Storage.WRITE_DELAY) do Storage.Save() end
    end)

    -- ============================================================
    -- FPS BOOST
    -- ============================================================
    local function EnableFpsBoost()
        task.spawn(function()
            pcall(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local effect = ReplicatedStorage:FindFirstChild("Effect")
                if effect then effect:Destroy() end
                
                if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
                    local fastBtn = LocalPlayer.PlayerGui:FindFirstChild("Main")
                    if fastBtn and fastBtn:FindFirstChild("Settings") and fastBtn.Settings:FindFirstChild("Buttons") then
                        local btn = fastBtn.Settings.Buttons:FindFirstChild("FastModeButton")
                        if btn and getconnections then
                            for _, conn in pairs(getconnections(btn.Activated)) do
                                conn.Function()
                            end
                        end
                    end
                end
                
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                        obj.Lifetime = NumberRange.new(0)
                    elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                        obj.Enabled = false
                    end
                end
                
                local lighting = game:GetService("Lighting")
                lighting.GlobalShadows = false
                lighting.FogEnd = 9e9
                lighting.Brightness = 0
                
                if settings and settings().Rendering then
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                end
                print("[✅ FPS Boost] Applied!")
            end)
        end)
    end
    EnableFpsBoost()

    -- ============================================================
    -- AUTO START - EXECUTE EVERYTHING
    -- ============================================================
    StartTick = StartTick or tick()
    SetText('MainTextLabel', 'Loaded In ' .. math.floor((tick() - StartTick) * 1000) / 1000 .. 's!')
    if AddPoint then AddPoint() end
    if J and J.RefreshQuest then J:RefreshQuest() end
    if RefreshInventory then RefreshInventory() end
    
    -- Main Execution Loop
    while task.wait() do
        if Config and Config.Configuration and Config.Configuration.HopWhenIdle and LastIdling and os.time() - LastIdling > 300.0 then
            SetTask('MainTask', "Rejoining due idle in 10 min!")
            task.wait(1)
            game:GetService('TeleportService'):Teleport(game.PlaceId)
        end
        
        if not AnimationDelay or os.time() - AnimationDelay > 60 then
            AnimationDelay = os.time()
        end
        
        if ScriptStorage and ScriptStorage.PlayerData and ScriptStorage.PlayerData.Level and ScriptStorage.PlayerData.Level > 0 then
            local success, err = xpcall(RefreshTasksData, debug.traceback)
            if not success then
                print('[ Error ]', err)
                task.wait(1)
            end
        else
            task.wait(1)
            if RefreshPlayerData then pcall(RefreshPlayerData) end
        end
    end
end

-- ============================================================
-- START SCRIPT
-- ============================================================
hoangtuveu()
