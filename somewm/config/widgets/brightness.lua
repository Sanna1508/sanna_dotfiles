local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- get basic slider
local birghtness_slider = wibox.widget({
	bar_shape = gears.shape.rounded_rect,
	bar_height = 3,
	bar_color = beautiful.border_color,
	handle_color = beautiful.bg_normal,
	handle_shape = gears.shape.circle,
	handle_border_color = beautiful.border_color,
	handle_width = 30,
	value = 25,
	minimum = 1,
	maximum = 100,
	widget = wibox.widget.slider,
})

local function update_slider(value)
	if value <= 100 then
		birghtness_slider.maximum = 100
		birghtness_slider.handle_color = "#834992"
	end
end
-- update slider via wpctl
local function update_brightness()
	awful.spawn.easy_async_with_shell("brightnessctl get", function(stdout)
		local value = tonumber(stdout:match("(%d+)")) / 75
		if not value then
			value = 0
		end
		birghtness_slider.value = value
		update_slider(value)
	end)
end

-- init widget for the first time
awful.spawn(update_brightness())

-- sync brightness from slider
birghtness_slider:connect_signal("property::value", function(slider)
	local current_val = slider.value
	update_slider(slider.value)
	awful.spawn("brightnessctl set " .. current_val .. "%", false)
end)

-- sync slider.value from signal
-- awesome.connect_signal("widget::brightness", update_brightness)

return birghtness_slider
