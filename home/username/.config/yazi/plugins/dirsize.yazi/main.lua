-- Shows the real recursive size of directories instead of their 4K `stat` size.
--
-- Yazi only calculates directory sizes when sorting by size, so the status bar
-- (and the "size" linemode) would otherwise show 4096 bytes ("4K") for folders.
--
-- Sizes are calculated lazily, only for directories that are actually rendered
-- (status bar + visible rows), and cached for the session.

local M = {}

local MAX_WORKERS = 3
local FLUSH_INTERVAL = 0.1 -- seconds, batch UI updates like Yazi's own sizer

local cache = {} -- ["file:///path/"] = bytes, or false if it failed
local pending = {} -- ["file:///path/"] = true while queued/running
local queue = {}
local running = 0
local batches = {} -- ["folder url"] = { base = Url, sizes = { [key] = bytes } }
local last_flush = 0

M.pending = pending

local function flush()
	if next(batches) == nil then
		return
	end

	local current, now = batches, ya.time()
	batches, last_flush = {}, now

	for _, batch in pairs(current) do
		ya.emit("update_files", {
			op = fs.op("size", { url = batch.base, sizes = batch.sizes }),
		})
	end
	ui.render()
end

local function stage(base, key, size)
	local id = tostring(base)
	local batch = batches[id]
	if not batch then
		batch = { base = base, sizes = {} }
		batches[id] = batch
	end
	batch.sizes[key] = size

	if ya.time() - last_flush >= FLUSH_INTERVAL then
		flush()
	end
end

local function worker()
	while #queue > 0 do
		local job = table.remove(queue, 1)
		local total, ok = 0, false

		local it = fs.calc_size(job.url)
		if it then
			ok = true
			while true do
				local n = it:recv()
				if not n then
					break
				end
				total = total + n
			end
		end

		-- Remember failures too, so we don't retry on every render
		cache[job.id] = ok and total or false
		if ok then
			stage(job.base, job.key, total)
		end
		pending[job.id] = nil

		-- Let the components fall back to the raw `stat` size
		if not ok then
			ui.render()
		end
	end

	running = running - 1
	if running == 0 then
		flush()
	end
end

local function pump()
	while running < MAX_WORKERS and #queue > 0 do
		running = running + 1
		ya.async(worker)
	end
end

local function enqueue(f, priority)
	local id = tostring(f.url)
	if pending[id] or cache[id] ~= nil then
		return
	end

	pending[id] = true
	local job = {
		id = id,
		url = f.url,
		key = f.url.key,
		base = f.url.trail,
	}

	if priority then
		table.insert(queue, 1, job)
	else
		queue[#queue + 1] = job
	end
end

-- Returns a directory's total size, starting a background calculation if
-- needed. Also used by the patched `Status` and `Linemode` components below.
function M:size_of(f)
	if not f then
		return nil
	end

	local size = f:size()
	if size then
		return size
	elseif not f.cha.is_dir then
		return f.cha.len
	end

	local id = tostring(f.url)
	local hit = cache[id]
	if hit ~= nil then
		return hit or nil
	end

	enqueue(f, true)
	pump()
	return nil
end

function M:setup()
	local function prime(f)
		if f and f.cha.is_dir and not f:size() then
			enqueue(f, true)
			pump()
		end
	end

	-- A folder finished loading: size its cursor entry right away
	ps.sub("load", function(ev)
		if ev.tab ~= cx.active.id then
			return
		end
		if ev.url ~= cx.active.current.cwd then
			return
		end

		local done, err = ev.stage()
		if not done or err then
			return
		end

		prime(cx.active.current.hovered)
	end)

	ps.sub("hover", function()
		prime(cx.active.current.hovered)
	end)

	-- Status bar: show the real size of the hovered folder
	function Status:length()
		local h = self._current.hovered
		local style = self:style()

		local text = "0B"
		if h then
			local size = M:size_of(h)
			if size then
				text = ya.readable_size(size)
			elseif h.cha.is_dir and pending[tostring(h.url)] then
				text = "…"
			else
				text = ya.readable_size(h.cha.len)
			end
		end

		return ui.Line {
			ui.Span(" " .. text .. " "):style(style.alt),
			ui.Span(th.status.sep_left.close):fg(style.alt:bg()),
		}
	end

	-- "size" linemode: show the real size of every rendered folder
	function Linemode:size()
		local f = self._file
		local size = M:size_of(f)

		if size then
			return ya.readable_size(size)
		elseif f.cha.is_dir then
			local folder = cx.active:history(f.url)
			return folder and tostring(#folder.files) or ""
		end
		return ""
	end
end

return M
