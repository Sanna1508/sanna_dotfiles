local awful = require("awful")
local keyboard = require("awful.keyboard")
local key = require("awful.key")
local wibox = require("wibox")
local gears = require("gears")

local init_box = require("config.wiboxs.rounded_retangle_wibox")

local brightness = require("config.widgets.brightness")
local clock = require("config.widgets.clock")
local volume = require("config.widgets.volume")
local volume_mute_icon = require("config.icons.volume_mute")

-- init layout
local layout = wibox.widget({
	{
		widget = clock,
	},
	{
		widget = brightness,
	},
	{
		widget = volume,
	},
	{
		widget = wibox.widget.imagebox(volume_mute_icon, true, gears.shape.rectangle),
	},
	layout = wibox.layout.flex.vertical,
})

-- init a dashboard per screen
awful.screen.connect_for_each_screen(function(s)
	s.dashboard = init_box(s, 0.18, 0.81, 0.9, 0.05)
	s.dashboard.widget = layout
end)

-- keybinding to visible
keyboard.append_global_keybindings({
	key({ "Mod4" }, "f", function()
		if awful.screen.focused().dashboard then
			awful.screen.focused().dashboard.visible = not awful.screen.focused().dashboard.visible
		end
	end),
	{ description = "toggle box", group = "wibox" },
})
