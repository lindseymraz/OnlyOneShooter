-- The template opponent phase

local opponentPhaseWeakspot = {}
opponentPhaseWeakspot.__index = opponentPhaseWeakspot


opponentPhaseWeakspot.DEFAULT_BULLET_COOLDOWN = 1


--------------------
-- MAIN CALLBACKS --
--------------------

function opponentPhaseWeakspot.new()
	local self = classes.opponentBase.new(opponentPhaseWeakspot)

	self.CHASE_SPEED = 200
	self.xDamage = self.x
	self.yDamage = self.y - 0.5 * self.radius

	return self
end

function opponentPhaseWeakspot:update(dt)
	if self.stunned then return end													--I moved this to the top so bullet collision can interact with the player angle

	if not state.player then return end

	self.angle = math.atan2(state.player.y - self.y, state.player.x - self.x)
	self.x = self.x + math.cos(self.angle) * self.CHASE_SPEED * dt
	self.y = self.y + math.sin(self.angle) * self.CHASE_SPEED * dt
	self.xDamage = self.x - math.cos(self.angle) * 0.5 * self.radius
	self.yDamage = self.y - math.sin(self.angle) * 0.5 * self.radius

	if self.stunned then
		self.stunTime = self.stunTime - dt
		if self.stunTime <= 0 then
			self.stunned = false
			self.stunTime = 0
			self.iframeTime = self.IFRAME_LENGTH
		end
	else
		-- Collide with bullets
		if self.iframeTime > 0 then
			self.iframeTime = self.iframeTime - dt
			if self.iframeTime < 0 then self.iframeTime = 0 end
		else
			for i, bullet in ipairs(state.bullets) do
				if bullet.friendly then
					if math.sqrt((self.x - bullet.x) ^ 2 + (self.y - bullet.y) ^ 2) <= (self.radius +
							bullet.radius) then
						if math.sqrt((self.xDamage - bullet.x) ^ 2 + (self.yDamage - bullet.y) ^ 2) <=
								(self.radius / 2 + bullet.radius) then
							self.life = self.life - 1
							if self.life == 0 then self.markForDeletion = true end
							self.stunned = true
							self.stunTime = self.STUN_LENGTH
						end
						bullet.markForDeletion = true
						break
					end
				end
			end
		end

		-- Shoot bullets
		if self.useDefaultShooting then
			self.currentCooldown = self.currentCooldown - dt
			if self.currentCooldown <= 0 then
				table.insert(state.bullets, classes.bullet.new(self.x, self.y, self.angle, false, self.bulletSpeed))
				self.currentCooldown = self.currentCooldown + self.bulletCooldownTime
			end
		end
	end
end

function opponentPhaseWeakspot:draw()
	-- Optional - draw default opponent
	classes.opponentBase.draw(self)

	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("fill", self.xDamage, self.yDamage, self.radius / 2)

	love.graphics.setColor(0, 0, 1)
	love.graphics.circle("fill", self.xDamage, self.yDamage, self.radius / 4)

	love.graphics.setColor(1, 1, 1)
	love.graphics.circle("fill", self.xDamage, self.yDamage, self.radius / 8)
end

function opponentPhaseWeakspot:onDestroy()
	-- Call default superclass method
	classes.opponentBase.onDestroy(self)
end

classes.opponentPhaseWeakspot = opponentPhaseWeakspot
