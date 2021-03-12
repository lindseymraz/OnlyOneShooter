-- Shooter following "Only One"
-- by Kyle Reese and Terry Hearst


-- Load up all states
states = {}
require "states/menu"
require "states/game"
require "states/pause"
require "states/victory"
require "states/gameOver"

-- Load up all classes
classes = {}
require "classes/player"
require "classes/bullet"
require "classes/bulletFirework"
require "classes/bulletPortal"
require "classes/opponentSpawner"
require "classes/opponentBase"
require "classes/opponentPhaseNormal"
require "classes/opponentPhaseNoBehavior"
require "classes/opponentPhaseBouncing"
require "classes/opponentPhaseCharge"
require "classes/opponentPhaseChargeShot"
require "classes/opponentPhaseChase"
require "classes/opponentPhaseWeakspot"
require "classes/opponentPhaseFireworkShot"
require "classes/opponentPhaseSpin"
require "classes/opponentPhaseOrbit"
require "classes/opponentPhaseTeleport"
require "classes/opponentPhasePortals"
require "classes/opponentPhaseFakeout"
require "classes/gameOverTimer"
require "classes/portal"

-- Global variables
state = nil 		-- Currently loaded state
nextState = nil 	-- State to load when the frame is done

-- Debug variables
debug = false

-- Fonts
fonts = {}


--------------------
-- MAIN CALLBACKS --
--------------------

function love.load()
	-- Set default background color
	love.graphics.setBackgroundColor(0.1, 0.3, 0.5)

	-- Create some fonts
	fonts.small = love.graphics.newFont(14)
	fonts.medium = love.graphics.newFont(22)
	fonts.large = love.graphics.newFont(40)
	fonts.title = love.graphics.newFont(96)

	-- Load menu state
	nextState = states.menu.new()
end

function love.update(dt)
	-- Limit dt
	if dt > 1/15 then dt = 1/15 end

	if nextState then
		state = nextState
		nextState = nil
	end

	state:update(dt)
end

function love.draw()
	state:draw()
end


---------------------
-- OTHER CALLBACKS --
---------------------

function love.keypressed(key, scancode, isrepeat)
	if key == "f12" then
		debug = not debug
	else
		if state and state.keypressed then state:keypressed(key, scancode, isrepeat) end
	end
end


----------------------
-- HELPER FUNCTIONS --
----------------------

function toPolar(x, y)
	local mag = math.sqrt(x * x + y * y)
	local ang = math.atan2(y, x)

	return mag, ang
end

function toCartesian(mag, ang)
	local x = mag * math.cos(ang)
	local y = mag * math.sin(ang)

	return x, y
end

function normalizeAngle(ang)
	while ang > math.pi do
		ang = ang - 2 * math.pi
	end
	while ang <= -math.pi do
		ang = ang + 2 * math.pi
	end
	return ang
end
