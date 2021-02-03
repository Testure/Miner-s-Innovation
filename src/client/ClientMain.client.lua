local Modules = {}
local Started = false

repeat wait() until game:IsLoaded()

local Inject = {}

function Inject.Import(Module: ModuleScript | string): ({}?, boolean)
	if typeof(Module) == "string" then
		Module = game.ReplicatedStorage.Common:FindFirstChild(Module)
	end
	local Success, Table = InitalizeModule(Module)
	return Table, Success
end

function InitalizeModule(Module: ModuleScript): (boolean, {}?)
	local ReturnTable: {} = nil
	local Success: boolean, Error: string? = pcall(function()
		ReturnTable = require(Module)
	end)
	local Failed: boolean = false
	if Success then
		for i,b in pairs(Inject) do
			ReturnTable[i] = b
		end
	end
	if Success and not Error then
		if (ReturnTable["Init"] ~= nil and typeof(ReturnTable["Init"]) == "function") then
			Success, Error = pcall(function()
				ReturnTable["Init"](ReturnTable)
			end)
			if not Success and Error then
				Failed = true
			end
		end
	else
		Failed = true
	end
	if not Failed and (Started and (ReturnTable["Start"] ~= nil and typeof(ReturnTable["Start"]) == "function")) then
		Success, Error = pcall(function()
			ReturnTable["Start"](ReturnTable, Modules)
		end)
		if not Success and Error then
			Failed = true
		end
	end
	if Failed then
		warn(string.format("Failed to initalize module %s!", Module.Name))
		warn(Error or "Unknown error!")
	end
	return not Failed, ReturnTable
end

for _,v in pairs(script.Parent:GetChildren()) do
	if v:IsA("ModuleScript") then
		local Success, Module = InitalizeModule(v)
		if Success and Module then
			Modules[v.Name] = Module
		end
	end
end

for i,v in pairs(Modules) do
	local Success, Error = pcall(function()
		if (v["Start"] ~= nil and typeof(v["Start"]) == "function") then
			v:Start(Modules)
		end
	end)
	if Success and not Error then
		print(string.format("Module %s started!", i))
	elseif Error then
		warn(string.format("Failed to start module %s!", i))
		warn(Error)
	end
end
Started = true