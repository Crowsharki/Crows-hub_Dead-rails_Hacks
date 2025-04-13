-- Crows Hub - Speed & Jump GUI (Executor Friendly)
--i just updated the GUI not working, its working now with a close button, based on tbao gui

local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local guiName = "CrowsHubUI"
local existing = p:FindFirstChild("PlayerGui"):FindFirstChild(guiName)
if existing then existing:Destroy() end

-- Create the GUI and set it up correctly
local gui = Instance.new("ScreenGui")
gui.Name = guiName
gui.ResetOnSpawn = false
gui.Parent = p:WaitForChild("PlayerGui")

-- Create the frame (smaller size)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 640, 0, 480)  -- Smaller size for the GUI
frame.Position = UDim2.new(0.5, -320, 0.5, -240)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Function for label creation
local function label(txt, posY)
    local l = Instance.new("TextLabel", frame)
    l.Size = UDim2.new(1, -50, 0, 40)
    l.Position = UDim2.new(0, 10, 0, posY)
    l.Text = txt
    l.TextScaled = true
    l.TextColor3 = Color3.new(1, 1, 1)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

-- Title of the GUI
label("Crows Hub", 5)

-- Local Button (left of title)
local localButton = Instance.new("TextButton", frame)
localButton.Size = UDim2.new(0, 120, 0, 40)
localButton.Position = UDim2.new(0, 30, 0, 45)  -- Position below title, left
localButton.Text = "Local"
localButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
localButton.TextColor3 = Color3.fromRGB(255, 255, 255)
localButton.Font = Enum.Font.GothamBold
localButton.TextScaled = true
Instance.new("UICorner", localButton).CornerRadius = UDim.new(0, 8)

-- ESP Button (next to Local button)
local espButton = Instance.new("TextButton", frame)
espButton.Size = UDim2.new(0, 120, 0, 40)
espButton.Position = UDim2.new(0, 160, 0, 45)  -- Position next to Local
espButton.Text = "ESP"
espButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.GothamBold
espButton.TextScaled = true
Instance.new("UICorner", espButton).CornerRadius = UDim.new(0, 8)

-- Local Group (Speed Button and other elements)
local localGroup = Instance.new("Frame", frame)
localGroup.Size = UDim2.new(0, 640, 0, 60)  -- Adjusted for the speed section
localGroup.Position = UDim2.new(0, 0, 0, 170)  -- Position below Local and ESP buttons
localGroup.Visible = false  -- Initially hidden
localGroup.BackgroundTransparency = 1  -- Remove any unwanted background color

local speedBox = Instance.new("TextBox", localGroup)
speedBox.Size = UDim2.new(0, 420, 0, 60)
speedBox.Position = UDim2.new(0, 30, 0, 0)
speedBox.PlaceholderText = "Enter Speed"
speedBox.Text = ""
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)  -- Dark gray background for the input box
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
speedBox.Font = Enum.Font.Gotham
speedBox.TextScaled = true
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

speedBox.BackgroundTransparency = 0.2  -- Make the background a bit transparent (adjust as needed)
speedBox.BorderSizePixel = 0  -- Remove the border

local toggleButton = Instance.new("TextButton", localGroup)
toggleButton.Size = UDim2.new(0, 120, 0, 60)
toggleButton.Position = UDim2.new(0, 460, 0, 0)
toggleButton.Text = "Inactive"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Red initially (inactive)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextScaled = true
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 8)

-- ESP Group (just a placeholder for the ESP section)
local espGroup = Instance.new("Frame", frame)
espGroup.Size = UDim2.new(0, 640, 0, 60)  -- Placeholder size for ESP group
espGroup.Position = UDim2.new(0, 0, 0, 170)  -- Position below Local and ESP buttons
espGroup.Visible = false  -- Initially hidden
espGroup.BackgroundTransparency = 1  -- Make the background of the ESP group transparent

-- Toggle button logic for Speed
local moveSpeed = nil
local originalSpeed = 16  -- Default walk speed of Roblox characters

toggleButton.MouseButton1Click:Connect(function()
    if toggleButton.BackgroundColor3 == Color3.fromRGB(255, 0, 0) then
        -- If the button is red (inactive), apply the new speed
        local speedValue = tonumber(speedBox.Text)
        if speedValue and speedValue > 0 then
            moveSpeed = speedValue
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Turn green
            toggleButton.Text = "Active"
        end
    else
        -- If the button is green (active), reset to original speed
        moveSpeed = originalSpeed
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Turn red
        toggleButton.Text = "Inactive"
    end
end)

-- Movement loop (speed)
local enforceConnection
rs.RenderStepped:Connect(function()
    local char = p.Character
    if not char then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if moveSpeed then
        hum.WalkSpeed = moveSpeed
    end
end)

-- Respawn handler
p.CharacterAdded:Connect(function(char)
    wait(1)
    local hum = char:WaitForChild("Humanoid")
    if moveSpeed then
        hum.WalkSpeed = moveSpeed
    else
        hum.WalkSpeed = originalSpeed  -- Reset to original speed if no custom speed is set
    end
end)

-- Local Button click: Toggle Local Group visibility
localButton.MouseButton1Click:Connect(function()
    if localGroup.Visible then
        localGroup.Visible = false  -- If it's visible, hide it
    else
        localGroup.Visible = true   -- If it's hidden, show it
        espGroup.Visible = false    -- Hide the ESP group if Local is visible
    end
end)

-- ESP Button click: Toggle ESP Group visibility
espButton.MouseButton1Click:Connect(function()
    if espGroup.Visible then
        espGroup.Visible = false  -- If it's visible, hide it
    else
        espGroup.Visible = true   -- If it's hidden, show it
        localGroup.Visible = false  -- Hide the Local group if ESP is visible
    end
end)

-- Close button logic
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 60, 0, 60)
close.Position = UDim2.new(1, -70, 0, 5)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 80, 80)
close.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
close.Font = Enum.Font.GothamBold
close.TextScaled = true
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

-- Close button logic
close.MouseButton1Click:Connect(function()
    gui:Destroy()  -- Completely destroy the GUI
end)
