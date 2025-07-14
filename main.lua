-- Example main.lua showing how to use love-scenes
-- This is how users would integrate the library into their LÖVE 2D projects

local LoveScenes = require("init")

function love.load()
	-- Initialize love-scenes with custom configuration
	LoveScenes.init({
		scenesPath = "scenes", -- Default: "scenes"
		autoLoad = true, -- Default: true
		enableLayouts = true, -- Default: true
		debugMode = true, -- Default: false
	})

	-- Navigate to the initial scene
	LoveScenes.navigate("/")
end

function love.update(dt)
	-- Forward update to love-scenes
	LoveScenes.update(dt)
end

function love.draw()
	-- Forward draw to love-scenes
	LoveScenes.draw()
end

-- Forward all input events to love-scenes
function love.keypressed(key, scancode, isrepeat)
	LoveScenes.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
	LoveScenes.keyreleased(key)
end

function love.mousepressed(x, y, button, istouch, presses)
	LoveScenes.mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
	LoveScenes.mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
	LoveScenes.mousemoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
	LoveScenes.wheelmoved(x, y)
end

-- Other LÖVE callbacks can be forwarded similarly
function love.resize(w, h)
	LoveScenes.resize(w, h)
end

function love.focus(focused)
	LoveScenes.focus(focused)
end
