-- 
-- Abstract: EggBreaker sample project
-- A simplified "crush the castle" game demo, where objects have internal listeners for collision events
-- 
-- Version: 1.2 (revised for Alpha 3)
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.

-- Activate physics engine
local physics = require("physics")
physics.start()

display.setStatusBar( display.HiddenStatusBar )

-- Load some external Lua libraries (from project directory)
local movieclip = require( "movieclip" )
local ui = require( "ui" )

local ballInPlay = false

-- Create master display group (for global "camera" scrolling effect)
local game = display.newGroup();
game.x = 0

------------------------------------------------------------
-- Set up sound effects

local boingSound = audio.loadSound("boing_wav.wav")
local knockSound = audio.loadSound("knock_wav.wav")
local squishSound = audio.loadSound("squish_wav.wav")

------------------------------------------------------------
-- Sky and ground graphics

local sky = display.newImage( "sky.png", true )
game:insert( sky )
sky.x = 160; sky.y = 160

local sky2 = display.newImage( "sky.png", true )
game:insert( sky2 )
sky2.x = 1120; sky2.y = 160

local grass = display.newImage( "grass.png", true )
game:insert( grass )
grass.x = 160
grass.y = 440
physics.addBody( grass, "static", { friction=0.5, bounce=0.3 } )

local grass2 = display.newImage( "grass.png", true )
game:insert( grass2 )
grass2.x = 1120
grass2.y = 440
physics.addBody( grass2, "static", { friction=0.5, bounce=0.3 } )

local arrow = display.newImage( "arrow.png" )
game:insert( arrow ); arrow.x = 50; arrow.y = 120

local instructionLabel = display.newText( "tap screen to launch", 70, 10 + display.screenOriginY, native.systemFont, 18 )
instructionLabel:setTextColor( 235, 235, 255, 255 )
game:insert( instructionLabel )


------------------------------------------------------------
-- Add trampoline

trampoline = display.newImage( "trampoline.png" )
game:insert( trampoline )
physics.addBody( trampoline, "static", { friction=0.5, bounce=1.2 } )
trampoline.x = 50 
trampoline.y = 355
trampoline.rotation = 45



------------------------------------------------------------------------
-- Construct castle (body type defaults to "dynamic" when not specified)

castleBody = { density=4.0, friction=1, bounce=0.2 }
castleBodyHeavy = { density=12.0, friction=0.3, bounce=0.4 }

wall1 = display.newImage( "wall.png" )
game:insert( wall1 ); wall1.x = 632; wall1.y = 350
physics.addBody( wall1, castleBody )

wall2 = display.newImage( "wall.png" )
game:insert( wall2 ); wall2.x = 744; wall2.y = 350
physics.addBody( wall2, castleBody )

wall3 = display.newImage( "wall.png" )
game:insert( wall3 ); wall3.x = 856; wall3.y = 350
physics.addBody( wall3, castleBody )

roof = display.newImage( "roof.png" )
game:insert( roof ); roof.x = 684; roof.y = 292
physics.addBody( roof, castleBody )

roof2 = display.newImage( "roof.png" )
game:insert( roof2 ); roof2.x = 804; roof2.y = 292
physics.addBody( roof2, castleBody )

beam = display.newImage( "beam.png" )
game:insert( beam ); beam.x = 694; beam.y = 250
physics.addBody( beam, castleBodyHeavy )

beam2 = display.newImage( "beam.png" )
game:insert( beam2 ); beam2.x = 794; beam2.y = 250
physics.addBody( beam2, castleBodyHeavy )

roof3 = display.newImage( "roof.png" )
game:insert( roof3 ); roof3.x = 744; roof3.y = 210
physics.addBody( roof3, castleBody )

beam3 = display.newImage( "beam.png" )
game:insert( beam3 ); beam3.x = 744; beam3.y = 168
physics.addBody( beam3, castleBodyHeavy )


------------------------------------------------------------
-- Construct eggs

eggBody = { density=1.0, friction=0.1, bounce=0.5, radius=25 }

-- Uses "movieclip" library for simple 2-frame animation; could also use sprite sheets for more complex animations
egg1 = movieclip.newAnim{ "egg.png", "egg_cracked.png" }
game:insert( egg1 ); egg1.x = 684; egg1.y = 374; egg1.id = "egg1"
physics.addBody( egg1, eggBody )

egg2 = movieclip.newAnim{ "egg.png", "egg_cracked.png" }
game:insert( egg2 ); egg2.x = 802; egg2.y = 374; egg2.id = "egg2"
physics.addBody( egg2, eggBody )

egg3 = movieclip.newAnim{ "egg.png", "egg_cracked.png" }
game:insert( egg3 ); egg3.x = 744; egg3.y = 258; egg3.id = "egg3"
physics.addBody( egg3, eggBody )


------------------------------------------------------------
-- Simple score display

local scoreDisplay = ui.newLabel{
	bounds = { display.contentWidth - 120, 10 + display.screenOriginY, 100, 24 }, -- align label with right side of current screen
	text = "0",
	font = "Trebuchet-BoldItalic",
	textColor = { 255, 225, 102, 255 },
	size = 32,
	align = "right"
}

score = 0

scoreDisplay:setText( score )
scoreDisplay:setText( system.getInfo("platformName")
 )


------------------------------------------------------------
-- Launch boulder

local boulder = display.newImage( "boulder.png" )
game:insert( boulder )

-- initial body type is "kinematic" so it doesn't fall under gravity
physics.addBody( boulder, { density=15.0, friction=0.5, bounce=0.2, radius=36 } )

local function resetBoulder()
	boulder.bodyType = "kinematic"
	boulder.x = 30
	boulder.y = -140
	boulder:setLinearVelocity( 0, 0 ) -- stop boulder moving
	boulder.angularVelocity = 0 -- stop boulder rotating
end

resetBoulder()

-- Camera follows bolder automatically
local function moveCamera()
	if (boulder.x > 80 and boulder.x < 1100) then
		game.x = -boulder.x + 80
	end
end


Runtime:addEventListener( "enterFrame", moveCamera )


------------------------------------------------------------
-- Add collision listeners to eggs

function startListening()
	-- if egg1 has a postCollision property then we've already started listening
	-- so return immediately
	if egg1.postCollision then
		return
	end

	local function onEggCollision ( self, event )

		-- uses "postSolve" event to get collision force
		
		print( "force: " .. event.force )
		
		-- Crack this egg if collision force is high enough
		if ( event.force > 6.0 ) then
			self:stopAtFrame(2)
			
			audio.play( squishSound )				
			score = score + 150
			scoreDisplay:setText( score )

			-- After this egg cracks, it can ignore further collisions
			self:removeEventListener( "postCollision", self )
		end
	end
	
	-- Set table listeners in each egg to check for collisions
	egg1.postCollision = onEggCollision
	egg1:addEventListener( "postCollision", egg1 )
	
	egg2.postCollision = onEggCollision
	egg2:addEventListener( "postCollision", egg2 )
	
	egg3.postCollision = onEggCollision
	egg3:addEventListener( "postCollision", egg3 )
	
end


------------------------------------------------------------
-- Add collision listener to trampoline

local function onBounce ( self, event )
	audio.play( boingSound )
end

trampoline.collision = onBounce
trampoline:addEventListener( "collision", trampoline )


------------------------------------------------------------
-- Add collision listener to trampoline

local function dropBoulder ( event )
	if ( not ballInPlay ) and ( event.phase == "began" ) then
		ballInPlay = true
		audio.play( knockSound )
		boulder.x = event.x - game.x
		boulder.y = event.y
		-- change body type to dynamic, so gravity affects it
		boulder.bodyType = "dynamic"

		startListening()
	end
end

local function newRound( event )
	resetBoulder()
	game.x = 0
	ballInPlay = false
	return true
end

local resetButton = ui.newButton{
	default = "buttonRed.png",
	over = "buttonRedOver.png",
	x = 160,
	y = 450,
	onPress = newRound,
	text = "New Boulder",
	emboss = true
}

--------------------------------------------------------------
-- On first startup, wait a few seconds for the new objects to "settle" to avoid false collisions at the beginning
timer.performWithDelay( 3000, startListening )

-- Finally, add a touch listener to the sky, for creating new boulders
sky:addEventListener( "touch", dropBoulder )
