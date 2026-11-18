local ruled = require("ruled")
local awful = require("awful")
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi
local beautiful = require("beautiful")

awesome.set_idle_timeout("display-off", 1800, function()
	awesome.dpms_off()
end)

ruled.client.connect_signal("request::rules", function()
	-- All clients match this rule.
	ruled.client.append_rule({
		id = "global",
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	})
	ruled.client.append_rule({
		id = "rounded",
		rule = {},
		properties = {
			shape = function(cr, w, h)
				gears.shape.rounded_rect(cr, w, h, dpi(beautiful.dpi_rounded_corner))
			end,
		},
	})

	-- kitty's animation
	ruled.client.append_rule({
		id = "kitty",
		rule = { class = "^kitty$" },
		properties = {
			animation = {
				appear = "scale",
				disappear = "fade",
			},
		},
	})

	-- Yazi
	ruled.client.append_rule({
		id = "yazi",
		rule = { class = "^yazi$" },
		properties = {
			tag = "file",
			animation = {
				appear = "scale",
				disappear = "fade",
			},
		},
	})

	ruled.client.append_rule({
		id = "yazi_portal",
		rule = { class = "^portal$" },
		properties = {
			floating = true,
			placement = awful.placement.centered,
			animation = {
				appear = "scale",
				disappear = "fade",
			},
		},
	})
	-- Ricing
	ruled.client.append_rule({
		id = "yazi",
		rule = { class = "^yazi_ricing$" },
		properties = {
			tag = "rice",
			animation = {
				appear = "scale",
				disappear = "fade",
			},
		},
	})

	-- Zen Browser
	ruled.client.append_rule({
		id = "zen_main",
		rule = { class = "^zen$", name = "^Zen Browser$" },
		properties = {
			tag = "browser",
			carousel_column_width = 1,
		},
		callback = function(c)
			local t = awful.tag.find_by_name(awful.screen.focused(), "browser")
			if not t.selected then
				awful.tag.viewtoggle(t)
			end
			c:connect_signal("property::name", function()
				if c.name and c.name:match("^Extension: %(Bitwarden Password Manager%)") then
					c.floating = true
					c.width = 500
					c.height = 600
					awful.placement.centered(c)
				else
					c.maximized = true
				end
			end)
		end,
	})

	-- Obsidian
	ruled.client.append_rule({
		id = "obsidian_main",
		rule_any = { class = { "^md.obsidian.Obsidian$" } },
		except = { class = "^md.obsidian.Obsidian$", name = "^Obsidian$" },
		properties = {
			tag = "note",
			maximized = true,
		},
		callback = function()
			local t = awful.tag.find_by_name(awful.screen.focused(), "note")
			if not t.selected then
				awful.tag.viewtoggle(t)
			end
		end,
	})
	ruled.client.append_rule({
		id = "obsidian_vault_popup",
		rule = { class = "^md.obsidian.Obsidian$", name = "^Obsidian$" },
		properties = {
			tag = "note",
			maximized = false,
			placement = awful.placement.centered,
		},
	})

	--  showmethekey
	ruled.client.append_rule({
		id = "showmethekey",
		rule = { class = "^one.alynx.showmethekey$", name = "^Floating%sWindow" },
		properties = {
			ontop = true,
			sticky = true,
			focusable = false,
			placement = awful.placement.bottom_right,
			border_width = 0,
		},
	})
	-- System tool
	ruled.client.append_rule({
		id = "system tool",
		rule_any = { class = { "^nmtui$", "^bluetui$", "^btop$" } },
		properties = {
			tag = "system",
		},
		callback = function()
			local t = awful.tag.find_by_name(awful.screen.focused(), "system")
			if not t.selected then
				awful.tag.viewtoggle(t)
			end
		end,
	})
end)
