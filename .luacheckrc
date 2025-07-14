-- Luacheck configuration for love-scenes

-- Global configuration
std = "lua53+love"
cache = true
codes = true

-- Ignore specific warnings
ignore = {
	"112", -- Mutating an undefined global variable
	"113", -- Accessing an undefined global variable
	"131", -- Unused implicitly defined global variable
	"211", -- Unused local variable
	"212", -- Unused argument
	"213", -- Unused loop variable
	"231", -- Local variable is set but never accessed
}

-- Global variables
globals = {
	"love",
	"_G",
}

-- Read-only globals
read_globals = {
	"love",
	"jit",
}

-- Files and directories to exclude
exclude_files = {
	"tests/mock_love.lua", -- Mock file with intentional globals
	"docs/", -- Generated documentation
	"build/", -- Build artifacts
	"*.rock", -- LuaRocks packages
}

-- File-specific configurations
files["main.lua"] = {
	ignore = { "113" }, -- Allow accessing love globals
}

files["tests/"] = {
	ignore = { "112", "113" }, -- Tests might access undefined globals
	globals = { "describe", "it", "assert" }, -- Test framework globals
}

files["scenes/"] = {
	ignore = { "113" }, -- Scenes can access love globals
	read_globals = { "love", "require" },
}

-- Maximum line length
max_line_length = 120

-- Maximum complexity
max_cyclomatic_complexity = 15

-- Warning format
format = "default"
