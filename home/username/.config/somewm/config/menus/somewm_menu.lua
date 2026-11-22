local awful = require("awful")
local keyboard = require("awful.keyboard")
local key = require("awful.key")
local spawn = require("awful.spawn")
local spawn = require("awful.spawn")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local naughty = require("naughty")

local super = "Mod4"

local terminal = "kitty"
local filemanager = "yazi"
local editor = terminal
	.. " --class "
	.. filemanager
	.. "_ricing"
	.. " "
	.. filemanager
	.. " "
	.. os.getenv("HOME")
	.. "/.config/somewm/"

local wmmenu = awful.menu({
	items = {
		{
			"hotkeys",
			function()
				hotkeys_popup.show_help(nil, awful.screen.focused())
			end,
		},
		-- {
		-- 	"test",
		-- 	function()
		-- 		awful.spawn("notify-send '" .. ws_a.tags[1] .. "'")
		-- 	end,
		-- },
		{
			"edit config",
			function()
				local t = awful.tag.find_by_name(awful.screen.focused(), "rice")
				if t and #t:clients() < 1 then
					spawn(editor)
					naughty.notification({
						message = editor,
					})
				end
				if t and not t.selected then
					awful.tag.viewtoggle(t)
				end
				local c = t:clients()[1]
				if c then
					c:raise()
					awful.client.focus.byidx(0, c)
					-- naughty.notification({
					-- 	message = c.class,
					-- })
				end
			end,
		},
		{ "restart", awesome.restart },
		{
			"quit",
			function()
				awesome.quit()
			end,
		},
	},
})

keyboard.append_global_keybindings({
	key({ super }, "Escape", function()
		wmmenu:toggle({ coords = { x = 400, y = 320 } })
	end),
})
