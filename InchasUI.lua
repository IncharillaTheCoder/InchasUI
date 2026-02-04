local UI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

UI.Themes = {
    default = {
        background = Color3.fromRGB(18, 18, 28),
        accent = Color3.fromRGB(0, 170, 255),
        text = Color3.fromRGB(255, 255, 255)
    },
    dark = {
        background = Color3.fromRGB(10, 10, 15),
        accent = Color3.fromRGB(0, 220, 100),
        text = Color3.fromRGB(240, 240, 240)
    },
    purple = {
        background = Color3.fromRGB(25, 15, 35),
        accent = Color3.fromRGB(180, 80, 255),
        text = Color3.fromRGB(255, 255, 255)
    },
    red = {
        background = Color3.fromRGB(28, 10, 10),
        accent = Color3.fromRGB(255, 60, 60),
        text = Color3.fromRGB(255, 255, 255)
    }
}

function UI.newWindow(titleText, subtitleText, config)
    local theme = UI.Themes[config.theme] or UI.Themes.default

    local gui = Instance.new("ScreenGui")
    gui.Name = "InchasLib"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = (gethui and gethui()) or CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(350, 420)
    frame.Position = config.position
    frame.BackgroundColor3 = theme.background
    frame.BackgroundTransparency = config.transparency
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = gui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(100, 100, 150)
    stroke.Thickness = 2.5
    stroke.Transparency = 0.15

    local titleBar = Instance.new("Frame", frame)
    titleBar.Size = UDim2.new(1, 0, 0, 48)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 2
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 16, 0, 0)

    local tg = Instance.new("UIGradient", titleBar)
    tg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.accent),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 170))
    })
    tg.Rotation = -15
    tg.Transparency = NumberSequence.new(0.2)

    local title = Instance.new("TextLabel", titleBar)
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left

    local subtitle = Instance.new("TextLabel", titleBar)
    subtitle.Size = UDim2.new(1, -100, 0, 16)
    subtitle.Position = UDim2.new(0, 20, 0, 30)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = subtitleText
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 220)
    subtitle.Font = Enum.Font.GothamMedium
    subtitle.TextSize = 12
    subtitle.TextXAlignment = Enum.TextXAlignment.Left

    local mBtn = Instance.new("TextButton", titleBar)
    mBtn.Size = UDim2.fromOffset(32, 32)
    mBtn.Position = UDim2.new(1, -80, 0.5, -16)
    mBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    mBtn.BackgroundTransparency = 0.2
    mBtn.Text = "−"
    mBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mBtn.Font = Enum.Font.GothamBold
    mBtn.TextSize = 24
    Instance.new("UICorner", mBtn).CornerRadius = UDim.new(1, 0)

    local mStr = Instance.new("UIStroke", mBtn)
    mStr.Color = Color3.fromRGB(120, 120, 180)
    mStr.Thickness = 1.5
    mStr.Transparency = 0.3

    local cBtn = Instance.new("TextButton", titleBar)
    cBtn.Size = UDim2.fromOffset(32, 32)
    cBtn.Position = UDim2.new(1, -40, 0.5, -16)
    cBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    cBtn.BackgroundTransparency = 0.2
    cBtn.Text = "×"
    cBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cBtn.Font = Enum.Font.GothamBold
    cBtn.TextSize = 22
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(1, 0)

    local cStr = Instance.new("UIStroke", cBtn)
    cStr.Color = Color3.fromRGB(255, 120, 120)
    cStr.Thickness = 1.5
    cStr.Transparency = 0.3

    local tabC = Instance.new("Frame", frame)
    tabC.Size = UDim2.new(1, 0, 0, 40)
    tabC.Position = UDim2.new(0, 0, 0, 48)
    tabC.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    tabC.BorderSizePixel = 0
    tabC.ZIndex = 2
    local tl = Instance.new("UIListLayout", tabC)
    tl.FillDirection = Enum.FillDirection.Horizontal

    local cont = Instance.new("Frame", frame)
    cont.Size = UDim2.new(1, 0, 1, -88)
    cont.Position = UDim2.new(0, 0, 0, 88)
    cont.BackgroundTransparency = 1
    cont.Parent = frame

    local dragging = false
    local dragStart = nil
    local sPos = nil

    titleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            sPos = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            frame.Position = UDim2.new(
                sPos.X.Scale,
                sPos.X.Offset + d.X,
                sPos.Y.Scale,
                sPos.Y.Offset + d.Y
            )
            config.position = frame.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local notifyCont = Instance.new("Frame", gui)
    notifyCont.Size = UDim2.new(0, 200, 1, 0)
    notifyCont.Position = UDim2.new(1, -210, 0, 0)
    notifyCont.BackgroundTransparency = 1
    local nl = Instance.new("UIListLayout", notifyCont)
    nl.Padding = UDim.new(0, 10)
    nl.VerticalAlignment = Enum.VerticalAlignment.Bottom
    nl.HorizontalAlignment = Enum.HorizontalAlignment.Right

    function UI.notify(text, duration)
        local n = Instance.new("Frame", notifyCont)
        n.Size = UDim2.new(0, 0, 0, 40)
        n.BackgroundColor3 = theme.background
        n.BorderSizePixel = 0
        n.ClipsDescendants = true
        Instance.new("UICorner", n).CornerRadius = UDim.new(0, 8)
        local ns = Instance.new("UIStroke", n)
        ns.Color = theme.accent
        ns.Thickness = 1.5

        local nt = Instance.new("TextLabel", n)
        nt.Size = UDim2.new(1, -20, 1, 0)
        nt.Position = UDim2.new(0, 10, 0, 0)
        nt.BackgroundTransparency = 1
        nt.Text = text
        nt.TextColor3 = theme.text
        nt.Font = Enum.Font.GothamBold
        nt.TextSize = 14
        nt.TextXAlignment = Enum.TextXAlignment.Center

        TweenService:Create(n, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(1, 0, 0, 40)}):Play()
        task.delay(duration or 3, function()
            TweenService:Create(n, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 0, 0, 40)}):Play()
            task.wait(0.4)
            n:Destroy()
        end)
    end

    return {
        gui = gui,
        frame = frame,
        cont = cont,
        tabC = tabC,
        mBtn = mBtn,
        cBtn = cBtn,
        theme = theme,
        notify = UI.notify
    }
end

function UI.addTab(window, name)
    local tabFrame = Instance.new("ScrollingFrame", window.cont)
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.Visible = false
    tabFrame.ScrollBarThickness = 4
    tabFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    local ul = Instance.new("UIListLayout", tabFrame)
    ul.Padding = UDim.new(0, 8)
    ul.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ul.SortOrder = Enum.SortOrder.LayoutOrder

    ul:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, ul.AbsoluteContentSize.Y + 10)
    end)

    local btn = Instance.new("TextButton", window.tabC)
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.BorderSizePixel = 0
    btn.Text = name:upper()
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(window.cont:GetChildren()) do
            if f:IsA("ScrollingFrame") then
                f.Visible = (f == tabFrame)
            end
        end
        for _, b in pairs(window.tabC:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundColor3 = (b == btn) and Color3.fromRGB(50, 50, 80) or Color3.fromRGB(40, 40, 60)
            end
        end
    end)

    return tabFrame, btn
end

function UI.addButton(tab, text, theme)
    local btn = Instance.new("TextButton", tab)
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local str = Instance.new("UIStroke", btn)
    str.Color = Color3.fromRGB(100, 100, 150)
    str.Thickness = 1.5
    str.Transparency = 0.3

    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(230, 230, 250)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local stt = Instance.new("Frame", btn)
    stt.Size = UDim2.fromOffset(8, 8)
    stt.Position = UDim2.new(1, -20, 0.5, -4)
    stt.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    stt.Visible = false
    Instance.new("UICorner", stt).CornerRadius = UDim.new(1, 0)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}):Play()
        TweenService:Create(str, TweenInfo.new(0.25), {Color = theme.accent, Transparency = 0.2}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
        TweenService:Create(str, TweenInfo.new(0.25), {Color = Color3.fromRGB(100, 100, 150), Transparency = 0.3}):Play()
    end)

    return btn, lbl, stt
end

function UI.addToggle(tab, text, theme, default, callback)
    local btn = Instance.new("TextButton", tab)
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local str = Instance.new("UIStroke", btn)
    str.Color = Color3.fromRGB(100, 100, 150)
    str.Thickness = 1.5
    str.Transparency = 0.3

    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(230, 230, 250)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local switchBase = Instance.new("Frame", btn)
    switchBase.Size = UDim2.new(0, 36, 0, 20)
    switchBase.Position = UDim2.new(1, -50, 0.5, -10)
    switchBase.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    Instance.new("UICorner", switchBase).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", switchBase)
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = UDim2.new(0, 2, 0.5, -8)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local enabled = default or false
    local function update()
        TweenService:Create(switchBase, TweenInfo.new(0.2), {BackgroundColor3 = enabled and theme.accent or Color3.fromRGB(50, 50, 70)}):Play()
        TweenService:Create(dot, TweenInfo.new(0.2), {Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
    end

    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        update()
        callback(enabled)
    end)

    update()
    return btn
end

function UI.addSlider(tab, text, theme, min, max, default, callback)
    local container = Instance.new("Frame", tab)
    container.Size = UDim2.new(1, -10, 0, 60)
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    container.BackgroundTransparency = 0.1
    container.BorderSizePixel = 0
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", container)
    lbl.Size = UDim2.new(1, -20, 0, 30)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(230, 230, 250)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valLbl = Instance.new("TextLabel", container)
    valLbl.Size = UDim2.new(0, 50, 0, 30)
    valLbl.Position = UDim2.new(1, -60, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(default)
    valLbl.TextColor3 = theme.accent
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 14
    valLbl.TextXAlignment = Enum.TextXAlignment.Right

    local bar = Instance.new("Frame", container)
    bar.Size = UDim2.new(1, -40, 0, 6)
    bar.Position = UDim2.new(0, 20, 0, 40)
    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = theme.accent
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", bar)
    knob.Size = UDim2.fromOffset(12, 12)
    knob.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function move(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        valLbl.Text = tostring(val)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        knob.Position = UDim2.new(pos, -6, 0.5, -6)
        callback(val)
    end

    knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then move(i) end end)

    return container
end

function UI.addKeybind(tab, name, config, callback, delCallback)
    local row = Instance.new("Frame", tab)
    row.Size = UDim2.new(1, -10, 0, 36)
    row.BackgroundTransparency = 1

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0.8, 0, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    btn.BorderSizePixel = 0
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextColor3 = Color3.fromRGB(230, 230, 250)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 10)

    local del = Instance.new("TextButton", row)
    del.Size = UDim2.new(0.18, 0, 0.7, 0)
    del.Position = UDim2.new(0.82, 0, 0.15, 0)
    del.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    del.Text = "x"
    del.TextColor3 = Color3.fromRGB(255, 255, 255)
    del.Font = Enum.Font.GothamBold
    del.TextSize = 16
    Instance.new("UICorner", del).CornerRadius = UDim.new(0, 4)

    local function refresh()
        local k = config.keybinds[name]
        btn.Text = k and (name .. " : " .. k) or (name .. " : UNBOUND")
        del.Visible = (k ~= nil)
    end

    del.MouseButton1Click:Connect(function() delCallback(name); refresh() end)
    btn.MouseButton1Click:Connect(function() btn.Text = name .. " : PRESS KEY..."; callback(name) end)
    refresh()
    return btn, del, refresh
end

return UI
