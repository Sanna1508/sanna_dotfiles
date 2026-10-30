local awful = require("awful")
local keyboard = require("awful.keyboard")
local key = require("awful.key")
local spawn = require("awful.spawn")

local terminal = "kitty"
local launcher = "rofi -show drun"
local super = "Mod4"

keyboard.append_global_keybindings({
	key({ super }, "Return", function()
		spawn(terminal)
	end, { description = "spawn a terminal", group = "basic" }),

	key({ super }, "p", function()
		spawn(launcher)
	end, { description = "spawn a launcher", group = "basic" }),
})

keyboard.append_global_keybindings({
	key({ super }, "Tab", function()
		awful.client.focus.byxid(1)
	end, { description = "focus the next client", group = "basic" }),
})

awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { super },
		keygroup = "numrow",
		description = "only view tag",
		group = "tag",
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
		description = "move focused client to tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
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
