-- Settings scene
-- Accessible at /settings

local scene = {}

function scene:init(params)
	print("Settings scene initialized")
	self.settings = {
		volume = 0.7,
		fullscreen = false,
		difficulty = "Normal",
	}
	self.selectedSetting = 1
	self.settingNames = { "Volume", "Fullscreen", "Difficulty" }
end

function scene:update(dt)
	-- Settings scene update logic
end

function scene:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf("Settings", 0, 20, love.graphics.getWidth(), "center")

	local y = 100
	for i, setting in ipairs(self.settingNames) do
		if i == self.selectedSetting then
			love.graphics.setColor(1, 1, 0) -- Yellow for selected
		else
			love.graphics.setColor(1, 1, 1) -- White for normal
		end

		local value = ""
		if setting == "Volume" then
			value = string.format("%.0f%%", self.settings.volume * 100)
		elseif setting == "Fullscreen" then
			value = self.settings.fullscreen and "On" or "Off"
		elseif setting == "Difficulty" then
			value = self.settings.difficulty
		end

		local text = setting .. ": " .. value
		love.graphics.printf(text, 0, y, love.graphics.getWidth(), "center")
		y = y + 40
	end

	love.graphics.setColor(0.7, 0.7, 0.7)
	love.graphics.printf(
		"Use Up/Down to navigate, Left/Right to change values",
		0,
		y + 40,
		love.graphics.getWidth(),
		"center"
	)
end

function scene:keypressed(key)
	if key == "up" then
		self.selectedSetting = math.max(1, self.selectedSetting - 1)
	elseif key == "down" then
		self.selectedSetting = math.min(#self.settingNames, self.selectedSetting + 1)
	elseif key == "left" then
		self:changeSetting(-1)
	elseif key == "right" then
		self:changeSetting(1)
	end
end

function scene:changeSetting(direction)
	local setting = self.settingNames[self.selectedSetting]

	if setting == "Volume" then
		self.settings.volume = math.max(0, math.min(1, self.settings.volume + direction * 0.1))
	elseif setting == "Fullscreen" then
		self.settings.fullscreen = not self.settings.fullscreen
	elseif setting == "Difficulty" then
		local difficulties = { "Easy", "Normal", "Hard" }
		local current = 2 -- Normal
		for i, diff in ipairs(difficulties) do
			if diff == self.settings.difficulty then
				current = i
				break
			end
		end
		current = current + direction
		current = math.max(1, math.min(#difficulties, current))
		self.settings.difficulty = difficulties[current]
	end
end

return scene
