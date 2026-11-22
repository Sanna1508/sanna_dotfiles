local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local init_box = require("config.wiboxs.rounded_retangle_wibox")

local function addtimerforclientbox(s)
	local timer = gears.timer({
		timeout = 0.75,
		auto_start = false,
		single_shot = true,
		callback = function()
			if s then
				s.clientbox.visible = not s.clientbox.visible
			end
		end,
	})
	return timer
end

local textbox = wibox.widget({
	text = "textbox",
	widget = wibox.widget.textbox,
})

local layout = wibox.widget({
	{
		textbox,
		widget = wibox.container.place,
	},
	layout = wibox.layout.flex.horizontal,
})

local function update(c)
	local s = c.screen
	textbox.text = c.class or "nil"

	if s.clientbox.timer.started == true then
		s.clientbox.timer:again()
	else
		s.clientbox.timer:start()
		s.clientbox.visible = not s.clientbox.visible
	end
end

awful.screen.connect_for_each_screen(function(s)
	s.clientbox = init_box(s, 0.2, 0.4, 0.1, 0.75)
	s.clientbox.widget = layout
	s.clientbox.timer = addtimerforclientbox(s)
end)

client.connect_signal("focus", function(c)
	update(c)
end)
