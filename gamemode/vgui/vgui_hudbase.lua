--
-- vgui_hudbase.lua
-- Prop Hunt
--	
-- Created by Andrew Theis on 2013-10-31. Modified from original Facepunch fretta file.
-- Copyright (c) 2013 Andrew Theis. All rights reserved.
--


local PANEL = {}

surface.CreateLegacyFont( "Trebuchet MS", 32, 800, true, false, "FHUDElement" )

AccessorFunc( PANEL, "m_bPartOfBar", 	"PartOfBar" )

function PANEL:Init()

	self:SetText( "-" )
	self:SetTextColor( self:GetDefaultTextColor() )
	self:SetFont( "FHUDElement" )

	self:ChooseParent()
	
end

-- This makes it so that it's behind chat & hides when you're in the menu
-- But it also removes the ability to click on it. So override it if you want to.
function PANEL:ChooseParent()
	self:ParentToHUD()
end

function PANEL:GetPadding()
	return 16
end

function PANEL:GetDefaultTextColor()
	return Color( 255, 255, 255, 255 )
end

function PANEL:GetTextLabelColor()
	return Color( 255, 255, 0 )
end

function PANEL:GetTextLabelFont()
	return "HudSelectionText"
end

function PANEL:Paint()

	if ( !self.m_bPartOfBar ) then
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 100 ) )
	end

end

derma.DefineControl( "HudBase", "A HUD Base Element (override to change the style)", PANEL, "DLabel" )
