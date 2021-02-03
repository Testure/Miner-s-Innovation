local module = {}

export type ChunkMap = {
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

return module