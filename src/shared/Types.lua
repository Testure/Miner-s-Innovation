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
    Density: number,
    IsSurfaceBlock: boolean,
    AboveBlock: number | nil
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
    Scale: number,
    SurfaceBlock: BlockType,
    SubSurfaceBlock: BlockType,
    UndergroundBlock: BlockType
}
export type BlockType = {
    GetName: () -> (string),
    GetColor: () -> (BrickColor),
    GetTransparency: () -> (number),
    _Color: BrickColor,
    _Name: string,
    _Transparency: number
}
export type Block = {
    _Position: Vector3,
    _BlockState: number,
    _BlockType: BlockType,
    _Instance: Instance,
    GetPosition: () -> (Vector3),
    GetBlockState: () -> (number),
    GetBlockType: () -> (BlockType),
    SetBlockState: (number) -> (),
    SetBlockType: (BlockType) -> (),
    _FindInstance: () -> (Instance?)
}
export type CustomEnum = {
    Items: {string},
    GetItems: () -> ({string}),
    AddItem: (string) -> (),
    Finalize: () -> ()
}

return module