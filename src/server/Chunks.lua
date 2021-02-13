local Chunks = {}
Chunks.ChunkMap = {}

local Types = require(game.ReplicatedStorage.Common.Types)

function Chunks:Init(Modules: {{}})
    local ParallelPromise = self.Import("ParallelPromise")
    local y = 0
    local BlockType = self.Import("BlockType", false)

    local Biome = {
        Amp = 20, 
        Scale = 30, 
        SurfaceBlock = BlockType.new("Grass", BrickColor.new("Shamrock"), 0),
        SubSurfaceBlock = BlockType.new("Dirt", BrickColor.new("Brown"), 0),
        UndergroundBlock = BlockType.new("Stone", BrickColor.new("Dark stone grey"), 0)
    }

    for x = 1, 8 do
        for z = 1, 8 do
            local Promise = ParallelPromise.new(function()
                y += 1
                local BlockMap: Types.BlockMap = Modules.ChunkGenerator:GenerateBlockMap(x * 16, z * 16, Biome)
                self.ChunkMap[y] = {x = x * 16, z = z * 16, Blocks = BlockMap, Biome = Biome}
                return true
            end)
            spawn(function()
                task.desynchronize()
                Promise:RunOnce()
            end)
        end
    end
    repeat wait() until y == (8 * 8)
    print("ChunkMap generated!")

    for i = 1, #self.ChunkMap do
        local Promise = ParallelPromise.new(Modules.ChunkGenerator.GenerateChunk)
        spawn(function()
            task.desynchronize()
            Promise:RunOnce(Modules.ChunkGenerator, self.ChunkMap[i].x, self.ChunkMap[i].z, i, self.ChunkMap[i].Blocks, self.ChunkMap[i].Biome)
        end)
    end
end

function Chunks:Start(Modules: {{}})

end

return Chunks