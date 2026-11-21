local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local function addtimerforclientbox(s)
	local timer = gears.timer({
		timeout = 2,
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

local function init_box(s, boxwidth_percent, x, boxheight_percent, y)
	boxwidth_percent = (boxwidth_percent > 0 and boxwidth_percent <= 1 and boxwidth_percent) or 0.1
	boxheight_percent = (boxheight_percent > 0 and boxheight_percent <= 1 and boxheight_percent) or 0.1
	x = (x > 0 and x <= 1 and x) or 0
	y = (y > 0 and y <= 1 and y) or 0
	-- init wibox
	local mypanel = wibox({
		visible = false,
		ontop = false,

		screen = s,
		x = s.geometry.width * x,
		y = s.geometry.height * y,
		width = s.geometry.width * boxwidth_percent,
		height = s.geometry.height * boxheight_percent,

		shape = function(cr, width, height)
			return gears.shape.rounded_rect(cr, width, height, 14)
		end,

		opacity = 0.5,
		bg = beautiful.bg_normal or "#222222",
		border_width = beautiful.border_width or 2,
		border_color = beautiful.border_color_active or "#535d6c",
	})
	return mypanel
end

local textbox = wibox.widget({
	text = "textbox",
	widget = wibox.widget.textbox,
})

local layout = wibox.widget({
	{
		widget = textbox,
		-- bg = beautiful.fg_normal,
		-- fg = beautiful.bg_normal,
		-- widget = wibox.container.background,
	},
	layout = wibox.layout.flex.horizontal,
})

local function update(c)
	local s = c.screen
	textbox.text = c.name or "test"

	if s.clientbox.timer.started == true then
		s.clientbox.timer:again()
	else
		s.clientbox.timer:start()
		s.clientbox.visible = not s.clientbox.visible
	end

	-- timer:connect_signal("stop", stoping(s))
end

awful.screen.connect_for_each_screen(function(s)
	s.clientbox = init_box(s, 0.2, 0.4, 0.15, 0.7)
	s.clientbox.widget = layout
	s.clientbox.timer = addtimerforclientbox(s)
end)

client.connect_signal("focus", function(c)
	update(c)
end)
