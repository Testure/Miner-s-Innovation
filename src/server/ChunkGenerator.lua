local ChunkGenerator = {}

local Types = require(game.ReplicatedStorage.Common.Types)

function ChunkGenerator:Init(Modules: {{}})

end

function ChunkGenerator:Start(Modules: {{}})
    
end

function ChunkGenerator:GenerateChunkMap(Size: number): Types.ChunkMap
    local Map: Types.ChunkMap = {[0] = {[0] = {[0] = {XNoise = 0, YNoise = 0, ZNoise = 0, Density = 0}}}}
    local Perlin = self.Import("Perlin")

    for x = 0, Size do
        Map[x] = {}
        for z = 0, Size do
            Map[x][z] = {}
            for y = 0, 25 do
                local BlockData: Types.BlockNoise = Perlin:CreateNoise(x, y, z, 20, 30)
                Map[x][z][y] = BlockData
            end
        end
    end
    print("ChunkMap Generated!")
    return Map
end

return ChunkGenerator