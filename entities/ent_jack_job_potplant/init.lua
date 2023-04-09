AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
resource.AddFile("materials/mat_jack_job_potleaf.vmt")
resource.AddFile("materials/tex_jack_job_potleaf.vtf")
ENT.StageModels={
    {90,101,"models/nater/weedplant_pot_growing7.mdl"},
    {80,89,"models/nater/weedplant_pot_growing6.mdl"},
    {70,80,"models/nater/weedplant_pot_growing5.mdl"},
    {60,70,"models/nater/weedplant_pot_growing4.mdl"},
    {50,60,"models/nater/weedplant_pot_growing3.mdl"},
    {40,50,"models/nater/weedplant_pot_growing2.mdl"},
    {30,40,"models/nater/weedplant_pot_growing1.mdl"},
    {20,30,"models/nater/weedplant_pot_planted.mdl"},
    {10,20,"models/nater/weedplant_pot_dirt.mdl"},
    {0,10,"models/nater/weedplant_pot.mdl"}
}
ENT.JackyUprightCarry="y"
ENT.JackaJobNoPocket=true
function ENT:Initialize()
    self:SetModel("models/nater/weedplant_pot.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local Phys=self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMaterial("grass")
    Phys:SetMass(15)
    self.NextThink=0
    self:SetUseType(SIMPLE_USE)
    self:SetPlantHealth(100)
    self:SetHydration(50)
    self:SetStage(0)
end
function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)
    if((dmg:IsDamageType(DMG_BURN))or(dmg:IsDamageType(DMG_PLASMA)))then self:Ignite(30) end
    if(self:GetStage()<=10)then
        self:Break()
    else
        self:Deteriorate(dmg:GetDamage()*2)
    end
end
function ENT:PhysicsCollide(dat,ent)
    local Class,Stage=dat.HitEntity:GetClass(),self:GetStage()
    if((Class=="ent_jack_job_potsoil")and(Stage<10))then
        self:Soil(dat.HitEntity)
    elseif((Class=="ent_jack_job_weedseed")and(Stage>=10)and(Stage<20))then
        self:Plant(dat.HitEntity)
    end
    local Spd=(dat.OurOldVelocity-dat.TheirOldVelocity):Length()
    if((Spd>100)and(dat.DeltaTime>.2))then self:EmitSound("Pottery.ImpactHard") end
    if((Spd>750)and not(self:IsPlayerHolding()))then self:Break() end
end
function ENT:Think()
    local Time,ThinkRate=CurTime(),5
    if(self:GetStage()>=20)then
        if(self:CanGrow())then
            if(self:GetPlantHealth()>=100)then
                self:Grow(math.Rand(.1,.3)*ThinkRate)
                self:Dehydrate(math.Rand(.4,.7)*ThinkRate)
            else
                self:Repair(math.Rand(.2,.4)*ThinkRate)
                self:Dehydrate(math.Rand(.5,.8)*ThinkRate)
            end
        else
            self:Deteriorate(math.Rand(.2,.4)*ThinkRate)
        end
    end
    self:NextThink(Time+ThinkRate)
    return true
end
function ENT:Use(activator)
    if(self:GetStage()>90)then
        self:Harvest(activator)
    else
        activator:PickupObject(self)
    end
end
function ENT:OnRemove()
    --
end
function ENT:CanGrow()
    if((self:GetHydration()>0)and(self:GetUp().z>.25))then
        local PConts=util.PointContents(self:GetPos())
        if((PConts==CONTENTS_TESTFOGVOLUME)or(PConts==CONTENTS_EMPTY))then
            for key,item in pairs(ents.FindInSphere(self:GetPos(),120*self.Params.LampDistance))do
                if((item:GetClass()=="ent_jack_job_plantlamp")and(item:GetActive())and(self:Visible(item)))then
                    return true
                end
            end
        end
    end
    return false
end
function ENT:Harvest(ply)
    local SeedNum,WeedNum,Pos,Vel=math.Round(math.Rand(0,2.5)*self.Params.SeedYield),math.Round(math.Rand(2,4)*self.Params.CropYield),self:GetPos()+self:GetUp()*20,self:GetPhysicsObject():GetVelocity()
    for i=0,SeedNum do
        local Seed=ents.Create("ent_jack_job_weedseed")
        Seed.NoPlant=true
        Seed:SetPos(Pos+VectorRand()*math.random(1,10))
        Seed:SetAngles(VectorRand():Angle())
        Seed:Spawn()
        Seed:Activate()
        Seed:GetPhysicsObject():SetVelocity(Vel+Vector(0,0,math.random(10,60)))
    end
    for i=0,WeedNum do
        local Seed=ents.Create("ent_jack_job_weedbag")
        Seed:SetPos(Pos+VectorRand()*math.random(1,10))
        Seed:SetAngles(VectorRand():Angle())
        Seed:Spawn()
        Seed:Activate()
        Seed:GetPhysicsObject():SetVelocity(Vel+Vector(0,0,math.random(10,60)))
    end
    self:EmitSound("Grass.StepLeft")
    self:EmitSound("Grass.StepRight")
    self:DispatchEffect("potbust")
    if(math.random(1,5*self.Params.SoilLongevity)==1)then
        self:SetStage(0)
        self:UpdateModel()
    else
        self:Die()
    end
end
function ENT:Soil(soil)
    SafeRemoveEntity(soil)
    self:SetStage(10)
    self:SetHydration(50)
    self:UpdateModel()
    self:EmitSound("Dirt.Impact")
end
function ENT:Plant(seed)
    seed:Remove()
    self:SetStage(20)
    self:SetPlantHealth(100)
    self:UpdateModel()
    self:EmitSound("Dirt.Impact")
end
function ENT:Grow(amt)
    self:SetStage(math.Clamp(self:GetStage()+amt*self.Params.GrowthRate,20,100))
    self:UpdateModel()
end
function ENT:Repair(amt)
    self:SetPlantHealth(math.Clamp(self:GetPlantHealth()+amt*self.Params.GrowthRate,0,100))
end
function ENT:Dehydrate(amt)
    self:SetHydration(math.Clamp(self:GetHydration()-amt*self.Params.WaterNeed,0,100))
end
function ENT:Deteriorate(amt)
    self:SetPlantHealth(math.Clamp(self:GetPlantHealth()-amt/self.Params.Hardiness,0,100))
    if(self:GetPlantHealth()<=0)then self:Die() end
end
function ENT:Die()
    self:SetStage(10)
    self:UpdateModel()
end
function ENT:Break()
    self:EmitSound("Pottery.Break")
    self:DispatchEffect("potbreak")
    if(self:GetStage()>=30)then
        self:EmitSound("Grass.StepLeft")
        self:EmitSound("Grass.StepRight")
        self:DispatchEffect("potbust")
    end
    self:Remove()
end
function ENT:DispatchEffect(eff)
    local EffDat=EffectData()
    EffDat:SetOrigin(self:GetPos()+self:GetUp()*10)
    util.Effect("eff_jack_job_"..eff,EffDat,true,true)
end
function ENT:UpdateModel()
    local CurMod,NewMod,Stage=self:GetModel(),"",self:GetStage()
    for key,mod in pairs(self.StageModels)do
        if((Stage>=mod[1])and(Stage<mod[2]))then
            NewMod=mod[3]
            break
        end
    end
    if(NewMod!=CurMod)then
        local Pos,Ang,Vel=self:GetPos(),self:GetAngles(),self:GetPhysicsObject():GetVelocity()
        self:SetModel(NewMod)
        self:SetPos(Pos)
        self:SetAngles(Ang)
        self:GetPhysicsObject():SetVelocity(Vel)
    end
end
hook.Add("GetPreferredCarryAngles","JackaJobPotCarry",function(ent)
    if(ent.JackyUprightCarry)then
        local Angel=Angle(0,0,0)
        Angel[ent.JackyUprightCarry]=0
        return Angel
    end
end)
--[[--------------------------------------------------------------
--                             NPC                              --  
----------------------------------------------------------------]]
local NPCSpawns,DatNPC=NPCSpawns or nil,DatNPC or nil
local function LoadNPCSpawns()
    local Jason=file.Read("weednpclocations/"..game.GetMap()..".txt")
	if(Jason)then
        local Tab=util.JSONToTable(Jason)
        if(#Tab>0)then NPCSpawns=Tab end
    end
end
util.AddNetworkString("JackaJobWeedDealerID")
hook.Add("PlayerSpawn","JackaJobWeedDealerID",function(ply)
	if(DatNPC)then
		net.Start("JackaJobWeedDealerID")
		net.WriteEntity(DatNPC)
		net.Send(ply)
	end
end)
hook.Add("PlayerInitialSpawn","JackaJobWeedNPCSpawn",function(ply)
    LoadNPCSpawns()
    if((NPCSpawns)and not(IsValid(DatNPC)))then
        local Point=table.Random(NPCSpawns)
        DatNPC=ents.Create("npc_citizen")
        DatNPC:SetPos(Point[1])
        DatNPC:SetAngles(Point[2])
        DatNPC:SetKeyValue("spawnflags","16384")
        DatNPC:Spawn()
        DatNPC:Activate()
        DatNPC.JackaJobNPCDealer=true
        DatNPC:SetUseType(SIMPLE_USE)
    else
        print("No set spawn locations for NPC marijuana buyer for this map. NPC not spawned.")
    end
end)
hook.Add("EntityTakeDamage","JackaJobWeedDealerDamage",function(ent,info)
	if(ent.JackaJobNPCDealer)then info:SetDamage(0) end
end)
local NextMove=0
hook.Add("Think","JackaJobNPCMove",function()
    local Time=CurTime()
    if(NextMove<Time)then
        NextMove=Time+JackaJob_WeedBuyerNPCMoveTime
        if(DatNPC)then
            local Point=table.Random(NPCSpawns)
			DatNPC:SetLastPosition(Point[1])
			DatNPC:SetSchedule(SCHED_FORCED_GO_RUN)
			timer.Simple(10,function()
				DatNPC:SetPos(Point[1])
				DatNPC:SetAngles(Point[2])
			end)
        end
    end
end)
hook.Add("KeyPress","JackaJobWeedSelling",function(ply,key)
    if(key==IN_USE)then
        local Tr=ply:GetEyeTraceNoCursor()
        if((Tr.Hit)and(Tr.Entity.JackaJobNPCDealer)and((Tr.HitPos-ply:GetShootPos()):Length()<70))then
            local Tab,Num=ply.darkRPPocket or {},0
            for key,item in pairs(Tab)do
                if(item.Class=="ent_jack_job_weedbag")then
                    local Bag=ply:dropPocketItem(key)
                    if(Bag)then SafeRemoveEntity(Bag) end
                    Num=Num+1
                end
            end
            if(Num>0)then
                local IllegallyGottenCash=Num*JackaJob_WeedSellPrice
                ply:addMoney(IllegallyGottenCash)
                local Path,Approval="vo/npc/male01/",{"nice.wav","fantastic01.wav","fantastic02.wav"}
                if(string.find(Tr.Entity:GetModel(),"female"))then
                    Path="vo/npc/female01/"
                    Approval={"nice01.wav","nice02.wav","fantastic01.wav","fantastic02.wav"}
                end
                Tr.Entity:EmitSound(Path..table.Random(Approval),65,100)
                timer.Simple(1.5,function() Tr.Entity:EmitSound(Path.."answer10.wav",60,100) end)
                timer.Simple(3.5,function() Tr.Entity:EmitSound(Path.."illstayhere01.wav",70,100) end)
                DarkRP.notify(ply,4,4,"Sold marijuana for $"..tostring(IllegallyGottenCash))
            end
        end
    end
end)
concommand.Add("marijuana_npc_buyer_location",function(ply)
    if(ply:IsAdmin())then
        if not(NPCSpawns)then NPCSpawns={} end
        table.insert(NPCSpawns,{ply:GetPos(),Angle(0,ply:EyeAngles().y,0)})
        local Jason=util.TableToJSON(NPCSpawns)
        if(Jason)then
            if not(file.Exists("weednpclocations/","DATA"))then file.CreateDir("weednpclocations") end
            file.Write("weednpclocations/"..game.GetMap()..".txt",Jason)
            print("Updated spawn table with "..tostring(#NPCSpawns).." locations written to weednpclocations/"..game.GetMap()..".txt")
        end
    else
        ply:PrintMessage(HUD_PRINTCENTER,"you're not an admin faggot")
    end
end)
concommand.Add("marijuana_npc_buyer_locations_delete",function(ply)
    if(ply:IsAdmin())then
        if(IsValid(DatNPC))then DatNPC:Remove() end
        NPCSpawns={}
        if not(file.Exists("weednpclocations/","DATA"))then file.CreateDir("weednpclocations") end
        file.Write("weednpclocations/"..game.GetMap()..".txt",util.TableToJSON(NPCSpawns))
        print("All spawn points deleted, spawn data file overwritten.")
    else
        ply:PrintMessage(HUD_PRINTCENTER,"fuck off m8")
    end
end)