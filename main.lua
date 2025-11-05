-- Roblox Aimbot Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local aimbotEnabled: boolean = false
local aimbotKey: Enum.KeyCode = Enum.KeyCode.Q

-- Toggle aimbot with Q key
UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
    if gameProcessed then return end
    
    if input.KeyCode == aimbotKey then
        aimbotEnabled = not aimbotEnabled
        print("Aimbot: " .. (aimbotEnabled and "ENABLED" or "DISABLED"))
    end
end)

-- Find closest player to crosshair
local function getClosestPlayer(): Player?
    local closestPlayer: Player? = nil
    local shortestDistance: number = math.huge
    local currentCamera = Workspace.CurrentCamera
    
    if not currentCamera then return nil end
    
    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            
            if humanoidRootPart and head then
                local screenPoint, visible = currentCamera:WorldToScreenPoint(head.Position)
                
                if visible then
                    local mouseLocation = Vector2.new(Mouse.X, Mouse.Y)
                    local targetLocation = Vector2.new(screenPoint.X, screenPoint.Y)
                    local distance = (mouseLocation - targetLocation).Magnitude
                    
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Aimbot logic
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local targetPlayer = getClosestPlayer()
        
        if targetPlayer and targetPlayer.Character then
            local character = targetPlayer.Character
            local head = character:FindFirstChild("Head")
            
            if head then
                local currentCamera = Workspace.CurrentCamera
                if currentCamera then
                    currentCamera.CFrame = CFrame.lookAt(currentCamera.CFrame.Position, head.Position)
                end
            end
        end
    end
end)

print("Aimbot script loaded. Press Q to toggle.")
