local blockEngine = require(game:GetService("ReplicatedStorage").Engine.BlockEngine)
local blockInfo = require(game:GetService("ReplicatedStorage").Engine.BlockInfo)
local Settings = require(game:GetService("ReplicatedStorage").Settings)
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local playerGui = Player:WaitForChild("PlayerGui")
local Mouse = Player:GetMouse()

local RequestData = game.ReplicatedStorage.RemoteConnections.RequestData

local PickComms = game:GetService("ReplicatedStorage").RemoteConnections.PickComms

local tool = script.Parent

local breakRange = (Settings.DefaultBreakRange*4) -- 5 blocks, 20 studs total

local isHolding = false
local currentlyMining = false

local HighlightHover = Instance.new("Highlight")
HighlightHover.Parent = script.Parent
HighlightHover.Enabled = true
HighlightHover.Name = "Highlight_Hover"
HighlightHover.FillTransparency = 1

local HighlightSelected = Instance.new("Highlight")
HighlightSelected.Parent = script.Parent
HighlightSelected.Enabled = false
HighlightSelected.Name = "Highlight_Selected"
HighlightSelected.FillTransparency = 1
HighlightSelected.OutlineColor = Color3.fromRGB(129, 255, 125)

local data
--// fetch data \\-
local function fetchData()
    RequestData:FireServer(Player)
end

RequestData.OnClientEvent:Connect(function(d)
    data = d
end)

fetchData()

--// Mining \\--
tool.Activated:Connect(function()
    if currentlyMining then return end
    currentlyMining = true 

    fetchData()

    local amount = 0
    for _,v in pairs(data.OreInventory) do
        amount += v
    end

    if amount == data.OreCapacity then 
        playerGui.BlockSelection.Frame.InventoryFull.Visible = true
    else
        playerGui.BlockSelection.Frame.InventoryFull.Visible = false
     end

    local waitTime = 0
    for _,v in pairs(blockInfo) do
        if v.Name == Mouse.Target.Name then
            waitTime = v.defaultTime
        end
    end

    if (Mouse.Target.Position - Player.Character.HumanoidRootPart.Position).magnitude < breakRange then
        HighlightSelected.Adornee = Mouse.Target
        HighlightSelected.Enabled = true
    end

    PickComms:FireServer(Mouse.Target)
    playerGui.BlockSelection.Frame.BlockSelected.Text = Mouse.Target.Name
    TweenService:Create(playerGui.BlockSelection.Frame.Progress.Main, TweenInfo.new(waitTime), {Size = UDim2.fromScale(1,1)}):Play()

    task.wait(waitTime)
    
    playerGui.BlockSelection.Frame.Progress.Main.Size = UDim2.fromScale(0,1)

    currentlyMining = false
    HighlightSelected.Adornee = nil
    HighlightSelected.Enabled = false
end)


tool.Equipped:Connect(function()
    isHolding = true
end)

tool.Unequipped:Connect(function()
    isHolding = false
end)

Mouse.Move:Connect(function()
    if isHolding then
        if (Mouse.Target.Position - Player.Character.HumanoidRootPart.Position).magnitude > breakRange then 
            HighlightHover.Adornee = nil
            HighlightHover.Enabled = false
            playerGui.BlockSelection.Frame.Visible = false
            return 
        end
    
        for _,v in pairs(blockInfo) do
            if Mouse.Target.Name == v.Name then
                HighlightHover.Adornee = Mouse.Target
                HighlightHover.Enabled = true
                playerGui.BlockSelection.Frame.Visible = true
                playerGui.BlockSelection.Frame.BlockSelected.Text = Mouse.Target.Name
            end
        end
    else
        HighlightHover.Adornee = nil
        HighlightHover.Enabled = false
        playerGui.BlockSelection.Frame.Visible = false
    end
end)
