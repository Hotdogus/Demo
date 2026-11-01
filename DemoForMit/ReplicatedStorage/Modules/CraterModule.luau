local module = {}

local TS = game:GetService("TweenService")
local Tween = require(game:GetService("ServerStorage").Modules.LocalTween)
local Debris = game:GetService("Debris")

local PartCacheModule = require(script.Parent.PartCache)

------Settings------
local AccurateRepresentation = true -- will include floor color,material and transparency
local FlyingDebrisCollision = true
--------------------

-----RandomDebris-----
local Colors = {
	Color3.fromRGB(91, 91, 91),
}
local Materials = {
	Enum.Material.Plastic,
}

local RunService = game:GetService'RunService'
local rad = math.rad
local clock = os.clock
local noise = math.noise
local random = math.random
local Heartbeat = RunService.Heartbeat
local xseed = random(10000, 100000)
local yseed = random(10000, 100000)
local zseed = random(10000, 100000)
local x = noise(xseed, clock() % 1000 * 0.5) * 360
local y = noise(yseed, clock() % 1000 * 0.5) * 360
local z = noise(zseed, clock() % 1000 * 0.5) * 360

local function spinPart(part)
	while part do	
		part.CFrame = CFrame.new(part.Position) * CFrame.Angles(rad(x), rad(y), rad(z))
		Heartbeat:Wait()
	end
end
----------------------

function module.Create(radius,Position, rockSize , FlyingDebrisSize, DespawnTime, FlyingRockDespawnTime , AmountFlyingDebris)
	local newrocksize = math.random(rockSize[1],rockSize[2])
	
	local ModelCircle = Instance.new("Model",workspace.Ignore)
	ModelCircle.Name = "Debris"
	Debris:AddItem(ModelCircle,10)
	
	local Y = Position.Y

	local Material
	local Transparency 
	local Color

	local IgnoreList = {}

	for _,object in pairs(workspace:GetDescendants()) do
		if object.Name == "Debree" or object:FindFirstChildWhichIsA("Humanoid") then
			table.insert(IgnoreList,object)
		end
	end

	local RPParams = RaycastParams.new()
	RPParams.FilterDescendantsInstances = IgnoreList
	RPParams.FilterType = Enum.RaycastFilterType.Blacklist

	local ray = workspace:Raycast(Position + Vector3.new(0,0.1,0),Vector3.new(0,-999,0),RPParams)

	if ray then
		Y = ray.Position.Y
		Material = ray.Material
		Transparency = ray.Instance.Transparency
		Color = ray.Instance.Color
	end

	local parts = {}

	for i = 0,radius * 8,newrocksize do
		local Rock = PartCacheModule.new(script.Parent.Parent.Assets.VFX.RockModuleRock,1)
		local DropletClone = PartCacheModule.GetPart(Rock)
		DropletClone.Parent = ModelCircle
		table.insert(parts,DropletClone)
		
		Rock:ReturnPart(DropletClone)
	end

	local function getXAndZPositions(angle)
		local x = math.cos(angle) * radius
		local z = math.sin(angle) * radius
		return x, z
	end
	
	for i, part in pairs(parts) do
		part.Anchored = true
		part.Name = "Debree"
		part.Size = Vector3.new(0,0,0)
		local angle = (i*newrocksize) * (360 / #parts)
		local x,z = getXAndZPositions(angle)
		table.insert(IgnoreList,part)
		RPParams.FilterDescendantsInstances = IgnoreList

		part.CFrame = CFrame.new(Position) * CFrame.new(x, 0, z)
		part.Position = Vector3.new(part.Position.X,Y,part.Position.Z)
		part.CFrame *= CFrame.Angles(math.rad(math.random(-90,90)),math.rad(math.random(-90,90)),math.rad(math.random(-90,90)))
						
		if AccurateRepresentation == true then
			local raynew = workspace:Raycast(part.Position + Vector3.new(0,0.1,0),Vector3.new(0,-999,0),RPParams)

			if raynew then
				part.Material = raynew.Material
				part.Transparency = raynew.Instance.Transparency
				part.Color = raynew.Instance.Color
			else
				--part.Material = Material
				--part.Transparency = Transparency
				--part.Color = Color
			end
		else
			part.Material = Materials[math.random(1,#Materials)]
			part.Color = Colors[math.random(1,#Colors)]
		end
				
		local newrocksize2 = math.random(rockSize[1],rockSize[2])

		part.Parent = workspace
		TS:Create(part,TweenInfo.new(0.2),{Size = Vector3.new(newrocksize2,newrocksize2,newrocksize2)}):Play()
		
		local DespawnTime1 = math.random(DespawnTime[1],DespawnTime[2])
		local RockDespawnTimeTween = math.random(.5,1.3)
		
		task.spawn(function()
			task.wait(DespawnTime1)
			local HighlightTweenInfo = {RockDespawnTimeTween, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false}
			local TweenGoal1 = {Size = Vector3.new(0,0,0)}
			local RockSizeTween = Tween.Tween(part, HighlightTweenInfo, TweenGoal1)	
			Debris:AddItem(part,4.1)
		end)
	end

	for i = 0,AmountFlyingDebris do
		local DebrisVelocity = Vector3.new(math.random(-40,40),math.floor(55,105),math.random(-40,40))
		
		local newFlyingrocksize = math.random(FlyingDebrisSize[1],FlyingDebrisSize[2])
		
		local part = Instance.new("Part",ModelCircle)
		part.CanCollide = false
		part.Size = Vector3.new(0,0,0)
		part.Massless = true
		part.Name = "Debree"
		TS:Create(part,TweenInfo.new(0.2),{Size = Vector3.new(newFlyingrocksize,newFlyingrocksize,newFlyingrocksize)}):Play()

		if AccurateRepresentation == true then
			part.Material = Material
			part.Transparency = Transparency
			part.Color = Color
		else
			part.Material = Materials[math.random(1,#Materials)]
			part.Color = Colors[math.random(1,#Colors)]
		end
		
		part.Position = Position + Vector3.new(0,newFlyingrocksize,0)
		part.Velocity = DebrisVelocity
		part.AssemblyAngularVelocity = Vector3.new(math.random(-90,90),math.random(-90,90),math.random(-90,90))
		
		task.spawn(function()
			task.wait(0.5)
			part.CanCollide = FlyingDebrisCollision
		end)
		
		local FlyingRockDespawnTime1 = math.random(FlyingRockDespawnTime[1],FlyingRockDespawnTime[2])
		local FlyingRockDespawnTimeTween = math.random(1,2)
		
		task.spawn(function()
			task.wait(FlyingRockDespawnTime1)			
			local HighlightTweenInfo = {FlyingRockDespawnTimeTween, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false}
			local TweenGoal1 = {Size = Vector3.new(0,0,0)}
			local RockSizeTween = Tween.Tween(part, HighlightTweenInfo, TweenGoal1)	
			Debris:AddItem(part, 5.1)			
			coroutine.wrap(spinPart)(part)						
		end)
	end
	
	return
end

return module
