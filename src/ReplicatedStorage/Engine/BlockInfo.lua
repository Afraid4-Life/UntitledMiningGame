return table.freeze({
    [1] = {
        Name = "Dirt",
        Color = Color3.fromRGB(145, 101, 75),
        Material = Enum.Material.Grass,
        Breakable = true,
        defaultTime = 0.5,
        BaseRarity = 0,
        Value = 4,
        RectOffset = Vector2.new(435, 667),
    },
    [2] = {
        Name = "Clay",
        Color = Color3.new(0.474509, 0.431372, 0.392156),
        Material = Enum.Material.Sand,
        Breakable = true,
        defaultTime = 1.2, -- 1.2
        Layers = {["DirtY"] = 50, ["StoneY"] = 125},
        Value = 8,
        RectOffset = Vector2.new(409, 258)
    },
    [3] = {
        Name = "Stone",
        Color = Color3.new(0.47843137254901963, 0.47843137254901963, 0.47843137254901963),
        Material = Enum.Material.Concrete,
        Breakable = true,
        defaultTime = 4, -- 2
        Layers = {["DirtY"] = 250, ["ClayY"] = 100},
        Value = 12,
        RectOffset = Vector2.new(281, 383),
    },
    [4] = {
        Name = "Bedrock",
        Color = Color3.fromRGB(54, 54, 54),
        Material = Enum.Material.SmoothPlastic,
        Breakable = false,
        defaultTime = 0,
        RectOffset = Vector2.new(285,544)
    },
    [5] = {
        Name = "Coal",
        Color = Color3.new(0,0,0),
        Material = Enum.Material.Concrete,
        Breakable = true,
        defaultTime = 1.5,
        Layers = {["StoneY"] = 40, ["ClayY"] = 75, ["DirtY"] = 350},
        Value = 35,
        RectOffset = Vector2.new(256.5, 409)
    },
    [6] = {
        Name = "Iron",
        Color = Color3.new(0.905882, 0.862745, 0.650980),
        Material = Enum.Material.Marble,
        Breakable = true,
        defaultTime = 3, -- 2
        Layers = {["StoneY"] = 50, ["ClayY"] = 250},
        Value = 75,
        RectOffset = Vector2.new(230, 408)
    },
    [7] = {
        Name = "Diamond",
        Color = Color3.new(0.482352, 0.8, 0.945098),
        Material = Enum.Material.Marble,
        Breakable = true,
        defaultTime = 15, -- 2
        Layers = {["StoneY"] = 150},
        Value = 250,
        RectOffset = Vector2.new(408, 869)
    },
    [8] = {
        Name = "Emerald",
        Color = Color3.new(0.501960, 1, 0.486274),
        Material = Enum.Material.Marble,
        Breakable = true,
        defaultTime = 8, -- 2
        Layers = {["StoneY"] = 150},
        Value = 300,
        RectOffset = Vector2.new(434, 870)
    },
    [9] = {
        Name = "Limestone",
        Color = Color3.new(0.827450, 0.807843, 0.749019),
        Material = Enum.Material.Concrete,
        Breakable = true,
        defaultTime = 2.2, -- 2
        Value = 10,
        RectOffset = Vector2.new(460, 487)
    },
    [10] = {
        Name = "Sandstone",
        Color = Color3.new(0.945098, 0.858823, 0.619607),
        Material = Enum.Material.Sand,
        Breakable = true,
        defaultTime = 1.6, -- 2
        Value = 11,
        RectOffset = Vector2.new(487, 128)
    }
})