-- Twix Hub UI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TwixHub"
ScreenGui.Parent = game.CoreGui

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "TwixHubMain"
Main.Size = UDim2.new(0, 220, 0, 140)
Main.Position = UDim2.new(0.35, 0, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 25, 60)
Main.BackgroundTransparency = 0.05
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Gradient Background
local Gradient = Instance.new("UIGradient", Main)
Gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 45, 90)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 20, 40))
}
Gradient.Rotation = 90

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 28)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ Twix Hub 🗹 ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17
Title.TextStrokeTransparency = 0.8

-- Status Label
local Status = Instance.new("TextLabel", Main)
Status.Position = UDim2.new(0.06, 0, 0.25, 0)
Status.Size = UDim2.new(0, 200, 0, 20)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.Text = "Status: Not in trade"
Status.TextColor3 = Color3.fromRGB(210, 210, 210)
Status.TextSize = 14
Status.TextXAlignment = Enum.TextXAlignment.Left

-- Freeze Label
local FreezeLabel = Instance.new("TextLabel", Main)
FreezeLabel.Position = UDim2.new(0.06, 0, 0.45, 0)
FreezeLabel.Size = UDim2.new(0, 100, 0, 20)
FreezeLabel.BackgroundTransparency = 1
FreezeLabel.Font = Enum.Font.Gotham
FreezeLabel.Text = "Freeze Trade:"
FreezeLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
FreezeLabel.TextSize = 14
FreezeLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Freeze Button
local FreezeButton = Instance.new("TextButton", Main)
FreezeButton.Position = UDim2.new(0.65, 0, 0.45, 0)
FreezeButton.Size = UDim2.new(0, 60, 0, 22)
FreezeButton.BackgroundColor3 = Color3.fromRGB(80, 40, 50)
FreezeButton.Font = Enum.Font.GothamBold
FreezeButton.Text = "OFF"
FreezeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FreezeButton.TextSize = 13
FreezeButton.Parent = Main
Instance.new("UICorner", FreezeButton)

-- Auto Label
local AutoLabel = Instance.new("TextLabel", Main)
AutoLabel.Position = UDim2.new(0.06, 0, 0.65, 0)
AutoLabel.Size = UDim2.new(0, 100, 0, 20)
AutoLabel.BackgroundTransparency = 1
AutoLabel.Font = Enum.Font.Gotham
AutoLabel.Text = "Auto Accept:"
AutoLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
AutoLabel.TextSize = 14
AutoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Auto Button
local AutoButton = Instance.new("TextButton", Main)
AutoButton.Position = UDim2.new(0.65, 0, 0.65, 0)
AutoButton.Size = UDim2.new(0, 60, 0, 22)
AutoButton.BackgroundColor3 = Color3.fromRGB(80, 40, 50)
AutoButton.Font = Enum.Font.GothamBold
AutoButton.Text = "OFF"
AutoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoButton.TextSize = 13
AutoButton.Parent = Main
Instance.new("UICorner", AutoButton)

-- States
local freezeEnabled = false
local autoEnabled = false

-- Button Logic
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

-- Trade Detection Function
local function checkTradeStatus()
	local mainGui = playerGui:FindFirstChild("Main")
	if not mainGui then return false, "" end
	
	local tradeFrame = mainGui:FindFirstChild("Trade")
	if not tradeFrame or not tradeFrame.Visible then return false, "" end

	local container = tradeFrame:FindFirstChild("Container")
	if not container then return false, "" end

	local frame1 = container:FindFirstChild("1")
	local frame2 = container:FindFirstChild("2")
	if not frame1 or not frame2 then return false, "" end

	local player1Label = frame1:FindFirstChild("TextLabel")
	local player2Label = frame2:FindFirstChild("TextLabel")
	if not player1Label or not player2Label then return false, "" end

	local localName = string.lower(localPlayer.Name)
	local localDisplay = string.lower(localPlayer.DisplayName)
	local p1Name = string.lower(player1Label.Text)
	local p2Name = string.lower(player2Label.Text)

	local victim = ""
	if p1Name == localName or p1Name == localDisplay then
		victim = player2Label.Text
	elseif p2Name == localName or p2Name == localDisplay then
		victim = player1Label.Text
	else
		return false, ""
	end

	return true, victim
end

-- Live Status Update
RunService.Heartbeat:Connect(function()
	local inTrade, victim = checkTradeStatus()
	if inTrade then
		Status.Text = "Victim: " .. victim
		Status.TextColor3 = Color3.fromRGB(255, 120, 120) -- Light red
	else
		Status.Text = "Status: Not in trade"
		Status.TextColor3 = Color3.fromRGB(210, 210, 210) -- Default gray
	end
end)
