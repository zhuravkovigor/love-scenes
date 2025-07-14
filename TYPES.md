# Типизация в Love Scenes

Love Scenes использует JSDoc-style аннотации типов для улучшения поддержки в IDE и предотвращения ошибок.

## 📋 Основные типы

### LoveScenesConfig

Конфигурация библиотеки:

```lua
---@class LoveScenesConfig
---@field scenesPath string Путь к папке сцен (по умолчанию: "scenes")
---@field autoLoad boolean Автоматически загружать сцены (по умолчанию: true)
---@field enableLayouts boolean Включить систему лейаутов (по умолчанию: true)
---@field debugMode boolean Включить отладку (по умолчанию: false)
```

### Сцены (Scene)

Методы жизненного цикла сцены:

```lua
---@param params table Параметры маршрута
function scene:init(params) end

---@param dt number Время в секундах
function scene:update(dt) end

function scene:draw() end

---@param key string Нажатая клавиша
function scene:keypressed(key) end
```

### Лейауты (Layout)

Методы жизненного цикла лейаута:

```lua
function layout:init() end

---@param scene table Сцена, использующая этот лейаут
function layout:onEnter(scene) end

---@param dt number Время в секундах
function layout:update(dt) end

---@param drawScene function Функция отрисовки текущей сцены
function layout:draw(drawScene) end
```

## 🛠️ Использование в IDE

### VS Code

1. Установите расширение Lua Language Server
2. Файл `.luarc.json` уже настроен для проекта
3. Получите автодополнение и проверку типов

### Другие редакторы

Любой редактор с поддержкой Lua Language Server получит:

- Автодополнение методов
- Проверку типов параметров
- Предупреждения о неправильном использовании API

## ✅ Проверка типов

Запустите проверку типов:

```bash
make typecheck
```

Или используйте напрямую lua-language-server, если установлен.

## 📚 Примеры типизированного кода

### Сцена с типизацией:

```lua
local scene = {}

---Инициализация сцены
---@param params table Параметры маршрута
function scene:init(params)
    self.playerId = params.id -- автодополнение знает, что это string
end

---Обновление каждый кадр
---@param dt number Время с последнего кадра
function scene:update(dt)
    -- dt автоматически определяется как number
end

return scene
```

### Навигация с типизацией:

```lua
local LoveScenes = require('love-scenes')

-- IDE предупредит о неправильных типах параметров
LoveScenes.navigate('/profile/123', {tab = 'settings'})
```

## 🔧 Отладка

Включите режим отладки для дополнительной информации:

```lua
LoveScenes.init({
    debugMode = true  -- Выводит информацию о загрузке и навигации
})
```
