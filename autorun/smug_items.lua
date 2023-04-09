Smuggle_Items = {}

Smuggle_Items["ITEM_AMMO"] = {  
	Name = "Illigal Ammunition", -- The name of the item.  
	Description = "Ammunition from China. Illigally smuggled into the US.", -- The description of the item.  
	Model = "models/Items/item_item_crate_dynamic.mdl", -- The model for the item. Shows in the menu and when spawned in the truck.  
	BuyPrice = 5000, -- The price of the item when you purchase it.  
	SellPrice = 7500, -- The price you will be able to sell the item for.  
	Health = 100, -- The health of the package before it explodes.  
	SmuggleDelay = 1500, -- The delay untill you can purchase a new package. The delay is global for all packages. In seconds.  
	ItemVector = Vector(0, 48, 53), -- The vector the package will spawn at inside the vehicle.  
	ItemAngle = Angle(0, 180, 0), -- The angle the package will spawn at inside the vehicle.  
}

Smuggle_Items["ITEM_TNT"] = {
	Name = "TNT",
	Description = "Highly explosive TNT.",
	Model = "models/dav0r/tnt/tnt.mdl",
	BuyPrice = 10000,
	SellPrice = 14000,
	Health = 100,
	SmuggleDelay = 2100,
	ItemVector = Vector(11, 48, 58),
	ItemAngle = Angle(0, 90, 90),
}

Smuggle_Items["ITEM_C4"] = {
	Name = "C4",
	Description = "C4 explosives to be used in terrorist attacks.",
	Model = "models/weapons/w_c4_planted.mdl",
	BuyPrice = 15000,
	SellPrice = 20000,
	Health = 100,
	SmuggleDelay = 2700,
	ItemVector = Vector(0, 48, 54),
	ItemAngle = Angle(0, 90, 0),
}

Smuggle_Items["ITEM_EXPLOSIVES"] = {
	Name = "Explosives",
	Description = "Various explosive packages.",
	Model = "models/Items/ammoCrate_Rockets.mdl",
	BuyPrice = 27000,
	SellPrice = 34000,
	Health = 100,
	SmuggleDelay = 3600,
	ItemVector = Vector(0, 48, 70),
	ItemAngle = Angle(0, 90, 90),
} 