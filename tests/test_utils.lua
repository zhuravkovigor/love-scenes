-- Tests for utils module

require("tests.mock_love")
local TestFramework = require("tests.test_framework")
local utils = require("utils")

local test = TestFramework.new()

test:test("split should split string by delimiter", function(t)
	local result = utils.split("a/b/c", "/")
	t:assertEquals(#result, 3)
	t:assertEquals(result[1], "a")
	t:assertEquals(result[2], "b")
	t:assertEquals(result[3], "c")
end)

test:test("split should handle empty strings", function(t)
	local result = utils.split("", "/")
	t:assertEquals(#result, 0)
end)

test:test("split should handle single element", function(t)
	local result = utils.split("hello", "/")
	t:assertEquals(#result, 1)
	t:assertEquals(result[1], "hello")
end)

test:test("deepCopy should copy nested tables", function(t)
	local original = {
		a = 1,
		b = {
			c = 2,
			d = { e = 3 },
		},
	}

	local copy = utils.deepCopy(original)

	-- Modify original
	original.a = 99
	original.b.c = 99
	original.b.d.e = 99

	-- Copy should be unchanged
	t:assertEquals(copy.a, 1)
	t:assertEquals(copy.b.c, 2)
	t:assertEquals(copy.b.d.e, 3)
end)

test:test("merge should merge tables", function(t)
	local target = { a = 1, b = { c = 2 } }
	local source = { b = { d = 3 }, e = 4 }

	utils.merge(target, source)

	t:assertEquals(target.a, 1)
	t:assertEquals(target.b.c, 2)
	t:assertEquals(target.b.d, 3)
	t:assertEquals(target.e, 4)
end)

test:test("normalizePath should handle double slashes", function(t)
	t:assertEquals(utils.normalizePath("//test//path//"), "/test/path")
	t:assertEquals(utils.normalizePath("test/path/"), "test/path")
	t:assertEquals(utils.normalizePath("/test/path"), "/test/path")
end)

test:test("getExtension should extract file extension", function(t)
	t:assertEquals(utils.getExtension("file.lua"), "lua")
	t:assertEquals(utils.getExtension("path/to/file.txt"), "txt")
	t:assertEquals(utils.getExtension("noextension"), "")
end)

test:test("getBaseName should extract filename without extension", function(t)
	t:assertEquals(utils.getBaseName("file.lua"), "file")
	t:assertEquals(utils.getBaseName("path/to/file.txt"), "path/to/file")
	t:assertEquals(utils.getBaseName("noextension"), "noextension")
end)

return test
