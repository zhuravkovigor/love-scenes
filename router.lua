--- Router module for love-scenes
-- Handles file-system based routing similar to Next.js.
--
-- The router scans the scenes directory and creates routes based on the file structure.
-- Supports both static routes (index.lua files) and dynamic routes ([param].lua files).
--
-- @module love-scenes.router
-- @author Igor Zhuravkov

local Router = {}
Router.__index = Router

local utils = require("utils")

--- Create a new router instance
-- @tparam table config Configuration object with routing settings
-- @treturn Router A new router instance
function Router.new(config)
	local self = setmetatable({}, Router)
	self.config = config
	self.scenes = {}
	self.layouts = {}
	return self
end

--- Load all scenes from the scenes directory
-- Recursively scans the scenes directory and registers all valid scene and layout files.
-- Recognizes index.lua files as static routes and [param].lua files as dynamic routes.
function Router:loadScenes()
	self.scenes = {}
	self.layouts = {}
	self:_scanDirectory(self.config.scenesPath, "")

	-- Debug: print all loaded scenes
	if self.config.debugMode then
		print("[Router] Loaded scenes:")
		for route, scene in pairs(self.scenes) do
			print("  " .. route .. " -> " .. scene.path .. (scene.isDynamic and " (dynamic)" or ""))
		end
	end
end

-- Recursively scan directory for scenes and layouts
function Router:_scanDirectory(basePath, relativePath)
	local fullPath = basePath
	if relativePath ~= "" then
		fullPath = basePath .. "/" .. relativePath
	end

	local items = love.filesystem.getDirectoryItems(fullPath)

	for _, item in ipairs(items) do
		local itemPath = fullPath .. "/" .. item
		local relativeItemPath = relativePath == "" and item or relativePath .. "/" .. item

		if love.filesystem.getInfo(itemPath, "directory") then
			-- Recursively scan subdirectories
			self:_scanDirectory(basePath, relativeItemPath)
		elseif item:match("%.lua$") then
			-- Process Lua files
			if item == "index.lua" then
				local route = self:_pathToRoute(relativePath)
				self.scenes[route] = {
					path = itemPath,
					route = route,
					isDynamic = route:match("%[.+%]") ~= nil,
					params = self:_extractParams(route),
				}
			elseif item == "layout.lua" then
				local route = self:_pathToRoute(relativePath)
				self.layouts[route] = {
					path = itemPath,
					route = route,
				}
			elseif item:match("^%[.+%]%.lua$") then
				-- Dynamic route file like [id].lua
				local paramName = item:match("^%[(.+)%]%.lua$")
				local route = relativePath == "" and "/[" .. paramName .. "]"
					or "/" .. relativePath .. "/[" .. paramName .. "]"
				route = self:_normalizePath(route)

				self.scenes[route] = {
					path = itemPath,
					route = route,
					isDynamic = true,
					params = { paramName },
				}
			end
		end
	end
end

-- Convert file path to route
function Router:_pathToRoute(path)
	if path == "" then
		return "/"
	end
	local route = "/" .. path:gsub("\\", "/")
	return self:_normalizePath(route)
end

-- Normalize path (remove double slashes, etc.)
function Router:_normalizePath(path)
	return path:gsub("//+", "/"):gsub("/$", "")
end

-- Extract parameter names from route
function Router:_extractParams(route)
	local params = {}
	for param in route:gmatch("%[([^%]]+)%]") do
		table.insert(params, param)
	end
	return params
end

--- Resolve a path to a scene and layout
-- Attempts to match the given path to a registered scene, handling both static and dynamic routes.
-- For dynamic routes, extracts parameters from the URL.
--
-- @tparam string path Route path to resolve
-- @tparam ?table params Additional parameters to merge with route parameters
-- @treturn ?table Scene data if found, nil otherwise
-- @treturn ?string Layout file path if found, nil otherwise
-- @treturn ?table Extracted and merged route parameters, nil if no scene found
function Router:resolve(path, params)
	path = self:_normalizePath(path)
	if path == "" then
		path = "/"
	end

	-- Try exact match first
	local scene = self.scenes[path]
	if scene then
		local layout = self:_findLayout(path)
		return scene, layout, params or {}
	end

	-- Try dynamic routes
	for route, sceneData in pairs(self.scenes) do
		if sceneData.isDynamic then
			local routeParams = self:_matchDynamicRoute(path, route)
			if routeParams then
				local layout = self:_findLayout(path)
				-- Merge provided params with route params
				local finalParams = params or {}
				for k, v in pairs(routeParams) do
					finalParams[k] = v
				end
				return sceneData, layout, finalParams
			end
		end
	end

	return nil, nil, nil
end

-- Match path against dynamic route pattern
function Router:_matchDynamicRoute(path, routePattern)
	-- Convert route pattern to regex pattern
	local pattern = routePattern:gsub("%[([^%]]+)%]", "([^/]+)")
	pattern = "^" .. pattern .. "$"

	local matches = { path:match(pattern) }
	if #matches > 0 then
		local params = {}
		local paramNames = self:_extractParams(routePattern)

		for i, paramName in ipairs(paramNames) do
			params[paramName] = matches[i]
		end

		return params
	end

	return nil
end

-- Find the closest layout for a given path
function Router:_findLayout(path)
	-- Start from the current path and walk up the hierarchy
	local segments = utils.split(path, "/")

	for i = #segments, 0, -1 do
		local layoutPath = table.concat(segments, "/", 1, i)
		if layoutPath == "" then
			layoutPath = "/"
		end
		layoutPath = self:_normalizePath(layoutPath)

		local layout = self.layouts[layoutPath]
		if layout then
			return layout.path
		end
	end

	return nil
end

-- Get scene count (for debugging)
---@return number count Number of loaded scenes
function Router:getSceneCount()
	local count = 0
	for _ in pairs(self.scenes) do
		count = count + 1
	end
	return count
end

-- Get all routes (for debugging)
---@return table[] routes Array of route information
function Router:getRoutes()
	local routes = {}
	for route, scene in pairs(self.scenes) do
		table.insert(routes, {
			route = route,
			path = scene.path,
			isDynamic = scene.isDynamic,
			params = scene.params,
		})
	end
	return routes
end

return Router
