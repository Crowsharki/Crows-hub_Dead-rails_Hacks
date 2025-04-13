-- Crows Hub - Speed & Jump GUI (Executor Friendly)
--i just updated the GUI not working, its working now with a close button

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

-- Destroy old GUI if it exists
local guiName = "CrowsHubUI"
local existing = player:FindFirstChild("PlayerGui"):FindFirstChild(guiName)
if existing then existing:Destroy() end

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = guiName
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 340, 0, 240)
frame.Position = UDim2.new(0.5, -170, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "🪶 Crows Hub"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 80, 80)
close.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
close.Font = Enum.Font.GothamBold
close.TextScaled = true
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

-- Speed Input
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 140, 0, 40)
speedBox.Position = UDim2.new(0, 20, 0, 60)
speedBox.PlaceholderText = "Enter Speed"
speedBox.Text = ""
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
speedBox.Font = Enum.Font.Gotham
speedBox.TextScaled = true
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

-- Jump Power Input
local jumpBox = Instance.new("TextBox", frame)
jumpBox.Size = UDim2.new(0, 140, 0, 40)
jumpBox.Position = UDim2.new(0, 20, 0, 120)
jumpBox.PlaceholderText = "Enter Jump Power"
jumpBox.Text = ""
jumpBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpBox.TextColor3 = Color3.new(1, 1, 1)
jumpBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
jumpBox.Font = Enum.Font.Gotham
jumpBox.TextScaled = true
Instance.new("UICorner", jumpBox).CornerRadius = UDim.new(0, 8)

-- Apply Button
local apply = Instance.new("TextButton", frame)
apply.Size = UDim2.new(0, 280, 0, 40)
apply.Position = UDim2.new(0, 30, 0, 180)
apply.Text = "✅ Apply Settings"
apply.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
apply.TextColor3 = Color3.new(1, 1, 1)
apply.Font = Enum.Font.GothamBold
apply.TextScaled = true
Instance.new("UICorner", apply).CornerRadius = UDim.new(0, 10)

-- Vars
local desiredSpeed = nil
local desiredJump = nil
local enforceConnection = nil

-- Apply logic
apply.MouseButton1Click:Connect(function()
	local spd = tonumber(speedBox.Text)
	local jmp = tonumber(jumpBox.Text)

	if spd and spd > 0 then desiredSpeed = spd end
	if jmp and jmp > 0 then desiredJump = jmp end
end)

-- Enforce loop to prevent resets
if enforceConnection then enforceConnection:Disconnect() end
enforceConnection = RunService.RenderStepped:Connect(function()
	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			if desiredSpeed then hum.WalkSpeed = desiredSpeed end
			if desiredJump then hum.JumpPower = desiredJump end
		end
	end
end)

-- Reapply on respawn
player.CharacterAdded:Connect(function(char)
	wait(1)
	local hum = char:WaitForChild("Humanoid")
	if desiredSpeed then hum.WalkSpeed = desiredSpeed end
	if desiredJump then hum.JumpPower = desiredJump end
end)

-- Close the hub
close.MouseButton1Click:Connect(function()
	if enforceConnection then enforceConnection:Disconnect() end
	gui:Destroy()
end)
