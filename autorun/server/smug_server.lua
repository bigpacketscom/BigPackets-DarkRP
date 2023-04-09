if not file.Exists( "craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."/smuggletruck_location.txt", "DATA" ) then
	file.Write("craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."/smuggletruck_location.txt", "0;-0;-0;0;0;0", "DATA")
end

function RP_Smuggle_InitSpawn( ply )
	ply.SmuggleDelay = true
	
	umsg.Start("RP_Smuggle_TimerRestart", ply)
		umsg.Long(SMUG_CONFIG_DefaultSmuggleDelay)
	umsg.End()
	
	timer.Simple(SMUG_CONFIG_DefaultSmuggleDelay, function()
		if ply:IsValid() then
			ply.SmuggleDelay = false
		end
	end)
end
hook.Add("PlayerInitialSpawn", "RP_Smuggle_InitSpawn", RP_Smuggle_InitSpawn)

function RP_Smuggle_Confiscate( ply, Vehicle )
	if ply.CantUse then return end 
	local trace = ply:GetEyeTrace()
	if not trace.Entity:IsVehicle() then return end
	
	if table.HasValue( SMUG_CONFIG_ConfiscateTeams, team.GetName(ply:Team()) ) then
		if not ply.IsConfiscating then
			if Vehicle.IsSmuggling then
				local CarSpeed = math.Round( (( Vehicle:OBBCenter() - Vehicle:GetVelocity() ):Length() / 17.6 )/2)
				if CarSpeed <= 5 then
					GAMEMODE:Notify(ply, 1, 5, "You are confiscating illegal items. It will take 10 seconds. Make sure the vehicle stays close to you.")
					
					timer.Simple(0.0005, function() 
						if ply:InVehicle() then
							ply:ExitVehicle()
							ply:SetPos( Vehicle:GetPos() + Vector(20,-250,20) ) 
						end
					end)
					
					ply.IsConfiscating = true
					timer.Simple(10, function()
						local tr = ply:GetEyeTrace()
						local vehtrace = tr.Entity
							
						if vehtrace:GetClass() == "prop_vehicle_jeep" and ply:GetPos():Distance(Vehicle:GetPos()) < 150 then
							GAMEMODE:Notify(ply, 1, 5, "You've succesfully confiscated illegal goods. You've been rewarded $"..SMUG_CONFIG_ConfiscateReward..".")
							for k, v in pairs(ents.GetAll()) do
								if v:GetClass() == "smuggle_item" then
									if v.Owner == ply:EntIndex() then
										v:Remove()
									end
								end
							end
							
							Vehicle.IsSmuggling = false
							Vehicle:Remove()
							
							ply:AddMoney( SMUG_CONFIG_ConfiscateReward )
							ply.IsConfiscating = false
						else
							GAMEMODE:Notify(ply, 1, 5, "The vehicle you were trying to confiscate items from is no longer close enough.")
							ply.IsConfiscating = false
						end
					end)
				end
			end
		end
	end
end
hook.Add("PlayerUse", "RP_Smuggle_Confiscate", RP_Smuggle_Confiscate)

function RP_SmuggleTruck_Position( ply )
	if ply:IsAdmin() then
		local HisVector = string.Explode(" ", tostring(ply:GetPos()))
		local HisAngles = string.Explode(" ", tostring(ply:GetAngles()))
		
		file.Write("craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."/smuggletruck_location.txt", ""..(HisVector[1])..";"..(HisVector[2])..";"..(HisVector[3])..";"..(HisAngles[1])..";"..(HisAngles[2])..";"..(HisAngles[3]).."", "DATA")
		ply:ChatPrint("New position for the smuggle truck has been succesfully set. The new position is now in effect!")
	else
		ply:ChatPrint("Only administrators can perform this action")
	end
end
concommand.Add("smuggletruck_setpos", RP_SmuggleTruck_Position)

function RP_Smuggle_TakeDamage( ent, dmginfo )
	
	local inflictor = dmginfo:GetInflictor()
    local attacker = dmginfo:GetAttacker()
    local amount    = dmginfo:GetDamage()
	
	if ent:GetClass() == "prop_vehicle_jeep" then
		ent:SetHealth(ent:Health() - (dmginfo:GetDamage() * 10000))
		
		if ent:Health() <= 0 then
			if ent.IsSmuggling then
				local SmuggleExplosion = ents.Create("env_explosion")
				SmuggleExplosion:SetPos(ent:GetPos())
				SmuggleExplosion:Spawn()
				SmuggleExplosion:SetKeyValue("iMagnitude","75")
				SmuggleExplosion:Fire("Explode", 0, 0 )
					
				for k, v in pairs(ents.GetAll()) do
					if v:GetClass() == "smuggle_item" then
						if v.Owner == player.GetByID(ent:GetNWEntity( "Owner" )):EntIndex() then
							v:Remove()
						end
					end
				end
				
				ent.IsSmuggling = false
				ent:Remove()
					
				GAMEMODE:Notify(player.GetByID(ent:GetNWEntity( "Owner" )), 1, 5,  "Your vehicle has been exploded, your smuggled goods and your vehicle have perished.")
			end
		end
	end
end
hook.Add("EntityTakeDamage", "RP_Smuggle_TakeDamage", RP_Smuggle_TakeDamage)

util.AddNetworkString("RP_SmuggleItems")
net.Receive("RP_SmuggleItems", function(length, ply)
	local Item = net.ReadString()
	
	if ply.SmuggleDelay then 
		GAMEMODE:Notify(ply, 1, 5,  "Please wait "..string.ToMinutesSeconds(math.Round(SMUG_CONFIG_DefaultSmuggleDelay - CurTime())).." minutes before smuggling again!")
		return
	end
	
	if #player.GetAll() < SMUG_CONFIG_PlayersRequired then
		GAMEMODE:Notify(ply, 1, 5, "Minimum "..SMUG_CONFIG_PlayersRequired.." SMUG_CONFIG_PlayersRequired are required to smuggle!")
		return
	end
	
	if not table.HasValue( SMUG_CONFIG_SmuggleTeams, team.GetName(ply:Team()) ) then
		GAMEMODE:Notify(ply, 1, 5, "You are not allowed to smuggle items with your current team!")
		return
	end
	
	if ply:getDarkRPVar("money") >= Smuggle_Items[Item].BuyPrice then
		GAMEMODE:Notify(ply, 1, 5, "Succesfully purchased ".. Smuggle_Items[Item].Name ..". It's been placed in the back of the truck.")
		ply:AddMoney(Smuggle_Items[Item].BuyPrice * -1)
		ply.SmuggleDelay = true
		
		local PositionFile = file.Read("craphead_scripts/smuggle_system/".. string.lower(game.GetMap()) .."/smuggletruck_location.txt", "DATA")
		local ThePosition = string.Explode( ";", PositionFile )
		local TheVector = Vector(ThePosition[1], ThePosition[2], ThePosition[3])
		local TheAngle = Angle(tonumber(ThePosition[4]), ThePosition[5], ThePosition[6])

		local TheCar = ents.Create( "prop_vehicle_jeep" )
		TheCar:SetKeyValue( "vehiclescript", SMUG_CONFIG_VehicleScript )
		TheCar:SetPos( TheVector )
		TheCar:SetAngles( TheAngle )
		TheCar:SetRenderMode(RENDERMODE_TRANSADDFRAMEBLEND)
		TheCar:SetModel( SMUG_CONFIG_VehicleModel )
		TheCar:Spawn()
		TheCar:Activate()
		TheCar:SetHealth(Smuggle_Items[Item].Health) 
		TheCar:SetNWInt( "Owner", ply:EntIndex() )
		TheCar:Own( ply )
		
		TheCar.SmugglePackage = Item
		TheCar.IsSmuggling = true
					
		local SmuggleItem = ents.Create("smuggle_item")
		SmuggleItem:SetModel( Smuggle_Items[Item].Model )
		SmuggleItem:SetParent( TheCar )
		SmuggleItem:SetLocalPos( Smuggle_Items[Item].ItemVector )
		SmuggleItem:SetLocalAngles( Smuggle_Items[Item].ItemAngle )
		SmuggleItem.Owner = ply:EntIndex()
		SmuggleItem:Spawn()
								
		umsg.Start("RP_Smuggle_TimerRestart", ply)
			umsg.Long( Smuggle_Items[Item].SmuggleDelay )
		umsg.End()
				
		timer.Simple(Smuggle_Items[Item].SmuggleDelay, function()
			if ply:IsValid() then
				ply.SmuggleDelay = false
			end
		end)
	else
		GAMEMODE:Notify(ply, 1, 5, "You cannot afford to smuggle this item!")
	end
end)

function RP_SmuggleItems_Sell( ply )
	local CarFound = false
	local CarsChecked = 0

	for k, car in pairs(ents.FindInSphere(ply:GetPos(), 500)) do
		CarsChecked = CarsChecked + 1
		if car:IsVehicle() then
			if car:GetNWInt("Owner") == ply:EntIndex() then
				CarFound = true
				local Item = car.SmugglePackage
				
				if car.IsSmuggling then
					for k, v in pairs(ents.GetAll()) do
						if v:GetClass() == "smuggle_item" then
							if v.Owner == ply:EntIndex() then
								v:Remove()
							end
						end
					end
					
					GAMEMODE:Notify(ply, 1, 5, "Succesfully sold "..Smuggle_Items[Item].Name ..". You've earned $".. Smuggle_Items[Item].SellPrice .."!")
					ply:AddMoney( Smuggle_Items[Item].SellPrice )
					car.IsSmuggling = false
					car:Remove()
					break
				else
					GAMEMODE:Notify(ply, 1, 5, "You do not have any smuggle goods in your trunk!")
					break
				end
			end
		end
		
		if CarsChecked == #ents.FindInSphere(ply:GetPos(), 500) then
            if not CarFound then
				GAMEMODE:Notify(ply, 1, 5, "Your vehicle is not close enough to the NPC!")
            end
        end
	end				
end