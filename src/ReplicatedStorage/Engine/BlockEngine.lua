local Blocks = {}
Blocks.__index = Blocks

local allBlocks = {}

function Blocks.createBlock(blockType, blockVector)
    local block = setmetatable({}, Blocks)

    --// check if block has already been mined or is above surface level
    for _,v in (allBlocks) do
        if v.X == blockVector.X and v.Y == blockVector.Y and v.Z == blockVector.Z or blockVector.Y > 0 then 
            return nil
        end
    end

    --// block data
    block.X = blockVector.X
    block.Y = blockVector.Y
    block.Z = blockVector.Z
    block.Type = blockType

    table.insert(allBlocks, block)
    return block
end

function Blocks.getBlocks()
    return allBlocks
end


--// Not in use but maybe in the future
function Blocks.delBlock(block)
    for i,v in pairs(allBlocks) do
        if v.X == block.Position.X and v.Y == block.Position.Y and v.Z == block.Position.Z then
            table.remove(allBlocks,i)
        end
    end
end


return Blocks