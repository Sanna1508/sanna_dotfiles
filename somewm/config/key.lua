local awful = require("awful")
local keyboard = require("awful.keyboard")
local key = require("awful.key")
local spawn = require("awful.spawn")
local screenshot = require("awful.screenshot")
local naughty = require("naughty")

local menu = require("config.menu")
local wmmenu = menu.wmmenu
local clientmenu = menu.clientmenu

local terminal = "kitty"
local launcher = "pkill -9 fuzzel || fuzzel"
local super = "Mod4"

-- apps spawn
keyboard.append_global_keybindings({
	key({ super }, "Return", function()
		spawn(terminal)
	end, { description = "spawn a terminal", group = "basic" }),

	key({ super }, "h", function()
		spawn.with_shell(launcher)
	end, { description = "spawn a launcher", group = "basic" }),
})

-- menus spawn
keyboard.append_global_keybindings({
	key({ super }, "Escape", function()
		wmmenu:toggle({ coords = { x = 400, y = 320 } })
	end),
	{ description = "toggle wmmenu", group = "menus" },
	key({ super }, "f", function()
		if awful.screen.focused().box then
			awful.screen.focused().box.visible = not awful.screen.focused().box.visible
		end
	end),
	{ description = "toggle box", group = "wibox" },
})

client.connect_signal("request::default_keybindings", function()
	keyboard.append_client_keybindings({
		key({ super }, ",", function()
			clientmenu:toggle({ coords = { x = 400, y = 320 } })
		end),
		{ description = "toggle clientmenu", group = "menus" },
	})
end)

-- client behaviors
keyboard.append_global_keybindings({
	key({ super }, "Tab", function()
		awful.client.focus.byidx(1)
	end, { description = "focus the next client", group = "basic" }),
	key({ super }, "Space", function()
		awful.layout.inc(1)
		spawn("notify-send '" .. awful.layout.getname() .. "'")
	end, { description = "toggle next layout", group = "basic" }),
})

-- tag behaviors
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

-- mouse
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

keyboard.append_global_keybindings({
	-- Screenshot --
	key({}, "Print", function()
		local ss = screenshot({
			interactive = true,
			directory = "/tmp",
		})
		ss:connect_signal("file::saved", function(_, file_path)
			spawn.with_shell("wl-copy < " .. file_path .. " && rm " .. file_path)
			naughty.notification({
				title = "Screenshot",
				message = "saved screenshot",
			})
		end)

		ss:refresh()
	end),
	-- Recording --
	key({ super }, "Print", function()
		spawn.with_shell("ffmpeg_recorder.sh")
	end),
})

-- audio (requires wpctl from wireplumber)
keyboard.append_global_keybindings({
	key({
		modifiers = {},
		key = "XF86AudioRaiseVolume",
		on_press = function()
			spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
		end,
		description = "raise volume",
		group = "audio",
	}),
	key({
		modifiers = {},
		key = "XF86AudioLowerVolume",
		on_press = function()
			spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
		end,
		description = "lower volume",
		group = "audio",
	}),
	key({
		modifiers = {},
		key = "XF86AudioMute",
		on_press = function()
			spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
		end,
		description = "mute output",
		group = "audio",
	}),
})

-- brightness (requires brightnessctl)
keyboard.append_global_keybindings({
	key({
		modifiers = {},
		key = "XF86MonBrightnessUp",
		on_press = function()
			spawn("brightnessctl set 5%+")
		end,
		description = "raise brightness",
		group = "brightness",
	}),
	key({
		modifiers = { super },
		key = "XF86MonBrightnessUp",
		on_press = function()
			spawn("brightnessctl set 40%")
		end,
		description = "set brightness 40%",
		group = "brightness",
	}),
	key({
		modifiers = {},
		key = "XF86MonBrightnessDown",
		on_press = function()
			spawn("brightnessctl set 5%-")
		end,
		description = "lower brightness",
		group = "brightness",
	}),
	key({
		modifiers = { super },
		key = "XF86MonBrightnessDown",
		on_press = function()
			spawn("brightnessctl set 0%")
		end,
		description = "turnoff brightness",
		group = "brightness",
	}),
})
