# IDE Configuration для Love Scenes

Настройки для различных редакторов и IDE для оптимальной работы с Love Scenes.

## 🎯 VS Code

### Расширения
Установите следующие расширения:
```
- Lua Language Server (sumneko.lua)
- LÖVE 2D Support (pixelbyte-studios.pixelbyte-love2d)
- Lua (keyring.Lua)
```

### Настройки
Файл `.vscode/settings.json`:
```json
{
    "Lua.runtime.version": "Lua 5.1",
    "Lua.workspace.library": [
        "/usr/share/love"
    ],
    "Lua.diagnostics.globals": [
        "love"
    ],
    "Lua.completion.enable": true,
    "Lua.hover.enable": true,
    "files.associations": {
        "*.lua": "lua"
    }
}
```

### Задачи
Файл `.vscode/tasks.json`:
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

### Конфигурация LSP
```lua
-- init.lua для Neovim
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

### Плагины
```lua
-- С помощью packer.nvim
use {
  'neovim/nvim-lspconfig',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
}
```

## 📝 Sublime Text

### Пакеты
Установите через Package Control:
- SublimeLinter
- SublimeLinter-luacheck
- Lua Dev
- LOVE

### Настройки
Файл `Preferences > Settings`:
```json
{
    "rulers": [120],
    "translate_tabs_to_spaces": true,
    "tab_size": 4
}
```

## 🛠️ Vim

### Плагины
```vim
" В .vimrc
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'dense-analysis/ale'
```

### Конфигурация ALE
```vim
let g:ale_linters = {
\   'lua': ['luacheck'],
\}
let g:ale_fixers = {
\   'lua': ['trim_whitespace', 'remove_trailing_lines'],
\}
```

## 🎨 Emacs

### Конфигурация
```elisp
;; В init.el
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

## 🔧 Общие настройки

### EditorConfig
Файл `.editorconfig`:
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

### Git hooks
```bash
# Установка pre-commit hook
echo "#!/bin/bash\nmake pre-commit" > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

## 🎯 Рекомендуемый workflow

1. **Настройте IDE** с Lua Language Server
2. **Установите зависимости**: `make dev-deps`
3. **Проверьте настройку**: `make ci`
4. **Начинайте разработку** с автодополнением и проверкой типов

## 🐛 Отладка настроек

### Проверка Lua Language Server
```bash
# Проверка версии
lua-language-server --version

# Проверка конфигурации
cat .luarc.json
```

### Проверка luacheck
```bash
# Тест конфигурации
luacheck --version
luacheck --config .luacheckrc init.lua
```

### Проверка LÖVE 2D
```bash
# Версия LÖVE
love --version

# Запуск демо
make demo
```
