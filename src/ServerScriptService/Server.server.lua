local Players = game:GetService("Players")

local blockEngine = require(game:GetService("ReplicatedStorage").Engine.BlockEngine)
local blockInfo = require(game:GetService("ReplicatedStorage").Engine.BlockInfo)
local Settings = require(game:GetService("ReplicatedStorage").Settings)
local buildPart = require(game:GetService("ReplicatedStorage").Engine.BuildPart)
local DataManager = require(game.ReplicatedStorage.DataManager)
local InventoryComm = game.ReplicatedStorage.RemoteConnections.Inventory

local PickComms = game:GetService("ReplicatedStorage").RemoteConnections.PickComms

local vectorOffsets = {
    Vector3.new(-4,0,0),
    Vector3.new(4,0,0),
    Vector3.new(0,4,0),
    Vector3.new(0,-4,0),
    Vector3.new(0,0,-4),
    Vector3.new(0,0,4)
}

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAppearanceLoaded:Connect(function(character)
        local light = Instance.new("SurfaceLight")
        light.Angle = 360
        light.Brightness = 0.6
        light.Parent = character.HumanoidRootPart
    end)
end)

--// simplicity sake, change from blocks unit to studs
local blockSettings = table.clone(Settings)
for i,v in pairs(blockSettings) do
    blockSettings[i] *= 4
end

--// Create Top Layer \\--
for x = 0, blockSettings.GridX, 1 do
    for z = 0, blockSettings.GridZ, 1 do
        local blockDataZ = blockEngine.createBlock(blockInfo[1], Vector3.new(-130 + (x * 4), -2.25, -79.5 + (z*4)))
        buildPart.new(blockDataZ)
    end
end

--// calculate block type \\--
local function calcType(yPos)
    for i,v in pairs (blockInfo) do
        if v.Layers then
            for i2,v2 in pairs(v.Layers) do
                if yPos <= blockSettings[i2] and math.random(1,v2) == 1 then
                    return blockInfo[i]
                end
            end
        end
    end

    --// Create layers \\--
    if yPos < blockSettings.DirtY and yPos > blockSettings.ClayY then return blockInfo[1]
	elseif yPos <= blockSettings.ClayY and yPos > blockSettings.SandstoneY then return blockInfo[2]
	elseif yPos <= blockSettings.SandstoneY and yPos > blockSettings.LimestoneY then return blockInfo[10]
    elseif yPos <= blockSettings.LimestoneY and yPos > blockSettings.StoneY then return blockInfo[9] 
    elseif yPos <= blockSettings.StoneY and yPos > blockSettings.BedrockY then return blockInfo[3]
	else -- and if no other ore is chosen by now, it returns bedrock so players don't fall into void:
	    return blockInfo[4]
	end 
end

--// Pickaxe Communications
PickComms.OnServerEvent:Connect(function(player, targ)
    if (targ.Position - player.Character.HumanoidRootPart.Position).magnitude > blockSettings.DefaultBreakRange  then return end

    local data = DataManager:Get(player)

    local amount = 0
    for _,v in pairs(data.OreInventory) do
        amount += v
    end

    if amount >= data.OreCapacity then return end

    for _,v in pairs(blockInfo) do
        if v.Name == targ.Name then

            local waitTime = 0

            for _,v in pairs(blockInfo) do
                if v.Name == targ.Name then
                    waitTime = v.defaultTime
                end
            end
            
            task.wait(waitTime)

            if targ.Name ~= "Bedrock" then
                targ:Destroy()
                data.OreInventory[targ.Name] += 1
                InventoryComm:FireClient(player, data)
            end


            --//  spawn blocks around destroyed block \\--
            for i = 0, 5, 1 do
                i += 1
                local blockData = blockEngine.createBlock(calcType(targ.Position.Y+vectorOffsets[i].Y), Vector3.new(targ.Position.X,targ.Position.Y,targ.Position.Z)+vectorOffsets[i])
                print(vectorOffsets[i], i)
                buildPart.new(blockData)
            end
        end
    end
end)


for _,SellPart in pairs(workspace.SellPoints:GetChildren()) do
    SellPart.SellPrompt.Triggered:Connect(function(player)
        local data 
        repeat task.wait() data = DataManager:Get(player) until data ~= nil

        for i,_ in (data.OreInventory) do
            if data.OreInventory[i] > 0 then
                data.OreInventory[i] = 0
                
                for _,v in pairs(blockInfo) do
                    if v.Name == i then
                        data.Money += v.Value
                    end
                end

            end
        end

        InventoryComm:FireClient(player, data)
    end)
end