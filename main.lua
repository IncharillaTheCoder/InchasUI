loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Main = Fluent:CreateWindow({
    Title = "Flight Control",
    SubTitle = "Enhanced Movement System",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark"
})

local Tabs = {
    Flight = Main:AddTab({ Title = "Flight", Icon = "wind" }),
    Settings = Main:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Flight System Variables
local Player = game:GetService("Players").LocalPlayer
local Character = Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local FlySpeed = 50
local Flying = false
local BodyGyro, BodyVelocity

local Controls = {
    Forward = false,
    Backward = false,
    Left = false,
    Right = false,
    Up = false,
    Down = false
}

-- Fly function
local function Fly()
    if Flying then
        BodyGyro = Instance.new("BodyGyro")
        BodyVelocity = Instance.new("BodyVelocity")
        
        BodyGyro.Parent = HumanoidRootPart
        BodyVelocity.Parent = HumanoidRootPart
        
        BodyGyro.P = 9e4
        BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.cframe = HumanoidRootPart.CFrame
        
        BodyVelocity.velocity = Vector3.new(0, 0, 0)
        BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        spawn(function()
            while Flying do
                wait()
                
                local moveDirection = Vector3.new(0, 0, 0)
                
                if Controls.Left then
                    moveDirection = moveDirection + Vector3.new(-FlySpeed, 0, 0)
                elseif Controls.Right then
                    moveDirection = moveDirection + Vector3.new(FlySpeed, 0, 0)
                end
                
                if Controls.Forward then
                    moveDirection = moveDirection + Vector3.new(0, 0, -FlySpeed)
                elseif Controls.Backward then
                    moveDirection = moveDirection + Vector3.new(0, 0, FlySpeed)
                end
                
                if Controls.Up then
                    moveDirection = moveDirection + Vector3.new(0, FlySpeed, 0)
                elseif Controls.Down then
                    moveDirection = moveDirection + Vector3.new(0, -FlySpeed, 0)
                end
                
                if moveDirection.Magnitude > 0 then
                    BodyVelocity.velocity = BodyGyro.cframe:VectorToWorldSpace(moveDirection)
                else
                    BodyVelocity.velocity = Vector3.new(0, 0, 0)
                end
                
                BodyGyro.cframe = Workspace.CurrentCamera.CoordinateFrame
            end
            
            if BodyGyro then BodyGyro:Destroy() end
            if BodyVelocity then BodyVelocity:Destroy() end
        end)
    else
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
    end
end

-- Input handling
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.W then
        Controls.Forward = true
    elseif input.KeyCode == Enum.KeyCode.S then
        Controls.Backward = true
    elseif input.KeyCode == Enum.KeyCode.A then
        Controls.Left = true
    elseif input.KeyCode == Enum.KeyCode.D then
        Controls.Right = true
    elseif input.KeyCode == Enum.KeyCode.Space then
        Controls.Up = true
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        Controls.Down = true
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.W then
        Controls.Forward = false
    elseif input.KeyCode == Enum.KeyCode.S then
        Controls.Backward = false
    elseif input.KeyCode == Enum.KeyCode.A then
        Controls.Left = false
    elseif input.KeyCode == Enum.KeyCode.D then
        Controls.Right = false
    elseif input.KeyCode == Enum.KeyCode.Space then
        Controls.Up = false
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        Controls.Down = false
    end
end)

-- GUI Elements
Tabs.Flight:AddParagraph({
    Title = "Flight Control System",
    Content = "Toggle flight mode and adjust flight speed using the controls below."
})

local FlightToggle = Tabs.Flight:AddToggle("FlightToggle", {
    Title = "Flight Mode",
    Default = false
})

FlightToggle:OnChanged(function(value)
    Flying = value
    if Flying then
        Main:Notify({
            Title = "Flight System",
            Content = "Flight mode activated!",
            Duration = 2
        })
        Fly()
    else
        Main:Notify({
            Title = "Flight System",
            Content = "Flight mode deactivated!",
            Duration = 2
        })
        if BodyGyro then BodyGyro:Destroy() end
        if BodyVelocity then BodyVelocity:Destroy() end
    end
    print("Flight Mode:", Flying)
end)

local SpeedSlider = Tabs.Flight:AddSlider("SpeedSlider", {
    Title = "Flight Speed",
    Description = "Adjust how fast you fly",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        FlySpeed = value
        print("Flight Speed:", value)
    end
})

Tabs.Flight:AddButton({
    Title = "Reset Character",
    Callback = function()
        Character:BreakJoints()
        Main:Notify({
            Title = "Flight System",
            Content = "Character reset!",
            Duration = 2
        })
    end
})

Tabs.Flight:AddParagraph({
    Title = "Controls",
    Content = "WASD - Move\nSpace - Ascend\nShift - Descend"
})

-- Settings Tab
local InterfaceSection = Tabs.Settings:AddSection("Interface")

InterfaceSection:AddDropdown("InterfaceTheme", {
    Title = "Theme",
    Description = "Switches Fluent theme.",
    Values = Fluent.Themes,
    Default = Fluent.Theme,
    Callback = function(v)
        Fluent:SetTheme(v)
        Main:Notify({ Title = "Theme", Content = "Switched to " .. v, Duration = 2 })
    end
})

if Fluent.UseAcrylic then
    InterfaceSection:AddToggle("AcrylicToggle", {
        Title = "Acrylic Blur",
        Default = Fluent.Acrylic,
        Callback = function(v)
            Fluent:ToggleAcrylic(v)
        end
    })
end

InterfaceSection:AddToggle("TransparentToggle", {
    Title = "Transparency",
    Default = Fluent.Transparency,
    Callback = function(v)
        Fluent:ToggleTransparency(v)
    end
})

InterfaceSection:AddKeybind("MenuKeybind", {
    Title = "Minimize UI",
    Default = "RightShift"
})
Main.MinimizeKeybind = Main.Options.MenuKeybind

-- Save Manager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

SaveManager:LoadAutoloadConfig()

Main:Notify({
    Title = "Flight Control",
    Content = "Flight system loaded successfully!",
    Duration = 4
})

print("Flight Control GUI Loaded!")
