local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

return function()
	local textclock = wibox.widget.textclock(" %H:%M:%S ", 1)
	local clock = wibox.widget({
		{
			textclock,
			margins = 6,
			widget = wibox.container.margin,
		},
		bg = "#FFFFFF",
		fg = beautiful.fg_normal,
		widget = wibox.container.background,
	})
	return clock
end
