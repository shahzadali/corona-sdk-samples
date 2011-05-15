-- Abstract: X-ray sample project
-- Demonstrates masking an image
--
-- Version: 1.0 (September 1, 2010)
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.

display.setStatusBar( display.HiddenStatusBar )

local halfW = display.contentCenterX
local halfH = display.contentCenterY

-- Background image
local bkg = display.newImage( "paper_bkg.png", true )
bkg.x = halfW
bkg.y = halfH

-- Image that the x-ray reveals. In display object rendering,
-- this is above the background. The mask effect makes it look
-- underneath
local image = display.newImage( "grid.png", true )
image.alpha = 0.7

-- The mask that creates the X-ray effect.
local mask = graphics.newMask( "circlemask.png" )
image:setMask( mask )

function onTouch( event )
	local t = event.target

	local phase = event.phase
	if "began" == phase then
		display.getCurrentStage():setFocus( t )

		-- Spurious events can be sent to the target, e.g. the user presses 
		-- elsewhere on the screen and then moves the finger over the target.
		-- To prevent this, we add this flag. Only when it's true will "move"
		-- events be sent to the target.
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.maskX
		t.y0 = event.y - t.maskY
	elseif t.isFocus then
		if "moved" == phase then
			-- Make object move (we subtract t.x0,t.y0 so that moves are
			-- relative to initial grab point, rather than object "snapping").
			t.maskX = event.x - t.x0
			t.maskY = event.y - t.y0
		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
		end
	end

	return true
end
image:addEventListener( "touch", onTouch )

-- Display instructions
local labelFont = "Zapfino"
local myLabel = display.newText( "Move circle to see behind paper", 0, 0, labelFont, 34 )
myLabel:setTextColor( 255, 255, 255, 180 )
myLabel.x = display.contentWidth/2
myLabel.y = 200

