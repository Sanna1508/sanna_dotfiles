local beautiful = require("beautiful")
local wallpaper = require("awful.wallpaper")
local wibox = require("wibox")
local gears = require("gears")

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
