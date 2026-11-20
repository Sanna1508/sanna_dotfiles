local awful = require("awful")
local naughty = require("naughty")
local setmetatable = setmetatable
local ipairs = ipairs
local gmath = require("gears.math")
local gtable = require("gears.table")
local gdebug = require("gears.debug")
local gobject = require("gears.object")
local gears = require("gears")

-- a workspace is a object that have tags. just show them to screen
local class = {}

local default_tags_name = {}

function class:get_tags()
	return self.tags
end

function class:find_tag_by_name(tag_name)
	for _, t in ipairs(self.tags) do
		if t.name == tag_name then
			return t
		end
	end
	return nil
end

-- add tag into workspace.tags
function class:add_tag(new_tag)
	if self.tags then
		if new_tag ~= self:find_tag_by_name(new_tag.name) then
			table.insert(self.tags, new_tag)
		end
	else
		rawset(self, "tags", { new_tag })
	end
end

-- set workspace's screen

function class:set_screen(s)
	s = s or awful.screen.focused() -- default screen is focused screen
	if self.screen then
		self.screen = s
	else
		rawset(self, "screen", s)
	end
end

function class:init_workspace(s, new_tags_name)
	self:set_screen(s)
	self:add_tag(awful.tag.find_by_name(s, new_tags_name))
	return self
end

function class:view_workspace()
	if self.tags then
		awful.tag.viewmore(self.tags, self.screen)
	end
end

local workspace = gears.object({
	class = class,
	-- enable_properties = true,
	-- enable_auto_signals = true,
})

return workspace
