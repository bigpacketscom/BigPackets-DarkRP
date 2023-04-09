ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Sun Lamp"
ENT.Author = "Jackarunda"
ENT.Spawnable = false
function ENT:SetupDataTables()
    self:NetworkVar("Bool",0,"Active")
end