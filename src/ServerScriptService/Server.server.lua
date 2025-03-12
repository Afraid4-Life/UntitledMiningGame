local Players = game:GetService("Players")

local blockEngine = require(game:GetService("ReplicatedStorage").Engine.BlockEngine)
local blockInfo = require(game:GetService("ReplicatedStorage").Engine.BlockInfo)
local Settings = require(game:GetService("ReplicatedStorage").Settings)
local buildPart = require(game:GetService("ReplicatedStorage").Engine.BuildPart)
local DataManager = require(game.ReplicatedStorage.DataManager)
local InventoryComm = game.ReplicatedStorage.RemoteConnections.Inventory

local PickComms = game:GetService("ReplicatedStorage").RemoteConnections.PickComms

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
        local blockDataZ = blockEngine.createBlock(blockInfo[1], -130 + (x * 4), -2.25, -79.5 + (z*4))
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
    if (targ.Position - player.Character.HumanoidRootPart.Position).magnitude > blockSettings.DefaultBreakRange then return end
    local data = DataManager:Get(player)
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
                InventoryComm:FireClient(player, data.OreInventory)
            end


            --//  spawn blocks around destroyed block \\--
            --// turn into forloop, very easy (post + vector3.new()) and using a table with all vector offsets
            local blockData1 = blockEngine.createBlock(calcType(targ.Position.Y), targ.Position.X-4,targ.Position.Y,targ.Position.Z)
            local blockData2 = blockEngine.createBlock(calcType(targ.Position.Y), targ.Position.X+4,targ.Position.Y,targ.Position.Z)
            local blockData3 = blockEngine.createBlock(calcType(targ.Position.Y+4), targ.Position.X,targ.Position.Y+4,targ.Position.Z)
            local blockData4 = blockEngine.createBlock(calcType(targ.Position.Y-4), targ.Position.X,targ.Position.Y-4,targ.Position.Z)
            local blockData5 = blockEngine.createBlock(calcType(targ.Position.Y), targ.Position.X,targ.Position.Y,targ.Position.Z+4)
            local blockData6 = blockEngine.createBlock(calcType(targ.Position.Y), targ.Position.X,targ.Position.Y,targ.Position.Z-4)

            buildPart.new(blockData1)
            buildPart.new(blockData2)
            buildPart.new(blockData3)
            buildPart.new(blockData4)
            buildPart.new(blockData5)
            buildPart.new(blockData6)
            -- testing 123
        end
    end
end)