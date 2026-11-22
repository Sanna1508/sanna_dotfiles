local awful = require("awful")
local keyboard = require("awful.keyboard")
local key = require("awful.key")
local spawn = require("awful.spawn")
local screenshot = require("awful.screenshot")
local naughty = require("naughty")

local env = require("env")

local terminal = env.terminal
local launcher = env.launcher
local super = env.super

-- apps spawn
keyboard.append_global_keybindings({
	key({ super }, "Return", function()
		spawn(terminal)
	end, { description = "spawn a terminal", group = "basic" }),

	key({ super }, "h", function()
		spawn.with_shell(launcher)
	end, { description = "spawn a launcher", group = "basic" }),
	key({ super, "Shift" }, "r", awesome.restart, { description = "spawn a launcher", group = "basic" }),
})

-- client behaviors
keyboard.append_global_keybindings({
	key({ super }, "Tab", function()
		awful.client.focus.byidx(1)
	end, { description = "focus the next client", group = "basic" }),
	key({ super }, "Space", function()
		awful.layout.suit.carousel.cycle_column_width()
	end, { description = "toggle next layout", group = "basic" }),
})

-- layout behaviors
keyboard.append_client_keybindings({
	key({ super }, "Left", function()
		-- awful.layout.suit.carousel.move_column(-1)
		awful.client.focus.bydirection("left")
		-- awful.layout.suit.carousel.adjust_column_width(-0.05)
	end),
	key({ super }, "Right", function()
		-- awful.layout.suit.carousel.move_column(1)
		awful.client.focus.bydirection("right")
		-- awful.layout.suit.carousel.adjust_column_width(0.05)
	end),
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
			if c.focusable == true then
				c:activate({ context = "mouse_click" })
			end
		end),
		awful.button({ super }, 1, function(c)
			if c.focusable == true then
				c:activate({ context = "mouse_click", action = "mouse_move" })
			end
		end),
		awful.button({ super }, 3, function(c)
			if c.focusable == true then
				c:activate({ context = "mouse_click", action = "mouse_resize" })
			end
		end),

		-- test carousel
		awful.button({ super }, 4, function()
			awful.client.focus.bydirection("left")
		end),
		awful.button({ super }, 5, function()
			awful.client.focus.bydirection("right")
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
		spawn.with_shell(os.getenv("HOME") .. "/.local/bin/ffmpeg_recorder.sh")
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
			spawn("brightnessctl set 10%+")
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
			spawn("brightnessctl set 10%-")
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
