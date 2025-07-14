-- Tests for router module

require("tests.mock_love")
local TestFramework = require("tests.test_framework")
local Router = require("router")

local test = TestFramework.new()

test:test("Router should initialize with config", function(t)
	local config = {
		scenesPath = "test_scenes",
		debugMode = false,
	}

	local router = Router.new(config)
	t:assertNotNil(router)
	t:assertEquals(router.config.scenesPath, "test_scenes")
end)

test:test("Router should load scenes from directory", function(t)
	local config = {
		scenesPath = "test_scenes",
		debugMode = false,
	}

	local router = Router.new(config)
	router:loadScenes()

	-- Should find index, game/index, and profile/[id]
	t:assertEquals(router:getSceneCount(), 3)

	-- Check specific routes
	t:assertContains(router.scenes, "/")
	t:assertContains(router.scenes, "/game")
	t:assertContains(router.scenes, "/profile/[id]")
end)

test:test("Router should resolve static routes", function(t)
	local config = {
		scenesPath = "test_scenes",
		debugMode = false,
	}

	local router = Router.new(config)
	router:loadScenes()

	local scene, layout, params = router:resolve("/")
	t:assertNotNil(scene)
	t:assertEquals(scene.route, "/")
	t:assertEquals(scene.isDynamic, false)
end)

test:test("Router should resolve dynamic routes", function(t)
	local config = {
		scenesPath = "test_scenes",
		debugMode = false,
	}

	local router = Router.new(config)
	router:loadScenes()

	local scene, layout, params = router:resolve("/profile/123")
	t:assertNotNil(scene)
	t:assertEquals(scene.route, "/profile/[id]")
	t:assertEquals(scene.isDynamic, true)
	t:assertNotNil(params)
	t:assertEquals(params.id, "123")
end)

test:test("Router should return nil for non-existent routes", function(t)
	local config = {
		scenesPath = "test_scenes",
		debugMode = false,
	}

	local router = Router.new(config)
	router:loadScenes()

	local scene, layout, params = router:resolve("/nonexistent")
	t:assertNil(scene)
	t:assertNil(layout)
	t:assertNil(params)
end)

test:test("Router should handle multiple dynamic parameters", function(t)
	local config = {
		scenesPath = "test_scenes",
		debugMode = false,
	}

	local router = Router.new(config)
	router:loadScenes()

	local scene, layout, params = router:resolve("/profile/user123")
	t:assertNotNil(scene)
	t:assertNotNil(params)
	t:assertEquals(params.id, "user123")
end)

return test
