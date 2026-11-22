local awful = require("awful")
local spawn = require("awful.spawn")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local naughty = require("naughty")

local terminal = "kitty"
local filemanager = "yazi"
local editor = terminal
	.. " --class "
	.. filemanager
	.. "_ricing"
	.. " "
	.. filemanager
	.. " "
	.. os.getenv("HOME")
	.. "/.config/somewm/"

local menus = {}

-- local workspace = require("config.workspace")
-- local ws_a = workspace:init_workspace(awful.screen.focused(), "rice")

local clientstate = {
	{
		"maximize",
		function()
			local c = client.focus
			c.maximized = not c.maximized
			c:raise()
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
		"fullscreen",
		function()
			local c = client.focus
			c.fullscreen = not c.fullscreen
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
			"quit",
			function()
				local c = client.focus
				c:kill()
			end,
		},
	},
})

local layouts = {
	awful.layout.suit.carousel,
	awful.layout.suit.tile,
	awful.layout.suit.max,
	awful.layout.suit.floating,
}
local layoutmenu = {}
for i = 1, #layouts do
	layoutmenu[i] = {
		awful.layout.getname(layouts[i]),
		function()
			awful.layout.set(layouts[i])
		end,
	}
end

menus.layoutmenu = awful.menu({
	items = layoutmenu,
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
