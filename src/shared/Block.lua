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
            self._Instance.Transparency = 1
        else
            self._Instance.CanCollide = true
            self._Instance.Transparency = 0
        end
    end
end

function Block:_FindInstance(): Instance?
    for _,v in pairs(workspace.Chunks:GetChildren()) do
        local Part = v:FindFirstChild(string.format("Block %d %d %d", self._Position.X, self._Position.Y, self._Position.Z))
        if Part ~= nil then
            return Part
        end
    end
    return nil
end

function IsSurfaceBlock(BlockMap: Types.BlockMap, x: number, z: number, y: number): (boolean, number?)
    local Bool: boolean, Above: number?
    for X, Next in pairs(BlockMap) do
        for Z, NextZ in pairs(Next) do
            for Y, DataY in pairs(NextZ) do
                if X == x and Z == z and Y == y then
                    Bool = DataY.IsSurfaceBlock
                    Above = DataY.AboveBlock
                    break
                end
            end
        end
    end
    return Bool, Above
end

function Module.GetTerrainBlockType(BlockMap: Types.BlockMap, x: number, z: number, y: number, Data: Types.BlockNoise, Biome: Types.Biome): Types.BlockType
    local SurfaceBlock, AboveBlock = Data.IsSurfaceBlock, Data.AboveBlock
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