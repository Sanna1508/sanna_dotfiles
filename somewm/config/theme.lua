local beautiful = require("beautiful")
local gears = require("gears")

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
-- beautiful.notification_max_height = 100

-- animation
beautiful.animation_appear_duration = 0.2
beautiful.animation_disappear_duration = 0.2

beautiful.animation_maximize_duration = 0.3

beautiful.animation_focus_duration = 0.8
beautiful.animation_tag = "none"
