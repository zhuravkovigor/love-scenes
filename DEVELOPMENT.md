# Love Scenes Development

This is a development guide for Love Scenes library contributors.

## 🛠️ Development Environment Setup

### Installing Dependencies

```bash
# Install development dependencies
make dev-deps

# Or manually
luarocks install --local luacheck
luarocks install --local ldoc
luarocks install --local busted
```

## ✅ Code Quality Checks

### Linting

```bash
# Check code style
make lint

# Configuration in .luacheckrc
```

### Testing

```bash
# Run all tests
make test

# Tests are located in tests/ directory
```

### Documentation Generation

```bash
# Generate documentation
make docs

# Open in browser
open docs/index.html
```

### Type Checking

```bash
# Check types (if lua-language-server is installed)
make typecheck
```

## 🚀 Development Workflow

### Quick Check

```bash
# Tests + demo
make dev
```

### Pre-commit

```bash
# Linting + tests
make pre-commit
```

### Full CI Check

```bash
# All checks
make ci
```

### Publishing to LuaRocks

```bash
# 1. Get API key from https://luarocks.org/settings/api-keys
export LUAROCKS_API_KEY=your_api_key_here

# 2. Create release
make ci                     # Ensure all checks pass
git tag v1.0               # Create tag
git push origin v1.0       # Push tag

# 3. Upload to LuaRocks
make upload
```

## 📁 Project Structure

```
love-scenes/
├── .gitignore          # Git ignored files
├── .luacheckrc         # luacheck configuration
├── .luarc.json         # Lua Language Server configuration
├── config.ld           # LDoc configuration
├── Makefile            # Build automation
├── init.lua            # Main module
├── router.lua          # Routing system
├── scene.lua           # Scene management
├── layout.lua          # Layout system
├── utils.lua           # Utilities
├── types.lua           # Type definitions
├── scenes/             # Example scenes
├── tests/              # Tests
└── docs/               # Generated documentation
```

## 🔄 Development Lifecycle

1. **Making Changes**

   ```bash
   # Edit code
   vim init.lua
   ```

2. **Testing**

   ```bash
   # Quick check
   make dev
   ```

3. **Pre-commit**

   ```bash
   # Full check
   make pre-commit
   git add .
   git commit -m "feature: add new functionality"
   ```

4. **Release**

   ```bash
   # CI check
   make ci

   # Create package
   make package

   # Upload to LuaRocks (for maintainers)
   export LUAROCKS_API_KEY=your_api_key_here
   make upload
   ```

## 📦 Publishing to LuaRocks

### For Maintainers

1. **Get API Key**

   - Go to https://luarocks.org/settings/api-keys
   - Create a new API key

2. **Set Environment Variable**

   ```bash
   export LUAROCKS_API_KEY=your_api_key_here
   ```

3. **Upload Package**
   ```bash
   make upload
   ```

### Release Process

1. Update version in `love-scenes-X.Y-Z.rockspec`
2. Update Makefile with new filename
3. Create Git tag: `git tag vX.Y`
4. Run full check: `make ci`
5. Upload to LuaRocks: `make upload`

## 📋 Code Standards

### Lua Code

- Maximum line length: 120 characters
- Use JSDoc-style comments for types
- Follow luacheck conventions

### Tests

- All new functions must be covered by tests
- Tests in `tests/` directory
- Use custom testing framework

### Documentation

- LDoc comments for all public functions
- Usage examples in comments
- Update README.md when adding new features

## 🐛 Debugging

### Enable Debug Mode

```lua
LoveScenes.init({
    debugMode = true
})
```

### Logs

Debug information is output to console when `debugMode = true`.

## 📊 Quality Metrics

- ✅ 100% test coverage of main API
- ✅ 0 luacheck warnings
- ✅ Complete LDoc documentation
- ✅ Type definitions for IDE support
