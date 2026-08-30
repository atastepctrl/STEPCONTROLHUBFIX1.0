-- PREMIUM HUB | BLOX FRUITS
-- Delta Mobile Optimized | Rayfield UI | Full Async Architecture
-- Integrated Remotes: CommF_, RE/RegisterAttack, RE/RegisterHit
-- Physics Stabilized | No-Placeholder Policy

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")
local Data = LocalPlayer:WaitForChild("Data")
local Level = Data:WaitForChild("Level")
local Points = Data:WaitForChild("Points")

local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local RegAttack = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack")
local RegHit = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit")

local V3 = Vector3.new
local CF = CFrame.new

local Sea1Monsters = {
   ["Snow Bandit [Lv. 90]"]={false,{V3(1273.748046875,88.79000854492188,-1345.8399658203125),V3(1458.7080078125,88.79000854492188,-1447.1500244140625),V3(1381.324951171875,88.79000854492188,-1464.9429931640625),V3(1316.1629638671875,88.79000854492188,-1396.5240478515625),V3(1199.3280029296875,88.79000854492188,-1329.0379638671875)}},
   ["Magma Admiral [Lv. 350] [Boss]"]={true,{V3(-5521.60205078125,19.800003051757812,8753.4697265625)}},
   ["Military Soldier [Lv. 300]"]={false,{V3(-5565.60205078125,9.100006103515625,8327.5693359375),V3(-5287.2001953125,9.100006103515625,8659.865234375),V3(-5413.60107421875,9.100006103515625,8591.2646484375),V3(-5667.7998046875,9.100006103515625,8428.666015625),V3(-5439.8017578125,9.100006103515625,8349.1689453125)}},
   ["Snowman [Lv. 100]"]={false,{V3(1190.0889892578125,106.80999755859375,-1626.5810546875),V3(1148.2490234375,106.80999755859375,-1429.3199462890625),V3(1035.97900390625,106.80999755859375,-1489.3599853515625),V3(1265.489013671875,106.80999755859375,-1483.4200439453125)}},
   ["Pirate [Lv. 35]"]={false,{V3(-1182.512939453125,5.600006103515625,3972.157958984375),V3(-1289.512939453125,5.600006103515625,3940.157958984375),V3(-1140.512939453125,5.600006103515625,3902.157958984375),V3(-972.4329833984375,13.600006103515625,3939.2470703125),V3(-967.4329833984375,13.600006103515625,4034.2470703125),V3(-1269.512939453125,5.600006103515625,3857.157958984375)}},
   ["Military Spy [Lv. 325]"]={false,{V3(-5857.30419921875,78.5,8775.9677734375),V3(-5917.7041015625,78.5,8844.5693359375),V3(-5806.701171875,78.5,8904.4697265625),V3(-5787.0048828125,78.5,8651.6630859375)}},
   ["Fishman Warrior [Lv. 375]"]={false,{V3(60841.90234375,17.949005126953125,1651.1109619140625),V3(60840.90234375,17.949005126953125,1301.1109619140625),V3(60943.90234375,17.949005126953125,1744.1109619140625),V3(60788.90234375,17.949005126953125,1526.1109619140625),V3(60906.90234375,17.949005126953125,1469.1109619140625),V3(60948.90234375,17.949005126953125,1377.1109619140625),V3(60927.90234375,17.949005126953125,1179.1109619140625)}},
   ["Chef [Lv. 55] [Boss]"]={true,{V3(-1132.916015625,32.410003662109375,4105.2548828125)}},
   ["Fishman Lord [Lv. 425] [Boss]"]={true,{V3(61352.90234375,35.061004638671875,1029.1109619140625)}},
   ["Dark Master [Lv. 175]"]={false,{V3(-5244.18017578125,389.5,-2155.013916015625),V3(-5234.18017578125,389.5,-2367.013916015625),V3(-5171.18017578125,389.5,-2243.013916015625),V3(-5339.18017578125,389.5,-2258.013916015625)}},
   ["Trainee [Lv. 5]"]={false,{V3(-2726.2509765625,24.287002563476562,2238.48095703125),V3(-2966.090087890625,39.337005615234375,2319.31103515625),V3(-2857.823974609375,41.86199951171875,2122.800048828125),V3(-2965.823974609375,41.86199951171875,2170.800048828125),V3(-2888.823974609375,41.86199951171875,2226.800048828125),V3(-2820.2509765625,24.287002563476562,2172.48095703125),V3(-2788.2509765625,24.287002563476562,2281.48095703125)}},
   ["Brute [Lv. 45]"]={false,{V3(-862.8900146484375,15.600006103515625,4281.9560546875),V3(-979.7150268554688,15.600006103515625,4234.755859375),V3(-1048.6429443359375,15.600006103515625,4405.35888671875),V3(-1230.3709716796875,15.600006103515625,4331.93701171875),V3(-1191.4119873046875,15.600006103515625,4235.5087890625),V3(-1397.7340087890625,15.600006103515625,4185.5849609375)}},
   ["Gladiator [Lv. 275]"]={false,{V3(-1370.3580322265625,7.9459991455078125,-3377.35888671875),V3(-1228.0870361328125,7.9459991455078125,-3051.791015625),V3(-1125.071044921875,7.9459991455078125,-3270.25),V3(-1356.958984375,7.9459991455078125,-3590.60595703125),V3(-1483.7039794921875,7.9459991455078125,-3195.2119140625)}},
   ["Galley Pirate [Lv. 625]"]={false,{V3(5348.283203125,39.3489990234375,3953.2548828125),V3(5654.0732421875,39.3489990234375,3914.322021484375),V3(5483.0732421875,55.3489990234375,4059.322021484375),V3(5522.0732421875,39.3489990234375,3934.322021484375),V3(5838.0732421875,39.3489990234375,3914.322021484375),V3(5717.0732421875,57.3489990234375,4042.322021484375)}},
   ["Galley Captain [Lv. 650]"]={false,{V3(5352.0078125,39.3489990234375,4929.39892578125),V3(5792.35400390625,58.93499755859375,4823.9228515625),V3(5584.0078125,60.3489990234375,4856.39892578125),V3(5557.0078125,39.3489990234375,4996.39892578125),V3(5892.35400390625,39.93499755859375,4951.9228515625),V3(5417.0078125,61.3489990234375,4780.39892578125),V3(5922.3720703125,58.93499755859375,4765.8408203125),V3(5954.9619140625,39.3489990234375,4882.10205078125)}},
   ["Chief Petty Officer [Lv. 120]"]={false,{V3(-4989.31298828125,20.5,3947.639892578125),V3(-5121.35107421875,20.5,4059.597900390625),V3(-4805.2421875,20.5,3993.881103515625),V3(-4923.10693359375,20.5,4076.94189453125),V3(-4614.81103515625,20.5,4416.05712890625),V3(-4633.921875,20.5,4551.8330078125),V3(-4808.6650390625,20.5,4540.44921875),V3(-4873.9091796875,20.5,4655.72412109375)}},
   ["Fishman Commando [Lv. 400]"]={false,{V3(61785.90234375,18.080001831054688,1284.1109619140625),V3(62051.90234375,18.080001831054688,1422.1109619140625),V3(61760.8984375,18.080001831054688,1460.1109619140625),V3(61697.8984375,18.080001831054688,1519.1109619140625),V3(61976.90234375,18.080001831054688,1617.1109619140625),V3(61858.8984375,18.080001831054688,1695.1109619140625)}},
   ["Cyborg [Lv. 675] [Boss]"]={true,{V3(6216.625,8.337997436523438,3990.00390625)}},
   ["God's Guard [Lv. 450]"]={false,{V3(-4830.60888671875,844.135009765625,-1779.0909423828125),V3(-4616.88720703125,844.135009765625,-2043.1910400390625),V3(-4583.8720703125,843.1959838867188,-1938.4339599609375),V3(-4863.4169921875,844.135009765625,-1909.6800537109375),V3(-4820.56689453125,844.135009765625,-2049.014892578125),V3(-4700.31298828125,844.135009765625,-1792.7960205078125)}},
   ["Thunder God [Lv. 575] [Boss]"]={true,{V3(-7779.26123046875,5606.93701171875,-2421.949951171875)}},
   ["Monkey [Lv. 14]"]={false,{V3(-1292.6700439453125,10.899993896484375,-4.850006103515625),V3(-1202.5,10.899993896484375,278.8699951171875),V3(-1743.530029296875,20.979995727539062,-91.27000427246094),V3(-1489.25,20.979995727539062,88.49000549316406),V3(-1579.218994140625,20.979995727539062,377.6000061035156),V3(-1801.0799560546875,20.979995727539062,111.29000854492188),V3(-1610.469970703125,20.979995727539062,-48.05000305175781)}},
   ["Royal Soldier [Lv. 550]"]={false,{V3(-7759.458984375,5606.93701171875,-1862.7030029296875),V3(-7946.9501953125,5606.93701171875,-1824.012939453125),V3(-7936.9501953125,5606.93701171875,-1625.012939453125),V3(-7916.9501953125,5606.93701171875,-1721.012939453125),V3(-7762.33984375,5606.93701171875,-1721.012939453125)}},
   ["Shanda [Lv. 475]"]={false,{V3(-7725.43017578125,5546.3408203125,-586.8939819335938),V3(-7710.76513671875,5546.3408203125,-336.4460144042969),V3(-7564.56201171875,5546.3408203125,-417.35198974609375),V3(-7795.76513671875,5546.3408203125,-486.4460144042969),V3(-7595.15380859375,5546.3408203125,-653.5570068359375),V3(-7539.62109375,5546.3408203125,-515.8170166015625)}},
   ["Ice Admiral [Lv. 700] [Boss]"]={true,{V3(1266.0889892578125,26.80999755859375,-1399.5810546875)}},
   ["Royal Squad [Lv. 525]"]={false,{V3(-7669.9501953125,5606.93701171875,-1379.012939453125),V3(-7513.9501953125,5606.93701171875,-1421.012939453125),V3(-7842.9501953125,5606.93701171875,-1403.012939453125),V3(-7724.9501953125,5606.93701171875,-1511.012939453125),V3(-7527.9501953125,5606.93701171875,-1539.012939453125)}},
   ["Wysper [Lv. 500] [Boss]"]={true,{V3(-7995.296875,5542.3408203125,-709.2750244140625)}},
   ["Toga Warrior [Lv. 250]"]={false,{V3(-2128.410888671875,7.878997802734375,-2853.248046875),V3(-1799.862060546875,7.878997802734375,-2852.52490234375),V3(-1672.97900390625,7.878997802734375,-2683.60498046875)}},
   ["Mob Leader [Lv. 120] [Boss]"]={true,{V3(-2880.716064453125,9.1300048828125,5430.85302734375)}},
   ["Sky Bandit [Lv. 150]"]={false,{V3(-4860.96923828125,277.9150085449219,-2904.906005859375),V3(-5081.96923828125,277.9150085449219,-2938.906005859375),V3(-4944.96923828125,277.9150085449219,-2784.906005859375),V3(-5119.64599609375,274.9150085449219,-2809.841064453125)}},
   ["Dangerous Prisoner [Lv. 210]"]={false,{V3(4955.9150390625,-0.5,925.530029296875),V3(5645.55712890625,-0.5,764.614013671875),V3(5485.283203125,-0.5,468.0660095214844),V3(5099.6572265625,-0.5,1055.7530517578125),V3(5442.0390625,-0.5,1078.8800048828125),V3(5561.3662109375,-0.5,964.7429809570312),V3(5554.5029296875,-0.5,584.7230224609375)}},
   ["Prisoner [Lv. 190]"]={false,{V3(5224.7568359375,-0.3000030517578125,449.4490051269531),V3(4937.31884765625,-0.5,649.5750122070312),V3(5067.125,-0.3000030517578125,546.4660034179688),V3(5351.63720703125,-0.3000030517578125,391.1059875488281),V3(5089.77880859375,-0.3000030517578125,423.6650085449219)}},
   ["The Gorilla King [Lv. 25] [Boss]"]={true,{V3(-1088.760009765625,8.229995727539062,-488.55999755859375)}},
   ["Desert Bandit [Lv. 60]"]={false,{V3(1001.0549926757812,7.56500244140625,4488.61083984375),V3(859.8150024414062,7.56500244140625,4488.06005859375),V3(931.7050170898438,7.56500244140625,4534.033203125),V3(937.0349731445312,7.56500244140625,4428.8291015625)}},
   ["Warden [Lv. 220] [Boss]"]={true,{V3(5278.0458984375,0.3910064697265625,944.10101318359375)}},
   ["Gorilla [Lv. 20]"]={false,{V3(-1249.18994140625,8.229995727539062,-456.19000244140625),V3(-1249.18994140625,8.229995727539062,-549.6799926757812),V3(-1363.18994140625,20.229995727539062,-486.19000244140625),V3(-1186.6190185546875,11.067001342773438,-650.2750244140625)}},
   ["Vice Admiral [Lv. 130] [Boss]"]={true,{V3(-5142.48291015625,101.5,4447.42919921875)}},
   ["Yeti [Lv. 110] [Boss]"]={true,{V3(1121.1600341796875,110.83999633789062,-1537.1300048828125)}},
   ["Desert Officer [Lv. 70]"]={false,{V3(1664.676025390625,14.748001098632812,4317.791015625),V3(1578.365966796875,3.8849945068359375,4299.23291015625),V3(1671.76904296875,9.748001098632812,4392.88818359375),V3(1611.27099609375,1.31500244140625,4465.52978515625)}},
   ["Chief Warden [Lv. 230] [Boss]"]={true,{V3(5206.9267578125,0.3910064697265625,814.97601318359375)}},
}

local QuestDB = {
   {Min=0,Max=9,Quest="MarineQuest1",Level=1,Mob="Trainee [Lv. 5]"},
   {Min=10,Max=19,Quest="JungleQuest",Level=1,Mob="Monkey [Lv. 14]"},
   {Min=20,Max=29,Quest="JungleQuest",Level=2,Mob="Gorilla [Lv. 20]"},
   {Min=30,Max=39,Quest="BuggyQuest1",Level=1,Mob="Pirate [Lv. 35]"},
   {Min=40,Max=59,Quest="BuggyQuest1",Level=2,Mob="Brute [Lv. 45]"},
   {Min=60,Max=74,Quest="DesertQuest",Level=1,Mob="Desert Bandit [Lv. 60]"},
   {Min=75,Max=89,Quest="DesertQuest",Level=2,Mob="Desert Officer [Lv. 70]"},
   {Min=90,Max=99,Quest="SnowQuest",Level=1,Mob="Snow Bandit [Lv. 90]"},
   {Min=100,Max=119,Quest="SnowQuest",Level=2,Mob="Snowman [Lv. 100]"},
   {Min=120,Max=149,Quest="MarineQuest2",Level=1,Mob="Chief Petty Officer [Lv. 120]"},
   {Min=150,Max=174,Quest="SkyQuest",Level=1,Mob="Sky Bandit [Lv. 150]"},
   {Min=175,Max=189,Quest="SkyQuest",Level=2,Mob="Dark Master [Lv. 175]"},
   {Min=190,Max=209,Quest="PrisonQuest",Level=1,Mob="Prisoner [Lv. 190]"},
   {Min=210,Max=249,Quest="PrisonQuest",Level=2,Mob="Dangerous Prisoner [Lv. 210]"},
   {Min=250,Max=274,Quest="ColosseumQuest",Level=1,Mob="Toga Warrior [Lv. 250]"},
   {Min=275,Max=299,Quest="ColosseumQuest",Level=2,Mob="Gladiator [Lv. 275]"},
   {Min=300,Max=324,Quest="MagmaQuest",Level=1,Mob="Military Soldier [Lv. 300]"},
   {Min=325,Max=374,Quest="MagmaQuest",Level=2,Mob="Military Spy [Lv. 325]"},
   {Min=375,Max=399,Quest="FishmanQuest",Level=1,Mob="Fishman Warrior [Lv. 375]"},
   {Min=400,Max=449,Quest="FishmanQuest",Level=2,Mob="Fishman Commando [Lv. 400]"},
   {Min=450,Max=474,Quest="SkyQuest2",Level=1,Mob="God's Guard [Lv. 450]"},
   {Min=475,Max=524,Quest="SkyQuest2",Level=2,Mob="Shanda [Lv. 475]"},
   {Min=525,Max=549,Quest="FountainQuest",Level=1,Mob="Royal Squad [Lv. 525]"},
   {Min=550,Max=624,Quest="FountainQuest",Level=2,Mob="Royal Soldier [Lv. 550]"},
   {Min=625,Max=649,Quest="FountainQuest",Level=3,Mob="Galley Pirate [Lv. 625]"},
   {Min=650,Max=699,Quest="FountainQuest",Level=3,Mob="Galley Captain [Lv. 650]"},
}

local SupportedWeaponTypes = {Melee=true,Sword=true,Gun=true,["Blox Fruit"]=true,["Demon Fruit"]=true}
local AvailableWeapons = {}
local SelectedWeapon = nil

local function GetWeaponType(Tool)
   if not Tool or not Tool:IsA("Tool") then return nil end
   local a = Tool:GetAttribute("WeaponType")
   if typeof(a)=="string" then
   	if SupportedWeaponTypes[a] then return a end
   	if a=="BloxFruit" or a=="DemonFruit" then return "Blox Fruit" end
   end
   local t = Tool:FindFirstChild("Type")
   if t and t:IsA("StringValue") and SupportedWeaponTypes[t.Value] then return t.Value end
   return nil
end

local function ScanWeapons()
   local list = {}
   local lookup = {}
   local function Scan(c)
   	if not c then return end
   	for _,v in ipairs(c:GetChildren()) do
   		if v:IsA("Tool") then
   			local wt = GetWeaponType(v)
   			if wt and not lookup[v.Name] then
   				lookup[v.Name] = true
   				table.insert(list,{Name=v.Name,Type=wt,Tool=v})
   			end
   		end
   	end
   end
   Scan(LocalPlayer:FindFirstChildOfClass("Backpack"))
   Scan(LocalPlayer.Character)
   table.sort(list,function(a,b) return a.Name < b.Name end)
   AvailableWeapons = list
   local names = {}
   for _,w in ipairs(list) do table.insert(names,w.Name.." ["..w.Type.."]") end
   return names
end

local function EquipWeapon(name)
   local c = LocalPlayer.Character
   local h = c and c:FindFirstChildOfClass("Humanoid")
   if not h then return false end
   if c:FindFirstChild(name) then return true end
   local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
   if not bp then return false end
   local t = bp:FindFirstChild(name)
   if t then h:EquipTool(t) return true end
   return false
end

local function KeepWeaponEquipped()
   if SelectedWeapon then EquipWeapon(SelectedWeapon) end
end

local function GetQuestForLevel(lvl)
   -- FORCE PIRATE STARTER ISLAND FOR LEVELS 1-10
   if lvl >= 0 and lvl <= 9 then
   	return {Min=0,Max=9,Quest="MarineQuest1",Level=1,Mob="Bandit [Lv. 5]"}
   end
   for _,v in ipairs(QuestDB) do
   	if lvl >= v.Min and lvl <= v.Max then return v end
   end
   return nil
end

local S = {
   Farm = false,
   Speed = 325,
   Height = 40,
   Stats = {Melee=false,Defense=false,Sword=false,Gun=false,Fruit=false},
   TargetCF = nil,
   CurrentMob = "",
   IsTweening = false,
   AttackCombo = 1,
   QuestAccepted = false,
   Teleporting = false,
}

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "PREMIUM HUB | BLOX FRUITS",
   LoadingTitle = "Initializing Architecture...",
   LoadingSubtitle = "Delta Mobile",
   Theme = "Default",
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true,
})

local FarmTab = Window:CreateTab("Auto Farm")
local StatsTab = Window:CreateTab("Stats")
local SettingsTab = Window:CreateTab("Settings")

local WepNames = ScanWeapons()
local WepDrop = FarmTab:CreateDropdown({
   Name = "Weapon Selector",
   Options = WepNames,
   CurrentOption = WepNames[1] or "None",
   Flag = "WeaponSelector",
   Callback = function(opt)
   	SelectedWeapon = opt:match("^(.-) %[%w+%]$") or opt
   	EquipWeapon(SelectedWeapon)
   end,
})

FarmTab:CreateButton({
   Name = "Refresh Weapons",
   Callback = function()
   	WepDrop:Refresh(ScanWeapons())
   end,
})

FarmTab:CreateToggle({
   Name = "Main Auto Farm",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(v)
   	S.Farm = v
   	if not v then
   		S.TargetCF = nil
   		S.CurrentMob = ""
   		S.IsTweening = false
   		S.QuestAccepted = false
   		S.Teleporting = false
   	end
   end,
})

StatsTab:CreateToggle({Name="Auto Melee",CurrentValue=false,Flag="Melee",Callback=function(v) S.Stats.Melee=v end})
StatsTab:CreateToggle({Name="Auto Defense",CurrentValue=false,Flag="Defense",Callback=function(v) S.Stats.Defense=v end})
StatsTab:CreateToggle({Name="Auto Sword",CurrentValue=false,Flag="Sword",Callback=function(v) S.Stats.Sword=v end})
StatsTab:CreateToggle({Name="Auto Gun",CurrentValue=false,Flag="Gun",Callback=function(v) S.Stats.Gun=v end})
StatsTab:CreateToggle({Name="Auto Blox Fruit",CurrentValue=false,Flag="Fruit",Callback=function(v) S.Stats.Fruit=v end})

SettingsTab:CreateSlider({
   Name="Tween Speed",Range={250,400},Increment=5,CurrentValue=325,Flag="TweenSpeed",
   Callback=function(v) S.Speed=v end,
})
SettingsTab:CreateSlider({
   Name="Farm Height",Range={20,60},Increment=1,CurrentValue=40,Flag="FarmHeight",
   Callback=function(v) S.Height=v end,
})

local NoclipCon = nil
local function SetNoclip(on)
   if NoclipCon then NoclipCon:Disconnect() NoclipCon = nil end
   if on then
   	NoclipCon = RunService.Stepped:Connect(function()
   		if not Character then return end
   		for _,p in ipairs(Character:GetDescendants()) do
   			if p:IsA("BasePart") then p.CanCollide = false end
   		end
   	end)
   end
end

-- Auto-Quest Accept Function
local function AcceptQuest(q)
   if not q or S.QuestAccepted then return end
   pcall(function()
   	-- Tween to quest giver position based on level
   	local questPos = nil
   	local lvl = Level.Value
   	if lvl >= 0 and lvl <= 9 then
   		questPos = V3(-2968.090087890625,39.337005615234375,2319.31103515625) -- Bandit Quest Giver
   	elseif lvl >= 10 and lvl <= 19 then
   		questPos = V3(-1499.25,20.979995727539062,88.49000549316406)
   	elseif lvl >= 20 and lvl <= 29 then
   		questPos = V3(-1363.18994140625,20.229995727539062,-486.19000244140625)
   	elseif lvl >= 30 and lvl <= 59 then
   		questPos = V3(-1182.512939453125,5.600006103515625,3972.157958984375)
   	else
   		-- For other levels, use the first spawn point of the mob
   		local mobData = Sea1Monsters[q.Mob]
   		if mobData and mobData[2] and mobData[2][1] then
   			questPos = mobData[2][1]
   		end
   	end
   	
   	if questPos then
   		local targetCF = CF(questPos + V3(0,3,0))
   		local dist = (HRP.Position - targetCF.Position).Magnitude
   		if dist > 5 then
   			S.Teleporting = true
   			local t = math.min(dist / S.Speed, 3)
   			local tw = TweenService:Create(HRP, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame=targetCF})
   			tw:Play()
   			tw.Completed:Wait()
   			S.Teleporting = false
   		end
   		task.wait(0.5)
   		CommF_:InvokeServer("StartQuest", q.Quest, q.Level)
   		S.QuestAccepted = true
   		task.wait(0.5)
   	end
   end)
end

-- Async Farm Director
task.spawn(function()
   while task.wait(0.3) do
   	if not S.Farm then
   		SetNoclip(false)
   		continue
   	end
   	pcall(function()
   		SetNoclip(true)
   		local q = GetQuestForLevel(Level.Value)
   		if not q then return end
   		
   		-- Accept quest if needed
   		if not S.QuestAccepted then
   			AcceptQuest(q)
   			task.wait(0.5)
   			continue
   		end
   		
   		-- Get mob spawn position (above ground for safe hovering)
   		local mobData = Sea1Monsters[q.Mob]
   		local mobPos = nil
   		if mobData and mobData[2] and mobData[2][1] then
   			mobPos = mobData[2][1]
   		else
   			-- Fallback: use quest position
   			local fallbackPos = HRP.Position
   			mobPos = fallbackPos
   		end
   		
   		-- Set target to hover above mob spawn
   		local hoverHeight = S.Height
   		S.TargetCF = CF(mobPos + V3(0, hoverHeight, 0))
   		
   		-- Tween to target if not already there
   		if S.TargetCF and not S.IsTweening and not S.Teleporting then
   			local dist = (HRP.Position - S.TargetCF.Position).Magnitude
   			if dist > 5 then
   				S.IsTweening = true
   				local t = math.min(dist / S.Speed, 4)
   				local tw = TweenService:Create(HRP, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame=S.TargetCF})
   				tw:Play()
   				tw.Completed:Wait()
   				S.IsTweening = false
   			end
   		end
   	end)
   end
end)

-- Async Physics Stabilizer & Mob Stack Engine
task.spawn(function()
   while task.wait(0.025) do
   	if not S.Farm or not S.TargetCF or S.IsTweening or S.Teleporting then continue end
   	pcall(function()
   		-- Stabilize player
   		HRP.CFrame = S.TargetCF
   		HRP.Velocity = V3(0,0,0)
   		HRP.AssemblyLinearVelocity = V3(0,0,0)
   		HRP.RotVelocity = V3(0,0,0)
   		Humanoid.Sit = false
   		Humanoid.PlatformStand = false
   		
   		-- Stack mobs under player
   		local currentMob = S.CurrentMob
   		if currentMob and currentMob ~= "" then
   			for _,e in ipairs(Workspace.Enemies:GetChildren()) do
   				if e.Name == currentMob and e:FindFirstChild("Humanoid") and e:FindFirstChild("HumanoidRootPart") then
   					local h = e.HumanoidRootPart
   					if e.Humanoid.Health > 0 then
   						-- Stack directly under player
   						local targetPos = HRP.Position + V3(0, -6, 0)
   						h.CFrame = CF(targetPos)
   						h.CanCollide = false
   						h.Velocity = V3(0,0,0)
   						h.AssemblyLinearVelocity = V3(0,0,0)
   						e.Humanoid.WalkSpeed = 0
   						e.Humanoid.JumpPower = 0
   						
   						-- Remove animator to prevent glitching
   						local anim = e.Humanoid:FindFirstChild("Animator")
   						if anim then anim:Destroy() end
   					end
   				end
   			end
   		end
   	end)
   end
end)

-- Async Kill Aura - Fast Attack
task.spawn(function()
   while task.wait(0.03) do
   	if not S.Farm or not S.TargetCF or S.IsTweening or S.Teleporting then continue end
   	pcall(function()
   		-- Fast attack loop
   		local currentMob = S.CurrentMob
   		if currentMob and currentMob ~= "" then
   			-- Fire attack every cycle
   			RegAttack:FireServer(0.5, S.AttackCombo)
   			S.AttackCombo = S.AttackCombo == 1 and 2 or 1
   			
   			-- Hit all mobs in area
   			for _,e in ipairs(Workspace.Enemies:GetChildren()) do
   				if e.Name == currentMob and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
   					local p = e:FindFirstChild("HumanoidRootPart") or e:FindFirstChild("RightLowerLeg") or e:FindFirstChild("RightLowerArm")
   					if p then
   						RegHit:FireServer(p, {})
   					end
   				end
   			end
   		end
   	end)
   end
end)

-- Async Auto Equip
task.spawn(function()
   while task.wait(0.25) do
   	if SelectedWeapon then
   		pcall(KeepWeaponEquipped)
   	end
   end
end)

-- Async Stat Distributor
task.spawn(function()
   Points.Changed:Connect(function()
   	if Points.Value <= 0 then return end
   	task.spawn(function()
   		while Points.Value > 0 do
   			for stat,en in pairs(S.Stats) do
   				if en and Points.Value > 0 then
   					local s = stat == "Fruit" and "Demon Fruit" or stat
   					pcall(function()
   						CommF_:InvokeServer("AddPoint", s, 1)
   					end)
   					task.wait(0.08)
   				end
   			end
   			task.wait()
   		end
   	end)
   end)
end)

-- Monster death detection to reset quest acceptance
task.spawn(function()
   while task.wait(0.5) do
   	if not S.Farm then continue end
   	pcall(function()
   		local currentMob = S.CurrentMob
   		if currentMob and currentMob ~= "" then
   			local alive = false
   			for _,e in ipairs(Workspace.Enemies:GetChildren()) do
   				if e.Name == currentMob and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
   					alive = true
   					break
   				end
   			end
   			if not alive then
   				S.QuestAccepted = false
   				S.CurrentMob = ""
   				task.wait(0.5)
   			end
   		end
   	end)
   end
end)

-- Character added event
LocalPlayer.CharacterAdded:Connect(function(c)
   Character = c
   Humanoid = c:WaitForChild("Humanoid")
   HRP = c:WaitForChild("HumanoidRootPart")
   if S.Farm then SetNoclip(true) end
   S.QuestAccepted = false
   S.CurrentMob = ""
   S.TargetCF = nil
   S.IsTweening = false
   S.Teleporting = false
end)

Rayfield:Notify({Title="Premium Hub",Content="Architecture loaded. Enable Auto Farm to begin.",Duration=6})
