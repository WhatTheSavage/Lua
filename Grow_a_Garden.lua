local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local updateLogs = {
    {
        Title   = "1 / 6 / 25",
        Content = "#Added\n - Auto Sell Pet\n - Swarm Event\n#Remove\n - Night Event\n#Fixed\n - Harvert very lag"
    },
    {
        Title   = "31 / 5 / 25",
        Content = "#Fixed\n - Can't Place Egg\n - Can't Plant Seed\n - Can't Harvert"
    },
}

local owner = "PrimeX_GG"
local hub = "PrimeXploit"
local scriptName = "Grow a Garden"
local update = "1 / 6 / 25"
local discord_link = "https://discord.gg/dbnuRpY2"

local folder = hub
local file = folder .. "/Grow_a_Garden.json"

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
    Pet_And_Egg = {
        Egg = {
            Select_Eggs_To_Place = {},
            Auto_Place_Egg = false,
            Auto_Hatch_Egg = false
        },
        Pet = {
            Select_Pet_To_Sell = {},
            Auto_Sell_Pet = false
        }
    },
    Event = {
        Swarm = {
            Auto_Collect_Honey = false
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

-- Egg > Egg
local saved_Eggs_To_Place = Settings.Pet_And_Egg.Egg.Select_Eggs_To_Place
local saved_Auto_Place_Egg = Settings.Pet_And_Egg.Egg.Auto_Place_Egg
local saved_Auto_Hatch_Egg = Settings.Pet_And_Egg.Egg.Auto_Hatch_Egg

-- Egg > Pet
local saved_Pet_To_Sell = Settings.Pet_And_Egg.Pet.Select_Pet_To_Sell
local saved_Auto_Sell_Pet = Settings.Pet_And_Egg.Pet.Auto_Sell_Pet

-- Event > Swarm
local saved_Auto_Collect_Honey = Settings.Event.Swarm.Auto_Collect_Honey

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
    mutations = {
        "Shocked",
        "Twisted",
        "Wet",
        "Chilled",
        "Frozen",
        "Disco",
        "Choc",
        "Plasma",
        "Burnt",
        "Moonlit",
        "Bloodlit",
        "Zombified",
        "Celestial",
        "Pollinated",
        "Voidtouched"
    },
    shop = {
        "Carrot",
        "Strawberry",
        "Blueberry",
        "Orange Tulip",
        "Tomato",
        "Corn",
        "Daffodil",
        "Watermelon",
        "Pumpkin",
        "Apple",
        "Bamboo",
        "Coconut",
        "Cactus",
        "Dragon Fruit",
        "Mango",
        "Grape",
        "Mushroom",
        "Pepper",
        "Cacao",
        "Beanstalk"
    },
    event = {
        Easter_2025 = {
            "Chocolate Carrot",
            "Red Lollipop",
            "Candy Sunflower",
            "Easter Egg",
            "Candy Blossom"
        },
        Angry_Plant = {
            "Cranberry",
            "Durian",
            "Eggplant",
            "Venus Fly Trap",
            "Lotus"
        },
        Lunar_Glow_Event = {
            "Nightshade",
            "Glowshroom",
            "Mint",
            "Moonflower",
            "Starfruit",
            "Moonglow",
            "Moon Blossom"
        },
        Blood_Moon_Shop = {
            "Blood Banana",
            "Moon Melon"
        },
        Twilight_Shop = {
            "Celestiberry",
            "Moon Mango"
        },
        Bizzy_Bee_Event = {
            "Rose",
            "Foxglove",
            "Lilac",
            "Pink Lily",
            "Purple Dahila",
            "Nectarine",
            "Hive Fruit",
            "Sunflower"
        }
    },
    seed_pack = {
        Normal = {
            "Pear",
            "Raspberry",
            "Pineapple",
            "Peach"
        },
        Exotic = {
            "Papaya",
            "Banana",
            "Passionfruit",
            "Soul Fruit",
            "Cursed Fruit"
        }
    },
    swarm = {
        "Flower Seed Pack",
        "Nectarine",
        "Hive Fruit",
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

local egg_data = {
    other = {
        locations = {
            [1] = "-289.04126, 2.87552762, 3.73038578, 1, 0, 0, 0, 1, 0, 0, 0, 1",
            [2] = "-289.039246, 2.79752779, 11.7703476, 1, 0, 0, 0, 1, 0, 0, 0, 1",
            [3] = "-289.031219, 2.79752779, 7.74039459, 1, 0, 0, 0, 1, 0, 0, 0, 1"
        },

        skin_color = {
            ["Common"] = "248, 248, 248",
            ["Uncommon"] = "211, 167, 129",
            ["Rare"] = "33, 84, 185",
            ["Legendary"] = "163, 50, 50",
            ["Mythical"] = "255, 170, 0",
            ["Bug"] = "53, 190, 29"
        }
    },
    shop = {
        "Common",
        "Uncommon",
        "Rare",
        "Legendary",
        "Mythical",
        "Bug"
    },
    pet = {
        "Dog",
        "Golden Lab",
        "Bunny",

        "Black Bunny",
        "Cat",
        "Deer",
        "Chicken",

        "Pig",
        "Rooster",
        "Spotted Deer",
        "Monkey",
        "Orange Tabby",

        "Polar Bear",
        "Turtle",
        "Sea Otter",
        "Cow",
        "Sliver Monkey",

        "Red Fox",
        "Red Giant Ant",
        "Brown Mouse",
        "Squirrel",
        "Grey Mouse",

        "Snail",
        "Giant Ant",
        "Caterpillar",
        "Praying Mantis",
        "Dragonfly",
    }
}

local Players = game:GetService("Players")
local player  = Players.LocalPlayer

local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buySeedRemote = ReplicatedStorage.GameEvents:WaitForChild("BuySeedStock")
local buyGearRemote = ReplicatedStorage.GameEvents:WaitForChild("BuyGearStock")
local buyPetEggRemote = ReplicatedStorage.GameEvents:WaitForChild("BuyPetEgg")
local buyBeeRemote = ReplicatedStorage.GameEvents:WaitForChild("BuyEventShopStock")

local plantRemote = ReplicatedStorage.GameEvents:WaitForChild("Plant_RE")
local ByteNetReliable = ReplicatedStorage:WaitForChild("ByteNetReliable")
local beeEventRemote = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("HoneyMachineService_RE")

local PetEggService = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetEggService")
local objectsPhysical = workspace:WaitForChild("Farm"):WaitForChild("Farm"):WaitForChild("Important"):WaitForChild("Objects_Physical")

local SellInventoryRemote = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory")

local farmFolder = workspace:WaitForChild("Farm")
local innerFarm = farmFolder:WaitForChild("Farm")
local important = innerFarm:WaitForChild("Important")
local dataFolder = important:WaitForChild("Data")
local ownerValue = dataFolder:WaitForChild("Owner")
local farmNumberVal = dataFolder:WaitForChild("Farm_Number")

local farmIndex = nil
if ownerValue.Value == player.Name then
    if typeof(farmNumberVal.Value) == "string" then
        farmIndex = tonumber(farmNumberVal.Value)
    else
        farmIndex = farmNumberVal.Value
    end
    if typeof(farmIndex) ~= "number" then
        warn(farmNumberVal.Value)
        farmIndex = nil
    end
else
    warn(player.Name)
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
    Log =  Window:AddTab({ Title = "Log", Icon = "key" }),
    Plant = Window:AddTab({ Title = "Plant", Icon = "sprout" }),
    Pet_And_Egg = Window:AddTab({ Title = "Pet And Egg", Icon = "egg" }),
    Event =  Window:AddTab({ Title = "Event", Icon = "electricity" }),
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    -- [ Log ]
    local welcome = Tabs.Log:AddSection("[ 👾 ] - Welcome")
    welcome:AddParagraph({
        Title = "Welcome to " .. hub .. " : " .. player.Name,
        Content = "This is a script for " .. scriptName .. "\n\nIf you'd like me to create any additional game scripts or the script very lag, please let me know on Discord Server\n\n[ Carefully crafted, ensuring simplicity ]"
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
    for _, logEntry in ipairs(updateLogs) do
        update_log:AddParagraph({
            Title   = logEntry.Title,
            Content = logEntry.Content
        })
    end


    -- [ Plant ]
    local harvestOptions = {}
    local seen = {}

    for _, name in ipairs(plant_data.shop) do
        if not seen[name] then
            table.insert(harvestOptions, name)
            seen[name] = true
        end
    end
    for _, packList in pairs(plant_data.seed_pack) do
        for _, name in ipairs(packList) do
            if not seen[name] then
                table.insert(harvestOptions, name)
                seen[name] = true
            end
        end
    end
    for _, eventList in pairs(plant_data.event) do
        for _, name in ipairs(eventList) do
            if not seen[name] then
                table.insert(harvestOptions, name)
                seen[name] = true
            end
        end
    end

    local function getSelectedSeeds()
        local seeds = {}
        for k, v in pairs(Options.Select_Seed_Plant.Value) do
            if v == true and type(k) == "string" and k ~= "" then
                table.insert(seeds, k)
            end
        end
        return seeds
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
    end
    local auto_plant = Tabs.Plant:AddSection("[ 🌱 ] - Plant")
    local select_seed = auto_plant:AddDropdown("Select_Seed_Plant", {
        Title = "Select Seeds",
        Description = "You can select multiple Seeds",
        Values = harvestOptions,
        Multi = true,
        Default = saved_Select_Seeds,
    })
    select_seed:OnChanged(function(newSelection)
        Settings.Plant.Plant.Select_Seeds = newSelection
        writefile(file, HttpService:JSONEncode(Settings))
    end)

    local auto_plant_toggle = auto_plant:AddToggle("Auto_Plant", { Title = "Auto Plant", Default = saved_Auto_Plant })
    auto_plant_toggle:OnChanged(function(on)
        Settings.Plant.Plant.Auto_Plant = on
        writefile(file, HttpService:JSONEncode(Settings))

        if on then
            spawn(function()
                while Options.Auto_Plant.Value do
                    local seeds = getSelectedSeeds()
                    if #seeds == 0 then
                        break
                    end

                    if not farmIndex then
                        break
                    end

                    for _, seedName in ipairs(seeds) do
                        local tool = findSeedTool(seedName)
                        if tool then
                            player.Character.Humanoid:EquipTool(tool)
                        end

                        local positions = plant_data.locations["Plant"][farmIndex]
                        if positions then
                            for _, locStr in ipairs(positions) do
                                local nums = {}
                                for num in locStr:gmatch("([^,]+)") do
                                    table.insert(nums, tonumber(num))
                                end
                                local pos = Vector3.new(nums[1], nums[2], nums[3])
                                plantRemote:FireServer(pos, seedName)
                            end
                        end
                    end

                    task.wait(0.1)
                end
            end)
        end
    end)


    -- [ Harvert ]
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
        Title = "Select Fruits",
        Description = "You can select multiple fruits",
        Values = harvestOptions,
        Multi = true,
        Default = saved_Harvest_Fruits,
    })
    selectFruits:OnChanged(function(val)
        Settings.Plant.Harvert.Select_Fruits = val
        writefile(file, HttpService:JSONEncode(Settings))
    end)

    local selectMuts = auto_harvert:AddDropdown("Select_Mutations_Harvert", {
        Title = "Select Mutations",
        Description = "You can select multiple mutations",
        Values = plant_data.mutations,
        Multi = true,
        Default = saved_Harvest_Mutations,
    })
    selectMuts:OnChanged(function(val)
        Settings.Plant.Harvert.Select_Mutations_Harvert = val
        writefile(file, HttpService:JSONEncode(Settings))
    end)

    local function getPlayerFarmFolder()
        local player = game.Players.LocalPlayer
        local farmParent = workspace:WaitForChild("Farm")
        for _, farmFolder in ipairs(farmParent:GetChildren()) do
            local important = farmFolder:FindFirstChild("Important")
            if important and important:FindFirstChild("Data") and important.Data:FindFirstChild("Owner") then
                if important.Data.Owner.Value == player.Name then
                    return farmFolder
                end
            end
        end
        return nil
    end

    local function harvestLoop()
        local farmFolder = getPlayerFarmFolder()
        if not farmFolder then
            return
        end

        local importantFolder = farmFolder:FindFirstChild("Important")
        if not importantFolder then
            return
        end

        local PlantsPhysical = importantFolder:FindFirstChild("Plants_Physical")
        if not PlantsPhysical then
            return
        end

        local selectedFruits = getSelected(Options.Select_Fruits_Harvert.Value)
        local selectedMuts = getSelected(Options.Select_Mutations_Harvert.Value)
        local filterFruit = #selectedFruits > 0
        local filterMut = #selectedMuts > 0

        for _, plant in ipairs(PlantsPhysical:GetChildren()) do
            task.wait(0.1)

            local growFolder = plant:FindFirstChild("Grow")
            local ageVal     = growFolder and growFolder:FindFirstChild("Age")
            local maxAgeAttr = plant:GetAttribute("MaxAge")
            local maxAgeVal  = (maxAgeAttr ~= nil and maxAgeAttr) or (plant:FindFirstChild("MaxAge") and plant.MaxAge.Value)

            if ageVal and maxAgeVal then
                if ageVal.Value < maxAgeVal then
                    continue
                end
            elseif growFolder or plant:FindFirstChild("MaxAge") then
                if not ageVal then end
                if not maxAgeVal then end
            else
                continue
            end

            if filterFruit then
                if not table.find(selectedFruits, plant.Name) then
                    continue
                end
            end

            if filterFruit and filterMut then
                local mutOnPlant = false
                for _, m in ipairs(selectedMuts) do
                    local attrValue  = plant:GetAttribute(m)
                    local childValue = plant:FindFirstChild(m) and plant[m].Value
                    if attrValue == true or childValue == true then
                        mutOnPlant = true
                        break
                    end
                end

                if mutOnPlant then
                    local fruitsFolder = plant:FindFirstChild("Fruits")
                    if fruitsFolder then
                        for _, fruit in ipairs(fruitsFolder:GetChildren()) do
                            ByteNetReliable:FireServer(
                                buffer.fromstring("\001\001\000\001"),
                                { fruit }
                            )
                        end
                    else
                        ByteNetReliable:FireServer(
                            buffer.fromstring("\001\001\000\001"),
                            { plant }
                        )
                    end
                end
                continue
            end

            if (not filterFruit) and filterMut then
                local fruitsFolder = plant:FindFirstChild("Fruits")
                if fruitsFolder then
                    for _, fruit in ipairs(fruitsFolder:GetChildren()) do
                        for _, m in ipairs(selectedMuts) do
                            local attrValueF  = fruit:GetAttribute(m)
                            local childValueF = fruit:FindFirstChild(m) and fruit[m].Value
                            if attrValueF == true or childValueF == true then
                                ByteNetReliable:FireServer(
                                    buffer.fromstring("\001\001\000\001"),
                                    { fruit }
                                )
                                break
                            end
                        end
                    end
                else
                    for _, m in ipairs(selectedMuts) do
                        local attrValueP  = plant:GetAttribute(m)
                        local childValueP = plant:FindFirstChild(m) and plant[m].Value
                        if attrValueP == true or childValueP == true then
                            ByteNetReliable:FireServer(
                                buffer.fromstring("\001\001\000\001"),
                                { plant }
                            )
                            break
                        end
                    end
                end
                continue
            end

            if filterFruit and (not filterMut) then
                if table.find(selectedFruits, plant.Name) then
                    local fruitsFolderCF = plant:FindFirstChild("Fruits")
                    if fruitsFolderCF then
                        for _, fruit in ipairs(fruitsFolderCF:GetChildren()) do
                            ByteNetReliable:FireServer(
                                buffer.fromstring("\001\001\000\001"),
                                { fruit }
                            )
                        end
                    else
                        ByteNetReliable:FireServer(
                            buffer.fromstring("\001\001\000\001"),
                            { plant }
                        )
                    end
                end
                continue
            end

            do
                local fruitsFolderAll = plant:FindFirstChild("Fruits")
                if fruitsFolderAll then
                    for _, fruit in ipairs(fruitsFolderAll:GetChildren()) do
                        ByteNetReliable:FireServer(
                            buffer.fromstring("\001\001\000\001"),
                            { fruit }
                        )
                    end
                else
                    ByteNetReliable:FireServer(
                        buffer.fromstring("\001\001\000\001"),
                        { plant }
                    )
                end
            end
        end
    end

    local autoHarvertToggle = auto_harvert:AddToggle("Auto_Harvert", { Title = "Auto Harvert", Default = saved_Auto_Harvest })
    autoHarvertToggle:OnChanged(function(state)
        Settings.Plant.Harvert.Auto_Harvert = state
        writefile(file, HttpService:JSONEncode(Settings))
        if state then
            task.spawn(function()
                while autoHarvertToggle.Value do
                    harvestLoop()
                    task.wait(1)
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

    local sellPropertyConn
    local sellChildAddedConn
    local sellChildRemovedConn

    local autosellToggle = auto_sell:AddToggle("Auto_Sell", { Title = "Auto Sell", Default = saved_Auto_Sell })
    autosellToggle:OnChanged(function(state)
        Settings.Plant.Auto_Sell.Auto_Sell = state
        writefile(file, HttpService:JSONEncode(Settings))

        if not state then
            if sellPropertyConn then
                sellPropertyConn:Disconnect()
                sellPropertyConn = nil
            end
            if sellChildAddedConn then
                sellChildAddedConn:Disconnect()
                sellChildAddedConn = nil
            end
            if sellChildRemovedConn then
                sellChildRemovedConn:Disconnect()
                sellChildRemovedConn = nil
            end
            return
        end

        if sellMode == "Every 30 seconds" then
            local orig = nil
            spawn(function()
                while autosellToggle.Value do
                    local char = player.Character
                    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        orig = hrp.CFrame
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
                        task.wait(2.5)
                        hrp.CFrame = orig
                        orig = nil
                    end
                    task.wait(30)
                end
            end)
        elseif sellMode == "Inventory Max" then
            local frame = player.PlayerGui:WaitForChild("Top_Notification"):WaitForChild("Frame")
            local origCFrame = nil
            local isWarping = false

            local function connectLabel(label)
                if sellPropertyConn then
                    sellPropertyConn:Disconnect()
                    sellPropertyConn = nil
                end

                sellPropertyConn = label:GetPropertyChangedSignal("Text"):Connect(function()
                    if not autosellToggle.Value then return end

                    local text = label.Text
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
                end)
            end

            local function onChildRemoved(child)
                if child.Name == "Notification_UI" and isWarping and origCFrame then
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

            if sellChildAddedConn then
                sellChildAddedConn:Disconnect()
                sellChildAddedConn = nil
            end
            sellChildAddedConn = frame.ChildAdded:Connect(function(child)
                if child.Name == "Notification_UI" then
                    local label = child:WaitForChild("TextLabel")
                    connectLabel(label)
                end
            end)

            if sellChildRemovedConn then
                sellChildRemovedConn:Disconnect()
                sellChildRemovedConn = nil
            end
            sellChildRemovedConn = frame.ChildRemoved:Connect(onChildRemoved)

            local existing = frame:FindFirstChild("Notification_UI")
            if existing then
                local label = existing:WaitForChild("TextLabel")
                connectLabel(label)
            end
        end
    end)



    -- [ Egg ]
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
    local auto_egg = Tabs.Pet_And_Egg:AddSection("[ 🥚 ] - Egg")
    local select_egg_to_place = auto_egg:AddDropdown("Select_Egg_To_Place", {
        Title = "Select Eggs To Place",
        Description = "You can select multiple Eggs",
        Values = egg_choices,
        Multi = true,
        Default = saved_Eggs_To_Place,
    })
    select_egg_to_place:OnChanged(function(value)
        Settings.Pet_And_Egg.Egg.Select_Egg_To_Place = value
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
        Settings.Pet_And_Egg.Egg.Auto_Place_Egg = on
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
        Settings.Pet_And_Egg.Egg.Auto_Hatch_Egg = on
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
    local auto_pet = Tabs.Pet_And_Egg:AddSection("[ 🐶 ] - Pet")
    local select_pet_to_sell = auto_pet:AddDropdown("Select_Pet_To_Sell", {
        Title = "Select Pet To Sell",
        Description = "You can select multiple Pets",
        Values = egg_data.pet,
        Multi = true,
        Default = saved_Pet_To_Sell,
    })
    select_pet_to_sell:OnChanged(function(value)
        Settings.Pet_And_Egg.Pet.Select_Pet_To_Sell = value
        writefile(file, HttpService:JSONEncode(Settings))
    end)
    local auto_sell_pet_toggle = auto_pet:AddToggle("Auto_Sell_Pet", { Title = "Auto Sell Pet", Default = saved_Auto_Sell_Pet })
    auto_sell_pet_toggle:OnChanged(function(on)
        Settings.Pet_And_Egg.Pet.Auto_Sell_Pet = on
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
                                    if baseName == petName then
                                        targetTool = tool
                                        break
                                    end
                                end
                            end
                            if targetTool and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                                player.Character:FindFirstChildOfClass("Humanoid"):EquipTool(targetTool)
                                sellPetEvent:FireServer(targetTool)
                                task.wait(0.5)
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end)



    -- [ Event ]
    local bee_event = Tabs.Event:AddSection("[ 🐝 ] - Swarm Event")
    bee_event:AddParagraph({
        Title = "Working after Swarm Event ended"
    })
    local auto_Auto_Collect_Honey = bee_event:AddToggle("Auto_Collect_Honey", { Title = "Auto Collect Honey and Give Plant", Default = saved_Auto_Collect_Honey })

    local autoCollectEnabled = auto_Auto_Collect_Honey.Value

    auto_Auto_Collect_Honey:OnChanged(function(state)
        Settings.Event.Swarm.Auto_Collect_Honey = state
        writefile(file, HttpService:JSONEncode(Settings))

        autoCollectEnabled = state

        if state then
            task.spawn(function()
                local label = workspace:WaitForChild("Interaction"):WaitForChild("UpdateItems"):WaitForChild("HoneyEvent"):WaitForChild("HoneyCombpressor"):WaitForChild("Sign"):WaitForChild("SurfaceGui"):WaitForChild("TextLabel")

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
                    local tool = findPollinatedTool()
                    if tool and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        humanoid:EquipTool(tool)

                        local text = label.Text

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

                            if not autoCollectEnabled then
                                break
                            end

                            wait(1)
                        else
                            repeat
                                wait(1)
                                text = label.Text
                            until (not text:match("%d+:%d+")) or (not autoCollectEnabled)

                            if not autoCollectEnabled then
                                break
                            end
                            wait(1)
                        end
                    else
                        wait(2)
                    end
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
    local egg_shop = Tabs.Shop:AddSection("[ 🥚 ] - Egg Shop")
    local select_egg = egg_shop:AddDropdown("Select_Eggs", {
        Title = "Buy Eggs",
        Description = "You can select multiple eggs",
        Values = egg_choices,
        Multi = true,
        Default = saved_Egg_Shop,
    })
    select_egg:OnChanged(function(Value)
        Settings.Shop.Egg_Shop.Select_Eggs = Value
        writefile(file, HttpService:JSONEncode(Settings))
    end)
    local function parseColor(str)
        local r,g,b = str:match("(%d+),%s*(%d+),%s*(%d+)")
        return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
    end

    local skinColorMap = {}
    for name, str in pairs(egg_data.other.skin_color) do
        skinColorMap[name] = parseColor(str)
    end

    local locMapping = {}
    for idx, locStr in pairs(egg_data.other.locations) do
        local nums = {}
        for v in locStr:gmatch("([^,]+)") do
            table.insert(nums, tonumber(v))
        end
        locMapping[idx] = Vector3.new(nums[1], nums[2], nums[3])
    end
    local function autoBuyEggs(filterTypes)
        local ok, eggFolder = pcall(function()
            return workspace:WaitForChild("NPCS"):WaitForChild("Pet Stand"):WaitForChild("EggLocations")
        end)
        if not ok then
            return
        end

        for _, model in ipairs(eggFolder:GetChildren()) do
            if not model:IsA("Model") then
                continue
            end

            local isPurchased = model:GetAttribute("RobuxEggOnly")
            if isPurchased then
                continue
            end

            local rawColor = model:GetAttribute("EggColor")
            local color = nil
            if typeof(rawColor) == "Color3" then
                color = rawColor
            elseif type(rawColor) == "string" then
                color = parseColor(rawColor)
            else
                continue
            end

            local eggType = nil
            for name, c in pairs(skinColorMap) do
                if (c == color) then
                    eggType = name
                    break
                end
            end
            if not eggType then
                continue
            end

            if not table.find(filterTypes, eggType) then
                continue
            end

            local pivotPos = model:GetPivot().Position
            for idx, locPos in pairs(locMapping) do
                if (pivotPos - locPos).Magnitude < 1 then
                    buyPetEggRemote:FireServer(idx)
                    break
                end
            end
        end
    end
    local auto_buy_egg_button = egg_shop:AddToggle("Auto_buy_egg", { Title = "Auto Buy Eggs", Default = saved_Auto_Buy_Eggs })
    auto_buy_egg_button:OnChanged(function(val)
        Settings.Shop.Egg_Shop.Auto_Buy_Eggs = val
        writefile(file, HttpService:JSONEncode(Settings))

        if val then
            spawn(function()
                while Options.Auto_buy_egg.Value do
                    local selected = {}
                    for name, enabled in pairs(Options.Select_Eggs.Value) do
                        if enabled then
                            local eggName = tostring(name):gsub("%s*Egg$", "")
                            table.insert(selected, eggName)
                        end
                    end
                    if #selected == 0 then
                        selected = egg_data.shop
                    end

                    autoBuyEggs(selected)

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

local Notification = require(ReplicatedStorage.Modules.Notification)
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
