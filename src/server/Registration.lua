local Registration = {}

Registration.Registrys = {}

function Registration:AddRegistry(RegistryName: string)
    self.Registrys[RegistryName] = {}
end

function Registration:Register(RegistryName: string, RegistryItem: any)
    assert(self.Registrys[RegistryName] ~= nil, string.format("Registry %q does not exist.", RegistryName))
    if self.Registrys[RegistryName][1] ~= nil then
        assert(typeof(self.Registrys[RegistryName][1]) == typeof(RegistryItem), string.format("RegistryItem of type %q does not match registry '%s's' type.", tostring(typeof(RegistryItem)), RegistryName))
    end
    self.Registrys[RegistryName][#self.Registrys[RegistryName]+1] = RegistryItem
end

function Registration:GetRegistry(RegistryName: string): {any}
    assert(self.Registrys[RegistryName] ~= nil, string.format("Registry %q does not exist.", RegistryName))
    return self.Registrys[RegistryName]
end

return Registration