-- Project: DynamicImageResolution
--
-- Date: September 12, 2010
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Ansca Mobile
--
-- Abstract:	Tests multiple resolution mode using display.newRectImage
--
-- Demonstrates: 
--		display.newRectImage (with image resolution table defined in config.lua)
--
-- File dependencies: config.lua
--
-- Target devices: Simulator and devices
--
-- Limitations: 
--
-- Update History: none
--
-- Comments:
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
---------------------------------------------------------------------------------------


-- The "newImageRect" function selects the best image for the resolution of the current device
-- and displays it at the specified size. 
-- In the example below, the specified image size is 200 x 200 in base content coordinates.
-- (The base content size is 320x480, defined in config.lua)

-- If no high-resolution alternates are found, the base image filename is used instead.
-- See the config.lua file for the "imageSuffix" naming table for alternate images.

local myImage = display.newImageRect( "hongkong.png", 200, 200 )
myImage.x = display.contentWidth / 2
myImage.y = display.contentHeight / 2


-- Create text message labels
local label1 = display.newText( "Dynamic Image Resolution", 20, 30, native.systemFontBold, 20 )
label1:setTextColor( 190, 190, 255 )
local label2 = display.newText( "View as different simulated devices", 20, 60, native.systemFont, 14 )
label2:setTextColor( 190, 190, 255 )
local label3 = display.newText( "(Best image is chosen automatically)", 20, 80, native.systemFont, 14 )
label3:setTextColor( 190, 190, 255 )
