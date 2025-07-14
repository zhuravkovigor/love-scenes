--- Layout module for love-scenes
-- Handles layout instances that wrap scenes with common UI elements.
--
-- Layouts provide a way to share common interface elements (headers, footers, etc.)
-- across multiple scenes. They can be nested hierarchically based on the file structure.
--
-- @module love-scenes.layout
-- @author Igor Zhuravkov

local Layout = {}
Layout.__index = Layout

--- Load a layout file
-- Creates a layout instance from a Lua file. The layout file should return
-- a table with layout methods (draw, update, etc.).
--
-- @tparam string layoutPath Absolute path to the layout file
-- @treturn table A new layout instance
function Layout.load(layoutPath)
	local layoutModule = love.filesystem.load(layoutPath)
	if not layoutModule then
		error("Could not load layout: " .. layoutPath)
	end

	local layoutDefinition = layoutModule()

	-- Create layout instance
	local self = setmetatable({}, Layout)
	self.path = layoutPath

	-- Copy layout methods and properties
	for k, v in pairs(layoutDefinition) do
		self[k] = v
	end

	-- Initialize layout if init method exists
	if self.init then
		self:init()
	end

	return self
end

-- Default layout methods (can be overridden)
---Called when entering this layout with a scene
---@param scene table The scene using this layout
function Layout:onEnter(scene)
	-- Called when entering this layout with a scene
end

---Called when leaving this layout
function Layout:onLeave()
	-- Called when leaving this layout
end

---Called every frame before scene update
---@param dt number Delta time in seconds
function Layout:update(dt)
	-- Called every frame before scene update
end

---Called every frame for rendering
---@param drawScene function Function that renders the current scene
function Layout:draw(drawScene)
	-- Called every frame for rendering
	-- drawScene is a function that renders the current scene
	if drawScene then
		drawScene()
	end
end

return Layout
