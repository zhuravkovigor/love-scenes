-- Test runner - runs all tests

require("tests.mock_love")
local TestFramework = require("tests.test_framework")

-- Import all test modules
local testModules = {
	require("tests.test_utils"),
	require("tests.test_router"),
	require("tests.test_scene"),
	require("tests.test_dynamic_params"),
}

-- Combine all tests
local allTests = TestFramework.new()

for _, testModule in ipairs(testModules) do
	for _, test in ipairs(testModule.tests) do
		allTests:test(test.name, test.func)
	end
end

-- Run all tests
local success = allTests:run()

-- Exit with appropriate code
if success then
	print("\n🎉 All tests passed!")
	os.exit(0)
else
	print("\n❌ Some tests failed!")
	os.exit(1)
end
