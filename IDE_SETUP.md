# IDE Configuration for Love Scenes

Configuration settings for various editors and IDEs for optimal Love Scenes development.

## 🎯 VS Code

### Extensions

Install the following extensions:

```
- Lua Language Server (sumneko.lua)
- LÖVE 2D Support (pixelbyte-studios.pixelbyte-love2d)
- Lua (keyring.Lua)
```

### Settings

File `.vscode/settings.json`:

```json
{
  "Lua.runtime.version": "Lua 5.1",
  "Lua.workspace.library": ["/usr/share/love"],
  "Lua.diagnostics.globals": ["love"],
  "Lua.completion.enable": true,
  "Lua.hover.enable": true,
  "files.associations": {
    "*.lua": "lua"
  }
}
```

### Tasks

File `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Run Tests",
      "type": "shell",
      "command": "make test",
      "group": "test",
      "presentation": {
        "echo": true,
        "reveal": "always"
      }
    },
    {
      "label": "Run Demo",
      "type": "shell",
      "command": "make demo",
      "group": "build"
    },
    {
      "label": "Lint Code",
      "type": "shell",
      "command": "make lint",
      "group": "test"
    }
  ]
}
```

## 🚀 Neovim

### LSP Configuration

```lua
-- init.lua for Neovim
require'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        version = 'Lua 5.1',
      },
      diagnostics = {
        globals = {'love'},
      },
      workspace = {
        library = {
          ['/usr/share/love'] = true,
        },
      },
    },
  },
}
```

### Plugins

```lua
-- Using packer.nvim
use {
  'neovim/nvim-lspconfig',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
}
```

## 📝 Sublime Text

### Packages

Install via Package Control:

- SublimeLinter
- SublimeLinter-luacheck
- Lua Dev
- LOVE

### Settings

File `Preferences > Settings`:

```json
{
  "rulers": [120],
  "translate_tabs_to_spaces": true,
  "tab_size": 4
}
```

## 🛠️ Vim

### Plugins

```vim
" In .vimrc
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'dense-analysis/ale'
```

### ALE Configuration

```vim
let g:ale_linters = {
\   'lua': ['luacheck'],
\}
let g:ale_fixers = {
\   'lua': ['trim_whitespace', 'remove_trailing_lines'],
\}
```

## 🎨 Emacs

### Configuration

```elisp
;; In init.el
(use-package lua-mode
  :ensure t
  :mode "\\.lua\\'")

(use-package company
  :ensure t
  :config
  (global-company-mode 1))

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode 1))
```

## 🔧 General Settings

### EditorConfig

File `.editorconfig`:

```ini
root = true

[*.lua]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 4
max_line_length = 120

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab
```

### Git Hooks

```bash
# Install pre-commit hook
echo "#!/bin/bash\nmake pre-commit" > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

## 🎯 Recommended Workflow

1. **Set up IDE** with Lua Language Server
2. **Install dependencies**: `make dev-deps`
3. **Check setup**: `make ci`
4. **Start developing** with autocomplete and type checking

## 🐛 Debugging Settings

### Check Lua Language Server

```bash
# Check version
lua-language-server --version

# Check configuration
cat .luarc.json
```

### Check luacheck

```bash
# Test configuration
luacheck --version
luacheck --config .luacheckrc init.lua
```

### Check LÖVE 2D

```bash
# LÖVE version
love --version

# Run demo
make demo
```
