local wibox = require("wibox")
local gears = require("gears")
local string = require("gears.string")

local class = {}

local function get_tags_name(c)
	local tags = c:tags()
	local tags_name = ""
	if c then
		for _, t in ipairs(tags) do
			tags_name = tags_name .. t.name
			if t ~= tags[#tags] then
				tags_name = tags_name .. "+"
			end
		end
	end
	return tags_name
end

local client_name_class_text_box = wibox.widget({
	markup = "<b>" .. string.xml_escape("nil") .. "</b>",
	valgin = "center",
	halign = "center",
	ellipsize = "end",
	wrap = "word_char",
	widget = wibox.widget.textbox,
})

local client_tags_text_box = wibox.widget({
	markup = "<b>" .. string.xml_escape("nil") .. "</b>",
	valgin = "center",
	halign = "center",
	ellipsize = "none",
	wrap = "word_char",
	widget = wibox.widget.textbox,
})

local client_state_text_box = wibox.widget({
	markup = "<b>" .. string.xml_escape("nil") .. "</b>",
	valgin = "center",
	halign = "center",
	ellipsize = "none",
	wrap = "word_char",
	widget = wibox.widget.textbox,
})

function class:set_client_text_box(c)
	client_name_class_text_box.markup = "<i>"
		.. string.xml_escape(c and c.class or "nil")
		.. "</i>: "
		.. "<b>"
		.. string.xml_escape(c and c.name or "nil")
		.. "</b>"

	client_tags_text_box.markup = "<b>" .. string.xml_escape(c and get_tags_name(c) or "nil or no_tag") .. "</b>"

	client_state_text_box.markup = "<i>"
		.. string.xml_escape((c and c.ontop) and "ontop/" or "")
		.. string.xml_escape((c and c.sticky) and "sticky/" or "")
		.. string.xml_escape(((c and c.above) and "above/") or ((c and c.below) and "below/") or "")
		.. string.xml_escape((c and c.maximized) and "maximized/" or "")
		.. string.xml_escape((c and c.floating) and "floating/" or "")
		.. "</i>"

	return wibox.widget({
		{
			{
				client_name_class_text_box,
				left = 8,
				right = 8,
				widget = wibox.container.margin,
			},
			{
				client_tags_text_box,
				left = 8,
				right = 8,
				widget = wibox.container.margin,
			},
			{
				client_state_text_box,
				left = 8,
				right = 8,
				widget = wibox.container.margin,
			},
			layout = wibox.layout.flex.vertical,
		},

		widget = wibox.container.place,
	})
end

return gears.object({
	class = class,
	-- enable_properties = true,
	-- enable_auto_signals = true,
})
