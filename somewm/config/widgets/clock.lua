local awful = require("awful")
local wibox = require("wibox")

return function()
	local textclock = wibox.widget.textclock(" %H:%M:%S ", 1)

	return textclock
end
