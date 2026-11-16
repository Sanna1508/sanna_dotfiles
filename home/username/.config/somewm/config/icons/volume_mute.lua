local cairo = require("lgi").cairo

return {
	width = 800,
	height = 800,
	render = function(cr)
		local temp_surface
		local old_cr
		local line_width = 1
		local pattern
		local matrix

		cr:set_operator("over")
		pattern = cairo.pattern_create_rgba(60, 60, 60, 1)
		cr:set_source(pattern)
		cr:new_path()
		cr:move_to(400, 50)
		cr:line_to(300, 50)
		cr:line_to(100, 250)
		cr:line_to(0, 250)
		cr:line_to(0, 550)
		cr:line_to(100, 550)
		cr:line_to(300, 750)
		cr:line_to(400, 750)
		cr:close_path()
		cr:move_to(400, 50)
		cr:set_tolerance(0.1)
		cr:set_antialias("default")
		cr:set_fill_rule("winding")
		cr:fill_preserve()
		----------------------
		cr:set_operator("over")
		pattern = cairo.pattern_create_rgba(0, 0, 0, 1)
		cr:set_source(pattern)
		cr:new_path()
		cr:move_to(464.644531, 310.355469)
		cr:line_to(554.289062, 400)
		cr:line_to(464.644531, 489.644531)
		cr:line_to(535.355469, 560.355469)
		cr:line_to(625, 470.710938)
		cr:line_to(714.644531, 560.355469)
		cr:line_to(785.355469, 489.644531)
		cr:line_to(695.710938, 400)
		cr:line_to(785.355469, 310.355469)
		cr:line_to(714.644531, 239.644531)
		cr:line_to(625, 329.289062)
		cr:line_to(535.355469, 239.644531)
		cr:close_path()
		cr:move_to(464.644531, 310.355469)
		cr:set_tolerance(0.1)
		cr:set_antialias("default")
		cr:set_fill_rule("winding")
		cr:fill_preserve()
		----------------------
	end,
}
