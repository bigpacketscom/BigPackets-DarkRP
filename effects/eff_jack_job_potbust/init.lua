/*---------------------------------------------------------
	EFFECT:Init(data)
---------------------------------------------------------*/
function EFFECT:Init(data)
	local vOffset = data:GetOrigin()
	
	self.Pos=vOffset

	local Emitter=ParticleEmitter(vOffset)
	for i=0,50 do
		local particle = Emitter:Add("effects/fleck_tile"..math.random(1,2),vOffset+VectorRand()*math.Rand(0,10))
		if(particle)then
			particle:SetVelocity(math.Rand(0,100)*VectorRand())
			particle:SetAirResistance(60)
			particle:SetDieTime(math.Rand(1,5))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(255)
			local Siz=math.Rand(1,5)
			particle:SetStartSize(Siz)
			particle:SetEndSize(Siz)
			particle:SetRoll(math.Rand(-3,3))
			particle:SetRollDelta(math.Rand(-2,2))
			particle:SetGravity(Vector(0,0,-100))
			particle:SetLighting(true)
			particle:SetColor(175,200,150)
			particle:SetCollide(true)
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