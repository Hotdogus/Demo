--// Variables \\--

local TS = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local effectCreator = {}

--local assets = replicatedStorage:FindFirstChild("Assets")
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
	
	--// Variables \\--
	
	local localPlayer = players.LocalPlayer
	
	local parameterList = {
		CFrame = Parameters.CFrame,
		Size = Parameters.Size * (math.random(90,110) / 100),
		Direction = Parameters.Direction,
		Amount = Parameters.Amount,
		presetPart = Parameters.presetPart
	}
	
	local Pos, InScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(parameterList.CFrame.Position)
	local distanceTo = (game.Workspace.CurrentCamera.CFrame.Position - parameterList.CFrame.Position).Magnitude

	--// Creating effect \\--
	
	if distanceTo < 400 then
		
		local createEffect = coroutine.wrap(function()

			--// Making model \\--

			local debrisCollection = Instance.new("Model")
			debrisCollection.Name = "Debris Collection"
			game.Debris:AddItem(debrisCollection, 15)
			debrisCollection.Parent = effectFolder:FindFirstChild("Debris")

			--// Creating debris \\--

			for i = 1, parameterList.Amount do

				local hitGround = false

				--// Creating debris \\--

				local resultSize = math.random(parameterList.Size * 40, parameterList.Size * 125) / 100

				local debrisPart = game.ReplicatedStorage.Assets.Models:FindFirstChild("Debris"):Clone()
				debrisPart.CFrame = parameterList.CFrame * CFrame.new(math.random(-25,25) / 10, math.random(-25,25) / 10, math.random(-25,25) / 10)
				debrisPart.Orientation = Vector3.new(math.random(-180,180), math.random(-180,180), math.random(-180,180))
				debrisPart.Massless = false

				debrisPart.Size = Vector3.new((resultSize * math.random(60,125)) / 100, (resultSize * math.random(60,125)) / 100, (resultSize * math.random(60,125)) / 100)
				debrisPart.Material = parameterList.presetPart.Material
				debrisPart.Color = parameterList.presetPart.Color

				debrisPart:FindFirstChild("Attachment0").Position = Vector3.new(debrisPart.Size.X, 0, 0)
				debrisPart:FindFirstChild("Attachment1").Position = Vector3.new(-debrisPart.Size.X, 0, 0)

				debrisPart.Parent = debrisCollection

				--// Flinging the debris part \\--

				local flingVelocity = Instance.new("BodyVelocity")
				flingVelocity.MaxForce = Vector3.new(15000,15000,15000)
				flingVelocity.Velocity = (parameterList.Direction) + Vector3.new(math.random(-35,35) * parameterList.Size / 3, math.random(0,35) * parameterList.Size / 3, math.random(-35,35) * parameterList.Size / 3)
				flingVelocity.Name = "Fling Velocity"
				game.Debris:AddItem(flingVelocity, math.random(10,25) / 100)
				flingVelocity.Parent = debrisPart

				local spinVelocity = Instance.new("BodyAngularVelocity")
				spinVelocity.MaxTorque = Vector3.new(5000,5000,5000)
				spinVelocity.AngularVelocity = Vector3.new(math.random(-50,50) / 10, math.random(-50,50) / 10, math.random(-50,50) / 10)
				spinVelocity.Name = "Spin Velocity"
				spinVelocity.Parent = debrisPart

				--// Playing sound \\--

				local flingSound = debrisPart:FindFirstChild("Fling")

				flingSound.PlaybackSpeed = math.random(80,120) / 100
				flingSound:Play()

				--// Detecting collision \\--

				local detectingCollision = coroutine.wrap(function()

					wait(0.15)

					debrisPart.CanCollide = true

					--// Waiting a bit so it doesn't hit the ground right away \\--

					wait(math.random(25,50) / 100)

					--// Detecting \\---

					local debrisEvents = {}

					debrisEvents["Touched"] = debrisPart.Touched:Connect(function(hitPart)
						if hitPart:FindFirstAncestor("World") and hitGround == false and not hitPart:FindFirstAncestor(debrisCollection.Name) then

							debrisEvents["Touched"]:Disconnect()
							hitGround = true

							--// Sound \\--

							local soundEffects = debrisPart:FindFirstChild("collisionSound"):GetChildren()
							local randomSound = soundEffects[math.random(1,#soundEffects)]

							randomSound.PlaybackSpeed = math.random(80,120) / 100
							randomSound:Play()

							--// Enabling colission \\--

							spinVelocity:Destroy()

							debrisPart:FindFirstChild("Trail").Enabled = false

							debrisPart.Velocity = Vector3.new(0,0,0)
							debrisPart.CanCollide = true
							debrisPart.Massless = false
							
							--// Clearing \\--

							local clearingDebris = coroutine.wrap(function()

								--// Waiting for a stay duration \\--

								wait(10)

								--// Pre setting \\--

								debrisPart.Anchored = true

								--// Despawning \\--

								TS:Create(debrisPart, TweenInfo.new(5, Enum.EasingStyle.Sine),{

									Position = debrisPart.Position + Vector3.new(
										math.random(-10,10) / 10,
										-(parameterList.Size * 3),
										math.random(-10,10) / 10
									),

									Transparency = 1,

									Orientation = debrisPart.Orientation + Vector3.new(
										math.random(-25,25),
										math.random(-25,25),
										math.random(-25,25)
									)
								}):Play()

							end)

							clearingDebris()

						end				
					end)

					debrisEvents["Destroyed"] = debrisPart:GetPropertyChangedSignal("Parent"):Connect(function()
						if debrisPart.Parent == nil then

							--// Disconnecting \\--

							for i, v in pairs(debrisEvents) do
								v:Disconnect()
							end

						end
					end)

				end)

				detectingCollision()

			end
		
		end)

		createEffect()
		
	end
	
end

--// Returning \\--

return effectCreator