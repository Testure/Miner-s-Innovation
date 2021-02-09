local ARegister = {}

local Types = require(game.ReplicatedStorage.Common.Types)

function ARegister:Init(Modules)
    local BlockType = self.Import("BlockType", false)

    Modules.Registration:AddRegistry("BlockTypes")
    Modules.Registration:Register("BlockTypes", BlockType.new("Air", BrickColor.new("Medium stone grey"), 1))
    Modules.Registration:Register("BlockTypes", BlockType.new("Stone", BrickColor.new("Dark stone grey"), 0))
    Modules.Registration:Register("BlockTypes", BlockType.new("Grass", BrickColor.new("Shamrock"), 0))
    Modules.Registration:Register("BlockTypes", BlockType.new("Dirt", BrickColor.new("Brown"), 0))
end

return ARegister