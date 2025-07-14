-- Dynamic profile scene
-- Accessible at /profile/[id] where [id] is a dynamic parameter

local scene = {}

function scene:init(params)
	print("Profile scene initialized with ID:", params.id)
	self.profileId = params.id or "unknown"
	self.userData = {
		name = "User " .. self.profileId,
		level = math.random(1, 100),
		score = math.random(1000, 50000),
	}
end

function scene:update(dt)
	-- Profile scene update logic
end

function scene:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf("Profile Scene", 0, 20, love.graphics.getWidth(), "center")

	local y = 80
	love.graphics.printf("Profile ID: " .. self.profileId, 0, y, love.graphics.getWidth(), "center")
	y = y + 40
	love.graphics.printf("Name: " .. self.userData.name, 0, y, love.graphics.getWidth(), "center")
	y = y + 30
	love.graphics.printf("Level: " .. self.userData.level, 0, y, love.graphics.getWidth(), "center")
	y = y + 30
	love.graphics.printf("Score: " .. self.userData.score, 0, y, love.graphics.getWidth(), "center")

	y = y + 60
	love.graphics.printf("This is a dynamic route example!", 0, y, love.graphics.getWidth(), "center")
	love.graphics.printf("Try /profile/456 or /profile/abc", 0, y + 30, love.graphics.getWidth(), "center")
end

return scene
