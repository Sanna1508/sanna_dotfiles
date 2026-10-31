local ruled = require("ruled")
local awful = require("awful")
local naughty = require("naughty")

ruled.notification.connect_signal("request::rules", function()
	ruled.notification.append_rule({
		rule = {},
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 5,
		},
	})

	-- Per-app routing example: mute one app, bump urgency for another.
	-- ruled.notification.append_rule {
	--     rule       = { app_name = "Spotify" },
	--     properties = { ignore = true },
	-- }
	-- ruled.notification.append_rule {
	--     rule       = { app_name = "Slack", title = "@you" },
	--     properties = { urgency = "critical" },
	-- }
end)

naughty.connect_signal("request::display", function(n)
	naughty.layout.box({ notification = n })
end)
