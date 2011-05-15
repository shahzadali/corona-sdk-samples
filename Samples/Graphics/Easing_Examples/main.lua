-- Project: Easing_Examples
--
-- File: main.Lua
-- Author: Michael Hartlef and Tom Newman
--
-- Date: June 6, 2010
--
-- Version: 1.0
-- 
-- Abstract: An example of using Corona Easing functions
-- From MikeHart in Corona Forum
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.

--------------------------------------------------------------------------------

--------------------------------
-- Easing Functions Start Here
--------------------------------

--linear
local function ease1()
	if not text1 then
		text1 = display.newText( "Linear", 0, 10, "Verdana-Bold", 12 )
		text1:setTextColor( 255,0,0 )
	end
	
	if not circle1 then
		circle1 = display.newCircle(20, 60, 10 )
		circle1:setFillColor(255,0,0,255)
	else
		circle1.y = 60
	end

	transition.to(circle1, {time=3000, y=460})
end

--inOutExpo
local function ease2()
	if not text2 then
		text2 = display.newText( "inOutExpo", 45, 30, "Verdana-Bold", 12 )
		text2:setTextColor( 255,0,255 )
	end
	
	if not circle2 then
		circle2 = display.newCircle(65, 60, 10 )
		circle2:setFillColor(255,0,255,255)
	else
		circle2.y = 60
	end
	
	transition.to(circle2, {time=3000, y=460, transition = easing.inOutExpo})
end

--inOutQuad   <<<< There seems to be a bug with that function
local function ease3()
	if not text3 then
		text3 = display.newText( "inOutQuad", 90, 10, "Verdana-Bold", 12 )
		text3:setTextColor( 255,255,255 )
	end
	
	if not circle3 then
		circle3 = display.newCircle(110, 60, 10 )
		circle3:setFillColor(255,255,255,255)
	else
		circle3.y = 60
	end
	
	transition.to(circle3, {time=3000, y=460, transition = easing.inOutQuad})
end

--outExpo
local function ease4()
	if not text4 then
		text4 = display.newText( "outExpo", 135, 30, "Verdana-Bold", 12 )
		text4:setTextColor( 0,255,255 )
	end
	
	if not circle4 then	
		circle4 = display.newCircle(155, 60, 10 )
		circle4:setFillColor(0,255,255,255)
	else
		circle4.y = 60
	end
	
	transition.to(circle4, {time=3000, y=460, transition = easing.outExpo})
end

--outQuad
local function ease5()
	if not text5 then
		text5 = display.newText( "outQuad", 180, 10, "Verdana-Bold", 12 )
		text5:setTextColor( 0,0,255 )
	end

	if not circle5 then		
		circle5 = display.newCircle(200, 60, 10 )
		circle5:setFillColor(0,0,255,255)
	else
		circle5.y = 60
	end
	
	transition.to(circle5, {time=3000, y=460, transition = easing.outQuad})
end

--inExpo
local function ease6()
	if not text6 then
		text6 = display.newText( "inExpo", 225, 30, "Verdana-Bold", 12 )
		text6:setTextColor( 255,255,0 )
	end

	if not circle6 then				 
		circle6 = display.newCircle(245, 60, 10 )
		circle6:setFillColor(255,255,0,255)
	else
		circle6.y = 60
	end
	
	transition.to(circle6, {time=3000, y=460, transition = easing.inExpo})
end

--inQuad
local function ease7()
	if not text7 then
		text7 = display.newText( "inQuad", 270, 10, "Verdana-Bold", 12 )
		text7:setTextColor( 0,255,0 )
	end

	if not circle7 then		 
		circle7 = display.newCircle(290, 60, 10 )
		circle7:setFillColor(0,255,0,255)
	else
		circle7.y = 60
	end
	
	transition.to(circle7, {time=3000, y=460, transition = easing.inQuad})
end


--------------------------------
-- Code Excution Start Here
--------------------------------

-- 0 = start all Easing samples; 1 to 7 = individual easing sample
local currentEasing = 0

display.setStatusBar( display.HiddenStatusBar )
 
local bkgd = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
bkgd:setFillColor( 0, 0, 0 )		-- black background

-- Table of functions for each Easing example
trans = {ease1, ease2, ease3, ease4, ease5, ease6, ease7}

-- Start all the Easing transitions


 
local text = display.newText( "Tap to start the Easing samples", 0, 0, nil, 16 )
text:setTextColor( 255, 255, 255 )
text.x = 0.5 * display.contentWidth
text.y = 0.5 * display.contentHeight

-- Tapping the first time starts all the Easing samples
-- Each tap after the first cycles through each Easing function
--
local listener = function( event )
	if currentEasing == 0 then
		-- Start all the transitions at once
		ease1(); ease2(); ease3(); ease4(); ease5(); ease6(); ease7()
		text.text = "Tap to cycle through Easing functions"
	else
		trans[currentEasing]()		-- do one Easing function at a time
	end
	
	currentEasing = currentEasing + 1
	
	if currentEasing > 7 then currentEasing = 1 end
end

-- Add listener to background for user "tap"
bkgd:addEventListener( "tap", listener )