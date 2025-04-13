local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Get the PlayerBonds value from ReplicatedStorage
local playerBonds = replicatedStorage:WaitForChild("PlayerBonds")

-- Create the UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "Crows UI"  -- Set UI name

-- UI Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)  -- Dark background color
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0

-- Add UICorner for rounded corners to the Frame
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 10)

-- Title Label (Optional)
local titleLabel = Instance.new("TextLabel", frame)
titleLabel.Size = UDim2.new(0, 280, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.Text = "Speed & Jump Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.TextScaled = true
titleLabel.TextStrokeTransparency = 0.8

-- Speed Input (TextBox)
local speedInput = Instance.new("TextBox", frame)
speedInput.Size = UDim2.new(0, 150, 0, 40)
speedInput.Position = UDim2.new(0, 10, 0, 60)
speedInput.PlaceholderText = "Set Speed"
speedInput.Text = ""
speedInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedInput.BackgroundTransparency = 0.3
speedInput.BorderSizePixel = 0

-- Add UICorner to speed input for rounded corners
local speedInputCorner = Instance.new("UICorner", speedInput)
speedInputCorner.CornerRadius = UDim.new(0, 10)

-- Bonds (Currency) Input (TextBox)
local bondInput = Instance.new("TextBox", frame)
bondInput.Size = UDim2.new(0, 150, 0, 40)
bondInput.Position = UDim2.new(0, 10, 0, 110)
bondInput.PlaceholderText = "Set Bonds"
bondInput.Text = ""
bondInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bondInput.BackgroundTransparency = 0.3
bondInput.BorderSizePixel = 0

-- Add UICorner to bond input for rounded corners
local bondInputCorner = Instance.new("UICorner", bondInput)
bondInputCorner.CornerRadius = UDim.new(0, 10)

-- Apply Button
local applyButton = Instance.new("TextButton", frame)
applyButton.Size = UDim2.new(0, 280, 0, 40)
applyButton.Position = UDim2.new(0, 10, 0, 160)
applyButton.Text = "Apply"
applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 127)  -- Green background
applyButton.BackgroundTransparency = 0.2
applyButton.BorderSizePixel = 0

-- Add UICorner to apply button for rounded corners
local applyButtonCorner = Instance.new("UICorner", applyButton)
applyButtonCorner.CornerRadius = UDim.new(0, 10)

-- Speed logic using BodyVelocity
local speed = 0
local bodyVel = nil

applyButton.MouseButton1Click:Connect(function()
    -- Handle invalid input gracefully
    speed = tonumber(speedInput.Text)
    local bond = tonumber(bondInput.Text)
    
    -- Validate speed input
    if not speed or speed <= 0 then
        warn("Invalid speed input!")
        speedInput.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Change text color to red if invalid
        return
    end
    
    -- Validate bond input
    if not bond or bond <= 0 then
        warn("Invalid bond input!")
        bondInput.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Change text color to red if invalid
        return
    end
    
    -- Reset text color on valid input
    speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    bondInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    -- Update bonds in ReplicatedStorage
    playerBonds.Value = bond  -- Update the bond currency in ReplicatedStorage
    
    -- Apply jump power changes
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if humanoid then
        humanoid.JumpPower = bond  -- Set the jump power to bond value (for this case, assuming bond also sets JumpPower)
    end

    if speed and hrp then
        -- Only create BodyVelocity if it doesn't exist already
        if not bodyVel then
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.MaxForce = Vector3.new(1, 0, 1) * math.huge
            bodyVel.P = 1250
            bodyVel.Parent = hrp
        end
    end
end)

-- Cleanup the BodyVelocity on character reset or when removed
player.CharacterAdded:Connect(function()
    if bodyVel then
        bodyVel:Destroy()
        bodyVel = nil
    end
end)

RunService.RenderStepped:Connect(function()
    if bodyVel and speed and player.Character then
        local moveDir = player.Character.Humanoid.MoveDirection
        bodyVel.Velocity = moveDir * speed
    end
end)
