-- Project: NativeDisplayObjects
--
-- Date: November 30, 2010
--
-- Version: 1.2
--
-- File name: main.lua
--
-- Code type: Sample code
--
-- Author: Ansca Mobile
--
-- Demonstrates:
--	Native Display Objects
--		native.newTextField
--		native.newTextBox
--		native.showAlert
--		native.setActivityIndicator
--		native.showWebPopup
--
--	Using UI library for buttons and labels
--	System orientation events
--	Display changes between portrait and landscape modes
--  Detect running in Simulator and modifying program operation
--
-- File dependencies: ui.lua
--
-- Target devices: Devices, Simulator (limited features)
--
-- Limitations: No native text display or text input on simulator
--
-- Update History:
--	v1.1	Android: added warning that ActivityIndicator not supported
--			Android: Submit button (webpoup) not supported
--
--  v1.2	Increased native.textField height when running on Android device
--			Removed texthandler parameter from native.textBox (not used)
--
-- Comments: 
--		The program detects it running in the Corona simulator and changes the
--		native.newTextField and native.newTextBox to display.newRect to simulate
--		the location and properties of the native text objects.
--
-- TO-DO
-- o Add WebPopUp object (using local HTML file)
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

local ui = require("ui");

display.setStatusBar( display.HiddenStatusBar )		-- hide status bar

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Determine the platform type
-- "iPhoneOS" or "Android" or "Mac OS X"
--
local isAndroid = "Android" == system.getInfo("platformName")

--------------------------------
-- Code Execution Start Here
--------------------------------

local isPortrait = true			-- assume we are in Portrait screen mode

local textMode = false			-- true when text keyboard is present
local kDimBtn = 0.6				-- Button dim value (when disabled)

-- forward references
local screenCenter
local clrKbButton
local txtFieldButton
local txtBoxButton
local webPopButton

local background = display.newImage("wood_bg.jpg")		-- Load background image


-----------------------------------------------------------
-- textMessage()
--
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

		
-------------------------------------------
-- *** Create Labels ***
-------------------------------------------

-- Title
--
local titleLabel = ui.newLabel{
	bounds = { 15, 5, 290, 55 },
	text = "Native Display Objects",
	font = native.systemFontBold,
	textColor = { 240, 240, 90, 255 },
	size = 24,
	align = "center"
}
titleLabel:setReferencePoint(display.TopCenterReferencePoint)

-- Orientation
--
-- Display current orientation using "system.orientation"
-- (default orientation is determined in build.settings file)
--
local orientationLabel = ui.newLabel{
	bounds = { 12, 40, 300, 40 },
	text = "Orientation: " .. system.orientation,		-- get current device orientation
	font = native.systemFontBold,
	textColor = { 255, 255, 255, 255 },
	size = 16,
	align = "center"
}
orientationLabel:setReferencePoint(display.TopCenterReferencePoint)

-- Keyboard Label
--
local keyboardLabel = ui.newLabel{
	bounds = { 12, 125, 300, 40 },
	text = "Click text field (above) to enter text",
	font = native.systemFontBold,
	textColor = { 255, 255, 255, 255 },
	size = 12,
	align = "center"
}
keyboardLabel.isVisible = false		-- hide our text
keyboardLabel:setReferencePoint(display.TopCenterReferencePoint)

-------------------------------------------
--  *** Button Press Routines ***
-------------------------------------------

-- Handle the textField keyboard input
--
local function fieldHandler( event )

	if ( "began" == event.phase ) then
		-- This is the "keyboard has appeared" event
		-- In some cases you may want to adjust the interface when the keyboard appears.

		-- Show Dismiss Keyboard button if in portrait mode
		if isPortrait then
			clrKbButton.isVisible = true
		end
		
		textMode = true
	
	elseif ( "ended" == event.phase ) then
		-- This event is called when the user stops editing a field: for example, when they touch a different field
	
	elseif ( "submitted" == event.phase ) then
		-- This event occurs when the user presses the "return" key (if available) on the onscreen keyboard
		
		-- Hide keyboard
		native.setKeyboardFocus( nil )
		textMode = false
		clrKbButton.isVisible = false		-- Hide the Dismiss KB button
	end

end


-- textField Button Pressed
--
-- Display a one line text box and accept keyboard input
--
local textFieldButtonPress = function( event )
	
	if textField then
		textField:removeSelf()
		textField = nil				-- set to nil so we recreate it next time
		clrKbButton.isVisible = false		-- hide Dismiss button
		txtBoxButton.alpha = 1.0			-- Restore the other text object button
		keyboardLabel.isVisible = false		-- hide our text
	else
		-- Only allow one text object at a time
		if textBox then return end	-- return if other object active
		
		-- Create Native Text Field
		if isSimulator then
			-- Simulator (simulate the textField area)
			textField = display.newRect( 15, 80, 280, 30 )
			textField:setFillColor( 255, 255, 255 )
			textMessage( "Native TextField not supported in Simulator", "Middle", 1, 16)

			-- Show Dismiss Keyboard button if in portrait mode		
			if isPortrait then
				clrKbButton.isVisible = true
			end
		else
				local tHeight = 30
				if isAndroid then tHeight = 40 end		-- adjust for Android
				textField = native.newTextField( 15, 80, 280, tHeight, fieldHandler )
		end		
		
		textField.isVisible = false
		textField:setReferencePoint(display.TopCenterReferencePoint)
		textField.x = screenCenter
		textField.isVisible = true
		
		txtBoxButton.alpha = kDimBtn		-- Dim the other text object button
		keyboardLabel.isVisible = true		-- display our text
	end

end

-- textBox Button Pressed
--
-- Display text box with preloaded text
--
local textBoxButtonPress = function( event )

	if textBox then
		textBox:removeSelf()
		textBox = nil				-- set to nil so we recreate it next time
		clrKbButton.isVisible = false		-- hide Dismiss button
		txtFieldButton.alpha = 1.0			-- Restore the other text object button
	else
		-- Only allow one text object at a time
		if textField then return end	-- return if other object active
		
		-- Create Native Text Field
		if isSimulator then	
			-- Simulator (simulate the textBox area)
			textBox = display.newRect( 15, 70, 280, 70 )	-- x,y,w,h
			textBox:setFillColor( 255, 255, 255 )
			textMessage( "Native TextBox not supported in Simulator", "Middle", 1, 16)
		else
			textBox = native.newTextBox( 15, 70, 280, 70 )
		end	

		textBox.text = "This is information placed into the Text Box all on one line.\nThis is text forced to a new line."
		textBox:setReferencePoint(display.TopCenterReferencePoint)
		textBox.x = screenCenter
		textBox.size = 16
		txtFieldButton.alpha = kDimBtn	-- Dim the other text object button

	end

end

-- Dismiss Keyboard Button Pressed
--
local clrKbButtonPress = function( event )
	native.setKeyboardFocus( nil )		-- remove keyboard
	clrKbButton.isVisible = false		-- hide button
	textMode = false
end

-- Alert Button Pressed
--
local alertButtonPress = function( event )
	-- Create Native Alert Box
	local alertBox = native.showAlert( "My Alert Box",
			"Your message goes here ©Ansca",
			{"OK", "Cancel"} )
end


-- Activity Indicator Button Pressed
--
-- Display for 1 second
local activityButton = function( event )
	if isAndroid then
		textMessage( "Feature not supported on Android", "Middle", 1, 18)
		return
	end
	
	-- Create Activity Indicator
	native.setActivityIndicator( true )
	
	timer.performWithDelay( 1000, 
		function() native.setActivityIndicator( false ) end 
	)
end

-- WebPopUp Listener
--
local function webListener( event )
	local shouldLoad = true

	local url = event.url
	if 1 == string.find( url, "corona:close" ) then
		-- Close the web popup
		shouldLoad = false
		isWebPopup = false			-- show Web object is gone
	end
	
	return shouldLoad
end

-- Display WebPopUp object
--
-- Used for WebPopup button and on orientation change
--
local dispWebPopUp = function()
	local options = { hasBackground=true, baseUrl=system.ResourceDirectory,
		urlRequest=webListener }
		
	local x = (display.contentWidth - 320) /2
		
	if isPortrait then
		y = 80			-- Portrait
	else
		y = 75			-- Landscape
	end
	
	-- x, y, w, h, url, options
	native.showWebPopup(x, y, 320, 180, "localpage.html", options )
	isWebPopup = true
end

-- WebPopUp Button Pressed
--
-- Display local HTML page
--
local webPopButtonButtonPress = function( event )
 
 	if isSimulator then
		textMessage( "WebPopup not supported in Simulator", "Middle", 1, 18)
	else
		if isWebPopup then
			native.cancelWebPopup()
			isWebPopup = false
		else			
			dispWebPopUp()
		end
	end

end

-------------------------------------------
-- *** Create Buttons ***
-------------------------------------------

-- textField Button
--
txtFieldButton = ui.newButton{
	default = "btnBlueMedium.png",
	over = "btnBlueMediumOver.png",
	onPress = textFieldButtonPress,	
	text = "textField",
	size = 16,
	emboss = true
}
txtFieldButton:setReferencePoint(display.TopCenterReferencePoint)

-- textBox Button
--
txtBoxButton = ui.newButton{
	default = "btnBlueMedium.png",
	over = "btnBlueMediumOver.png",
	onPress = textBoxButtonPress,
	text = "textBox",
	size = 16,
	emboss = true
}
txtBoxButton:setReferencePoint(display.TopCenterReferencePoint)

-- Clear Keyboard Button
-- Invisible until used in Portrait text mode
--
clrKbButton = ui.newButton{
	default = "btnBlueMedium.png",
	over = "btnBlueMediumOver.png",
	onPress = clrKbButtonPress,
	text = "Dismiss KB",
	size = 16,
	emboss = true
}
clrKbButton.isVisible = false		-- we will use it later
txtBoxButton:setReferencePoint(display.TopCenterReferencePoint)

-- Alert Button
--
local alertButton = ui.newButton{
	default = "btnBlueMedium.png",
	over = "btnBlueMediumOver.png",
	onRelease = alertButtonPress,			-- used onRelease to avoid system interaction
	text = "Alert",
	size = 16,
	emboss = true
}
alertButton:setReferencePoint(display.TopCenterReferencePoint)

-- Activity Indicator Button
--
local activityButton = ui.newButton{
	default = "btnBlueMedium.png",
	over = "btnBlueMediumOver.png",
	onRelease = activityButton,			-- used onRelease to avoid system interaction
	text = "Activity",
	size = 16,
	emboss = true
}
activityButton:setReferencePoint(display.TopCenterReferencePoint)

-- WebPopup Button
--
webPopButton = ui.newButton{
	default = "btnBlueMedium.png",
	over = "btnBlueMediumOver.png",
	onPress = webPopButtonButtonPress,
	text = "WebPopup",
	size = 16,
	emboss = true
}
webPopButton:setReferencePoint(display.TopCenterReferencePoint)


-----------------------------------------------
-- *** Locate the buttons on the screen ***
-----------------------------------------------

-- Adjust objects for Portrait or Lanscape mode
--
-- Enter: mode = orientation mode
--
local function changeOrientation( mode )

local Y_Btn_P = 310		-- First button Y position for Portrait
local Y_Btn_L = 155		-- First button Y position for Landscape
local BtnOffset = 55	-- offset between buttons
	
	clrKbButton.alpha = 0.0			-- hide it during the transition

	-- Ignore "faceUp" and "faceDown" modes
	if mode == "portrait" or mode == "portraitUpsideDown" then
		background:removeSelf()
		background = display.newImage("wood_bg.jpg")		-- Load portrait background image
		background.parent:insert(1, background )
	
		background.x = display.contentWidth * 0.5
		background.y = display.contentHeight * 0.5
		
		isPortrait = true
		screenCenter = display.contentWidth * 0.5
				
		txtFieldButton.x = screenCenter - 80;
		txtBoxButton.x = screenCenter +80;
		txtFieldButton.y = Y_Btn_P
		txtBoxButton.y = Y_Btn_P

		alertButton.x = screenCenter - 80;
		activityButton.x = screenCenter +80;
		alertButton.y = Y_Btn_P + BtnOffset*1
		activityButton.y = Y_Btn_P + BtnOffset*1

		webPopButton.x = screenCenter;
		webPopButton.y = Y_Btn_P + BtnOffset*2
		
		-- Adjust WebPopUp box if present
		--
		if isWebPopup then
			-- Since we can relocate the object, close and reopen
			native.cancelWebPopup()			-- close it first
			-- Delay some time before showing the Webpopup again
			timer.performWithDelay( 400, dispWebPopUp )
		end
		
		if textMode then
			clrKbButton.isVisible = true		-- make Dismiss KB button visible
		end
	elseif	mode == "landscapeLeft" or mode == "landscapeRight" then
	
			-- Remove old background image and insert new image at the bottom
			background:removeSelf()
			background = display.newImage("wood_bg_lc.jpg")		-- Load landscape background image
			background.parent:insert( 1, background )

			background.x = display.contentWidth * 0.5
			background.y = display.contentHeight * 0.5
			
			isPortrait = false
			screenCenter = display.contentWidth * 0.5

			txtFieldButton.x = screenCenter - 100;
			txtBoxButton.x = screenCenter +100;
			txtFieldButton.y = Y_Btn_L
			txtBoxButton.y = Y_Btn_L
	
			alertButton.x = screenCenter - 100;
			activityButton.x = screenCenter +100;
			alertButton.y = Y_Btn_L + BtnOffset*1
			activityButton.y = Y_Btn_L + BtnOffset*1
	
			webPopButton.x = screenCenter;
			webPopButton.y = Y_Btn_L + BtnOffset*2
			
			clrKbButton.isVisible = false		-- hide Dismiss button

			-- Adjust WebPopUp box if present
			--
			if isWebPopup then
				-- Since we can relocate the object, close and reopen
				native.cancelWebPopup()			-- close it first
				-- Delay some time before showing the Webpopup again
				timer.performWithDelay( 400, dispWebPopUp )

--[[
				local options = { hasBackground=true, baseUrl=system.ResourceDirectory,
					urlRequest=webListener }
					
				local x = (display.contentWidth - 320) /2
				-- Delay some time before showing the Webpopup again
				-- x, y, w, h, url, options
				timer.performWithDelay( 200,
					function() native.showWebPopup( x,
						80, 320, 180, "localpage.html", options )
					end )
--]]
			end
	end

	-- Adjustments that are common to all screen orientations
	if textField then
		textField.x = screenCenter
	end
	
	if textBox then
		textBox.x = screenCenter
	end

	clrKbButton.x = screenCenter
	clrKbButton.y = 180
	
	-- Auto center our text strings
	orientationLabel.x = screenCenter
	titleLabel.x = screenCenter
	keyboardLabel.x = screenCenter
	
	transition.to( clrKbButton, {time = 500, alpha = 1.0} )			-- restore the alpha channel
end

-- Set up the display after the app starts
changeOrientation( system.orientation )

-- Come here when an Orientation Change event occurs
--
-- Change the display to fix the new mode
-- Display the change on screen
--
local function onOrientationChange( event )

	changeOrientation( event.type )
	orientationLabel:setText("Orientation: " .. event.type )
end

-- Add listerner for Orientation changes
--
Runtime:addEventListener( "orientation", onOrientationChange )
