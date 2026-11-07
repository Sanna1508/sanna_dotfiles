local wibox = require("wibox")

return function(widget, margins, valign, halign)
	widget = widget or nil
	margins = margins or 6
	valign = valign or "center"
	halign = halign or "center"
	local return_widget = wibox.widget({
		{
			widget,
			margins = margins,
			widget = wibox.container.margin,
		},
		valign = valign,
		halign = halign,
		widget = wibox.container.place,
	})
	return return_widget
end
