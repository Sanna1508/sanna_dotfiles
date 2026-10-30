local awful = require("awful")

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
		awful.tag({ "alpha", "beta", "omega", "theta", "zeta" }, s, awful.layout.layouts[1])
	end
end)

tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.tile,
		awful.layout.suit.floating,
		awful.layout.suit.magnifier,
	})
end)
