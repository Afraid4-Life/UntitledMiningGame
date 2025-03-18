local createBlock = {}

function createBlock.new(blockData)
    --// if block cannot be places just cancel
    if not blockData then return end 

    local part = Instance.new("Part")
    part.Anchored = true
    part.Size = Vector3.new(4,4,4)
    part.Position = Vector3.new(blockData.X, blockData.Y, blockData.Z)
    part.Parent = workspace.Blocks
    part.Color = blockData.Type["Color"]
    part.Material = blockData.Type["Material"]
    part.Name = blockData.Type["Name"]
end

return createBlock