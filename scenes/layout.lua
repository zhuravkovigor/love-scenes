-- Root layout for all scenes
-- This layout will be applied to all scenes unless overridden

local layout = {}

function layout:init()
	print("Root layout initialized")
	self.headerHeight = 60
	self.footerHeight = 40
end

function layout:update(dt)
	-- Layout update logic
end

function layout:draw(drawScene)
	-- Draw header
	love.graphics.setColor(0.2, 0.2, 0.2)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), self.headerHeight)

	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(love.graphics.getFont())
	love.graphics.print("Love Scenes Demo", 10, 20)

	-- Draw scene content in the middle
	love.graphics.push()
	love.graphics.translate(0, self.headerHeight)
	if drawScene then
		drawScene()
	end
	love.graphics.pop()

	-- Draw footer
	local footerY = love.graphics.getHeight() - self.footerHeight
	love.graphics.setColor(0.2, 0.2, 0.2)
	love.graphics.rectangle("fill", 0, footerY, love.graphics.getWidth(), self.footerHeight)

	love.graphics.setColor(0.7, 0.7, 0.7)
	love.graphics.print("Press ESC to go back", 10, footerY + 10)
end

function layout:keypressed(key)
	if key == "escape" then
		require("init").navigate("/")
	end
end

return layout
