local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi

-- ensure maximize do not having border and rounded corners
client.connect_signal("property::maximized", function(c)
	if c.maximized == true then
		c.border_width = 0
		c.shape = function(cr, w, h)
			gears.shape.rectangle(cr, w, h)
		end
	else
		c.border_width = beautiful.border_width
		c.shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, dpi(beautiful.dpi_rounded_corner))
		end
	end
end)
