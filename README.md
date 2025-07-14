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

function scene:init(params)
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

function scene:init(params)
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

function scene:init(params)
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

```lua
LoveScenes.init({
    scenesPath = "scenes",      -- Directory containing scenes (default: "scenes")
    autoLoad = true,            -- Automatically load scenes on init (default: true)
    enableLayouts = true,       -- Enable layout system (default: true)
    debugMode = false           -- Enable debug logging (default: false)
})
```

## Scene Lifecycle

Scenes have several lifecycle methods:

```lua
local scene = {}

function scene:init(params)
    -- Called when scene is created
    -- Access route parameters via params
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

return scene
```

## Layout Lifecycle

Layouts also have lifecycle methods:

```lua
local layout = {}

function layout:init()
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

Initialize the library with optional configuration.

**Parameters:**

- `config` (table, optional): Configuration options

### LoveScenes.navigate(path, params)

Navigate to a scene.

**Parameters:**

- `path` (string): Route path (e.g., "/", "/game", "/user/123")
- `params` (table, optional): Additional parameters to pass to the scene

### LoveScenes.getCurrentScene()

Get the current active scene instance.

### LoveScenes.getCurrentLayout()

Get the current active layout instance.

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
