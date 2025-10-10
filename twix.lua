-- Twix Hub 🗹  |  Safe Roblox UI Script
-- Theme: Dark Blue

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TwixHubUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 160)
mainFrame.Position = UDim2.new(0.5, -140, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 40) -- deep dark blue
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

-- Dark blue gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 30, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 10, 20))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Title (changed to Twix Hub 🗹)
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Twix Hub 🗹"
titleLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
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
