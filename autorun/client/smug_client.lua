local ItemUnlockStart = SMUG_CONFIG_DefaultSmuggleDelay
local ItemUnlockCD = CurTime() + ItemUnlockStart

function RestartCountDownTimer(um) 
ItemUnlockStart = um:ReadLong() -- Calculates in seconds (One hour).
ItemUnlockCD = CurTime() + ItemUnlockStart
end
usermessage.Hook("RP_Smuggle_TimerRestart", RestartCountDownTimer)

surface.CreateFont("UiBold", {
	font = "Tahoma", 
	size = 13, 
	weight = 700
})

surface.CreateFont("Trebuchet24", {
	font = "Trebuchet MS", 
	size = 24, 
	weight = 900
})

surface.CreateFont("Trebuchet22", {
	font = "Trebuchet MS", 
	size = 22, 
	weight = 900
})

surface.CreateFont("TabLarge", {
	font = "Tahoma", 
	size = 13, 
	weight = 700
})
	
function RP_SmuggleMenu_Buy()
	local BuyMenu = vgui.Create( "DFrame" )
	BuyMenu:SetSize( 470, 520 ) 
	BuyMenu:Center() 
	BuyMenu:SetTitle( "" )  
	BuyMenu:SetVisible( true )
	BuyMenu:SetDraggable( true ) 
	BuyMenu:ShowCloseButton( false )
	BuyMenu:MakePopup()
	BuyMenu:SizeToContents()
	BuyMenu.Paint = function(CHPaint)
		-- Draw the menu background color.
				
		draw.RoundedBox( 6, 0, 0, CHPaint:GetWide(), CHPaint:GetTall(), Color( 255, 255, 255, 150 ) )

		-- Draw the outline of the menu.
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect(0, 0, CHPaint:GetWide(), CHPaint:GetTall())

		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect(0, 0, CHPaint:GetWide(), 25)
		--surface.DrawOutlinedRect(1, 1, CHPaint:GetWide(), 25)

		-- Draw the top title.
		draw.SimpleText("Smuggling Menu", "UiBold", 55,12.5, Color(70,70,70,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
		
	local GUI_Main_Exit = vgui.Create("DButton", BuyMenu)
	GUI_Main_Exit:SetSize(16,16)
	GUI_Main_Exit:SetPos(450,5)
	GUI_Main_Exit:SetText("")
	GUI_Main_Exit.Paint = function()
		surface.SetMaterial(Material("icon16/cross.png"))
		surface.SetDrawColor(200,200,0,200)
		surface.DrawTexturedRect(0,0,GUI_Main_Exit:GetWide(),GUI_Main_Exit:GetTall())
	end
	GUI_Main_Exit.DoClick = function()
		BuyMenu:Remove()
		net.Start("CH_CloseSmuggleBuyMenu")
		net.SendToServer()
	end
	
	local TimeBackground = vgui.Create( "DPanel", BuyMenu )
	TimeBackground:SetPos( 85, 500 )
	TimeBackground:SetSize( 300, 20 )
	TimeBackground.Paint = function() -- Paint function
		draw.RoundedBoxEx(8,1,1,TimeBackground:GetWide(),TimeBackground:GetTall(),Color(70, 70, 70, 200), true, true, false, false)
		
		if ItemUnlockCD > CurTime() then
			draw.SimpleText("Items unlock in ".. string.ToMinutesSeconds(math.Round(ItemUnlockCD - CurTime())) .." minutes.", "UiBold", 150,10, Color(200,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("All items are unlocked.", "UiBold", 150,10, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	
	local CDListPanel = vgui.Create( "DPanelList", BuyMenu )
	CDListPanel:SetTall( 465 )
	CDListPanel:SetWide( 460 )
	CDListPanel:SetPos( 5, 30 )
	CDListPanel:EnableVerticalScrollbar( true )
	CDListPanel:EnableHorizontal( true ) -- Only vertical items
		
	for k, v in pairs( Smuggle_Items ) do
		if v.Name then
			local SmuggleItems_Buy = vgui.Create("DPanelList")
			SmuggleItems_Buy:SetTall( 120 )
			SmuggleItems_Buy:SetWide( 460 )
			SmuggleItems_Buy:SetPos( 10, 30 )
			SmuggleItems_Buy:SetSpacing( 5 )
			SmuggleItems_Buy.Paint = function()
				draw.RoundedBox(8,0,2,SmuggleItems_Buy:GetWide(),SmuggleItems_Buy:GetTall(),Color( 20, 20, 20, 180 ))
			end
				
			local ItemBackground = vgui.Create( "DPanel", SmuggleItems_Buy )
			ItemBackground:SetPos( 0, 10 )
			ItemBackground:SetSize( 460, 105 )
			ItemBackground.Paint = function() -- Paint function
				draw.RoundedBoxEx(8,1,1,ItemBackground:GetWide()-2,ItemBackground:GetTall()-2,Color(70, 70, 70, 200), false, false, false, false)
			end
				
			local ItemIcon = vgui.Create( "SpawnIcon", ItemBackground )
			ItemIcon:SetPos( 5, 5 )
			ItemIcon:SetModel( v.Model )
			ItemIcon:SetSize(100,95)
			ItemIcon:SetToolTip( false )
			ItemIcon.PaintOver = function()
				return
			end
			ItemIcon.OnMousePressed = function()
				return false
			end
			
			local ItemName = vgui.Create( "DLabel", ItemBackground )
			ItemName:SetPos( 115, 7.5 )
			ItemName:SetFont( "Trebuchet24" )
			ItemName:SetColor( Color(255,255,255,255) )
			ItemName:SetText( v.Name )
			ItemName:SizeToContents()
				
			local ItemDescription = vgui.Create( "DLabel", ItemBackground )
			ItemDescription:SetPos( 115, 30 )
			ItemDescription:SetSize( 325, 15 )
			ItemDescription:SetFont( "UiBold" )
			ItemDescription:SetColor( Color(255,255,255,255) )
			ItemDescription:SetText( v.Description )
			
			local ItemPrice = vgui.Create( "DLabel", ItemBackground )
			ItemPrice:SetPos( 115, 45 )
			ItemPrice:SetSize( 325, 15 )
			ItemPrice:SetFont( "UiBold" )
			ItemPrice:SetColor( Color(0,200,0,255) )
			ItemPrice:SetText( "Price: $"..v.BuyPrice )
			
			local ItemSellPrice = vgui.Create( "DLabel", ItemBackground )
			ItemSellPrice:SetPos( 115, 60 )
			ItemSellPrice:SetSize( 325, 15 )
			ItemSellPrice:SetFont( "UiBold" )
			ItemSellPrice:SetColor( Color(200,0,0,255) )
			ItemSellPrice:SetText( "Sell Price: $"..v.SellPrice )
			
			local SmuggleDelay = vgui.Create( "DLabel", ItemBackground )
			SmuggleDelay:SetPos( 115, 75 )
			SmuggleDelay:SetSize( 325, 15 )
			SmuggleDelay:SetFont( "UiBold" )
			SmuggleDelay:SetColor( Color(20,20,20,255) )
			SmuggleDelay:SetText( "Smuggle Delay: "..v.SmuggleDelay / 60 .." minutes" )
			
			local ItemPurchase = vgui.Create("DButton", ItemBackground)
			ItemPurchase:SetSize( 150, 30 )
			ItemPurchase:SetPos( 310, 70 )
			ItemPurchase:SetText("")
			--if ItemUnlockCD > CurTime() then
			--	ItemPurchase:SetDisabled( true )
			--end
			ItemPurchase.Paint = function(panel)
				draw.RoundedBoxEx(8,1,1,ItemPurchase:GetWide()-2,ItemPurchase:GetTall()-2,Color(0, 0, 0, 130), true, false, true, false)
					
				local struc = {}
				struc.pos = {}
				struc.pos[1] = 75 -- x pos
				struc.pos[2] = 15 -- y pos
				if ItemUnlockCD > CurTime() then
					struc.color = Color(150,150,150,255)
				else
					struc.color = Color(255,255,255,255)
				end
				struc.text = "Purchase" -- Text
				struc.font = "Trebuchet22" -- Font
				struc.xalign = TEXT_ALIGN_CENTER-- Horizontal Alignment
				struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
				draw.Text( struc )
			end
			ItemPurchase.DoClick = function()
				BuyMenu:Remove()
				
				net.Start("CH_CloseSmuggleBuyMenu")
				net.SendToServer()
				
				net.Start("RP_SmuggleItems")
					net.WriteString(k)
				net.SendToServer()
			end
				
			CDListPanel:AddItem( SmuggleItems_Buy )
		end
	end
end
usermessage.Hook("RP_SmuggleBuyMenu", RP_SmuggleMenu_Buy)