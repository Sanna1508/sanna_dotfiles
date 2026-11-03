local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local timer = gears.timer({
	timeout = 0.3,
	-- autostart = true,
	callback = function()
		awful.spawn("notify-send 'play timer'")
	end,
})

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

-- update slider via brightnessctl
local function update_brightness()
	awful.spawn.easy_async_with_shell("brightnessctl get", function(stdout)
		local value = tonumber(stdout:match("(%d+)")) / 75
		if not value then
			value = 0
		end
		birghtness_slider.value = value
	end)
end

-- init widget for the first time
awful.spawn(update_brightness())

-- sync brightness from slider
birghtness_slider:connect_signal("property::value", function(slider)
	local new_val = slider.value
	awful.spawn.easy_async_with_shell("brightnessctl get", function(stdout)
		local value = tonumber(stdout:match("(%d+)")) / 75
		if new_val ~= value then
			awful.spawn("brightnessctl set " .. new_val .. "%", false)
		end
	end)
end)

-- sync slider.value from signal
-- awesome.connect_signal("widget::brightness", update_brightness)

return birghtness_slider
