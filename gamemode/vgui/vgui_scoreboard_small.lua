--
-- vgui_scoreboard_small.lua
-- Prop Hunt
--	
-- Created by Andrew Theis on 2013-10-31. Modified from original Facepunch fretta file.
-- Copyright (c) 2013 Andrew Theis. All rights reserved.
--


local PANEL = {}

Derma_Hook( PANEL, 	"Paint", 				"Paint", 	"SpectatorInfo" )
Derma_Hook( PANEL, 	"ApplySchemeSettings", 	"Scheme", 	"SpectatorInfo" )
Derma_Hook( PANEL, 	"PerformLayout", 		"Layout", 	"SpectatorInfo" )


function PANEL:Init()

	self.LastThink = 0

end


function PANEL:Setup( iTeam, pMainScoreboard )

	self.iTeam = iTeam

end


function PANEL:GetPlayers()

	return team.GetPlayers( self.iTeam )

end

function PANEL:ShouldShow()
	
	local players = team.GetPlayers( self.iTeam )
	if (!players || #players == 0) then return false end
	
	return true
	
end


function PANEL:UpdateText( NewText )

	local OldText = self:GetValue()
	if (OldText == NewText) then return end
	
	self:SetText(NewText)
	self:SizeToContents()
	self:InvalidateLayout()
	self:GetParent():InvalidateLayout()

end


function PANEL:Think()

	if (self.LastThink > RealTime()) then return end
	self.LastThink = RealTime() + 1
	
	local players = team.GetPlayers( self.iTeam )
	if (!players || #players == 0) then 
		local OldText = self:GetValue()
		self:UpdateText( "" ) 
		return 
	end
	
	local Str = team.GetName( self.iTeam ) .. ": "
		
	for k, v in pairs( players ) do
		Str = Str .. v:Name() .. ", "
	end
	
	Str = Str:sub( 0, -3 )
	self:UpdateText( Str ) 
	
end

derma.DefineControl( "TeamBoardSmall", "", PANEL, "DLabel" )