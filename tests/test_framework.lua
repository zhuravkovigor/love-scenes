-- Simple test framework for love-scenes
-- Lightweight testing without external dependencies

local TestFramework = {}
TestFramework.__index = TestFramework

function TestFramework.new()
	local self = setmetatable({}, TestFramework)
	self.tests = {}
	self.results = {
		passed = 0,
		failed = 0,
		errors = {},
	}
	return self
end

---Add a test case
---@param name string Test name
---@param testFunc function Test function
function TestFramework:test(name, testFunc)
	table.insert(self.tests, { name = name, func = testFunc })
end

---Assert that condition is true
---@param condition boolean Condition to check
---@param message? string Optional error message
function TestFramework:assert(condition, message)
	if not condition then
		error(message or "Assertion failed")
	end
end

---Assert that two values are equal
---@param actual any Actual value
---@param expected any Expected value
---@param message? string Optional error message
function TestFramework:assertEquals(actual, expected, message)
	if actual ~= expected then
		local msg = message or string.format("Expected %s, got %s", tostring(expected), tostring(actual))
		error(msg)
	end
end

---Assert that value is nil
---@param value any Value to check
---@param message? string Optional error message
function TestFramework:assertNil(value, message)
	if value ~= nil then
		local msg = message or string.format("Expected nil, got %s", tostring(value))
		error(msg)
	end
end

---Assert that value is not nil
---@param value any Value to check
---@param message? string Optional error message
function TestFramework:assertNotNil(value, message)
	if value == nil then
		local msg = message or "Expected non-nil value"
		error(msg)
	end
end

---Assert that table contains key
---@param table table Table to check
---@param key any Key to find
---@param message? string Optional error message
function TestFramework:assertContains(table, key, message)
	if table[key] == nil then
		local msg = message or string.format("Table does not contain key: %s", tostring(key))
		error(msg)
	end
end

---Run all tests
function TestFramework:run()
	print("Running tests...")
	print("================")

	for _, test in ipairs(self.tests) do
		local success, err = pcall(test.func, self)
		if success then
			self.results.passed = self.results.passed + 1
			print("✓ " .. test.name)
		else
			self.results.failed = self.results.failed + 1
			table.insert(self.results.errors, { name = test.name, error = err })
			print("✗ " .. test.name .. ": " .. err)
		end
	end

	print("================")
	print(string.format("Results: %d passed, %d failed", self.results.passed, self.results.failed))

	if self.results.failed > 0 then
		print("\nFailures:")
		for _, failure in ipairs(self.results.errors) do
			print(string.format("  %s: %s", failure.name, failure.error))
		end
	end

	return self.results.failed == 0
end

return TestFramework
