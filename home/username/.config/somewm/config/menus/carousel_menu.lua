local awful = require("awful")
local keyboard = require("awful.keyboard")
local key = require("awful.key")
local env = require("env")

local super = env.super

local carousel_column_widths = { 1, 0.66, 0.5, 0.34 }
local layouts = {}
for i = 1, #carousel_column_widths do
	layouts[i] = {
		"Set to " .. tostring(carousel_column_widths[i]) .. "x",
		function()
			awful.layout.suit.carousel.set_column_width(carousel_column_widths[i])
		end,
	}
end

local width_menu = awful.menu({
	items = layouts,
})

client.connect_signal("request::default_keybindings", function()
	keyboard.append_client_keybindings({
		key({ super }, ".", function()
			width_menu:toggle({ coords = { x = 400, y = 320 } })
		end),
		{ description = "toggle client_menu", group = "menus" },
	})
end)
