local ChunkGenerator = {}

local Types = require(game.ReplicatedStorage.Common.Types)

function ChunkGenerator:Init()

end

function ChunkGenerator:Start(Modules: {{}})
    
end

function IsSurfaceBlock(BlockMap: Types.BlockMap, x: number, z: number, y: number): (boolean, number?)
    if y <= 1 then
        return false, y + 1
    end
    for X, Next in pairs(BlockMap) do
        for Z, NextZ in pairs(Next) do
            for Y, DataY in pairs(NextZ) do
                if DataY.Density < 20 then
                    if X == x and Z == z then
                        if Y > y then
                            if Y < (y * 2) then
                                return false, Y
                            end
                        end
                    end
                end
            end
        end
    end
    return true, nil
end

function ChunkGenerator:GenerateBlockMap(ChunkX: number, ChunkZ: number, Biome: Types.Biome): Types.BlockMap
    local Map: Types.BlockMap = {[1] = {[1] = {[1] = {XNoise = 0, YNoise = 0, ZNoise = 0, Density = 0}}}}
    local Size = 1
    local Perlin = self.Import("Perlin", false)

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
    for x, Z in pairs(Map) do
        for z, Y in pairs(Z) do
            for y, Data in pairs(Y) do
                local bool, above = IsSurfaceBlock(Map, x, z, y)
                if bool then
                    Data.IsSurfaceBlock = true
                    Data.AboveBlock = above
                else
                    Data.IsSurfaceBlock = false
                    Data.AboveBlock = above
                end
            end
        end
    end
    return Map
end

function ChunkGenerator:GenerateChunk(XPos: number, ZPos: number, i: number, BlockMap: Types.BlockMap, Biome: Types.Biome): boolean
    task.synchronize()
    local Model = Instance.new("Model")
    Model.Parent = workspace.Chunks
    Model.Name = "Chunk"..tostring(i)

    local Block = self.Import("Block", false)
    local ParallelPromise = self.Import("ParallelPromise", false)
    local Done = false

    for x = 1, 16 do
        --local Promise = ParallelPromise.new(function()
            for z = 1, 16 do
                for y = 1, 48 do
                    task.synchronize()
                    local Part = Instance.new("Part")
                    Part.Parent = Model
                    Part.Anchored = true
                    Part.Size = Vector3.new(4, 4, 4)
                    Part.Position = Vector3.new((XPos + x) * 4, y * 4, (ZPos + z) * 4)
                    Part.Name = string.format("Block %d %d %d", Part.Position.X, Part.Position.Y, Part.Position.Z)
                    Part.TopSurface = Enum.SurfaceType.Smooth
                    Part.BottomSurface = Enum.SurfaceType.Smooth
                    Part.Material = Enum.Material.SmoothPlastic
                    Part.Transparency = 1
                    Part.BrickColor = BrickColor.new("Medium stone grey")
                    task.desynchronize()
                end
            end
            Done = true
            --return true
        --end)
        --spawn(function()
            --task.desynchronize()
            --Promise:RunOnce()
        --end)
    end

    for x, Z in pairs(BlockMap) do
        repeat wait() until Done
        --local Promise = ParallelPromise.new(function()
            for z, Y in pairs(Z) do
                for y, Data in pairs(Y) do
                    if Data.Density < 20 then
                        local NewBlock = Block.new(Vector3.new((XPos + x) * 4, y * 4, (ZPos + z) * 4), 1, self.Modules.BlockType.new("Air", BrickColor.new("Medium stone grey"), 1))
                        local BlockType = Block.GetTerrainBlockType(BlockMap, x, z, y, Data, Biome)
                        task.synchronize()
                        NewBlock:SetBlockType(BlockType)
                        task.desynchronize()
                    end
                end
            end
            --return true
        --end)
        --spawn(function()
            --task.desynchronize()
            --Promise:RunOnce()
        --end)
    end
    return true
end

return ChunkGenerator