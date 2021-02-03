--[[
local Size = 15
math.randomseed(os.time())
local Promise = require(game.ReplicatedStorage.ParallelPromise)

local PositionGrid = {}
local Done = false

for chunkX = 0, 15 do
	PositionGrid[chunkX] = {}
	for chunkZ = 0, 15 do
		local ChunkPromise = Promise.new(function(ChunkX: number, ChunkZ: number)
			local Grid = {}
			for x = 0, Size do
				Grid[x] = {}
				for z = 0, Size do
					Grid[x][z] = Vector3.new(
						ChunkX*16*4 + x*4,
						math.floor(math.noise((16/10 * ChunkX) + x/10, (16/10 * ChunkZ) + z/10) * 4) * 4,
						ChunkZ*16*4 + z*4
					)
				end
			end
			return Grid
		end)
		PositionGrid[chunkX][chunkZ] = ChunkPromise
	end
end
task.desynchronize()
for chunkX, v in pairs(PositionGrid) do
	for chunkZ, b in pairs(v) do
		local _, _, Grid = b:RunOnce(chunkX, chunkZ)
		PositionGrid[chunkX][chunkZ] = Grid
		game.ReplicatedStorage.ChunkPosSet:FireAllClients(chunkX + chunkZ)
		if chunkX == 15 and chunkZ == 15 then
			Done = true
		end
	end
end
task.synchronize()

local Chunk = {}
Chunk.__index = Chunk

function Chunk.new(ChunkX: number, ChunkZ: number)
	local self = {_Instances = {}, _X = ChunkX, _Z = ChunkZ}
	setmetatable(self, Chunk)
	self._TreeCount = 0
	self._LastTree = nil
	
	local Model = Instance.new("Model")
	Model.Parent = workspace
	Model.Name = "Chunk"..tostring(ChunkX)..tostring(ChunkZ)
	self._Model = Model
	
	for x = 0, Size do
		for z = 0, Size do
			local Pos = PositionGrid[ChunkX][ChunkZ][x][z]
			local Part = Instance.new("Part")
			Part.Name = "Part"..tostring(x).." "..tostring(z)
			Part.Parent = Model
			Part.Anchored = true
			Part.Size = Vector3.new(4, 4, 4)
			Part.Position = Pos
			Part.BottomSurface = Enum.SurfaceType.Smooth
			Part.TopSurface = Enum.SurfaceType.Smooth
			Part.Material = Enum.Material.Grass
			Part.BrickColor = BrickColor.new("Medium green")
			if self._TreeCount < 5 then
				local Chance = math.random(1, 15)
				if Chance == 1 then
					if self._LastTree == nil or (Part.Position - self._LastTree.Position).Magnitude >= 16 then
						Instance.new("BoolValue", Part).Name = "TreePart"
						self._TreeCount += 1
						self._LastTree = Part
					end
				end
			end
			table.insert(self._Instances, Part)
		end
	end
	
	for	_,v in pairs(self._Instances) do
		if v:FindFirstChild("TreePart") then
			v.TreePart:Destroy()
			local Tree = game.ReplicatedStorage.Tree:Clone()
			Tree.Parent = workspace.Trees
			Tree:SetPrimaryPartCFrame(CFrame.new(v.Position.X, v.Position.Y + 4, v.Position.Z))
		end
	end
	return self
end

function Chunk:LoadRest(x)
	task.desynchronize()
	for z = 0, Size do
		local Block = self._Model:FindFirstChild("Part"..tostring(x).." "..tostring(z))
		local X, Z = Block.Position.X, Block.Position.Z
		local y = 0
		repeat wait()
			y += 1
			local Y = Block.Position.Y - (4 * y)
			task.synchronize()
			local Part = Instance.new("Part")
			Part.Name = Block.Name..tostring(Y)
			Part.Parent = self._Model
			Part.Anchored = true
			Part.Size = Vector3.new(4, 4, 4)
			Part.Position = Vector3.new(X, Y, Z)
			Part.BottomSurface = Enum.SurfaceType.Smooth
			Part.TopSurface = Enum.SurfaceType.Smooth
			Part.Material = Enum.Material.Slate
			Part.BrickColor = BrickColor.new("Medium stone grey")
			task.desynchronize()
		until self._Model:FindFirstChild(Block.Name..tostring(-(8 * 4))) ~= nil
	end
	task.synchronize()
end

function Chunk:Destroy()
	for _,v in pairs(self._Instances) do
		v:Destroy()
	end
end

repeat wait() until PositionGrid[15][15] ~= nil and Done
local c = nil
local Chunks = {}

local function Generate()
	for x = 0, 15 do
		for z = 0, 15  do
			table.insert(Chunks, Chunk.new(x, z))
		end
	end

	for i,v in pairs(Chunks) do
		game.ReplicatedStorage.ChunkDoneish:FireAllClients(i)
		for x = 0, Size do
			local ChunkPromise = Promise.new(v.LoadRest)
			
			spawn(function()
				ChunkPromise:RunOnce(v, x)
				game.ReplicatedStorage.ChunkDone:FireAllClients(i)
			end)
		end
	end
end
game.ReplicatedStorage.Generate.OnServerEvent:Connect(Generate)
]]