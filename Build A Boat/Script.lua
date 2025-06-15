local chest_data = {
    "Common Chest",
    "Uncommon Chest",
    "Rare Chest",
    "Epic Chest",
    "Legendary Chest"
}

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

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
    Main = {
        Auto_Farm = {
            Mode = {},
            Toggle = false
        }
    },
    Shop = {
        Auto_Buy_Chest = {
            Select = {},
            Toggle = false
        }
    }
}

for cat, tbl in pairs(defaults) do
    Settings[cat] = Settings[cat] or {}
    for sub, subTbl in pairs(tbl) do
        Settings[cat][sub] = Settings[cat][sub] or subTbl
    end
end

writefile(file, HttpService:JSONEncode(Settings))

-- Main > Auto Farm
local saved_AutoFarm_Mode = Settings.Main.Auto_Farm.Mode
local saved_AutoFarm_Toggle = Settings.Main.Auto_Farm.Toggle

-- Event

-- Shop > Buy Chest
local saved_Select_Auto_Buy_Chest = Settings.Shop.Auto_Buy_Chest.Select
local saved_Auto_Buy_Chest_Toggle = Settings.Shop.Auto_Buy_Chest.Toggle

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
    Main = Window:AddTab({ Title = "Main", Icon = "book-open" }),
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



    -- [ Main ] Auto Farm
    local caveFolder = workspace.BoatStages.NormalStages
    local trigger = workspace.BoatStages.NormalStages.TheEnd.GoldenChest.Trigger
    local startCFrame = CFrame.new(-65, 80, 755)
    local tweenInfo = TweenInfo.new(35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local goal = { CFrame = CFrame.new(-54, 80, 8808) }
    local toggleConn, currentTween, teleportLoop
    local autoFarm = Tabs.Main:AddSection("[ 💵 ] - Auto Farm")
    local autoFarm_Mode_Dropdown = autoFarm:AddDropdown("Auto_Farm_Mode_Dropdown", {
        Title = "Select mode to farm",
        Values = {"Tween", "Teleport"},
        Multi = false,
        Default = saved_AutoFarm_Mode,
    })
    local autoFarm_Toggle = autoFarm:AddToggle("Auto_Farm", {Title = "Auto Farm", Default = saved_AutoFarm_Toggle })
    local function stopFarm()
        if toggleConn then
            toggleConn:Disconnect()
            toggleConn = nil
        end
        if currentTween then
            currentTween:Cancel()
            currentTween = nil
        end
        if teleportLoop then
            teleportLoop:Disconnect()
            teleportLoop = nil
        end
        hrp.Anchored = false
        hrp.CanCollide = true
    end
    local function tryStartFarm(mode, isOn)
        if isOn then
            if mode == "Tween" then
                stopFarm()

                hrp.CFrame = startCFrame
                hrp.CanCollide = false

                toggleConn = RunService.RenderStepped:Connect(function()
                    hrp.Anchored = not hrp.Anchored
                end)

                currentTween = TweenService:Create(hrp, tweenInfo, goal)
                currentTween:Play()

                currentTween.Completed:Connect(function(status)
                    if toggleConn then toggleConn:Disconnect() end
                    hrp.Anchored = false
                    hrp.CanCollide = true
                    hrp.CFrame = trigger.CFrame + Vector3.new(0, -3, 0)
                    currentTween = nil
                end)

            elseif mode == "Teleport" then
                stopFarm()
                hrp.CanCollide = false

                local marker
                spawn(function()
                    for i = 1, 10 do
                        if not autoFarm_Toggle.Value then break end

                        local stage = caveFolder:FindFirstChild("CaveStage"..i)
                        if stage then
                            local darkPart = stage:FindFirstChild("DarknessPart")
                            if darkPart then
                                hrp.CFrame = darkPart.CFrame + Vector3.new(0, 3, 0)

                                if marker then
                                    marker:Destroy()
                                    marker = nil
                                end

                                marker = Instance.new("Part")
                                marker.Name = "TeleportMarker"
                                marker.Size = Vector3.new(5, 0.5, 5)
                                marker.Anchored = true
                                marker.CanCollide = true
                                marker.CFrame = hrp.CFrame + Vector3.new(0, -50, 0)
                                marker.Parent = workspace
                            end
                        end

                        task.wait(2)
                    end

                    if autoFarm_Toggle.Value then
                        if marker then
                            marker:Destroy()
                            marker = nil
                        end

                        hrp.CFrame = trigger.CFrame + Vector3.new(0, -3, 0)
                    else
                        if marker then
                            marker:Destroy()
                            marker = nil
                        end
                    end

                    hrp.CanCollide = true
                end)
            end
        else
            stopFarm()
        end
    end
    autoFarm_Mode_Dropdown:OnChanged(function(value)
        Settings.Main.Auto_Farm.Mode = value
        writefile(file, HttpService:JSONEncode(Settings))
        tryStartFarm(value, autoFarm_Toggle.Value)
    end)
    autoFarm_Toggle:OnChanged(function(value)
        Settings.Main.Auto_Farm.Toggle = value
        writefile(file, HttpService:JSONEncode(Settings))
        tryStartFarm(autoFarm_Mode_Dropdown.Value, autoFarm_Toggle.Value)
    end)
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        hrp = character:WaitForChild("HumanoidRootPart")

        if autoFarm_Toggle.Value then
            tryStartFarm(autoFarm_Mode_Dropdown.Value, true)
        end
    end)

    if player.Character then
        if autoFarm_Toggle.Value then
            tryStartFarm(autoFarm_Mode_Dropdown.Value, true)
        end
    end



    -- [ Event ]
    local event = Tabs.Event:AddSection("[ ⚙️ ] - Event")
    event:AddParagraph({
        Title = "Don't have any event"
    })



    -- [ Store ]
    local store = Tabs.Shop:AddSection("[ 🧰 ] - Buy Chest")
    local selectedChests = {}

    local auto_Buy_Chest_Dropdown = store:AddDropdown("Auto_Buy_Chest_Dropdown", {
        Title = "Select chest to buy",
        Description = "You can select multiple chests",
        Values = chest_data,
        Multi = true,
        Default = saved_Select_Auto_Buy_Chest,
    })
    auto_Buy_Chest_Dropdown:OnChanged(function(selection)
        selectedChests = {}
        for chestName, isOn in pairs(selection) do
            if isOn then
                table.insert(selectedChests, chestName)
            end
        end
        Settings.Shop.Auto_Buy_Chest.Select = selection
        writefile(file, HttpService:JSONEncode(Settings))
    end)

    local auto_Buy_Chest_Toggle = store:AddToggle("Auto_Buy_Chest", { Title   = "Auto Buy Chest", Default = saved_Auto_Buy_Chest_Toggle, })
    auto_Buy_Chest_Toggle:OnChanged(function(isOn)
        Settings.Shop.Auto_Buy_Chest.Toggle = isOn
        writefile(file, HttpService:JSONEncode(Settings))

        if isOn then
            spawn(function()
                while auto_Buy_Chest_Toggle.Value do
                    for _, chestName in ipairs(selectedChests) do
                        pcall(function()
                            workspace:WaitForChild("ItemBoughtFromShop"):InvokeServer(chestName, 1)
                        end)
                        task.wait(1)
                    end
                    task.wait(0.5)
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

Fluent:Notify({
    Title = hub,
    Content = "Anti AFK : Activate",
    Duration = 5
})

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

local function onPlayerAdded(player)
    if player.Name == owner then
        Fluent:Notify({
            Title = hub,
            Content = "The owner just joined your server",
            Duration = 5
        })
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)

local existing = Players:FindFirstChild(owner)
if existing then
    Fluent:Notify({
        Title = hub,
        Content = "The owner is already in the server",
        Duration = 5
    })
end