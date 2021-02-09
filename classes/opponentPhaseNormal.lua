-- The "normal" opponent phase where it acts like a space invader

local opponentPhaseNormal = {}
opponentPhaseNormal.__index = opponentPhaseNormal


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseNormal.new()
	local self = classes.opponentBase.new()
	setmetatable(self, opponentPhaseNormal)

	-- Constants
	self.ADVANCE_DISTANCE = 125
	self.BULLET_COOLDOWN_LENGTH = 1

	-- Movement variables
	self.advance = false
	self.xspeed = 200
	self.yspeed = 200

	self.shotCooldown = self.BULLET_COOLDOWN_LENGTH
	self.advanceDist = 0

	return self
end

function opponentPhaseNormal:update(dt)
	-- Call superclass method
	classes.opponentBase.update(self, dt)

	if self.stunned then return end

	-- Update opponent values
	self.shotCooldown = self.shotCooldown - dt
	self.advanceDist = self.advanceDist + self.yspeed * dt

	-- Update opponent movement
	if not self.advance then
		self.x = self.x + self.xspeed * dt
	else
		self.y = self.y + self.yspeed * dt
	end

	if self.x < self.radius then
		self.x = self.radius
		self.xspeed = math.abs(self.xspeed)
		if self.y < ARENA_HEIGHT - self.ADVANCE_DISTANCE - self.radius - 1 then
			self.advance = true
		end
	elseif self.x >= ARENA_WIDTH - self.radius then
		self.x = ARENA_WIDTH - self.radius - 1
		self.xspeed = -math.abs(self.xspeed)
		if self.y < ARENA_HEIGHT - self.ADVANCE_DISTANCE - self.radius - 1 then
			self.advance = true
		end
	end

	if self.advanceDist >= self.ADVANCE_DISTANCE then
		self.advance = false
		self.advanceDist = 0
	end

	-- Shoot bullets
	if self.shotCooldown <= 0 then
		table.insert(state.bullets, classes.bullet.new(self.x, self.y, math.pi / 2, false))
		self.shotCooldown = self.BULLET_COOLDOWN_LENGTH
	end
end

function opponentPhaseNormal:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)
end

function opponentPhaseNormal:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseNormal = opponentPhaseNormal
