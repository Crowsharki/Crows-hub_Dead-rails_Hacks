-- Crows Hub - Speed & Jump GUI (Executor Friendly)
--i just updated the GUI not working, its working now with a close button, based on tbao hub, 
--added ESP and u can drag it now

-- Variables
local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local guiName = "CrowsHubUI"
local espTags = {}

-- Destroy any existing GUI
local existing = p:FindFirstChild("PlayerGui"):FindFirstChild(guiName)
if existing then existing:Destroy() end

-- Create the GUI
local gui = Instance.new("ScreenGui")
gui.Name = guiName
gui.ResetOnSpawn = false
gui.Parent = p:WaitForChild("PlayerGui")

-- Create the frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 640, 0, 480)
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

label("Crows Hub", 5) -- Hub Name

-- Create buttons
local function makeButton(name, xPos, yPos)
    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0, 120, 0, 40)
    button.Position = UDim2.new(0, xPos, 0, yPos)
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextScaled = true
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    return button
end

-- Create the buttons
local localButton = makeButton("Local", 30, 45) -- Left button
local espButton = makeButton("ESP", 160, 45)   -- Right button

-- Local Group (Speed and Jump)
local localGroup = Instance.new("Frame", frame)
localGroup.Size = UDim2.new(0, 640, 0, 60)
localGroup.Position = UDim2.new(0, 0, 0, 170)
localGroup.Visible = false
localGroup.BackgroundTransparency = 1

local speedBox = Instance.new("TextBox", localGroup)
speedBox.Size = UDim2.new(0, 420, 0, 60)
speedBox.Position = UDim2.new(0, 30, 0, 0)
speedBox.PlaceholderText = "Enter Speed"
speedBox.Text = ""
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
speedBox.Font = Enum.Font.Gotham
speedBox.TextScaled = true
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

local toggleButton = Instance.new("TextButton", localGroup)
toggleButton.Size = UDim2.new(0, 120, 0, 60)
toggleButton.Position = UDim2.new(0, 460, 0, 0)
toggleButton.Text = "Inactive"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextScaled = true
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 8)

-- ESP Group (Mobs, Items, Players ESP)
local espGroup = Instance.new("Frame", frame)
espGroup.Size = UDim2.new(0, 640, 0, 60)
espGroup.Position = UDim2.new(0, 0, 0, 170)
espGroup.Visible = false
espGroup.BackgroundTransparency = 1

-- Mobs ESP Button
local mobsESPBtn = makeButton("Mobs ESP", 30, 200)
mobsESPBtn.Visible = false -- Initially hidden
-- Items ESP Button
local itemsESPBtn = makeButton("Items ESP", 160, 200)
itemsESPBtn.Visible = false -- Initially hidden
-- Player ESP Button
local playersESPBtn = makeButton("Player ESP", 290, 200)
playersESPBtn.Visible = false -- Initially hidden

-- Function to create ESP Tag
local function createESP(model, labelText)
    if not model:FindFirstChild("Head") then return end
    if model.Head:FindFirstChild("_ESPTag") then return end

    local tag = Instance.new("BillboardGui", model.Head)
    tag.Name = "_ESPTag"
    tag.AlwaysOnTop = true
    tag.Size = UDim2.new(0, 100, 0, 40)
    tag.StudsOffset = Vector3.new(0, 2, 0)

    local text = Instance.new("TextLabel", tag)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.new(1, 1, 1)
    text.Font = Enum.Font.GothamBold
    text.TextScaled = true
    text.Text = labelText

    table.insert(espTags, tag)
end

-- Mobs ESP Logic
local isMobsESPActive = false
mobsESPBtn.MouseButton1Click:Connect(function()
    isMobsESPActive = not isMobsESPActive
    if isMobsESPActive then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Head") and not v:FindFirstChildOfClass("Humanoid") then
                createESP(v, v.Name)
            end
        end
        mobsESPBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Change color to indicate active
    else
        for _, tag in ipairs(espTags) do
            if tag and tag.Parent then
                tag:Destroy()
            end
        end
        espTags = {}
        mobsESPBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Change color to indicate inactive
    end
end)

-- Items ESP Logic
local isItemsESPActive = false
itemsESPBtn.MouseButton1Click:Connect(function()
    isItemsESPActive = not isItemsESPActive
    if isItemsESPActive then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Handle") then
                createESP(v, v.Name)
            end
        end
        itemsESPBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Change color to indicate active
    else
        for _, tag in ipairs(espTags) do
            if tag and tag.Parent then
                tag:Destroy()
            end
        end
        espTags = {}
        itemsESPBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Change color to indicate inactive
    end
end)

-- Player ESP Logic
local isPlayersESPActive = false
playersESPBtn.MouseButton1Click:Connect(function()
    isPlayersESPActive = not isPlayersESPActive
    if isPlayersESPActive then
        for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Head") then
                createESP(v.Character, v.Name)
            end
        end
        playersESPBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Change color to indicate active
    else
        for _, tag in ipairs(espTags) do
            if tag and tag.Parent then
                tag:Destroy()
            end
        end
        espTags = {}
        playersESPBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Change color to indicate inactive
    end
end)

-- Toggle button logic for Speed
local moveSpeed = nil
local originalSpeed = 16

toggleButton.MouseButton1Click:Connect(function()
    if toggleButton.BackgroundColor3 == Color3.fromRGB(255, 0, 0) then
        local speedValue = tonumber(speedBox.Text)
        if speedValue and speedValue > 0 then
            moveSpeed = speedValue
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            toggleButton.Text = "Active"
        end
    else
        moveSpeed = originalSpeed
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        toggleButton.Text = "Inactive"
    end
end)

-- Movement loop (speed)
local enforceConnection
rs.RenderStepped:Connect(function()
    local char = p.Character
    if not char then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if hum and moveSpeed then
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
        hum.WalkSpeed = originalSpeed
    end
end)

-- Local Button click: Toggle Local Group visibility and hide ESP group if it’s visible
localButton.MouseButton1Click:Connect(function()
    -- Hide ESP group if visible
    if espGroup.Visible then
        espGroup.Visible = false
        mobsESPBtn.Visible = false
        itemsESPBtn.Visible = false
        playersESPBtn.Visible = false
    end
    localGroup.Visible = true  -- Show Local group
end)

-- ESP Button click: Toggle ESP Group visibility and show ESP Buttons
espButton.MouseButton1Click:Connect(function()
    espGroup.Visible = not espGroup.Visible  -- Toggle ESP group visibility
    mobsESPBtn.Visible = espGroup.Visible
    itemsESPBtn.Visible = espGroup.Visible
    playersESPBtn.Visible = espGroup.Visible
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
    gui:Destroy()  -- Destroy the GUI when the close button is clicked
end)
