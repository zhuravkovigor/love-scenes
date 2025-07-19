--- Love Scenes - File-system based scene routing for LÖVE 2D games inspired by Next.js
--
-- Love Scenes provides a Next.js-style routing system for LÖVE 2D games using the filesystem.
-- Create scenes by simply adding Lua files to your scenes directory, with support for
-- dynamic routes, layouts, and automatic navigation.
--
-- @module love-scenes
-- @author Igor Zhuravkov
-- @license MIT
-- @release dev-1

---@type LoveScenes
local LoveScenes = {}

local Router = require("libs.love-scenes.router")
local Scene = require("libs.love-scenes.scene")
local Layout = require("libs.love-scenes.layout")

-- Default configuration
---@type LoveScenesConfig
local defaultConfig = {
	scenesPath = "scenes",
	autoLoad = true,
	enableLayouts = true,
	debugMode = false,
}

---@type LoveScenesConfig
local config = defaultConfig
---@type Router
local router = nil
---@type Scene
local currentScene = nil
---@type Layout
local currentLayout = nil

--- Initialize the love-scenes library
-- Sets up the routing system and loads scenes from the specified directory.
-- All configuration parameters are optional - the library works with sensible defaults.
--
-- @tparam ?LoveScenesConfig userConfig Configuration options (all optional)
-- @treturn LoveScenes The initialized LoveScenes instance
-- @usage
-- -- Minimal setup
-- LoveScenes.init()
--
-- -- With custom configuration
-- LoveScenes.init({
--     scenesPath = "game-scenes",
--     debugMode = true
-- })
function LoveScenes.init(userConfig)
	-- Merge user config with defaults
	config = {
		scenesPath = defaultConfig.scenesPath,
		autoLoad = defaultConfig.autoLoad,
		enableLayouts = defaultConfig.enableLayouts,
		debugMode = defaultConfig.debugMode,
	}
	for k, v in pairs(defaultConfig) do
		config[k] = v
	end
	if userConfig then
		for k, v in pairs(userConfig) do
			config[k] = v
		end
	end

	-- Initialize router
	router = Router.new(config)

	if config.autoLoad then
		router:loadScenes()
	end

	if config.debugMode then
		print("[LoveScenes] Initialized with scenes path: " .. config.scenesPath)
		print("[LoveScenes] Found " .. router:getSceneCount() .. " scenes")
	end

	return LoveScenes
end

--- Navigate to a scene
-- Changes the current scene to the one specified by the path.
-- Supports both static routes ("/game") and dynamic routes ("/profile/123").
--
-- @tparam string path Route path (e.g., "/", "/game", "/profile/123")
-- @tparam ?table params Additional parameters to pass to the scene
-- @treturn boolean true if navigation was successful, false otherwise
-- @usage
-- LoveScenes.navigate('/')
-- LoveScenes.navigate('/profile/123')
-- LoveScenes.navigate('/user/456', {tab = 'settings'})
function LoveScenes.navigate(path, params)
	if not router then
		error("LoveScenes not initialized. Call LoveScenes.init() first.")
	end

	local scene, layoutPath, routeParams = router:resolve(path, params)

	if not scene then
		if config.debugMode then
			print("[LoveScenes] Scene not found for path: " .. path)
		end
		return false
	end

	-- Handle layout change
	local newLayout = nil
	if config.enableLayouts and layoutPath then
		newLayout = Layout.load(layoutPath)
	end

	-- Call lifecycle hooks
	if currentScene and currentScene.onLeave then
		currentScene:onLeave()
	end

	if currentLayout and currentLayout.onLeave then
		currentLayout:onLeave()
	end

	-- Switch to new scene and layout
	currentLayout = newLayout
	currentScene = Scene.create(scene, routeParams or {})

	if currentLayout and currentLayout.onEnter then
		currentLayout:onEnter(currentScene)
	end

	if currentScene.onEnter then
		currentScene:onEnter()
	end

	if config.debugMode then
		print("[LoveScenes] Navigated to: " .. path)
	end

	return true
end

--- Get the current active scene
-- @treturn ?Scene The current scene instance, or nil if no scene is active
function LoveScenes.getCurrentScene()
	return currentScene
end

--- Get the current active layout
-- @treturn ?Layout The current layout instance, or nil if no layout is active
function LoveScenes.getCurrentLayout()
	return currentLayout
end

--- Update the current scene and layout
-- Should be called from love.update(dt).
--
-- @tparam number dt Delta time in seconds since last frame
function LoveScenes.update(dt)
	if currentLayout and currentLayout.update then
		currentLayout:update(dt)
	end

	if currentScene and currentScene.update then
		currentScene:update(dt)
	end
end

--- Draw the current scene and layout
-- Should be called from love.draw().
--- Draw the current scene and layout
-- Should be called from love.draw().
-- Handles layout rendering with scene content injection.
function LoveScenes.draw()
	if currentLayout and currentLayout.draw then
		currentLayout:draw(function()
			if currentScene and currentScene.draw then
				currentScene:draw()
			end
		end)
	elseif currentScene and currentScene.draw then
		currentScene:draw()
	end
end

-- Forward other LÖVE callbacks to current scene
local loveCallbacks = {
	"keypressed",
	"keyreleased",
	"textinput",
	"mousepressed",
	"mousereleased",
	"mousemoved",
	"wheelmoved",
	"joystickpressed",
	"joystickreleased",
	"joystickaxis",
	"resize",
	"focus",
	"visible",
}

for _, callback in ipairs(loveCallbacks) do
	LoveScenes[callback] = function(...)
		if currentLayout and currentLayout[callback] then
			local result = currentLayout[callback](currentLayout, ...)
			if result ~= nil then
				return result
			end
		end

		if currentScene and currentScene[callback] then
			return currentScene[callback](currentScene, ...)
		end
	end
end

return LoveScenes
