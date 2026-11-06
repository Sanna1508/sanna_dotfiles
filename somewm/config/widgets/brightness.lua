local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local container = require("config.widgets.container_a")

local istimerended = false

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
local birghtness_slider = wibox.widget({
	bar_shape = gears.shape.rounded_rect,
	bar_height = 3,
	bar_color = beautiful.border_color,
	handle_color = beautiful.fg_normal or beautiful.bg_normal,
	handle_shape = gears.shape.circle,
	handle_border_color = beautiful.border_color,
	handle_width = 30,
	value = 25,
	minimum = 1,
	maximum = 100,
	widget = wibox.widget.slider,
})

-- update slider via brightnessctl
local function update_slider()
	awful.spawn.easy_async_with_shell("brightnessctl get", function(stdout)
		local value = tonumber(stdout:match("(%d+)")) / 75
		if not value then
			value = 0
		end
		birghtness_slider.value = value
	end)
end

-- update brightness from slider
local changing_brightness = function(new_val)
	awful.spawn.easy_async_with_shell("brightnessctl get", function(stdout)
		local value = tonumber(stdout:match("(%d+)")) / 75
		if new_val ~= value then
			awful.spawn("brightnessctl set " .. new_val .. "%", false)
		end
	end)
end

-- init widget for the first time
awful.spawn(update_slider())

-- sync brightness from slider
birghtness_slider:connect_signal("property::value", function(slider)
	if istimerended then
		local new_val = slider.value
		changing_brightness(new_val)
		istimerended = false
	else
		timer:start()
	end
end)

-- sync slider.value from signal
-- awesome.connect_signal("widget::brightness", update_brightness)

local birghtness_widget = container(birghtness_slider, 6, "center", "center")

return birghtness_widget
