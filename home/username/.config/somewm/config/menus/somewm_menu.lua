local awful = require("awful")
local keyboard = require("awful.keyboard")
local key = require("awful.key")
local spawn = require("awful.spawn")
local hotkeys_popup = require("awful.hotkeys_popup")
local naughty = require("naughty")

local super = "Mod4"

local env = require("env")

local wmmenu = awful.menu({
	items = {
		{
			"hotkeys",
			function()
				hotkeys_popup.show_help(nil, awful.screen.focused())
			end,
		},
		{
			"edit config",
			function()
				local t = awful.tag.find_by_name(awful.screen.focused(), "rice")
				if t and #t:clients() < 1 then
					spawn(env.rice_point)
					naughty.notification({
						message = env.rice_point,
					})
				end
				if t and not t.selected then
					awful.tag.viewtoggle(t)
				end
				local c = t:clients()[1]
				if c then
					c:raise()
					awful.client.focus.byidx(0, c)
				end
			end,
		},
		{ "restart", awesome.restart },
		{
			"quit",
			function()
				awesome.quit()
			end,
		},
	},
})

keyboard.append_global_keybindings({
	key({ super }, "Escape", function()
		wmmenu:toggle({ coords = { x = 400, y = 320 } })
	end),
})
