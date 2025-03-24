local player = game.Players.LocalPlayer
local Mouse = player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local InventoryComm = game.ReplicatedStorage.RemoteConnections.Inventory
local BlockInfo = require(game.ReplicatedStorage.Engine.BlockInfo)

local playerGui = player:WaitForChild("PlayerGui")

--// Update Inventory \\--
InventoryComm.OnClientEvent:Connect(function(data)
    player.PlayerGui.Inventory.Frame.ScrollingFrame:ClearAllChildren()

    local UiList = Instance.new("UIListLayout")
    UiList.Parent = player.PlayerGui.Inventory.Frame.ScrollingFrame
    UiList.Padding = UDim.new(0.001,0)
    UiList.VerticalAlignment =  Enum.VerticalAlignment.Bottom

    local totalOres = 0

    for i,v in pairs(data.OreInventory) do
        if v == 0 then continue end

        local oreFrame = player.PlayerGui.Inventory.Frame.Example:Clone()
        oreFrame.Parent = player.PlayerGui.Inventory.Frame.ScrollingFrame
        oreFrame.Name = i
        oreFrame.OreName.Text = i
        oreFrame.Amount.Text = v
        oreFrame.Visible = true

        totalOres += v

        for _,ore in pairs(BlockInfo) do
            if ore.Name == i then
                oreFrame.ImageOre.ImageRectOffset = ore.RectOffset
                oreFrame.ImageOre.ImageRectSize = (ore.RectSize) or Vector2.new(26, 26)
            end
        end
    end
    
    player.PlayerGui.Inventory.Frame.InventorySpace.Frame.TextLabel.Text = totalOres.."/"..data.OreCapacity
    player.PlayerGui.Inventory.Frame.InventorySpace.Frame.Grow.Size = UDim2.new(totalOres/data.OreCapacity,0,1,0)

    if totalOres >= data.OreCapacity then
        player.PlayerGui.Inventory.Frame.InventorySpace.Frame.Grow.BackgroundColor3 = Color3.fromRGB(255, 126, 126)
    else
        player.PlayerGui.Inventory.Frame.InventorySpace.Frame.Grow.BackgroundColor3 = Color3.fromRGB(157, 228, 116)
    end

    player.PlayerGui.Inventory.StatsFrame.Money.Text = "$"..data.Money
end)

--// Depth Meter \\--
RunService.Heartbeat:Connect(function()
    player.PlayerGui.Inventory.StatsFrame.PositionText.Text = "Depth: "..math.floor((player.Character.HumanoidRootPart.Position.Y/4))
end)


local scrollframe = playerGui:WaitForChild("Inventory"):WaitForChild("Frame"):WaitForChild("ScrollingFrame")
scrollframe.CanvasSize = UDim2.new(0, 0, 0, scrollframe.UIListLayout.AbsoluteContentSize.Y)


local function updateFrameSizes()
	scrollframe.CanvasSize = UDim2.new(0, 0, 0, scrollframe.UIListLayout.AbsoluteContentSize.Y)

    playerGui:WaitForChild("Inventory"):WaitForChild("Frame"):WaitForChild("Background").Size = UDim2.new(1, 0, 0, scrollframe.UIListLayout.AbsoluteContentSize.Y)
    playerGui:WaitForChild("Inventory"):WaitForChild("Frame"):WaitForChild("Background").Position = UDim2.new(0, 0, 0.908, -scrollframe.UIListLayout.AbsoluteContentSize.Y)

    if scrollframe.UIListLayout.AbsoluteContentSize.Y == 0 then
        playerGui:WaitForChild("Inventory"):WaitForChild("Frame"):WaitForChild("Background").UIStroke.Thickness = 0
    else
        playerGui:WaitForChild("Inventory"):WaitForChild("Frame"):WaitForChild("Background").UIStroke.Thickness = 0.7
    end
end


--// Inventory Scroll Mechanic \\-
scrollframe.ChildAdded:Connect(function(child)
	task.wait()
	updateFrameSizes()
end)

scrollframe.ChildRemoved:Connect(function()
	task.wait()
    updateFrameSizes()
end)

--// Tp to Surface Button \\--
playerGui:WaitForChild("Inventory"):WaitForChild("SurfaceTP").MouseButton1Down:Connect(function()
    player.Character.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame + Vector3.new(0,2,0)
end)
