-- Game scene
-- Accessible at /game

local scene = {}

function scene:init(params)
	print("Game scene initialized")
	self.playerX = love.graphics.getWidth() / 2
	self.playerY = love.graphics.getHeight() / 2
	self.playerSpeed = 200
end

function scene:update(dt)
	-- Simple player movement
	if love.keyboard.isDown("left", "a") then
		self.playerX = self.playerX - self.playerSpeed * dt
	end
	if love.keyboard.isDown("right", "d") then
		self.playerX = self.playerX + self.playerSpeed * dt
	end
	if love.keyboard.isDown("up", "w") then
		self.playerY = self.playerY - self.playerSpeed * dt
	end
	if love.keyboard.isDown("down", "s") then
		self.playerY = self.playerY + self.playerSpeed * dt
	end

	-- Keep player on screen
	self.playerX = math.max(25, math.min(love.graphics.getWidth() - 25, self.playerX))
	self.playerY = math.max(85, math.min(love.graphics.getHeight() - 65, self.playerY))
end

function scene:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf("Game Scene", 0, 20, love.graphics.getWidth(), "center")
	love.graphics.printf("Use WASD or arrow keys to move", 0, 50, love.graphics.getWidth(), "center")

	-- Draw player
	love.graphics.setColor(0, 1, 0) -- Green player
	love.graphics.circle("fill", self.playerX, self.playerY, 20)
end

return scene
