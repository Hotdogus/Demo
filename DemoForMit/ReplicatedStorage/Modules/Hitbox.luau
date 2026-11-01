local rs = game:GetService("RunService")

local HB = {}

local hitboxColor = Color3.fromRGB(181, 10, 0)
local hitboxTransparency = .5

HB.__index = HB

function HB.new()
	local newHitbox = setmetatable({},HB)
	newHitbox.Size = Vector3.new(10,10,10)
	newHitbox.CFrame = CFrame.new(0,5,0)
	newHitbox.Offset = CFrame.new(0,0,0)
	newHitbox.Humanoids = {}
	newHitbox.Detect = false
	
	newHitbox.Visualizer = false
	
	newHitbox.onTouch = function(humanoid)
		print("Something Touched The Hitbox")
		print("IsHumanoid: ")
	end
	
	newHitbox.Box = nil
	newHitbox.Connection = nil
	
	return newHitbox
end

local getCframe = 
	{
		["Instance"] = function(point)
			return point.CFrame
		end,

		["CFrame"] = function(point)
			return point
		end,
	}


function HB:_Visualize()
	
	if not self.Visualizer then return end
	
	local cframeType = typeof(self.CFrame)
	local realCFrame = getCframe[cframeType](self.CFrame)
	
	if not self.Box then
		self.Box = Instance.new("BoxHandleAdornment")
		self.Box.CFrame = realCFrame * self.Offset
		self.Box.Adornee = workspace.Terrain
		self.Box.Color3 = hitboxColor
		self.Box.Transparency = hitboxTransparency
		self.Box.Size = self.Size
		self.Box.Parent = workspace.Terrain
	else
		self.Box.CFrame = realCFrame * self.Offset
		self.Box.Size = self.Size
	end
	
end

function HB:_Cast()
	local cframeType = typeof(self.CFrame)
	local realCFrame = getCframe[cframeType](self.CFrame)
	
	local touchingParts = workspace:GetPartBoundsInBox(realCFrame * self.Offset, self.Size)
	for i,v in pairs(touchingParts) do
		local humanoid = v.Parent:FindFirstChild("Humanoid")
		
		if humanoid then
			if not table.find(self.Humanoids, humanoid) then
				table.insert(self.Humanoids,humanoid)
				self.onTouch(humanoid)
			end
		end
	end
end

function HB:_Clear()
	
	if self.Connection then
		self.Connection:Disconnect()
		self.Connection = nil
	end
	
	if self.Box then
		self.Box:Destroy()
		self.Box = nil
	end
	
end

function HB:Start()
	
	task.spawn(function()
		self.Connection = rs.Heartbeat:Connect(function()
			self:_Visualize()
			self:_Cast()
		end)
	end)

end

function HB:Stop()
	self:_Clear()
end

function HB:Destroy()
	self.Humanoids = {}
	self:_Clear()
	setmetatable(self,nil)
end

return HB