local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- get basic slider
local volume_slider = wibox.widget({
	bar_shape = gears.shape.rounded_rect,
	bar_height = 3,
	bar_color = beautiful.border_color,
	handle_color = beautiful.bg_normal,
	handle_shape = gears.shape.circle,
	handle_border_color = beautiful.border_color,
	handle_width = 30,
	value = 25,
	maximum = 100,
	widget = wibox.widget.slider,
})

local function update_slider(vol)
	if vol <= 100 then
		volume_slider.maximum = 100
		volume_slider.handle_color = "#834992"
	else
		volume_slider.maximum = math.floor(vol / 100) * 100 + 110
		volume_slider.handle_color = "#383294"
	end
end
-- update slider via wpctl
local function update_volume()
	awful.spawn.easy_async_with_shell("wpctl get-volume @DEFAULT_SINK@", function(stdout)
		local vol = tonumber(stdout:match("Volume:%s*(%d+%.%d+)")) * 100
		-- local muted = stdout:match("Mute: yes") and true or false
		if not vol then
			vol = 0
		end
		volume_slider.value = vol
		update_slider(vol)
	end)
end

-- init widget for the first time
awful.spawn(update_volume())

-- sync volume from slider
volume_slider:connect_signal("property::value", function(slider)
	local current_val = slider.value
	update_slider(slider.value)
	awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ " .. current_val .. "%", false)
end)

-- sync slider.value from signal
awesome.connect_signal("widget::volume", update_volume)

return volume_slider
