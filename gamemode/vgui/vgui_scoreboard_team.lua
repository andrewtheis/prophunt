--
-- vgui_scoreboard_team.lua
-- Prop Hunt
--	
-- Created by Andrew Theis on 2013-10-31. Modified from original Facepunch fretta file.
-- Copyright (c) 2013 Andrew Theis. All rights reserved.
--


local PANEL = {}

Derma_Hook( PANEL, 	"Paint", 				"Paint", 	"TeamScoreboardHeader" )
Derma_Hook( PANEL, 	"ApplySchemeSettings", 	"Scheme", 	"TeamScoreboardHeader" )
Derma_Hook( PANEL, 	"PerformLayout", 		"Layout", 	"TeamScoreboardHeader" )
	
function PANEL:Init()

	self.Columns = {}
	self.iTeamID = 0
	self.PlayerCount = 0
	
	self.TeamName = vgui.Create( "DLabel", self )
	self.TeamScore = vgui.Create( "DLabel", self )

end

function PANEL:Setup( iTeam, pMainScoreboard )

	self.TeamName:SetText( team.GetName( iTeam ) )
	self.iTeamID = iTeam

end

function PANEL:Think()

	local Count = #team.GetPlayers( self.iTeamID )
	if ( self.PlayerCount != Count ) then
		self.PlayerCount = Count
		self.TeamName:SetText( team.GetName( self.iTeamID ) .. " (" .. self.PlayerCount .. " Players)" )
	end
	
	self.TeamScore:SetText( team.GetScore( self.iTeamID ) )

end

derma.DefineControl( "TeamScoreboardHeader", "", PANEL, "Panel" )




local PANEL = {}

function PANEL:Init()

	self.Columns = {}

	self.List = vgui.Create( "DListView", self )
	self.List:SetSortable( false )
	self.List:DisableScrollbar()
	
	self.Header = vgui.Create( "TeamScoreboardHeader", self )

end

function PANEL:Setup( iTeam, pMainScoreboard )

	self.iTeam = iTeam
	self.pMain = pMainScoreboard
	
	self.Header:Setup( iTeam, pMainScoreboard )

end

function PANEL:SizeToContents()

	self.List:SizeToContents()
	local tall = self.List:GetTall()
	
	self:SetTall( tall + self.Header:GetTall() )

end

function PANEL:PerformLayout()

	if ( self.pMain:GetShowScoreboardHeaders() ) then

		self.Header:SetPos( 0, 0 )
		self.Header:CopyWidth( self )

	else
	
		self.Header:SetTall( 0 )
		self.Header:SetVisible( false )
		
	end
	
	self:SizeToContents()
	self.List:StretchToParent( 0, self.Header:GetTall(), 0, 0 )
	self.List:SetDataHeight( self.pMain:GetRowHeight() )
	self.List:SetHeaderHeight( 16 )

end

function PANEL:AddColumn( col )

	table.insert( self.Columns, col )
	
	local pnlCol = self.List:AddColumn( col.Name )
	
	if (col.iFixedSize) then pnlCol:SetMinWidth( col.iFixedSize ) pnlCol:SetMaxWidth( col.iFixedSize ) end
	if (col.HeaderAlign) then 
		pnlCol.Header:SetContentAlignment( col.HeaderAlign ) 
	end

	Derma_Hook( pnlCol, 	"Paint", 				"Paint", 	"ScorePanelHeader" )
	
	pnlCol.cTeamColor = team.GetColor( self.iTeam )
	
	Derma_Hook( pnlCol.Header, 	"Paint", 				"Paint", 	"ScorePanelHeaderLabel" )
	Derma_Hook( pnlCol.Header, 	"ApplySchemeSettings", 	"Scheme", 	"ScorePanelHeaderLabel" )
	Derma_Hook( pnlCol.Header, 	"PerformLayout", 		"Layout", 	"ScorePanelHeaderLabel" )
	
	pnlCol.Header:ApplySchemeSettings()

end

function PANEL:SetSortColumns( ... )
	
	self.SortArgs = ...
	
end

function PANEL:FindPlayerLine( ply )

	for _, line in pairs( self.List.Lines ) do
		if ( line.pPlayer == ply ) then return line end
	end
	
	local line = self.List:AddLine()
	line.pPlayer = ply
	line.UpdateTime = {}
	
	Derma_Hook( line, 	"Paint", 				"Paint", 	"ScorePanelLine" )
	Derma_Hook( line, 	"ApplySchemeSettings", 	"Scheme", 	"ScorePanelLine" )
	Derma_Hook( line, 	"PerformLayout", 		"Layout", 	"ScorePanelLine" )
	
	self.pMain:InvalidateLayout()
	
	return line

end

function PANEL:UpdateColumn( i, col, pLine )

	if ( !col.fncValue ) then return end
	
	pLine.UpdateTime[i] = pLine.UpdateTime[i] or 0
	if ( col.UpdateRate == 0 && pLine.UpdateTime[i] != 0 ) then return end // 0 = only update once
	if ( pLine.UpdateTime[i] > RealTime() ) then return end
	
	pLine.UpdateTime[i] = RealTime() + col.UpdateRate
	
	local Value = col.fncValue( pLine.pPlayer )
	if ( Value == nil ) then return end
	
	local lbl = pLine:SetColumnText( i, Value )
	if ( IsValid( lbl ) && !lbl.bScorePanelHooks ) then
	
		lbl.bScorePanelHooks = true
		
		if ( col.ValueAlign ) then lbl:SetContentAlignment( col.ValueAlign ) end
		if ( col.Font ) then lbl:SetFont( col.Font ) end
		
		lbl.pPlayer = pLine.pPlayer
	
		Derma_Hook( lbl, 	"Paint", 				"Paint", 	"ScorePanelLabel" )
		Derma_Hook( lbl, 	"ApplySchemeSettings", 	"Scheme", 	"ScorePanelLabel" )
		Derma_Hook( lbl, 	"PerformLayout", 		"Layout", 	"ScorePanelLabel" )
	
	end

	
end

function PANEL:UpdateLine( pLine )

	for i, col in pairs( self.Columns ) do
		self:UpdateColumn( i, col, pLine )
	end
	
end

function PANEL:CleanLines( pLine )

	for k, line in pairs( self.List.Lines ) do
	
		if ( !IsValid( line.pPlayer ) || line.pPlayer:Team() != self.iTeam ) then 
			self.List:RemoveLine( k ) 
		end
		
	end
	
end

function PANEL:Think()

	self:CleanLines()
	
	local players = team.GetPlayers( self.iTeam )
	for _, player in pairs( players ) do
		
		local line = self:FindPlayerLine( player )
		self:UpdateLine( line )
		
	end
	
	if ( self.SortArgs ) then
		self.List:SortByColumns( unpack(self.SortArgs) )
	end

end

derma.DefineControl( "TeamScoreboard", "", PANEL, "Panel" )