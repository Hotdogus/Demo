--// Variables \\--

local TS = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local debrisEffect = require(game.ReplicatedStorage.Modules.ClientBased.effectHandler:FindFirstChild("Debris"))

local effectCreator = {}


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

local function createSoundEffect(Object, soundId, Volume, playbackSpeed)

	local newSound = Instance.new("Sound")
	newSound.Name = "Body Explode"
	newSound.SoundId = soundId

	newSound.RollOffMinDistance = 0
	newSound.RollOffMaxDistance = 175
	newSound.RollOffMode = Enum.RollOffMode.LinearSquare

	newSound.PlaybackSpeed = math.random((playbackSpeed * 100) * 0.8, (playbackSpeed * 100) * 1.2) / 100
	newSound.Volume = 0.08

	newSound.Parent = Object
	newSound:Play()
	game.Debris:AddItem(newSound, newSound.TimeLength + 2)

end

function effectCreator.Create(Parameters)
	
	--// Variables \\--
	
	local localPlayer = players.LocalPlayer
	
	local parameterList = {
		CFrame = Parameters.CFrame,
		Size = Parameters.Size * (math.random(90,110) / 100),
		Direction = Parameters.Direction,
		Rows = Parameters.Rows,
		emitDebris = Parameters.emitDebris,
		emitSmoke = Parameters.emitSmoke,
		createSound = Parameters.createSound
	}
		
	--// Creating effect \\--
	
	local createEffect = coroutine.wrap(function()
		print("We cratering!!!")
		
		--// Raycasting \\
		
		local raycastResult = raycast(
			parameterList.CFrame.Position,
			parameterList.Direction,
			Enum.RaycastFilterType.Include,
			{
				game:GetService("Workspace"):FindFirstChild("Map")
			}
		)
		
		--// Raycast result \\--
		
		if raycastResult ~= "Nothing was hit" then

			print("We found it")
			
			local Pos, InScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(parameterList.CFrame.Position)
			local distanceTo = (game.Workspace.CurrentCamera.CFrame.Position - parameterList.CFrame.Position).Magnitude
		
			
			--// Creating crater \\--

			if raycastResult.Instance.Name == "Water" then


				local craterModel = Instance.new("Model")
				craterModel.Name = "Crater"
				craterModel.Parent = effectFolder
				game.Debris:AddItem(craterModel, 16)

	
				local shatteredEffect = game.ReplicatedStorage.Assets.Models:FindFirstChild("Shattered Ground"):Clone()
				shatteredEffect.Cracks.Transparency = 1
				shatteredEffect.Size = Vector3.new(
					(parameterList.Size * 1.25) * (1 + parameterList.Rows / 3),
					(parameterList.Size * 1.25) * (1 + parameterList.Rows / 3),
					0.1
				)
				shatteredEffect.CFrame = CFrame.lookAt(raycastResult.Position, raycastResult.Position + raycastResult.Normal) * CFrame.Angles(0, 0, math.rad(math.random(-180,180)))
				shatteredEffect.Parent = craterModel

				craterModel:WaitForChild("Shattered Ground")

				for i,v in pairs(shatteredEffect.Attachment:GetDescendants()) do
					if v:IsA("ParticleEmitter") then	
						v:Emit(v.Rate)
					end
				end

				local m = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
				m.PlaySound("Splash",craterModel)

			else  
			
			local craterModel = Instance.new("Model")
			craterModel.Name = "Crater"
			craterModel.Parent = effectFolder
			game.Debris:AddItem(craterModel, 16)
			
			local craterPart = game.ReplicatedStorage.Assets.Models:FindFirstChild("Crater"):Clone()
			craterPart.CFrame = CFrame.lookAt(raycastResult.Position, raycastResult.Position + raycastResult.Normal) * CFrame.Angles(0, 0, math.rad(math.random(-180,180)))
			craterPart.Parent = craterModel
			
			local materialColor = raycastResult.Instance.Color
			
			--// Adding cracks \\--
			
			local shatteredEffect = game.ReplicatedStorage.Assets.Models:FindFirstChild("Shattered Ground"):Clone()
			shatteredEffect.Size = Vector3.new(
				(parameterList.Size * 1.25) * (1 + parameterList.Rows / 3),
				(parameterList.Size * 1.25) * (1 + parameterList.Rows / 3),
				0.1
			)
			shatteredEffect:FindFirstChild("Smoke"):SetAttribute("emittionScale", parameterList.Size * 4)
			shatteredEffect.CFrame = CFrame.lookAt(raycastResult.Position, raycastResult.Position + raycastResult.Normal) * CFrame.Angles(0, 0, math.rad(math.random(-180,180)))
			shatteredEffect.Parent = craterModel
			
			TS:Create(shatteredEffect:FindFirstChild("Cracks"), TweenInfo.new(0.2),{
				Transparency = 0.5
			}):Play()
			
			local clearingGround = coroutine.wrap(function()
				
				wait(10)
				
				TS:Create(shatteredEffect:FindFirstChild("Cracks"), TweenInfo.new(5),{
					Transparency = 1
				}):Play()
				
			end)
			
			clearingGround()
			
			--// Sound Effect \\--
			
			if parameterList.createSound == nil then
				parameterList.createSound = true
			end
			
			if parameterList.createSound == true then
				
				local allSounds = craterPart:FindFirstChild("Sound"):GetChildren()
				local randomSound = allSounds[math.random(1,#allSounds)]

				randomSound.PlaybackSpeed *= math.random(85,115) / 100
				randomSound:Play()
				
				craterPart:FindFirstChild("impact").PlaybackSpeed = math.random(85,115) / 100
				craterPart:FindFirstChild("impact"):Play()
				
			end
			
			--// Checking if required to emit smoke \\--
			
			if parameterList.emitSmoke == true and InScreen == true and distanceTo < 150 then
				
				--// Smoke Sound \\--

				local smokeSound = craterPart:FindFirstChild("smokeSound")

				smokeSound.PlaybackSpeed *= math.random(100,125) / 100
				smokeSound:Play()

				--// Particle Emittion \\--

				for i, v in pairs(craterPart:GetChildren()) do
					if v:IsA("ParticleEmitter") and v:GetAttribute("emittionScale") then

						v.Color = ColorSequence.new(materialColor, materialColor)

						local emittionScale = v:GetAttribute("emittionScale")
						v:Emit(tonumber(emittionScale))

					end
				end

				for i, v in pairs(shatteredEffect:GetChildren()) do
					if v:IsA("ParticleEmitter") and v:GetAttribute("emittionScale") then

						v.Color = ColorSequence.new(materialColor, materialColor)

						local emittionScale = v:GetAttribute("emittionScale")
						v:Emit(tonumber(emittionScale))

					end
				end
				
			end
			
			--// Creating debris \\--
			
			if parameterList.emitDebris == true then
				print("supposedtodebris")
			end
			
			--// Creating crater \\--

			end
			
		end
		
	end)
	
	createEffect()
	
end

--// Returning \\--

return effectCreator