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
	
	--// Variables \\--

	print("recieved emit")
	
	local localPlayer = players.LocalPlayer
	
	local parameterList = {
		CFrame = Parameters.CFrame,
		Subject = Parameters.Subject,
		presetParticles = Parameters.presetParticles,
		attachPart = Parameters.attachPart
	}

	--// Creating effect \\--
	
	local createEffect = coroutine.wrap(function()
		
		local particlePosition
		
		if parameterList.Subject ~= nil then
			particlePosition = parameterList.Subject.Position
		else
			particlePosition = parameterList.CFrame.Position
		end
		
		local Pos, InScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(particlePosition)
		local distanceTo = (game.Workspace.CurrentCamera.CFrame.Position - particlePosition).Magnitude
		
		--// Checking \\--
		
		if InScreen == true and distanceTo < 150  then

			print("Inscreen and indistance")
			
			--// Creating \\--

			local newEffect = parameterList.presetParticles:Clone()

			print(newEffect.Name)
			
			if parameterList.Subject ~= nil then
				
				local effectWeld = newEffect:FindFirstChildOfClass("Weld")
				effectWeld.Part0 = parameterList.Subject
				
			else
				newEffect.CFrame = parameterList.CFrame
			end
			
			game.Debris:AddItem(newEffect, newEffect:GetAttribute("Duration"))
			newEffect.Parent = effectFolder
			
			--// Attaching \\--
			
			if parameterList.attachPart ~= nil then
				
				newEffect.Anchored = false
				
				local effectWeld = newEffect:FindFirstChildOfClass("Weld")
				effectWeld.Part0 = parameterList.attachPart
				
			end
			
			--// Emitting effects \\--

			for i, v in pairs(newEffect:GetDescendants()) do
				if v:IsA("ParticleEmitter") and v:GetAttribute("emitRate") then
					if v.Name == "Smoke" then
						print("Emitted")	
						v:Emit(v:GetAttribute("emitRate"))
					else
						
						print("emitted?")
						v:Emit(v:GetAttribute("emitRate"))
						
					end
				elseif v:IsA("Sound") then
					v.PlaybackSpeed = math.random(math.round(v.PlaybackSpeed * 85), math.round(v.PlaybackSpeed * 115)) / 100
					v:Play()
				elseif v:IsA("PointLight") or v:IsA("SpotLight") then
					
					local parameters = {
						Brightness = v.Brightness,
						Range = v.Range
					}
					
					v.Brightness = 0
					v.Range = 0
					
					TS:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quad),{
						Brightness = parameters.Brightness,
						Range = parameters.Range
					}):Play()
					
					local despawn = coroutine.wrap(function()
						
						wait(0.35)
						
						TS:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Quad),{
							Brightness = 0,
							Range = 0
						}):Play()
						
					end)
					
					despawn()
					
				end
			end
			
		end

	end)

	print("Emitdone")
	
	createEffect()
	
end

--// Returning \\--

return effectCreator