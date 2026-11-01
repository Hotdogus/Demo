local module = {}

module.Create = function(Type: "Perm" | "Temp", Item, Location, Name, Duration)
	spawn(function()
		if Type == "Perm" then
			local val = Instance.new(Item)
			val.Name = Name
			val.Parent = Location
		else 
			local val = Instance.new(Item)
			val.Name = Name
			val.Parent = Location
			game.Debris:AddItem(val, Duration)
		end
	end)
end


module.Clearvelocity = function(Character)

	for i,v in pairs(Character:GetDescendants()) do
		if v:IsA("BodyVelocity") then
			v:Destroy()
		end
		if v:IsA("BodyPosition") then
			v:Destroy()
		end
	end

end

module.PlaySound = function(SoundName,Location)

	local sfx = script.Sounds:FindFirstChild(SoundName):Clone()
	sfx.Parent = Location
	sfx:Play()
	game.Debris:AddItem(sfx,3)

end

module.PlayRandomSound = function(SoundName,Location,MaxSounds)

	local sfx = script.Sounds:FindFirstChild(SoundName..math.random(1,MaxSounds)):Clone()
	sfx.Parent = Location
	sfx:Play()
	game.Debris:AddItem(sfx,3)

end

module.Destroy = function(Location, Item)
	for i,v in Location:GetDescendants() do
		if v.Name == Item then
			v:Destroy()
		end
	end
end

module.Velocity = function(char)

	local dashDirection = "Forward"	
	local Humanoid = char.Humanoid
	local HRP = char.HumanoidRootPart

	local movementDirection = game.Workspace.CurrentCamera.CFrame:vectorToObjectSpace(char.Humanoid.MoveDirection).Unit
	if Humanoid.MoveDirection == Vector3.new(0,0,0)  then return end  

	local dashVelocity = coroutine.wrap(function()

		--// Creating body position \\--

		local dashDistance = 60
		local dashDuration = 0.37

		local baseHRPCFrame = CFrame.new(HRP.Position.X, HRP.Position.Y, HRP.Position.Z) * CFrame.Angles(0, math.rad(HRP.Orientation.Y), 0)

		local directionVelocities = {
			["Forward"] = baseHRPCFrame * CFrame.new(0, 0, -dashDistance),
			["Back"] = baseHRPCFrame * CFrame.new(0, 0, dashDistance),
			["Left"] = baseHRPCFrame * CFrame.new(-dashDistance, 0, 0),
			["Right"] = baseHRPCFrame * CFrame.new(dashDistance, 0, 0),
		}

		local bodyPosition = Instance.new("BodyPosition")
		bodyPosition.Name = "Dash Velocity"
		bodyPosition.P = 15000
		bodyPosition.D = 1900
		bodyPosition.Position = directionVelocities[dashDirection].Position
		bodyPosition.MaxForce = Vector3.new(100000, 0, 100000)
		game.Debris:AddItem(bodyPosition, dashDuration)
		bodyPosition.Parent = HRP

		if dashDirection == "Back" then
			spawn(function()
				task.wait(0.235)

				local baseHRPCFrame = CFrame.new(HRP.Position.X, HRP.Position.Y, HRP.Position.Z) * CFrame.Angles(0, math.rad(HRP.Orientation.Y), 0)

				local directionVelocities = {
					["Forward"] = baseHRPCFrame * CFrame.new(0, 0, -dashDistance),
					["Back"] = baseHRPCFrame * CFrame.new(0, 0, dashDistance),
					["Left"] = baseHRPCFrame * CFrame.new(-dashDistance, 0, 0),
					["Right"] = baseHRPCFrame * CFrame.new(dashDistance, 0, 0),
				}

				local bodyPosition = Instance.new("BodyPosition")
				bodyPosition.Name = "Dash Velocity"
				bodyPosition.P = 15000
				bodyPosition.D = 1900
				bodyPosition.Position = directionVelocities[dashDirection].Position
				bodyPosition.MaxForce = Vector3.new(100000, 0, 100000)
				game.Debris:AddItem(bodyPosition, dashDuration)
				bodyPosition.Parent = HRP

				local start = tick()

				local adjusting

				adjusting = game:GetService("RunService").Stepped:Connect(function()

					--// Disconnecting \\--

					if bodyPosition.Parent == nil  then

						bodyPosition:Destroy()
						adjusting:Disconnect()
						print(tick() - start)
						return


					end

					--// Presetting direction values \\--

					baseHRPCFrame = CFrame.new(HRP.Position.X, HRP.Position.Y, HRP.Position.Z) * CFrame.Angles(0, math.rad(HRP.Orientation.Y), 0)

					directionVelocities = {
						["Forward"] = baseHRPCFrame * CFrame.new(0, 0, -dashDistance),
						["Back"] = baseHRPCFrame * CFrame.new(0, 0, dashDistance),
						["Left"] = baseHRPCFrame * CFrame.new(-dashDistance, 0, 0),
						["Right"] = baseHRPCFrame * CFrame.new(dashDistance, 0, 0),
					}

					--// Setting \\--

					if bodyPosition.Parent ~= nil then
						bodyPosition.Position = directionVelocities[dashDirection].Position
					end

				end)
			end)
		end

		--// Adjusting velocity \\--

		local start = tick()

		local adjusting

		adjusting = game:GetService("RunService").Stepped:Connect(function()

			--// Disconnecting \\--

			if bodyPosition.Parent == nil  then

				bodyPosition:Destroy()
				adjusting:Disconnect()
				print(tick() - start)
				return


			end

			--// Presetting direction values \\--

			baseHRPCFrame = CFrame.new(HRP.Position.X, HRP.Position.Y, HRP.Position.Z) * CFrame.Angles(0, math.rad(HRP.Orientation.Y), 0)

			directionVelocities = {
				["Forward"] = baseHRPCFrame * CFrame.new(0, 0, -dashDistance),
				["Back"] = baseHRPCFrame * CFrame.new(0, 0, dashDistance),
				["Left"] = baseHRPCFrame * CFrame.new(-dashDistance, 0, 0),
				["Right"] = baseHRPCFrame * CFrame.new(dashDistance, 0, 0),
			}

			--// Setting \\--

			if bodyPosition.Parent ~= nil then
				bodyPosition.Position = directionVelocities[dashDirection].Position
			end

		end)

	end)

	dashVelocity()

end



return module
