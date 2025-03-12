local player = game.Players.LocalPlayer
local Mouse = player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local InventoryComm = game.ReplicatedStorage.RemoteConnections.Inventory


InventoryComm.OnClientEvent:Connect(function(InventoryData)
    print(InventoryData)

    player.PlayerGui.Inventory.Frame.ScrollingFrame:ClearAllChildren()

    local UiList = Instance.new("UIListLayout")
    UiList.Parent = player.PlayerGui.Inventory.Frame.ScrollingFrame
    UiList.Padding = UDim.new(0.001,0)

    for i,v in pairs(InventoryData) do
        if v == 0 then continue end

        local oreFrame = player.PlayerGui.Inventory.Frame.Example:Clone()
        oreFrame.Parent = player.PlayerGui.Inventory.Frame.ScrollingFrame
        oreFrame.Name = i
        oreFrame.OreName.Text = i
        oreFrame.Amount.Text = v
        oreFrame.Visible = true
    end
end)


RunService.Heartbeat:Connect(function(deltaTime)
    player.PlayerGui.Inventory.Position.Text = "Depth: "..math.floor((player.Character.HumanoidRootPart.Position.Y/4))
end)
