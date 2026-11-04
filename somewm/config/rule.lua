local ruled = require("ruled")
local awful = require("awful")

awesome.set_idle_timeout("display-off", 1800, function()
	awesome.dpms_off()
end)

ruled.client.connect_signal("request::rules", function()
	-- All clients match this rule.
	ruled.client.append_rule({
		id = "global",
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	})
end)
