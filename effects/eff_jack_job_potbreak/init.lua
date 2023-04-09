/*---------------------------------------------------------
	EFFECT:Init(data)
---------------------------------------------------------*/
function EFFECT:Init(data)
	local vOffset = data:GetOrigin()
	
	self.Pos=vOffset

	local Emitter=ParticleEmitter(vOffset)
	for i=0,40 do
		local particle = Emitter:Add("effects/fleck_tile"..math.random(1,2),vOffset+VectorRand()*math.Rand(0,10))
		if(particle)then
			particle:SetVelocity(math.Rand(0,400)*VectorRand())
			particle:SetAirResistance(30)
			particle:SetDieTime(math.Rand(2,10))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			local Siz=math.Rand(1,7)
			particle:SetStartSize(Siz)
			particle:SetEndSize(Siz)
			particle:SetRoll(math.Rand(-3,3))
			particle:SetRollDelta(math.Rand(-2,2))
			particle:SetGravity(Vector(0,0,-600))
			particle:SetLighting(true)
			particle:SetColor(255,150,100)
			particle:SetCollide(true)
			particle:SetBounce(math.Rand(.1,.3))
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