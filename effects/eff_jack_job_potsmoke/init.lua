/*---------------------------------------------------------
	EFFECT:Init(data)
---------------------------------------------------------*/
function EFFECT:Init(data)
	local vOffset = data:GetOrigin()
	
	self.Pos=vOffset

	local Emitter=ParticleEmitter(vOffset)
	for i=0,40 do
		local sprite
		local chance=math.random(1,3)
		if(chance==1)then
			sprite="particle/smokestack"
		elseif(chance==2)then
			sprite="particles/smokey"
		elseif(chance==3)then
			sprite="particle/particle_smokegrenade"
		end
		local particle = Emitter:Add(sprite,vOffset)
		if(particle)then
			particle:SetVelocity(math.Rand(0,50)*VectorRand())
			particle:SetAirResistance(20)
			particle:SetDieTime(math.Rand(1,5))
			particle:SetStartAlpha(math.Rand(200,255))
			particle:SetEndAlpha(0)
			local Siz=math.Rand(1,30)
			particle:SetStartSize(Siz/2)
			particle:SetEndSize(Siz*2)
			particle:SetRoll(math.Rand(-3,3))
			particle:SetRollDelta(math.Rand(-2,2))
			particle:SetGravity(Vector(0,0,math.random(1,50)))
			particle:SetLighting(true)
			particle:SetColor(255,255,255)
			particle:SetCollide(false)
		end
	end
	Emitter:Finish()
end
/*---------------------------------------------------------
	EFFECT:Think()
---------------------------------------------------------*/
function EFFECT:Think()
	return false
end
/*---------------------------------------------------------
	EFFECT:Render()
---------------------------------------------------------*/
function EFFECT:Render()
	--no
end