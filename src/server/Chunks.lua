local Chunks = {}
Chunks.ChunkMap = {}

local Types = require(game.ReplicatedStorage.Common.Types)

function Chunks:Init(Modules: {{}})
    Chunks.ChunkMap = Modules.ChunkGenerator:GenerateChunkMap(48)
end

function Chunks:Start(Modules: {{}})

end

return Chunks