local Player = FindMetaTable("Player");

function Player:SetInAir(bInAir)

	self:SetNW2Bool("m_bInAir", bInAir);

end

function Player:GetInAir()

	return self:GetNW2Bool("m_bInAir", false);

end

function Player:SetHasLandedThisTick(bLanded)

	self:SetNW2Bool("m_bHasLandedThisTick", bLanded);

end

function Player:GetHasLandedThisTick()

	return self:GetNW2Bool("m_bHasLandedThisTick", false);

end

hook.Add("SetupMove", "bh0pb00st", function(ply, mv, cmd)

	if(!IsFirstTimePredicted())
	then

		//return;

	end

	if(ply:GetHasLandedThisTick() && !ply:IsOnGround())
	then

		mv:SetVelocity(mv:GetVelocity() + Vector(mv:GetVelocity().x * 0.25, 0, 0));

	end

	if(!ply:IsOnGround())
	then

		ply:SetInAir(true);

	end

	if(ply:GetHasLandedThisTick())
	then

		ply:SetHasLandedThisTick(false);

	end

	if(ply:IsOnGround() && ply:GetInAir())
	then

		ply:SetHasLandedThisTick(true);

	end

	if(ply:IsOnGround())
	then

		ply:SetInAir(false);

	end

end);