--[[ ⚡ Twix Hub (Middle Size Neon Cyber Glass Edition)
     Visual redesign with glowing teal edges, glass transparency,
     and animated gradient background.
     Includes Freeze Trade & Auto Accept toggles.
--]]

-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- // ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TwixHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- // Main Frame (Middle Size)
local Main = Instance.new("Frame")
Main.Name = "TwixHubMain"
Main.Size = UDim2.new(0, 300, 0, 180)
Main.Position = UDim2.new(0.35, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 25, 40)
Main.BackgroundTransparency = 0.35
Main.Active = true
Main.Draggable = true
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

-- Rounded edges
local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 14)

-- // Animated Gradient Background
local Gradient = Instance.new("UIGradient", Main)
Gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 220)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
}
Gradient.Rotation = 0

task.spawn(function()
	while task.wait(0.05) do
		Gradient.Rotation = (Gradient.Rotation + 1) % 360
	end
end)

-- // Glow Border
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 220)
Stroke.Thickness = 1.8
Stroke.Transparency = 0.3

-- // Subtle Glow Shadow
local Glow = Instance.new("ImageLabel", Main)
Glow.Size = UDim2.new(1, 40, 1, 40)
Glow.Position = UDim2.new(0, -20, 0, -20)
Glow.Image = "rbxassetid://1316045217"
Glow.ImageColor3 = Color3.fromRGB(0, 255, 220)
Glow.ImageTransparency = 0.85
Glow.BackgroundTransparency = 1
Glow.ZIndex = 0

-- // Title Bar
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 36)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ Twix Hub ⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 220)
Title.TextSize = 20
Title.TextStrokeTransparency = 0.85

local TitleLine = Instance.new("Frame", Main)
TitleLine.Size = UDim2.new(0.9, 0, 0, 1)
TitleLine.Position = UDim2.new(0.05, 0, 0, 36)
TitleLine.BackgroundColor3 = Color3.fromRGB(0, 255, 220)
TitleLine.BackgroundTransparency = 0.6

-- // Status Label
local Status = Instance.new("TextLabel", Main)
Status.Position = UDim2.new(0.08, 0, 0.28, 0)
Status.Size = UDim2.new(0.9, 0, 0, 22)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.Text = "Status: Not in trade"
Status.TextColor3 = Color3.fromRGB(0, 255, 220) -- neon teal
Status.TextSize = 15
Status.TextXAlignment = Enum.TextXAlignment.Left

-- // Toggle Creation Function
local function CreateToggle(labelText, posY)
	local Label = Instance.new("TextLabel", Main)
	Label.Position = UDim2.new(0.08, 0, posY, 0)
	Label.Size = UDim2.new(0, 140, 0, 26)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Gotham
	Label.Text = labelText
	Label.TextColor3 = Color3.fromRGB(210, 210, 210)
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left

	local Button = Instance.new("TextButton", Main)
	Button.Position = UDim2.new(0.7, 0, posY, 0)
	Button.Size = UDim2.new(0, 70, 0, 26)
	Button.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	Button.Font = Enum.Font.GothamBold
	Button.Text = "OFF"
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.TextSize = 14
	Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 12)

	-- Hover effect
	Button.MouseEnter:Connect(function()
		Button:TweenSize(UDim2.new(0, 74, 0, 28), "Out", "Quad", 0.15, true)
	end)
	Button.MouseLeave:Connect(function()
		Button:TweenSize(UDim2.new(0, 70, 0, 26), "Out", "Quad", 0.15, true)
	end)

	local Enabled = false
	Button.MouseButton1Click:Connect(function()
		Enabled = not Enabled
		if Enabled then
			Button.Text = "ON"
			Button.BackgroundColor3 = Color3.fromRGB(0, 255, 220)
		else
			Button.Text = "OFF"
			Button.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
		end
	end)
end

-- // Create Toggles
CreateToggle("Freeze Trade:", 0.50)
CreateToggle("Auto Accept:", 0.70)

-- // Trade Detection Function
local function checkTradeStatus()
	local mainGui = PlayerGui:FindFirstChild("Main")
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

	local localName = string.lower(LocalPlayer.Name)
	local localDisplay = string.lower(LocalPlayer.DisplayName)
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

-- // Live Status Update
RunService.Heartbeat:Connect(function()
	local inTrade, victim = checkTradeStatus()
	if inTrade then
		Status.Text = "Victim: " .. victim
		Status.TextColor3 = Color3.fromRGB(0, 255, 220) -- neon teal
	else
		Status.Text = "Status: Not in trade"
		Status.TextColor3 = Color3.fromRGB(0, 255, 220)
	end
end)
