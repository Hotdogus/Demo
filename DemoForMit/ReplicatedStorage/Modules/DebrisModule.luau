local DebrisModule = {}
DebrisModule.__index = DebrisModule

function DebrisModule.new()
	local self = setmetatable({}, DebrisModule)
	self.items = {}
	return self
end

function DebrisModule:Add(item, lifetime)
	table.insert(self.items, {object = item, expireTime = tick() + lifetime})
end

function DebrisModule:Cleanup()
	local currentTime = tick()
	for i = #self.items, 1, -1 do
		if self.items[i].expireTime <= currentTime then
			if self.items[i].object and self.items[i].object.Parent then
				self.items[i].object:Destroy()
			end
			table.remove(self.items, i)
		end
	end
end

return DebrisModule
