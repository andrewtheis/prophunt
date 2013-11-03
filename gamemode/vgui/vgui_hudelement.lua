local PANEL = {}

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

end

function PANEL:SetLabel( text )

	self.LabelPanel = vgui.Create( "DLabel", self )
	self.LabelPanel:SetText( text )
	self.LabelPanel:SetTextColor( self:GetTextLabelColor() )
	self.LabelPanel:SetFont( self:GetTextLabelFont() )

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self:SetContentAlignment( 5 )

	if ( self.LabelPanel ) then
		self.LabelPanel:SetPos( self:GetPadding(), self:GetPadding() )
		self.LabelPanel:SizeToContents()
		self.LabelPanel:SetSize( self.LabelPanel:GetWide() + self:GetPadding() * 0.5, self.LabelPanel:GetTall() + self:GetPadding() * 0.5 )
		self:SetTextInset( self.LabelPanel:GetWide() + self:GetPadding(), 0 )
		self:SetContentAlignment( 4 )
	end

	self:SizeToContents( )
	self:SetSize( self:GetWide() + self:GetPadding(), self:GetTall() + self:GetPadding() )
	
end

derma.DefineControl( "DHudElement", "A HUD Element", PANEL, "HudBase" )
