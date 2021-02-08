local Module = {}
local Block = {}
Block.__index = Block

local Types = require(script.Parent.Types)

function Module.new(Position: Vector3, BlockState: number, BlockType: Types.BlockType): Types.Block
    local self = setmetatable({}, Block)
    self._Position = Position
    self._BlockState = BlockState
    self._BlockType = BlockType
    self._Instance = self:_FindInstance()
    return self
end

function Block:GetPosition(): Vector3
    return self._Position
end

function Block:GetBlockState(): number
    return self._BlockState
end

function Block:GetBlockType(): Types.BlockType
    return self._BlockType
end

function Block:SetBlockState(BlockState: number)
    self._BlockState = BlockState
end

function Block:SetBlockType(BlockType: Types.BlockType)
    self._BlockType = BlockType
    if self._Instance ~= nil then
        self._Instance.BrickColor = BlockType:GetColor()
        self._Instance.Transparency = BlockType:GetTransparency()
        if BlockType:GetName() == "Air" then
            self._Instance.CanCollide = false
        else
            self._Instance.CanCollide = true
        end
    end
end

function Block:_FindInstance(): Instance?
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart")then
            if v.Position == self:GetPosition() then
                return v
             end
        end
    end
    return nil
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

function Module.GetTerrainBlockType(BlockMap: Types.BlockMap, x: number, z: number, y: number, Data: Types.BlockNoise, Biome: Types.Biome): Types.BlockType
    local SurfaceBlock, AboveBlock = IsSurfaceBlock(BlockMap, x, z, y)
    local SubSurfaceBlock = false

    if not SurfaceBlock and AboveBlock then
        if IsSurfaceBlock(BlockMap, x, z, AboveBlock) then
            SubSurfaceBlock = true
        end
    end

    if SurfaceBlock then
        return Biome.SurfaceBlock
    elseif SubSurfaceBlock then
        return Biome.SubSurfaceBlock
    else
        return Biome.UndergroundBlock
    end
end

return Module