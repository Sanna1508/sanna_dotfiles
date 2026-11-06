local naughty = require("naughty")
local gears = require("gears")
local input = require("awful.input")
local awful = require("awful")
local ruled = require("ruled")
local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local wallpaper = require("awful.wallpaper")
local wibox = require("wibox")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local keyboard = require("awful.keyboard")
local key = require("awful.key")
local screenshot = require("awful.screenshot")

local terminal = "kitty"
local launcher = "pkill -9 fuzzel || fuzzel"
local super = "Mod4"

-- debug
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)

if awesome.x11_fallback_info then
	gears.timer.delayed_call(function()
		local info = awesome.x11_fallback_info
		local msg = string.format(
			"Your config contains X11-specific code that won't work on Wayland. "
				.. "It was loaded anyway; the code below will not do anything.\n\n"
				.. "File: %s:%d\n"
				.. "Pattern: %s\n"
				.. "Code: %s\n\n"
				.. "Suggestion: %s\n\n"
				.. "Run `somewm --check` on your config for the full list.",
			info.config_path or "unknown",
			info.line_number or 0,
			info.pattern or "unknown",
			info.line_content or "",
			info.suggestion or "See somewm migration guide"
		)
		naughty.notification({
			urgency = "critical",
			title = "Config contains X11 patterns",
			message = msg,
			timeout = 0,
		})
	end)
end

-- env
input.xkb_layout = "us"
input.xkb_variant = "dvorak"
input.send_events_mode = "disabled_on_external_mouse"

-- screen, tags
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.floating,
		awful.layout.suit.max.fullscreen,
		awful.layout.suit.magnifier,
	})
end)

screen.connect_signal("request::desktop_decoration", function(s)
	-- Restore saved tags if this output was previously removed
	local output_name = s.output and s.output.name
	local restore = output_name and awful.permissions.saved_tags[output_name]
	if restore then
		awful.permissions.saved_tags[output_name] = nil
		local client_tags = {}
		for _, td in ipairs(restore) do
			local t = awful.tag.add(td.name, {
				screen = s,
				layout = td.layout,
				master_width_factor = td.master_width_factor,
				master_count = td.master_count,
				gap = td.gap,
				selected = td.selected,
			})
			for _, c in ipairs(td.clients) do
				if c.valid then
					if not client_tags[c] then
						client_tags[c] = {}
					end
					table.insert(client_tags[c], t)
				end
			end
		end
		for c, tags in pairs(client_tags) do
			c:move_to_screen(s)
			c:tags(tags)
		end
	else
		awful.tag({ "alpha", "beta", "gamma", "delta", "omega" }, s, awful.layout.layouts[1])
	end
end)

-- startup
spawn.once("kdeconnectd")
spawn.once("fcitx5 fcitx5")
spawn.once("copyq --start-server")

-- wallpaper
screen.connect_signal("request::wallpaper", function(s)
	beautiful.get().wallpaper = "/home/sandrone/.config/somewm/wallpaper.png"

	if beautiful.wallpaper then
		wallpaper({
			screen = s,
			widget = {
				{
					image = gears.surface.crop_surface({
						surface = gears.surface.load_uncached(beautiful.wallpaper),
						ratio = s.geometry.width / s.geometry.height,
					}),
					upscale = true,
					downscale = true,
					widget = wibox.widget.imagebox,
				},
				valign = "center",
				halign = "center",
				widget = wibox.container.place,
			},
		})
	else
		wallpaper({ screen = s, bg = beautiful.bg_normal or "#222222" })
	end
end)

-- rule
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

-- theme
local theme_file = (os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config") .. "/somewm/theme"
local theme_name = "catppuccin"
do
	local f = io.open(theme_file, "r")
	if f then
		local name = f:read("*l")
		if name and name ~= "" then
			theme_name = name
		end
		f:close()
	end
end

beautiful.init(gears.filesystem.get_themes_dir() .. theme_name .. "/theme.lua")

beautiful.screenshot_frame_color = beautiful.fg_focus

beautiful.notification_width = 300
beautiful.notification_max_width = 100

-- notification
ruled.notification.connect_signal("request::rules", function()
	ruled.notification.append_rule({
		rule = {},
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 5,
		},
	})
end)

naughty.connect_signal("request::display", function(n)
	naughty.layout.box({ notification = n })
end)

-- menu
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
		"maximize",
		function()
			local c = client.focus
			c.maximized = not c.maximized
			-- naughty.notification({
			-- 	title = c.name,
			-- 	message = "maximized is " .. (c.maximized and "true" or "false"),
			-- })
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
			c.focus:raise()
		end,
	},
}

local clientmenu = awful.menu({
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

-- key
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
