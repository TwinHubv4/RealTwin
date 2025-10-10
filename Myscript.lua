local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 140)
frame.Position = UDim2.new(0.5, -90, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Text = "Twix Hub 🗹"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local function makeToggle(text, y)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 140, 0, 35)
    btn.Position = UDim2.new(0.5, -70, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.Text = text..": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14

    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = text..(on and ": ON" or ": OFF")
        btn.BackgroundColor3 = on and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
        print(text .. (on and " Enabled" or " Disabled"))
    end)
end

makeToggle("Freeze Trade", 40)
makeToggle("Auto Accept", 80)
