--[[--------------------------------------------------------
--                   Plant Parameters                     --
----------------------------------------------------------]]
ENT.Params = {
    GrowthRate = 1, -- factor for how quickly the plant grows (default about 7 minutes from seedling to harvest) and heals
    Hardiness = 1, -- factor for how damage-resistant the plant is (default roughly 5 pistol shots)
    SeedYield = 1, -- factor for how many seeds ON AVERAGE the plant yields per harvest (default about 1.25 seeds per harvest)
    CropYield = 1, -- factor for how many units of marijuana ON AVERAGE the plant yields per harvest (default about 3 units per harvest)
    WaterNeed = 1, -- factor for how much water the plant needs (default 100 water units every 3 minutes)
    SoilLongevity = 1, -- factor for ON AVERAGE how long the soil in a pot lasts (default soil lasts for about 5 harvests)
    LampDistance = 1 -- factor for the max distance a plant can grow from a sun map, default is about 2 meters
}
--[[----------------------------------------------------------
--                  Global Parameters                       --
------------------------------------------------------------]]
JackaJob_WeedSellPrice = 100 -- each weed bag sells to the NPC for this many USD
JackaJob_WeedBuyerNPCMoveTime = 100 -- weed buyer will stay in one place for this many seconds

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cannabis Plant"
ENT.Author = "Jackarunda"
ENT.Spawnable = false
function ENT:SetupDataTables()
    self:NetworkVar("Entity",0,"owning_ent")
    self:NetworkVar("Float",0,"PlantHealth")
    self:NetworkVar("Float",1,"Hydration")
    self:NetworkVar("Float",2,"Stage") -- 0 empty 10 soiled 20 planted 30 40 50 60 70 80 90 growing 100 harvestable
end
