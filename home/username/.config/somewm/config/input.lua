local input = require("awful.input")
local awful = require("awful")
local menubar = require("menubar")
local env = require("env")

local terminal = env.terminal

input.xkb_layout = "us"
input.xkb_variant = "dvorak"
input.send_events_mode = "disabled_on_external_mouse"
input.tap_to_click = 1
input.accel_profile = "flat"
input.accel_speed = 0.3
input.disable_while_typing = 1

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
