local awful = require("awful")
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

-- return a table containing maximized clients amongs visible clients
local function get_maximized_clients()
	local clients = awful.screen.focused():get_clients()
	local maximized_clients = {}
	for _, c in pairs(clients) do
		if c.maximized == true then
			table.insert(maximized_clients, c)
		end
	end
	return maximized_clients
end

-- switch maximize on focus if at least a visible client was maximized
client.connect_signal("focus", function(c)
	local maximized_clients = get_maximized_clients()
	local time_now = os.time()
	if c.floating == false then
		if #maximized_clients >= 1 and ((c.ff == nil) or c.ff > 0 or time_now - c.spawn_time > 1) then
			for _, mc in pairs(maximized_clients) do
				mc.maximized = false
			end
			c.maximized = true
		end
	end
end)
