local naughty = require("naughty")
local beautiful = require("beautiful")

-- client.connect_signal("property::fullscreen", function(c)
-- 	naughty.notification({
-- 		title = c.name,
-- 		message = "fullscreen is " .. (c.fullscreen and "true" or "false"),
-- 	})
-- end)
--
client.connect_signal("request::borrder", function(c)
	c.border_color = beautiful.border_normal
end)
