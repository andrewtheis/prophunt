--
-- cl_skin.lua
-- Prop Hunt
--	
-- Created by Andrew Theis on 2013-10-31. Modified from original Facepunch fretta file.
-- Copyright (c) 2013 Andrew Theis. All rights reserved.
--

local surface = surface
local draw = draw
local Color = Color

local SKIN = {}

SKIN.PrintName 		= ""
SKIN.Author 		= ""
SKIN.DermaVersion	= 1

SKIN.bg_color 					= Color( 100, 100, 100, 255 )
SKIN.bg_color_sleep 			= Color( 70, 70, 70, 255 )
SKIN.bg_color_dark				= Color( 50, 50, 50, 255 )
SKIN.bg_color_bright			= Color( 220, 220, 220, 255 )

SKIN.fontFrame					= "Default"

SKIN.control_color 				= Color( 180, 180, 180, 255 )
SKIN.control_color_highlight	= Color( 220, 220, 220, 255 )
SKIN.control_color_active 		= Color( 110, 150, 255, 255 )
SKIN.control_color_bright 		= Color( 255, 200, 100, 255 )
SKIN.control_color_dark 		= Color( 100, 100, 100, 255 )

SKIN.bg_alt1 					= Color( 50, 50, 50, 255 )
SKIN.bg_alt2 					= Color( 55, 55, 55, 255 )

SKIN.listview_hover				= Color( 70, 70, 70, 255 )
SKIN.listview_selected			= Color( 100, 170, 220, 255 )

SKIN.text_bright				= Color( 255, 255, 255, 255 )
SKIN.text_normal				= Color( 180, 180, 180, 255 )
SKIN.text_dark					= Color( 20, 20, 20, 255 )
SKIN.text_highlight				= Color( 255, 20, 20, 255 )

SKIN.texGradientUp				= Material( "gui/gradient_up" )
SKIN.texGradientDown			= Material( "gui/gradient_down" )

SKIN.combobox_selected			= SKIN.listview_selected

SKIN.panel_transback			= Color( 255, 255, 255, 50 )
SKIN.tooltip					= Color( 255, 245, 175, 255 )

SKIN.colPropertySheet 			= Color( 170, 170, 170, 255 )
SKIN.colTab			 			= SKIN.colPropertySheet
SKIN.colTabInactive				= Color( 170, 170, 170, 155 )
SKIN.colTabShadow				= Color( 60, 60, 60, 255 )
SKIN.colTabText		 			= Color( 255, 255, 255, 255 )
SKIN.colTabTextInactive			= Color( 0, 0, 0, 155 )
SKIN.fontTab					= "Default"

SKIN.colCollapsibleCategory		= Color( 255, 255, 255, 20 )

SKIN.colCategoryText			= Color( 255, 255, 255, 255 )
SKIN.colCategoryTextInactive	= Color( 200, 200, 200, 255 )
SKIN.fontCategoryHeader			= "TabLarge"

SKIN.colNumberWangBG			= Color( 255, 240, 150, 255 )
SKIN.colTextEntryBG				= Color( 240, 240, 240, 255 )
SKIN.colTextEntryBorder			= Color( 20, 20, 20, 255 )
SKIN.colTextEntryText			= Color( 20, 20, 20, 255 )
SKIN.colTextEntryTextHighlight	= Color( 20, 200, 250, 255 )
SKIN.colTextEntryTextHighlight	= Color( 20, 200, 250, 255 )

SKIN.colMenuBG					= Color( 255, 255, 255, 200 )
SKIN.colMenuBorder				= Color( 0, 0, 0, 200 )

SKIN.colButtonText				= Color( 0, 0, 0, 250 )
SKIN.colButtonTextDisabled		= Color( 0, 0, 0, 100 )
SKIN.colButtonBorder			= Color( 20, 20, 20, 255 )
SKIN.colButtonBorderHighlight	= Color( 255, 255, 255, 50 )
SKIN.colButtonBorderShadow		= Color( 0, 0, 0, 100 )
SKIN.fontButton					= "Default"

-- enum for draw order
DM_ORDER_LATESTATTOP = 1;
DM_ORDER_LATESTATBOTTOM = 2;

-- basic deathmsg appearance settings
SKIN.deathMessageBackgroundCol			= Color( 46, 43, 42, 220 );
SKIN.deathMessageBackgroundLocal		= Color( 75, 75, 75, 200 ); -- this is the colour that the background is when the local player is involved in the deathmsg, so it stands out.
SKIN.deathMessageActionColor			= Color( 200, 200, 200 );

local matBlurScreen = Material( "pp/blurscreen" )


/*---------------------------------------------------------
   DrawGenericBackground
---------------------------------------------------------*/
function SKIN:DrawGenericBackground( x, y, w, h, color )

	draw.RoundedBox( 4, x, y, w, h, color )

end

/*---------------------------------------------------------
   DrawLinedButtonBorder
---------------------------------------------------------*/
function SKIN:DrawLinedButtonBorder( x, y, w, h, depressed )

	surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
	surface.DrawOutlinedRect( x+1, y+1, w-2, h-2 )

end

/*---------------------------------------------------------
	Button
---------------------------------------------------------*/
function SKIN:PaintCancelButton( panel )

	local w, h = panel:GetSize()

	if ( panel.m_bBackground ) then
	
		local col = self.control_color
		
		if ( panel:GetDisabled() ) then
			col = self.control_color_dark
		elseif ( panel.Depressed ) then
			col = self.control_color_active
		elseif ( panel.Hovered ) then
			col = self.control_color_highlight
		end
		
		if ( panel.m_colBackground ) then
		
			col = table.Copy( panel.m_colBackground )
			
			if ( panel:GetDisabled() ) then
				col.r = math.Clamp( col.r * 0.7, 0, 255 )
				col.g = math.Clamp( col.g * 0.7, 0, 255 )
				col.b = math.Clamp( col.b * 0.7, 0, 255 )
				col.a = 20
			elseif ( panel.Depressed ) then
				col.r = math.Clamp( col.r + 100, 0, 255 )
				col.g = math.Clamp( col.g + 100, 0, 255 )
				col.b = math.Clamp( col.b + 100, 0, 255 )
			elseif ( panel.Hovered ) then
				col.r = math.Clamp( col.r + 30, 0, 255 )
				col.g = math.Clamp( col.g + 30, 0, 255 )
				col.b = math.Clamp( col.b + 30, 0, 255 )
			end
		end
		
		surface.SetDrawColor( col.r, col.g, col.b, col.a )
		panel:DrawFilledRect()
	
	end

end

SKIN.PaintSelectButton = SKIN.PaintCancelButton

function SKIN:PaintOverCancelButton( panel )

	local w, h = panel:GetSize()
	
	if ( panel.m_bBorder ) then
		self:DrawLinedButtonBorder( 0, 0, w, h, panel.Depressed )
	end

end

SKIN.PaintOverSelectButton = SKIN.PaintOverCancelButton

function SKIN:SchemeCancelButton( panel )

	panel:SetFontInternal( "FRETTA_SMALL" )
	
	if ( panel:GetDisabled() ) then
		panel:SetTextColor( self.colButtonTextDisabled )
	else
		panel:SetTextColor( self.colButtonText )
	end
	
	DLabel.ApplySchemeSettings( panel )

end

function SKIN:SchemeSelectButton( panel )

	panel:SetFontInternal( "FRETTA_SMALL" )
	
	if ( panel:GetDisabled() ) then
		panel:SetTextColor( self.colButtonTextDisabled )
	else
		panel:SetTextColor( self.colButtonText )
	end
	
	DLabel.ApplySchemeSettings( panel )

end

/*---------------------------------------------------------
	ListViewLine
---------------------------------------------------------*/
function SKIN:PaintListViewLine( panel )


end

/*---------------------------------------------------------
	ListViewLine
---------------------------------------------------------*/
function SKIN:PaintListView( panel )


end

/*---------------------------------------------------------
	ListViewLabel
---------------------------------------------------------*/
function SKIN:PaintScorePanelHeader( panel )

	//surface.SetDrawColor( panel.cTeamColor )	
	//panel:DrawFilledRect()
	
end

/*---------------------------------------------------------
	ListViewLabel
---------------------------------------------------------*/
function SKIN:PaintScorePanelLine( panel )

	local Tall = panel:GetTall()
	local BoxHeight = 21
	
	if ( !IsValid( panel.pPlayer ) || !panel.pPlayer:Alive() ) then
		draw.RoundedBox( 4, 0, Tall*0.5 - BoxHeight*0.5, panel:GetWide(), BoxHeight, Color( 60, 60, 60, 255 ) )
		return
	end

	if ( panel.pPlayer == LocalPlayer() ) then
		draw.RoundedBox( 4, 0, Tall*0.5 - BoxHeight*0.5, panel:GetWide(), BoxHeight, Color( 90, 90, 90, 255 ) )
		return
	end

	draw.RoundedBox( 4, 0, Tall*0.5 - BoxHeight*0.5, panel:GetWide(), BoxHeight, Color( 70, 70, 70, 255 ) )
		
end

/*---------------------------------------------------------
	PaintScorePanel
---------------------------------------------------------*/
function SKIN:PaintScorePanel( panel )

	surface.SetMaterial( matBlurScreen )	
	surface.SetDrawColor( 255, 255, 255, 255 )
		
	local x, y = panel:LocalToScreen( 0, 0 )
	
	matBlurScreen:SetFloat( "$blur", 5 )
	render.UpdateScreenEffectTexture()
	surface.DrawTexturedRect( x*-1, y*-1, ScrW(), ScrH() )
	
	//matBlurScreen:SetFloat( "$blur", 3 )
	//render.UpdateScreenEffectTexture()
	//surface.DrawTexturedRect( x*-1, y*-1, ScrW(), ScrH() )
		
	draw.RoundedBox( 8, 0, 8, panel:GetWide(), panel:GetTall()-8, Color( 200, 200, 200, 150 ) )
	
end


/*---------------------------------------------------------
	LayoutTeamScoreboardHeader
---------------------------------------------------------*/
function SKIN:LayoutTeamScoreboardHeader( panel )

	panel.TeamName:StretchToParent( 0, 0, 0, 0 )
	panel.TeamName:SetTextInset( 8, 0 )
	panel.TeamName:SetColor( Color( 0, 0, 0, 220 ) )
	panel.TeamName:SetFontInternal( "FRETTA_MEDIUM" )
	
	panel.TeamScore:StretchToParent( 0, 0, 0, 0 )
	panel.TeamScore:SetContentAlignment( 6 )
	panel.TeamScore:SetTextInset( 8, 0 )
	panel.TeamScore:SetColor( Color( 0, 0, 0, 250 ) )
	panel.TeamScore:SetFontInternal( "FRETTA_MEDIUM" )

end

function SKIN:PaintTeamScoreboardHeader( panel )

	local Color = team.GetColor( panel.iTeamID )
	draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall()*2, Color )

end

function SKIN:SchemeScorePanelLabel( panel )

	panel:SetTextColor( GAMEMODE:GetTeamColor( panel.pPlayer ) )
	panel:SetFontInternal( "FRETTA_MEDIUM_SHADOW" )

end

function SKIN:PaintScorePanelLabel( panel )

	if ( !IsValid( panel.pPlayer ) || !panel.pPlayer:Alive() ) then
		panel:SetAlpha( 125 )
	else
		panel:SetAlpha( 255 )
	end
		
end

function SKIN:SchemeScorePanelHeaderLabel( panel )

	panel:SetTextColor( Color( 70, 70, 70, 255 ) )
	panel:SetFontInternal( "HudSelectionText" )
		
end

function SKIN:SchemeSpectatorInfo( panel )

	panel:SetTextColor( Color( 255, 255, 255, 255 ) )
	panel:SetFontInternal( "FRETTA_SMALL" )
		
end

/*---------------------------------------------------------
	ScoreHeader
---------------------------------------------------------*/
function SKIN:PaintScoreHeader( panel )

	draw.RoundedBox( 8, 0, 0, panel:GetWide(), panel:GetTall()*2, Color( 50, 90, 160 ) )
		
end

function SKIN:LayoutScoreHeader( panel )

	panel.HostName:SizeToContents()
	panel.HostName:SetPos( 0, 0 )
	panel.HostName:CenterHorizontal()
	
	panel.GamemodeName:SizeToContents()
	panel.GamemodeName:MoveBelow( panel.HostName, 0 )
	panel.GamemodeName:CenterHorizontal()
	
	panel:SetTall( panel.GamemodeName.y + panel.GamemodeName:GetTall() + 4 ) 
		
end

function SKIN:SchemeScoreHeader( panel )

	panel.HostName:SetTextColor( Color( 255, 255, 255, 255 ) )
	panel.HostName:SetFontInternal( "FRETTA_LARGE_SHADOW" )
	
	panel.GamemodeName:SetTextColor( Color( 255, 255, 255, 255 ) )
	panel.GamemodeName:SetFontInternal( "FRETTA_MEDIUM_SHADOW" )
		
end

/*---------------------------------------------------------
	DeathMessages
---------------------------------------------------------*/
function SKIN:PaintGameNotice( panel )

	if ( panel.m_bHighlight ) then
		draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall(), Color( 90, 90, 90, 200 ) )
		return
	end

	draw.RoundedBox( 4, 0, 0, panel:GetWide(), panel:GetTall(), Color( 20, 20, 20, 190 ) )
	
end

function SKIN:SchemeGameNoticeLabel( panel )

	panel:SetFontInternal( "FRETTA_NOTIFY" );
	DLabel.ApplySchemeSettings( panel )
	
end

/*---------------------------------------------------------
	GamemodeButton
---------------------------------------------------------*/
function SKIN:PaintGamemodeButton( panel )

	local w, h = panel:GetSize()
	
	local col = Color( 255, 255, 255, 10 )
	
	if ( panel:GetDisabled() ) then
		col = Color( 0, 0, 0, 10 )
	elseif ( panel.Depressed ) then
		col = Color( 255, 255, 255, 50 )
	elseif ( panel.Hovered ) then
		col = Color( 255, 255, 255, 20 )
	end
	
	if ( panel.bgColor != nil ) then col = panel.bgColor end

	draw.RoundedBox( 4, 0, 0, w, h, col )

end

function SKIN:SchemeGamemodeButton( panel )

	panel:SetTextColor( color_white )
	panel:SetFontInternal( "FRETTA_MEDIUM_SHADOW" )
	panel:SetContentAlignment( 4 )
	panel:SetTextInset( 8, 0 )

end


/*---------------------------------------------------------
	PanelButton
---------------------------------------------------------*/
function SKIN:PaintPanelButton( panel )

	local w, h = panel:GetSize()
	
	local col = Color( 160, 160, 160, 255 )
	
	if ( panel:GetDisabled() ) then
		col = Color( 100, 100, 100, 255 )
	elseif ( panel.Depressed ) then
		col = Color( 150, 210, 255, 255 )
	elseif ( panel.Hovered ) then
		col = Color( 200, 200, 200, 255 )
	end
		
	if ( panel.bgColor != nil ) then col = panel.bgColor end

	surface.SetDrawColor( col )
	panel:DrawFilledRect()

end

function SKIN:PaintOverPanelButton( panel )

	local w, h = panel:GetSize()
	self:DrawLinedButtonBorder( 0, 0, w, h, panel.Depressed )

end

derma.DefineSkin( "PropHuntSkin", "", SKIN )