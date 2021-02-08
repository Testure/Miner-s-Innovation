local Module = {}
local BlockType = {}
BlockType.__index = BlockType

local Types = require(script.Parent.Types)
local CustomEnum = require(script.Parent.CustomEnum)
local BlockTypes = CustomEnum.new({})

function Module.new(Name: string, Color: BrickColor, Transparency: number): Types.BlockType
    local self = setmetatable({}, BlockType)
    self._Color = Color
    self._Name = Name
    self._Transparency = Transparency
    return self
end

function BlockType:GetName(): string
    return self._Name
end

function BlockType:GetColor(): BrickColor
    return self._Color
end

function BlockType:GetTransparency(): number
    return self.Transparency
end

function Module:Init(Modules)
    for _,v in pairs(Modules.Registration:GetRegistry("BlockTypes")) do
        BlockTypes:AddItem(v:GetName())
    end
    BlockTypes:Finalize()
    self.BlockTypes = BlockTypes.Items
end

function Module.FindBlockTypeByName(Registry: {Types.BlockType}, Name: string): Types.BlockType?
    for _,v in pairs(Registry) do
        if v:GetName() == Name then
            return v
        end
    end
    return nil
end

return Module