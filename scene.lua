--- Scene module for love-scenes
-- Handles individual scene instances and their lifecycle.
--
-- Scenes are loaded from Lua files and can define various lifecycle methods
-- such as load, update, draw, onEnter, onLeave, and LÖVE 2D callbacks.
--
-- @module love-scenes.scene
-- @author Igor Zhuravkov

local Scene = {}
Scene.__index = Scene

--- Create a new scene instance
-- Loads a scene file and creates an instance with the provided parameters.
-- Automatically calls the scene's load method if it exists.
--
-- @tparam table sceneData Scene data from router containing path and route info
-- @tparam table params Route parameters to pass to the scene
-- @treturn table A new scene instance
function Scene.create(sceneData, params)
	local scenePath = sceneData.path

	-- Load the scene file
	local sceneModule = love.filesystem.load(scenePath)
	if not sceneModule then
		error("Could not load scene: " .. scenePath)
	end

	local sceneDefinition = sceneModule()

	-- Create scene instance
	local self = setmetatable({}, Scene)
	self.path = scenePath
	self.route = sceneData.route
	self.params = params or {}
	self.isDynamic = sceneData.isDynamic

	-- Copy scene methods and properties
	for k, v in pairs(sceneDefinition) do
		self[k] = v
	end

	-- Initialize scene data if load method exists
	if self.load then
		self:load(params)
	end

	return self
end

-- Default scene methods (can be overridden)
---Called when entering this scene
function Scene:onEnter()
	-- Called when entering this scene
end

---Called when leaving this scene
function Scene:onLeave()
	-- Called when leaving this scene
end

---Called every frame
---@param dt number Delta time in seconds
function Scene:update(dt)
	-- Called every frame
end

---Called every frame for rendering
function Scene:draw()
	-- Called every frame for rendering
end

-- Utility method to get a parameter
---@param name string Parameter name
---@param default any Default value if not found
---@return any value Parameter value or default
function Scene:getParam(name, default)
	return self.params[name] or default
end

-- Utility method to check if scene has a parameter
---@param name string Parameter name
---@return boolean hasParam Whether parameter exists
function Scene:hasParam(name)
	return self.params[name] ~= nil
end

return Scene
