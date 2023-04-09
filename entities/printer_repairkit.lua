AddCSLuaFile();

ENT.Type = "anim";
ENT.PrintName = "Printer Repair Kit";
ENT.Category = "best printers";
ENT.Spawnable = true;
ENT.RenderGroup = RENDERGROUP_OPAQUE;

function ENT:Initialize()

	if(CLIENT)
	then

		return;

	end

	self:SetModel("models/props_lab/reciever01d.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);

	if(self:GetPhysicsObject():IsValid())
	then

		self:GetPhysicsObject():Wake();

	end

end