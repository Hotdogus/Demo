local module = {}

module.LingeringHB = function(AliveData,char,damageTable,Size,Timer)
local Root = char.HumanoidRootPart
	task.spawn(function()

		local hitlist = {}

		local timer = tick()
	
		while true do

			local hitContents

			hitContents = workspace:GetPartBoundsInBox(Root.CFrame * CFrame.new(0, 0, -2), Vector3.new(Size,Size,Size), OverlapParams.new())


			if (tick() - timer) > Timer then
				break
			end

			for a, b in pairs(hitContents) do
				if b.Parent then

					local hit = b.Parent

					if hit then
						local player = game.Players:GetPlayerFromCharacter(char)	
				

						local ehum = hit:FindFirstChild("Humanoid")

						if ehum and hit ~= char and not hitlist[ehum] then

							hitlist[ehum] = true 

							game.ServerStorage.TagHumanoid:Invoke(char, hit, damageTable)

							break

						end

					end
				end	
			end

			game:GetService("RunService").Heartbeat:Wait()
		end
	end)

end

module.LingeringFrontHB = function(AliveData,char,damageTable,Size,Timer)
	local Root = char.HumanoidRootPart
	local Stunned 
	task.spawn(function()

		local hitlist = {}

		local timer = tick()

		while true do

			local hitContents

			hitContents = workspace:GetPartBoundsInBox(Root.CFrame * CFrame.new(0, 0, -2), Vector3.new(Size,Size,Size), OverlapParams.new())

			local Connection
			Connection = AliveData.TempValue.ChildAdded:Connect(function(ch)
				if ch.Name == "Stun" or ch.Name == "Ragdoll" or ch.Name == "Feinted" then
					Stunned = true
				end
			end)

			if (tick() - timer) > Timer or Stunned then
				break
			end

			for a, b in pairs(hitContents) do
				if b.Parent then

					local hit = b.Parent
				

					if hit then
						local player = game.Players:GetPlayerFromCharacter(char)

						local ehum = hit:FindFirstChild("Humanoid")

						if ehum and hit ~= char and not hitlist[ehum] then

							hitlist[ehum] = true 

							if Stunned then return end 

							if AliveData.TempValue:FindFirstChild("Feinted") then
							else 
							game.ServerStorage.TagHumanoid:Invoke(char, hit, damageTable)
							end 

							break

						end

					end
				end	
			end

			game:GetService("RunService").Heartbeat:Wait()
		end
	end)

end

module.FrontHB = function(AliveData,char,damageTable)

	coroutine.wrap(function()
		local Stunned
		local Connection

		Connection = AliveData.TempValue.ChildAdded:Connect(function(ch)
			if ch.Name == "Stun" or ch.Name == "Ragdoll" or ch.Name == "Feinted" then
				Stunned = true
			end
		end)

		local timer = tick()

		while true do 
			if tick() - timer >= 0.45 then
				break
			end

			if Stunned then
				break
			end

			game:GetService("RunService").Heartbeat:Wait()
		end



		if AliveData:FindFirstChild("Stun") then return end 
		if AliveData:FindFirstChild("ParryStun") then return end 

		local overlapParams = OverlapParams.new()
		local hitContents = workspace:GetPartBoundsInBox(char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2), Vector3.new(6, 6, 6), overlapParams)
		local hitlist = {}

		for a, b in pairs(hitContents) do
			local hit = b.Parent
			local ehum = hit:FindFirstChild("Humanoid")
			if ehum and hit ~= char and hit:IsDescendantOf(workspace.Alive) and not hitlist[ehum] then
				hitlist[ehum] = true 	
				--print("HIT")
				if Stunned == true then return end 
				game.ServerStorage.TagHumanoid:Invoke(char, hit, damageTable)	
			end
		end
	end)()
end

module.DistHB = function(AliveData,char,damageTable,offset,size)

	coroutine.wrap(function()
		local Stunned
		local Connection

		Connection = AliveData.TempValue.ChildAdded:Connect(function(ch)
			if ch.Name == "Stun" or ch.Name == "Ragdoll" or ch.Name == "Feinted" then
				Stunned = true
			end
		end)

		local timer = tick()

		while true do 
			if tick() - timer >= 0.45 then
				break
			end

			if Stunned then
				break
			end

			game:GetService("RunService").Heartbeat:Wait()
		end



		if AliveData:FindFirstChild("Stun") then return end 
		if AliveData:FindFirstChild("ParryStun") then return end 

		local overlapParams = OverlapParams.new()
		local hitContents = workspace:GetPartBoundsInBox(char.HumanoidRootPart.CFrame * CFrame.new(offset), size, overlapParams)
		
		--
		--local disPart= Instance.new('Part')
		--disPart.Color = Color3.new(1, 0, 0)
		--disPart.Transparency = 0.5
		--disPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(offset)
		--disPart.Size = size
		--disPart.CanCollide = false
		--disPart.CanTouch = false
		--disPart.CanQuery = false
		--disPart.Anchored = true
		--disPart.Parent = workspace
		--game.Debris:AddItem(disPart, 10)
		
		local hitlist = {}

		for a, b in pairs(hitContents) do
			local hit = b.Parent
			local ehum = hit:FindFirstChild("Humanoid")
			if ehum and hit ~= char and hit:IsDescendantOf(workspace.Alive) and not hitlist[ehum] then
				hitlist[ehum] = true 	
				--print("HIT")
				if Stunned == true then return end 
				game.ServerStorage.TagHumanoid:Invoke(char, hit, damageTable)	
			end
		end
	end)()
end


local smallerSize = 2.5
module.CHANGEABLEFrontHB = function(AliveData,char,damageTable,SIZE)

	coroutine.wrap(function()
		local Stunned
		local Connection

		Connection = AliveData.TempValue.ChildAdded:Connect(function(ch)
			if ch.Name == "Stun" or ch.Name == "Ragdoll" then
				Stunned = true
			end
		end)

		local timer = tick()

		while true do 
			if tick() - timer >= 0.25 then
				break
			end

			if Stunned then
				break
			end

			game:GetService("RunService").Heartbeat:Wait()
		end



		if AliveData:FindFirstChild("Stun") then return end 
		if AliveData:FindFirstChild("ParryStun") then return end 

		local overlapParams = OverlapParams.new()
		local hitContents = workspace:GetPartBoundsInBox(char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2), Vector3.new(SIZE, SIZE, SIZE), overlapParams)
		local hitlist = {}


		for a, b in pairs(hitContents) do
			local hit = b.Parent
		
			local ehum = hit:FindFirstChild("Humanoid")
			if ehum and hit ~= char and hit:IsDescendantOf(workspace.Alive) and not hitlist[ehum] then
				hitlist[ehum] = true 	
				--print("HIT")
				if Stunned == true then return end 
				game.ServerStorage.TagHumanoid:Invoke(char, hit, damageTable)	
			end
		end
	end)()


end


module.AOEHB = function(AliveData,char,damageTable,SIZE)

	coroutine.wrap(function()
		local Stunned
		local Connection

		Connection = AliveData.TempValue.ChildAdded:Connect(function(ch)
			if ch.Name == "Stun" or ch.Name == "Ragdoll" then
				Stunned = true
			end
		end)

		local timer = tick()

		while true do 
			if tick() - timer >= 0.35 then
				break
			end

			if Stunned then
				break
			end

			game:GetService("RunService").Heartbeat:Wait()
		end



		if AliveData.TempValue:FindFirstChild("Stun") then return end 
		if AliveData.TempValue:FindFirstChild("ParryStun") then return end 

		local overlapParams = OverlapParams.new()
		local hitContents = workspace:GetPartBoundsInBox(char.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0), Vector3.new(SIZE,SIZE, SIZE), overlapParams)
		local hitlist = {}

		for a, b in pairs(hitContents) do
			local hit = b.Parent
		
			local ehum = hit:FindFirstChild("Humanoid")
			if ehum and hit ~= char and hit:IsDescendantOf(workspace.Alive) and not hitlist[ehum] then
				hitlist[ehum] = true 	
				--print("HIT")
				if Stunned == true then return end 
				game.ServerStorage.TagHumanoid:Invoke(char, hit, damageTable)	
			end
		end
	end)()


end


module.AirSlamHB = function(AliveData,char,damageTable)

	coroutine.wrap(function()
		local Stunned
		local Connection

		Connection = AliveData.TempValue.ChildAdded:Connect(function(ch)
			if ch.Name == "Stun" or ch.Name == "Ragdoll" then
				Stunned = true
			end
		end)

		local timer = tick()

		while true do 
			if tick() - timer >= 0.35 then
				break
			end

			if Stunned then
				break
			end

			game:GetService("RunService").Heartbeat:Wait()
		end



		if AliveData:FindFirstChild("Stun") then return end 
		if AliveData:FindFirstChild("ParryStun") then return end 

		local overlapParams = OverlapParams.new()
		local hitContents = workspace:GetPartBoundsInBox(char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1), Vector3.new(8.5,9.5, 8.5), overlapParams)
		local hitlist = {}

		for a, b in pairs(hitContents) do
			local hit = b.Parent
			local ehum = hit:FindFirstChild("Humanoid")
	
			if ehum and hit ~= char and hit:IsDescendantOf(workspace.Alive) and not hitlist[ehum] then
				hitlist[ehum] = true 	
				--print("HIT")
				if Stunned == true then return end 
				game.ServerStorage.TagHumanoid:Invoke(char, hit, damageTable)	
			end
		end
	end)()


end

module.GunHitBox = function(AliveData,char,damageTable,Size,Timer)
	local Root = char.HumanoidRootPart
	local Stunned 
	task.spawn(function()

		local hitlist = {}

		local timer = tick()

		while true do

			local hitContents

			hitContents = workspace:GetPartBoundsInBox(char.HumanoidRootPart.CFrame * CFrame.new(0,0,-10), Vector3.new(Size,Size,Size), OverlapParams.new())

			local Connection
			Connection = AliveData.TempValue.ChildAdded:Connect(function(ch)
				if ch.Name == "Stun" or ch.Name == "Ragdoll" or ch.Name == "Feinted" then
					Stunned = true
				end
			end)

			if (tick() - timer) > Timer or Stunned then
				break
			end

			for a, b in pairs(hitContents) do
				if b.Parent then

					local hit = b.Parent


					if hit then
						local player = game.Players:GetPlayerFromCharacter(char)

						local ehum = hit:FindFirstChild("Humanoid")

						if ehum and hit ~= char and not hitlist[ehum] then

							hitlist[ehum] = true 

							if Stunned then return end 

							if AliveData.TempValue:FindFirstChild("Feinted") then
							else 
								game.ServerStorage.TagHumanoid:Invoke(char, hit, damageTable)
							end 

							break

						end

					end
				end	
			end

			game:GetService("RunService").Heartbeat:Wait()
		end
	end)

end

return module
