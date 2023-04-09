include("asb_config.lua")

if SERVER then
	util.AddNetworkString("ASBubble")
	util.AddNetworkString("ASBPLight")
	
	hook.Add("PlayerDeath", "ResetASB", function(ply, i, a)
		ply:Freeze(false)
		ply:GodDisable()

		ply:SetNWBool("AdminSit", false)
		ply:SetNWBool("InSit", false)
	end)
	
	concommand.Add("toggle_asb", function(ply)
		if table.HasValue(AllowedRanks, ply:GetUserGroup()) then
			if ply:GetNWBool("AdminSit") == false then
				ply:SetNWBool("AdminSit", true)
				
				ply:GodEnable()
			else
				ply:SetNWBool("AdminSit", false)
				
				ply:GodDisable()
			end
			
			net.Start("ASBubble")
				net.WriteBool(ply:GetNWBool("AdminSit"))
				net.WriteEntity(ply)
			net.Send(ply)
		end
	end)
	
	hook.Add("PlayerSay", "ASBChatCommand", function(ply, text, public)
		text = string.lower(text)
		if (string.sub(text, 1) == ChatCommand) then
			ply:ConCommand("toggle_asb")
			
			return false
		end
	end)
	
	hook.Add("PlayerTick", "BubbleDetect", function(ply)
		for k, v in pairs(player.GetAll()) do
			if ply:GetNWBool("AdminSit") == true then
				if v:GetNWBool("AdminSit") == false then
					if ply:GetPos():Distance(v:GetPos()) <= BubbleRadius then
						v:SetNWBool("InSit", true)
						
						if !table.HasValue(AllowedRanks, v:GetUserGroup()) then
							v:GodEnable()
							
							if FreezePlayers then
								v:Freeze(true)
							end
						end

						net.Start("ASBPLight")
							net.WriteEntity(v)
						net.Broadcast(v)
					else
						v:SetNWBool("InSit", false)
					
						if !table.HasValue(AllowedRanks, v:GetUserGroup()) then
							v:GodDisable()
							
							if FreezePlayers then
								v:Freeze(false)
							end
						end
					end
				end
			end
		end
	end)
end

if CLIENT then
	net.Receive("ASBubble", function(len)
		local bool = net.ReadBool()
		local v = net.ReadEntity()
		
		hook.Add("HUDPaint", "ASBNotifier", function()
			if bool == true then
				draw.SimpleText("Your Admin Sit Bubble is active.", "Trebuchet24", ScrW() / 2, 50, PlayerColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end)
		
		hook.Add("PostDrawOpaqueRenderables", "DrawASBubble", function()
			for _, ply in pairs(player.GetAll()) do
				if ply == v and bool == true then
					render.SetMaterial(Material("decals/light"))
					render.DrawSphere(ply:GetPos() + Vector(0, 0, 16), BubbleRadius, 20, 20, AdminColor)
					
					cam.Start3D2D(ply:GetPos() + Vector(0, 0, 40), Angle(0, 0, 0), 1)
						surface.DrawCircle(0, 0, BubbleRadius - 1, AdminColor)
					cam.End3D2D()
					
					local speed = 20 * FrameTime()
					
					cam.Start3D2D(ply:GetPos() + Vector(0, 0, 196), Angle(0, LocalPlayer():EyeAngles().y - 90, LocalPlayer():EyeAngles().r + 90), 1)
						if LocalPlayer() != ply then
							surface.SetFont("Trebuchet24")
							surface.SetTextColor(255, 255, 255, 255)
							surface.SetTextPos(-100, 0) 
							surface.DrawText("Admin Sit in Progress...")
						end
					cam.End3D2D()
				end
			end
		end)
		
		hook.Add("Think", "ASBPALight", function()
			if bool == true then
				local sl = DynamicLight(v:EntIndex())
				sl.pos = v:GetPos() + Vector(0, 0, 16)
				sl.r = AdminColor.r
				sl.g = AdminColor.g
				sl.b = AdminColor.b
				sl.brightness = 2
				sl.Decay = 0
				sl.Size = 256 * 2
				sl.Style = 2
				sl.DieTime = CurTime() + 1
				sl.nomodel = true
			end
		end)
	end)
	
	net.Receive("ASBPLight", function(len)
		local v = net.ReadEntity()
		
		local pl = DynamicLight(v:EntIndex())
		pl.pos = v:GetPos() + Vector(0, 0, 16)
		pl.r = PlayerColor.r
		pl.g = PlayerColor.g
		pl.b = PlayerColor.b
		pl.brightness = 2
		pl.Decay = 0
		pl.Size = 256 * 2
		pl.Style = 2
		pl.DieTime = CurTime() + 1
		pl.nomodel = true
	end)
end