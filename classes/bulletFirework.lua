-- A bullet that fragments into pieces

local bulletFirework = {}
bulletFirework.__index = bulletFirework


--------------------
-- MAIN CALLBACKS --
--------------------

function bulletFirework.new(x, y, angle, friendly, speed)
	local self = classes.bullet.new(x, y, angle, friendly, speed)
	setmetatable(self, bulletFirework)

	self.radius = 12
	self.countdownTime = 1.5
	self.shake = false
	self.shakeTime = 1
	self.timeBetweenShakes = 0.1
	self.offsetX = 0
	self.offsetY = 0

	self.NUM_BULLETS = 6
	self.OUTGOING_BULLET_SPEED = 200
	self.SHAKE_OFFSET = 5

	return self
end

function bulletFirework:update(dt)
	-- Call superclass method
	classes.bullet.update(self, dt)

	self.countdownTime = self.countdownTime - dt
	if self.countdownTime <= 0 then
		self.shake = true
		self.shakeTime = self.shakeTime - dt
		self.xspeed = self.xspeed * self.shakeTime
		self.yspeed = self.yspeed * self.shakeTime
		self.timeBetweenShakes = self.timeBetweenShakes - dt
		if self.timeBetweenShakes <= 0 then
			local ang = 2 * math.pi * love.math.random()
			self.offsetX = self.SHAKE_OFFSET * math.cos(ang)
			self.offsetY = self.SHAKE_OFFSET * math.sin(ang)
			self.timeBetweenShakes = self.timeBetweenShakes + 0.1
		end
		if self.shakeTime <= 0 then
			for i = 1, self.NUM_BULLETS do
				local ang = 2 * math.pi * i / self.NUM_BULLETS
				table.insert(state.bullets, classes.bullet.new(self.x, self.y, ang, self.friendly, self.OUTGOING_BULLET_SPEED))
			end
			self.countdownTime = 1.5
			self.shake = false
			self.shakeTime = 0.5
			self.markForDeletion = true
		end
	end
end

function bulletFirework:draw()
	love.graphics.setColor(0.1, 0.7, 0.1)
	love.graphics.circle("fill", self.x + self.offsetX, self.y + self.offsetY, self.radius)
end

function bulletFirework:onDestroy()
	-- Call default superclass method
	if classes.bullet.onDestroy then
		classes.bullet.onDestroy(self)
	end
end

classes.bulletFirework = bulletFirework
