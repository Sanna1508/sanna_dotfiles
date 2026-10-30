local awful = require("awful")
local keyboard = require("awful.keyboard")
local key = require("awful.key")
local spawn = require("awful.spawn")

local menu = require("config.menu")
local wmmenu = menu.wmmenu
local clientmenu = menu.clientmenu

local terminal = "kitty"
local launcher = "rofi -show drun"
local super = "Mod4"

-- apps spawn
keyboard.append_global_keybindings({
	key({ super }, "Return", function()
		spawn(terminal)
	end, { description = "spawn a terminal", group = "basic" }),

	key({ super }, "h", function()
		spawn(launcher)
	end, { description = "spawn a launcher", group = "basic" }),
})

-- menus spawn
keyboard.append_global_keybindings({
	key({ super }, "Escape", function()
		wmmenu:toggle({ coords = { x = 400, y = 320 } })
	end),
	{ description = "toggle wmmenu", group = "menus" },
})
keyboard.append_client_keybindings({
	key({ super }, ",", function()
		clientmenu:toggle({ coords = { x = 400, y = 320 } })
	end),
	{ description = "toggle clientmenu", group = "menus" },
})

keyboard.append_global_keybindings({
	key({ super }, "Tab", function()
		awful.client.focus.byidx(1)
	end, { description = "focus the next client", group = "basic" }),
})

keyboard.append_global_keybindings({
	awful.key({
		modifiers = { super },
		keygroup = "numrow",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only()
			end
		end,
	}),
	awful.key({
		modifiers = { super, "Shift" },
		keygroup = "numrow",
		on_press = function(index)
			local c = client.focus
			if c then
				local tag = c.screen.tags[index]
				if tag then
					c:move_to_tag(tag)
				end
			end
		end,
	}),
})

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({}, 1, function(c)
			c:activate({ context = "mouse_click" })
		end),
		awful.button({ super }, 1, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		awful.button({ super }, 3, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end),
	})
end)
