local CameraHandler = {}

--services
local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

--constants
local style = Enum.EasingStyle.Quad
local direction = Enum.EasingDirection.Out

--states
local isClient = RunService:IsClient()

local camera = isClient and workspace.CurrentCamera or nil

local originalCFrame = nil
local originalType = nil

local isActive = false

local currentCutscene = nil
local cutsceneConnections = {}

--helpers
local function validateCFrame(cf)
	if typeof(cf) ~= "CFrame" then
		return false
	end
	return true
end

local function validateNumber(num, name)
	if typeof(num) ~= "number" then
	return false
	end
	return true
end

local function getCamera()
	if not isClient then
		return nil
	end
	if not camera then
		camera = workspace.CurrentCamera
	end
	return camera
end

--scriptable activate
function CameraHandler.Activate()
	local cam = getCamera()
	if not cam then return false end
	
	if isActive then
		warn("CameraHandler: Camera is already active")
		return false
	end
	
	originalType = cam.CameraType
	originalCFrame = cam.CFrame
	cam.CameraType = Enum.CameraType.Scriptable
	
	isActive = true
	
	return true
end

--scriptable deactivate
function CameraHandler.Deactivate()
	local cam = getCamera()
	if not cam then return false end
	
	if not isActive then
		warn("CameraHandler: Camera is not active")
		return false
	end
	
	cam.CameraType = originalType or Enum.CameraType.Custom
	if originalCFrame then
		cam.CFrame = originalCFrame
	end
	
	isActive = false
	
	return true
end

--currently in cutscene mode
function CameraHandler.IsActive()
	return isActive
end

--camera to CFrame
function CameraHandler.SnapTo(cf)
	if not validateCFrame(cf) then return false end
	local cam = getCamera()
	if not cam then return false end
	
	cam.CFrame = cf
	return true
end

--tween to cf
function CameraHandler.TweenTo(cf, duration, easingStyle, easingDirection)
	if not validateCFrame(cf) then return nil end
	if not validateNumber(duration, "duration") then return nil end
	
	local cam = getCamera()
	if not cam then return nil end
	
	local style = easingStyle or style
	local direction = easingDirection or direction
	
	local info = TweenInfo.new(duration, style, direction)
	local goal = {CFrame = cf}
	local tween = TweenService:Create(cam, info, goal)
	
	tween:Play()
	return tween
end

-- tween to
function CameraHandler.TweenLookAt(position, lookAtPoint, duration, easingStyle, easingDirection)
	if not validateCFrame(position) and typeof(position) ~= "Vector3" then
		return nil
	end
	
	local pos = typeof(position) == "Vector3" and position or position.Position
	local targetCF = CFrame.new(pos, lookAtPoint)
	
	return CameraHandler.TweenTo(targetCF, duration, easingStyle, easingDirection)
end

--camera to look at specific point from a position
function CameraHandler.SnapLookAt(position, lookAtPoint)
	local pos = typeof(position) == "Vector3" and position or position.Position
	local targetCF = CFrame.new(pos, lookAtPoint)
	return CameraHandler.SnapTo(targetCF)
end

--new cutscene object for building sequences
function CameraHandler.CreateCutscene()
	local cutscene = {
		steps = {},
		currentIndex = 0,
		isPlaying = false,
		onComplete = nil,
		onStep = nil
	}
	
	--adds a snap step
	function cutscene:Snap(cf)
		table.insert(self.steps, {type = "snap", cf = cf})
		return self
	end
	
	--adds a tween step
	function cutscene:Tween(cf, duration, easingStyle, easingDirection)
		table.insert(self.steps, {
			type = "tween",
			cf = cf,
			duration = duration or 1,
			easingStyle = easingStyle,
			easingDirection = easingDirection
		})
		return self
	end
	
	--adds a wait step
	function cutscene:Wait(duration)
		table.insert(self.steps, {type = "wait", duration = duration})
		return self
	end
	
	--adds a look-at tween step
	function cutscene:TweenLookAt(position, lookAtPoint, duration, easingStyle, easingDirection)
		local pos = typeof(position) == "Vector3" and position or position.Position
		local targetCF = CFrame.new(pos, lookAtPoint)
		table.insert(self.steps, {
			type = "tween",
			cf = targetCF,
			duration = duration or 1,
			easingStyle = easingStyle,
			easingDirection = easingDirection
		})
		return self
	end
	
	--adds a callback step (for triggering events during cutscene)
	function cutscene:Callback(callback)
		table.insert(self.steps, {type = "callback", callback = callback})
		return self
	end

	--sets the callbacks
	function cutscene:OnComplete(callback)
		self.onComplete = callback
		return self
	end
	function cutscene:OnStep(callback)
		self.onStep = callback
		return self
	end
	
	--plays the cutscene sequence
	function cutscene:Play()
		if self.isPlaying then return end
		self.isPlaying = true
		self.currentIndex = 0
		
		CameraHandler.Activate()
		
		local function playNextStep()
			self.currentIndex = self.currentIndex + 1
			local step = self.steps[self.currentIndex]
			
			if not step then
				-- Cutscene complete
				self.isPlaying = false
				if self.onComplete then
					self.onComplete()
				end
				return
			end
			
			if self.onStep then
				self.onStep(self.currentIndex, step)
			end
			
			if step.type == "snap" then
				CameraHandler.SnapTo(step.cf)
				playNextStep()
				
				elseif step.type == "tween" then
					local tween = CameraHandler.TweenTo(step.cf, step.duration, step.easingStyle, step.easingDirection)
				
				if tween then
					tween.Completed:Connect(playNextStep)
					
				else
					playNextStep()
				end
			elseif step.type == "wait" then
				task.delay(step.duration, playNextStep)
				
			elseif step.type == "callback" then
				if step.callback then
					step.callback()
				end
				
				playNextStep()
			end
		end
		
		playNextStep()
		return self
	end
	
	--stops the cutscene and deactivates cam
	function cutscene:Stop()
		self.isPlaying = false
		CameraHandler.Deactivate()
		return self
	end
	
	--clear all steps
	function cutscene:Clear()
		self.steps = {}
		self.currentIndex = 0
		return self
	end
	
	return cutscene
end

--util

function CameraHandler.CreateCFrame(position, lookAt)
	return CFrame.new(position, lookAt)
end

function CameraHandler.CreateCFrameFromRotation(position, rotationDegrees)
	local cf = CFrame.new(position)
	cf = cf * CFrame.Angles(math.rad(rotationDegrees.X), math.rad(rotationDegrees.Y), math.rad(rotationDegrees.Z))
	return cf
end

function CameraHandler.GetCFrame()
	local cam = getCamera()
	if not cam then return nil end
	return cam.CFrame
end

function CameraHandler.GetPosition()
	local cam = getCamera()
	if not cam then return nil end
	return cam.CFrame.Position
end

function CameraHandler.SetFOV(fov)
	if not validateNumber(fov, "fov") then return false end
	local cam = getCamera()
	if not cam then return false end
	
	cam.FieldOfView = fov
	return true
end

--tween fov
function CameraHandler.TweenFOV(fov, duration, easingStyle, easingDirection)
	if not validateNumber(fov, "fov") or not validateNumber(duration, "duration") then
		return nil
	end
	
	local cam = getCamera()
	if not cam then return nil end
	
	local style = easingStyle or style
	local direction = easingDirection or direction
	
	local info = TweenInfo.new(duration, style, direction)
	local goal = {FieldOfView = fov}
	local tween = TweenService:Create(cam, info, goal)
	
	tween:Play()
	return tween
end

--server
function CameraHandler.GetRemoteEvent()
	local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
	if not eventsFolder then
		eventsFolder = Instance.new("Folder")
		eventsFolder.Name = "Events"
		eventsFolder.Parent = ReplicatedStorage
	end
	
	local remoteEvent = eventsFolder:FindFirstChild("DogCam")
	if not remoteEvent then
		remoteEvent = Instance.new("RemoteEvent")
		remoteEvent.Name = "DogCam"
		remoteEvent.Parent = eventsFolder
	end
	
	return remoteEvent
end

if not isClient then
	--activates camera for all or specific players
	function CameraHandler.ServerActivate(players)
		local remoteEvent = CameraHandler.GetRemoteEvent()
		if players then
			remoteEvent:FireClient(players, 1)
		else
			remoteEvent:FireAllClients(1)
		end
	end
	
	--deactivates camera for all or specific players
	function CameraHandler.ServerDeactivate(players)
		local remoteEvent = CameraHandler.GetRemoteEvent()
		if players then
			remoteEvent:FireClient(players, 2)
		else
			remoteEvent:FireAllClients(2)
		end
	end
	
	--snaps camera for all or specific players
	function CameraHandler.ServerSnapTo(players, cf)
		local remoteEvent = CameraHandler.GetRemoteEvent()
		if players then
			remoteEvent:FireClient(players, 3, cf)
		else
			remoteEvent:FireAllClients(3, cf)
		end
	end
	
	--tweens camera for all or specific players
	function CameraHandler.ServerTweenTo(players, cf, duration, easingStyle, easingDirection)
		local remoteEvent = CameraHandler.GetRemoteEvent()
		if players then
			remoteEvent:FireClient(players, 4, cf, duration, easingStyle, easingDirection)
		else
			remoteEvent:FireAllClients(4, cf, duration, easingStyle, easingDirection)
		end
	end
	
	--plays a cutscene sequence for all or specific players
	function CameraHandler.ServerPlayCutscene(players, steps)
		local remoteEvent = CameraHandler.GetRemoteEvent()
		if players then
			remoteEvent:FireClient(players, 5, steps)
		else
			remoteEvent:FireAllClients(5, steps)
		end
	end
end

--client

if isClient then
	local remoteEvent = CameraHandler.GetRemoteEvent()
	
	remoteEvent.OnClientEvent:Connect(function(actionId, ...)
		local args = {...}
		
		if actionId == 1 then
			CameraHandler.Activate()
		elseif actionId == 2 then
			CameraHandler.Deactivate()
		elseif actionId == 3 then
			CameraHandler.SnapTo(args[1])
		elseif actionId == 4 then
			CameraHandler.TweenTo(args[1], args[2], args[3], args[4])
		elseif actionId == 5 then
			--play cutscene sequence from server
			local steps = args[1]
			if type(steps) == "table" then
				local cutscene = CameraHandler.CreateCutscene()
				for _, step in ipairs(steps) do
					if step.type == "snap" then
						cutscene:Snap(step.cf)
					elseif step.type == "tween" then
						cutscene:Tween(step.cf, step.duration, step.easingStyle, step.easingDirection)
					elseif step.type == "wait" then
						cutscene:Wait(step.duration)
					end
				end
				cutscene:Play()
			end
		end
	end)
end

return CameraHandler