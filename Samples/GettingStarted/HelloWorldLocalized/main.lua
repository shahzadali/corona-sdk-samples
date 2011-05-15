-- 
-- Abstract: Hello World sample app, with multiple language support based on user's settings
-- 
-- Version: 1.2
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.

local translations =
{
	["en"] = "Hello, world!",
	["fr"] = "Bonjour, le monde!",
	["pt"] = "Olá mundo!",
	["zh-Hant"] = "世界你好！",
	["zh-Hans"] = "世界你好！",
	["de"] = "Hallo, Welt!",
	["it"] = "Salve, mondo!",
	["ja"] = "世界よ、こんにちは！",
	["es"] = "¡Hola mundo!",
}

local language = "en"

local os = system.getInfo("platformName")
if os == "Android" then
	print( "system.getPreference is not implemented on Android yet" )
else
	language = system.getPreference( "ui", "language" )
end

-- Other localization-related system properties:
--  system.getPreference( "locale", "country" )
--  system.getPreference( "locale", "identifier" )
--  system.getPreference( "locale", "language" )

local message = translations[language]
if not message then
	-- default to English
	message = translations.en
end

-- Background image from NASA's Visible Earth gallery (http://visibleearth.nasa.gov/)
local background = display.newImage("globe_east.jpg")

-- Show text, using default bold font of device (works in iOS or Android)
local textObject = display.newText( message, 0, 0, native.systemFontBold, 24 )
textObject:setTextColor( 255,255,255 )

-- A trick to get text to be centered
local centeredGroup = display.newGroup()
centeredGroup.x = display.contentWidth * 0.5
centeredGroup.y = display.contentHeight * 0.5
centeredGroup:insert( textObject, true )

-- Insert rounded rect behind textObject
local r = 10
local roundedRect = display.newRoundedRect( 0, 0, textObject.contentWidth + 2*r, textObject.contentHeight + 2*r, r )
roundedRect:setFillColor( 55, 55, 55, 190 )
centeredGroup:insert( 1, roundedRect, true )