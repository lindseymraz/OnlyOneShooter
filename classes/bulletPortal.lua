-- The portal shots

local bulletPortal = {}
bulletPortal.__index = bulletPortal


--------------------
-- MAIN CALLBACKS --
--------------------

function bulletPortal.new(x, y, angle, friendly, speed, color)
	local self = classes.bullet.new(x, y, angle, friendly, speed)
	setmetatable(self, bulletPortal)

	self.color = color
	self.PORTAL_PLACEMENT_OFFSET = 100

	return self
end

function bulletPortal:update(dt)
	-- Call superclass method
	classes.bullet.update(self, dt)

	if self.x < -self.radius + self.PORTAL_PLACEMENT_OFFSET
			or self.x > ARENA_WIDTH + self.radius - self.PORTAL_PLACEMENT_OFFSET
			or self.y < -self.radius + self.PORTAL_PLACEMENT_OFFSET
			or self.y > ARENA_HEIGHT + self.radius - self.PORTAL_PLACEMENT_OFFSET then
		self.markForDeletion = true
	end
end

function bulletPortal:draw()
	if self.color == "blue" then
		love.graphics.setColor(0, 0.396, 1)
	elseif self.color == "orange" then
		love.graphics.setColor(1, 0.365, 0)
	end
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

function bulletPortal:onDestroy()
	-- Call default superclass method
	if classes.bullet.onDestroy then
		classes.bullet.onDestroy(self)
	end

	if self.noSpawnPortal then return end

	if self.x < -self.radius + self.PORTAL_PLACEMENT_OFFSET
			or self.x > ARENA_WIDTH + self.radius - self.PORTAL_PLACEMENT_OFFSET
			or self.y < -self.radius + self.PORTAL_PLACEMENT_OFFSET
			or self.y > ARENA_HEIGHT + self.radius - self.PORTAL_PLACEMENT_OFFSET then
		local newPortal = classes.portal.new(self.x, self.y, self.color)
		if self.color == "blue" then
			state.bluePortal = newPortal
		else --self.color == "orange" then
			state.orangePortal = newPortal
		end
	end
end

classes.bulletPortal = bulletPortal
