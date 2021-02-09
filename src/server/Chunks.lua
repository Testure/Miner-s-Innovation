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

    for x = 1, 2 do
        for z = 1, 2 do
            y += 1
            local BlockMap: Types.BlockMap = Modules.ChunkGenerator:GenerateBlockMap(x * 16, z * 16, Biome)
            self.ChunkMap[y] = {x = x * 16, z = z * 16, Blocks = BlockMap, Biome = Biome}
        end
    end
    print("ChunkMap generated!")

    for i = 1, #self.ChunkMap do
        local Actor = Instance.new("Actor")
        Actor.Parent = game.ServerStorage
        local Mod = game.ReplicatedStorage.Common.ParallelPromise:Clone()
        Mod.Parent = Actor
        local e = require(Mod)
        spawn(function()
            task.desynchronize()
            e(Modules.ChunkGenerator.GenerateChunk, Modules.ChunkGenerator, self.ChunkMap[i].x, self.ChunkMap[i].z, i, self.ChunkMap[i].Blocks, self.ChunkMap[i].Biome, Actor)
            --Modules.ChunkGenerator:GenerateChunk(self.ChunkMap[i].x, self.ChunkMap[i].z, i, self.ChunkMap[i].Blocks, self.ChunkMap[i].Biome)
        end)
    end
end

function Chunks:Start(Modules: {{}})

end

return Chunks