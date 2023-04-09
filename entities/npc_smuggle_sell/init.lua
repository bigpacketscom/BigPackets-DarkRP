AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function SpawnSmuggleSellNPC()	
	if not file.IsDir("craphead_scripts", "DATA") then
		file.CreateDir("craphead_scripts", "DATA")
	end
	
	if not file.IsDir("craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."", "DATA") then
		file.CreateDir("craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."", "DATA")
	end
	
	if not file.Exists( "craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."/smugglenpc_location_sell.txt", "DATA" ) then
		file.Write("craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."/smugglenpc_location_sell.txt", "0;-0;-0;0;0;0", "DATA")
	end
	
	local PositionFile = file.Read("craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."/smugglenpc_location_sell.txt", "DATA")
	 
	local ThePosition = string.Explode( ";", PositionFile )
		
	local TheVector = Vector(ThePosition[1], ThePosition[2], ThePosition[3])
	local TheAngle = Angle(tonumber(ThePosition[4]), ThePosition[5], ThePosition[6])
		
	local SmuggleSellNPC = ents.Create("npc_smuggle_sell")
	SmuggleSellNPC:SetModel(SMUG_CONFIG_NPCBuyModel)
	SmuggleSellNPC:SetPos(TheVector)
	SmuggleSellNPC:SetAngles(TheAngle)
	SmuggleSellNPC:Spawn()
	SmuggleSellNPC:SetMoveType(MOVETYPE_NONE)
	SmuggleSellNPC:SetSolid( SOLID_BBOX )
	SmuggleSellNPC:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		
	local Indicator = ents.Create("npc_indicator")
	Indicator:SetPos( SmuggleSellNPC:GetPos() + (SmuggleSellNPC:GetUp() * 90) )
	Indicator:SetParent( SmuggleSellNPC )
	Indicator:SetAngles( SmuggleSellNPC:GetAngles() )
	Indicator:Spawn()
	Indicator:SetCollisionGroup(COLLISION_GROUP_WORLD)

end
timer.Simple(1, SpawnSmuggleSellNPC)

function CH_SmuggleSell_Position( ply )
	if ply:IsAdmin() then
		local HisVector = string.Explode(" ", tostring(ply:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ply:GetAngles()))
		
		file.Write("craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."/smugglenpc_location_sell.txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA")
		ply:ChatPrint("New position for the sell NPC has been succesfully set. Please restart your server!")
	else
		ply:ChatPrint("Only administrators can perform this action")
	end
end
concommand.Add("smugglesellnpc_setpos", CH_SmuggleSell_Position)

function ENT:AcceptInput(ply, caller)
	if caller:IsPlayer() && !caller.CantUse then
		caller.CantUse = true
		timer.Simple(3, function()  caller.CantUse = false end)

		if caller:IsValid() then
			RP_SmuggleItems_Sell( caller )
		end
	end
end