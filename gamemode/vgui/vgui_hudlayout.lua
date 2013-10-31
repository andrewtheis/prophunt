--
-- vgui_hudlayout.lua
-- Prop Hunt
--	
-- Created by Andrew Theis on 2013-10-31. Modified from original Facepunch fretta file.
-- Copyright (c) 2013 Andrew Theis. All rights reserved.
--


local PANEL = {}

AccessorFunc( PANEL, "Spacing", 	"Spacing" )


function PANEL:Init()

	self.Items = {}

	self:SetSpacing( 8 )
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	
	self:ParentToHUD()

end


-- This makes it so that it's behind chat & hides when you're in the menu
-- But it also removes the ability to click on it. So override it if you want to.
function PANEL:ChooseParent()
	self:ParentToHUD()
end


function PANEL:Clear( bDelete )

	for k, panel in pairs( self.Items ) do
	
		if ( panel && panel:IsValid() ) then
		
			panel:SetParent( panel )
			panel:SetVisible( false )
		
			if ( bDelete ) then
				panel:Remove()
			end
			
		end
		
	end
	
	self.Items = {}

end


function PANEL:AddItem( item, relative, pos )

	if (!item || !item:IsValid()) then return end

	item.HUDPos = pos
	item.HUDrelative = relative
	
	item:SetVisible( true )
	item:SetParent( self )
	table.insert( self.Items, item )
	
	self:InvalidateLayout()

end

function PANEL:PositionItem( item )

	if ( item.Positioned ) then return end
	if ( IsValid( item.HUDrelative ) && item != item.HUDrelative ) then self:PositionItem( item.HUDrelative ) end
	
	local SPACING = self:GetSpacing()
	
	item:InvalidateLayout( true )

	if ( item.HUDPos == 7 || item.HUDPos == 8 || item.HUDPos == 9 ) then
		if ( IsValid( item.HUDrelative ) ) then
			item:MoveAbove( item.HUDrelative, SPACING )
		else
			item:AlignTop()
		end
	end
	
	if ( item.HUDPos == 4 || item.HUDPos == 5 || item.HUDPos == 6 ) then
		if ( IsValid( item.HUDrelative ) ) then
			item.y = item.HUDrelative.y
		else
			item:CenterVertical()
		end
	end
	
	if ( item.HUDPos == 1 || item.HUDPos == 2 || item.HUDPos == 3 ) then
		if ( IsValid( item.HUDrelative ) ) then
			item:MoveBelow( item.HUDrelative, SPACING )
		else
			item:AlignBottom()
		end
	end
	
	if ( item.HUDPos == 7 || item.HUDPos == 4 || item.HUDPos == 1 ) then
		if ( IsValid( item.HUDrelative ) ) then
			item.x = item.HUDrelative.x
		else
			item:AlignLeft()
		end
	end
	
	if ( item.HUDPos == 8 || item.HUDPos == 5 || item.HUDPos == 2 ) then
		if ( IsValid( item.HUDrelative ) ) then
			item.x = item.HUDrelative.x + ( item.HUDrelative:GetWide() - item:GetWide() ) / 2
		else
			item:CenterHorizontal()
		end
	end
	
	if ( item.HUDPos == 9 || item.HUDPos == 6 || item.HUDPos == 3 ) then
		if ( IsValid( item.HUDrelative ) ) then
			item.x = item.HUDrelative.x + item.HUDrelative:GetWide() - item:GetWide() 
		else
			item:AlignRight()
		end
	end
	
	if ( item.HUDPos == 4 && IsValid( item.HUDrelative ) ) then
		item:MoveLeftOf( item.HUDrelative, SPACING )
	end
	
	if ( item.HUDPos == 6 && IsValid( item.HUDrelative ) ) then
		item:MoveRightOf( item.HUDrelative, SPACING )
	end

	item.Positioned = true
	
end


function PANEL:Think()
	self:InvalidateLayout()
end


function PANEL:PerformLayout()

	self:SetPos( 32, 32 )
	self:SetWide( ScrW() - 64 )
	self:SetTall( ScrH() - 64 )

	for k, item in pairs( self.Items ) do
		item.Positioned = false
	end
	
	for k, item in pairs( self.Items ) do
		self:PositionItem( item )
	end

end

derma.DefineControl( "DHudLayout", "A HUD Layout Base", PANEL, "Panel" )