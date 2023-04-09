AddCSLuaFile()
--[[----------------------------------------------------------------
                       Watering Can Params
-------------------------------------------------------------------]]
SWEP.Params={
    WaterAmount = 500 -- how much water each can contains to start. 100 units is one full hydration for one plant
}

if(CLIENT)then
    SWEP.PrintName = "Watering Can"
    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
    function SWEP:DrawHUD()
        local W,H=ScrW(),ScrH()
        draw.SimpleTextOutlined("Water: "..tostring(math.Round(self:GetWater())),"Trebuchet24",W*.7,H*.9,Color(255,255,255,255),0,0,1,Color(0,0,0,255))
    end
    function SWEP:GetViewModelPosition(pos,ang)
        local Up,Forward,Right=ang:Up(),ang:Forward(),ang:Right()
        pos=pos+Forward*15+Right*8-Up*7
        ang:RotateAroundAxis(Up,90)
        if(self.Owner:KeyDown(IN_ATTACK))then
            pos=pos+Forward*10+Up*5
            ang:RotateAroundAxis(Forward,-15)
            ang:RotateAroundAxis(Right,-10)
        end
        return pos,ang
    end
    function SWEP:DrawWorldModel()
        if not((self.Owner)and(self.Owner.Alive)and(self.Owner:Alive()))then
            self:DrawModel()
            return
        end
        local Hand=self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
        if(Hand)then
            local pos,ang=self.Owner:GetBonePosition(Hand)
            if((pos)and(ang))then
                local Fw=ang:Forward()
                self.WModel:SetRenderOrigin(pos+Fw*6+ang:Right()*5+ang:Up()*2)
                ang:RotateAroundAxis(Fw,190)
                ang:RotateAroundAxis(ang:Up(),140)
                self.WModel:SetRenderAngles(ang)
                self.WModel:DrawModel()
            end
        end
    end
end
SWEP.PrintName = "Weed Water Can"
SWEP.Author = "KittoniuM"
SWEP.Category = "BigPackets.com"

SWEP.IsDarkRPKeys = true
SWEP.WorldModel = "models/props_interiors/pot01a.mdl"
SWEP.ViewModel = "models/props_interiors/pot01a.mdl"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.AnimPrefix  = "rpg"
SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Sound = "doors/door_latch3.wav"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
function SWEP:SetupDataTables()
    self:NetworkVar("Float",0,"Water")
end
function SWEP:Initialize()
    if(SERVER)then
        self:SetWater(self.Params.WaterAmount)
        self:SetHoldType("slam")
    elseif(CLIENT)then
        self.WModel=ClientsideModel(self.WorldModel)
        self.WModel:SetPos(self:GetPos())
        self.WModel:SetParent(self)
        self.WModel:SetNoDraw(true)
    end
end
function SWEP:Deploy()
    return true
end
function SWEP:Holster()
    return true
end
function SWEP:PreDrawViewModel()
    return false
end
function SWEP:PrimaryAttack()
    if(CLIENT)then return end
    local Tr=self.Owner:GetEyeTrace()
    if((Tr.Hit)and((Tr.HitPos-self.Owner:GetShootPos()):Length()<70)and(Tr.Entity:GetClass()=="ent_jack_job_potplant"))then
        local Existing=Tr.Entity:GetHydration()
        if(Existing<99)then
            local Eff=EffectData()
            Eff:SetOrigin(Tr.HitPos)
            Eff:SetScale(7)
            util.Effect("WaterSplash",Eff,true,true)
            local Missing,Have=100-Existing,self:GetWater()
            if(Missing>=Have)then
                Tr.Entity:SetHydration(Existing+Have)
                self:Remove()
            elseif(Missing<Have)then
                self:SetWater(Have-Missing)
                Tr.Entity:SetHydration(100)
            end
        end
    end
end
function SWEP:SecondaryAttack()
    --
end
function SWEP:Reload()
    --
end