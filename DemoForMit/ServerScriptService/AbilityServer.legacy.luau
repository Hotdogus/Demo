local RP = game:GetService('ReplicatedStorage')
local SS = game:GetService('ServerStorage')
local PS = game:GetService('Players')
local TS = game:GetService('TweenService')
local SoundService = game:GetService('SoundService')

local abilitySettings = RP:WaitForChild('AbilitySettings')

local modules = SS:WaitForChild('Modules')
local hitboxModule = require(modules:WaitForChild('HitboxModule'))
local combatHitboxModule = require(script.Parent.Combat.HITBOXING)

local events = RP:WaitForChild('Events')
local vfx = RP:WaitForChild('VFXStorage')
local anims = RP:WaitForChild('Animations')
local sounds = SoundService:WaitForChild('Abilities')

local abilityEvent = events:WaitForChild('Ability')
local camEvent = events:WaitForChild('Camera')

local cooldowns = {}
local shadowTransportVis = {}

PS.PlayerAdded:Connect(function(plr)
	cooldowns[plr.Name] = {}
end)

local function StartCooldown(plr, abilityName)
	cooldowns[plr.Name][abilityName] = os.time()
end

local function getControlPoint(p0, p2, dist, hm)
	local y = math.max(p0.y, p2.y) + (dist * hm)
	local x = (p0.x + p2.x)/2
	local z = (p0.z + p2.z)/2

	return CFrame.new(x, y, z)
end

local function getBezierPos(p0, p1, p2, t)
	local x = (1-t)^2 * p0.x+ 2*(1-t)*t * p1.x + t^2 * p2.x
	local y = (1-t)^2 * p0.y + 2*(1-t)*t * p1.y + t^2 * p2.y
	local z = (1-t)^2 * p0.z + 2*(1-t)*t * p1.z + t^2 * p2.z

	return Vector3.new(x, y, z)
end

local function leapTo(hmrp, target:CFrame, heightMultiplier, defLeapTime)
	local MIN_LEAP_TIME = 1

	local origin = hmrp.CFrame

	local horizontalDist = (target.Position - origin.Position).Magnitude

	--create p0 p1 p2
	local p2 = target.Position

	local p1 = getControlPoint(origin.Position, p2, horizontalDist, heightMultiplier)
	if heightMultiplier == 0 then
		local y = (origin.Position.y + p2.y)/2
		local x = (origin.Position.x + p2.x)/2
		local z = (origin.Position.z + p2.z)/2
		p1 = CFrame.new(x, y, z)
	end

	--time related variables
	local progress = 0

	local duration = math.max(MIN_LEAP_TIME, horizontalDist/35)
	if defLeapTime then duration = defLeapTime end

	local connection

	--connection
	connection = game["Run Service"].Heartbeat:Connect(function(dt)
		progress += dt/duration

		if progress >= 1 then
			connection:Disconnect()
			hmrp.CFrame = target
			return
		end

		--easing
		local easedProgress
		if progress < 0.5 then
			--quad in
			easedProgress = 2 * progress * progress
		else
			--quad out
			easedProgress = 1 - 2 * (1 - progress) * (1 - progress)
		end

		local newPosCF = CFrame.new(getBezierPos(origin.Position, p1, p2, easedProgress))
		local newRotCF = origin:Lerp(target, easedProgress)

		--set cframe to new cframe
		hmrp.CFrame = newPosCF * newRotCF.Rotation
	end)
end

local function GlitchCloak(plr)
	local char = plr.Character
	local torso = char.Torso
	
	local cloak = torso:FindFirstChild('GlitchCloakFX')
	
	if cloak then
		-- If there is already a cloak on the player, toggle it on/off
		
		for i, v in pairs(cloak:GetChildren()) do
			if v:IsA('ParticleEmitter') then
				v.Enabled = not v.Enabled
			end
		end
		
		local burstSound = cloak.GlitchLoop
		if burstSound.isPlaying then
			burstSound:Stop()
		else
			burstSound:Play()
		end
	else
		-- If there is no cloak on the player, create one
		cloak = vfx.GlitchCloakFX:Clone()
		cloak.ToTorso.Part1 = torso
		cloak.CFrame = torso.CFrame
		cloak.Parent = torso
		
		cloak.GlitchLoop:Play()
	end
end

local function GlitchMask(plr)
	local char = plr.Character
	local head = char.Head

	local mask = head:FindFirstChild('GlitchMaskFX')

	if mask then
		-- If there is already a cloak on the player, toggle it on/off

		mask.Particles.Enabled = not mask.Particles.Enabled
	else
		-- If there is no cloak on the player, create one
		local maskModel = vfx.GlitchMaskModel:Clone()
		mask = maskModel.GlitchMaskFX
		
		mask.ToHead.Part1 = head
		maskModel:PivotTo(head.CFrame)
		mask.Parent = head
		maskModel:Destroy()
	end
end

local function GlitchTeleport(plr, mouseHit)
	local char = plr.Character
	local root = char.HumanoidRootPart
	
	local offsetLocation = mouseHit * CFrame.new(Vector3.new(0, 3, 0))
	local teleportFX = vfx.GlitchTeleportFX:Clone()
	teleportFX.CFrame = offsetLocation
	teleportFX.Parent = workspace
	task.wait(0.1)
	teleportFX.Sparks:Emit(30)
	task.wait(0.1)
	teleportFX.Glitch:Emit(50)
	
	local burstSound = teleportFX.GlitchBurst
	burstSound:Play()
	
	root.CFrame = offsetLocation
	
	game.Debris:AddItem(teleportFX, 15)
end

local function TimeToggle(plr)
	local allModels = workspace:FindFirstChild(plr.Name.." allModels")
	abilityEvent:FireClient(plr, 2, 3)
	
	if allModels then
		--untoggle
		allModels:Destroy()
		return
	end
	--toggle

	local allModels = Instance.new('Folder', workspace)
	allModels.Name = plr.Name.." allModels"
end

local function AfterImage(plr, currColor)
	local allModels = workspace:FindFirstChild(plr.Name.." allModels")
	if not allModels then return end
	
	local char = plr.Character
	local newModel = Instance.new('Model')

	for _,v in pairs(char:GetDescendants()) do
		if v:isA("Part") or v:isA("MeshPart") then
			local newV = v:Clone()
			newV.CanCollide = false
			newV.CanTouch = false
			newV.CanQuery = false
			newV.Anchored = true
			newV.Transparency = 1
			newV.Color = currColor
			for i, g in pairs(newV:GetChildren()) do
				if g:IsA('Motor6D') or g:IsA('Decal') or g:IsA('Weld') or g:IsA('BallSocketConstraint') or g:IsA('WeldConstraint') then
					g:Destroy()
				end
			end
			newV.Parent = newModel
		end
	end

	local MAX_MODELS = 20
	if #allModels:GetChildren()+1 > MAX_MODELS then
		allModels:GetChildren()[1]:Destroy()
	end
	
	newModel.Parent = allModels
end

local function AfterImageCheck(plr, currColor)
	local tsInfo = TweenInfo.new(0.1)
	local TS = game:GetService('TweenService')
	
	local cd = SS:FindFirstChild(plr.Name..' AfterImageCD')
	if not cd then
		cd = Instance.new('Folder', SS)
		cd.Name = plr.Name..' AfterImageCD'
		game.Debris:AddItem(cd, 0.1)
		
		AfterImage(plr, currColor)
	end
end

local function TimeReverse(plr)
	local char = plr.Character
	local root = char.HumanoidRootPart
	
	local allModels = workspace:FindFirstChild(plr.Name.." allModels")
	--toggled off
	if not allModels then return end

	local tsInfo = TweenInfo.new(0.1)
	local TS = game:GetService('TweenService')
	local blue = Color3.new(0, 0, 1)
	local green = Color3.new(0, 1, 0)
	local red = Color3.new(1, 0, 0)
	local currColor = Color3.new(1, 0, 0)

	local currInvis = {}
	local function InvisChar()
		for _,v in pairs(char:GetDescendants()) do
			if v:isA("Part") or v:isA("MeshPart") or v:isA("Decal") then
				if v.Transparency == 0 then
					v.Transparency = 1
					table.insert(currInvis, v)
				end
			end
		end
	end

	local function UnInvisChar()
		for i, v in currInvis do
			v.Transparency = 0
		end
		table.clear(currInvis)
	end

	local function AfterImageFlash()
		for i = #allModels:GetChildren(),1,-1 do
			task.spawn(function()
				local currModel = allModels:GetChildren()[i]

				for _,part in pairs(currModel:GetChildren()) do
					TS:Create(part, tsInfo, {Transparency = 0}):Play()
				end
				task.wait(0.1)
				for _,part in pairs(currModel:GetChildren()) do
					TS:Create(part, tsInfo, {Color = red}):Play()
					TS:Create(part, tsInfo, {Transparency = 1}):Play()
				end
			end)
			task.wait(0.04)
		end
	end
	
	local function TimeStop()
		abilityEvent:FireAllClients(2,1)
		local tsInfo = TweenInfo.new(0.3)
		local horror = sounds.Horror
		local alarm = sounds.Alarm
		horror.Volume = 0.1
		alarm.Volume = 0
		TS:Create(alarm, tsInfo, {Volume = 1}):Play()
		horror:Play()
		alarm:Play()
		task.wait(6.2)
		sounds.GlitchBoom:Play()
		task.wait(0.1)
		task.delay(8, function()
			local tsInfo2 = TweenInfo.new(3)
			TS:Create(horror, tsInfo2, {Volume = 0}):Play()
			horror:Stop()
		end)
	end
	
	local function TimeResume()
		task.spawn(function()
			abilityEvent:FireAllClients(2,2)

			local boom = sounds.SonicBoom
			local heart = sounds.TinnitusHeartbeat
			heart.Volume = 0.5
			boom:Play()
			heart:Play()
			
			local tsInfo = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 5)
			TS:Create(heart, tsInfo, {Volume = 0}):Play()
		end)
	end
	
	local function ReverseCloak()
		local cloak = vfx.ReverseCloakFX:Clone()
		local torso = char.Torso
		cloak.ToTorso.Part1 = torso
		cloak.CFrame = torso.CFrame
		cloak.Parent = workspace
		
		task.wait(6)
		local tsInfo = TweenInfo.new(3)
		TS:Create(cloak.Sparks, tsInfo, {Rate = 0})
		task.wait(4)
		cloak:Destroy()
	end
	
	TimeStop()
	InvisChar()
	AfterImageFlash()
	
	char.HumanoidRootPart.CFrame = allModels:GetChildren()[1].HumanoidRootPart.CFrame
	UnInvisChar()
	TimeResume()
	ReverseCloak()
	
	allModels:Destroy()
	local newAllModels = Instance.new('Folder', workspace)
	newAllModels.Name = plr.Name.." allModels"
end

local function ToggleAnchor(char, val)
	for i, v in pairs(char:GetChildren()) do
		if v:IsA('Part') then
			v.Anchored = val
		end
	end
end

local function TimeFreeze(plr, target)
	ToggleAnchor(target, true)
	local freeze = sounds.Freeze:Clone()
	freeze.Parent = target
	freeze:Play()
	
	abilityEvent:FireAllClients(2, 4, target.Name)
	local durr = abilitySettings.TimeFreezeDURR.Value
	task.wait(durr)
	ToggleAnchor(target, false)
end

local function TelekinesisDagger(plr, target)
	local DAGGER_COUNT = 3
	local SPEED = 10--studs per second
	local ACCELERATION = 5
	local HOLD_TIME = 1
	local DECAY_TIME = 1
	local DURATION = 4 + HOLD_TIME + DECAY_TIME
	local DMG = 20
	
	local daggers = {}
	local hitboxes = {}
	local startCFs = {}
	
	local dagFolder = Instance.new('Folder', workspace)
	dagFolder.Name = plr.Name.." daggers"
	
	local startRoot = plr.Character.HumanoidRootPart.CFrame
	
	for i=1, DAGGER_COUNT, 1 do
		--create daggers around the player
		local dagger = vfx.Dagger:Clone()
		
		local yOffset = math.random(2, 7)
		local xOffset = math.random(-5, 5)
		local zOffset = math.random(-5, 5)
		
		local startCF =  CFrame.lookAt(plr.Character.HumanoidRootPart.Position + Vector3.new(xOffset, -2, zOffset), target.Position)
		local finalStartCF =  CFrame.lookAt(plr.Character.HumanoidRootPart.Position + Vector3.new(xOffset, yOffset, zOffset), target.Position)
		
		dagger:PivotTo(startCF)
		
		local hitbox = hitboxModule.New()
		hitbox.size = Vector3.new(2, 2, 2)
		hitbox.onTouch = function(hit)
			local isPlayer = game.Players:FindFirstChild(hit.Parent.Name)
			
			if isPlayer and not (hit.Parent.Name == plr.Name) then
				dagger.PrimaryPart.Damage:Play()
				local hum = hit.Parent.Humanoid
				hum:TakeDamage(DMG)
			end
		end

		table.insert(daggers, dagger)
		table.insert(hitboxes, hitbox)
		table.insert(startCFs, finalStartCF)
		
		game.Debris:AddItem(dagger, DURATION)
		task.delay(DURATION, function()
			hitbox:Destroy()
		end)
		
		dagger.Parent = dagFolder
	end
	
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params:AddToFilter(plr.Character)
	params:AddToFilter(dagFolder)
	
	local connection
	local speed2 = SPEED
	
	--to start (raise up from ground)
	connection = game["Run Service"].Heartbeat:Connect(function(dt)
		for i in daggers do
			local dagger = daggers[i]
			local startCF = startCFs[i]

			local origin = dagger.PrimaryPart.Position
			local dir = (startCF.Position-dagger.PrimaryPart.Position).Unit
			local prog = speed2*dt
			local dist = (startCF.Position-dagger.PrimaryPart.Position).Magnitude
			
			if dist<prog then
				connection:Disconnect()
				dagger:PivotTo(startCF)
			else
				local currCF = dagger.PrimaryPart.CFrame + (dir*prog)
				dagger:PivotTo(currCF)
			end
		end

		speed2+=ACCELERATION
	end)
	
	task.wait(HOLD_TIME)
	for i, v in daggers do
		v.PrimaryPart.Throw:Play()
	end
	
	for i, v in hitboxes do
		v:Start()
	end
	
	local decayInfo = TweenInfo.new(DECAY_TIME*(2/3), Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, DECAY_TIME/3)
	
	--to target
	connection = game["Run Service"].Heartbeat:Connect(function(dt)
		for i in daggers do
			local dagger = daggers[i]
			local hitbox = hitboxes[i]
			
			--stop movement if it hits an obstacle
			if not dagger or not dagger.PrimaryPart or not dagger.PrimaryPart.Position then
				connection:Disconnect()
			end
			local origin = dagger.PrimaryPart.Position
			local dir = (target.Position-dagger.PrimaryPart.Position).Unit
			local dist = SPEED*dt
			
			local result = workspace:Raycast(origin, dir * dist, params)--shoot a ray .5 studs ahead
			if result then
				--hit an obstacle
				table.remove(daggers, table.find(daggers, dagger))
				table.remove(hitboxes, table.find(hitboxes, hitbox))

				dist = result.Distance
				local currCF = dagger.PrimaryPart.CFrame + (dir*dist)

				dagger:PivotTo(currCF)
				hitbox.cframe = currCF
				
				dagger.Attachment:Destroy()
				dagger.PrimaryPart.Anchored = false
				dagger.WeldConstraint.Part1 = result.Instance
				
				dagger.PrimaryPart.Hit:Play()
				
				TS:Create(dagger.PrimaryPart, decayInfo, {Transparency = 1}):Play()
			else
				local currCF = dagger.PrimaryPart.CFrame + (dir*dist)

				dagger:PivotTo(currCF)
				hitbox.cframe = currCF
			end
		end
		
		SPEED+=ACCELERATION
	end)
	
	task.wait(DURATION)
	
	connection:Disconnect()
	
	for i, v in daggers do
		v.Attachment:Destroy()
		v.PrimaryPart.Anchored = false
		v.PrimaryPart.CanCollide = true
		
		v.PrimaryPart.Stop:Play()
		
		TS:Create(v.PrimaryPart, decayInfo, {Transparency = 1}):Play()
	end
	table.clear(daggers)
	table.clear(hitboxes)
	
end

local function PlacePortal(plr, targetSurface, mouseHit, mouseTarget, portalObj)
	--place portal object on surface
	portalObj.Position = mouseHit.Position
	
	--rotate portal object based on surface normal
	
	if not (targetSurface == Enum.NormalId.Top or targetSurface == Enum.NormalId.Bottom) then
		--leave the same if it is the top or bottom
		--otherwise, rotate it 90 degrees on x axis
		
		portalObj.Orientation += Vector3.new(90, 0, 0)
		
		--shoot a ray cast out of both sides of the portal object to check if it is againist the wall properly
		local dist = 4
		local resultForward = workspace:Raycast(portalObj.Position, portalObj.CFrame.UpVector*dist)
		local resultBackward = workspace:Raycast(portalObj.Position, -portalObj.CFrame.UpVector*dist)
		
		if not ((resultForward and resultForward.Instance == mouseTarget) or (resultBackward and resultBackward.Instance == mouseTarget)) then
			--if it isn't againist the object, then rotate it 90 degrees on y axis
			portalObj.Orientation += Vector3.new(0, 90, 0)
		end
	end
end

local function PortalOpen(plr, targetSurface, mouseHit, mouseTarget)
	--find or create a portal folder
	local portalFolder = workspace:FindFirstChild(plr.Name..' Portals')
	if not portalFolder then
		portalFolder = Instance.new('Folder', workspace)
		portalFolder.Name = plr.Name..' Portals'
	end
	
	--check which portal was placed first
	local portal1 = portalFolder:FindFirstChild('Portal1')
	local portal2 = portalFolder:FindFirstChild('Portal2')
	local portalObj = vfx.Portal2:Clone()
	PlacePortal(plr, targetSurface, mouseHit, mouseTarget, portalObj)
	
	local hitbox1, hitbox2
	
	if portal1 then
			
		local otherPortal = portal1	

		if portal2 then
			--both portals are present, swap portal 2 to 1 and then place a new portal 2
			portal2.Name = 'Portal1'
			portal1:Destroy()
			otherPortal = portal2	
		end
		

		hitbox1 = hitboxModule.New()
		hitbox1.size = Vector3.new(3, 3, 3)

		hitbox2 = hitboxModule.New()
		hitbox2.size = Vector3.new(3, 3, 3)

		hitbox1.onTouch = function(hit)
			local isPlayer = game.Players:FindFirstChild(hit.Parent.Name)

			if isPlayer then
				local hitChar = isPlayer.Character
				hitChar.HumanoidRootPart.CFrame = otherPortal.CFrame
				table.insert(hitbox2.hit, hitChar)

				task.wait(abilitySettings.PortalTeleportCD.Value)
				table.remove(hitbox1.hit, table.find(hitbox1.hit, hitChar))
				table.remove(hitbox2.hit, table.find(hitbox2.hit, hitChar))
			end
		end

		hitbox2.onTouch = function(hit)
			local isPlayer = game.Players:FindFirstChild(hit.Parent.Name)

			if isPlayer then
				local hitChar = isPlayer.Character
				hitChar.HumanoidRootPart.CFrame = portalObj.CFrame
				table.insert(hitbox1.hit, hitChar)

				task.wait(abilitySettings.PortalTeleportCD.Value)
				table.remove(hitbox2.hit, table.find(hitbox2.hit, hitChar))
				table.remove(hitbox1.hit, table.find(hitbox1.hit, hitChar))
			end
		end
		
		otherPortal.Destroying:Connect(function()
			--portal's being swapped
			hitbox1:Destroy()
			hitbox2:Destroy()
		end)
		
		hitbox1.cframe = portalObj.CFrame
		hitbox2.cframe = otherPortal.CFrame
	else
		--neither portal has been placed
		portalObj.Name = 'Portal1'
	end
	
	portalObj.Parent = portalFolder
	
	--play vfx
	task.wait(1)
	portalObj.Start.Startup:Emit(1)
	task.wait(4.5)
	for i,v in pairs(portalObj.Vortex:GetChildren()) do
		v.Enabled = true
	end
	
	if hitbox1 then
		hitbox1:Start()
		hitbox2:Start()
	end
end

local function PortalClose(plr)
	local portalFolder = workspace:FindFirstChild(plr.Name..' Portals')
	
	for _,portalObj in pairs(portalFolder:GetChildren()) do
		for _,attachment in pairs(portalObj:GetChildren()) do
			for _, emitter in pairs(attachment:GetChildren()) do
				emitter.Enabled = false
			end
		end
	end
	
	task.wait(1)
	
	portalFolder:Destroy()
end

local function Homerun(plr, exe)
	local charge = plr:FindFirstChild('HomerunCharge')
	
	if exe then
		local tool = plr.Character:FindFirstChild('BaseballModel')
		if not tool then return end
		
		--move will be started or executed
		if charge then
			--signal to execute
			charge.Value = 1
		else
			charge = Instance.new('IntValue', plr)
			charge.Name = 'HomerunCharge'
			
			local char = plr.Character
			local animator = char.Humanoid.Animator
			local anim = animator:LoadAnimation(anims.Homerun)
			
			anim:Play(0.5)
			task.wait(0.5)
			anim:AdjustSpeed(0)
			
			local connection
			connection = charge.Changed:Connect(function(val)
				print('changed')
				if val == 1 then
					--execute
					local hmrp = char.HumanoidRootPart
					hmrp.Anchored = true
					
					local target = nil
					local hitbox = hitboxModule.New()
					hitbox.cframe = hmrp.CFrame
					hitbox.offset = CFrame.new(-hmrp.CFrame.LookVector*2)
					hitbox:Draw()
					hitbox.onTouch = function(hit)
						print(hit, hit.Parent ~= char, game.Players:FindFirstChild(hit.Parent.Name), target==nil)
						if hit.Parent ~= char and game.Players:FindFirstChild(hit.Parent.Name) and target == nil then
							target = hit.Parent
						end
					end
					
					hitbox:Start()
					task.wait(0.1)
					hitbox:Destroy()
					
					print(target)
					if target then
						target.HumanoidRootPart.Anchored = true 
						StartCooldown(plr, 'Homerun')
						
						--place scene
						local scene = vfx.HomerunScene:Clone()
						scene:PivotTo(CFrame.new(hmrp.Position + Vector3.new(0, 100, 0)))
						scene.Parent = workspace

						--face camera to scene
						camEvent:FireAllClients(scene.CameraPos.CFrame, true, false)

						--bring players
						local returnCF1 = hmrp.CFrame
						local returnCF2 = target.HumanoidRootPart.CFrame
						hmrp.CFrame = scene.P1Root.CFrame
						target.HumanoidRootPart.CFrame = scene.P2Root.CFrame

						sounds.WarpGlitch:Play()
						task.wait(1.2)					
						anim:AdjustSpeed(0.25)

						task.wait(0.3)	
						--impact frames

						anim:AdjustSpeed(1)
						abilityEvent:FireAllClients(5, 2, scene)
						target.Humanoid:TakeDamage(40)

						task.wait(0.5)

						hmrp.CFrame = returnCF1
						target.HumanoidRootPart.CFrame = returnCF2

						camEvent:FireAllClients(nil, true, false)
						hmrp.Anchored = false
						target.HumanoidRootPart.Anchored = false 
						charge:Destroy()
					else
						anim:AdjustSpeed(1)
						task.wait(0.5)
						
						hmrp.Anchored = false
						charge:Destroy()
					end
				else
					--cancel
					charge:Destroy()
					anim:Stop()
					-- Start cooldown
					StartCooldown(plr, 'HomerunCANCEL')
				end
				connection:Disconnect()
			end)
			
		end
		
	else
		--move will be canceled, CD refunded
		if charge then charge.Value = 2 end
		
	end
end

local function EquipBaseball(plr)
	local tool = vfx['BaseballModel']:Clone()
	local char = plr.Character
	local grip = tool:WaitForChild('ToolGrip')
	
	grip.Parent = char
	tool:PivotTo(char['Right Arm'].CFrame)
	grip.Part0 = char['Right Arm']
	tool.Parent = char
end

local function UnequipBaseball(plr)
	local char = plr.Character
	local tool = char:FindFirstChild('BaseballModel')

	if tool then 
		tool:Destroy()

	end
end

local function Unsheathe(plr, target)
	local char = plr.Character
	local hum = char.Humanoid
	local origin = char.HumanoidRootPart.CFrame

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params:AddToFilter(workspace.Alive)
	params.ExcludeInstances = {char}

	local dir = origin.LookVector
	local maxDist = 50
	local walkspeed = 4
	local flashStepOffset = 3
	local anim = anims.Unsheathe

	local result = workspace:Raycast(origin.Position, dir * maxDist, params)
	if result then
		--Only if a player is hit
		local char = plr.Character
		local AliveData = char.AliveData
		local Perm = AliveData.PermValue
		local Temp = AliveData.TempValue

		local katanaMark = Instance.new('Folder', Perm)
		katanaMark.Name = 'KatanaMark'
		local counter = Instance.new('IntValue', katanaMark)
		
		local mod = Instance.new('Folder', Temp)
		mod.Name = 'Modify'
		local WS = Instance.new('IntValue', mod)
		WS.Name = 'WalkSpeed'
		WS.Value = walkspeed
		local JS = Instance.new('IntValue', mod)
		JS.Name = 'JumpPower'
		JS.Value = hum.JumpPower

		local hitDist = result.Distance
		local flashStep = origin + (dir*(hitDist+flashStepOffset))

		--Freeze all players
		for i,v in pairs(workspace.Alive:GetChildren()) do
			local HMRP = v:FindFirstChild('HumanoidRootPart')
			if(HMRP and plr.Name~=v.Name) then
				HMRP.Anchored = true
			end

			local hum = v:FindFirstChild('Humanoid')
			if hum then
				hum.AutoRotate = false
			end
		end

		--Play animation
		local track = hum.Animator:LoadAnimation(anim)
		track:Play()
		track:AdjustWeight(1)

		--Play sounds
		sounds.Tinnitus:Play()
		sounds.Footsteps:Play()

		--Black and white filter
		local blackAndWhite = Instance.new('ColorCorrectionEffect', game.Lighting)
		blackAndWhite.Saturation = -1
		
		local tempSheathe = vfx.UnsheathObj:Clone()
		tempSheathe.ToolGrip.Part0 = char['Left Arm']
		tempSheathe.Parent = char
		local acessoryKatana = char.AccessoryKatana

		track.KeyframeReached:Connect(function(name)
			if name == 'Swap' then
				tempSheathe.Transparency = 0
				char['Right Arm'].BodyAttach.Sheath.Transparency = 1
				
			elseif name == 'Attach' then
				acessoryKatana.Sheath.Transparency = 0
				tempSheathe:Destroy()
			end
		end)
		
		task.wait(2)
		--flashstep
		char.HumanoidRootPart.CFrame = flashStep

		track.Stopped:Wait()

		--Hit effects
		local hitChar = result.Instance.Parent
		local blood = vfx.SlashBlood:Clone()

		blood.Parent = hitChar
		blood.Splash:Emit(70)
		blood.Blood:Emit(70)
		sounds.FlashSlash:Play()
		blackAndWhite:Destroy()

		--Hit damage

		local damageTable = {
			damage = 12;
			bruise = true;
			stuntime = 0.9;
			Sharp = true;
			blunt = false;
			KB = false;
			AirComboExtend = false;
			ragdollduration = 0;	
		}
		game.ServerStorage.TagHumanoid:Invoke(char, hitChar, damageTable)

		--Restore all players to normal
		mod:Destroy()

		for i,v in pairs(workspace.Alive:GetChildren()) do
			local HMRP = v:FindFirstChild('HumanoidRootPart')
			if(HMRP and plr.Name~=v.Name) then
				HMRP.Anchored = false
			end

			local hum = v:FindFirstChild('Humanoid')
			if hum then
				hum.AutoRotate = true
			end
		end

		--End sounds
		sounds.Tinnitus:Stop()
		sounds.Footsteps:Stop()

	end
end

--local function ToggleParry(plr, toggle)
--	if toggle then
--		--parry activated
--		local AliveData = plr.Character.AliveData
--		local Temp = AliveData.TempValue
		
--		local parry = Instance.new('Folder', Temp)
--		parry.Name = "Parry"
--	else
--		--parry deactivated
--		local AliveData = plr.Character.AliveData
--		local Temp = AliveData.TempValue

--		for i, v in pairs(Temp:GetChildren()) do
--			if v.Name == 'Parry' then
--				v:Destroy()
--			end
--		end
--	end	
--end


local function Slaughter(plr) -- Called whenever the client-side tool detects input and cooldown is validated on server
	local char = plr.Character
	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local katanaMark = Perm.KatanaMark

	local val = katanaMark:GetChildren()[1] -- A tag that records which player currently has the consecutive hits
	local target = val.Name
	local threshold = val.Value -- Hits recorded by combat since unsheathing

	--Must have 7 hits to execute
	if threshold < 7 then return end

	local hitChar = workspace.Alive:FindFirstChild(target)

	for i, v in pairs(workspace.Alive:GetChildren()) do
		local hmrp = v:FindFirstChild('HumanoidRootPart')
		if hmrp then
			hmrp.Anchored = true
		end

		local hum = v:FindFirstChild('Humanoid')
		if hum then
			hum.AutoRotate = false
			
			local disableRotate = Instance.new('Folder', v)
			disableRotate.Name = 'disableRotate'
		end
	end

	local sceneReference = vfx.SlaughterCutscene:Clone() -- Parts with set coordinate frames, used as a reference when moving around the player's in the scene and the cameras
	sceneReference:PivotTo(char.HumanoidRootPart.CFrame * CFrame.new(Vector3.new(0, 0, 0)))

	local charCF = char.HumanoidRootPart.CFrame
	local hitCharCF = hitChar:WaitForChild('HumanoidRootPart').CFrame
	char.HumanoidRootPart.CFrame = sceneReference.ExecuteRoot.CFrame
	hitChar.HumanoidRootPart.CFrame = sceneReference.TargetRoot.CFrame
	sceneReference.Parent = workspace

	abilityEvent:FireAllClients(6, 3, char, hitChar, sceneReference) -- Signal to all clients to run the client-based effects (less strain on server, smoother effects)

	task.wait(12)

	hitChar.HumanoidRootPart.CFrame *= CFrame.new(Vector3.new(0, 50, 0))

	task.wait(15)
	
	char.HumanoidRootPart.CFrame = charCF
	hitChar.HumanoidRootPart.CFrame = hitCharCF
	for i, v in pairs(workspace.Alive:GetChildren()) do
		local hmrp = v:FindFirstChild('HumanoidRootPart')
		if hmrp then
			hmrp.Anchored = false
		end

		local hum = v:FindFirstChild('Humanoid')
		if hum then
			hum.AutoRotate = true
			local disableRotate = v:FindFirstChild('disableRotate')
			disableRotate:Destroy()
		end
	end
	sceneReference:Destroy()
	

	--Hit settings

	local damageTable = {
		damage = 99999;
		bruise = true;
		stuntime = 99999;
		Sharp = true;
		blunt = false;
		KB = false;
		GB = true;
		AirComboExtend = false;
		ragdollduration = 99999;	
	}
	game.ServerStorage.TagHumanoid:Invoke(char, hitChar, damageTable) -- Send this damage information to the damage handler (taghumanoid)
end

local function ShadowLow(plr)
	local char = plr.Character
	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local Temp = AliveData.TempValue
	local shadowStatus = Temp:FindFirstChild('ShadowTransport')
	
	if not shadowStatus then 
		return
	else 
		shadowStatus:Destroy() 
	end
	
	--SPIKE FX
	local shadowFx = workspace:FindFirstChild(plr.Name..'shadestep')
	shadowFx.Primary.Trail.Ground.Enabled = false
	shadowFx.Primary.Ripples.Ground:Emit(3)
	for i, v in pairs(shadowFx.Primary.Spikes:GetChildren()) do
		v:Emit(20)
	end

	--SPIKE SFX
	local submerge2 = sounds.WaterExplosion:Clone()
	submerge2.Parent = char
	submerge2:Play()

	--DESTROY FX AND SFX
	game.Debris:AddItem(submerge2, 7)
	game.Debris:AddItem(shadowFx, 6)

	--DESTROY DATA
	local dodge = Temp:FindFirstChild('Dodged')
	local dashCancel = Temp:FindFirstChild('DisableDash')
	local usingSkill = Temp:FindFirstChild('UsingSkill')
	local mod = Temp:FindFirstChild('Modify')
	
	if dodge then dodge:Destroy() end
	if dashCancel then dashCancel:Destroy() end
	if shadowStatus then shadowStatus:Destroy() end
	if usingSkill then usingSkill:Destroy() end
	if mod then mod:Destroy() end

	--HITBOX
	local Params = {
		damage = 15;
		bruise = true;
		stuntime = 0.5;
		blunt = true;
		GB = true;
		KB = false;
		ragdollduration = 0;	
	}
	
	combatHitboxModule.LingeringHB(AliveData,char,Params,4.5,0.4)

	--UNINVIS
	for i, v in pairs(char:GetDescendants()) do
		if v:IsA('Part') or v:IsA('MeshPart') or v:IsA('BasePart') then
			v.CollisionGroup = 'Player'
		end
	end
	
	local visibleReset = shadowTransportVis[plr.Name]
	for i in visibleReset do
		local v = visibleReset[i]
		if v:IsA('Part') or v:IsA('MeshPart') or v:IsA('BasePart') then
			v.Transparency = 0
		end

		if v:IsA('ParticleEmitter') or v:IsA('Beam') then
			v.Enabled = true
		end
	end
end

local function ShadowHighDash(plr, cf)
	local char = plr.Character
	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local Temp = AliveData.TempValue
	
	local status = Temp:FindFirstChild('ShadowStatus2')
	if not status then
		return
	else
		status:Destroy()
	end
	
	
	local dodge = Temp:FindFirstChild('Dodged')
	if dodge then dodge:Destroy() end

	local HMRP = char.HumanoidRootPart
	local torso = char.Torso

	local params = RaycastParams.new()
	params.ExcludeInstances = {char}
	
	local origin = HMRP.Position
	local direction = cf.LookVector * 200
	
	local result = workspace:Raycast(origin, direction, params)
	if result then
		HMRP.CFrame *= CFrame.new(result.Position)
	else
		HMRP.CFrame *= CFrame.new(origin + direction)
	end
	
	local windVFX = HMRP:FindFirstChild('WindOrb')
	if windVFX then windVFX:Destroy() end
	
	--leapTo(HMRP, target, 0, 1)
	task.wait(1)
	
	--leap finished

	--HITBOX
	local HitParams = {
		damage = 25;
		bruise = true;
		stuntime = 0.5;
		blunt = true;
		GB = true;
		KB = true;
		ragdollduration = 0;	
	}

	HMRP.Anchored = false
	combatHitboxModule.AOEHB(AliveData,char,HitParams,4.5)
	
	local boneFx = vfx.Bone
	local info = TweenInfo.new(0.3)

	for i = 1, 50 do
		local bone = boneFx:Clone()

		-- Random horizontal direction
		local angle = math.rad(math.random(0, 359))
		local direction = Vector3.new(
			math.cos(angle),
			0,
			math.sin(angle)
		)

		local startOffset = direction * math.random(0, 5)

		bone.CFrame =
			HMRP.CFrame
			* CFrame.new(startOffset)
			* CFrame.new(0, -25, 0)
			* CFrame.Angles(
				math.rad(math.random(-180, 180)),
				math.rad(math.random(-180, 180)),
				math.rad(math.random(-180, 180))
			)
		
		bone.Parent = workspace

		-- Mostly vertical movement, with a small outward spread
		local outwardDistance = math.random(2, 6)
		local height = math.random(20, 30)

		local goalPosition =
			HMRP.CFrame
			* CFrame.new(
				direction.X * outwardDistance,
				height,
				direction.Z * outwardDistance
			)

		-- Only a slight additional rotation during the tween
		local smallRotation = CFrame.Angles(
			math.rad(math.random(-15, 15)),
			math.rad(math.random(-15, 15)),
			math.rad(math.random(-15, 15))
		)

		local goal = goalPosition * smallRotation

		TS:Create(bone, info, {
			CFrame = goal
		}):Play()
		
		game.Debris:AddItem(bone, 5)
	end
	
end

local function ShadowHigh(plr)
	local char = plr.Character
	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local Temp = AliveData.TempValue
	
	local shadowStatus = Temp:FindFirstChild('ShadowTransport')

	if not shadowStatus then 
		return
	else 
		shadowStatus:Destroy() 
	end

	local shadowFx = workspace:FindFirstChild(plr.Name..'shadestep')
	shadowFx.Primary.Trail.Ground.Enabled = false
	game.Debris:AddItem(shadowFx, 6)
	
	--DESTROY DATA
	local dashCancel = Temp:FindFirstChild('DisableDash')
	local shadowStatus = Temp:FindFirstChild('ShadowTransport')
	local usingSkill = Temp:FindFirstChild('UsingSkill')
	local mod = Temp:FindFirstChild('Modify')

	if dashCancel then dashCancel:Destroy() end
	if usingSkill then usingSkill:Destroy() end
	if mod then mod:Destroy() end

	local HMRP = char.HumanoidRootPart
	HMRP.Anchored = true
	HMRP.CFrame *= CFrame.new(Vector3.new(0, 20, 0))
	
	local windOrb = vfx.WindOrb:Clone()
	windOrb.Parent = HMRP

	--UNINVIS
	for i, v in pairs(char:GetDescendants()) do
		if v:IsA('Part') or v:IsA('MeshPart') or v:IsA('BasePart') then
			v.CollisionGroup = 'Player'
		end
	end

	local visibleReset = shadowTransportVis[plr.Name]
	for i in visibleReset do
		local v = visibleReset[i]
		if v:IsA('Part') or v:IsA('MeshPart') or v:IsA('BasePart') then
			v.Transparency = 0
		end

		if v:IsA('ParticleEmitter') or v:IsA('Beam') then
			v.Enabled = true
		end
	end
	
	local shadowStatus2 = Instance.new('Folder', Temp)
	shadowStatus2.Name = 'ShadowStatus2'
	
	task.wait(1)
	
	local inputShadow = vfx.ShadowUp:Clone()
	inputShadow.Parent = plr.PlayerGui
	
	task.wait(3)
	if inputShadow then inputShadow:Destroy() end
	print('a')
	ShadowHighDash(plr)
end

local function ShadowTravel(plr, visibleReset)
	local char = plr.Character
	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local Temp = AliveData.TempValue
	
	local shadowSpeed = 40
	
	local shadowInfo = TweenInfo.new(1)
	local goal = {Transparency = 1, Position = char.HumanoidRootPart.Position+Vector3.new(0, -5, 0)}
	
	for i, v in pairs(char:GetDescendants()) do
		if v:IsA('Part') or v:IsA('MeshPart') or v:IsA('BasePart') then
			if v.Transparency == 0 then
				if v.Parent == char then
					local shadowPart = v:Clone()
					game.Debris:AddItem(shadowPart, 2)
					shadowPart.Color = Color3.new(0, 0, 0)
					shadowPart.Anchored = true
					for i, v in pairs(shadowPart:GetDescendants()) do
						v:Destroy()
					end

					shadowPart.CanCollide = false
					shadowPart.Parent = workspace
					TS:Create(shadowPart, shadowInfo, goal):Play()
				end
				
				v.Transparency = 1
				table.insert(visibleReset, v)
			end
			v.CollisionGroup = 'Shadow'
		end
	end

	shadowTransportVis[plr.Name] = visibleReset

	local dodge = Instance.new('Folder', Temp)
	dodge.Name = "Dodged"
	local dashCancel = Instance.new('Folder', Temp)
	dashCancel.Name = "DisableDash"
	local skillUse = Instance.new('Folder', Temp)
	skillUse.Name = "UsingSkill"
	local shadowStatus = Instance.new('Folder', Temp)
	shadowStatus.Name = "ShadowTransport"
	
	local mod = Instance.new('Folder', Temp)
	mod.Name = 'Modify'
	local WS = Instance.new('IntValue', mod)
	WS.Name = 'WalkSpeed'
	WS.Value = shadowSpeed
	local JS = Instance.new('IntValue', mod)
	JS.Name = 'JumpPower'
	JS.Value = 5
	
	local shadowFx = vfx.ShadeStepFX:Clone()
	shadowFx:PivotTo(char.HumanoidRootPart.CFrame)
	shadowFx.Root.ToRoot.Part1 = char.HumanoidRootPart
	shadowFx.Parent = workspace
	shadowFx.Primary.Ripples.Ground:Emit(3)
	shadowFx.Name = plr.Name..'shadestep'
	
	for i, v in pairs(shadowFx.Primary.Spikes:GetChildren()) do
		v:Emit(50)
	end
	local submerge = sounds.Submerge:Clone()
	submerge.Parent = char
	submerge:Play()
	game.Debris:AddItem(submerge, 7)
	
	local inputShadow = vfx.ShadowTravel:Clone()
	inputShadow.Parent = plr.PlayerGui
	
	task.wait(5)
	
	if inputShadow then inputShadow:Destroy() end
	ShadowLow(plr)
end

local function Flick(plr)
	local char = plr.Character
	local hmrp = char.HumanoidRootPart
	local animator = char.Humanoid.Animator


	local skeletonModel = char:FindFirstChild('ExtinctionModel')
	if not skeletonModel then return end
	hmrp.Anchored = true

	skeletonModel:PivotTo(hmrp.CFrame)

	local skeleAnimator = skeletonModel.ExtinctionModel.AnimationController.Animator
	local flickTrack = skeleAnimator:LoadAnimation(anims.SFlick)
	flickTrack:Play()

	skeletonModel.Script.Enabled = false
	print('FLICKED')
	local finalCF = hmrp.CFrame * CFrame.new(0, 0, 15)
	local info = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, true)
	TS:Create(skeletonModel.PrimaryPart, info, {CFrame = finalCF}):Play()
	finalCF = hmrp.CFrame * CFrame.new(0, 30, 40)
	TS:Create(skeletonModel.ExtinctionModel.Skeleton, info, {CFrame = finalCF}):Play()

	task.wait(0.6)

	local track = animator:LoadAnimation(anims.ScytheLeap)
	track:Play()

	leapTo(hmrp, hmrp.CFrame*CFrame.new(0, 0, -40), 2)

	task.wait(0.2)
	skeletonModel.Script.Enabled = true

	task.wait(1.3)

	local y = hmrp.Position.Y
	local yStart = y-6
	local count = 20
	for i=1, count, 1 do
		local deb = Instance.new('Part')
		deb.Color = Color3.new(0.2, 0.2, 0.2)
		deb.CanCollide = false
		deb.CanTouch = false
		deb.CanQuery = false
		deb.Anchored = true

		local size = math.random(2, 4)
		deb.Size = Vector3.new(size, size, size)

		deb.Position = hmrp.Position + Vector3.new(0,yStart,0)

		local randZ = math.random(-8, 8)
		local randX = math.random(-8, 8)

		local randRotX = math.random(-180, 180)
		local randRotY = math.random(-180, 180)
		local randRotZ = math.random(-180, 180)

		local finalPos = (hmrp.CFrame * CFrame.new(randX, 0, randZ)).Position - Vector3.new(0, 3, 0)
		local finalOri = Vector3.new(randRotX, randRotY, randRotZ)

		local info = TweenInfo.new(0.4)
		local trainfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 4)

		deb.Parent = workspace
		TS:Create(deb, info, {Position = finalPos, Orientation = finalOri}):Play()
		TS:Create(deb, trainfo, {Transparency = 1}):Play()

		game.Debris:AddItem(deb, 10)
	end

	hmrp.Anchored = false
end

local function Transport(plr)
	local char = plr.Character
	local hmrp = char.HumanoidRootPart
	local model = vfx.GrabModel:Clone()

	--HAND SCENE

	hmrp.Anchored = true
	model:PivotTo(hmrp.CFrame)
	model.Parent = workspace
	for i, v in pairs(model.Folder:GetChildren()) do
		local modAnimator = v.AnimationController.Animator
		local anim = anims.SGrab
		local track = modAnimator:LoadAnimation(anim)
		track:Play()
	end
	
	game.Debris:AddItem(model, 15)

	local visibleReset = {}

	for i, v in pairs(char:GetDescendants()) do
		if v:IsA('ParticleEmitter') or v:IsA('Beam') then
			if v.Enabled then
				v.Enabled = false
				table.insert(visibleReset, v)
			end
		end
	end
	
	task.wait(0.5)
	hmrp.Anchored = false
	
	--START TRAVEL
	ShadowTravel(plr, visibleReset)
end

local function Summon(plr)
	local char = plr.Character
	local hmrp = char.HumanoidRootPart
	local model = vfx.ExtinctionModel:Clone()
	local skele = model.ExtinctionModel
	local durr = abilitySettings.SummonDURR.Value

	model:PivotTo(hmrp.CFrame)
	model.Script.Value.Value = hmrp
	model.Script.Enabled = true
	model.Parent = char

	task.wait(1)
	local modAnimator = skele.AnimationController.Animator
	local anim = anims.SSummon
	local track = modAnimator:LoadAnimation(anim)
	track:Play()
	--track:AdjustSpeed(0.1)

	task.wait(0.4)
	skele.Skeleton.Transparency = 0
	task.wait(4.2)
	local idleAnim = anims.SIdle
	local idleTrack = modAnimator:LoadAnimation(idleAnim)
	idleTrack:Play()

	local rArmAura = vfx.ExtinctAura.LimbAura:Clone()
	local lArmAura = vfx.ExtinctAura.LimbAura:Clone()
	local rLegAura = vfx.ExtinctAura.LimbAura:Clone()
	local lLegAura = vfx.ExtinctAura.LimbAura:Clone()
	local headAura = vfx.ExtinctAura.LimbAura:Clone()
	headAura.Parent = char.Head
	rArmAura.Parent = char['Right Arm']
	lArmAura.Parent = char['Left Arm']
	rLegAura.Parent = char['Right Leg']
	lLegAura.Parent = char['Left Leg']

	local torsoAura = vfx.ExtinctAura.TorsoAura:Clone()
	torsoAura.Parent = char.Torso
	torsoAura.SpinningPart.Position = hmrp.Position - Vector3.new(0, 2.3, 0)
	torsoAura.SpinningPart.WeldConstraint.Part1 = hmrp

	task.delay(durr, function()
		local unsumAnim = anims.SUnsummon
		local unsumTrack = modAnimator:LoadAnimation(unsumAnim)
		unsumTrack:Play(0.2, 1)
		unsumTrack:AdjustSpeed(0.1)
		task.wait(6)
		model:Destroy()
		headAura:Destroy()
		rArmAura:Destroy()
		lArmAura:Destroy()
		rLegAura:Destroy()
		lLegAura:Destroy()
	end)
end

local function Skewer(plr)
	local char = plr.Character
	local hmrp = char.HumanoidRootPart
	local animator = char.Humanoid.Animator
	local y = hmrp.Position.Y
	local yStart = y-20

	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local Temp = AliveData.TempValue
	
	local skillUse = Instance.new('Folder', Temp)
	skillUse.Name = "UsingSkill"
	hmrp.Anchored = true
	local track = animator:LoadAnimation(anims.ScytheSkewer)
	track:Play()
	
	task.wait(0.4)

	local count = 20
	for i=1, count, 1 do
		local skeletonArm = vfx.LowPolyArm:Clone()
		skeletonArm.Skeleton.Position = hmrp.Position + Vector3.new(0,yStart,0)

		local randZ = math.random(-30, -8)
		local randX = math.random(-math.abs(randZ)/2, math.abs(randZ)/2)

		local randRotX = math.random(-40, 40)
		local randRotY = math.random(-180, 180)
		local randRotZ = math.random(-40, 40)

		local finalPos = (hmrp.CFrame * CFrame.new(randX, 0, randZ)).Position
		local finalOri = skeletonArm.Skeleton.Orientation + Vector3.new(randRotX, randRotY, randRotZ)

		local info = TweenInfo.new(math.abs(randZ)/math.random(14,16))
		local trainfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 2)

		skeletonArm.Parent = workspace
		TS:Create(skeletonArm.Skeleton, info, {Position = finalPos, Orientation = finalOri}):Play()
		TS:Create(skeletonArm.Skeleton, trainfo, {Transparency = 1}):Play()
		game.Debris:AddItem(skeletonArm, 5)
	end

	count = 30
	for i=1, count, 1 do
		local deb = Instance.new('Part')
		deb.Color = Color3.new(0.2, 0.2, 0.2)
		deb.CanCollide = false
		deb.CanTouch = false
		deb.CanQuery = false
		deb.Anchored = true

		local size = math.random(2, 5)
		deb.Size = Vector3.new(size, size, size)

		deb.Position = hmrp.Position + Vector3.new(0,yStart,0)

		local randZ = math.random(-30, -8)
		local randX = math.random(-math.abs(randZ)/2, math.abs(randZ)/2)

		local randRotX = math.random(-180, 180)
		local randRotY = math.random(-180, 180)
		local randRotZ = math.random(-180, 180)

		local finalPos = (hmrp.CFrame * CFrame.new(randX, 0, randZ)).Position - Vector3.new(0, 3, 0)
		local finalOri = Vector3.new(randRotX, randRotY, randRotZ)

		local info = TweenInfo.new(math.abs(randZ)/30, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0.3)
		local trainfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 4)

		deb.Parent = workspace
		TS:Create(deb, info, {Position = finalPos, Orientation = finalOri}):Play()
		TS:Create(deb, trainfo, {Transparency = 1}):Play()

		game.Debris:AddItem(deb, 10)
	end
	

	local damageTable = {
		damage = 20;
		bruise = true;
		stuntime = 0.9;
		Sharp = true;
		blunt = false;
		GB = true;
		KB = true;
		AirComboExtend = false;
		ragdollduration = 0;	
	}
	
	local offset = Vector3.new(0, 0, -16)
	local size = Vector3.new(10, 7, 20)
	
	combatHitboxModule.DistHB(AliveData,char,damageTable,offset,size)

	task.wait(1.2)
	skillUse:Destroy()
	hmrp.Anchored = false
end

abilityEvent.OnServerEvent:Connect(function(player, spec, abilityID, ...)
	local args = {...}	
	
	local stunned = SS.Stunned:FindFirstChild(player.Name)
	if stunned then return end
	
	if spec == 1 then
		-- Glitch Spec
		
		--if playerHasSpec then
		if abilityID == 1 then
			-- Cloak
			local abilityName = 'Glitch Cloak'
				
			-- Check cooldown
			local CD_TIME = abilitySettings.GlitchCloakCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]
			
			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end
			
			-- Start cooldown
			StartCooldown(player, abilityName)
			
			-- Execute ability
			GlitchCloak(player)
	
		elseif abilityID == 2 then
			-- Mask
			local abilityName = 'Glitch Mask'

			-- Check perms
			--local playerHasAbility = playerHasSpec:FindFirstChild(abilityName)
			--if playerHasAbility then


			-- Check cooldown
			local CD_TIME = abilitySettings.GlitchMaskCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				-- Still on cooldown
				print('Cooldown is still active')
				return
			end

			--Start cooldown
			StartCooldown(player, abilityName)

			-- Execute ability
			GlitchMask(player)

		elseif abilityID == 3 then
			-- Teleport
			local abilityName = 'Glitch Teleport'

			-- Check perms
			--local playerHasAbility = playerHasSpec:FindFirstChild(abilityName)
			--if playerHasAbility then


			-- Check cooldown
			local CD_TIME = abilitySettings.GlitchTeleportCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				-- Still on cooldown
				print('Cooldown is still active')
				return
			end

			-- Start cooldown
			StartCooldown(player, abilityName)
			
			-- Get params
			local mouseHit = args[1]

			-- Execute ability
			GlitchTeleport(player, mouseHit)
		
		end
	elseif spec == 2 then
		-- Time Spec


		--if playerHasSpec then
		if abilityID == 1 then
			-- Toggle
			local abilityName = 'Time Toggle'

			-- Check cooldown
			local CD_TIME = abilitySettings.TimeToggleCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end

			-- Start cooldown
			StartCooldown(player, abilityName)

			-- Execute ability
			TimeToggle(player)

		elseif abilityID == 2 then
			-- After Image
			local abilityName = 'Time After Image'

			-- Check perms
			--local playerHasAbility = playerHasSpec:FindFirstChild(abilityName)
			--if playerHasAbility then

			-- Check cooldown
			local CD_TIME = abilitySettings.TimeAfterImageCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end

			-- Start cooldown
			StartCooldown(player, abilityName)
			
			-- Execute ability
			local currColor = args[1]
			AfterImageCheck(player, currColor)
				
		elseif abilityID == 3 then
			-- Reverse
			local abilityName = 'Time Reverse'

			-- Check perms
			--local playerHasAbility = playerHasSpec:FindFirstChild(abilityName)
			--if playerHasAbility then


			-- Check cooldown
			local CD_TIME = abilitySettings.TimeReverseCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end

			-- Start cooldown
			StartCooldown(player, abilityName)

			-- Execute ability
			TimeReverse(player)
			
		elseif abilityID == 4 then
			-- Reverse
			local abilityName = 'Time Freeze'

			-- Check perms
			--local playerHasAbility = playerHasSpec:FindFirstChild(abilityName)
			--if playerHasAbility then


			-- Check cooldown
			local CD_TIME = abilitySettings.TimeFreezeCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end
			
			local target = args[1]
			
			local isPlayer = game.Players:FindFirstChild(target.Name)
			local MAX_DIST = abilitySettings.TimeFreezeRange.Value
			if isPlayer then
				local dist = (target.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
				if dist < MAX_DIST then
					-- Start cooldown
					StartCooldown(player, abilityName)

					-- Execute ability
					TimeFreeze(player, target)
				end
			end
		end
	elseif spec == 3 then
		-- Telekinesis Spec
		
		if abilityID == 1 then
			-- dagger
			local abilityName = 'Telekinesis Dagger'

			-- Check cooldown
			local CD_TIME = abilitySettings.TelekinesisDaggerCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end

			local target = args[1]

			-- Start cooldown
			StartCooldown(player, abilityName)

			-- Execute ability
			TelekinesisDagger(player, target)
			--end
		end
	elseif spec == 4 then
		-- Portal Spec

		if abilityID == 1 then
			-- open
			local abilityName = 'Portal Open'

			-- Check cooldown
			local CD_TIME = abilitySettings.PortalOpenCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end

			local targetSurface = args[1]
			local mouseHit = args[2]
			local mouseTarget = args[3]

			-- Start cooldown
			StartCooldown(player, abilityName)

			-- Execute ability
			PortalOpen(player, targetSurface, mouseHit, mouseTarget)
		elseif abilityID == 2 then
			-- open
			local abilityName = 'Portal Close'

			-- Check perms
			--local playerHasAbility = playerHasSpec:FindFirstChild(abilityName)
			--if playerHasAbility then


			-- Check cooldown
			local CD_TIME = abilitySettings.PortalCloseCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end

			-- Start cooldown
			StartCooldown(player, abilityName)

			-- Execute ability
			PortalClose(player)
		end
	elseif spec == 5 then
	-- Baseball Spec

		if abilityID == 1 then
			-- open
			local abilityName = 'Baseball Equip'

			-- Check cooldown
			local CD_TIME = abilitySettings.EquipCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end

			-- Start cooldown
			StartCooldown(player, abilityName)
			
			if player.Character:FindFirstChild('BaseballModel') then
				-- Execute ability
				UnequipBaseball(player)
				
			else
				-- Execute ability
				EquipBaseball(player)
			end
			--end
		elseif abilityID == 2 then
			-- open
			local abilityName = 'Homerun'

			-- Check perms
			--local playerHasAbility = playerHasSpec:FindFirstChild(abilityName)
			--if playerHasAbility then

			-- Check cooldown
			local CD_TIME = abilitySettings.BaseballHomerunCD.Value
			local CANCEL_TIME = abilitySettings.BaseballHomerunCancelCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]
			local lastUsedCANCEL = cooldowns[player.Name][abilityName..'CANCEL']
			
			print('server cancel')
			if (lastUsed and (currentTime - lastUsed) < CD_TIME) or (lastUsedCANCEL and (currentTime - lastUsedCANCEL) < CANCEL_TIME) then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end
			
			print('flowwed')
			local execute = args[1]
			-- Execute ability
			Homerun(player, execute)
		end

	elseif spec == 6 then
		-- Katana Spec

		-- Check perms

		if abilityID == 1 then
			-- open
			local abilityName = 'Unsheathe'

			-- Check cooldown
			local CD_TIME = abilitySettings.UnsheathCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end

			-- Start cooldown
			StartCooldown(player, abilityName)

			Unsheathe(player)
		elseif abilityID == 2 then
			---- open
			--local abilityName = 'ToggleParry'

			---- Check cooldown
			--local CD_TIME = abilitySettings.ToggleParryCD.Value
			--local currentTime = os.time()
			--local lastUsed = cooldowns[player.Name][abilityName]

			--if lastUsed and (currentTime - lastUsed) < CD_TIME then
			--	--Still on cooldown
			--	print('Cooldown is still active')
			--	return
			--end

			---- Start cooldown
			--StartCooldown(player, abilityName)

			--local toggle = args[1]
			--ToggleParry(player, toggle)

		elseif abilityID == 3 then
			-- open
			local abilityName = 'Slaughter'

			-- Check cooldown
			local CD_TIME = abilitySettings.SlaughterCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end

			-- Start cooldown
			StartCooldown(player, abilityName)

			Slaughter(player)
		end
	elseif spec == 7 then
		-- Extinction Spec

		-- Check perms

		if abilityID == 1 then
			-- open
			local abilityName = 'Transport'

			-- Check cooldown
			local CD_TIME = abilitySettings.TransportCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]
			
			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end

			-- Start cooldown
			StartCooldown(player, abilityName)
			
			Transport(player)
		elseif abilityID == 2 then
			-- open
			local abilityName = 'Skewer'

			-- Check cooldown
			local CD_TIME = abilitySettings.SkewerCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end

			-- Start cooldown
			StartCooldown(player, abilityName)

			Skewer(player)
		elseif abilityID == 3 then
			-- open
			local abilityName = 'Summon'

			-- Check cooldown
			local CD_TIME = abilitySettings.SummonCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end

			-- Start cooldown
			StartCooldown(player, abilityName)

			Summon(player)
		elseif abilityID == 4 then
			-- open
			local abilityName = 'Flick'

			-- Check cooldown
			local CD_TIME = abilitySettings.FlickCD.Value
			local currentTime = os.time()
			local lastUsed = cooldowns[player.Name][abilityName]

			if lastUsed and (currentTime - lastUsed) < CD_TIME then
				--Still on cooldown
				print('Cooldown is still active')
				return
			end

			-- Start cooldown
			StartCooldown(player, abilityName)

			Flick(player)
		
		elseif abilityID == 5 then
			-- shadow choice
			if args[1] == 1 then
				ShadowLow(player)
			else
				ShadowHigh(player)
			end
			
		elseif abilityID == 6 then
			-- shadow high dash
			ShadowHighDash(player, args[1])
		end
	end
end)