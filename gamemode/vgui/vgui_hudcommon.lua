local PANEL = {}
AccessorFunc( PANEL, "m_Items", 	"Items" )
AccessorFunc( PANEL, "m_Horizontal", 	"Horizontal" )
AccessorFunc( PANEL, "m_Spacing", 		"Spacing" )

AccessorFunc( PANEL, "m_AlignBottom", 	"AlignBottom" )
AccessorFunc( PANEL, "m_AlignCenter", 	"AlignCenter" )

function PANEL:Init()
	self.m_Items = {}
	self:SetHorizontal( true )
	self:SetText( "" )
	self:SetAlignCenter( true )
	self:SetSpacing( 8 )
end

function PANEL:AddItem( item )
	item:SetParent( self )
	table.insert( self.m_Items, item )
	self:InvalidateLayout()
	item:SetPaintBackgroundEnabled( false )
	item.m_bPartOfBar = true
end

function PANEL:PerformLayout()

	if ( self.m_Horizontal ) then
	local x = self.m_Spacing
	local tallest = 0
	for k, v in pairs( self.m_Items ) do
	
		v:SetPos( x, 0 )
		x = x + v:GetWide() + self.m_Spacing
		tallest = math.max( tallest, v:GetTall() )
		
		if ( self.m_AlignBottom ) then v:AlignBottom() end
		if ( self.m_AlignCenter ) then v:CenterVertical() end
	
	end
	self:SetSize( x, tallest )
	else
		// todo.
	end

end

derma.DefineControl( "DHudBar", "", PANEL, "HudBase" )

local PANEL = {}
AccessorFunc( PANEL, "m_ValueFunction", 	"ValueFunction" )
AccessorFunc( PANEL, "m_ColorFunction", 	"ColorFunction" )


function PANEL:Init()
	
end

function PANEL:GetTextValueFromFunction()
	if (!self.m_ValueFunction) then return "-" end
	return tostring( self:m_ValueFunction() )
end

function PANEL:GetColorFromFunction()
	if (!self.m_ColorFunction) then return self:GetDefaultTextColor() end
	return self:m_ColorFunction()
end

function PANEL:Think()
	self:SetTextColor( self:GetColorFromFunction() )
	self:SetText( self:GetTextValueFromFunction() )
end

derma.DefineControl( "DHudUpdater", "A HUD Element", PANEL, "DHudElement" )


local PANEL = {}
AccessorFunc( PANEL, "m_Function", 	"Function" )


function PANEL:Init()
	HudBase.Init( self )
end

function PANEL:Think()

	if ( !self.m_ValueFunction ) then return end
	
	self:SetTextColor( self:GetColorFromFunction() )
	
	local EndTime = self:m_ValueFunction()
	if ( EndTime == -1 ) then return end
	
	if ( !EndTime || EndTime < CurTime() ) then 
		self:SetText( "00:00" )
		return
	end
	
	local Time = util.ToMinutesSeconds( EndTime - CurTime() )
	self:SetText( Time )

end

derma.DefineControl( "DHudCountdown", "A HUD Element", PANEL, "DHudUpdater" )