local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TradeHelperUI"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 160)
mainFrame.Position = UDim2.new(0.5, -140, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 25, 60) -- dark blue base
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = false
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 6, 1, 6)
shadow.Position = UDim2.new(0, -3, 0, -3)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = mainFrame.ZIndex - 1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 15)
shadowCorner.Parent = shadow

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 45, 90)), -- top dark blue
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 20, 40))  -- bottom darker blue
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- 🔹 Title changed here
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Twix Hub 🗹"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Not in trade"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local function createToggle(name, position, enabled)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name .. "Toggle"
    toggleFrame.Size = UDim2.new(0, 240, 0, 35)
    toggleFrame.Position = position
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 50, 100) -- dark blue shade
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0, 140, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = enabled and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(200, 200, 220)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local switch = Instance.new("Frame")
    switch.Name = "Switch"
    switch.Size = UDim2.new(0, 60, 0, 22)
    switch.Position = UDim2.new(1, -70, 0.5, -11)
    switch.BackgroundColor3 = enabled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(50, 60, 90)
    switch.BorderSizePixel = 0
    switch.Parent = toggleFrame
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 11)
    switchCorner.Parent = switch
    
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switch
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 9)
    knobCorner.Parent = knob
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = toggleFrame
    
    return {
        frame = toggleFrame,
        switch = switch,
        knob = knob,
        label = label,
        button = button,
        enabled = enabled
    }
end

local freezeToggle = createToggle("Freeze Trade", UDim2.new(0, 20, 0, 65), false)
local forceToggle = createToggle("Force Accept", UDim2.new(0, 20, 0, 110), false)

local inTrade = false
local tradingPartner = ""
local tradeConnection

local function animateToggle(toggle, enabled)
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local switchTween = TweenService:Create(toggle.switch, tweenInfo, {
        BackgroundColor3 = enabled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(50, 60, 90)
    })
    
    local knobTween = TweenService:Create(toggle.knob, tweenInfo, {
        Position = enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    })
    
    local labelTween = TweenService:Create(toggle.label, tweenInfo, {
        TextColor3 = enabled and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(200, 200, 220)
    })
    
    switchTween:Play()
    knobTween:Play()
    labelTween:Play()
end

local function showNotification(text, color)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 200, 0, 40)
    notif.Position = UDim2.new(0.5, -100, 1, 10)
    notif.BackgroundColor3 = color or Color3.fromRGB(30, 50, 100)
    notif.BorderSizePixel = 0
    notif.Parent = mainFrame
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notif
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -10, 1, 0)
    notifText.Position = UDim2.new(0, 5, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextScaled = true
    notifText.Font = Enum.Font.Gotham
    notifText.Parent = notif
    
    local showTween = TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -100, 1, -50)})
    showTween:Play()
    
    wait(2)
    
    local hideTween = TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -100, 1, 10)})
    hideTween:Play()
    hideTween.Completed:Connect(function()
        notif:Destroy()
    end)
end

-- (Rest of your script stays identical)
