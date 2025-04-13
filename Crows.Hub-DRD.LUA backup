-- Crows Hub - Speed & Jump GUI (Executor Friendly)
--i just updated the GUI not working, its working now with a close button, based on tbao hub, 
--added ESP and u can drag it now

-- Crows Hub - Noclip & ESP GUI (Executor Friendly)

local p = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local guiName = "CrowsHubUI"
local espTags = {}
local noclipActive = false
local jumping = false

-- Destroy any existing GUI
local existing = p:FindFirstChild("PlayerGui"):FindFirstChild(guiName)
if existing then existing:Destroy() end

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = guiName
gui.ResetOnSpawn = false
gui.Parent = p:WaitForChild("PlayerGui")

-- Main frame
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

-- Button maker
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

-- Top buttons
local localButton = makeButton("Local", 30, 45)
local espButton = makeButton("ESP", 160, 45)

-- Local Group
local localGroup = Instance.new("Frame", frame)
localGroup.Size = UDim2.new(0, 640, 0, 60)
localGroup.Position = UDim2.new(0, 0, 0, 170)
localGroup.Visible = false
localGroup.BackgroundTransparency = 1

local noclipButton = Instance.new("TextButton", localGroup)
noclipButton.Size = UDim2.new(0, 560, 0, 60)
noclipButton.Position = UDim2.new(0, 40, 0, 0)
noclipButton.Text = "Noclip"
noclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
noclipButton.TextColor3 = Color3.new(1, 1, 1)
noclipButton.Font = Enum.Font.GothamBold
noclipButton.TextScaled = true
Instance.new("UICorner", noclipButton).CornerRadius = UDim.new(0, 8)

-- ESP Group
local espGroup = Instance.new("Frame", frame)
espGroup.Size = UDim2.new(0, 640, 0, 60)
espGroup.Position = UDim2.new(0, 0, 0, 170)
espGroup.Visible = false
espGroup.BackgroundTransparency = 1

local mobsESPBtn = makeButton("Mobs ESP", 30, 200)
local itemsESPBtn = makeButton("Items ESP", 160, 200)
local playersESPBtn = makeButton("Player ESP", 290, 200)
mobsESPBtn.Visible = false
itemsESPBtn.Visible = false
playersESPBtn.Visible = false

-- ESP
local function createESP(model, labelText)
    if not model:FindFirstChild("Head") or model.Head:FindFirstChild("_ESPTag") then return end
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
    for _, tag in ipairs(espTags) do if tag and tag.Parent then tag:Destroy() end end
    espTags = {}
end

local function toggleESP(btn, flag, generator)
    _G[flag] = not _G[flag]
    if _G[flag] then
        clearESP()
        generator()
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        clearESP()
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end

mobsESPBtn.MouseButton1Click:Connect(function()
    toggleESP(mobsESPBtn, "MOBS_ESP", function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Head") and not v:FindFirstChildOfClass("Humanoid") then
                createESP(v, v.Name)
            end
        end
    end)
end)

itemsESPBtn.MouseButton1Click:Connect(function()
    toggleESP(itemsESPBtn, "ITEMS_ESP", function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Handle") then
                createESP(v, v.Name)
            end
        end
    end)
end)

playersESPBtn.MouseButton1Click:Connect(function()
    toggleESP(playersESPBtn, "PLAYERS_ESP", function()
        for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Head") then
                createESP(v.Character, v.Name)
            end
        end
    end)
end)

-- Noclip handling
noclipButton.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    noclipButton.BackgroundColor3 = noclipActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
end)

rs.Stepped:Connect(function()
    if noclipActive and not jumping then
        local char = p.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

local function monitorJump()
    local function setup(hum)
        hum:GetPropertyChangedSignal("Jump"):Connect(function()
            if hum.Jump then
                jumping = true
                wait(0.1)
                jumping = false
            end
        end)
    end
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        setup(p.Character.Humanoid)
    end
    p.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        setup(hum)
    end)
end
monitorJump()

-- Toggle tabs
localButton.MouseButton1Click:Connect(function()
    espGroup.Visible = false
    mobsESPBtn.Visible = false
    itemsESPBtn.Visible = false
    playersESPBtn.Visible = false
    localGroup.Visible = true
end)

espButton.MouseButton1Click:Connect(function()
    localGroup.Visible = false
    espGroup.Visible = not espGroup.Visible
    mobsESPBtn.Visible = espGroup.Visible
    itemsESPBtn.Visible = espGroup.Visible
    playersESPBtn.Visible = espGroup.Visible
end)

-- Close button
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 60, 0, 60)
close.Position = UDim2.new(1, -70, 0, 5)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 80, 80)
close.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
close.Font = Enum.Font.GothamBold
close.TextScaled = true
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
close.MouseButton1Click:Connect(function() gui:Destroy() end)
