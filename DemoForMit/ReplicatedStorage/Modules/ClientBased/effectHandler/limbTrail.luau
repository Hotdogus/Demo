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
	
	local localPlayer = players.LocalPlayer
	
	local parameterList = {
		Limb = Parameters.Limb,
		Trail = Parameters.Trail,
		Duration = Parameters.Duration,
		Subject = Parameters.Subject,
		Type = Parameters.Type
	}
	
	if parameterList.Type == nil then
		parameterList.Type = "Speedtrail"
	end
	
	if parameterList.Subject == nil then
		parameterList.Subject = parameterList.Limb.Parent
	end
	
	--// Checking distance \\--

	local currCamera = game.Workspace.CurrentCamera
	local Pos, InScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(parameterList.Subject.PrimaryPart.Position)
	local distanceTo = (currCamera.CFrame.Position - parameterList.Subject.PrimaryPart.Position).Magnitude
	
	
	--// Creating effect \\--
	
	if distanceTo < 175 then
		
		local createEffect = coroutine.wrap(function()

			if parameterList.Type == "Speedtrail" then

				local clonedTrail = parameterList.Trail:Clone()
				clonedTrail.Parent = parameterList.Limb
				game.Debris:AddItem(clonedTrail, parameterList.Duration + 1.5)

				local trailWeld = clonedTrail:FindFirstChildOfClass("Weld")
				trailWeld.Part0 = parameterList.Limb


				wait(parameterList.Duration)

				for i, v in pairs(clonedTrail:GetDescendants()) do
					if v:IsA("Trail") then
						v.Enabled = false
					end
					if v:IsA("ParticleEmitter") then
						v.Enabled = false
					end
				end

			end

		end)

		createEffect()
		
	end
	
end

--// Returning \\--

return effectCreator