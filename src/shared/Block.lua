local Module = {}
local Block = {}
Block.__index = Block

function Module.new(Position: Vector3)
    local self = setmetatable({}, Block)
    self._Position = Position
    return self
end

function Module.GetTerrainBlockType(Position: Vector3, Part: Instance): BrickColor
    local IsTop = true
    local Params = RaycastParams.new()
    Params.FilterDescendantsInstances = {Part}
    Params.FilterType = Enum.RaycastFilterType.Blacklist
    local Result = workspace:Raycast(Position, Position - Vector3.new(Position.X, Position.Y - (16 * 4), Position.Z), Params)
    local Dirt = false
    if Result and Result.Instance then
        local NewResult = workspace:Raycast(Result.Instance.Position, Result.Instance.Position - Vector3.new(Result.Instance.Position.X, Result.Instance.Position.Y - (2 * 4), Result.Instance.Position.Z))
        if NewResult and NewResult.Instance and NewResult.Instance.BrickColor ~= BrickColor.new("Shamrock") then
            IsTop = false
        else
            Dirt = true
        end
    end
    --TODO: Change Logic
    if IsTop then
        return BrickColor.new("Shamrock")
    elseif Dirt and Position.Y >= (3 * 4) then
        return BrickColor.new("Brown")
    elseif Position.Y >= (8 * 4) then
        return BrickColor.new("Dark stone grey")
    else
        return BrickColor.new("Dark stone grey")
    end
end

return Module