-- Mock love module for testing
-- Provides minimal love.* functions needed for tests

local love = {}

-- Mock filesystem
love.filesystem = {}

function love.filesystem.getDirectoryItems(path)
	-- Return mock directory structure for testing
	if path == "test_scenes" then
		return { "index.lua", "layout.lua", "game", "profile" }
	elseif path == "test_scenes/game" then
		return { "index.lua" }
	elseif path == "test_scenes/profile" then
		return { "[id].lua" }
	end
	return {}
end

function love.filesystem.getInfo(path, type)
	-- Mock file/directory info
	local mockFiles = {
		["test_scenes"] = { type = "directory" },
		["test_scenes/index.lua"] = { type = "file" },
		["test_scenes/layout.lua"] = { type = "file" },
		["test_scenes/game"] = { type = "directory" },
		["test_scenes/game/index.lua"] = { type = "file" },
		["test_scenes/profile"] = { type = "directory" },
		["test_scenes/profile/[id].lua"] = { type = "file" },
	}

	local info = mockFiles[path]
	if info and (not type or info.type == type) then
		return info
	end
	return nil
end

function love.filesystem.load(path)
	-- Mock scene loading
	if path:match("index%.lua$") then
		return function()
			return {
				init = function(self, params) end,
				update = function(self, dt) end,
				draw = function(self) end,
			}
		end
	elseif path:match("layout%.lua$") then
		return function()
			return {
				init = function(self) end,
				update = function(self, dt) end,
				draw = function(self, drawScene) end,
			}
		end
	elseif path:match("%[id%]%.lua$") then
		return function()
			return {
				init = function(self, params)
					self.userId = params.id
				end,
				update = function(self, dt) end,
				draw = function(self) end,
			}
		end
	end
	return nil
end

-- Mock graphics (minimal)
love.graphics = {}
function love.graphics.getWidth()
	return 800
end
function love.graphics.getHeight()
	return 600
end

-- Make love global for compatibility
_G.love = love

return love
