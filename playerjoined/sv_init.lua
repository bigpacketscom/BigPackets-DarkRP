AddCSLuaFile("cl_init.lua")
playerjoined = playerjoined or {}

playerjoined.AdminGroups = {"owner", "staffmanager", "superadmin", "admin", "moderator", "trialmod"} // edit this.
playerjoined.ConsoleUserPrint = false
playerjoined.ConsoleAdminPrint = false

util.AddNetworkString("playerjoinedAddChat")
util.AddNetworkString("playerjoinedAddConsole")
function playerjoinedAddChat(ply, ...)
  if CLIENT then
    chat.AddText(...)
  else
    if string.lower(ply) == "all" then
      net.Start("playerjoinedAddChat")
        net.WriteTable({...})
      net.Broadcast()
    elseif string.lower(ply) == "staff" then
      for k, v in pairs(playerjoined.AdminGroups) do
        for j, p in pairs(player.GetAll()) do
          if p:GetNWString("usergroup")== v then
              net.Start("playerjoinedAddChat")
                net.WriteTable({...})
              net.Send(p)
        end
      end
    end
    else
      Msg("No arguement for AddChat")
    end
  end
end

function playerjoined_consoleprint(ply, ...)
  if CLIENT then
    return
  else
    if string.lower(ply) == "all" then
      net.Start("playerjoinedAddConsole")
        net.WriteTable({...})
      net.Broadcast()
    elseif string.lower(ply) == "staff" then
      for k, v in pairs(playerjoined.AdminGroups) do
        for j, p in pairs(player.GetAll()) do
          if p:GetUserGroup()== v then
            net.Start("playerjoinedAddConsole")
              net.WriteTable({...})
            net.Send(p)
          end
        end
      end
    else
      MsgC("Error, no arguments.")
    end
  end
end

function playerJoined_connect(ply, ip)
  if playerjoined.ConsoleUserPrint == false then
    playerjoinedAddChat("all", Color(0, 100, 255), "[Server] ", Color(255, 255, 255, 255), ply.." has connected to the server.")
  else
    playerjoined_consoleprint("all", Color(0, 100, 255), "[Server] ", Color(255, 255, 255, 255), ply.." has connected to the server.")
  end
  if playerjoined.ConsoleAdminPrint == false then
    playerjoinedAddChat("staff", Color(255, 0, 0, 255), "[Admin] ", Color(255, 255, 255, 255), ply.." connected with IP: "..ip)
  else
    playerjoined_consoleprint("staff", Color(255, 0, 0, 255), "[Admin] ", Color(255, 255, 255, 255), ply.." connected with IP: "..ip)
  end
end
hook.Add("PlayerConnect", "playerjoined_plyconnect", playerJoined_connect)

function playerJoined_plyspawned(ply)
  local name = ply:Nick()
  local id = ply:SteamID()
  local ip = ply:IPAddress()
  if playerjoined.ConsoleUserPrint == false then
    playerjoinedAddChat("all", Color(0, 100, 255, 255), "[Server] ", Color(255, 255, 255, 255), name.." has spawned! ("..id..")")
  else
    playerjoined_consoleprint("all", Color(0, 100, 255, 255), "[Server] ", Color(255, 255, 255, 255), name.." has spawned! ("..id..")")
  end
  if playerjoined.ConsoleAdminPrint == false then
    playerjoinedAddChat("staff", Color(255, 0, 0, 255), "[Admin] ", Color(255, 255, 255, 255), name.." spawned IP: "..ip.." ID: "..id)
  else
    playerjoined_consoleprint("staff", Color(255, 0, 0, 255), "[Admin] ", Color(255, 255, 255, 255), name.." spawned IP: "..ip.." ID: "..id)
  end
end
hook.Add("PlayerInitialSpawn", "playerjoined_plyspawned", playerJoined_plyspawned)

function playerJoined_plydisconnect(ply)
  local name = ply:Nick()
  local id = ply:SteamID()
  local ip = ply:IPAddress()
  if playerjoined.ConsoleUserPrint == false then
    playerjoinedAddChat("all", Color(0, 100, 255, 255), "[Server] ", Color(255, 255, 255, 255), name.." has disconnected! ("..id..")")
  else
    playerjoined_consoleprint("all", Color(0, 100, 255, 255), "[Server] ", Color(255, 255, 255, 255), name.." has disconnected! ("..id..")")
  end

  if playerjoined.ConsoleAdminPrint == false then
    playerjoinedAddChat("staff", Color(255, 0, 0, 255), "[Admin] ", Color(255, 255, 255, 255), name.." disconnecte, IP: "..ip.." SteamID: "..id)
  else
    playerjoined_consoleprint("staff", Color(255, 0, 0, 255), "[Admin] ", Color(255, 255, 255, 255), name.." disconnected, IP: "..ip.." SteamID: "..id)
  end
end
hook.Add("PlayerDisonnected", "playerjoined_plydisconnected", playerJoined_plydisconnect)
