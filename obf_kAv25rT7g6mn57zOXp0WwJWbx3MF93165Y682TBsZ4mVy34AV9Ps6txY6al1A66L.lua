local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.Name = "DonationSimulator"

-- Drag function for windows
local function makeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Animation function for closing windows
local function animateClose(frame)
    spawn(function()
        frame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5)
        for i = 0, 1, 0.05 do
            frame.BackgroundTransparency = i
            for _, child in pairs(frame:GetChildren()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    child.TextTransparency = i
                elseif child:IsA("Frame") or child:IsA("ScrollingFrame") then
                    child.BackgroundTransparency = i
                end
            end
            wait(0.02)
        end
        frame:Destroy()
    end)
end

-- Create the main frame with macOS-like styling
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
mainFrame.Visible = false
makeDraggable(mainFrame)

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainFrame

-- macOS-like traffic lights
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 12, 0, 12)
closeButton.Position = UDim2.new(0, 10, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 95, 87)
closeButton.BorderSizePixel = 0
closeButton.Text = ""
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton
closeButton.Parent = mainFrame

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 12, 0, 12)
minimizeButton.Position = UDim2.new(0, 27, 0, 10)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 189, 46)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = ""
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1, 0)
minCorner.Parent = minimizeButton
minimizeButton.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Donation Simulator"
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.Parent = mainFrame

-- Player list frame
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(0, 280, 0, 300)
playerList.Position = UDim2.new(0, 10, 0, 40)
playerList.BackgroundTransparency = 1
playerList.BorderSizePixel = 0
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.Parent = mainFrame

-- Steal button
local stealButton = Instance.new("TextButton")
stealButton.Size = UDim2.new(0, 260, 0, 40)
stealButton.Position = UDim2.new(0, 20, 0, 350)
stealButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
stealButton.Text = "Steal Donations"
stealButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stealButton.Font = Enum.Font.GothamBlack
stealButton.TextSize = 20
local stealCorner = Instance.new("UICorner")
stealCorner.CornerRadius = UDim.new(0, 10)
stealCorner.Parent = stealButton
stealButton.Parent = mainFrame

-- Restore button for minimized state
local restoreButton = Instance.new("TextButton")
restoreButton.Size = UDim2.new(0, 30, 0, 30)
restoreButton.Position = UDim2.new(1, -40, 0, 0)
restoreButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
restoreButton.Text = "▲"
restoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
restoreButton.Font = Enum.Font.GothamBlack
restoreButton.TextSize = 16
restoreButton.Visible = false
local restoreCorner = Instance.new("UICorner")
restoreCorner.CornerRadius = UDim.new(0, 5)
restoreCorner.Parent = restoreButton
restoreButton.Parent = mainFrame

-- Selected player window
local selectedFrame = Instance.new("Frame")
selectedFrame.Size = UDim2.new(0, 200, 0, 80)
selectedFrame.Position = UDim2.new(0.5, 100, 0, -40)
selectedFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
selectedFrame.BorderSizePixel = 0
selectedFrame.Parent = screenGui
selectedFrame.Visible = false
makeDraggable(selectedFrame)

local selectedCorner = Instance.new("UICorner")
selectedCorner.CornerRadius = UDim.new(0, 15)
selectedCorner.Parent = selectedFrame

local selectedClose = Instance.new("TextButton")
selectedClose.Size = UDim2.new(0, 12, 0, 12)
selectedClose.Position = UDim2.new(0, 10, 0, 10)
selectedClose.BackgroundColor3 = Color3.fromRGB(255, 95, 87)
selectedClose.BorderSizePixel = 0
selectedClose.Text = ""
local selectedCloseCorner = Instance.new("UICorner")
selectedCloseCorner.CornerRadius = UDim.new(1, 0)
selectedCloseCorner.Parent = selectedClose
selectedClose.Parent = selectedFrame

local selectedLabel = Instance.new("TextLabel")
selectedLabel.Size = UDim2.new(1, 0, 1, -20)
selectedLabel.Position = UDim2.new(0, 0, 0, 20)
selectedLabel.BackgroundTransparency = 1
selectedLabel.Text = "Selected: None"
selectedLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
selectedLabel.Font = Enum.Font.GothamBold
selectedLabel.TextSize = 16
selectedLabel.TextWrapped = true
selectedLabel.Parent = selectedFrame

-- Made By window
local madeByFrame = Instance.new("Frame")
madeByFrame.Size = UDim2.new(0, 200, 0, 60)
madeByFrame.Position = UDim2.new(0.5, -300, 0.5, -100)
madeByFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
madeByFrame.BorderSizePixel = 0
madeByFrame.Parent = screenGui
madeByFrame.Visible = false
makeDraggable(madeByFrame)

local madeByCorner = Instance.new("UICorner")
madeByCorner.CornerRadius = UDim.new(0, 15)
madeByCorner.Parent = madeByFrame

local madeByLabel = Instance.new("TextLabel")
madeByLabel.Size = UDim2.new(1, 0, 1, 0)
madeByLabel.Position = UDim2.new(0, 0, 0, 0)
madeByLabel.BackgroundTransparency = 1
madeByLabel.Text = "Made By: Lucas - Roblox Scripts"
madeByLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
madeByLabel.Font = Enum.Font.GothamBold
madeByLabel.TextSize = 16
madeByLabel.TextWrapped = true
madeByLabel.Parent = madeByFrame

-- Stealing window
local function createStealingWindow()
    local stealingFrame = Instance.new("Frame")
    stealingFrame.Size = UDim2.new(0, 200, 0, 80)
    stealingFrame.Position = UDim2.new(0.5, -100, 0.5, -40)
    stealingFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    stealingFrame.BorderSizePixel = 0
    stealingFrame.Parent = screenGui
    stealingFrame.Visible = false
    makeDraggable(stealingFrame)

    local stealingCorner = Instance.new("UICorner")
    stealingCorner.CornerRadius = UDim.new(0, 15)
    stealingCorner.Parent = stealingFrame

    local stealingText = Instance.new("TextLabel")
    stealingText.Size = UDim2.new(1, 0, 1, 0)
    stealingText.Position = UDim2.new(0, 0, 0, 0)
    stealingText.BackgroundTransparency = 1
    stealingText.Text = "Stealing Donations..."
    stealingText.TextColor3 = Color3.fromRGB(0, 0, 0)
    stealingText.Font = Enum.Font.GothamBold
    stealingText.TextSize = 16
    stealingText.TextWrapped = true
    stealingText.Parent = stealingFrame

    return stealingFrame
end

-- Success window
local function createSuccessWindow(playerName, amount)
    local successFrame = Instance.new("Frame")
    successFrame.Size = UDim2.new(0, 250, 0, 150)
    successFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
    successFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    successFrame.BorderSizePixel = 0
    successFrame.Parent = screenGui
    successFrame.Visible = false
    makeDraggable(successFrame)

    local successCorner = Instance.new("UICorner")
    successCorner.CornerRadius = UDim.new(0, 15)
    successCorner.Parent = successFrame

    local successClose = Instance.new("TextButton")
    successClose.Size = UDim2.new(0, 12, 0, 12)
    successClose.Position = UDim2.new(0, 10, 0, 10)
    successClose.BackgroundColor3 = Color3.fromRGB(255, 95, 87)
    successClose.BorderSizePixel = 0
    successClose.Text = ""
    local successCloseCorner = Instance.new("UICorner")
    successCloseCorner.CornerRadius = UDim.new(1, 0)
    successCloseCorner.Parent = successClose
    successClose.Parent = successFrame

    local successText = Instance.new("TextLabel")
    successText.Size = UDim2.new(1, 0, 1, -20)
    successText.Position = UDim2.new(0, 0, 0, 20)
    successText.BackgroundTransparency = 1
    successText.Text = "Success! Stole " .. amount .. " Robux from " .. playerName .. "!"
    successText.TextColor3 = Color3.fromRGB(0, 0, 0)
    successText.Font = Enum.Font.GothamBlack
    successText.TextSize = 20
    successText.TextWrapped = true
    successText.Parent = successFrame

    successClose.MouseButton1Click:Connect(function()
        animateClose(successFrame)
    end)

    return successFrame
end

-- Intro animation
local introLabel = Instance.new("TextLabel")
introLabel.Size = UDim2.new(0, 0, 0, 0)
introLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
introLabel.AnchorPoint = Vector2.new(0.5, 0.5)
introLabel.BackgroundTransparency = 1
introLabel.Text = "Subscribe to Lucas - Roblox Scripts"
introLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
introLabel.Font = Enum.Font.GothamBlack
introLabel.TextSize = 30
introLabel.Parent = screenGui

-- Slower exploding intro effect
spawn(function()
    introLabel:TweenSize(UDim2.new(0, 600, 0, 200), "Out", "Quad", 1.5)
    wait(1)
    introLabel:TweenSize(UDim2.new(0, 1000, 0, 300), "In", "Quad", 1.5)
    for i = 0, 1, 0.02 do
        introLabel.TextTransparency = i
        wait(0.05)
    end
    introLabel:Destroy()
    mainFrame.Visible = true
    madeByFrame.Visible = true
    mainFrame:TweenPosition(UDim2.new(0.5, -150, 0.5, -200), "Out", "Bounce", 0.5)
    madeByFrame:TweenPosition(UDim2.new(0.5, -300, 0.5, -100), "Out", "Bounce", 0.5)
end)

-- Variables
local selectedPlayer = nil
local selectedRaised = 0
local isMinimized = false

-- Functions
local function updatePlayerList()
    playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
    for _, child in pairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local yOffset = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local raised = player:WaitForChild("leaderstats"):WaitForChild("Raised").Value
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -10, 0, 40)
            button.Position = UDim2.new(0, 5, 0, yOffset)
            button.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            button.Text = player.Name .. " (Raised: " .. raised .. ")"
            button.TextColor3 = Color3.fromRGB(0, 0, 0)
            button.Font = Enum.Font.GothamBold
            button.TextSize = 18
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = button
            
            button.MouseButton1Click:Connect(function()
                selectedPlayer = player
                selectedRaised = raised
                selectedLabel.Text = "Selected: " .. player.Name
                selectedFrame.Visible = true
                selectedFrame:TweenPosition(UDim2.new(0.5, 100, 0.5, -40), "Out", "Bounce", 0.5)
            end)
            
            button.Parent = playerList
            yOffset = yOffset + 45
        end
    end
    playerList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Client-side leaderboard manipulation
local function fakeStealRobux(targetPlayer, amount)
    local targetLeaderstats = targetPlayer:WaitForChild("leaderstats")
    local targetRaised = targetLeaderstats:WaitForChild("Raised")
    local stolenAmount = math.min(amount, targetRaised.Value) -- Don't steal more than they have
    targetRaised.Value = math.max(0, targetRaised.Value - stolenAmount) -- Reduce target's Raised
    
    local myLeaderstats = LocalPlayer:WaitForChild("leaderstats")
    local myRaised = myLeaderstats:WaitForChild("Raised")
    myRaised.Value = myRaised.Value + stolenAmount -- Add to my Raised
end

-- Button functionality
closeButton.MouseButton1Click:Connect(function()
    animateClose(mainFrame)
    animateClose(madeByFrame)
end)

minimizeButton.MouseButton1Click:Connect(function()
    if not isMinimized then
        playerList.Visible = false
        stealButton.Visible = false
        mainFrame:TweenSize(UDim2.new(0, 300, 0, 30), "Out", "Quad", 0.3)
        restoreButton.Visible = true
        isMinimized = true
    end
end)

restoreButton.MouseButton1Click:Connect(function()
    if isMinimized then
        mainFrame:TweenSize(UDim2.new(0, 300, 0, 400), "Out", "Quad", 0.3)
        wait(0.3)
        playerList.Visible = true
        stealButton.Visible = true
        restoreButton.Visible = false
        isMinimized = false
    end
end)

selectedClose.MouseButton1Click:Connect(function()
    animateClose(selectedFrame)
    selectedPlayer = nil
    selectedRaised = 0
    selectedLabel.Text = "Selected: None"
end)

stealButton.MouseButton1Click:Connect(function()
    if selectedPlayer then
        local stealingWindow = createStealingWindow()
        stealingWindow.Visible = true
        stealingWindow:TweenPosition(UDim2.new(0.5, -100, 0.5, -40), "Out", "Bounce", 0.5)
        
        spawn(function()
            wait(2)
            animateClose(stealingWindow)
            fakeStealRobux(selectedPlayer, selectedRaised)
            local successWindow = createSuccessWindow(selectedPlayer.Name, selectedRaised)
            successWindow.Visible = true
            successWindow:TweenPosition(UDim2.new(0.5, -125, 0.5, -75), "Out", "Bounce", 0.5)
            updatePlayerList()
        end)
        
        -- Uncomment the line below and comment out the debug mode above for live game with purchase
        -- MarketplaceService:PromptProductPurchase(LocalPlayer, 12345678)
    else
        local tempLabel = Instance.new("TextLabel")
        tempLabel.Size = UDim2.new(1, 0, 0, 20)
        tempLabel.Position = UDim2.new(0, 0, 0, 325)
        tempLabel.BackgroundTransparency = 1
        tempLabel.Text = "Please select a player first!"
        tempLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        tempLabel.Font = Enum.Font.GothamBold
        tempLabel.TextSize = 16
        tempLabel.Parent = mainFrame
        wait(2)
        animateClose(tempLabel)
    end
end)

-- Handle purchase (for live game)
MarketplaceService.PromptPurchaseFinished:Connect(function(player, assetId, isPurchased)
    if isPurchased and player == LocalPlayer and selectedPlayer then
        for _, child in pairs(screenGui:GetChildren()) do
            if child:IsA("Frame") and child:FindFirstChild("TextLabel") and child.TextLabel.Text == "Stealing Donations..." then
                animateClose(child)
            end
        end
        wait(2)
        fakeStealRobux(selectedPlayer, selectedRaised)
        local successWindow = createSuccessWindow(selectedPlayer.Name, selectedRaised)
        successWindow.Visible = true
        successWindow:TweenPosition(UDim2.new(0.5, -125, 0.5, -75), "Out", "Bounce", 0.5)
        updatePlayerList()
    end
end)

-- Update player list periodically
updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Subtle hover effect (color change only)
stealButton.MouseEnter:Connect(function()
    stealButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)
stealButton.MouseLeave:Connect(function()
    stealButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
end)