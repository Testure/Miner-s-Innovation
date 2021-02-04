local module = {}

export type BlockMap = {
    [number]: {
        [number]: {
            [number]: BlockNoise
        }
    }
}
export type BlockNoise = {
    XNoise: number,
    YNoise: number,
    ZNoise: number,
    Density: number
}
export type ChunkMap = {
    [number]: {
        x: number,
        z: number,
        Blocks: BlockMap,
        Biome: Biome
    }
}
export type Biome = {
    Amp: number,
    Scale: number
}

return module