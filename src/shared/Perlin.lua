local Perlin = {}
math.randomseed(os.time())

local Types = require(game.ReplicatedStorage.Common.Types)
Perlin.Seed = math.random(0, 10000000)

function Perlin:CreateNoise(x: number, y: number, z: number, Amp: number, Scale: number, Seed: number?): Types.BlockNoise
    if Seed then
        self.Seed = Seed
    end

    local BlockNoise: Types.BlockNoise = {XNoise = 0, YNoise = 0, ZNoise = 0, Density = 0}

    BlockNoise.XNoise = math.noise(y/Scale, z/Scale, self.Seed) * Amp
    BlockNoise.YNoise = math.noise(x/Scale, z/Scale, self.Seed) * Amp
    BlockNoise.ZNoise = math.noise(x/Scale, y/Scale, self.Seed) * Amp
    BlockNoise.Density = BlockNoise.XNoise + BlockNoise.YNoise + BlockNoise.ZNoise + y

    return BlockNoise
end

return Perlin