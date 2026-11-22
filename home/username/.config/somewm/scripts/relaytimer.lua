local gears = require("gears")

local istiming = false

local object = gears.object

local function addtimerforclientbox()
	local timer = gears.timer({
		timeout = 1,
		auto_start = false,
		single_shot = true,
		callback = function() end,
	})
	return timer
end
object.timer = addtimerforclientbox()

local function update(c)
	if object.timer.started == true then
		object.timer:again()
	else
		object.timer:start()
	end
end
