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
    {"Build A Boat For Treasure", true},
    {"Pligrammed", nil},
    {"Forsaken", nil},
    {"Volleyball Legend", nil},
    {"Driving Empire", nil},
}

local player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local placeScripts = {
    [126884695634066] = "https://raw.githubusercontent.com/WhatTheSavage/Lua/refs/heads/main/Grow%20A%20Garden/Update_Logs.lua",
    [537413528] = "https://raw.githubusercontent.com/WhatTheSavage/Lua/refs/heads/main/Build%20A%20Boat/Update_Logs.lua"
}

local keysTable = {
    ["Staff"] = {
        ["8693748922"] = "PRIME-X-PLOIT-473115-P1H9WL-A3R0JS-ZG4XAU-RURV3F-T2L8XG",
        ["1547445463"] = "PRIME-X-PLOIT-539897-A3KYV1-HD4ZMV-UXNLZ3-YQZCIH-7ZGGYE",
        ["6016908523"] = "PRIME-X-PLOIT-190913-6F7SAP-2W8VQ2-25DEMF-BOMEZU-VMY99L",
        ["2924621695"] = "PRIME-X-PLOIT-580260-6GPXP7-ZU8HIM-4SD17H-4GGK9L-RSOF7T"
    },
    ["LifeTime_Set1"] = {
        [""] = "PRIME-X-PLOIT-058548-SKGOWG-QSFW55-G7F4QT-GLPS47-KJODK4",
        [""] = "PRIME-X-PLOIT-207138-7ODCJN-RURCTN-V8AL7X-XS916C-2MS4V6",
        [""] = "PRIME-X-PLOIT-479542-NKOVF5-O1NT32-4NTMRM-UZFDJG-T0KSH5",
        [""] = "PRIME-X-PLOIT-665637-NTE3ET-W4W1KT-L97FLT-9FS7EV-A4BL3H",
        [""] = "PRIME-X-PLOIT-973663-ELB34E-94JAHT-424TPG-Q35DFJ-YOHHHJ",
        [""] = "PRIME-X-PLOIT-660966-HJV0QS-29WBN4-KJQ4TH-SGK208-7WQLN4",
        [""] = "PRIME-X-PLOIT-996668-BKG4Z5-YDYI7Q-BP1ZLO-NQDMF9-U39INC",
        [""] = "PRIME-X-PLOIT-841861-XZ5R0L-IXBDV3-NEEW8E-3LLRZX-OBPRKK",
        [""] = "PRIME-X-PLOIT-225781-TM82GX-Q0QMEP-RX6EAE-0HP93C-46PCQ7",
        [""] = "PRIME-X-PLOIT-038608-6ZWX2R-UQJT6E-QEF286-JKRE7N-JTF6MN"
    }
}

local userIdStr = tostring(player.UserId)
local userKey = tostring(_G.PrimeKey)

local function isValidKey()
    if keysTable.Staff and keysTable.Staff[userIdStr] == userKey then
        return true
    end
    if keysTable.LifeTime_Set1 and keysTable.LifeTime_Set1[userIdStr] == userKey then
        return true
    end
    return false
end

if not isValidKey() then
    player:Kick("\nInvalid key or UserID mismatch.")
    return
end

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
