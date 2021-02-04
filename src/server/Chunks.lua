local Chunks = {}
Chunks.ChunkMap = {}

local Types = require(game.ReplicatedStorage.Common.Types)

function Chunks:Init(Modules: {{}})
    local y = 0
    for x = 1, 4 do
        for z = 1, 4 do
            y += 1
            local BlockMap: Types.BlockMap = Modules.ChunkGenerator:GenerateBlockMap(x * 16, z * 16, {Amp = 20, Scale = 15})
            self.ChunkMap[y] = {x = x * 16, z = z * 16, Blocks = BlockMap, Biome = {Amp = 20, Scale = 15}}
        end
    end
    print("ChunkMap generated!")
    for i = 1, #self.ChunkMap do
        Modules.ChunkGenerator:GenerateChunk(self.ChunkMap[i].x, self.ChunkMap[i].z, i, self.ChunkMap[i].Blocks, self.ChunkMap[i].Biome)
    end
end

function Chunks:Start(Modules: {{}})

end

return Chunks