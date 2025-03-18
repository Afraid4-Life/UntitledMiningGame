local DataManager = require(game.ReplicatedStorage.DataManager)
local InventoryComm = game.ReplicatedStorage.RemoteConnections.Inventory
local RequestData = game.ReplicatedStorage.RemoteConnections.RequestData

game.Players.PlayerAdded:Connect(function(player)
    local data 
    repeat task.wait() data = DataManager:Get(player) until data ~= nil

    if data then
        InventoryComm:FireClient(player, data)
    end
end) 

RequestData.OnServerEvent:Connect(function(player)
    local data 
    repeat task.wait() data = DataManager:Get(player) until data ~= nil

    RequestData:FireClient(player, data)
end)