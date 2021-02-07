local Module = {}
local Block = {}
Block.__index = Block

function Module.new(Position: Vector3)
    local self = setmetatable({}, Block)
    self._Position = Position
    return self
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

function Module.GetTerrainBlockType(BlockMap: Types.BlockMap, x: number, z: number, y: number, Data: Types.BlockNoise, Biome: Types.Biome): BrickColor
    local SurfaceBlock, AboveBlock = IsSurfaceBlock(BlockMap, x, z, y)
    local SubSurfaceBlock = false

    if not SurfaceBlock and AboveBlock then
        if IsSurfaceBlock(BlockMap, x, z, AboveBlock) then
            SubSurfaceBlock = true
        end
    end

    if SurfaceBlock then
        return BrickColor.new("Shamrock")
    elseif SubSurfaceBlock then
        return BrickColor.new("Brown")
    else
        return BrickColor.new("Dark stone grey")
    end
end

return Module