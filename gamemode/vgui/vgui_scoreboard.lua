--
-- vgui_scoreboard.lua
-- Prop Hunt
--	
-- Created by Andrew Theis on 2013-10-31. Modified from original Facepunch fretta file.
-- Copyright (c) 2013 Andrew Theis. All rights reserved.
--


include( "vgui_scoreboard_team.lua" )
include( "vgui_scoreboard_small.lua" )

local PANEL = {}

Derma_Hook( PANEL, 	"Paint", 				"Paint", 	"ScoreHeader" )
Derma_Hook( PANEL, 	"ApplySchemeSettings", 	"Scheme", 	"ScoreHeader" )
Derma_Hook( PANEL, 	"PerformLayout", 		"Layout", 	"ScoreHeader" )


function PANEL:Init()

	self.Columns = {}
	self.iTeamID = 0
	
	self.HostName = vgui.Create( "DLabel", self )
	self.HostName:SetText( GetHostName() )
	
	self.GamemodeName = vgui.Create( "DLabel", self )
	self.GamemodeName:SetText( GAMEMODE.Name )
	
	self:SetHeight( 64 )

end

derma.DefineControl( "ScoreboardHeader", "", PANEL, "Panel" )


local PANEL = {}


AccessorFunc( PANEL, "m_bHorizontal", "Horizontal" )
AccessorFunc( PANEL, "m_iPadding", "Padding" )
AccessorFunc( PANEL, "m_iRowHeight", "RowHeight" )
AccessorFunc( PANEL, "m_bShowScoreHeaders", "ShowScoreboardHeaders" )

Derma_Hook( PANEL, 	"Paint", 				"Paint", 	"ScorePanel" )
Derma_Hook( PANEL, 	"ApplySchemeSettings", 	"Scheme", 	"ScorePanel" )
Derma_Hook( PANEL, 	"PerformLayout", 		"Layout", 	"ScorePanel" )

function PANEL:Init()

	self.SortDesc = true

	self.Boards = {}
	self.SmallBoards = {}
	self.Columns = {}

	self:SetRowHeight( 32 )
	self:SetHorizontal( false )
	self:SetPadding( 10 )
	self:SetShowScoreboardHeaders( true )
	
	self.Header = vgui.Create( "ScoreboardHeader", self )
	
	local teams = team.GetAllTeams()
	for k, v in pairs( teams ) do
			
		local ScoreBoard = vgui.Create( "TeamScoreboard", self )
		ScoreBoard:Setup( k, self )
		self.Boards[ k ] = ScoreBoard
		
	end

end

function PANEL:SetAsBullshitTeam( iTeamID )

	if ( IsValid( self.Boards[ iTeamID ] ) ) then
		self.Boards[ iTeamID ]:Remove()
		self.Boards[ iTeamID ] = nil
	end
	
	self.SmallBoards[ iTeamID ] = vgui.Create( "TeamBoardSmall", self )
	self.SmallBoards[ iTeamID ]:Setup( iTeamID, self )
	
end

function PANEL:SetSortColumns( ... )

	for k, v in pairs( self.Boards ) do
		v:SetSortColumns( ... )
	end

end

function PANEL:AddColumn( Name, iFixedSize, fncValue, UpdateRate, TeamID, HeaderAlign, ValueAlign, Font )

	local Col = {}
	
	Col.Name = Name
	Col.iFixedSize = iFixedSize
	Col.fncValue = fncValue
	Col.TeamID = TeamID
	Col.UpdateRate = UpdateRate
	Col.ValueAlign = ValueAlign
	Col.HeaderAlign = HeaderAlign
	Col.Font = Font
	
	for k, v in pairs( self.Boards ) do
		v:AddColumn( Col )
	end
	
	return Col

end

function PANEL:Layout4By4( y )

	local a = self.Boards[1]
	local b = self.Boards[2]
	local c = self.Boards[3]
	local d = self.Boards[4]
	
	local widtheach = (self:GetWide() - ( self.m_iPadding * 3 )) / 2
	
	for k, v in pairs( self.Boards ) do
	
		v:SizeToContents()
		v:SetWide( widtheach )
		
	end
	
	a:SetPos( self.m_iPadding, y + self.m_iPadding )
	b:SetPos( a:GetPos() + a:GetWide() + self.m_iPadding, y + self.m_iPadding )
	
	local height = a:GetTall() + a.y
	height = math.max( b:GetTall() + b.y, height )
	height = height + self.m_iPadding * 2
	
	c:SetPos( self.m_iPadding, height )
	d:SetPos( c:GetPos() + c:GetWide() + self.m_iPadding, height )
	
	local height = d:GetTall() + d.y
	height = math.max( c:GetTall() + c.y, height )
	height = height + self.m_iPadding * 2
	
	return height

end

function PANEL:LayoutHorizontal( y )

	local cols = table.Count( self.Boards )
	
	if ( cols == 4 ) then
		return self:Layout4By4( y )
	end
	
	local widtheach = (self:GetWide() - ( self.m_iPadding * (cols+1) )) / cols
	
	local x = self.m_iPadding
	local tallest = 0 
	for k, v in pairs( self.Boards ) do
	
		v:SizeToContents()
		v:SetPos( x, y )
		v:SetWide( widtheach )
		
		x = x + widtheach + self.m_iPadding
		tallest = math.max( tallest, y + v:GetTall() + self.m_iPadding )
		
	end
	
	return tallest

end

function PANEL:LayoutVertical( y )

	for k, v in pairs( self.Boards ) do
	
		v:SizeToContents()
		v:SetPos( self.m_iPadding, y )
		v:SetWide( self:GetWide() - self.m_iPadding * 2 )
		y = y + v:GetTall() + self.m_iPadding
		
	end
	
	return y

end

function PANEL:PerformLayout()

	local y = 0
	
	if ( IsValid( self.Header ) ) then
	
		self.Header:SetPos( 0, 0 )
		self.Header:SetWidth( self:GetWide() )
	
		y = y + self.Header:GetTall() + self.m_iPadding
	
	end
	
	if ( self.m_bHorizontal ) then
		y = self:LayoutHorizontal( y )
	else
		y = self:LayoutVertical( y )
	end
	
	for k, v in pairs( self.SmallBoards ) do
	
		if ( v:ShouldShow() ) then
		
			v:SizeToContents()
			
			v:SetPos( self.m_iPadding, y )
			v:CenterHorizontal()
			
			y = y + v:GetTall() + self.m_iPadding
		end
		
	end

end

derma.DefineControl( "PHScoreboard", "", PANEL, "DPanel" )
