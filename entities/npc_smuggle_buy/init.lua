AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function SpawnSmuggleBuyNPC()	
	if not file.IsDir("craphead_scripts", "DATA") then
		file.CreateDir("craphead_scripts", "DATA")
	end
	
	if not file.IsDir("craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."", "DATA") then
		file.CreateDir("craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."", "DATA")
	end
	
	if not file.Exists( "craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."/smugglenpc_location_buy.txt", "DATA" ) then
		file.Write("craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."/smugglenpc_location_buy.txt", "0;-0;-0;0;0;0", "DATA")
	end
	
	local PositionFile = file.Read("craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."/smugglenpc_location_buy.txt", "DATA")
	 
	local ThePosition = string.Explode( ";", PositionFile )
		
	local TheVector = Vector(ThePosition[1], ThePosition[2], ThePosition[3])
	local TheAngle = Angle(tonumber(ThePosition[4]), ThePosition[5], ThePosition[6])
		
	local SmuggleBuyNPC = ents.Create("npc_smuggle_buy")
	SmuggleBuyNPC:SetModel(SMUG_CONFIG_NPCSellModel)
	SmuggleBuyNPC:SetPos(TheVector)
	SmuggleBuyNPC:SetAngles(TheAngle)
	SmuggleBuyNPC:Spawn()
	SmuggleBuyNPC:SetMoveType(MOVETYPE_NONE)
	SmuggleBuyNPC:SetSolid( SOLID_BBOX )
	SmuggleBuyNPC:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		
	local Indicator = ents.Create("npc_indicator")
	Indicator:SetPos( SmuggleBuyNPC:GetPos() + (SmuggleBuyNPC:GetUp() * 90) )
	Indicator:SetParent( SmuggleBuyNPC )
	Indicator:SetAngles( SmuggleBuyNPC:GetAngles() )
	Indicator:Spawn()
	Indicator:SetCollisionGroup(COLLISION_GROUP_WORLD)

end
timer.Simple(1, SpawnSmuggleBuyNPC)

function CH_SmuggleBuy_Position( ply )
	if ply:IsAdmin() then
		local HisVector = string.Explode(" ", tostring(ply:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ply:GetAngles()))
		
		file.Write("craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."/smugglenpc_location_buy.txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA")
		ply:ChatPrint("New position for the buy NPC has been succesfully set. Please restart your server!")
	else
		ply:ChatPrint("Only administrators can perform this action")
	end
end
concommand.Add("smugglebuynpc_setpos", CH_SmuggleBuy_Position)

function ENT:AcceptInput(ply, caller)
	if caller:IsPlayer() && !caller.CantUse && !caller.MenuOpen then
		caller.CantUse = true
		caller.MenuOpen = true
		timer.Simple(3, function()  caller.CantUse = false end)

		if caller:IsValid() then
			umsg.Start( "RP_SmuggleBuyMenu", caller )
			umsg.End()
		end
	end
end

util.AddNetworkString("CH_CloseSmuggleBuyMenu")
net.Receive("CH_CloseSmuggleBuyMenu", function(length, ply)
	ply.MenuOpen = false
end)