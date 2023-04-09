MsgN("Packet Bank 1 7 8")

if (SERVER) then
    AddCSLuaFile("bank_config.lua")
    include("bank_config.lua")
	
	util.PrecacheSound("siren.wav")
else	
	include("bank_config.lua")
end
