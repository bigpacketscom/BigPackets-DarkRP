ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Dumpster"
ENT.Author = "KittoniuM"
ENT.Category = "BigPackets.com"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "CooldownTime")
end