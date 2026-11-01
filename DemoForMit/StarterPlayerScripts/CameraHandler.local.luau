local RP = game:GetService('ReplicatedStorage')
local TS = game:GetService('TweenService')

local plr = game:GetService('Players').LocalPlayer

local events = RP:WaitForChild('Events')

local returnPoint = nil
local returnType = nil
local cam = workspace.CurrentCamera

local currTween = false
local paused = false

local function cutCam(target)
	cam.CameraType = Enum.CameraType.Scriptable
	cam.CFrame = target
end

local function pauseCam(target)
	if paused then
		cam.CameraType = Enum.CameraType.Scriptable
		cam.CFrame = paused
		paused = false
		currTween:Play()
	else
		paused = cam.CFrame
		currTween:Pause()
		cam.CameraType = Enum.CameraType.Scriptable
		cam.CFrame = target
	end
end

local function tweenCam(target, tweenTime)
	cam.CameraType = Enum.CameraType.Scriptable
	currTween = TS:Create(cam, TweenInfo.new(tweenTime), {CFrame = target})
	currTween:Play()
end

local disabled = {}

events:WaitForChild('Camera').OnClientEvent:Connect(function(target, returnTo, tweenTo, disableUi, pause)

	if disableUi then
		if #disabled > 0 then
			for i, v in pairs(disabled) do
				v.Enabled = true
			end
			table.clear(disabled)
		else
			for i, v in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
				if v:IsA('ScreenGui') and v.Enabled then
					table.insert(disabled, v)
					v.Enabled = false
				end
			end
		end
		return
	elseif pause then
		pauseCam(target)
		return
	end

	if returnTo then
		if returnPoint == nil then
			returnType = cam.CameraType
			returnPoint = cam.CFrame

			if tweenTo then
				tweenCam(target, tweenTo)
			else
				cutCam(target)
			end
		else
			cam.CameraType = returnType
			cam.CFrame = returnPoint
		end
	else
		if tweenTo then
			tweenCam(target, tweenTo)
		else
			cutCam(target)
		end
	end
end)
