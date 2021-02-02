-- The template opponent phase

local opponentPhaseTEMPLATE = {}
opponentPhaseTEMPLATE.__index = opponentPhaseTEMPLATE


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseTEMPLATE.new()
	local self = classes.opponentBase.new()
	setmetatable(self, opponentPhaseTEMPLATE)
	return self
end

function opponentPhaseTEMPLATE:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	-- ... rest of method here ...
end

function opponentPhaseTEMPLATE:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseTEMPLATE:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

-- Uncomment this
--classes.opponentPhaseTEMPLATE = opponentPhaseTEMPLATE
