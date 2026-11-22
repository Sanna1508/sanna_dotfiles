local awful = require("awful")
local keyboard = require("awful.keyboard")
local key = require("awful.key")
local env = require("env")

local super = env.super

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

local client_menu = awful.menu({
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

client.connect_signal("request::default_keybindings", function()
	keyboard.append_client_keybindings({
		key({ super }, ",", function()
			client_menu:toggle({ coords = { x = 400, y = 320 } })
		end),
		{ description = "toggle client_menu", group = "menus" },
	})
end)
