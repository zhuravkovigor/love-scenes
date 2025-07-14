package = "love-scenes"
version = "1.0-1"
source = {
   url = "git+https://github.com/zhuravkovigor/love-scenes.git",
   tag = "v1.0"
}
description = {
   summary = "File-system based scene routing for LÖVE 2D games inspired by Next.js",
   detailed = [[
      A library that provides Next.js-style file-system based routing for LÖVE 2D game scenes.
      Create scenes using index.lua, layout.lua, and dynamic routes like [id].lua.
      Supports nested routing, dynamic parameters, and layout inheritance.
   ]],
   homepage = "https://github.com/zhuravkovigor/love-scenes",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1"
}
build = {
   type = "builtin",
   modules = {
      ["love-scenes"] = "init.lua",
      ["love-scenes.router"] = "router.lua",
      ["love-scenes.scene"] = "scene.lua",
      ["love-scenes.layout"] = "layout.lua",
      ["love-scenes.utils"] = "utils.lua",
      ["love-scenes.types"] = "types.lua"
   },
   copy_directories = {
      "tests"
   }
}
