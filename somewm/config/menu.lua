local awful = require("awful")
local spawn = require("awful.spawn")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local naughty = require("naughty")

local terminal = "kitty"

local menus = {}

menus.wmmenu = awful.menu({
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
				spawn("kitty -d /home/sandrone/Projects/somewm-dotfiles/ yazi")
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

local clientstate = {
	{
		"fullscreen",
		function()
			local c = client.focus
			c.fullscreen = not c.fullscreen
			c.focus:raise()
		end,
	},
	{
		"floating",
		function()
			local c = client.focus
			c.floating = not c.floating
			c:raise()
		end,
	},
	{
		"maximize",
		function()
			local c = client.focus
			c.maximized = not c.maximized
			c:raise()
		end,
	},
}

menus.clientmenu = awful.menu({
	items = {
		{ "state", clientstate },
		{
			"ontop",
			function()
				local c = client.focus
				c.ontop = not c.ontop
				c:raise()
			end,
		},
		{
			"getinfo",
			function()
				naughty.notify({ text = "Class: " .. (client.focus.class or "None") })
			end,
		},
		{
			"quit",
			function()
				local c = client.focus
				c:kill()
			end,
		},
	},
})

-- setup menu keyboard
awful.menu.menu_keys = {
	up = { "Up", "," },
	down = { "Down", "o" },
	back = { "Left", "a" },
	enter = { "Right", "e" },
	exec = { "Return", "." },
	close = { "Escape", "'" },
}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
menubar.show_categories = false

return menus
