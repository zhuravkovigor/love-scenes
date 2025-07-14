-- Additional tests for dynamic parameters

require("tests.mock_love")
local TestFramework = require("tests.test_framework")
local Router = require("router")

local test = TestFramework.new()

test:test("Router should handle different parameter names", function(t)
	-- Add mock for level scenes
	local originalGetDirectoryItems = love.filesystem.getDirectoryItems
	love.filesystem.getDirectoryItems = function(path)
		if path == "test_scenes" then
			return { "index.lua", "level", "shop" }
		elseif path == "test_scenes/level" then
			return { "[level].lua" }
		elseif path == "test_scenes/shop" then
			return { "[category].lua" }
		end
		return originalGetDirectoryItems(path)
	end

	local originalGetInfo = love.filesystem.getInfo
	love.filesystem.getInfo = function(path, type)
		local mockFiles = {
			["test_scenes"] = { type = "directory" },
			["test_scenes/index.lua"] = { type = "file" },
			["test_scenes/level"] = { type = "directory" },
			["test_scenes/level/[level].lua"] = { type = "file" },
			["test_scenes/shop"] = { type = "directory" },
			["test_scenes/shop/[category].lua"] = { type = "file" },
		}

		local info = mockFiles[path]
		if info and (not type or info.type == type) then
			return info
		end
		return nil
	end

	local config = {
		scenesPath = "test_scenes",
		debugMode = false,
	}

	local router = Router.new(config)
	router:loadScenes()

	-- Should find scenes with different parameter names
	t:assertEquals(router:getSceneCount(), 3)
	t:assertContains(router.scenes, "/level/[level]")
	t:assertContains(router.scenes, "/shop/[category]")

	-- Restore original functions
	love.filesystem.getDirectoryItems = originalGetDirectoryItems
	love.filesystem.getInfo = originalGetInfo
end)

test:test("Router should resolve different parameter names correctly", function(t)
	-- Same mock setup as above
	local originalGetDirectoryItems = love.filesystem.getDirectoryItems
	love.filesystem.getDirectoryItems = function(path)
		if path == "test_scenes" then
			return { "index.lua", "level", "shop" }
		elseif path == "test_scenes/level" then
			return { "[level].lua" }
		elseif path == "test_scenes/shop" then
			return { "[category].lua" }
		end
		return originalGetDirectoryItems(path)
	end

	local originalGetInfo = love.filesystem.getInfo
	love.filesystem.getInfo = function(path, type)
		local mockFiles = {
			["test_scenes"] = { type = "directory" },
			["test_scenes/index.lua"] = { type = "file" },
			["test_scenes/level"] = { type = "directory" },
			["test_scenes/level/[level].lua"] = { type = "file" },
			["test_scenes/shop"] = { type = "directory" },
			["test_scenes/shop/[category].lua"] = { type = "file" },
		}

		local info = mockFiles[path]
		if info and (not type or info.type == type) then
			return info
		end
		return nil
	end

	local config = {
		scenesPath = "test_scenes",
		debugMode = false,
	}

	local router = Router.new(config)
	router:loadScenes()

	-- Test level parameter
	local scene, layout, params = router:resolve("/level/forest")
	t:assertNotNil(scene)
	t:assertEquals(scene.route, "/level/[level]")
	t:assertNotNil(params)
	t:assertEquals(params.level, "forest")

	-- Test category parameter
	scene, layout, params = router:resolve("/shop/weapons")
	t:assertNotNil(scene)
	t:assertEquals(scene.route, "/shop/[category]")
	t:assertNotNil(params)
	t:assertEquals(params.category, "weapons")

	-- Restore original functions
	love.filesystem.getDirectoryItems = originalGetDirectoryItems
	love.filesystem.getInfo = originalGetInfo
end)

test:test("Router should handle complex parameter names", function(t)
	-- Test with various parameter names
	local testCases = {
		{ file = "[userId].lua", route = "/user/[userId]", path = "/user/john123", expected = { userId = "john123" } },
		{
			file = "[worldId].lua",
			route = "/world/[worldId]",
			path = "/world/overworld",
			expected = { worldId = "overworld" },
		},
		{
			file = "[item-type].lua",
			route = "/item/[item-type]",
			path = "/item/sword",
			expected = { ["item-type"] = "sword" },
		},
	}

	for _, testCase in ipairs(testCases) do
		local router = Router.new({ scenesPath = "test", debugMode = false })

		-- Manually add scene for testing
		router.scenes[testCase.route] = {
			path = "test/" .. testCase.file,
			route = testCase.route,
			isDynamic = true,
			params = {},
		}

		local scene, layout, params = router:resolve(testCase.path)
		t:assertNotNil(scene, "Scene should be found for " .. testCase.path)
		t:assertNotNil(params, "Params should be extracted for " .. testCase.path)

		for key, value in pairs(testCase.expected) do
			t:assertEquals(params[key], value, "Parameter " .. key .. " should match")
		end
	end
end)

return test
