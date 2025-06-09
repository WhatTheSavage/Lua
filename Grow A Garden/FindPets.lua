local DataSer = require(game:GetService("ReplicatedStorage").Modules.DataService)
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")

while true do
    task.wait(1)

    local found = false
    local petNameFound

    for _, v in pairs(DataSer:GetData().SavedObjects) do
        if v.ObjectType == "PetEgg" and v.Data.RandomPetData then
            local name = v.Data.RandomPetData.Name
			StarterGui:SetCore("SendNotification", {
				Title = "[ DEBUG ] Found",
				Text = name,
				Duration = 5,
			})

            if table.find(_G.TargetNames, name) then
                found = true
                petNameFound = name
                break
            end
        end
    end

    if found then
        StarterGui:SetCore("SendNotification", {
            Title = "✨ Found",
            Text = petNameFound,
            Duration = 5,
        })
        break
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Not Found",
            Text = "Rejoin...",
            Duration = 5,
        })
        task.wait(3)
        TeleportService:Teleport(game.PlaceId, localPlayer)
        return
    end
end
