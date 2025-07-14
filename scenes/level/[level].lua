-- Dynamic level scene
-- Accessible at /level/[level] where [level] is any level identifier

local scene = {}

---Initialize level scene with level parameter
---@param params table Route parameters containing level info
function scene:init(params)
	print("Level scene initialized with level:", params.level)
	self.levelId = params.level or "unknown"

	-- Different level configurations
	self.levelConfig = self:_getLevelConfig(self.levelId)
	self.enemies = {}
	self.player = { x = 100, y = 300, speed = 200 }

	-- Generate level content based on level ID
	self:_generateLevel()
end

---Get configuration for specific level
---@param levelId string Level identifier
---@return table config Level configuration
function scene:_getLevelConfig(levelId)
	local configs = {
		["1-1"] = { name = "Green Hill", difficulty = 1, enemies = 3 },
		["1-2"] = { name = "Underground", difficulty = 2, enemies = 5 },
		["boss-1"] = { name = "Fire Boss", difficulty = 5, enemies = 1 },
		["forest"] = { name = "Mystic Forest", difficulty = 3, enemies = 4 },
		["desert"] = { name = "Sandy Desert", difficulty = 4, enemies = 6 },
	}

	return configs[levelId] or { name = "Unknown Level", difficulty = 1, enemies = 2 }
end

---Generate level content based on configuration
function scene:_generateLevel()
	-- Create enemies based on level config
	for i = 1, self.levelConfig.enemies do
		table.insert(self.enemies, {
			x = math.random(200, 600),
			y = math.random(200, 400),
			type = "basic",
		})
	end
end

---Update level logic
---@param dt number Delta time in seconds
function scene:update(dt)
	-- Player movement
	if love.keyboard.isDown("left", "a") then
		self.player.x = self.player.x - self.player.speed * dt
	end
	if love.keyboard.isDown("right", "d") then
		self.player.x = self.player.x + self.player.speed * dt
	end
	if love.keyboard.isDown("up", "w") then
		self.player.y = self.player.y - self.player.speed * dt
	end
	if love.keyboard.isDown("down", "s") then
		self.player.y = self.player.y + self.player.speed * dt
	end

	-- Keep player on screen
	self.player.x = math.max(25, math.min(love.graphics.getWidth() - 25, self.player.x))
	self.player.y = math.max(85, math.min(love.graphics.getHeight() - 65, self.player.y))
end

---Draw the level
function scene:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf("Level: " .. self.levelId, 0, 20, love.graphics.getWidth(), "center")
	love.graphics.printf(self.levelConfig.name, 0, 45, love.graphics.getWidth(), "center")
	love.graphics.printf("Difficulty: " .. self.levelConfig.difficulty, 0, 70, love.graphics.getWidth(), "center")

	-- Draw player
	love.graphics.setColor(0, 0, 1) -- Blue player
	love.graphics.circle("fill", self.player.x, self.player.y, 15)

	-- Draw enemies
	love.graphics.setColor(1, 0, 0) -- Red enemies
	for _, enemy in ipairs(self.enemies) do
		love.graphics.circle("fill", enemy.x, enemy.y, 10)
	end

	-- Instructions
	love.graphics.setColor(0.7, 0.7, 0.7)
	love.graphics.print("Try these URLs:", 10, love.graphics.getHeight() - 120)
	love.graphics.print("/level/1-1, /level/forest, /level/boss-1", 10, love.graphics.getHeight() - 100)
	love.graphics.print("Use WASD to move", 10, love.graphics.getHeight() - 80)
end

return scene
