--------LEAKED BY Friendly Man--------
--------leakforums.net/user-1034794--------
function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local range = 800

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(24, 32)

	local vBaseAng = Angle(0, 0, 0)
	local i = math.Rand(25, 65)
	for x=0, 360, 15 do
		local vVec = Vector(range * math.cos(x), range * math.sin(x), 0)
		vVec:Rotate(vBaseAng, 180)

		local particle = emitter:Add("particles/smokey", pos)
		particle:SetVelocity(vVec * math.Rand(0.5, 0.9))
		particle:SetDieTime(math.Rand(2.2, 3.2))
		particle:SetStartAlpha(math.random(100, 175))
		particle:SetEndAlpha(0)
		particle:SetStartSize(32)
		particle:SetEndSize(math.Rand(150, 200))
		particle:SetRoll(math.Rand(0, 359))
		-- particle:SetCollide(true)
		particle:SetBounce(0.2)
		particle:SetAirResistance(200)
		particle:SetColor(i, i, i)
	end

	emitter:Finish()

	self.Start = pos
	self.DieTime = CurTime() + 0.01
end

function EFFECT:Think()
	if (IsValid(self.Entity)) then
		dlight = DynamicLight(self.Entity:EntIndex())
		dlight.pos = self.Start
		dlight.r = 255
		dlight.g = 170
		dlight.b = 0
		dlight.Brightness = IsNight and 12 or 8
		dlight.Size = IsNight and 512 or 256
		dlight.Decay = 2000
		dlight.DieTime = CurTime() + 0.1
	end

	return CurTime() < self.DieTime
end

function EFFECT:Render()
end