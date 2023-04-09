if(SERVER)
then

	local _Spawns;

	local _filename = string.format("%s_zombiespawns.txt", game.GetMap());

	if(file.Exists(_filename, "DATA"))
	then
		_Spawns = util.JSONToTable(file.Read(_filename, "DATA"));

		for k, v in next, _Spawns do

			v["curzombies"] = 0;
			v["zombies"] = {};

			if(type(k) == "number")
			then

				_Spawns[tostring(k)] = v;
				_Spawns[k] = nil;

			end

		end
	end

	if(!_Spawns) then _Spawns = {}; end

	local function SaveSpawns()
		file.Write(_filename, util.TableToJSON(_Spawns));
	end

	concommand.Add("zombie_addspawn", function(ply, cmd, args, argstr)

		if(!ply:IsAdmin())
		then
		
			return;

		end

		if(#args == 0)
		then

			ply:ChatPrint("usage: zombie_addspawn <identifier> <maxzombies>");
			return;

		end

		if(#args != 2)
		then

			ply:ChatPrint("failed");
			return;

		end

		_Spawns[args[1]] = {

			["pos"] = ply:GetPos(),
			["maxzombies"] = tonumber(args[2]);

		};

		SaveSpawns();

	end);

	concommand.Add("zombie_removespawn", function(ply, cmd, args, argstr)

		if(!ply:IsAdmin())
		then

			return;

		end

		if(#args == 0)
		then

			ply:ChatPrint("usage: zombie_removespawn <identifier>");
			return;

		end

		if(#args != 1)
		then

			ply:ChatPrint("failed");
			return;

		end

		if(_Spawns[tostring(args[1])] == nil)
		then

			ply:ChatPrint("no such spawner");
			return;

		end

		_Spawns[tostring(args[1])] = nil;
		ply:ChatPrint("successfully removed");

		SaveSpawns();

	end);

	concommand.Add("zombie_gotospawn", function(ply, cmd, args, argstr)

		if(!ply:IsAdmin())
		then

			return;

		end

		if(#args == 0)
		then

			ply:ChatPrint("usage: zombie_gotospawn <identifier>");
			return;

		end

		if(!_Spawns[tostring(args[1])])
		then

			return;

		end

		ply:SetPos(_Spawns[tostring(args[1])]["pos"]);

	end);

	concommand.Add("zombie_listspawns", function(ply, cmd, args, argstr)

		if(!ply:IsAdmin())
		then

			return;

		end

		for k,v in next, _Spawns do

			ply:ChatPrint(string.format("%s = %d (%f, %f, %f)", k, v["maxzombies"], v["pos"].x, v["pos"].y, v["pos"].z));

		end

	end);

	hook.Add("Think", "zombiem3n", function()

		for k,v in next, _Spawns do

			if(v["zombies"] == nil)
			then

				v["zombies"] = {};

			end

			if(v["curzombies"] == nil)
			then

				v["curzombies"] = 0;

			end

			if(v["curzombies"] > 0)
			then

				local idx = 1;
				while(true)
				do

					if(idx > v["curzombies"])
					then

						break;

					end

					if(v["zombies"][idx] == nil)
					then

						break;

					end

					if(!v["zombies"][idx]:IsValid())
					then

						table.remove(v["zombies"], idx);
						v["curzombies"] = v["curzombies"] - 1;

					else

						idx = idx + 1;

					end

				end

			end

			while(v["curzombies"] < v["maxzombies"])
			do

				local _type = math.random(1, 100);
				if(_type <= 5)
				then

					_type = "npc_poisonzombie";

				elseif(_type <= 15)
				then

					_type = "npc_fastzombie";

				else

					_type = "npc_zombie";

				end

				local newzombie = ents.Create(_type);
				newzombie:SetPos(v["pos"] + Vector(math.random(-200, 200), math.random(-200, 200), 0));
				newzombie:Spawn();
				v["zombies"][v["curzombies"] + 1] = newzombie;
				v["curzombies"] = v["curzombies"] + 1;

			end

		end

	end);

end