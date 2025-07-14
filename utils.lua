--- Utility functions for love-scenes
-- A collection of helper functions used throughout the library.
--
-- @module love-scenes.utils
-- @author Igor Zhuravkov

local utils = {}

--- Split a string by delimiter
-- @tparam string str String to split
-- @tparam string delimiter Delimiter to split by
-- @treturn table Array of string parts
function utils.split(str, delimiter)
	local result = {}
	local pattern = string.format("([^%s]+)", delimiter)

	for match in str:gmatch(pattern) do
		table.insert(result, match)
	end

	return result
end

--- Create a deep copy of a table
-- Recursively copies all nested tables and their contents.
-- @tparam table original Table to copy
-- @treturn table Deep copy of the original table
function utils.deepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			copy[k] = utils.deepCopy(v)
		else
			copy[k] = v
		end
	end
	return copy
end

--- Merge two tables
-- Merges the source table into the target table, recursively merging nested tables.
-- @tparam table target Target table to merge into
-- @tparam table source Source table to merge from
-- @treturn table The target table with merged contents
function utils.merge(target, source)
	for k, v in pairs(source) do
		if type(v) == "table" and type(target[k]) == "table" then
			utils.merge(target[k], v)
		else
			target[k] = v
		end
	end
	return target
end

--- Check if a file exists
-- @tparam string path File path to check
-- @treturn boolean true if file exists, false otherwise
function utils.fileExists(path)
	local info = love.filesystem.getInfo(path)
	return info ~= nil and info.type == "file"
end

--- Check if a directory exists
-- @tparam string path Directory path to check
-- @treturn boolean true if directory exists, false otherwise
function utils.directoryExists(path)
	local info = love.filesystem.getInfo(path)
	return info ~= nil and info.type == "directory"
end

--- Normalize path separators and remove redundant parts
-- Converts backslashes to forward slashes and removes duplicate slashes.
-- @tparam string path Path to normalize
-- @treturn string Normalized path
function utils.normalizePath(path)
	return path:gsub("\\", "/"):gsub("//+", "/"):gsub("/$", "")
end

--- Get file extension from filename
-- @tparam string filename Filename to extract extension from
-- @treturn string File extension without the dot, empty string if no extension
function utils.getExtension(filename)
	return filename:match("^.+%.(.+)$") or ""
end

--- Get filename without extension
-- @tparam string filename Filename to process
-- @treturn string Filename without extension
function utils.getBaseName(filename)
	return filename:match("^(.+)%..+$") or filename
end

return utils
