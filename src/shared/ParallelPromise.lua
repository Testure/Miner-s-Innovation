local module = {}
local Promise = {}
Promise.__index = Promise

local IsServer = game:FindService("NetworkServer") ~= nil
local Player = game.Players.LocalPlayer

if script.Parent:IsA("Actor") then
	return function(func, ...)
		local Response
		local Args = {...}
		local Success, Error = pcall(function()
			task.desynchronize()
			Response = func(unpack(Args))
		end)
		task.synchronize()
		if not Success then
			warn(Error)
		end
		return Success, Error, Response
	end
end

function module.new(func)
	local self = setmetatable({}, Promise)
	self._Func = func
	self._Actor = Instance.new("Actor")
	if IsServer then
		self._Actor.Parent = game.ServerStorage
	elseif Player ~= nil then
		self._Actor.Parent = Player.PlayerScripts
	end
	self._Mod = script:Clone()
	self._Mod.Parent = self._Actor
	self._RunFunction = require(self._Mod)
	self.Done = false
	self.Returned = nil
	self.Error = nil
	return self
end

function Promise:Run(...)
	self.Done = false
	self.Error = nil
	self.Returned = nil
	local Success, Error, Response = self._RunFunction(self._Func, ...)
	if Success then
		self.Done = true
		self.Error = nil
		self.Returned = Response
		return
	else
		self.Done = true
		self.Error = Error
		self.Returned = nil
		return
	end
end

function Promise:RunOnce(...)
	local Success, Error, Response = self._RunFunction(self._Func, ...)
	if Success then
		self.Done = true
		self.Error = nil
		self.Returned = Response
	else
		self.Done = true
		self.Error = Error
		self.Returned = nil
	end
	self:_CleanUp()
	return self.Done, self.Error, self.Returned
end

function Promise:_CleanUp()
	self._Actor:Destroy()
end

return module