local ruled = require("ruled")
local awful = require("awful")
local naughty = require("naughty")
local timer = require("gears.timer")

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

-- notification
-- battery notification
timer({
	timeout = 60,
	call_now = true,
	autostart = true,
	callback = function()
		awful.spawn.easy_async({ "cat", "/sys/class/power_supply/BAT0/capacity" }, function(out)
			local battery = tonumber(out:match("(%d+)"))
			if battery <= 10 then
				naughty.notification({
					title = "Battery",
					message = "battery is " .. out,
				})
			end
		end)
	end,
})
