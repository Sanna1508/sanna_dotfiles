local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local container = require("config.widgets.container_a")

return function()
	local textclock = wibox.widget.textclock(" %H:%M:%S ", 1)
	local clock = container(textclock, 6, "center", "center")
	return clock
end
