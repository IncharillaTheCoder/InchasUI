local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local aimbotEnabled = false
local espEnabled = true
local aimbotKey = Enum.KeyCode.Q
local espKey = Enum.KeyCode.E

local espObjects = {}

local function newDrawing(t)
    local ok, d = pcall(function() return Drawing.new(t) end)
    return ok and d or nil
end

local function createESP(p)
    if espObjects[p] then return end
    local box = newDrawing("Square")
    local tracer = newDrawing("Line")
    local nameTag = newDrawing("Text")
    local hp = newDrawing("Square")
    if not box or not tracer or not nameTag or not hp then return end
    box.Thickness, box.Filled, box.Color, box.Visible, box.ZIndex = 2, false, Color3.fromRGB(255,0,0), false, 2
    tracer.Thickness, tracer.Color, tracer.Visible, tracer.ZIndex = 1, Color3.fromRGB(255,255,255), false, 1
    nameTag.Size, nameTag.Center, nameTag.Outline, nameTag.Color, nameTag.Visible, nameTag.ZIndex =
        16, true, true, Color3.fromRGB(255,255,255), false, 3
    nameTag.Text = p.Name
    hp.Thickness, hp.Filled, hp.Color, hp.Visible, hp.ZIndex = 1, true, Color3.fromRGB(0,255,0), false, 2
    espObjects[p] = {box = box, tracer = tracer, nameTag = nameTag, healthBar = hp}
end

local function removeESP(p)
    local d = espObjects[p]
    if not d then return end
    if d.box then pcall(function() d.box:Remove() end) end
    if d.tracer then pcall(function() d.tracer:Remove() end) end
    if d.nameTag then pcall(function() d.nameTag:Remove() end) end
    if d.healthBar then pcall(function() d.healthBar:Remove() end) end
    espObjects[p] = nil
end

Players.PlayerRemoving:Connect(removeESP)
Players.PlayerAdded:Connect(function(p) if espEnabled then createESP(p) end end)

local function updateESP(p)
    if not espEnabled or p == LocalPlayer or not p.Character then return end
    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
    local head = p.Character:FindFirstChild("Head")
    local humanoid = p.Character:FindFirstChild("Humanoid")
    local cam = Workspace.CurrentCamera
    if not hrp or not head or not cam then removeESP(p) return end
    if not espObjects[p] then createESP(p) end
    local e = espObjects[p]
    if not e then return end
    local rootPos, rootVisible = cam:WorldToViewportPoint(hrp.Position)
    local headPos = cam:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
    local legPos = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))
    if rootVisible then
        local height = math.abs(headPos.Y - legPos.Y)
        local width = math.max(1, height/2)
        e.box.Size = Vector2.new(width, height)
        e.box.Position = Vector2.new(rootPos.X - width/2, headPos.Y)
        e.box.Visible = true
        local screenSize = cam.ViewportSize
        e.tracer.From = Vector2.new(screenSize.X/2, screenSize.Y)
        e.tracer.To = Vector2.new(rootPos.X, legPos.Y)
        e.tracer.Visible = true
        e.nameTag.Position = Vector2.new(rootPos.X, headPos.Y - 20)
        e.nameTag.Visible = true
        if humanoid and humanoid.Health > 0 and humanoid.MaxHealth > 0 then
            local hpPct = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            local hbH = math.max(1, height * hpPct)
            e.healthBar.Size = Vector2.new(3, hbH)
            e.healthBar.Position = Vector2.new(rootPos.X - width/2 - 6, legPos.Y + (height - hbH))
            if hpPct > 0.6 then
                e.healthBar.Color = Color3.fromRGB(0,255,0)
            elseif hpPct > 0.3 then
                e.healthBar.Color = Color3.fromRGB(255,255,0)
            else
                e.healthBar.Color = Color3.fromRGB(255,0,0)
            end
            e.healthBar.Visible = true
        else
            e.healthBar.Visible = false
        end
    else
        e.box.Visible, e.tracer.Visible, e.nameTag.Visible, e.healthBar.Visible = false, false, false, false
    end
end

local function getClosestPlayer()
    local cam = Workspace.CurrentCamera
    if not cam then return nil end
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local best, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if head and hrp then
                local screenPoint, onScreen = cam:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (mousePos - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                    if dist < bestDist then bestDist, best = dist, p end
                end
            end
        end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local t = getClosestPlayer()
        if t and t.Character then
            local head = t.Character:FindFirstChild("Head")
            local cam = Workspace.CurrentCamera
            if head and cam then
                cam.CFrame = CFrame.lookAt(cam.CFrame.Position, head.Position)
            end
        end
    end
    if espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then updateESP(p) end
        end
    end
end)

UserInputService.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == aimbotKey then aimbotEnabled = not aimbotEnabled end
    if i.KeyCode == espKey then
        espEnabled = not espEnabled
        if not espEnabled then
            for p,_ in pairs(espObjects) do removeESP(p) end
        else
            for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then createESP(p) end end
        end
    end
end)
