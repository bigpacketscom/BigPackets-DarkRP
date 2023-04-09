ENT.Type = "anim"
ENT.PrintName = "Deployable Keypad Cracker"

ENT.Spawnable = false

ENT.Model = Model("models/weapons/w_c4_planted.mdl")
ENT.KeyCrackSound = Sound("buttons/blip2.wav")

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "StartTime")
	self:NetworkVar("Float", 1, "CompletionTime")
end