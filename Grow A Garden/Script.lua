local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player  = Players.LocalPlayer

-- Remotes for buying items
local buySeedRemote = ReplicatedStorage.GameEvents:WaitForChild("BuySeedStock")
local buyGearRemote = ReplicatedStorage.GameEvents:WaitForChild("BuyGearStock")
local buyPetEggRemote = ReplicatedStorage.GameEvents:WaitForChild("BuyPetEgg")
local buyBeeRemote = ReplicatedStorage.GameEvents:WaitForChild("BuyEventShopStock")

-- Remotes for actions
local plantRemote = ReplicatedStorage.GameEvents:WaitForChild("Plant_RE")
local beeEventRemote = ReplicatedStorage.GameEvents:WaitForChild("HoneyMachineService_RE")
local SellInventoryRemote = ReplicatedStorage.GameEvents:WaitForChild("Sell_Inventory")
local favoriteRemote = ReplicatedStorage.GameEvents:WaitForChild("Favorite_Item")

-- Service Remotes
local PetEggService = ReplicatedStorage.GameEvents:WaitForChild("PetEggService")
local feedPetRemote = ReplicatedStorage.GameEvents:WaitForChild("ActivePetService")

-- Data
local SeedData = require(ReplicatedStorage.Data.SeedData)
local SeedPackData = require(ReplicatedStorage.Data.SeedPackData)
local MutationData = require(ReplicatedStorage.Modules.MutationHandler)
local PetData = require(ReplicatedStorage.Data.PetRegistry.PetList)
local DataSer = require(ReplicatedStorage.Modules.DataService)

-- Networking
local ByteNetReliable = ReplicatedStorage:WaitForChild("ByteNetReliable")

local Notification = require(ReplicatedStorage.Modules.Notification)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local updateLogs = _G.script_setting.Update_Logs

local owner = _G.script_setting.Owner
local hub = _G.script_setting.Hub_Name
local scriptName = _G.script_setting.Name
local update = _G.script_setting.Update_Date
local discord_link = _G.script_setting.Discord_Link

local folder = hub
local file = folder .. _G.script_setting.Save_File

local HttpService = game:GetService("HttpService")

if not isfolder(folder) then makefolder(folder) end

if not isfile(file) then
    writefile(file, HttpService:JSONEncode({}))
end

local raw = readfile(file)
local Settings = HttpService:JSONDecode(raw) or {}

local defaults = {
    Plant = {
        Plant = {
            Select_Seeds = {},
            Auto_Plant = false
        },
        Harvert = {
            Select_Fruits = {},
            Select_Mutations = {},
            Auto_Harvert = false
        },
        Auto_Sell = {
            Select_Sell_Mode = {},
            Auto_Sell = false
        },
    },
    Egg = {
        Auto_Place_And_Hatch = {
            Select_Eggs_To_Place = {},
            Auto_Place_Egg = false,
            Auto_Hatch_Egg = false
        }
    },
    Pet = {
        Auto_Sell_Pet = {
            Select_Pet_To_Sell = {},
            Auto_Sell_Pet = false
        },
        Auto_Feed_Pet = {
            Select_Pet_To_Feed = {},
            Select_Fruit_To_Feed = {},
            Auto_Feed_Pet = false
        }
    },
    Event = {
        Swarm = {
            Auto_Collect_Honey = false,
            Auto_UnFavorite = false
        }
    },
    Shop = {
        Seed_Shop = {
            Select_Seeds = {},
            Auto_Buy_Seeds = false
        },
        Gear_Shop = {
            Select_Gears = {},
            Auto_Buy_Gears = false
        },
        Honey_Shop = {
            Select_Item = {},
            Auto_Buy_Items = false
        },
        Egg_Shop = {
            Select_Eggs = {},
            Auto_Buy_Eggs = false
        },
    },
    Misc = {
        Favorite = {
            Select_Favorite_Fruits = {},
            Select_Favorite_Mutations = {},
            Select_Favorite_Pets = {},
            Auto_Favorite = false
        }
    },
}

for cat, tbl in pairs(defaults) do
    Settings[cat] = Settings[cat] or {}
    for sub, subTbl in pairs(tbl) do
        Settings[cat][sub] = Settings[cat][sub] or subTbl
    end
end

writefile(file, HttpService:JSONEncode(Settings))

-- Plant > Plant
local saved_Select_Seeds = Settings.Plant.Plant.Select_Seeds
local saved_Auto_Plant = Settings.Plant.Plant.Auto_Plant

-- Plant > Harvert
local saved_Harvest_Fruits = Settings.Plant.Harvert.Select_Fruits
local saved_Harvest_Mutations = Settings.Plant.Harvert.Select_Mutations
local saved_Auto_Harvest = Settings.Plant.Harvert.Auto_Harvert

-- Plant > Auto_Sell
local saved_Sell_Modes = Settings.Plant.Auto_Sell.Select_Sell_Mode
local saved_Auto_Sell = Settings.Plant.Auto_Sell.Auto_Sell

-- Egg > Auto_Place_And_Hatch
local saved_Eggs_To_Place = Settings.Egg.Auto_Place_And_Hatch.Select_Eggs_To_Place
local saved_Auto_Place_Egg = Settings.Egg.Auto_Place_And_Hatch.Auto_Place_Egg
local saved_Auto_Hatch_Egg = Settings.Egg.Auto_Place_And_Hatch.Auto_Hatch_Egg

-- Pet > Auto_Sell_Pet
local saved_Pet_To_Sell = Settings.Pet.Auto_Sell_Pet.Select_Pet_To_Sell
local saved_Auto_Sell_Pet = Settings.Pet.Auto_Sell_Pet.Auto_Sell_Pet

-- Pet > Auto_Feed_Pet
local saved_Pet_To_Feed = Settings.Pet.Auto_Feed_Pet.Select_Pet_To_Feed
local saved_Fruit_To_Feed = Settings.Pet.Auto_Feed_Pet.Select_Fruit_To_Feed
local saved_Auto_Feed_Pet = Settings.Pet.Auto_Feed_Pet.Auto_Feed_Pet

-- Event > Swarm
local saved_Auto_Collect_Honey = Settings.Event.Swarm.Auto_Collect_Honey
local saved_Auto_UnFavorite = Settings.Event.Swarm.Auto_UnFavorite

-- Shop > Seed_Shop
local saved_Seed_Shop_Seeds = Settings.Shop.Seed_Shop.Select_Seeds
local saved_Auto_Buy_Seeds = Settings.Shop.Seed_Shop.Auto_Buy_Seeds

-- Shop > Gear_Shop
local saved_Gear_Shop = Settings.Shop.Gear_Shop.Select_Gears
local saved_Auto_Buy_Gears = Settings.Shop.Gear_Shop.Auto_Buy_Gears

-- Shop > Honey_Shop
local saved_Honey_Shop_Items  = Settings.Shop.Honey_Shop.Select_Item
local saved_Auto_Buy_Honey    = Settings.Shop.Honey_Shop.Auto_Buy_Items

-- Shop > Egg_Shop
local saved_Egg_Shop = Settings.Shop.Egg_Shop.Select_Eggs
local saved_Auto_Buy_Eggs = Settings.Shop.Egg_Shop.Auto_Buy_Eggs

-- Misc > Favorite
local saved_Favorite_Fruits = Settings.Misc.Favorite.Select_Favorite_Fruits
local saved_Favorite_Mutations = Settings.Misc.Favorite.Select_Favorite_Mutations
local saved_Favorite_Pets = Settings.Misc.Favorite.Select_Favorite_Pets
local saved_Auto_Favorite = Settings.Misc.Favorite.Auto_Favorite

local plant_data = {
    locations = {
        ["Plant"] = {
            [1] = {
                [1] = "12, 0, -105",
                [2] = "56, 0, -105"
            },
            [2] = {
                [1] = "56, 0, 77",
                [2] = "12, 0, 77"
            },
            [3] = {
                [1] = "-122, 0, -105",
                [2] = "-77, 0, -105"
            },
            [4] = {
                [1] = "-77, 0, 77",
                [2] = "-122, 0, 77"
            },
            [5] = {
                [1] = "-258, 0, -105",
                [2] = "-213, 0, -105"
            },
            [6] = {
                [1] = "-213, 0, 77",
                [2] = "-258, 0, 77"
            }
        },
        ["Place Egg"] = {
            [1] = {
                [1] = "3, 0, -105",
                [2] = "6, 0, -105",
                [3] = "9, 0, -105",
                [4] = "12, 0, -105",
                [5] = "14, 0, -105",
                [6] = "16, 0, -105",
                [7] = "18, 0, -105",
                [8] = "18, 0, -102",
            },
            [2] = {
                [1] = "3, 0, 77",
                [2] = "6, 0, 77",
                [3] = "9, 0, 77",
                [4] = "12, 0, 77",
                [5] = "14, 0, 77",
                [6] = "16, 0, 77",
                [7] = "18, 0, 77",
                [8] = "18, 0, 75",
            },
            [3] = {
                [1] = "-71, 0, -105",
                [2] = "-73, 0, -105",
                [3] = "-75, 0, -105",
                [4] = "-77, 0, -105",
                [5] = "-79, 0, -105",
                [6] = "-81, 0, -105",
                [7] = "-83, 0, -105",
                [8] = "-83, 0, -102",
            },
            [4] = {
                [1] = "-71, 0, 77",
                [2] = "-73, 0, 77",
                [3] = "-75, 0, 77",
                [4] = "-77, 0, 77",
                [5] = "-79, 0, 77",
                [6] = "-81, 0, 77",
                [7] = "-83, 0, 77",
                [8] = "-83, 0, 75",
            },
            [5] = {
                [1] = "-207, 0, -105",
                [2] = "-209, 0, -105",
                [3] = "-211, 0, -105",
                [4] = "-213, 0, -105",
                [5] = "-215, 0, -105",
                [6] = "-217, 0, -105",
                [7] = "-219, 0, -105",
                [8] = "-221, 0, -102",
            },
            [6] = {
                [1] = "-207, 0, 77",
                [2] = "-209, 0, 77",
                [3] = "-211, 0, 77",
                [4] = "-213, 0, 77",
                [5] = "-215, 0, 77",
                [6] = "-217, 0, 77",
                [7] = "-219, 0, 77",
                [8] = "-221, 0, 75",
            },
        }
    },
	mutations = {},
    shop = {},
    seed_pack  = {},
    swarm = {
        "Flower Seed Pack",
		"Lavender",
		"Nectarshade",
        "Nectarine",
        "Hive Fruit",
		"Pollen Radar",
		"Nectar Staff",
        "Honey Sprinkler",
        "Bee Egg",
        "Bee Crate",
        "Honey Comb",
        "Bee Chair",
        "Honey Torch",
        "Honey Walkway"
    }
}

local gear_data = {
    "Watering Can",
    "Trowel",
    "Recall Wrench",
    "Basic Sprinkler",
    "Advanced Sprinkler",
    "Godly Sprinkler",
    "Lightning Rod",
    "Master Sprinkler",
    "Favorite Tool",
    "Harvert Tool"
}

local pet_data = {}

local egg_data = {
    shop = {
        "Common",
        "Uncommon",
        "Rare",
        "Legendary",
        "Mythical",
        "Bug"
    },
    event = {
        Lunar_Glow_Event = {
            "Night"
        },
        Bizzy_Bee_Event = {
            "Bee",
			"Anti Bee"
        }
    }
}

local seedOptions = {}
for seedName, _ in pairs(SeedData) do
    table.insert(seedOptions, seedName)
end
table.sort(seedOptions, function(a, b)
    return SeedData[a].LayoutOrder < SeedData[b].LayoutOrder
end)

local shopOptions = {}
for seedName, data in pairs(SeedData) do
    if data.DisplayInShop then
        table.insert(shopOptions, seedName)
    end
end
table.sort(shopOptions, function(a, b)
    return SeedData[a].LayoutOrder < SeedData[b].LayoutOrder
end)
plant_data.shop = shopOptions

local mutationList = {}
for _, mut in pairs(MutationData:GetMutations()) do
    table.insert(mutationList, mut.Name)
end
table.sort(mutationList)
plant_data.mutations = mutationList

for name, info in pairs(PetData) do
    table.insert(pet_data, name)
end
table.sort(pet_data, function(a, b)
    local infoA, infoB = PetData[a], PetData[b]
    if infoA.LayoutOrder and infoB.LayoutOrder then
        return infoA.LayoutOrder < infoB.LayoutOrder
    end
    return a:lower() < b:lower()
end)

local farmRoot = workspace:WaitForChild("Farm")

local farmIndex = nil
for _, farmFolder in ipairs(farmRoot:GetChildren()) do
    local important = farmFolder:FindFirstChild("Important")
    if not important then
        warn("Not found folder 'Important' in :", farmFolder:GetFullName())
        continue
    end

    local dataFolder = important:FindFirstChild("Data")
    if not dataFolder then
        warn("Not found folder 'Data' in :", important:GetFullName())
        continue
    end

    local ownerValue = dataFolder:FindFirstChild("Owner")
    local farmNumberVal = dataFolder:FindFirstChild("Farm_Number")
    if not ownerValue or not farmNumberVal then
        warn("Owner or Farm_Number missing :", dataFolder:GetFullName())
        continue
    end

    if ownerValue.Value == player.Name then
        if typeof(farmNumberVal.Value) == "string" then
            farmIndex = tonumber(farmNumberVal.Value)
        else
            farmIndex = farmNumberVal.Value
        end

        if typeof(farmIndex) ~= "number" then
            warn("'Farm_Number' not a number :", farmNumberVal.Value)
            farmIndex = nil
        else
            print("Found Farm :", ownerValue.Value, "| Index :", farmIndex)
        end
    end
end

local Window = Fluent:CreateWindow({
    Title = hub .. " | " .. scriptName .. " | Update : " .. update,
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 380),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Log = Window:AddTab({ Title = "Activity Log", Icon = "key" }),
    Plant = Window:AddTab({ Title = "Planting Operations", Icon = "sprout" }),
    Egg = Window:AddTab({ Title = "Egg Management", Icon = "egg" }),
    Pet = Window:AddTab({ Title = "Pet Management", Icon = "bone" }),
    Event = Window:AddTab({ Title = "Events", Icon = "electricity" }),
    Shop = Window:AddTab({ Title = "Store", Icon = "shopping-cart" }),
    Misc = Window:AddTab({ Title = "Miscellaneous", Icon = "cpu" }),
    Settings = Window:AddTab({ Title = "Configuration", Icon = "settings" }),
}

local Options = Fluent.Options

do
    -- [ Log ]
    local welcome = Tabs.Log:AddSection("[ 👾 ] - Welcome")
    welcome:AddParagraph({
        Title = "Welcome to " .. hub .. " : " .. player.Name,
        Content = "This is a script for " .. scriptName .. "\n\nIf you'd like me to create any additional game scripts or the script very lag, please let me know on Discord Server\n\n[ Carefully crafted, ensuring simplicity ]"
    })
	local statusContent = ""
	local lines = {}
	for _, entry in ipairs(_G.script_setting.Script_Status) do
		local name, status = entry[1], entry[2]
		local icon

		if status == nil then
			icon = "🟡"
		else
			icon = status and "🟢" or "🔴"
		end

		lines[#lines+1] = icon .. " : " .. name
	end

	local statusContent = table.concat(lines, "\n")

	welcome:AddParagraph({
		Title   = "Script Status",
		Content = statusContent
	})
    welcome:AddButton({
        Title = "Discord Server",
        Description = discord_link,
        Callback = function()
            Window:Dialog({
                Title = "Join community?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            setclipboard(discord_link)
                            Fluent:Notify({
                                Title = hub,
                                Content = "Copied link !",
                                Duration = 5
                            })
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()

                        end
                    }
                }
            })
        end
    })
    welcome:AddButton({
        Title = "Reset Config",
        Description = "",
        Callback = function()
            Window:Dialog({
                Title = "Reset Config?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            if isfile(file) then
                                delfile(file)
                            end
                            player:Kick("Reset Config : " .. scriptName)
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()

                        end
                    }
                }
            })
        end
    })
    welcome:AddParagraph({
        Title = "Executor : " .. (identifyexecutor and identifyexecutor() or "Unknown")
    })
    local update_log = Tabs.Log:AddSection("[ 🧾 ] - Update log")
    for _, entry in ipairs(updateLogs) do
        local contentStr = ""

        local sectionOrder = { "Added", "Remove", "Fixed" }

        local lastIndexWithContent = 0
        for idx, section in ipairs(sectionOrder) do
            if entry.Content[section] and #entry.Content[section] > 0 then
                lastIndexWithContent = idx
            end
        end

        if lastIndexWithContent == 0 then
            update_log:AddParagraph({
                Title   = entry.Date,
                Content = ""
            })
        else
            for idx, section in ipairs(sectionOrder) do
                local lines = entry.Content[section]
                if lines and #lines > 0 then
                    contentStr = contentStr .. "# " .. section .. "\n"
                    for _, line in ipairs(lines) do
                        contentStr = contentStr .. "- " .. line .. "\n"
                    end
                    if idx < lastIndexWithContent then
                        contentStr = contentStr .. "\n"
                    end
                end
            end

            contentStr = contentStr:gsub("\n$", "")

            update_log:AddParagraph({
                Title   = entry.Date,
                Content = contentStr
            })
        end
    end


    -- [ Plant ]
    local function getPlayerFarmFolder()
        local farmParent = workspace:FindFirstChild("Farm")
        if not farmParent then return nil end

        for _, farmFolder in ipairs(farmParent:GetChildren()) do
            local important = farmFolder:FindFirstChild("Important")
            if important and important:FindFirstChild("Data") and important.Data:FindFirstChild("Owner") and important.Data:FindFirstChild("Farm_Number") then
                if important.Data.Owner.Value == player.Name then
                    return farmFolder
                end
            end
        end

        return nil
    end
    local auto_plant = Tabs.Plant:AddSection("[ 🌱 ] - Plant")
    local select_seed = auto_plant:AddDropdown("Select_Seed_Plant", {
        Title = "Select Seeds To Plant",
        Description = "You can select multiple Seeds",
        Values = seedOptions,
        Multi = true,
        Default = saved_Select_Seeds,
    })
    select_seed:OnChanged(function(newSelection)
        Settings.Plant.Plant.Select_Seeds = newSelection
        writefile(file, HttpService:JSONEncode(Settings))
    end)

    local precomputedPlantPositions = {}
    for i, locList in pairs(plant_data.locations["Plant"]) do
        precomputedPlantPositions[i] = {}
        for _, locStr in ipairs(locList) do
            local nums = {}
            for num in locStr:gmatch("([^,]+)") do
                nums[#nums+1] = tonumber(num)
            end
            precomputedPlantPositions[i][#precomputedPlantPositions[i]+1] = Vector3.new(nums[1], nums[2], nums[3])
        end
    end

    local function findSeedTool(seedName)
        local lowerName = seedName:lower()
        for _, t in ipairs(player.Backpack:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():match("^" .. lowerName .. "%s*seed") then
                return t
            end
        end
        for _, t in ipairs(player.Character:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():match("^" .. lowerName .. "%s*seed") then
                return t
            end
        end
        return nil
    end

    local function getMyFarmIndex()
        local farmParent = workspace:FindFirstChild("Farm")
        if not farmParent then return nil end
        for _, farmFolder in ipairs(farmParent:GetChildren()) do
            local important = farmFolder:FindFirstChild("Important")
            if important then
                local dataFolder = important:FindFirstChild("Data")
                if dataFolder and dataFolder:FindFirstChild("Owner") and dataFolder:FindFirstChild("Farm_Number") then
                    if dataFolder.Owner.Value == player.Name then
                        local val = dataFolder.Farm_Number.Value
                        local idx = (type(val) == "string") and tonumber(val) or val
                        if type(idx) == "number" then
                            return idx
                        end
                    end
                end
            end
        end
        return nil
    end

    local auto_plant_toggle = auto_plant:AddToggle("Auto_Plant", { Title = "Auto Plant", Default = saved_Auto_Plant })
    auto_plant_toggle:OnChanged(function(on)
        Settings.Plant.Plant.Auto_Plant = on
        writefile(file, HttpService:JSONEncode(Settings))

        if on then
            local idx = getMyFarmIndex()
            if type(idx) ~= "number" then
                task.wait(0.5)
                auto_plant_toggle:Set(false)
                return
            end

            task.spawn(function()
                while auto_plant_toggle.Value do
                    local seeds = {}
                    for name, enabled in pairs(Options.Select_Seed_Plant.Value) do
                        if enabled and type(name) == "string" then
                            seeds[#seeds+1] = name
                        end
                    end

                    if #seeds == 0 then
                        task.wait(0.1)
                        continue
                    end

                    for _, seedName in ipairs(seeds) do
                        local tool = findSeedTool(seedName)
                        if tool and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                            local currentTool = player.Character:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Tool")
                            if currentTool ~= tool then
                                player.Character:FindFirstChildOfClass("Humanoid"):EquipTool(tool)
                                task.wait(0.05)
                            end
                        end

                        local positions = precomputedPlantPositions[idx]
                        if positions then
                            for _, pos in ipairs(positions) do
                                plantRemote:FireServer(pos, seedName)
                                task.wait(0.01)
                            end
                        end
                    end

                    task.wait(0.05)
                end

                if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
                end
            end)
        else
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
            end
        end
    end)

    -- [ Harvert ]
	local harvestCount = 0
    local function getSelected(tbl)
        local t = {}
        for name, enabled in pairs(tbl) do
            if enabled then
                table.insert(t, name)
            end
        end
        return t
    end
    local auto_harvert = Tabs.Plant:AddSection("[ 🌾 ] - Harvert")
    local selectFruits = auto_harvert:AddDropdown("Select_Fruits_Harvert", {
        Title = "Select Fruits To Harvert",
        Description = "You can select multiple Fruits",
        Values = seedOptions,
        Multi = true,
        Default = saved_Harvest_Fruits,
    })
    selectFruits:OnChanged(function(val)
        Settings.Plant.Harvert.Select_Fruits = val
        writefile(file, HttpService:JSONEncode(Settings))
    end)

    local selectMuts = auto_harvert:AddDropdown("Select_Mutations_Harvert", {
        Title = "Select Mutations To Harvert",
        Description = "You can select multiple Mutations",
        Values = plant_data.mutations,
        Multi = true,
        Default = saved_Harvest_Mutations,
    })
    selectMuts:OnChanged(function(val)
        Settings.Plant.Harvert.Select_Mutations_Harvert = val
        writefile(file, HttpService:JSONEncode(Settings))
    end)

    local inventoryFull = false

    local function onNotifText(text)
        if string.find(text, "Max backpack space! Go sell!") then
            inventoryFull = true
        end
    end

    local function setupInventoryListener()
        local topNotifGui = player.PlayerGui:FindFirstChild("Top_Notification")
                           or player.PlayerGui:FindFirstChild("TopNotification")
        if not topNotifGui then return end

        local frame = topNotifGui:FindFirstChild("Frame") or topNotifGui

        for _, child in ipairs(frame:GetChildren()) do
            local label = child:FindFirstChild("TextLabel") or (child:IsA("TextLabel") and child)
            if label then
                label:GetPropertyChangedSignal("Text"):Connect(function()
                    onNotifText(label.Text)
                end)
                onNotifText(label.Text)
            end
        end

        frame.ChildAdded:Connect(function(child)
            local label = child:FindFirstChild("TextLabel") or (child:IsA("TextLabel") and child)
            if label then
                label:GetPropertyChangedSignal("Text"):Connect(function()
                    onNotifText(label.Text)
                end)
                onNotifText(label.Text)
            end
        end)
    end
	local function harvestLoop()
		local farmFolder = getPlayerFarmFolder()
		if not farmFolder then return end

		local importantFolder = farmFolder:FindFirstChild("Important")
		if not importantFolder then return end

		local PlantsPhysical = importantFolder:FindFirstChild("Plants_Physical")
		if not PlantsPhysical then return end

		local selectedFruits = getSelected(Options.Select_Fruits_Harvert.Value)
		local selectedMuts = getSelected(Options.Select_Mutations_Harvert.Value)
		local filterFruit = #selectedFruits > 0
		local filterMut = #selectedMuts > 0

		local function doHarvest(item)
			ByteNetReliable:FireServer(
				buffer.fromstring("\001\001\000\001"),
				{ item }
			)
			harvestCount = harvestCount + 1
			if harvestCount >= 100 then
				task.wait(2)
				harvestCount = 0
			end
		end

		for _, plant in ipairs(PlantsPhysical:GetChildren()) do
			task.wait(0.01)

			local growFolder = plant:FindFirstChild("Grow")
			local ageVal = growFolder and growFolder:FindFirstChild("Age")
			local maxAgeAttr = plant:GetAttribute("MaxAge")
			local maxAgeVal = maxAgeAttr or (plant:FindFirstChild("MaxAge") and plant.MaxAge.Value)
			if ageVal and maxAgeVal then
				if ageVal.Value < maxAgeVal then
					continue
				end
			elseif growFolder or plant:FindFirstChild("MaxAge") then
				continue
			else
				continue
			end

			if filterFruit and filterMut then
				local fruitsFolder = plant:FindFirstChild("Fruits")
				if fruitsFolder then
					for _, fruit in ipairs(fruitsFolder:GetChildren()) do
						doHarvest(fruit)
					end
				else
					doHarvest(plant)
				end
				continue
			end

			if (not filterFruit) and filterMut then
				local fruitsFolder = plant:FindFirstChild("Fruits")
				if fruitsFolder then
					for _, fruit in ipairs(fruitsFolder:GetChildren()) do
						for _, m in ipairs(selectedMuts) do
							local ok = fruit:GetAttribute(m) or (fruit:FindFirstChild(m) and fruit[m].Value)
							if ok then
								doHarvest(fruit)
								break
							end
						end
					end
				else
					for _, m in ipairs(selectedMuts) do
						local ok = plant:GetAttribute(m) or (plant:FindFirstChild(m) and plant[m].Value)
						if ok then
							doHarvest(plant)
							break
						end
					end
				end
				continue
			end

			if filterFruit and (not filterMut) then
				if table.find(selectedFruits, plant.Name) then
					local fruitsFolder = plant:FindFirstChild("Fruits")
					if fruitsFolder then
						for _, fruit in ipairs(fruitsFolder:GetChildren()) do
							doHarvest(fruit)
						end
					else
						doHarvest(plant)
					end
				end
				continue
			end

			do
				local fruitsFolder = plant:FindFirstChild("Fruits")
				if fruitsFolder then
					for _, fruit in ipairs(fruitsFolder:GetChildren()) do
						doHarvest(fruit)
					end
				else
					doHarvest(plant)
				end
			end
		end
	end

	local autoHarvertToggle = auto_harvert:AddToggle("Auto_Harvert", { Title = "Auto Harvert", Default = saved_Auto_Harvest })
	autoHarvertToggle:OnChanged(function(state)
		Settings.Plant.Harvert.Auto_Harvert = state
		writefile(file, HttpService:JSONEncode(Settings))

		inventoryFull = false
		setupInventoryListener()

		if state then
			task.spawn(function()
				while autoHarvertToggle.Value and not inventoryFull do
					harvestLoop()
					task.wait(0.01)
				end
			end)
		end
	end)

    -- [ Auto Sell ]
    local auto_sell = Tabs.Plant:AddSection("[ 💵 ] - Auto Sell")
    if type(saved_Sell_Modes) == "table" then
        saved_Sell_Modes = saved_Sell_Modes[1]
    end
    saved_Sell_Modes = saved_Sell_Modes or "Inventory Max"

    local sellMode = saved_Sell_Modes

    local selectSellMode = auto_sell:AddDropdown("Select_Sell_Mode", {
        Title   = "Select Sell Mode",
        Values  = {"Inventory Max", "Every 30 seconds"},
        Default = sellMode,
        Multi   = false,
    })
    selectSellMode:OnChanged(function(val)
        Settings.Plant.Auto_Sell.Select_Sell_Mode = val
        writefile(file, HttpService:JSONEncode(Settings))
        sellMode = val
    end)

    local sellPropertyConns = {}
    local sellChildAddedConn
    local sellChildRemovedConn
    local origCFrame
    local isWarping = false

    local autosellToggle = auto_sell:AddToggle("Auto_Sell", { Title = "Auto Sell", Default = saved_Auto_Sell })

    local function handleSellText(text)
        if string.find(text, "Max backpack space! Go sell!") and not isWarping then
            isWarping = true

            local char = player.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                origCFrame = hrp.CFrame
                local sellCFrame = CFrame.new(
                    86.5854721, 2.97185373, 0.426784277,
                    1.7411641e-16, 1.07745741e-07, -1,
                    -1.02299481e-10, 1, 1.07745741e-07,
                    1, 1.02299481e-10, 1.85138744e-16
                )
                task.wait(1)
                hrp.CFrame = sellCFrame
                task.wait(0.5)
                SellInventoryRemote:FireServer()
            end
        end
    end

    local function onChildAdded(child)
        local label = child:FindFirstChild("TextLabel") or (child:IsA("TextLabel") and child)
        if not label then return end

        local conn = label:GetPropertyChangedSignal("Text"):Connect(function()
            if not autosellToggle.Value then return end
            handleSellText(label.Text)
        end)
        sellPropertyConns[child] = conn

        handleSellText(label.Text)
    end

    local function onChildRemoved(child)
        if child.Name == "Notification_UI" or child:IsA("Frame") or child:IsA("TextLabel") then
            local conn = sellPropertyConns[child]
            if conn then
                conn:Disconnect()
                sellPropertyConns[child] = nil
            end
            if isWarping and origCFrame then
                local char = player.Character
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    task.wait(1)
                    hrp.CFrame = origCFrame
                end
                task.wait(1)
                origCFrame = nil
                isWarping = false
            end
        end
    end

    autosellToggle:OnChanged(function(state)
        Settings.Plant.Auto_Sell.Auto_Sell = state
        writefile(file, HttpService:JSONEncode(Settings))

        if not state then
            if sellChildAddedConn then
                sellChildAddedConn:Disconnect()
                sellChildAddedConn = nil
            end
            if sellChildRemovedConn then
                sellChildRemovedConn:Disconnect()
                sellChildRemovedConn = nil
            end
            for child, conn in pairs(sellPropertyConns) do
                conn:Disconnect()
            end
            sellPropertyConns = {}
            return
        end

        if sellMode == "Every 30 seconds" then
            spawn(function()
                while autosellToggle.Value do
                    local char = player.Character
                    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        origCFrame = hrp.CFrame
                        local sellCFrame = CFrame.new(
                            86.5854721, 2.97185373, 0.426784277,
                            1.7411641e-16, 1.07745741e-07, -1,
                            -1.02299481e-10, 1, 1.07745741e-07,
                            1, 1.02299481e-10, 1.85138744e-16
                        )
                        task.wait(1)
                        hrp.CFrame = sellCFrame
                        task.wait(0.5)
                        SellInventoryRemote:FireServer()
                        task.wait(1)
                        hrp.CFrame = origCFrame
                        origCFrame = nil
                    end
                    task.wait(30)
                end
            end)
        elseif sellMode == "Inventory Max" then
            local topNotifGui = player.PlayerGui:FindFirstChild("Top_Notification")
                             or player.PlayerGui:FindFirstChild("TopNotification")
            if not topNotifGui then return end

            local frame = topNotifGui:FindFirstChild("Frame") or topNotifGui

            if sellChildAddedConn then
                sellChildAddedConn:Disconnect()
                sellChildAddedConn = nil
            end
            if sellChildRemovedConn then
                sellChildRemovedConn:Disconnect()
                sellChildRemovedConn = nil
            end

            sellChildAddedConn = frame.ChildAdded:Connect(onChildAdded)
            sellChildRemovedConn = frame.ChildRemoved:Connect(onChildRemoved)

            for _, existingChild in ipairs(frame:GetChildren()) do
                if existingChild.Name == "Notification_UI"
                   or existingChild:IsA("TextLabel")
                   or existingChild:IsA("Frame")
                then
                    onChildAdded(existingChild)
                end
            end
        end
    end)



    -- [ Egg ]
    local eggOptions = {}
    for _, name in ipairs(egg_data.shop) do
        table.insert(eggOptions, name)
    end
    for _, eventList in pairs(egg_data.event) do
        for _, name in ipairs(eventList) do
            table.insert(eggOptions, name)
        end
    end
    local function getPlayerFarmIndex()
        local farmParent = workspace:FindFirstChild("Farm")
        if not farmParent then return nil end

        for _, farmFolder in ipairs(farmParent:GetChildren()) do
            local important = farmFolder:FindFirstChild("Important")
            if important and important:FindFirstChild("Data") and important.Data:FindFirstChild("Owner") and important.Data:FindFirstChild("Farm_Number") then
                if important.Data.Owner.Value == player.Name then
                    local val = important.Data.Farm_Number.Value
                    local idx = (type(val) == "string") and tonumber(val) or val
                    if type(idx) == "number" then
                        return idx
                    end
                end
            end
        end
        return nil
    end
    local egg_choices = {}
    for _, name in ipairs(egg_data.shop) do
        table.insert(egg_choices, name .. " Egg")
    end
    for _, eventList in pairs(egg_data.event) do
        for _, name in ipairs(eventList) do
            table.insert(egg_choices, name .. " Egg")
        end
    end
    local auto_egg = Tabs.Egg:AddSection("[ 🥚 ] - Place And Hatch")
    local select_egg_to_place = auto_egg:AddDropdown("Select_Egg_To_Place", {
        Title = "Select Eggs To Place",
        Description = "You can select multiple Eggs",
        Values = egg_choices,
        Multi = true,
        Default = saved_Eggs_To_Place,
    })
    select_egg_to_place:OnChanged(function(value)
        Settings.Egg.Auto_Place_And_Hatch.Select_Eggs_To_Place = value
        writefile(file, HttpService:JSONEncode(Settings))
    end)
    local isPlacing = false
    local isHatching = false
    local hatchedCount = 0
    local initialPlaced = false
    local function findEggTool(eggName)
        local lc = eggName:lower()
        for _, t in ipairs(player.Backpack:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():match("^" .. lc) then
                return t
            end
        end
        for _, t in ipairs(player.Character:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():match("^" .. lc) then
                return t
            end
        end
    end
    local auto_place_egg_toggle = auto_egg:AddToggle("Auto_Place_Egg", { Title = "Auto Place Egg", Default = saved_Auto_Place_Egg })
    auto_place_egg_toggle:OnChanged(function(on)
        Settings.Egg.Auto_Place_And_Hatch.Auto_Place_Egg = on
        writefile(file, HttpService:JSONEncode(Settings))

        isPlacing = on
        initialPlaced = false

        if on then
            task.spawn(function()
                while isPlacing do
                    local selectedEggs = {}
                    for entry, enabled in pairs(Options.Select_Egg_To_Place.Value) do
                        if enabled and type(entry) == "string" then
                            local baseName = entry:match("(.+)%s*x%d+$") or entry
                            table.insert(selectedEggs, baseName)
                        end
                    end

                    if #selectedEggs > 0 then
                        local placeCount
                        if hatchedCount > 0 then
                            task.wait(5)
                            placeCount = hatchedCount
                        elseif not initialPlaced then
                            placeCount = 8
                            initialPlaced = true
                        end

                        if placeCount then
                            local farmIndexNow = getPlayerFarmIndex()
                            if not farmIndexNow then
                                break
                            end

                            local eggPositions = plant_data.locations["Place Egg"][farmIndexNow]
                            if not eggPositions then
                                break
                            end

                            for _, eggName in ipairs(selectedEggs) do
                                local tool = findEggTool(eggName)
                                if tool then
                                    player.Character.Humanoid:EquipTool(tool)
                                    task.wait(0.1)
                                end

                                for i = 1, placeCount do
                                    local idx = ((i - 1) % #eggPositions) + 1
                                    local locStr = eggPositions[idx]

                                    local coords = {}
                                    for coord in locStr:gmatch("([^,]+)") do
                                        table.insert(coords, tonumber(coord))
                                    end
                                    local pos = Vector3.new(coords[1], coords[2], coords[3])

                                    PetEggService:FireServer("CreateEgg", pos)
                                    task.wait(0.1)
                                end
                            end

                            hatchedCount = 0
                        end
                    end

                    task.wait(1)
                end
            end)
        end
    end)
    local function getObjectsPhysical()
        local farmParent = workspace:FindFirstChild("Farm")
        if not farmParent then return nil end

        for _, farmFolder in ipairs(farmParent:GetChildren()) do
            local important = farmFolder:FindFirstChild("Important")
            if important and important:FindFirstChild("Data") then
                local ownerVal = important.Data:FindFirstChild("Owner")
                if ownerVal and ownerVal.Value == player.Name then
                    return important:FindFirstChild("Objects_Physical")
                end
            end
        end

        return nil
    end
    local auto_hatch_egg_toggle = auto_egg:AddToggle("Auto_Hatch_Egg", { Title = "Auto Hatch Egg", Default = saved_Auto_Hatch_Egg })
    auto_hatch_egg_toggle:OnChanged(function(on)
        Settings.Egg.Auto_Place_And_Hatch.Auto_Hatch_Egg = on
        writefile(file, HttpService:JSONEncode(Settings))

        isHatching = on
        if on then
            task.spawn(function()
                while isHatching do
                    local objectsPhysical = getObjectsPhysical()
                    if objectsPhysical then
                        for _, obj in ipairs(objectsPhysical:GetChildren()) do
                            if obj:GetAttribute("TimeToHatch") == 0 then
                                PetEggService:FireServer("HatchPet", obj)
                                hatchedCount = hatchedCount + 1
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end)

    -- [ Pet ]
    local auto_sell_pet = Tabs.Pet:AddSection("[ 🐶 ] - Auto Sell Pet")
    local select_pet_to_sell = auto_sell_pet:AddDropdown("Select_Pet_To_Sell", {
        Title = "Select Pets To Sell",
        Description = "You can select multiple Pets",
        Values = pet_data,
        Multi = true,
        Default = saved_Pet_To_Sell,
    })
    select_pet_to_sell:OnChanged(function(value)
        Settings.Pet.Auto_Sell_Pet.Select_Pet_To_Sell = value
        writefile(file, HttpService:JSONEncode(Settings))
    end)
    local auto_sell_pet_toggle = auto_sell_pet:AddToggle("Auto_Sell_Pet", { Title = "Auto Sell Pet", Default = saved_Auto_Sell_Pet })
    auto_sell_pet_toggle:OnChanged(function(on)
        Settings.Pet.Auto_Sell_Pet.Auto_Sell_Pet = on
        writefile(file, HttpService:JSONEncode(Settings))

        if on then
            task.spawn(function()
                local sellPetEvent = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("SellPet_RE")
                while auto_sell_pet_toggle.Value do
                    for petName, enabled in pairs(Options.Select_Pet_To_Sell.Value) do
                        if enabled and type(petName) == "string" then
                            local targetTool = nil
                            for _, tool in ipairs(player.Backpack:GetChildren()) do
                                if tool:IsA("Tool") then
                                    local baseName = tool.Name:match("^(.-)%s*%[")
                                    if baseName == petName and tool:GetAttribute("d") ~= true then
                                        targetTool = tool
                                        break
                                    end
                                end
                            end
                            if targetTool and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                                if targetTool:GetAttribute("d") ~= true then
                                    player.Character:FindFirstChildOfClass("Humanoid"):EquipTool(targetTool)
                                    sellPetEvent:FireServer(targetTool)
                                    task.wait(0.5)
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end)

    -- [ Auto Feed Pet ]
    local function cleanName(raw)
        local s = raw:lower()
        s = s:gsub("%b[]", "")
        s = s:gsub("%b()", "")
        return s:match("^%s*(.-)%s*$")
    end

    local function findFruitTool(fruitName)
        local lc = fruitName:lower()
        for _, container in ipairs({player.Backpack, player.Character}) do
            if container then
                for _, t in ipairs(container:GetChildren()) do
                    if t:IsA("Tool") then
                        local nameRaw = t.Name
                        local nameLower = nameRaw:lower()
                        local isSeed = nameLower:find("seed") ~= nil
                        local isFav = t:GetAttribute("d") == true
                        local stripped = cleanName(nameRaw)
                        local willHold = (not isSeed) and (not isFav) and stripped:match("^"..lc) ~= nil

                        if willHold then
                            return t
                        end
                    end
                end
            end
        end
        return nil
    end

    local auto_feed_pet = Tabs.Pet:AddSection("[ 🍒 ] - Auto Feed Pet")
    local select_pet_to_feed = auto_feed_pet:AddDropdown("Select_Pets_To_Feed", {
        Title = "Select Pets To Feed",
        Description = "You can select multiple Pets",
        Values = {},
        Multi = true,
        Default = saved_Pet_To_Feed,
    })
    select_pet_to_feed:OnChanged(function(value)
        Settings.Pet.Auto_Feed_Pet.Select_Pet_To_Feed = value
        writefile(file, HttpService:JSONEncode(Settings))
    end)
    local select_fruits_to_feed = auto_feed_pet:AddDropdown("Select_Fruits_To_Feed", {
        Title = "Select Fruits To Feed",
        Description = "You can select multiple Fruits",
        Values = seedOptions,
        Multi = true,
        Default = saved_Fruit_To_Feed,
    })
    select_fruits_to_feed:OnChanged(function(value)
        Settings.Pet.Auto_Feed_Pet.Select_Fruit_To_Feed = value
        writefile(file, HttpService:JSONEncode(Settings))
    end)
    local function updateOwnedPets()
        petOptions = {}
        petMap = {}

        local gui = player.PlayerGui:FindFirstChild("ActivePetUI")
        local scrolling = gui and gui.Frame.Main:FindFirstChild("ScrollingFrame")

        for _, petContainer in ipairs(workspace:WaitForChild("PetsPhysical"):GetChildren()) do
            if petContainer:GetAttribute("OWNER") == player.Name then
                local innerModel = petContainer:FindFirstChildWhichIsA("Model")
                local defaultName = innerModel and innerModel.Name or petContainer.Name

                local petUUID = petContainer:GetAttribute("UUID")

                local nameText = defaultName
                local typeText = defaultName

                if scrolling and petUUID then
                    local petFrame = scrolling:FindFirstChild(petUUID)
                    if petFrame then
                        if petFrame:FindFirstChild("PET_NAME") then
                            nameText = petFrame.PET_NAME.Text
                        end
                        if petFrame:FindFirstChild("PET_TYPE") then
                            typeText = petFrame.PET_TYPE.Text
                        end
                    end
                end

                local entryName = nameText .. " - [ " .. typeText .. " ]"
                table.insert(petOptions, entryName)
                petMap[entryName] = petUUID
            end
        end

        select_pet_to_feed:SetValues(petOptions)

        for i = #saved_Pet_To_Feed, 1, -1 do
            if not table.find(petOptions, saved_Pet_To_Feed[i]) then
                table.remove(saved_Pet_To_Feed, i)
            end
        end
    end

    updateOwnedPets()
    workspace:WaitForChild("PetsPhysical").ChildAdded:Connect(function(child)
        if child:GetAttribute("OWNER") == player.Name then
            updateOwnedPets()
        end
    end)
    workspace:WaitForChild("PetsPhysical").ChildRemoved:Connect(function(child)
        if child:GetAttribute("OWNER") == player.Name then
            updateOwnedPets()
        end
    end)

    local function getSelectedPets()
        local pets = {}
        for name, enabled in pairs(Options.Select_Pets_To_Feed.Value) do
            if enabled then table.insert(pets, name) end
        end
        return pets
    end
    local function getSelectedFruits()
        local fruits = {}
        for name, enabled in pairs(Options.Select_Fruits_To_Feed.Value) do
            if enabled then table.insert(fruits, name) end
        end
        return fruits
    end
    local auto_feed_pet_toggle = auto_feed_pet:AddToggle("Auto_Feed_Pet", { Title = "Auto Feed Pet", Default = saved_Auto_Feed_Pet })
    auto_feed_pet_toggle:OnChanged(function(on)
        Settings.Pet.Auto_Feed_Pet.Auto_Feed_Pet = on
        writefile(file, HttpService:JSONEncode(Settings))

        if on then
            task.spawn(function()
                while auto_feed_pet_toggle.Value do
                    local petsToFeed   = getSelectedPets()
                    local fruitsToFeed = getSelectedFruits()

                    if #petsToFeed == 0 or #fruitsToFeed == 0 then
                        task.wait(1)
                        continue
                    end

                    for _, entryName in ipairs(petsToFeed) do
                        local petUUID = petMap[entryName]
                        if not petUUID then
                            continue
                        end

                        local gui = player.PlayerGui:FindFirstChild("ActivePetUI")
                        local scroll = gui and gui.Frame.Main:FindFirstChild("ScrollingFrame")
                        local petFrame = scroll and scroll:FindFirstChild(petUUID)
                        local hungerBar = petFrame and petFrame:FindFirstChild("PetStats") and petFrame.PetStats:FindFirstChild("HUNGER") and petFrame.PetStats.HUNGER:FindFirstChild("HUNGER_BAR")
                        if not hungerBar then
                            continue
                        end

                        print("Hunger:", hungerBar.Size.X.Scale)
                        while hungerBar.Size.X.Scale < 0.9 do
                            local tool = findFruitTool(fruitsToFeed[1])
                            if tool then
                                player.Character:FindFirstChildOfClass("Humanoid"):EquipTool(tool)
                                task.wait(0.1)
                                feedPetRemote:FireServer("Feed", petUUID)
                                task.wait(0.5)
                            else
                                break
                            end
                            local newFrame = scroll and scroll:FindFirstChild(petUUID)
                            hungerBar = newFrame and newFrame:FindFirstChild("PetStats") and newFrame.PetStats:FindFirstChild("HUNGER") and newFrame.PetStats.HUNGER:FindFirstChild("HUNGER_BAR")
                            if not hungerBar then break end
                        end
                    end

                    task.wait(1)
                end
                if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
                end
            end)
        else
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
            end
        end
    end)



    -- [ Event ]
    local bee_event = Tabs.Event:AddSection("[ 🐝 ] - Swarm Event")
    bee_event:AddParagraph({
        Title = "Working after Swarm Event ended"
    })
    local auto_UnFavorite = bee_event:AddToggle("Auto_UnFavorite", { Title = "Auto UnFavorite Pollinated", Default = saved_Auto_UnFavorite })
    auto_UnFavorite:OnChanged(function(state)
        Settings.Event.Swarm.Auto_UnFavorite = state
        writefile(file, HttpService:JSONEncode(Settings))
    end)
    local auto_Collect_Honey = bee_event:AddToggle("Auto_Collect_Honey", { Title = "Auto Farm Honey", Default = saved_Auto_Collect_Honey })
    local autoCollectEnabled = auto_Collect_Honey.Value
    auto_Collect_Honey:OnChanged(function(state)
        Settings.Event.Swarm.Auto_Collect_Honey = state
        writefile(file, HttpService:JSONEncode(Settings))

        autoCollectEnabled = state

        if state then
            task.spawn(function()
                local label = workspace
                    :WaitForChild("HoneyEvent")
                    :WaitForChild("HoneyCombpressor")
                    :WaitForChild("Sign")
                    :WaitForChild("SurfaceGui")
                    :WaitForChild("TextLabel")

                local function findPollinatedTool()
                    for _, container in ipairs({ player.Backpack, player.Character }) do
                        if container then
                            for _, tool in ipairs(container:GetChildren()) do
                                if tool:IsA("Tool") and tool:GetAttribute("Pollinated") == true then
                                    return tool
                                end
                            end
                        end
                    end
                    return nil
                end

                while autoCollectEnabled do
                    local text = label.Text
                    if text:match("%d+:%d+") then
                        wait(1)
                    else
                        local tool = findPollinatedTool()
                        if tool and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            humanoid:EquipTool(tool)

                            if auto_UnFavorite.Value then
                                favoriteRemote:FireServer(tool)
                            end

                            text = label.Text
                            if text == "READY" then
                                beeEventRemote:FireServer("MachineInteract")
                                wait(1)
                                text = label.Text
                                if text:match("%d+:%d+") then
                                    repeat
                                        wait(1)
                                        text = label.Text
                                    until (not text:match("%d+:%d+")) or (not autoCollectEnabled)
                                end
                            else
                                if not text:match("%d+:%d+") then
                                    beeEventRemote:FireServer("MachineInteract")
                                    wait(0.5)
                                    text = label.Text

                                    if text:match("%d+:%d+") then
                                        repeat
                                            wait(1)
                                            text = label.Text
                                        until (not text:match("%d+:%d+")) or (not autoCollectEnabled)
                                    end
                                    if not autoCollectEnabled then break end
                                    wait(1)
                                else
                                    repeat
                                        wait(1)
                                        text = label.Text
                                    until (not text:match("%d+:%d+")) or (not autoCollectEnabled)
                                    if not autoCollectEnabled then break end
                                    wait(1)
                                end
                            end
                        else
                            wait(2)
                        end
                    end
                end
            end)
        else
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character:FindFirstChildOfClass("Humanoid"):UnequipTools()
            end
        end
    end)



    -- [ SHOP ]
    local seed_shop = Tabs.Shop:AddSection("[ 🌱 ] - Seed Shop")
    local select_seeds = seed_shop:AddDropdown("Select_Seeds", {
        Title = "Buy Seeds",
        Description = "You can select multiple seeds",
        Values = plant_data.shop,
        Multi = true,
        Default = saved_Seed_Shop_Seeds,
    })
    select_seeds:OnChanged(function(Value)
        Settings.Shop.Seed_Shop.Select_Seeds = Value
        writefile(file, HttpService:JSONEncode(Settings))
    end)
    local auto_buy_seed_button = seed_shop:AddToggle("Auto_buy_seed", { Title = "Auto Buy Seeds", Default = saved_Auto_Buy_Seeds })
    auto_buy_seed_button:OnChanged(function(val)
        Settings.Shop.Seed_Shop.Auto_Buy_Seeds = val
        writefile(file, HttpService:JSONEncode(Settings))
        if val then
            spawn(function()
                while Options.Auto_buy_seed.Value do
                    local seeds = getSelected(Options.Select_Seeds.Value)
                    if #seeds == 0 then
                        seeds = plant_data.shop
                    end

                    for _, seed in ipairs(seeds) do
                        buySeedRemote:FireServer(seed)
                    end

                    task.wait(0.1)
                end
            end)
        end
    end)
    local honey_shop = Tabs.Shop:AddSection("[ 🍯 ] - Honey Shop")
    local select_honey_items  = honey_shop:AddDropdown("Select_Honey_Items", {
        Title = "Buy Honey Shop",
        Description = "You can select multiple Items",
        Values = plant_data.swarm,
        Multi = true,
        Default = saved_Honey_Shop_Items,
    })
    select_honey_items:OnChanged(function(value)
        Settings.Shop.Honey_Shop.Select_Item = value
        writefile(file, HttpService:JSONEncode(Settings))
    end)
    local auto_buy_honey_toggle = honey_shop:AddToggle("Auto_Buy_Honey", { Title = "Auto Buy Honey Items", Default = saved_Auto_Buy_Honey })
    auto_buy_honey_toggle:OnChanged(function(on)
        Settings.Shop.Honey_Shop.Auto_Buy_Items = on
        writefile(file, HttpService:JSONEncode(Settings))

        if on then
            task.spawn(function()
                while auto_buy_honey_toggle.Value do
                    local selected = getSelected(Options.Select_Honey_Items.Value)
                    if #selected == 0 then
                        selected = plant_data.swarm
                    end

                    for _, item in ipairs(selected) do
                        buyBeeRemote:FireServer(item)
                    end

                    task.wait(0.1)
                end
            end)
        end
    end)
    local gear_shop = Tabs.Shop:AddSection("[ ⚙️ ] - Gear Shop")
    local select_gears = gear_shop:AddDropdown("Select_Gears", {
        Title = "Buy Gears",
        Description = "You can select multiple gears",
        Values = gear_data,
        Multi = true,
        Default = saved_Gear_Shop,
    })
    select_gears:OnChanged(function(Value)
        Settings.Shop.Gear_Shop.Select_Gears = Value
        writefile(file, HttpService:JSONEncode(Settings))
    end)
    local auto_buy_gear_button = gear_shop:AddToggle("Auto_buy_gear", { Title = "Auto Buy Gears", Default = saved_Auto_Buy_Gears })
    auto_buy_gear_button:OnChanged(function(val)
        Settings.Shop.Gear_Shop.Auto_Buy_Gears = val
        writefile(file, HttpService:JSONEncode(Settings))
        if val then
            spawn(function()
                while Options.Auto_buy_gear.Value do
                    local gears = getSelected(Options.Select_Gears.Value)
                    if #gears == 0 then
                        gears = gear_data
                    end
                    for _, gear in ipairs(gears) do
                        buyGearRemote:FireServer(gear)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end)
    local function getEggStocks()
        local data = DataSer:GetData()
        return (data.PetEggStock and data.PetEggStock.Stocks) or {}
    end

    local function autoBuyEggs(filterTypes)
        local stocks = getEggStocks()
        for idx, info in ipairs(stocks) do
            if info.Stock > 0 and table.find(filterTypes, info.EggName) then
                buyPetEggRemote:FireServer(idx)
            end
        end
    end
    local egg_choices_shop = {}
    for _, name in ipairs(egg_data.shop) do
        table.insert(egg_choices_shop, name .. " Egg")
    end
    local egg_shop = Tabs.Shop:AddSection("[ 🥚 ] - Egg Shop")
    local select_egg = egg_shop:AddDropdown("Select_Eggs", {
        Title = "Buy Eggs",
        Description = "You can select multiple eggs",
        Values = egg_choices_shop,
        Multi = true,
        Default = saved_Egg_Shop,
    })
    select_egg:OnChanged(function(Value)
        Settings.Shop.Egg_Shop.Select_Eggs = Value
        writefile(file, HttpService:JSONEncode(Settings))
    end)
    local auto_buy_egg_button = egg_shop:AddToggle("Auto_Buy_Eggs", { Title = "Auto Buy Eggs", Default = saved_Auto_Buy_Eggs })
    auto_buy_egg_button:OnChanged(function(on)
        Settings.Shop.Egg_Shop.Auto_Buy_Eggs = on
        writefile(file, HttpService:JSONEncode(Settings))

        if on then
            task.spawn(function()
                while auto_buy_egg_button.Value do
                    local selected = {}
                    for name, enabled in pairs(Options.Select_Eggs.Value) do
                        if enabled then
                            table.insert(selected, name)
                        end
                    end

                    autoBuyEggs(selected)
                    task.wait(1)
                end
            end)
        end
    end)


    -- [ Fovorite ]
    local function favoriteLoop()
        local selectedFruits = getSelected(Options.Select_Favorite_Fruits.Value)
        local selectedMuts   = getSelected(Options.Select_Favorite_Mutations.Value)
        local selectedPets   = getSelected(Options.Select_Favorite_Pets.Value)

        local filterFruit = #selectedFruits > 0
        local filterMut   = #selectedMuts > 0
        local filterPet   = #selectedPets > 0

        for _, container in ipairs({ player.Backpack, player.Character }) do
            if not container then
                continue
            end

            for _, tool in ipairs(container:GetChildren()) do
                if not tool:IsA("Tool") then
                    continue
                end

                if tool:GetAttribute("d") == true then
                    continue
                end

                local name = tool.Name

                if filterPet and (not filterFruit) and (not filterMut) then
                    local basePetName = name:match("^(.-)%s*%[")
                    if basePetName and table.find(selectedPets, basePetName) then
                        favoriteRemote:FireServer(tool)
                    end
                    continue
                end

                local fruitNamePart
                if name:match("^%[") then
                    fruitNamePart = name:match("^%[.+%]%s*(.-)%s*%[")
                else
                    fruitNamePart = name:match("^(.-)%s*%[")
                end

                local mutationList = name:match("^%[([^%]]+)%]")

                if filterFruit and not filterMut then
                    if fruitNamePart and table.find(selectedFruits, fruitNamePart) then
                        favoriteRemote:FireServer(tool)
                    end
                    continue
                end

                if filterMut and not filterFruit then
                    if mutationList then
                        for _, m in ipairs(selectedMuts) do
                            if mutationList:find(m) then
                                favoriteRemote:FireServer(tool)
                                break
                            end
                        end
                    end
                    continue
                end

                if filterFruit and filterMut then
                    if fruitNamePart and table.find(selectedFruits, fruitNamePart) then
                        if mutationList then
                            for _, m in ipairs(selectedMuts) do
                                if mutationList:find(m) then
                                    favoriteRemote:FireServer(tool)
                                    break
                                end
                            end
                        end
                    end
                    continue
                end

                if (not filterFruit) and (not filterMut) and (not filterPet) then
                    if mutationList then
                        favoriteRemote:FireServer(tool)
                    end
                end

            end
        end
    end
    local auto_favorite = Tabs.Misc:AddSection("[ 💖 ] - Favorite")
    local selectFavos_Fruits = auto_favorite:AddDropdown("Select_Favorite_Fruits", {
        Title = "Select Favorite Fruits",
        Description = "You can select multiple Fruits",
        Values = seedOptions,
        Multi = true,
        Default = saved_Favorite_Fruits,
    })
    selectFavos_Fruits:OnChanged(function(val)
        Settings.Misc.Favorite.Select_Favorite_Fruits = val
        writefile(file, HttpService:JSONEncode(Settings))
    end)
    local selectFavos_Mutations = auto_favorite:AddDropdown("Select_Favorite_Mutations", {
        Title = "Select Favorite Mutations",
        Description = "You can select multiple Mutations",
        Values = plant_data.mutations,
        Multi = true,
        Default = saved_Favorite_Mutations,
    })
    selectFavos_Mutations:OnChanged(function(val)
        Settings.Misc.Favorite.Select_Favorite_Mutations = val
        writefile(file, HttpService:JSONEncode(Settings))
    end)
    local selectFavos_Pets = auto_favorite:AddDropdown("Select_Favorite_Pets", {
        Title = "Select Favorite Pets",
        Description = "You can select multiple Pets",
        Values = pet_data,
        Multi = true,
        Default = saved_Favorite_Pets,
    })
    selectFavos_Pets:OnChanged(function(val)
        Settings.Misc.Favorite.Select_Favorite_Pets = val
        writefile(file, HttpService:JSONEncode(Settings))
    end)
    local autoFavoriteToggle = auto_favorite:AddToggle("Auto_Favorite", { Title = "Auto Favorite", Default = saved_Auto_Favorite })
    autoFavoriteToggle:OnChanged(function(state)
        Settings.Misc.Favorite.Auto_Favorite = state
        writefile(file, HttpService:JSONEncode(Settings))

        if state then
            task.spawn(function()
                while autoFavoriteToggle.Value do
                    favoriteLoop()
                    task.wait(1)
                end
            end)
        end
    end)
end

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("FluentScriptHub")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = hub,
    Content = "The script has been loaded.",
    SubContent = scriptName,
    Duration = 8
})

wait(0.5)

Notification:CreateNotification("Anti AFK : Activate")

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local function onPlayerAdded(player)
    if player.Name == owner then
        Notification:CreateNotification("The owner of " .. hub .. " just joined your server")
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)

local existing = Players:FindFirstChild(owner)
if existing then
    Notification:CreateNotification("The owner of " .. hub .. " is already in the server")
end
