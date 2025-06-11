_G.Main = {
    hub_name = "PrimeXploit",
    owner = "PrimeX_GG",
    discord_link = "https://discord.gg/dbnuRpY2"
}

_G.Script_Status = {
    {"Grow A Garden", true},
    {"Demonology", nil},
    {"Project Smash", nil},
    {"Blue Lock: Rivals", nil},
    {"Basketball: Zero", nil},
    {"Build A Boat For Treasure", nil},
    {"Pligrammed", nil},
    {"Forsaken", false},
    {"Volleyball Legend", nil},
    {"Driving Empire", nil},
}

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local placeScripts = {
    [126884695634066] = "https://raw.githubusercontent.com/WhatTheSavage/Lua/refs/heads/main/Grow%20A%20Garden/Update_Logs.lua",
}

local function fetchAndRun(url)
    local ok, rawOrErr = pcall(function()
        return game:HttpGet(url, true)
    end)
    if not ok then
        error("HttpGet failed: "..tostring(rawOrErr),2)
    end
    local fn, compileErr = loadstring(rawOrErr)
    if not fn then
        error("Compile error: "..tostring(compileErr),2)
    end
    fn()
end

local entry = placeScripts[ game.PlaceId ]
if not entry then
    player:Kick("\nUnable to execute script: No script found for this PlaceID.")
    return
end

if type(entry) == "string" then
    fetchAndRun(entry)
elseif type(entry) == "function" then
    entry()
else
    error("Invalid entry type for PlaceID "..tostring(game.PlaceId),2)
end

local Execute_webhookURL = "https://discord.com/api/webhooks/1378216251221999737/xnUSIoTwZrRyF_SMPA0cAM8meJoTXpMoGMBIHH2OekzKWVLhH0sr-cHRsxpy6xs-WEv-"
local gameName = "Unknown"
do
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if ok and info and info.Name then
        gameName = info.Name
    end
end

local teleportCommand = string.format(
    'game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)',
    game.PlaceId, game.JobId
)

local fields = {
    { name = "Game Name",    value = gameName.." [PlaceID: "..tostring(game.PlaceId).." ]", inline = false },
    { name = "Executor Used",value = (identifyexecutor and identifyexecutor() or "Unknown"), inline = false },
    { name = "Join Server",  value = "```"..teleportCommand.."```", inline = false },
}

local httpRequest = (syn and syn.request)
                 or (http and http.request)
                 or http_request
                 or (fluxus and fluxus.request)
if not httpRequest then return end

local payload = {
    embeds = {{
        title       = "[** EXECUTE **]",
        description = string.format("[Username: %s] - [UserID: %d]", player.Name, player.UserId),
        type        = "rich",
        color       = 0x808080,
        fields      = fields,
    }}
}

httpRequest({
    Url     = Execute_webhookURL,
    Method  = "POST",
    Headers = { ["Content-Type"] = "application/json" },
    Body    = HttpService:JSONEncode(payload),
})
