local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local brightness = require("config.widgets.brightness")
local clock = require("config.widgets.clock")
local volume = require("config.widgets.volume")

local function init_box(s, boxwidth_percent, x, boxheight_percent, y)
	boxwidth_percent = (boxwidth_percent > 0 and boxwidth_percent <= 1 and boxwidth_percent) or 0.1
	boxheight_percent = (boxheight_percent > 0 and boxheight_percent <= 1 and boxheight_percent) or 0.1
	x = (x > 0 and x <= 1 and x) or 0
	y = (y > 0 and y <= 1 and y) or 0
	-- init wibox
	local mypanel = wibox({
		visible = false,
		ontop = true,

		screen = s,
		x = s.geometry.width * x,
		y = s.geometry.height * y,
		width = s.geometry.width * boxwidth_percent,
		height = s.geometry.height * boxheight_percent,

		shape = function(cr, width, height)
			return gears.shape.rounded_rect(cr, width, height, 14)
		end,

		opacity = 0.95,
		bg = beautiful.bg_normal or "#222222",
		border_width = beautiful.border_width or 2,
		border_color = beautiful.border_color_active or "#535d6c",
	})
	return mypanel
end

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
	layout = wibox.layout.flex.vertical,
})

awful.screen.connect_for_each_screen(function(s)
	s.box = init_box(s, 0.18, 0.81, 0.9, 0.05)
	s.box.widget = layout
end)
