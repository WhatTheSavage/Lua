local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

_G.ENABLED = not _G.ENABLED
local clickDelay_local = _G.settings.clickDelay

StarterGui:SetCore("SendNotification", {
    Title = "Notify",
    Text = (_G.ENABLED and "Enabled" or "Disabled") .. " | Delay : " .. clickDelay_local,
    Duration = 5
})

local player = Players.LocalPlayer

RunService.Heartbeat:Connect(function()
    local digGui = player.PlayerGui:FindFirstChild("Dig")
    if not digGui then return end
    local safezone = digGui:FindFirstChild("Safezone")
    local holder = safezone and safezone:FindFirstChild("Holder")
    if holder then
        local playerBar = holder:FindFirstChild("PlayerBar")
        local areaStrong = holder:FindFirstChild("Area_Strong")
        if playerBar and areaStrong then
            playerBar.Position = areaStrong.Position
        end
    end
end)

spawn(function()
    local cam = workspace.CurrentCamera
    local cx, cy = cam.ViewportSize.X/2, cam.ViewportSize.Y/2

    while _G.ENABLED do
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end

        task.wait(clickDelay_local)

        local digGui = player.PlayerGui:FindFirstChild("Dig")
        local noDigFolder = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Zones") and workspace.World.Zones:FindFirstChild("_NoDig")
        if not digGui then
            if noDigFolder then
                for _, v in ipairs(noDigFolder:GetChildren()) do
                    if v:IsA("BasePart") then
                        v:Destroy()
                    end
                end
            end
            VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true,  digGui, false)
            VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, digGui, false)
        else
            local safezone = digGui:FindFirstChild("Safezone")
            if not safezone then
                RunService.Heartbeat:Wait()
                continue
            end
            VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true,  digGui, false)
            VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, digGui, false)
        end

        RunService.Heartbeat:Wait()
    end
end)
