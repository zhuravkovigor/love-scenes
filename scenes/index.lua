-- Main menu scene
-- This is the root scene at /

local scene = {}

---Initialize the main menu
---@param params table Route parameters
function scene:init(params)
	print("Main menu initialized")
	self.title = "Love Scenes Demo"
	self.options = {
		{
			text = "Start Game",
			action = function()
				require("init").navigate("/game")
			end,
		},
		{
			text = "Level 1-1",
			action = function()
				require("init").navigate("/level/1-1")
			end,
		},
		{
			text = "Forest Level",
			action = function()
				require("init").navigate("/level/forest")
			end,
		},
		{
			text = "Boss Level",
			action = function()
				require("init").navigate("/level/boss-1")
			end,
		},
		{
			text = "Settings",
			action = function()
				require("init").navigate("/settings")
			end,
		},
		{
			text = "Profile",
			action = function()
				require("init").navigate("/profile/123")
			end,
		},
		{
			text = "Quit",
			action = function()
				love.event.quit()
			end,
		},
	}
	self.selectedOption = 1
end

---Update menu logic
---@param dt number Delta time in seconds
function scene:update(dt)
	-- Menu logic here
end

---Draw the main menu
function scene:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf(self.title, 0, 100, love.graphics.getWidth(), "center")

	for i, option in ipairs(self.options) do
		local y = 200 + (i - 1) * 50
		if i == self.selectedOption then
			love.graphics.setColor(1, 1, 0) -- Yellow for selected
		else
			love.graphics.setColor(1, 1, 1) -- White for normal
		end
		love.graphics.printf(option.text, 0, y, love.graphics.getWidth(), "center")
	end
end

---Handle keyboard input
---@param key string Pressed key
function scene:keypressed(key)
	if key == "up" then
		self.selectedOption = math.max(1, self.selectedOption - 1)
	elseif key == "down" then
		self.selectedOption = math.min(#self.options, self.selectedOption + 1)
	elseif key == "return" or key == "space" then
		self.options[self.selectedOption].action()
	end
end

return scene
