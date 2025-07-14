-- Tests for scene module

require("tests.mock_love")
local TestFramework = require("tests.test_framework")
local Scene = require("scene")

local test = TestFramework.new()

test:test("Scene should create instance with parameters", function(t)
	local sceneData = {
		path = "test_scenes/profile/[id].lua",
		route = "/profile/[id]",
		isDynamic = true,
		params = { "id" },
	}

	local params = { id = "123", extra = "data" }
	local scene = Scene.create(sceneData, params)

	t:assertNotNil(scene)
	t:assertEquals(scene.route, "/profile/[id]")
	t:assertEquals(scene.isDynamic, true)
	t:assertEquals(scene.params.id, "123")
	t:assertEquals(scene.params.extra, "data")
end)

test:test("Scene should have default lifecycle methods", function(t)
	local sceneData = {
		path = "test_scenes/index.lua",
		route = "/",
		isDynamic = false,
		params = {},
	}

	local scene = Scene.create(sceneData, {})

	t:assertNotNil(scene.onEnter)
	t:assertNotNil(scene.onLeave)
	t:assertNotNil(scene.update)
	t:assertNotNil(scene.draw)
end)

test:test("Scene getParam should return parameter value", function(t)
	local sceneData = {
		path = "test_scenes/profile/[id].lua",
		route = "/profile/[id]",
		isDynamic = true,
		params = { "id" },
	}

	local params = { id = "123", name = "test" }
	local scene = Scene.create(sceneData, params)

	t:assertEquals(scene:getParam("id"), "123")
	t:assertEquals(scene:getParam("name"), "test")
	t:assertEquals(scene:getParam("missing", "default"), "default")
	t:assertNil(scene:getParam("missing"))
end)

test:test("Scene hasParam should check parameter existence", function(t)
	local sceneData = {
		path = "test_scenes/profile/[id].lua",
		route = "/profile/[id]",
		isDynamic = true,
		params = { "id" },
	}

	local params = { id = "123", name = "test" }
	local scene = Scene.create(sceneData, params)

	t:assert(scene:hasParam("id"))
	t:assert(scene:hasParam("name"))
	t:assert(not scene:hasParam("missing"))
end)

test:test("Scene should initialize dynamic parameters", function(t)
	local sceneData = {
		path = "test_scenes/profile/[id].lua",
		route = "/profile/[id]",
		isDynamic = true,
		params = { "id" },
	}

	local params = { id = "user123" }
	local scene = Scene.create(sceneData, params)

	-- Mock scene should set userId in init
	t:assertEquals(scene.userId, "user123")
end)

return test
