-- Abstract: Flashlight sample project
-- Demonstrates masking an image. The flashlight skews depending 
-- on location from center.
--
-- Version: 1.0 (September 1, 2010)
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.

display.setStatusBar( display.HiddenStatusBar )

local halfW = display.contentCenterX
local halfH = display.contentCenterY

-- Black background
local bkg = display.newRect( 0, 0, 768, 1024 )
bkg:setFillColor( 0 )

-- Image to be masked
local image = display.newImageRect( "image.png", 768, 1024 )
image:translate( halfW, halfH )

-- Mask
local mask = graphics.newMask( "circlemask.png" )
image:setMask( mask )


local radiusMax = math.sqrt( halfW*halfW + halfH*halfH )

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
			local maskX = event.x - t.x0
			local maskY = event.y - t.y0
			t.maskX = maskX
			t.maskY = maskY

			-- Stretch the flashlight as it moves further away 
			-- from the screen's center
			local radius = math.sqrt( maskX*maskX + maskY*maskY )
			local scaleDelta = radius/radiusMax
			t.maskScaleX = 1 + scaleDelta
			t.maskScaleY = 1 + 0.2 * scaleDelta

			-- Rotate it appropriately about screen center
			local rotation = math.deg( math.atan2( maskY, maskX ) )
			t.maskRotation = rotation

		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
		end
	end

	return true
end
image:addEventListener( "touch", onTouch )

-- Display instructions
local labelFont = "Zapfino" -- if not found, system font will be used
local myLabel = display.newText( "Touch circle to move flashlight", 0, 0, labelFont, 34 )
myLabel:setTextColor( 255, 255, 255, 180 )
myLabel.x = halfW
myLabel.y = 200

