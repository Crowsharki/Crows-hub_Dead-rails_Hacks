-- Crows Hub - Speed & Jump GUI (Executor Friendly)
--i just updated the GUI not working, its working now with a close button, based on tbao hub, 
--added ESP and u can drag it now

-- Crows Hub - Noclip & Money Setter GUI (Executor Friendly)

-- Variables
local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local guiName = "CrowsHubUI"
local espTags = {}
local noclipActive = false
local humanoid = nil

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

-- Label
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

label("Crows Hub", 5)

-- Button Creator (Updated to use smaller height for buttons)
local function makeButton(name, xPos, yPos, height)
    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0, 120, 0, height)  -- Adjusted height
    button.Position = UDim2.new(0, xPos, 0, yPos)
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextScaled = true
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    return button
end

-- Tabs
local localButton = makeButton("Local", 30, 45, 30)  -- Adjusted height here
local espButton = makeButton("ESP", 160, 45, 30)   -- Adjusted height here

-- Local Group (Where all local functions reside)
local localGroup = Instance.new("Frame", frame)
localGroup.Size = UDim2.new(0, 640, 0, 200)  -- Same height
localGroup.Position = UDim2.new(0, 0, 0, 170)
localGroup.Visible = false
localGroup.BackgroundTransparency = 1

-- Noclip Button (Updated to use smaller height)
local noclipBtn = Instance.new("TextButton", localGroup)
noclipBtn.Size = UDim2.new(0, 580, 0, 40)  -- Adjusted height
noclipBtn.Position = UDim2.new(0, 30, 0, 0)  -- Move up a little
noclipBtn.Text = "Noclip: OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextScaled = true
Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0, 8)

-- Money Setter (Placed below the Noclip button)
local moneySetterGroup = Instance.new("Frame", localGroup)
moneySetterGroup.Size = UDim2.new(0, 640, 0, 120)  -- Adjusted height
moneySetterGroup.Position = UDim2.new(0, 0, 0, 50)  -- Placed below Noclip button
moneySetterGroup.BackgroundTransparency = 1

-- Money TextBox (for entering the amount)
local moneyTextBox = Instance.new("TextBox", moneySetterGroup)
moneyTextBox.Size = UDim2.new(0, 580, 0, 40)  -- Adjusted height
moneyTextBox.Position = UDim2.new(0, 30, 0, 0)
moneyTextBox.PlaceholderText = "Enter the amount"
moneyTextBox.Text = ""
moneyTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
moneyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
moneyTextBox.Font = Enum.Font.GothamBold
moneyTextBox.TextScaled = true
Instance.new("UICorner", moneyTextBox).CornerRadius = UDim.new(0, 8)

-- Set Money Button (Updated to use smaller height)
local setMoneyBtn = Instance.new("TextButton", moneySetterGroup)
setMoneyBtn.Size = UDim2.new(0, 580, 0, 40)  -- Adjusted height
setMoneyBtn.Position = UDim2.new(0, 30, 0, 50)
setMoneyBtn.Text = "Set Money"
setMoneyBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
setMoneyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
setMoneyBtn.Font = Enum.Font.GothamBold
setMoneyBtn.TextScaled = true
Instance.new("UICorner", setMoneyBtn).CornerRadius = UDim.new(0, 8)

-- Money Setter Logic (Setting Money)
setMoneyBtn.MouseButton1Click:Connect(function()
    local leaderstats = p:FindFirstChild("leaderstats")
    if leaderstats then
        local money = leaderstats:FindFirstChild("Money")
        if money then
            -- Attempt to convert the text input into a number
            local moneyAmount = tonumber(moneyTextBox.Text)
            if moneyAmount then
                money.Value = moneyAmount  -- Set money to the entered value
            else
                print("Invalid amount entered.")  -- If it's not a valid number, print a message
            end
        end
    end
end)

-- ESP Group
local espGroup = Instance.new("Frame", frame)
espGroup.Size = UDim2.new(0, 640, 0, 60)
espGroup.Position = UDim2.new(0, 0, 0, 170)
espGroup.Visible = false
espGroup.BackgroundTransparency = 1

-- ESP Buttons
local mobsESPBtn = makeButton("Mobs ESP", 30, 200, 30)  -- Adjusted height here
local itemsESPBtn = makeButton("Items ESP", 160, 200, 30)  -- Adjusted height here
local playersESPBtn = makeButton("Player ESP", 290, 200, 30)  -- Adjusted height here
mobsESPBtn.Visible, itemsESPBtn.Visible, playersESPBtn.Visible = false, false, false

-- ESP Logic
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

local function clearESP()
    for _, tag in ipairs(espTags) do
        if tag and tag.Parent then tag:Destroy() end
    end
    espTags = {}
end

-- ESP Button Logic
local isMobsESPActive, isItemsESPActive, isPlayersESPActive = false, false, false

mobsESPBtn.MouseButton1Click:Connect(function()
    isMobsESPActive = not isMobsESPActive
    clearESP()
    if isMobsESPActive then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Head") and not v:FindFirstChildOfClass("Humanoid") then
                createESP(v, v.Name)
            end
        end
        mobsESPBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        mobsESPBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

itemsESPBtn.MouseButton1Click:Connect(function()
    isItemsESPActive = not isItemsESPActive
    clearESP()
    if isItemsESPActive then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Handle") then
                createESP(v, v.Name)
            end
        end
        itemsESPBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        itemsESPBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

playersESPBtn.MouseButton1Click:Connect(function()
    isPlayersESPActive = not isPlayersESPActive
    clearESP()
    if isPlayersESPActive then
        for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Head") then
                createESP(v.Character, v.Name)
            end
        end
        playersESPBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        playersESPBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- Noclip Logic
local function toggleNoclip(state)
    noclipActive = state
    noclipBtn.Text = "Noclip: " .. (state and "ON" or "OFF")
    noclipBtn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end

rs.Stepped:Connect(function()
    if noclipActive and p.Character then
        for _, part in pairs(p.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Auto-disable noclip when jumping
rs.RenderStepped:Connect(function()
    if noclipActive and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if hum:GetState() == Enum.HumanoidStateType.Jumping then
            toggleNoclip(false)
        end
    end
end)

noclipBtn.MouseButton1Click:Connect(function()
    toggleNoclip(not noclipActive)
end)

-- Tab Buttons
localButton.MouseButton1Click:Connect(function()
    espGroup.Visible = false
    mobsESPBtn.Visible = false
    itemsESPBtn.Visible = false
    playersESPBtn.Visible = false
    localGroup.Visible = not localGroup.Visible
end)

espButton.MouseButton1Click:Connect(function()
    localGroup.Visible = false
    local show = not espGroup.Visible
    espGroup.Visible = show
    mobsESPBtn.Visible = show
    itemsESPBtn.Visible = show
    playersESPBtn.Visible = show
end)

-- Close Button
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 60, 0, 60)
close.Position = UDim2.new(1, -70, 0, 5)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 80, 80)
close.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
close.Font = Enum.Font.GothamBold
close.TextScaled = true
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
