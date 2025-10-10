-- // Twix Hub 🗹 // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(15, 25, 60)
Main.Position = UDim2.new(0.35, 0, 0.25, 0)
Main.Size = UDim2.new(0, 220, 0, 140)
Main.Active = true
Main.Draggable = true
Main.Name = "TwixHubMain"
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Gradient = Instance.new("UIGradient", Main)
Gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 45, 90)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 20, 40))
}
Gradient.Rotation = 90

local Title = Instance.new("TextLabel", Main)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 28)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ Twix Hub 🗹 ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17
Title.TextStrokeTransparency = 0.8

local Status = Instance.new("TextLabel", Main)
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0.06, 0, 0.25, 0)
Status.Size = UDim2.new(0, 200, 0, 20)
Status.Font = Enum.Font.Gotham
Status.Text = "Status: Not in trade"
Status.TextColor3 = Color3.fromRGB(210, 210, 210)
Status.TextSize = 14
Status.TextXAlignment = Enum.TextXAlignment.Left

-- Freeze Label & Button
local FreezeLabel = Instance.new("TextLabel", Main)
FreezeLabel.BackgroundTransparency = 1
FreezeLabel.Position = UDim2.new(0.06, 0, 0.45, 0)
FreezeLabel.Size = UDim2.new(0, 100, 0, 20)
FreezeLabel.Font = Enum.Font.Gotham
FreezeLabel.Text = "Freeze Trade:"
FreezeLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
FreezeLabel.TextSize = 14
FreezeLabel.TextXAlignment = Enum.TextXAlignment.Left

local FreezeButton = Instance.new("TextButton", Main)
FreezeButton.BackgroundColor3 = Color3.fromRGB(80, 40, 50)
FreezeButton.Position = UDim2.new(0.65, 0, 0.45, 0)
FreezeButton.Size = UDim2.new(0, 60, 0, 22)
FreezeButton.Font = Enum.Font.GothamBold
FreezeButton.Text = "OFF"
FreezeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FreezeButton.TextSize = 13
Instance.new("UICorner", FreezeButton)

-- Auto Accept Label & Button
local AutoLabel = Instance.new("TextLabel", Main)
AutoLabel.BackgroundTransparency = 1
AutoLabel.Position = UDim2.new(0.06, 0, 0.65, 0)
AutoLabel.Size = UDim2.new(0, 100, 0, 20)
AutoLabel.Font = Enum.Font.Gotham
AutoLabel.Text = "Auto Accept:"
AutoLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
AutoLabel.TextSize = 14
AutoLabel.TextXAlignment = Enum.TextXAlignment.Left

local AutoButton = Instance.new("TextButton", Main)
AutoButton.BackgroundColor3 = Color3.fromRGB(80, 40, 50)
AutoButton.Position = UDim2.new(0.65, 0, 0.65, 0)
AutoButton.Size = UDim2.new(0, 60, 0, 22)
AutoButton.Font = Enum.Font.GothamBold
AutoButton.Text = "OFF"
AutoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoButton.TextSize = 13
Instance.new("UICorner", AutoButton)

-- State
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

--== Reused Function from Your Working Script ==--
function checkTradeStatus()
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

	local localPlayerName = string.lower(localPlayer.Name)
	local localPlayerDisplay = string.lower(localPlayer.DisplayName)
	local player1Name = string.lower(player1Label.Text)
	local player2Name = string.lower(player2Label.Text)

	local tradingPartnerName
	if player1Name == localPlayerName or player1Name == localPlayerDisplay then
		tradingPartnerName = player2Label.Text
	elseif player2Name == localPlayerName or player2Name == localPlayerDisplay then
		tradingPartnerName = player1Label.Text
	else
		return false, ""
	end
	
	return true, tradingPartnerName
end

--== Live Status Update ==--
RunService.Heartbeat:Connect(function()
	local inTrade, victim = checkTradeStatus()
	if inTrade then
		Status.Text = "Victim: " .. victim
	else
		Status.Text = "Status: Not in trade"
	end
end)
