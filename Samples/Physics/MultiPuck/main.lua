-- Abstract: MultiPuck sample project
-- Demonstrates multitouch and draggable phyics objects using "touch joints" in gameUI library
--
-- Version: 1.0 (September 1, 2010)
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.

display.setStatusBar( display.HiddenStatusBar )

local physics = require("physics")
local gameUI = require("gameUI")
local easingx  = require("easingx")

physics.start()
physics.setGravity( 0, 0 ) -- no gravity in any direction

popSound = audio.loadSound ("pop2_wav.wav")
labelFont = gameUI.newFontXP{ ios="Zapfino", android=native.systemFont }

system.activate( "multitouch" )

local bkg = display.newImage( "paper_bkg.png", true )
bkg.x = display.contentWidth/2
bkg.y = display.contentHeight/2

local myLabel = display.newText( "Touch screen to create pucks", 0, 0, labelFont, 34 )
myLabel:setTextColor( 255, 255, 255, 180 )
myLabel.x = display.contentWidth/2
myLabel.y = 200

local diskGfx = { "puck_yellow.png", "puck_green.png", "puck_red.png" }
local allDisks = {} -- empty table for storing objects

-- Automatic culling of offscreen objects
local function removeOffscreenItems()
	for i = 1, #allDisks do
		local oneDisk = allDisks[i]
		if (oneDisk.x) then
			if oneDisk.x < -100 or oneDisk.x > display.contentWidth + 100 or oneDisk.y < -100 or oneDisk.y > display.contentHeight + 100 then
				oneDisk:removeSelf()
			end	
		end
	end
end

local function dragBody( event )
	gameUI.dragBody( event )
	
	-- Substitute one of these lines for the line above to see what happens!
	--gameUI.dragBody( event, { maxForce=400, frequency=5, dampingRatio=0.2 } ) -- slow, elastic dragging
	--gameUI.dragBody( event, { maxForce=20000, frequency=1000, dampingRatio=1.0, center=true } ) -- very tight dragging, snaps to object center
end

local function spawnDisk( event )
	local phase = event.phase
	
	if "ended" == phase then
		audio.play( popSound )
		myLabel.isVisible = false

		randImage = diskGfx[ math.random( 1, 3 ) ]
		allDisks[#allDisks + 1] = display.newImage( randImage )
		local disk = allDisks[#allDisks]
		disk.x = event.x; disk.y = event.y
		disk.rotation = math.random( 1, 360 )
		disk.xScale = 0.8; disk.yScale = 0.8
		
		transition.to(disk, { time = 500, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic }) -- "pop" animation
		
		physics.addBody( disk, { density=0.3, friction=0.6, radius=66.0 } )
		disk.linearDamping = 0.4
		disk.angularDamping = 0.6
		
		disk:addEventListener( "touch", dragBody ) -- make object draggable
	end
end

bkg:addEventListener( "touch", spawnDisk ) -- touch the screen to create disks
Runtime:addEventListener( "enterFrame", removeOffscreenItems ) -- clean up offscreen disks
