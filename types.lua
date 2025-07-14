-- Type definitions for love-scenes library
-- This file provides JSDoc-style type annotations for better IDE support

---@meta

---@class LoveScenesConfig
---@field scenesPath string Path to scenes directory (default: "scenes")
---@field autoLoad boolean Automatically load scenes on init (default: true)
---@field enableLayouts boolean Enable layout system (default: true)
---@field debugMode boolean Enable debug logging (default: false)

---@class SceneParams
---@field [string] any Dynamic parameters from route

---@class RouteParams
---@field [string] string Parameters extracted from dynamic routes

---@class SceneData
---@field path string Absolute path to scene file
---@field route string Route pattern (e.g., "/profile/[id]")
---@field isDynamic boolean Whether this is a dynamic route
---@field params string[] Parameter names for dynamic routes

---@class LayoutData
---@field path string Absolute path to layout file
---@field route string Route pattern for layout

---@class Scene
---@field path string Scene file path
---@field route string Scene route
---@field params table<string, any> Route parameters
---@field isDynamic boolean Whether scene is dynamic
local Scene = {}

---Scene initialization method
---@param params table<string, any> Route parameters
function Scene:init(params) end

---Called when entering this scene
function Scene:onEnter() end

---Called when leaving this scene
function Scene:onLeave() end

---Called every frame
---@param dt number Delta time in seconds
function Scene:update(dt) end

---Called every frame for rendering
function Scene:draw() end

---Get route parameter value
---@param name string Parameter name
---@param default any Default value if parameter not found
---@return any
function Scene:getParam(name, default) end

---Check if scene has parameter
---@param name string Parameter name
---@return boolean
function Scene:hasParam(name) end

-- LÖVE 2D callbacks
---@param key string
---@param scancode string
---@param isrepeat boolean
function Scene:keypressed(key, scancode, isrepeat) end

---@param key string
function Scene:keyreleased(key) end

---@param x number
---@param y number
---@param button number
---@param istouch boolean
---@param presses number
function Scene:mousepressed(x, y, button, istouch, presses) end

---@param x number
---@param y number
---@param button number
---@param istouch boolean
---@param presses number
function Scene:mousereleased(x, y, button, istouch, presses) end

---@param x number
---@param y number
---@param dx number
---@param dy number
---@param istouch boolean
function Scene:mousemoved(x, y, dx, dy, istouch) end

---@param x number
---@param y number
function Scene:wheelmoved(x, y) end

---@param w number
---@param h number
function Scene:resize(w, h) end

---@param focused boolean
function Scene:focus(focused) end

---@class Layout
---@field path string Layout file path
local Layout = {}

---Layout initialization method
function Layout:init() end

---Called when entering this layout with a scene
---@param scene Scene The scene using this layout
function Layout:onEnter(scene) end

---Called when leaving this layout
function Layout:onLeave() end

---Called every frame before scene update
---@param dt number Delta time in seconds
function Layout:update(dt) end

---Called every frame for rendering
---@param drawScene function Function to render the current scene
function Layout:draw(drawScene) end

-- LÖVE 2D callbacks for layouts
---@param key string
---@param scancode string
---@param isrepeat boolean
function Layout:keypressed(key, scancode, isrepeat) end

---@param key string
function Layout:keyreleased(key) end

---@param x number
---@param y number
---@param button number
---@param istouch boolean
---@param presses number
function Layout:mousepressed(x, y, button, istouch, presses) end

---@param x number
---@param y number
---@param button number
---@param istouch boolean
---@param presses number
function Layout:mousereleased(x, y, button, istouch, presses) end

---@param x number
---@param y number
---@param dx number
---@param dy number
---@param istouch boolean
function Layout:mousemoved(x, y, dx, dy, istouch) end

---@param x number
---@param y number
function Layout:wheelmoved(x, y) end

---@param w number
---@param h number
function Layout:resize(w, h) end

---@param focused boolean
function Layout:focus(focused) end

---@class Router
---@field config LoveScenesConfig Configuration object
---@field scenes table<string, SceneData> Loaded scenes by route
---@field layouts table<string, LayoutData> Loaded layouts by route
local Router = {}

---Create new router instance
---@param config LoveScenesConfig Configuration
---@return Router
function Router.new(config) end

---Load all scenes from scenes directory
function Router:loadScenes() end

---Resolve path to scene and layout
---@param path string Route path
---@param params? table<string, any> Additional parameters
---@return SceneData? scene Scene data if found
---@return string? layoutPath Layout file path if found
---@return table<string, any>? routeParams Extracted route parameters
function Router:resolve(path, params) end

---Get number of loaded scenes
---@return number
function Router:getSceneCount() end

---Get all routes for debugging
---@return table[]
function Router:getRoutes() end

---@class LoveScenes
local LoveScenes = {}

---Initialize love-scenes library
---@param config? LoveScenesConfig Configuration options
---@return LoveScenes
function LoveScenes.init(config) end

---Navigate to a scene
---@param path string Route path (e.g., "/", "/game", "/profile/123")
---@param params? table<string, any> Additional parameters
---@return boolean success Whether navigation was successful
function LoveScenes.navigate(path, params) end

---Get current active scene
---@return Scene? scene Current scene instance
function LoveScenes.getCurrentScene() end

---Get current active layout
---@return Layout? layout Current layout instance
function LoveScenes.getCurrentLayout() end

---Update current scene and layout
---@param dt number Delta time in seconds
function LoveScenes.update(dt) end

---Draw current scene and layout
function LoveScenes.draw() end

-- LÖVE 2D callback forwarding
---@param key string
---@param scancode string
---@param isrepeat boolean
function LoveScenes.keypressed(key, scancode, isrepeat) end

---@param key string
function LoveScenes.keyreleased(key) end

---@param x number
---@param y number
---@param button number
---@param istouch boolean
---@param presses number
function LoveScenes.mousepressed(x, y, button, istouch, presses) end

---@param x number
---@param y number
---@param button number
---@param istouch boolean
---@param presses number
function LoveScenes.mousereleased(x, y, button, istouch, presses) end

---@param x number
---@param y number
---@param dx number
---@param dy number
---@param istouch boolean
function LoveScenes.mousemoved(x, y, dx, dy, istouch) end

---@param x number
---@param y number
function LoveScenes.wheelmoved(x, y) end

---@param w number
---@param h number
function LoveScenes.resize(w, h) end

---@param focused boolean
function LoveScenes.focus(focused) end

return {
	LoveScenes = LoveScenes,
	Scene = Scene,
	Layout = Layout,
	Router = Router,
}
