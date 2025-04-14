-- Crows Hub - Speed & Jump GUI (Executor Friendly)
--i just updated the GUI not working, its working now with a close button, based on tbao hub, 
--added ESP and u can drag it now

-- Existing Script for Crows Hub

-- Variables and GUI setup (this part remains the same as in the original script)

local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local guiName = "CrowsHubUI"
local espTags = {}
local noclipActive = false
local fullbrightActive = false
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

-- Button Creator
local function makeButton(name, xPos, yPos, height)
    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0, 120, 0, height)  
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
local localButton = makeButton("Local", 30, 45, 30) 
local espButton = makeButton("ESP", 160, 45, 30)   

-- Local Group (Where all local functions reside)
local localGroup = Instance.new("Frame", frame)
localGroup.Size = UDim2.new(0, 640, 0, 200) 
localGroup.Position = UDim2.new(0, 0, 0, 170)
localGroup.Visible = true
localGroup.BackgroundTransparency = 1

-- Noclip Button
local noclipBtn = Instance.new("TextButton", localGroup)
noclipBtn.Size = UDim2.new(0, 580, 0, 40)  
noclipBtn.Position = UDim2.new(0, 30, 0, 0)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextScaled = true
Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0, 8)

-- Fullbright Button
local fullbrightBtn = Instance.new("TextButton", localGroup)
fullbrightBtn.Size = UDim2.new(0, 580, 0, 40)
fullbrightBtn.Position = UDim2.new(0, 30, 0, 50)
fullbrightBtn.Text = "Fullbright: OFF"
fullbrightBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
fullbrightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fullbrightBtn.Font = Enum.Font.GothamBold
fullbrightBtn.TextScaled = true
Instance.new("UICorner", fullbrightBtn).CornerRadius = UDim.new(0, 8)

-- ESP Group
local espGroup = Instance.new("Frame", frame)
espGroup.Size = UDim2.new(0, 640, 0, 200)
espGroup.Position = UDim2.new(0, 0, 0, 170)
espGroup.Visible = false
espGroup.BackgroundTransparency = 1

-- ESP Buttons
local mobsESPBtn = makeButton("Mobs ESP", 30, 200, 30)  
local itemsESPBtn = makeButton("Items ESP", 160, 200, 30)  
local playersESPBtn = makeButton("Player ESP", 290, 200, 30)  

-- Close Button
local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(0, 590, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)

-- ESP Logic for Mobs and Items (from external script)

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

-- Mobs ESP
mobsESPBtn.MouseButton1Click:Connect(function()
    clearESP()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Head") and not v:FindFirstChildOfClass("Humanoid") then
            createESP(v, v.Name)
        end
    end
    mobsESPBtn.BackgroundColor3 = mobsESPBtn.BackgroundColor3 == Color3.fromRGB(0, 255, 0) and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(0, 255, 0)
end)

-- Items ESP
itemsESPBtn.MouseButton1Click:Connect(function()
    clearESP()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Handle") then
            createESP(v, v.Name)
        end
    end
    itemsESPBtn.BackgroundColor3 = itemsESPBtn.BackgroundColor3 == Color3.fromRGB(0, 255, 0) and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(0, 255, 0)
end)

-- Player ESP (based on the original external script logic)
playersESPBtn.MouseButton1Click:Connect(function()
    clearESP()
    for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Head") then
            createESP(v.Character, v.Name)
        end
    end
    playersESPBtn.BackgroundColor3 = playersESPBtn.BackgroundColor3 == Color3.fromRGB(0, 255, 0) and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(0, 255, 0)
end)

-- Noclip Logic with Landing
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

-- Fullbright Logic
local function toggleFullbright(state)
    fullbrightActive = state
    fullbrightBtn.Text = "Fullbright: " .. (state and "ON" or "OFF")
    fullbrightBtn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

    if state then
        game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        game.Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end

-- Button logic
noclipBtn.MouseButton1Click:Connect(function()
    toggleNoclip(not noclipActive)
end)

fullbrightBtn.MouseButton1Click:Connect(function()
    toggleFullbright(not fullbrightActive)
end)

-- Close Button Logic
closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Tab switching logic
localButton.MouseButton1Click:Connect(function()
    -- Show Local Tab and hide ESP Tab
    localGroup.Visible = true
    espGroup.Visible = false
end)

espButton.MouseButton1Click:Connect(function()
    -- Show ESP Tab and hide Local Tab
    espGroup.Visible = true
    localGroup.Visible = false
end)

-- Make GUI draggable
local dragging = false
local dragStart = Vector3.zero
local startPos = frame.Position

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
