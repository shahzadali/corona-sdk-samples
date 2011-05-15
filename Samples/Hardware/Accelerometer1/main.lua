-- Abstract: Accelerometer sample
--
-- Date: August 24, 2010
--
-- Version: 1.1
--
-- File name: main.lua
--
-- Author: Ansca Mobile
--
-- Demonstrates: 
-- 		Demonstrates use of the accelerometer.
--		Displays accelerometer values on screen and moves objected based on values.
--		Beeps and displays message when Shake detected.
--
-- File dependencies: none
--
-- Target devices: iPhone and Android
--
-- Limitations: Accelerator doesn't work on Simulator (execpt for Shake)
--
-- Update History:
--
-- Comments: 
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
---------------------------------------------------------------------------------------
display.setStatusBar( display.HiddenStatusBar )		-- hide status bar

-- Displays App title
title = display.newText( "Accelerator / Shake", 0, 20, "Verdana-Bold", 20 )
title.x = display.contentWidth/2		-- center title
title:setTextColor( 255,255,0 )

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Accelerator is not supported on Simulator
--
if isSimulator then
	msg = display.newText( "Accelerometer not supported on Simulator", 0, 55, "Verdana-Bold", 13 )
	msg.x = display.contentWidth/2		-- center title
	msg:setTextColor( 255,255,0 )
end

local soundID = audio.loadSound ("beep_wav.wav")

-----------------------------------------------------------
-- Create Text and Display Objects
-----------------------------------------------------------

-- Text parameters
local labelx = 50
local x = 220
local y = 95
local fontSize = 24

local frameUpdate = false					-- used to update our Text Color (once per frame)

local xglabel = display.newText( "gravity x = ", labelx, y, native.systemFont, fontSize ) 
xglabel:setTextColor(255,255,255)
local xg = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
xg:setTextColor(255,255,255)
y = y + 25
local yglabel = display.newText( "gravity y = ", labelx, y, native.systemFont, fontSize ) 
local yg = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
yglabel:setTextColor(255,255,255)
yg:setTextColor(255,255,255)
y = y + 25
local zglabel = display.newText( "gravity z = ", labelx, y, native.systemFont, fontSize ) 
local zg = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
zglabel:setTextColor(255,255,255)
zg:setTextColor(255,255,255)
y = y + 50
local xilabel = display.newText( "instant x = ", labelx, y, native.systemFont, fontSize ) 
local xi = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
xilabel:setTextColor(255,255,255)
xi:setTextColor(255,255,255)
y = y + 25
local yilabel = display.newText( "instant y = ", labelx, y, native.systemFont, fontSize ) 
local yi = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
yilabel:setTextColor(255,255,255)
yi:setTextColor(255,255,255)
y = y + 25
local zilabel = display.newText( "instant z = ", labelx, y, native.systemFont, fontSize ) 
local zi = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
zilabel:setTextColor(255,255,255)
zi:setTextColor(255,255,255)

-- Create a circle that moves with Accelerator events (for visual effects)
--
local centerX = display.contentWidth / 2
local centerY = display.contentHeight / 2

Circle = display.newCircle(0, 0, 20)
Circle.x = centerX
Circle.y = centerY
Circle:setFillColor( 0, 0, 255 )		-- blue

-----------------------------------------------------------
-- textMessage() --
-----------------------------------------------------------
-- v1.0
--
-- Create a message that is displayed for a few seconds.
-- Text is centered horizontally on the screen.
--
-- Enter:	str = text string
--			scrTime = time (in seconds) message stays on screen (0 = forever) -- defaults to 3 seconds
--			location = placement on the screen: "Top", "Middle", "Bottom" or number (y)
--			size = font size (defaults to 24)
--			color = font color (table) (defaults to white)
--
-- Returns:	text object (for removing or hiding later)
--
local textMessage = function( str, location, scrTime, size, color, font )

	local x, t
	
	size = tonumber(size) or 24
	color = color or {255, 255, 255}
	font = font or "Helvetica"

	-- Determine where to position the text on the screen
	if "string" == type(location) then
		if "Top" == location then
			x = display.contentHeight/4
		elseif "Bottom" == location then
			x = (display.contentHeight/4)*3
		else
			-- Assume middle location
			x = display.contentHeight/2
		end
	else
		-- Assume it's a number -- default to Middle if not
		x = tonumber(location) or display.contentHeight/2
	end
	
	scrTime = (tonumber(scrTime) or 3) * 1000		-- default to 3 seconds (3000) if no time given

	t = display.newText(str, 0, 0, font, size )
	t.x = display.contentWidth/2
	t.y = x
	t:setTextColor( color[1], color[2], color[3] )
	
	-- Time of 0 = keeps on screen forever (unless removed by calling routine)
	--
	if scrTime ~= 0 then
	
		-- Function called after screen delay to fade out and remove text message object
		local textMsgTimerEnd = function()
			transition.to( t, {time = 500, alpha = 0}, 
				function() t.removeSelf() end )
		end
	
		-- Keep the message on the screen for the specified time delay
		timer.performWithDelay( scrTime, textMsgTimerEnd )
	end
	
	return t		-- return our text object in case it's needed
	
end	-- textMessage()
-----------------------------------------------------------


-----------------------------------------------------------
-- Hardware Events
-----------------------------------------------------------

-- Display the Accerator Values
--
-- Update the text color once a frame based on sign of the value
--
local function 	xyzFormat( obj, value)

	obj.text = string.format( "%1.3f", value )
	
	-- Exit if not time to update text color
	if not frameUpdate then return end
	
	if value < 0.0 then
		-- Only update the text color if the value has changed
		if obj.positive ~= false then 
			obj:setTextColor( 255, 0, 0 )		-- red if negative
			obj.positive = false
			print("[---]")
		end
	else

		if obj.positive ~= true then 
			obj:setTextColor( 255, 255, 255)		-- white if postive
			obj.positive = true
			print("+++")
		end

	end
end


-- event.xGravity is the acceleration due to gravity in the x-direction
-- event.yGravity
-- event.yGravity is the acceleration due to gravity in the y-direction
-- event.zGravity
-- event.zGravity is the acceleration due to gravity in the z-direction
-- event.xInstant
-- event.xInstant is the instantaneous acceleration in the x-direction
-- event.yInstant
-- event.yInstant is the instantaneous acceleration in the y-direction
-- event.zInstant
-- event.zInstant is the instantaneous acceleration in the z-direction
-- event.isShake
-- event.isShake is true when the user shakes the device

-- Called for Accelerator events
--
-- Update the display with new values
-- If shake detected, make sound and display message for a few seconds
--
local function onAccelerate( event )

	-- Format and display the Accelerator values
	--
	xyzFormat( xg, event.xGravity)
	xyzFormat( yg, event.yGravity)
	xyzFormat( zg, event.zGravity)
	xyzFormat( xi, event.xInstant)
	xyzFormat( yi, event.yInstant)	
	xyzFormat( zi, event.zInstant)	
	
	frameUpdate = false		-- update done 
	
	-- Move our object based on the accelerator values
	--
	Circle.x = centerX + (centerX * event.xGravity)
	Circle.y = centerY + (centerY * event.yGravity * -1)

	-- Display message and sound beep if Shake'n
	--
	if event.isShake == true then
		-- str, location, scrTime, size, color, font
		textMessage( "Shake!", 400, 3, 52, {255, 255, 0} )
		audio.play( soundID )
	end
end

-- Function called every frame
-- Sets update flag to time our color changes
--
local function onFrame()
	frameUpdate = true
	
--[[
	if xg.positive == true then
		xg:setTextColor( 255, 255, 255)	-- white if postive
	else
		xg:setTextColor( 255, 0, 0)		-- red if negative
	end
--]]
end

-- Add runtime listeners
--
Runtime:addEventListener ("accelerometer", onAccelerate);
Runtime:addEventListener ("enterFrame", onFrame);
