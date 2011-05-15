-- Project: DeviceInfo
--
-- Date: Oct 7, 2010
--
-- Version: 1.2
--
-- File name: main.lua
--
-- Author: Ansca
--
-- Abstract: Displays Device and Corona Information on Screen
--
-- Demonstrates: system.getInfo() API, system.getPreference() API
--
-- File dependencies: none
--
-- Target devices: Simulator, iPhone/iPad, Android
--
-- Limitations:
--
-- Update History:
--	v1.1		Fixed UDID display problem
--  v1.2		Add system.getPreference() API
--
-- Comments:
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
---------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )		-- hide status bar

local background = display.newImage( "wood_bg.jpg", true )
background.x = display.contentWidth / 2
background.y = display.contentHeight / 2
background.alpha = 0.8

-- Define colors for labels
lbl = {red = 255, green = 180, blue = 90}
txt = {red = 255, green = 255, blue = 255}

-------------------------------------------
-- *** Add Device labels ***
-------------------------------------------

local x = 20		-- x value for label fields
local y = 40		-- y value for label fields	
local yOffset = 30	-- y offset between fields

local itemLabel = display.newText( "Device Info",100, 30, native.systemFont, 24 )
itemLabel:setTextColor( 255, 255, 255)

itemLabel = display.newText( "name:", x+85, y+yOffset*1, native.systemFont, 16 )
itemLabel:setTextColor(lbl.red, lbl.green, lbl.blue)

itemLabel = display.newText( "model:", x+78, y+yOffset*2, native.systemFont, 16 )
itemLabel:setTextColor(lbl.red, lbl.green, lbl.blue)

itemLabel = display.newText( "environment:", x+30, y+yOffset*3, native.systemFont, 16 )
itemLabel:setTextColor(lbl.red, lbl.green, lbl.blue)

itemLabel = display.newText( "platformName:", x+15, y+yOffset*4, native.systemFont, 16 )
itemLabel:setTextColor(lbl.red, lbl.green, lbl.blue)

itemLabel = display.newText( "platformVersion:", x+2, y+yOffset*5, native.systemFont, 16 )
itemLabel:setTextColor(lbl.red, lbl.green, lbl.blue)

itemLabel = display.newText( "version (Corona):", x, y+yOffset*6, native.systemFont, 16 )
itemLabel:setTextColor(lbl.red, lbl.green, lbl.blue)

itemLabel = display.newText( "build (Corona):", x+19, y+yOffset*7, native.systemFont, 16 )
itemLabel:setTextColor(lbl.red, lbl.green, lbl.blue)

itemLabel = display.newText( "deviceID:", x+10, y+yOffset*8, native.systemFont, 16 )
itemLabel:setTextColor(lbl.red, lbl.green, lbl.blue)

itemLabel = display.newText( "language:", x+57, y+yOffset*10, native.systemFont, 16 )
itemLabel:setTextColor(lbl.red, lbl.green, lbl.blue)

itemLabel = display.newText( "country:", x+69, y+yOffset*11, native.systemFont, 16 )
itemLabel:setTextColor(lbl.red, lbl.green, lbl.blue)

itemLabel = display.newText( "locale:", x+83, y+yOffset*12, native.systemFont, 16 )
itemLabel:setTextColor(lbl.red, lbl.green, lbl.blue)

itemLabel = display.newText( "language code:", x+15, y+yOffset*13, native.systemFont, 16 )
itemLabel:setTextColor(lbl.red, lbl.green, lbl.blue)

-------------------------------------------
-- *** Add Device text ***
-------------------------------------------

-- Calls system.getInfo to fill in the Device Info fields

local xText = 160		-- x value for Text fields
local itemText

itemText = display.newText( system.getInfo( "name" ),
	xText, y+yOffset*1, native.systemFont, 16 )
itemText:setTextColor(txt.red, txt.green, txt.blue)

itemText = display.newText( system.getInfo( "model" ),
	xText, y+yOffset*2, native.systemFont, 16 )
itemText:setTextColor(txt.red, txt.green, txt.blue)

itemText = display.newText( system.getInfo( "environment" ),
	xText, y+yOffset*3, native.systemFont, 16 )
itemText:setTextColor(txt.red, txt.green, txt.blue)

itemText = display.newText( system.getInfo( "platformName" ),
	xText, y+yOffset*4, native.systemFont, 16 )
itemText:setTextColor(txt.red, txt.green, txt.blue)

itemText = display.newText( system.getInfo( "platformVersion" ),
	xText, y+yOffset*5, native.systemFont, 16 )
itemText:setTextColor(txt.red, txt.green, txt.blue)

itemText = display.newText( system.getInfo( "version" ),
	xText, y+yOffset*6, native.systemFont, 16 )
itemText:setTextColor(txt.red, txt.green, txt.blue)

itemText = display.newText( system.getInfo( "build" ),
	xText, y+yOffset*7, native.systemFont, 16 )
itemText:setTextColor(txt.red, txt.green, txt.blue)

itemText = display.newText( system.getInfo( "deviceID" ),
	30, y+yOffset*8+25, native.systemFont, 14 )
	itemText.x = display.contentWidth/2				-- center long string (40 chars)
itemText:setTextColor(txt.red, txt.green, txt.blue)

itemText = display.newText( system.getPreference( "ui", "language" ),
	xText, y+yOffset*10, native.systemFont, 16 )
itemText:setTextColor(txt.red, txt.green, txt.blue)

itemText = display.newText( system.getPreference( "locale", "country" ),
	xText, y+yOffset*11, native.systemFont, 16 )
itemText:setTextColor(txt.red, txt.green, txt.blue)

itemText = display.newText( system.getPreference( "locale", "identifier" ),
	xText, y+yOffset*12, native.systemFont, 16 )
itemText:setTextColor(txt.red, txt.green, txt.blue)

itemText = display.newText( system.getPreference( "locale", "language" ),
	xText, y+yOffset*13, native.systemFont, 16 )
itemText:setTextColor(txt.red, txt.green, txt.blue)




