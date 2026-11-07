local awful = require("awful")
local spawn = require("awful.spawn")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")

local container = require("config.widgets.container_a")

local istimerended = false
local mute_icon = { "󰝟", "󰕾" }

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

-- get a basic textbox
local mutebox = wibox.widget({
	text = mute_icon[1],
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

-- return the current volume (int 0 to 100)
local function get_vol()
	awful.spawn.easy_async("pactl get-sink-volume @DEFAULT_SINK@", function(stdout)
		local current_vol = tonumber(stdout:match("(%d+)%%"))
		if current_vol then
			return current_vol
		end
	end)
end

-- update new volume
local function update_vol(new_vol)
	if get_vol() ~= new_vol then
		spawn("pactl set-sink-volume @DEFAULT_SINK@ " .. tostring(new_vol) .. "%")
	end
end

local function update_slider(new_val)
	volume_slider.value = new_val
end

-- update mutebox
local function update_mutebox()
	awful.spawn.easy_async("pactl get-sink-mute @DEFAULT_SINK@", function(stdout)
		local status = stdout:match("Mute:%s*(%a+)")
		if status == "yes" then
			mutebox.text = mute_icon[1]
		else
			mutebox.text = mute_icon[2]
		end
	end)
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

mutebox:connect_signal("button::press", function()
	toggle_mute_state()
	update_mutebox()
end)

update_slider(get_vol() or 75)
update_mutebox()

local volume_widget = wibox.widget({
	{
		widget = mutebox,
	},
	{
		widget = volume_slider,
	},
	layout = wibox.layout.ratio.horizontal,
})
volume_widget:set_ratio(1, 0.1)
volume_widget:set_ratio(2, 0.9)

return wibox.widget({
	volume_widget,
	margins = 6,
	widget = wibox.container.margin,
})

-- return container(volume_widget, 0, "center", "center")
