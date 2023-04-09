AddCSLuaFile();

ENT.Type = "anim";
ENT.PrintName = "Base Printer";
ENT.Category = "best printers";
ENT.Spawnable = true;
ENT.RenderGroup = RENDERGROUP_OPAQUE;

ENT.m_nMaxMoney = 10000;
ENT.m_MoneyGenTbl = {5, 20}; -- how much $ we should generate every m_flMoneyGenInterval (math.random(one, two))
ENT.m_flMoneyGenInterval = 0.1; -- delta between money generation in seconds...

ENT.m_nMaxHealth = 200;

ENT.m_Level = 60;
ENT.m_Volume = 0.8;

function ENT:SetupDataTables()

	self:NetworkVar("Entity", 0, "owning_ent");

end

function ENT:GetMaxMoney()

	return self.m_nMaxMoney;

end

function ENT:GetRandomMoneyAmount()

	return math.random(self.m_MoneyGenTbl[1], self.m_MoneyGenTbl[2]);

end

function ENT:GetMoneyGenInterval()

	return self.m_flMoneyGenInterval;

end

function ENT:GetMoney()

	return self:GetNWInt("m_iMoney", 0);

end

function ENT:SetMoney(iMoney)

	self:SetNWInt("m_iMoney", iMoney);

end

function ENT:AddMoney(iMoney)

	if(self:GetMoney() >= self:GetMaxMoney() && !self:IsOvercharged())
	then

		return;

	end

	self:SetMoney(self:GetMoney() + iMoney);

	if(!self:IsOvercharged())
	then

		self:SetMoney(math.Clamp(self:GetMoney(), 0, self:GetMaxMoney()));

	end

end

function ENT:IsOvercharged()

	return self:GetNWBool("m_bOvercharged", false);

end

function ENT:IsDueToExplode()

	return self:GetNWBool("m_bDueToExplode", false);

end

function ENT:GetExplodeTime()

	return self:GetNWFloat("m_flExplodeTime", 0);

end

function ENT:StartDeath()

	self:SetNWBool("m_bDueToExplode", true);
	self:SetNWFloat("m_flExplodeTime", CurTime() + math.Rand(5, 10));

end

function ENT:CancelDeath()

	self:SetNWBool("m_bDueToExplode", false);

end

function ENT:Think()

	if(CLIENT)
	then

		return;

	end

	if(self:IsDueToExplode())
	then

		if(CurTime() >= self:GetExplodeTime())
		then

			if(self:GetNWEntity("m_OurKiller", NULL):IsValid())
			then

				local _ply = self:GetNWEntity("m_OurKiller", NULL);
				_ply:addMoney(GAMEMODE.Config.printerreward);

				local _Lua = string.format("notification.AddLegacy(\"You were awarded %d$ for destroying a %s.\", NOTIFY_GENERIC, 4)", GAMEMODE.Config.printerreward, self.PrintName);
				_ply:SendLua(_Lua);

			end 

			local explode = ents.Create("env_explosion");
			explode:SetPos(self:GetPos());
			explode:SetOwner(self);
			explode:Spawn();
			explode:SetKeyValue("iMagnitude", "0");
			explode:Fire("Explode", 0, 0);

			self:Remove();

			return;

		end

	end

	self:AddMoney(self:GetRandomMoneyAmount());

	self:NextThink(CurTime() + self:GetMoneyGenInterval());
	return true;

end

function ENT:OnTakeDamage(dmg)

	self:SetHealth(self:Health() - dmg:GetDamage());

	if(self:Health() <= 0)
	then

		self:SetHealth(0);

		if(!self:IsDueToExplode())
		then

			self:StartDeath();
			self:Ignite(60, 20);

			if(dmg:GetAttacker():IsPlayer() && dmg:GetAttacker():isCP())
			then

				self:SetNWEntity("m_OurKiller", dmg:GetAttacker());

			else

				self:SetNWEntity("m_OurKiller", NULL);

			end

		end

	end

end

function ENT:Touch(ent)

	if(ent:GetClass() == "printer_repairkit")
	then

		if(self:Health() > 0)
		then

			return;

		end

		self:SetHealth(self:GetMaxHealth());

		self:CancelDeath();
		self:Extinguish();

		ent:Remove();

	end

end

function ENT:Use(activ, caller, usetype, value)

	if(!activ:IsPlayer())
	then

		return;

	end

	if(self:GetMoney() <= 0)
	then

		return;

	end

	local _Lua = string.format("notification.AddLegacy(\"You acquired %d$ from a %s.\", NOTIFY_GENERIC, 4)", self:GetMoney(), self.PrintName);
	activ:SendLua(_Lua);

	activ:addMoney(self:GetMoney());
	self:SetMoney(0);

end

local function GetColor(iCur, iMax)

	if((iCur / iMax) <= 0.3)
	then

		return Color(255, 0, 0);

	elseif((iCur / iMax) <= 0.6)
	then

		return Color(255, 255, 0);

	end

	return Color(0, 255, 0);

end

function ENT:Draw()

	self:DrawModel();

	local vAng = self:GetAngles();
	vAng:RotateAroundAxis(vAng:Up(), 90);

	cam.Start3D2D(self:GetPos() + self:GetAngles():Up() * 10.7, vAng, 0.15)

		surface.SetDrawColor(50, 50, 50);
		//surface.DrawRect(-101, -109, 205, 206);

		surface.SetFont("Trebuchet24");

		local tw, th = surface.GetTextSize(self.PrintName);
		surface.SetTextPos(-101 + 205 / 2 - tw / 2, -105);
		surface.SetTextColor(255, 255, 255);
		surface.DrawText(self.PrintName);

		surface.SetDrawColor(255, 255, 255);
		//surface.DrawLine(-90, -80, 94, -80);

		surface.SetFont("Trebuchet18");

		local tw, th = surface.GetTextSize("Money");
		surface.SetTextPos(-90, -70);
		surface.SetTextColor(255, 255, 255);
		surface.DrawText("Money");

		local tw, th = surface.GetTextSize(string.format("%d / %d", self:GetMoney(), self:GetMaxMoney()));
		surface.SetTextPos(94 - tw, -70);
		surface.SetTextColor(255, 255, 255);
		surface.DrawText(string.format("%d / %d", self:GetMoney(), self:GetMaxMoney()));

		surface.SetDrawColor(0, 0, 0);
		surface.DrawRect(-90, -50, 185, 12);

		surface.SetDrawColor(GetColor(self:GetMoney(), self:GetMaxMoney()));
		surface.DrawRect(-90, -50, (math.min(self:GetMoney(), self:GetMaxMoney()) / self:GetMaxMoney()) * 185, 12);

		surface.SetDrawColor(0, 0, 0);
		surface.DrawOutlinedRect(-90, -50, 185, 12);

		local tw, th = surface.GetTextSize("Health");
		surface.SetTextPos(-90, -30);
		surface.SetTextColor(255, 255, 255);
		surface.DrawText("Health");

		local tw, th = surface.GetTextSize(string.format("%d / %d", self:Health(), self:GetMaxHealth()));
		surface.SetTextPos(94 - tw, -30);
		surface.SetTextColor(255, 255, 255);
		surface.DrawText(string.format("%d / %d", self:Health(), self:GetMaxHealth()));

		surface.SetDrawColor(0, 0, 0);
		surface.DrawRect(-90, -10, 185, 12);

		surface.SetDrawColor(GetColor(self:Health(), self:GetMaxHealth()));
		surface.DrawRect(-90, -10, (math.min(math.max(0, self:Health()), self:GetMaxHealth()) / self:GetMaxHealth()) * 185, 12);

		surface.SetDrawColor(0, 0, 0);
		surface.DrawOutlinedRect(-90, -10, 185, 12);

		surface.SetFont("Trebuchet24");

		local tw, th = surface.GetTextSize("Owner:");
		surface.SetTextColor(Color(255, 255, 255));
		surface.SetTextPos(-101 + 205 / 2 - tw / 2, 45);
		surface.DrawText("Owner:");

		local _Owner = "Unknown";
		if(self:Getowning_ent():IsValid())
		then

			_Owner = self:Getowning_ent():Name();

		end

		surface.SetFont("Trebuchet18");

		local tw, th = surface.GetTextSize(string.format("%s", _Owner));
		surface.SetTextColor(Color(255, 255, 255));
		surface.SetTextPos(-101 + 205 / 2 - tw / 2, 70);
		surface.DrawText(string.format("%s", _Owner));

	cam.End3D2D();

end

function ENT:Initialize()

	if(CLIENT)
	then

		return;

	end

	self:SetModel("models/props_c17/consolebox01a.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);

	self:SetMaxHealth(self.m_nMaxHealth);
	self:SetHealth(self:GetMaxHealth());

	if(self:GetPhysicsObject():IsValid())
	then

		self:GetPhysicsObject():Wake();

	end

	self:SetUseType(SIMPLE_USE);

	self.m_Sound = CreateSound(self, "ambient/levels/labs/equipment_printer_loop1.wav");
	self.m_Sound:SetSoundLevel(self.m_Level);
	self.m_Sound:PlayEx(self.m_Volume, 100);

end

function ENT:OnRemove()

	if(CLIENT)
	then

		return;

	end

	if(self.m_Sound && self.m_Sound:IsPlaying())
	then

		self.m_Sound:Stop();

	end

end