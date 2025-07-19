# Love Scenes 🎮

File-system based scene routing for LÖVE 2D games inspired by Next.js

## Features

- 📁 **File-system based routing** - Create scenes by simply adding files to your scenes directory
- 🔀 **Dynamic routes** - Support for parameterized routes like `[id].lua`
- 📱 **Layout system** - Wrap scenes with reusable layouts
- 🎯 **Simple API** - Easy to integrate into existing LÖVE 2D projects
- 🔧 **Configurable** - Customize scenes directory and behavior

## Installation

### LuaRocks (Recommended)

```bash
luarocks install love-scenes
```

### Git/GitHub

Install directly from GitHub:

```bash
luarocks install --server=https://luarocks.org/manifests/zhuravkovigor love-scenes
```

Or clone and install manually:

```bash
git clone https://github.com/zhuravkovigor/love-scenes.git
cd love-scenes
luarocks make love-scenes-1.0-1.rockspec
```

### Manual Installation

1. Download the latest release from [GitHub Releases](https://github.com/zhuravkovigor/love-scenes/releases)
2. Extract the files to your project directory
3. Require the library in your `main.lua`

### Development Installation

Clone the repository and install locally:

```bash
git clone https://github.com/zhuravkovigor/love-scenes.git
cd love-scenes
make install
```

## Quick Start

### 1. Basic Setup

```lua
-- main.lua
local LoveScenes = require('love-scenes')

function love.load()
    -- Initialize with default settings
    LoveScenes.init()

    -- Navigate to the main scene
    LoveScenes.navigate('/')
end

function love.update(dt)
    LoveScenes.update(dt)
end

function love.draw()
    LoveScenes.draw()
end

-- Forward input events
function love.keypressed(key, scancode, isrepeat)
    LoveScenes.keypressed(key, scancode, isrepeat)
end
```

### 2. Create Your First Scene

```lua
-- scenes/index.lua (Main menu at route "/")
local scene = {}

function scene:load(params)
    self.title = "My Awesome Game"
end

function scene:update(dt)
    -- Scene update logic
end

function scene:draw()
    love.graphics.printf(self.title, 0, 100, love.graphics.getWidth(), "center")
end

function scene:keypressed(key)
    if key == "space" then
        require('love-scenes').navigate('/game')
    end
end

return scene
```

### 3. Add More Scenes

```lua
-- scenes/game/index.lua (Game scene at route "/game")
local scene = {}

function scene:load(params)
    self.player = {x = 100, y = 100}
end

function scene:update(dt)
    if love.keyboard.isDown("left") then
        self.player.x = self.player.x - 100 * dt
    end
    if love.keyboard.isDown("right") then
        self.player.x = self.player.x + 100 * dt
    end
end

function scene:draw()
    love.graphics.circle("fill", self.player.x, self.player.y, 20)
end

return scene
```

## File Structure

Love Scenes uses a file-system based routing approach similar to Next.js:

```
scenes/
├── index.lua              # Route: /
├── layout.lua             # Layout for all scenes
├── game/
│   ├── index.lua          # Route: /game
│   └── layout.lua         # Layout for /game/* routes
├── level/
│   └── [level].lua        # Route: /level/1-1, /level/forest, etc.
├── profile/
│   └── [id].lua           # Route: /profile/123, /profile/abc, etc.
├── shop/
│   └── [category].lua     # Route: /shop/weapons, /shop/armor, etc.
└── settings/
    ├── index.lua          # Route: /settings
    └── audio/
        └── index.lua      # Route: /settings/audio
```

## Routing Examples

### Static Routes

- `scenes/index.lua` → `/` (root)
- `scenes/about/index.lua` → `/about`
- `scenes/game/level/index.lua` → `/game/level`

### Dynamic Routes

- `scenes/user/[id].lua` → `/user/123`, `/user/abc`
- `scenes/level/[level].lua` → `/level/1-1`, `/level/forest`
- `scenes/shop/[category].lua` → `/shop/weapons`, `/shop/armor`
- `scenes/post/[slug]/[id].lua` → `/post/hello-world/123`

```lua
-- scenes/level/[level].lua
local scene = {}

function scene:load(params)
    self.levelId = params.level  -- Access the dynamic parameter
    print("Loading level:", self.levelId)

    -- Different logic based on level
    if self.levelId == "boss-1" then
        self:loadBossLevel()
    else
        self:loadNormalLevel()
    end
end

return scene
```

## Layouts

Layouts wrap scenes and provide common UI elements:

```lua
-- scenes/layout.lua (Root layout for all scenes)
local layout = {}

function layout:draw(drawScene)
    -- Draw header
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 60)

    -- Draw scene content
    love.graphics.push()
    love.graphics.translate(0, 60)
    drawScene()  -- This renders the current scene
    love.graphics.pop()

    -- Draw footer
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight() - 40,
                          love.graphics.getWidth(), 40)
end

return layout
```

## Navigation

Navigate between scenes using the `navigate` function:

```lua
local LoveScenes = require('love-scenes')

-- Navigate to different routes
LoveScenes.navigate('/')
LoveScenes.navigate('/game')
LoveScenes.navigate('/profile/123')
LoveScenes.navigate('/settings/audio')

-- Navigate with additional parameters
LoveScenes.navigate('/user/123', {tab = "settings"})
```

## Configuration

All configuration parameters are optional. Love Scenes works out of the box with sensible defaults:

```lua
-- Minimal setup - all parameters are optional
LoveScenes.init()

-- With custom configuration
LoveScenes.init({
    scenesPath = "scenes",      -- Directory containing scenes (default: "scenes")
    autoLoad = true,            -- Automatically load scenes on init (default: true)
    enableLayouts = true,       -- Enable layout system (default: true)
    debugMode = false           -- Enable debug logging (default: false)
})
```

### Configuration Options

| Parameter       | Type    | Default    | Description                                          |
| --------------- | ------- | ---------- | ---------------------------------------------------- |
| `scenesPath`    | string  | `"scenes"` | Directory containing your scene files                |
| `autoLoad`      | boolean | `true`     | Automatically scan and load scenes on initialization |
| `enableLayouts` | boolean | `true`     | Enable the layout system for wrapping scenes         |
| `debugMode`     | boolean | `false`    | Enable debug logging to console                      |

## Scene Lifecycle

Scenes have several lifecycle methods:

```lua
local scene = {}

function scene:load(params)
    -- Called when scene is created and loaded
    -- Access route parameters via params
    -- Initialize scene data, load assets, set up state
end

function scene:onEnter()
    -- Called when navigating to this scene
end

function scene:onLeave()
    -- Called when leaving this scene
end

function scene:update(dt)
    -- Called every frame
end

function scene:draw()
    -- Called every frame for rendering
end

-- LÖVE 2D callbacks are automatically forwarded
function scene:keypressed(key, scancode, isrepeat)
    -- Handle input
end

function scene:mousepressed(x, y, button, isTouch, presses)
    -- Handle mouse input
end

return scene
```

## Layout Lifecycle

Layouts also have lifecycle methods:

```lua
local layout = {}

function layout:load()
    -- Called when layout is created
end

function layout:onEnter(scene)
    -- Called when a scene using this layout is entered
end

function layout:onLeave()
    -- Called when leaving this layout
end

function layout:update(dt)
    -- Called every frame before scene update
end

function layout:draw(drawScene)
    -- Called every frame for rendering
    -- drawScene() renders the current scene
end

return layout
```

## API Reference

### LoveScenes.init(config)

Initialize the library with optional configuration. **All parameters are optional** - the library works with sensible defaults.

**Parameters:**

- `config` (table, optional): Configuration options. If omitted, uses default values.
  - `scenesPath` (string, optional): Directory containing scenes (default: "scenes")
  - `autoLoad` (boolean, optional): Automatically load scenes on init (default: true)
  - `enableLayouts` (boolean, optional): Enable layout system (default: true)
  - `debugMode` (boolean, optional): Enable debug logging (default: false)

**Examples:**

```lua
-- Minimal setup
LoveScenes.init()

-- With custom scenes directory
LoveScenes.init({ scenesPath = "game-scenes" })

-- With debug mode
LoveScenes.init({ debugMode = true })
```

### LoveScenes.navigate(path, params)

Navigate to a scene.

**Parameters:**

- `path` (string): Route path (e.g., "/", "/game", "/user/123")
- `params` (table, optional): Additional parameters to pass to the scene

### LoveScenes.getCurrentScene()

Get the current active scene instance.

### LoveScenes.getCurrentLayout()

Get the current active layout instance.

## Complete Examples

### Basic Game Setup

Here's a complete example of a simple game with multiple scenes:

```lua
-- main.lua
local LoveScenes = require('love-scenes')

function love.load()
    LoveScenes.init({
        debugMode = true  -- Enable debug logging
    })

    -- Start at main menu
    LoveScenes.navigate('/')
end

function love.update(dt)
    LoveScenes.update(dt)
end

function love.draw()
    LoveScenes.draw()
end

-- Forward all LÖVE callbacks
function love.keypressed(key, scancode, isrepeat)
    LoveScenes.keypressed(key, scancode, isrepeat)
end

function love.mousepressed(x, y, button, isTouch, presses)
    LoveScenes.mousepressed(x, y, button, isTouch, presses)
end
```

```lua
-- scenes/index.lua (Main Menu)
local LoveScenes = require('love-scenes')
local scene = {}

function scene:load()
    self.title = "My Awesome Game"
    self.menuItems = {"Start Game", "Settings", "Quit"}
    self.selectedIndex = 1
end

function scene:update(dt)
    -- Menu logic here
end

function scene:draw()
    -- Draw title
    love.graphics.setFont(love.graphics.newFont(32))
    love.graphics.printf(self.title, 0, 100, love.graphics.getWidth(), "center")

    -- Draw menu items
    love.graphics.setFont(love.graphics.newFont(16))
    for i, item in ipairs(self.menuItems) do
        local y = 200 + (i - 1) * 40
        local color = i == self.selectedIndex and {1, 1, 0} or {1, 1, 1}
        love.graphics.setColor(color)
        love.graphics.printf(item, 0, y, love.graphics.getWidth(), "center")
    end
    love.graphics.setColor(1, 1, 1)  -- Reset color
end

function scene:keypressed(key)
    if key == "up" then
        self.selectedIndex = math.max(1, self.selectedIndex - 1)
    elseif key == "down" then
        self.selectedIndex = math.min(#self.menuItems, self.selectedIndex + 1)
    elseif key == "return" then
        if self.selectedIndex == 1 then
            LoveScenes.navigate('/game')
        elseif self.selectedIndex == 2 then
            LoveScenes.navigate('/settings')
        elseif self.selectedIndex == 3 then
            love.event.quit()
        end
    end
end

return scene
```

```lua
-- scenes/game/index.lua (Game Scene)
local LoveScenes = require('love-scenes')
local scene = {}

function scene:load()
    self.player = {
        x = 400,
        y = 300,
        speed = 200
    }
    self.enemies = {}
    self.score = 0
end

function scene:update(dt)
    -- Player movement
    if love.keyboard.isDown("left", "a") then
        self.player.x = self.player.x - self.player.speed * dt
    end
    if love.keyboard.isDown("right", "d") then
        self.player.x = self.player.x + self.player.speed * dt
    end
    if love.keyboard.isDown("up", "w") then
        self.player.y = self.player.y - self.player.speed * dt
    end
    if love.keyboard.isDown("down", "s") then
        self.player.y = self.player.y + self.player.speed * dt
    end

    -- Keep player on screen
    self.player.x = math.max(20, math.min(love.graphics.getWidth() - 20, self.player.x))
    self.player.y = math.max(20, math.min(love.graphics.getHeight() - 20, self.player.y))
end

function scene:draw()
    -- Draw player
    love.graphics.setColor(0, 1, 0)  -- Green
    love.graphics.circle("fill", self.player.x, self.player.y, 20)

    -- Draw UI
    love.graphics.setColor(1, 1, 1)  -- White
    love.graphics.print("Score: " .. self.score, 10, 10)
    love.graphics.print("Press ESC to return to menu", 10, 30)
end

function scene:keypressed(key)
    if key == "escape" then
        LoveScenes.navigate('/')
    end
end

return scene
```

### Dynamic Routes Example

```lua
-- scenes/profile/[id].lua (Dynamic User Profile)
local scene = {}

function scene:load(params)
    self.userId = params.id
    self.userInfo = self:loadUserInfo(self.userId)
end

function scene:loadUserInfo(id)
    -- Simulate loading user data
    return {
        name = "User " .. id,
        level = math.random(1, 100),
        score = math.random(1000, 99999)
    }
end

function scene:draw()
    love.graphics.printf("User Profile", 0, 50, love.graphics.getWidth(), "center")
    love.graphics.printf("ID: " .. self.userId, 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("Name: " .. self.userInfo.name, 0, 130, love.graphics.getWidth(), "center")
    love.graphics.printf("Level: " .. self.userInfo.level, 0, 160, love.graphics.getWidth(), "center")
    love.graphics.printf("Score: " .. self.userInfo.score, 0, 190, love.graphics.getWidth(), "center")

    love.graphics.printf("Press ESC to go back", 0, 250, love.graphics.getWidth(), "center")
end

function scene:keypressed(key)
    if key == "escape" then
        require('love-scenes').navigate('/')
    end
end

return scene
```

Now you can navigate to different user profiles:

- `LoveScenes.navigate('/profile/123')`
- `LoveScenes.navigate('/profile/player1')`
- `LoveScenes.navigate('/profile/admin')`

## Tips and Best Practices

### 1. Scene Organization

- Keep related scenes in subdirectories (e.g., `scenes/game/`, `scenes/menu/`)
- Use descriptive names for dynamic routes: `[playerId].lua`, `[levelName].lua`

### 2. State Management

- Initialize all scene data in the `load()` method
- Use `onEnter()` and `onLeave()` for cleanup and transitions
- Store global state outside of individual scenes if needed

### 3. Performance

- Preload assets in `load()` method
- Use `onLeave()` to clean up resources
- Consider using layouts for shared UI elements

### 4. Navigation

- Use absolute paths for navigation: `/game`, `/settings/audio`
- Pass additional data via the params parameter
- Handle navigation errors gracefully

## Examples

Check out the `scenes/` directory in this repository for complete examples including:

- Main menu with navigation
- Game scene with player movement
- Settings scene with configurable options
- Dynamic profile scenes with URL parameters
- Layout system with header and footer

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see LICENSE file for details.
