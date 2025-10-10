-- // Twix Hub 🗹 // --
-- Clean dark-blue UI with gradient --

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Status = Instance.new("TextLabel")
local FreezeLabel = Instance.new("TextLabel")
local AutoLabel = Instance.new("TextLabel")
local FreezeButton = Instance.new("TextButton")
local AutoButton = Instance.new("TextButton")
local Gradient = Instance.new("UIGradient")

-- // Parent
ScreenGui.Parent = game.CoreGui

-- // Main Frame
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(15, 25, 60)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.35, 0, 0.25, 0)
Main.Size = UDim2.new(0, 220, 0, 140)
Main.BackgroundTransparency = 0.05
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Name = "TwixHubMain"

-- Rounded corners
local corner = Instance.new("UICorner", Main)
corner.CornerRadius = UDim.new(0, 12)

-- Gradient background
Gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 45, 90)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 20, 40))
}
Gradient.Rotation = 90
Gradient.Parent = Main

-- // Title
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 28)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ Twix Hub 🗹 ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17
Title.TextStrokeTransparency = 0.8

-- // Status
Status.Parent = Main
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0.06, 0, 0.25, 0)
Status.Size = UDim2.new(0, 200, 0, 20)
Status.Font = Enum.Font.Gotham
Status.Text = "Status: Not in trade"
Status.TextColor3 = Color3.fromRGB(210, 210, 210)
Status.TextSize = 14
Status.TextXAlignment = Enum.TextXAlignment.Left

-- // Freeze Label
FreezeLabel.Parent = Main
FreezeLabel.BackgroundTransparency = 1
FreezeLabel.Position = UDim2.new(0.06, 0, 0.45, 0)
FreezeLabel.Size = UDim2.new(0, 100, 0, 20)
FreezeLabel.Font = Enum.Font.Gotham
FreezeLabel.Text = "Freeze Trade:"
FreezeLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
FreezeLabel.TextSize = 14
FreezeLabel.TextXAlignment = Enum.TextXAlignment.Left

-- // Freeze Button
FreezeButton.Parent = Main
FreezeButton.BackgroundColor3 = Color3.fromRGB(80, 40, 50)
FreezeButton.Position = UDim2.new(0.65, 0, 0.45, 0)
FreezeButton.Size = UDim2.new(0, 60, 0, 22)
FreezeButton.Font = Enum.Font.GothamBold
FreezeButton.Text = "OFF"
FreezeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FreezeButton.TextSize = 13
Instance.new("UICorner", FreezeButton)

-- // Auto Label
AutoLabel.Parent = Main
AutoLabel.BackgroundTransparency = 1
AutoLabel.Position = UDim2.new(0.06, 0, 0.65, 0)
AutoLabel.Size = UDim2.new(0, 100, 0, 20)
AutoLabel.Font = Enum.Font.Gotham
AutoLabel.Text = "Auto Accept:"
AutoLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
AutoLabel.TextSize = 14
AutoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- // Auto Button
AutoButton.Parent = Main
AutoButton.BackgroundColor3 = Color3.fromRGB(80, 40, 50)
AutoButton.Position = UDim2.new(0.65, 0, 0.65, 0)
AutoButton.Size = UDim2.new(0, 60, 0, 22)
AutoButton.Font = Enum.Font.GothamBold
AutoButton.Text = "OFF"
AutoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoButton.TextSize = 13
Instance.new("UICorner", AutoButton)

-- // Functionality
local freezeEnabled = false
local autoEnabled = false

FreezeButton.MouseButton1Click:Connect(function()
	freezeEnabled = not freezeEnabled
	if freezeEnabled then
		FreezeButton.Text = "ON"
		FreezeButton.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
	else
		FreezeButton.Text = "OFF"
		FreezeButton.BackgroundColor3 = Color3.fromRGB(80, 40, 50)
	end
end)

AutoButton.MouseButton1Click:Connect(function()
	autoEnabled = not autoEnabled
	if autoEnabled then
		AutoButton.Text = "ON"
		AutoButton.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
	else
		AutoButton.Text = "OFF"
		AutoButton.BackgroundColor3 = Color3.fromRGB(80, 40, 50)
	end
end)

-- // Victim Name Detection
task.spawn(function()
	local tradeGui = playerGui:WaitForChild("TradeUI", 10) -- ⚠️ Replace "TradeUI" if your trade GUI has a different name
	if not tradeGui then return end

	tradeGui:GetPropertyChangedSignal("Visible"):Connect(function()
		if tradeGui.Visible then
			local victimName = nil
			pcall(function()
				-- ⚠️ Replace this path with your actual GUI path to the victim's name label
				victimName = tradeGui.Frame.Right.PlayerName.Text
			end)

			if victimName and victimName ~= "" then
				Status.Text = "Victim: " .. victimName
			else
				Status.Text = "Status: In trade"
			end
		else
			Status.Text = "Status: Not in trade"
		end
	end)
end)
