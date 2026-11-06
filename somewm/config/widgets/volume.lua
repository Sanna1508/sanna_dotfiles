local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local container = require("config.widgets.container_a")

local istimerended = false

local command = "get-sink-volume @DEFAULT_SINK@ && pactl get-sink-mute @DEFAULT_SINK@"

-- delayed timer for not making lag
local timer = gears.timer({
	timeout = 0.05,
	autostart = true,
	single_shot = true,
	callback = function()
		istimerended = true
	end,
})

-- get basic slider
local volume_slider = wibox.widget({
	bar_shape = gears.shape.rounded_rect,
	bar_height = 3,
	bar_color = beautiful.border_color,
	handle_color = beautiful.fg_normal,
	handle_shape = gears.shape.circle,
	handle_border_color = beautiful.border_color,
	handle_width = 30,
	value = 25,
	maximum = 100,
	widget = wibox.widget.slider,
})

local function update_volume()
	awful.spawn.easy_async_with_shell(command, function(stdout)
		local vol = tonumber(stdout:match("%/%s*(%d*)%"))
		local muted = stdout:match("Mute: yes") and true or false
		awful.spawn("notify-send '" .. stdout:match("%/%s*(%d*)%") .. "'")
		awful.spawn("notify-send '" .. stdout:match("Mute: yes") .. "'")
	end)
end

update_volume()
