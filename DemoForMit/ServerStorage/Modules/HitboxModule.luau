local RS = game:GetService('RunService')

local HitboxModule = {}

HitboxModule.__index = HitboxModule

function HitboxModule.New()
	local hitbox = setmetatable({}, HitboxModule)
	hitbox.cframe = CFrame.new(0,5,0)
	hitbox.offset = CFrame.new(0,0,0)
	hitbox.size = Vector3.new(5, 5, 5)
	hitbox.connection = nil
	hitbox.hit = {}
	hitbox.box = nil
	hitbox.active = true
	hitbox.onTouch = function(hit)
		--print(hit.Parent.Name)
	end
	
	return hitbox
end

function HitboxModule:Draw()
	if not self.box then
		self.box = Instance.new('BoxHandleAdornment')
		self.box.Size = self.size
		self.box.CFrame = self.cframe * self.offset
		self.box.Color3 = Color3.new(1, 0.0666667, 0.0823529)
		self.box.Adornee = workspace.Terrain
		self.box.Parent = workspace.Terrain
		self.box.Transparency = 0.5
	else
		self.box.Size = self.size
		self.box.CFrame = self.cframe * self.offset
	end
end

function HitboxModule:Start()
	self.connection = RS.Heartbeat:Connect(function(dt)
		local hitboxes = workspace:GetPartBoundsInBox(self.cframe*self.offset, self.size)

		for i, hitbox in pairs(hitboxes) do
			if not table.find(self.hit, hitbox.Parent) and self.active then
				table.insert(self.hit, hitbox.Parent)
				self.onTouch(hitbox)
			end
		end
	end)
end

function HitboxModule:Stop()
	self.active = false
	if self.connection then
		self.connection:Disconnect()
	end
end

function HitboxModule:Destroy()
	self:Stop()
	if self.box then self.box:Destroy() end
	self.hit = {}
	setmetatable(self, nil)
end

return HitboxModule
