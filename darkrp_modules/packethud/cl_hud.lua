--[[---------------------------------------------------------------------------
HUD ConVars
---------------------------------------------------------------------------]]
local ConVars = {}
local HUDWidth
local HUDHeight

local Color = Color
local CurTime = CurTime
local cvars = cvars
local DarkRP = DarkRP
local draw = draw
local GetConVar = GetConVar
local hook = hook
local IsValid = IsValid
local Lerp = Lerp
local localplayer
local math = math
local pairs = pairs
local ScrW, ScrH = ScrW, ScrH
local SortedPairs = SortedPairs
local string = string
local surface = surface
local table = table
local timer = timer
local tostring = tostring
local plyMeta = FindMetaTable("Player")

local function loadFonts()
    surface.CreateFont("PacketHudFont", {
	font = "Arial", 
	extended = false,
	size = 16,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false}
		)
end

local function GetHealthColor(Health)
local col
if Health <= 30 then
					col = Color(255,0,0) return col end
					
				if Health <= 60 then
					col = Color(255,255,0) return col end
				
					col = Color(0,255,0)
	
	return col
end

loadFonts()
-- Load twice because apparently once is not enough
hook.Add("InitPostEntity", "aaaaaaaaaaxxxd", loadFonts)

local function ReloadConVars()

    HUDWidth = (GetConVar("HudW") or  CreateClientConVar("HudW", 240, true, false)):GetInt()
    HUDHeight = (GetConVar("HudH") or CreateClientConVar("HudH", 115, true, false)):GetInt()

    if not cvars.GetConVarCallbacks("HudW", false) and not cvars.GetConVarCallbacks("HudH", false) then
        cvars.AddChangeCallback("HudW", function() timer.Simple(0,ReloadConVars) end)
        cvars.AddChangeCallback("HudH", function() timer.Simple(0,ReloadConVars) end)
    end
end
ReloadConVars()

local Scrw, Scrh, RelativeX, RelativeY
local salaryText, JobWalletText, weptext
local function DrawInfo()
    salaryText = salaryText or DarkRP.getPhrase("salary", DarkRP.formatMoney(localplayer:getDarkRPVar("salary")), "")

    JobWalletText = JobWalletText or string.format("%s\n%s",
        DarkRP.getPhrase("job", localplayer:getDarkRPVar("job") or ""),
        DarkRP.getPhrase("wallet", DarkRP.formatMoney(localplayer:getDarkRPVar("money")), "")
    )
	
	 draw.DrawNonParsedText(salaryText, "PacketHudFont", RelativeX + 5, RelativeY - HUDHeight + 6, Color(255,255,255), 0)
   
    surface.SetFont("PacketHudFont")
    local _, h = surface.GetTextSize(salaryText)

    draw.DrawNonParsedText(JobWalletText, "PacketHudFont", RelativeX + 5, RelativeY - HUDHeight + h + 6, Color(255,255,255), 0)
end

local Page = Material("icon16/page_white_text.png")
local function GunLicense()
    if localplayer:getDarkRPVar("HasGunlicense") then
        surface.SetMaterial(Page)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(RelativeX + HUDWidth, Scrh - 34, 32, 32)
    end
end

local agendaText
local function Agenda()
    local shouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "DarkRP_Agenda")
    if shouldDraw == false then return end

    local agenda = localplayer:getAgendaTable()
    if not agenda then return end
    agendaText = agendaText or DarkRP.textWrap((localplayer:getDarkRPVar("agenda") or ""):gsub("//", "\n"):gsub("\\n", "\n"), "PacketHudFont", 440)

	--surface.SetDrawColor( 10, 15, 20, 50 )
	--surface.DrawRect(10, 10, 460, 110 )

    draw.DrawNonParsedText(agenda.Title, "PacketHudFont", 30, 10, Color(255,255,255), 0)
    draw.DrawNonParsedText(agendaText, "PacketHudFont", 30, 25, Color(255,255,255), 0)
end

hook.Add("DarkRPVarChanged", "agendaHUD", function(ply, var, _, new)
    if ply ~= localplayer then return end
    if var == "agenda" and new then
        agendaText = DarkRP.textWrap(new:gsub("//", "\n"):gsub("\\n", "\n"), "PacketHudFont", 440)
    else
        agendaText = nil
    end

    if var == "salary" then
        salaryText = DarkRP.getPhrase("salary", DarkRP.formatMoney(new), "")
    end

    if var == "job" or var == "money" then
        JobWalletText = string.format("%s\n%s",
            DarkRP.getPhrase("job", var == "job" and new or localplayer:getDarkRPVar("job") or ""),
            DarkRP.getPhrase("wallet", var == "money" and DarkRP.formatMoney(new) or DarkRP.formatMoney(localplayer:getDarkRPVar("money")), "")
        )
    end
end)

local function LockDown()
    local chbxX, chboxY = chat.GetChatBoxPos()
    if GetGlobalBool("DarkRP_LockDown") then
        local shouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "DarkRP_LockdownHUD")
        if shouldDraw == false then return end
        local cin = (math.sin(CurTime()) + 1) / 2
        local chatBoxSize = math.floor(Scrh / 4)
        draw.DrawNonParsedText(DarkRP.getPhrase("lockdown_started"), "ScoreboardSubtitle", chbxX, chboxY + chatBoxSize, Color(cin * 255, 0, 255 - (cin * 255), 255), TEXT_ALIGN_LEFT)
    end
end

local Arrested = function() end

usermessage.Hook("GotArrested", function(msg)
    local StartArrested = CurTime()
    local ArrestedUntil = msg:ReadFloat()

    Arrested = function()
        local shouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "DarkRP_ArrestedHUD")
        if shouldDraw == false then return end

        if CurTime() - StartArrested <= ArrestedUntil and localplayer:getDarkRPVar("Arrested") then
            draw.DrawNonParsedText(DarkRP.getPhrase("youre_arrested", math.ceil((ArrestedUntil - (CurTime() - StartArrested)) * 1 / game.GetTimeScale())), "PacketHudFont", Scrw / 2, Scrh - Scrh / 12, Color(255,255,255), 1)
        elseif not localplayer:getDarkRPVar("Arrested") then
            Arrested = function() end
        end
    end
end)

local AdminTell = function() end

usermessage.Hook("AdminTell", function(msg)
    timer.Remove("DarkRP_AdminTell")
    local Message = msg:ReadString()

    AdminTell = function()
        draw.RoundedBox(4, 10, 10, Scrw - 20, 110, colors.darkblack)
        draw.DrawNonParsedText("THSI TEXT IS VERY IMPORTNRTNAT READ NOW", "GModToolName", Scrw / 2 + 10, 100, colors.white, 1)
        draw.DrawNonParsedText(Message, "ChatFont", Scrw / 2 + 10, 150, Color(255,100,100), 1)
    end

    timer.Create("DarkRP_AdminTell", 10, 1, function()
        AdminTell = function() end
    end)
end)

local function DrawHUD()
	 local shouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "DarkRP_HUD")
    if shouldDraw == false then return end

    Scrw, Scrh = ScrW(), ScrH()
    RelativeX, RelativeY = 0, Scrh

    shouldDraw = hook.Call("HUDShouldDraw", GAMEMODE, "DarkRP_LocalPlayerHUD")
    shouldDraw = shouldDraw ~= false
    if shouldDraw then
	
		draw.DrawNonParsedText("[x[ BigPackets.com DarkRP Server ]x]", "PacketHudFont", Scrw / 2, 10, Color(255,255,255), 1)
        
        --Draw Health
		local maxHealth = localplayer:GetMaxHealth()
		local myHealth = localplayer:Health()
		local Health = math.min(maxHealth, myHealth)
		local healthRatio = math.min(Health / maxHealth, 1)
	 
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect(RelativeX + 4, RelativeY - 60, 102, 6 )
		
		surface.SetDrawColor( GetHealthColor(myHealth) )
		surface.DrawRect(RelativeX + 5, RelativeY - 59, 100 * healthRatio, 4 )
		
		local armor = localplayer:Armor()
		if armor ~= 0 then
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawRect(RelativeX + 4, RelativeY - 50, 101, 6 )
			
			surface.SetDrawColor( 0, 127, 255, 255 )
			local ArmorVal = (99) * armor / 100; if ArmorVal > 100 then ArmorVal = 100 end
			surface.DrawRect(RelativeX + 5, RelativeY - 49, ArmorVal, 4 )
	   end
		--Draw Health End
        DrawInfo()
        GunLicense()
    end
    Agenda()
	if localplayer.DRPIsTalking then
		draw.DrawNonParsedText("* Transmitting Voice *", "PacketHudFont", Scrw - 500, chat.GetChatBoxPos(), Color(100,255,255), 0)
    end
    LockDown()

    Arrested()
    AdminTell()
end

plyMeta.drawPlayerInfo = plyMeta.drawPlayerInfo or function(self)
    local pos = self:EyePos()

    pos.z = pos.z + 10 -- The position we want is a bit above the position of the eyes
    pos = pos:ToScreen()
    if not self:getDarkRPVar("wanted") then
        -- Move the text up a few pixels to compensate for the height of the text
        pos.y = pos.y - 50
    end

    if GAMEMODE.Config.showname then
        local nick, plyTeam = self:Nick(), self:Team()
        draw.DrawNonParsedText(nick, "PacketHudFont", pos.x, pos.y, RPExtraTeams[plyTeam] and RPExtraTeams[plyTeam].color or team.GetColor(plyTeam) , 1)
    end

    if GAMEMODE.Config.showhealth then
		local maxHealth = self:GetMaxHealth()
		local myHealth = self:Health()
		local Health = math.min(maxHealth, myHealth);
		local healthRatio = math.min(Health / maxHealth, 1)
	 
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect(pos.x - 25, pos.y + 20, 52, 6 )
		
		surface.SetDrawColor( GetHealthColor(myHealth) )
		surface.DrawRect(pos.x - 24, pos.y + 21, 50 * healthRatio, 4 )
    end

    if GAMEMODE.Config.showjob then
        local teamname = self:getDarkRPVar("job") or team.GetName(self:Team())
        draw.DrawNonParsedText(teamname, "PacketHudFont", pos.x, pos.y + 40, Color(255,255,255), 1)
    end

    if self:getDarkRPVar("HasGunlicense") then
        surface.SetMaterial(Page)
        surface.SetDrawColor(255,255,255,255)
        surface.DrawTexturedRect(pos.x-16, pos.y + 60, 32, 32)
    end
end

-- Draw wanted information above a player's head
-- This syntax allows for easy overriding
plyMeta.drawWantedInfo = plyMeta.drawWantedInfo or function(self)
    if not self:Alive() then return end

    local pos = self:EyePos()
    if not pos:isInSight({localplayer, self}) then return end

    pos.z = pos.z + 10
    pos = pos:ToScreen()

    if GAMEMODE.Config.showname then
        local nick, plyTeam = self:Nick(), self:Team()
        draw.DrawNonParsedText(nick, "PacketHudFont", pos.x, pos.y, RPExtraTeams[plyTeam] and RPExtraTeams[plyTeam].color or team.GetColor(plyTeam) , 1)
    end

    local wantedText = DarkRP.getPhrase("wanted", tostring(self:getDarkRPVar("wantedReason")))

    draw.DrawNonParsedText(wantedText, "PacketHudFont", pos.x, pos.y - 40, Color(255,255,255), 1)
    draw.DrawNonParsedText(wantedText, "PacketHudFont", pos.x + 1, pos.y - 41, Color(255,0,0), 1)
end

--[[---------------------------------------------------------------------------
The Entity display: draw HUD information about entities
---------------------------------------------------------------------------]]
local function DrawEntityDisplay()
    local shouldDraw, players = hook.Call("HUDShouldDraw", GAMEMODE, "DarkRP_EntityDisplay")
    if shouldDraw == false then return end

    local shootPos = localplayer:GetShootPos()
    local aimVec = localplayer:GetAimVector()

    for k, ply in pairs(players or player.GetAll()) do
        if ply == localplayer or not ply:Alive() or ply:GetNoDraw() then continue end
        local hisPos = ply:GetShootPos()
        if ply:getDarkRPVar("wanted") then ply:drawWantedInfo() end

        if GAMEMODE.Config.globalshow then
            ply:drawPlayerInfo()
        -- Draw when you're (almost) looking at him
        elseif hisPos:DistToSqr(shootPos) < 200000 then
            local pos = hisPos - shootPos
            local unitPos = pos:GetNormalized()
            if unitPos:Dot(aimVec) > 0.95 then
                local trace = util.QuickTrace(shootPos, pos, localplayer)
                if trace.Hit and trace.Entity ~= ply then break end
                ply:drawPlayerInfo()
            end
        end
    end

    local tr = localplayer:GetEyeTrace()

    if IsValid(tr.Entity) and tr.Entity:isKeysOwnable() and tr.Entity:GetPos():DistToSqr(localplayer:GetPos()) < 40000 then
        tr.Entity:drawOwnableInfo()
    end
end

--[[---------------------------------------------------------------------------
Drawing death notices
---------------------------------------------------------------------------]]
function GM:DrawDeathNotice(x, y)
    if not GAMEMODE.Config.showdeaths then return end
    self.Sandbox.DrawDeathNotice(self, x, y)
end

--[[---------------------------------------------------------------------------
Display notifications
---------------------------------------------------------------------------]]
local function DisplayNotify(msg)
    local txt = msg:ReadString()
    GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
    surface.PlaySound("buttons/lightswitch2.wav")

    -- Log to client console
    MsgC(Color(255, 20, 20, 255), "[PacketWars] ", Color(200, 200, 200, 255), txt, "\n")
end
usermessage.Hook("_Notify", DisplayNotify)

--[[---------------------------------------------------------------------------
Remove some elements from the HUD in favour of the DarkRP HUD
---------------------------------------------------------------------------]]
function GM:HUDShouldDraw(name)
    if name == "CHudHealth" or
        name == "CHudBattery" or
		name == "CHudSuitPower" or
		name == "CHudDamageIndicator" or
        (HelpToggled and name == "CHudChat") then
            return false
    else
        return self.Sandbox.HUDShouldDraw(self, name)
    end
end

--[[---------------------------------------------------------------------------
Disable players' names popping up when looking at them
---------------------------------------------------------------------------]]
function GM:HUDDrawTargetID()
    return false
end

--[[---------------------------------------------------------------------------
Actual HUDPaint hook
---------------------------------------------------------------------------]]
function GM:HUDPaint()
    localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
    if not IsValid(localplayer) then return end

    DrawHUD()
    DrawEntityDisplay()

    self.Sandbox.HUDPaint(self)
end
