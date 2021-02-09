local ChunkGenerator = {}

local Types = require(game.ReplicatedStorage.Common.Types)

function ChunkGenerator:Init()

end

function ChunkGenerator:Start(Modules: {{}})
    
end

function ChunkGenerator:GenerateBlockMap(ChunkX: number, ChunkZ: number, Biome: Types.Biome): Types.BlockMap
    local Map: Types.BlockMap = {[1] = {[1] = {[1] = {XNoise = 0, YNoise = 0, ZNoise = 0, Density = 0}}}}
    local Size = 1
    local Perlin = self.Import("Perlin")

    for x = 1, Size * 16 do
        Map[x] = {}
        for z = 1, Size * 16 do
            Map[x][z] = {}
            for y = 1, 48 do
                local BlockData: Types.BlockNoise = Perlin:CreateNoise((ChunkX + x), y, (ChunkZ + z), Biome.Amp, Biome.Scale)
                Map[x][z][y] = BlockData
            end
        end
    end
    return Map
end

function ChunkGenerator:GenerateChunk(XPos: number, ZPos: number, i: number, BlockMap: Types.BlockMap, Biome: Types.Biome, Actor): boolean
    task.synchronize()
    local Model = Instance.new("Model")
    Model.Parent = workspace
    Model.Name = "Chunk"..tostring(i)

    local Block = self.Import("Block", false)
    local ParallelPromise = self.Import("ParallelPromise", false)

        for x = 1, 16 do
            local Promise = ParallelPromise.new(function()
            for z = 1, 16 do
                for y = 1, 48 do
                    task.synchronize()
                    local Part = Instance.new("Part")
                    Part.Parent = Model
                    Part.Anchored = true
                    Part.Size = Vector3.new(4, 4, 4)
                    Part.Position = Vector3.new((XPos + x) * 4, y * 4, (ZPos + z) * 4)
                    Part.TopSurface = Enum.SurfaceType.Smooth
                    Part.BottomSurface = Enum.SurfaceType.Smooth
                    Part.Material = Enum.Material.SmoothPlastic
                    task.desynchronize()
                    local NewBlock = Block.new(Part.Position, 1, self.Modules.BlockType.new("Air", BrickColor.new("Medium stone grey"), 1))
                    task.synchronize()
                    NewBlock:SetBlockType(self.Modules.BlockType.new("Air", BrickColor.new("Medium stone grey"), 1))
                    task.desynchronize()
                end
            end
        end)
        spawn(function()
            task.desynchronize()
            Promise:RunOnce()
        end)
    end

    for x, Z in pairs(BlockMap) do
        local Promise = ParallelPromise.new(function()
            for z, Y in pairs(Z) do
                for y, Data in pairs(Y) do
                    if Data.Density < 20 then
                        task.synchronize()
                        local Part = Instance.new("Part")
                        Part.Parent = Model
                        Part.Anchored = true
                        Part.Size = Vector3.new(4, 4, 4)
                        Part.Position = Vector3.new((XPos + x) * 4, y * 4, (ZPos + z) * 4)
                        Part.TopSurface = Enum.SurfaceType.Smooth
                        Part.BottomSurface = Enum.SurfaceType.Smooth
                        Part.Material = Enum.Material.SmoothPlastic
                        task.desynchronize()
                        local NewBlock = Block.new(Part.Position, 1, self.Modules.BlockType.new("Air", BrickColor.new("Medium stone grey"), 1))
                        task.synchronize()
                        NewBlock:SetBlockType(self.Modules.BlockType.new("Air", BrickColor.new("Medium stone grey"), 1))
                        task.desynchronize()
                        local BlockType = Block.GetTerrainBlockType(BlockMap, x, z, y, Data, Biome)
                        task.synchronize()
                        NewBlock:SetBlockType(BlockType)
                        task.desynchronize()
                    end
                end
            end
        end)
        spawn(function()
            task.desynchronize()
            --Promise:RunOnce()
        end)
    end
end

return ChunkGenerator