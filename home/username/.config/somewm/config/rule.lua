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
		except = { maximized = true },
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
		callback = function()
			local t = awful.tag.find_by_name(awful.screen.focused(), "file")
			if not t.selected then
				awful.tag.viewtoggle(t)
			end
		end,
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

	-- copyq
	ruled.client.append_rule({
		id = "yazi_portal",
		rule = { class = "^com.github.hluk.copyq$" },
		properties = {
			floating = true,
			width = 500,
			height = 600,
			placement = awful.placement.centered,
			animation = {
				appear = "scale",
				disappear = "fade",
			},
		},
	})

	-- Zen Browser
	ruled.client.append_rule({
		id = "zen",
		rule = { class = "^zen$" },
		properties = {
			tag = "browser",
			carousel_column_width = 1,
			-- maximized = true,
			ff = 0,
		},
		callback = function(c)
			c.spawn_time = os.time()
			local t = awful.tag.find_by_name(awful.screen.focused(), "browser")
			if not t.selected then
				awful.tag.viewtoggle(t)
			end
			c:connect_signal("property::name", function()
				if
					c.name
					and (c.name:match("^Extension: %(Bitwarden Password Manager%)") or c.name:match("^Page Info —"))
				then
					c.maximized = false
					c.floating = true
					c.width = 600
					c.height = 650
					awful.placement.centered(c)
				end
				c.ff = c.ff + 1
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
			floating = true,
			placement = awful.placement.centered,
		},
		callback = function()
			local t = awful.tag.find_by_name(awful.screen.focused(), "system")
			if not t.selected then
				awful.tag.viewtoggle(t)
			end
		end,
	})
end)
