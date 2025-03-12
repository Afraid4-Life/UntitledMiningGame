local DataManager = require(game.ReplicatedStorage.DataManager)
local InventoryComm = game.ReplicatedStorage.RemoteConnections.Inventory

game.Players.PlayerAdded:Connect(function(player)
    local data 
    print("loading data")
    repeat task.wait() data = DataManager:Get(player) until data ~= nil
    print("recieved data")

    if data then
        InventoryComm:FireClient(player, data.OreInventory)
    end
end) 