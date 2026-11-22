local awful = require("awful")
local keyboard = require("awful.keyboard")
local key = require("awful.key")
local env = require("env")

local super = env.super

local layout_preset = {
	awful.layout.suit.carousel,
	awful.layout.suit.tile,
	awful.layout.suit.max,
	awful.layout.suit.floating,
}
local layouts = {}
for i = 1, #layout_preset do
	layouts[i] = {
		awful.layout.getname(layout_preset[i]),
		function()
			awful.layout.set(layout_preset[i])
		end,
	}
end

local layout_menus = awful.menu({
	items = layouts,
})

keyboard.append_global_keybindings({
	key({ super }, "apostrophe", function()
		layout_menus:toggle({ coords = { x = 400, y = 320 } })
	end),
	{ description = "toggle layoutmenu", group = "menus" },
})
