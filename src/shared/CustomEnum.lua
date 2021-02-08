local Module = {}
local CustomEnum = {}
CustomEnum.__index = CustomEnum

local Meta = {
    _metatable = {},
    __newindex = function()
        warn("Attempt to edit enum item")
    end,
    __index = function(self, i)
        if string.find(i, "_") then
            return nil
        end
        return rawget(self, "_FinalTable")[i]
    end,
    __tostring = function(self)
        return tostring(rawget(self, "_FinalTable"))
    end
}

local Types = require(script.Parent.Types)

function Module.new(Items: {string}): Types.CustomEnum
    local self = setmetatable({}, CustomEnum)
    self.Items = {}
    for _,v in pairs(Items) do
        self.Items[#self.Items+1] = v
    end
    self._Finalized = false
    return self
end

function CustomEnum:AddItem(Item: string)
    assert(not self._Finalized, "Can't edit a finalized Enum!")
    self.Items[#self.Items+1] = Item
end

function CustomEnum:Finalize()
    if self._Finalized then
        print("Enum already finalized!")
        return
    end
    self._Finalized = true
    self.Items._FinalTable = self.Items
    setmetatable(self.Items, Meta)
end

function CustomEnum:GetItems(): {string}
    return self.Items
end

return Module