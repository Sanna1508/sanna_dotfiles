local awful = require("awful")

-- a workspace is a object that have tags. just show them to screen
local workspace = {}

workspace.tags = {}
workspace.main_layout = {}
workspace.master_clients = {}

function workspace.list_tags()
	return workspace.tags
end

function workspace.find_tag_by_name(tag_name)
	for _, t in workspace.tags do
		if t.name == tag_name then
			return t
		end
	end
	return nil
end

function workspace.set_tags(tags)
	local cur_length = #workspace.tags
	for _, t in tags do
		if workspace.find_tag_by_name(t.name) ~= nil then
			workspace.tags[cur_length + 1] = t
		end
	end
end

function workspace.view_workspace_in(s)
	awful.tag.viewmore(workspace.tags, s)
end

return workspace
