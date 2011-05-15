-- 
-- Abstract: PolyLines sample app, demonstrating how to draw shapes using line segments
-- 
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.


-- Example of shape drawing function
local function newStar()

	-- need initial segment to start
	local star = display.newLine( 0,-110, 27,-35 ) 

	-- further segments can be added later
	star:append( 105,-35, 43,16, 65,90, 0,45, -65,90, -43,15, -105,-35, -27,-35, 0,-110 )

	-- default color and width (can also be modified later)
	star:setColor( 255, 255, 255, 255 )
	star.width = 3

	return star
end


-- Create stars with random color and position
local stars = {}

for i = 1, 20 do

	local myStar = newStar()
	
	myStar:setColor( math.random(255), math.random(255), math.random(255), math.random(200) + 55 )
	myStar.width = math.random(10)
	
	myStar.x = math.random( display.contentWidth )
	myStar.y = math.random( display.contentHeight )
	myStar.rotation = math.random(360)
	
	myStar.xScale = math.random(150)/100 + 0.5
	myStar.yScale = myStar.xScale
	
	myStar:setReferencePoint( display.CenterReferencePoint )

	local dr = math.random( 1, 4 )
	myStar.dr = dr
	if ( math.random() < 0.5 ) then
		myStar.dr = -dr
	end

	table.insert( stars, myStar )
end


function stars:enterFrame( event )

	for i,v in ipairs( self ) do
		v.rotation = v.rotation + v.dr
	end
end

Runtime:addEventListener( "enterFrame", stars )
