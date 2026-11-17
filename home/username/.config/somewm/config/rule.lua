local ruled = require("ruled")
local awful = require("awful")

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
			maximized = true,
		},
	})
	ruled.client.append_rule({
		id = "zen_bitwarden",
		rule = { class = "^zen$" },
		properties = {
			placement = awful.placement.centered,
		},
	})

	-- Obsidian
	ruled.client.append_rule({
		id = "obsidian_main",
		rule_any = { class = { "^md.obsidian.Obsidian$" } },
		except = { class = "^md.obsidian.Obsidian$", name = "^Obsidian$" },
		properties = {
			maximized = true,
		},
	})
	ruled.client.append_rule({
		id = "obsidian_vault_popup",
		rule = { class = "^md.obsidian.Obsidian$", name = "^Obsidian$" },
		properties = {
			maximized = false,
			placement = awful.placement.centered,
		},
	})

	-- keypop
	ruled.client.append_rule({
		id = "keypop",
		rule = { class = "^keypop$" },
		properties = {
			below = true,
			sticky = true,
			focusable = false,
			width = 1432,
			height = 800,
			x = -50,
			y = -10,
			-- maximized = true,
		},
	})
	-- System tool
	ruled.client.append_rule({
		id = "system tool",
		rule_any = { class = { "^nmtui$", "^bluetui$" } },
		properties = {
			tag = "system",
		},
	})
end)
