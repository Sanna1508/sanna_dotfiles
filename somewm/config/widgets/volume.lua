local awful = require("awful")
local spawn = require("awful.spawn")
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
local volume_slider = wibox.widget({
	bar_shape = gears.shape.rounded_rect,
	bar_border_color = beautiful.bg_normal,
	-- bar_border_width = 1,
	bar_height = 5,
	bar_color = beautiful.border_color,
	handle_color = beautiful.fg_normal,
	handle_shape = gears.shape.circle,
	handle_border_color = beautiful.border_color,
	handle_width = 30,
	value = 25,
	maximum = 100,
	widget = wibox.widget.slider,
})

local function get_vol()
	awful.spawn.easy_async_with_shell("pactl get-sink-volume @DEFAULT_SINK@", function(stdout)
		return tonumber(stdout:match("%/%s*(%d*)%%"))
	end)
end

local function get_muted_state()
	awful.spawn.easy_async_with_shell("pactl get-sink-mute @DEFAULT_SINK@", function(stdout)
		return stdout:match("Mute: yes") and true or false
	end)
end

local function update_vol(new_vol)
	spawn("pactl set-sink-volume @DEFAULT_SINK@ " .. tostring(new_vol) .. "%")
end

local function toggle_mute_state()
	spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
end

volume_slider:connect_signal("property::value", function(slider)
	if istimerended then
		local new_vol = slider.value
		update_vol(new_vol)
		istimerended = false
	else
		timer:start()
	end
end)

return container(volume_slider, 6, "center", "center")
