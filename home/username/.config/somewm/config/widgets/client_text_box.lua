local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local class = {}

local client_name_text_box = wibox.widget({
	markup = "<b>" .. gears.string.xml_escape(c and c.name or "nil") .. "</b>",
	valgin = "center",
	halign = "center",
	ellipsize = "end",
	wrap = "word_char",
	widget = wibox.widget.textbox,
})

function class:set_client_text_box(c)
	client_name_text_box.markup = "<b>" .. gears.string.xml_escape(c and c.name or "nil") .. "</b>"

	return wibox.widget({
		{
			widget = client_name_text_box,
		},
		layout = wibox.layout.flex.vertical,
	})
end

return gears.object({
	class = class,
	-- enable_properties = true,
	-- enable_auto_signals = true,
})
