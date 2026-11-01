--// Variables \\--

local TS = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local effectCreator = {}

local assets = replicatedStorage:FindFirstChild("Assets")
local effectFolder = game:GetService("Workspace").Ignore

--// Create Effect \\--

local function raycast(origin, direction, filterType, filterTable)
	
	--// Creating raycast \\--
	
	local raycastParameters = RaycastParams.new()
	raycastParameters.FilterType = filterType
	raycastParameters.FilterDescendantsInstances = filterTable
	raycastParameters.RespectCanCollide = true
	
	local raycastResult = game:GetService("Workspace"):Raycast(origin, direction, raycastParameters)
	
	--// Returning result \\--
	
	if raycastResult ~= nil then		
		return raycastResult	
	else		
		return "Nothing was hit"		
	end
	
end

function effectCreator.Create(Parameters)
	
wait(0.08)
	--// Variables \\--
	
	local localPlayer = players.LocalPlayer
	
	local parameterList = {
		Person = Parameters.Person,
	}
	
	--// Creating effect \\--
	
	local createEffect = coroutine.wrap(function()
		
		--// Character Variables \\--
		
		local Target = parameterList.Person
		
		local personHRP = Target:FindFirstChild("HumanoidRootPart")
		local personHumanoid = Target:FindFirstChild("Humanoid")
		
		local slideParticles = Instance.new("Model")
		slideParticles.Name = "Slide Particles"
		slideParticles.Parent = effectFolder
		
		--// Creating slide particles \\--
		
		local creatingParticles
		
		creatingParticles = game["Run Service"].Heartbeat:Connect(function()
			
			--// Pre Check \\--
			
			local canContinue = true
			
			local canContinue = true

			if Target.Parent == nil or personHumanoid.Health <= 0 or not Target.AliveData.TempValue:FindFirstChild("GS") then
				game.Debris:AddItem(slideParticles, 11)
				canContinue = false
				creatingParticles:Disconnect()
			end

			
			--// Checking \\--
			
			if canContinue == true then
				
				--// Checking distance \\--

				local currCamera = game.Workspace.CurrentCamera
				local distanceTo = (currCamera.CFrame.Position - parameterList.Person.PrimaryPart.Position).Magnitude

				--// Rayasting \\--

				local newSet = coroutine.wrap(function()

					if distanceTo < 200 then

						local rng = math.random(1,10)
						if rng ~= 1 then return end 

						local side = -2.25

						for i = 1, 8 do

							--// Params \\--

							local raycastResult = raycast(
								(personHRP.CFrame * CFrame.new(side, 0, 0)).Position,
								Vector3.new(0,-7,0),
								Enum.RaycastFilterType.Include,
								{
									game.Workspace.Map
								}
							)

							--// Result \\--

							if raycastResult ~= "Nothing was hit" then
								if i == 8 then

									if rng < 1 then
										 return
									end
						
									--// Creating particle \\--

									local currSize = math.random(20,45) / 100

									local newParticle = Instance.new("Part")
									newParticle.Name = "Slide Particle"
									newParticle.Anchored = true
									newParticle.CanCollide = false

									newParticle.Size = Vector3.new(currSize / 2, currSize / 2, currSize / 2)
									newParticle.Color = raycastResult.Instance.Color
									newParticle.Material = raycastResult.Instance.Material
									newParticle.Transparency = 1

									local partPosition = raycastResult.Position + Vector3.new(math.random(-65,65) / 100, 0, math.random(-65,65) / 100)

									newParticle.Position = partPosition + Vector3.new(math.random(-25,25) / 100, -1, math.random(-25,25) / 100)
									newParticle.Orientation = Vector3.new(math.random(-180,180), math.random(-180,180), math.random(-180,180))
									newParticle.Parent = slideParticles

									TS:Create(newParticle, TweenInfo.new(0.1, Enum.EasingStyle.Quad),{
										Orientation = newParticle.Orientation + Vector3.new(math.random(-25,25), math.random(-25,25), math.random(-25,25)),
										Size = Vector3.new(currSize, currSize, currSize),
										Transparency = 0,
										Position = partPosition
									}):Play()

									--// Clearing after 5 secs \\--

									local clearing = coroutine.wrap(function()

										wait(2)

										TS:Create(newParticle, TweenInfo.new(5, Enum.EasingStyle.Quad),{
											Position = newParticle.Position + Vector3.new(0,-2,0),
											Transparency = 1
										}):Play()

									end)

									clearing()

								end
							end

							--// Changign side \\--

							if i == 1 then
								side = 2.25
							elseif i == 2 then
								side = 0
							end

						end	

					end

				end)

				newSet()
				
			end
			
		end)
		
	end)
	
	createEffect()
	
end

--// Returning \\--

return effectCreator