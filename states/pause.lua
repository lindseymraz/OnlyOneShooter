-- The pause state

local pause = {}
pause.__index = pause


--------------------
-- MAIN CALLBACKS --
--------------------

function pause.new(savedGame)
	local self = setmetatable({}, pause)

	self.gameState = savedGame

	return self
end

function pause:update(dt)
	-- TODO: write this function
end

function pause:draw()
	self.gameState:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(fonts.medium)
	love.graphics.printf("Press 'esc' to return to the game --- Press 'enter' to exit to the menu", 0, 200, ARENA_WIDTH, "center")
end


---------------------
-- OTHER CALLBACKS --
---------------------

function pause:keypressed(key, scancode, isrepeat)
	-- Return to the game
	if key == "escape" then
		nextState = self.gameState
	elseif key == "return" then
		nextState = states.menu.new()
	end
end

states.pause = pause
