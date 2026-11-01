local ui = game.Players.LocalPlayer.PlayerGui:WaitForChild('Cooldowns')
local queue = ui:WaitForChild('Queue')
local ts = game:GetService('TweenService')

local size = 0

local function push()
	for i, cd in pairs(queue:GetChildren()) do
		cd.Position += UDim2.new(0, 0, -0.1, 0)
		
		if cd.Position.Y.Scale < 0 then
			cd.Position += UDim2.new(3, 0, 0, 0)
		end
	end
end

local function remove(index)
	for i, cd in pairs(queue:GetChildren()) do
		if tonumber(cd.Name) < index then
			cd.Position += UDim2.new(0, 0, 0.1, 0)
		end
	end
end

ui.Queue.ChildAdded:Connect(function(child)
	size+=1
	child.Name = size
	local index = size
	push(child)
	
	--start prog bar
	local durr = child.Progress.Duration.Value
	local tsInfo = TweenInfo.new(durr)
	
	ts:Create(child.Progress, tsInfo, {Size = UDim2.new(1,0,0.35,0)}):Play()	
	task.wait(durr)
	child:Destroy()
	size-=1
	remove(index)
	
end)