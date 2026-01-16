local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

local introGui = Instance.new("ScreenGui")
introGui.Name = "IntroPedro"
introGui.ResetOnSpawn = false
introGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", introGui)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.Size = UDim2.new(0, 200, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

local text = Instance.new("TextLabel", frame)
text.Size = UDim2.new(1, 0, 1, 0)
text.BackgroundTransparency = 1
text.Text = "By @Incharilla on Discord"
text.Font = Enum.Font.GothamBold
text.TextSize = 20
text.TextColor3 = Color3.new(1, 1, 1)
text.TextTransparency = 1

local sound = Instance.new("Sound", frame)
sound.SoundId = "rbxassetid://9118828564"
sound.Volume = 0.6

TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 260, 0, 80),
	BackgroundTransparency = 0.15
}):Play()

TweenService:Create(text, TweenInfo.new(0.5), {
	TextTransparency = 0
}):Play()

TweenService:Create(blur, TweenInfo.new(0.5), {
	Size = 12
}):Play()

sound:Play()

task.delay(2, function()
	TweenService:Create(frame, TweenInfo.new(0.5), {
		Size = UDim2.new(0, 200, 0, 60),
		BackgroundTransparency = 1
	}):Play()

	TweenService:Create(text, TweenInfo.new(0.5), {
		TextTransparency = 1
	}):Play()

	TweenService:Create(blur, TweenInfo.new(0.5), {
		Size = 0
	}):Play()

	task.delay(0.6, function()
		sound:Stop()
		sound:Destroy()
		blur:Destroy()
		introGui:Destroy()
	end)
end)

pcall(function()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

Lighting.GlobalShadows = false
Lighting.Brightness = 1
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
Lighting.FogEnd = 9e9

for _, v in ipairs(Lighting:GetChildren()) do
	if v:IsA("PostEffect") then
		v.Enabled = false
	end
end

local function optimize(obj)
	if obj:IsA("BasePart") then
		obj.Material = Enum.Material.Plastic
		obj.Reflectance = 0
		obj.CastShadow = false
	elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
		obj.Enabled = false
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
		obj.Transparency = 1
	end
end

for _, obj in ipairs(workspace:GetDescendants()) do
	optimize(obj)
end

workspace.DescendantAdded:Connect(function(obj)
	task.wait()
	optimize(obj)
end)

local infoGui = Instance.new("ScreenGui", player.PlayerGui)
infoGui.ResetOnSpawn = false

local infoFrame = Instance.new("Frame", infoGui)
infoFrame.Size = UDim2.new(0, 95, 0, 22)
infoFrame.Position = UDim2.new(1, -100, 0, 10)
infoFrame.BackgroundColor3 = Color3.new(0, 0, 0)
infoFrame.BackgroundTransparency = 0.4
infoFrame.BorderSizePixel = 0

local infoText = Instance.new("TextLabel", infoFrame)
infoText.Size = UDim2.new(1, 0, 1, 0)
infoText.BackgroundTransparency = 1
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 11
infoText.TextColor3 = Color3.fromRGB(0, 255, 0)
infoText.Text = "FPS: 0 | MS: 0"

local frames = 0
local last = tick()

RunService.RenderStepped:Connect(function()
	frames += 1
	if tick() - last >= 1 then
		local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		infoText.Text = "FPS: " .. frames .. " | MS: " .. ping
		frames = 0
		last = tick()
	end
end)
