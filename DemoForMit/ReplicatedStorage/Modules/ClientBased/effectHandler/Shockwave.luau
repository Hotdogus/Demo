--// Variables \\--

local TS = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

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

function effectCreator.Create(Parameters)
	print("Module")
	
	--// Variables \\--
	
	local localPlayer = players.LocalPlayer
	
	local parameterList = {
		CFrame = Parameters.CFrame,
		Size = Parameters.Size * (math.random(90,110) / 100),
		Duration = Parameters.Duration,
		Type = Parameters.Type
	}
	
	--// Checking distance \\--

	local currCamera = game.Workspace.CurrentCamera
	local Pos, InScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(parameterList.CFrame.Position)
	local distanceTo = (currCamera.CFrame.Position - parameterList.CFrame.Position).Magnitude
	
	--// Creating effect \\--
	
	if distanceTo < 150 then
		print("InDIstance")
		local createEffect = coroutine.wrap(function()

			--// Creating shockwave \\--

			local shockwave = game.ReplicatedStorage.Assets.VFX:FindFirstChild(parameterList.Type):Clone()
			shockwave.CFrame = parameterList.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
			shockwave.Transparency = 0.5

			shockwave.Parent = effectFolder
			game.Debris:AddItem(shockwave, parameterList.Duration + 1)

			--// Tweening shockwave \\--

			TS:Create(shockwave, TweenInfo.new(parameterList.Duration, Enum.EasingStyle.Sine),{
				Transparency = 1,
				Size = Vector3.new(parameterList.Size, parameterList.Size / 35, parameterList.Size)
			}):Play()
			print("Tweened")
		end)

		createEffect()
		
	end
	
end

--// Returning \\--

return effectCreator