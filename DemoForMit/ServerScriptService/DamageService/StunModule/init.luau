local module = {}

module.Stun = function(char,Duration)

	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local Temp = AliveData.TempValue
	local CDS = AliveData.CDS
	local anims = game.ReplicatedStorage.Animations
	local Subject = char

	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	miscmodule.Destroy(Perm,"Run")
	miscmodule.Create("Temp","Folder",Temp,"Stun",Duration)

	if char.HumanoidRootPart:FindFirstChild("Dash Velocity") then
		char.HumanoidRootPart:FindFirstChild("Dash Velocity"):Destroy()
	end

	for i, v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
		if string.find("Fist",v.Name) then
			v:Stop()
		end
	end 

	local Paranim = char.Humanoid:LoadAnimation(game.ReplicatedStorage.Animations:WaitForChild("Hit"..math.random(1,4)))
	Paranim:Play()
	Paranim:AdjustSpeed(0.88)
	Paranim.Priority = Enum.AnimationPriority.Action3
end

module.Blocked = function(char)

	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local Temp = AliveData.TempValue
	local CDS = AliveData.CDS


	local Paranim = char.Humanoid:LoadAnimation(game.ReplicatedStorage.Animations:WaitForChild("FistBlockReact"))
	Paranim:Play()

	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	miscmodule.PlaySound("Blked",char.HumanoidRootPart)
end

module.Bleed = function(char)

	local fx = game.ReplicatedStorage.Assets.Models.GB.Blod:Clone()
	fx.Parent = char.HumanoidRootPart
	game.Debris:AddItem(fx,2)
	for i,v in pairs(fx:GetDescendants()) do 
		if v:IsA("ParticleEmitter") then
			v:Emit(v.Rate)
		end
	end 

	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	miscmodule.PlaySound("Blood",char.HumanoidRootPart)

end

module.Blunt = function(char)

	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local Temp = AliveData.TempValue
	local CDS = AliveData.CDS
	local anims = game.ReplicatedStorage.Animations

	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	miscmodule.PlayRandomSound("Hit",char.HumanoidRootPart,3)
end

module.KawaiiSub = function(char, hit)

	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	miscmodule.Create("Temp","Folder",char.AliveData.TempValue,"Subbed",0.5)

	local Log = game.ReplicatedStorage.Assets.Models["Dummy Bag/CT3"]:Clone()
	Log.Parent = workspace.Ignore
	Log.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
	Log.Orientation = Vector3.new(math.random(1,255),math.random(1,255),math.random(1,255))
	Log.Sound:Play()
	Log.Sound2:Play()	
	Log.ParticleEmitter.Enabled = true
	Log.PE2.Enabled = true
	spawn(function()	
		task.wait(0.2)
		Log.PE2.Enabled = false
		Log.ParticleEmitter.Enabled = false
	end)
	game.Debris:AddItem(Log,4)


	for i,v in pairs(char:GetDescendants()) do

		if v:IsA("Part") then
			if v.Transparency == 0 then
				v.Transparency = 1
				spawn(function() 
					task.wait(0.8)
					v.Transparency = 0 
				end)
			end
		end

		if v:IsA("Decal") then
			if v.Transparency == 0 then
				v.Transparency = 1
				spawn(function() 
					task.wait(0.8)
					v.Transparency = 0 
				end)
			end
		end



	end

end

module.TreeDestroy = function(char)
	local eroot = char.HumanoidRootPart
	local hit = char
	local efolder = char.AliveData.TempValue

	local function ray(startpos,endpos)
		local myParams = RaycastParams.new()
		myParams.FilterType = Enum.RaycastFilterType.Include
		myParams.FilterDescendantsInstances = {workspace.Map}
		myParams.IgnoreWater = true

		local ray = workspace:Raycast(startpos,endpos,myParams)

		if ray then

			if ray.Instance then
				return ray.Instance,ray.Position,ray.Normal
			end

		end

	end

	task.spawn(function()
		local T = tick()
		while true do				
			local h, p, sf = ray(eroot.CFrame.Position,  eroot.CFrame.lookVector * -5)
			
			if h and h.CanCollide and h.Anchored and sf then
				print(h.Name) 		
				print(h.Parent.Name)
				if h.Parent.Name == "tree" then 
					if not hit.AliveData.TempValue:FindFirstChild("WALLSLAMCD") then
						local boom = Instance.new("Folder")
						boom.Name = "WALLSLAMCD"
						boom.Parent = efolder
						game.Debris:AddItem(boom,1.5)

						local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
						miscmodule.PlaySound("Wood Breaking",eroot)
						miscmodule.PlaySound("SLAMMED",eroot)
						miscmodule.PlaySound("Tree log breaking SFX",eroot)
						miscmodule.PlaySound("Fol",eroot)

						local p = h.Parent:Clone()
						
						for i,v in pairs(p:GetDescendants()) do
							if v:IsA("Part") then
								spawn(function()
									local rng = math.random(1,2)
									
									if v.Name == "Grass" then
										local TweenService = game:GetService("TweenService")
										local time = 1 --this will tell you how much it would take for the tween to finish
										local tween = TweenService:Create(v, TweenInfo.new(time), {Transparency = 2})
										tween:Play()
									else
										local BM = Instance.new("BodyVelocity")
										BM.Name = "Fling"
										BM.MaxForce  = Vector3.new(65000, 3000, 65000)
										BM.P = 20000
										BM.Velocity = eroot.CFrame.LookVector * -30
										BM.Parent = v
										game.Debris:AddItem(BM, 0.2)
									end

									spawn(function()
										local FX = game.ReplicatedStorage.Assets.VFX.LEAF:Clone()
										FX.Parent = v
										v:WaitForChild("LEAF")
										FX:Emit(10)
										game.Debris:AddItem(FX,4)
									end)

									v.Parent = game.Workspace.Ignore
									v.Anchored = false
									v.Name = "NoTouch"
									game.Debris:AddItem(v,12)
									task.wait(3)
									v.Anchored = true
								end)
							end
						end

						for i,v in pairs(h.Parent:GetDescendants()) do 
							if v:IsA("BasePart") then
								spawn(function()
									v.CanCollide = false
									v.Transparency = 1
									task.wait(20)
									v.CanCollide = true
									v.Transparency = 0
								end)
							end
						end
					end

					eroot.CFrame = eroot.CFrame
				end
			end

			if (tick() - T) > .6 then
				break
			end

			task.wait()
		end
	end)	
end

module.BasicSub = function(char, hit)

	local Log = game.ReplicatedStorage.Assets.Models.Log_A:Clone()
	Log.Parent = workspace.Ignore
	Log.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
	Log.Orientation = Vector3.new(math.random(1,255),math.random(1,255),math.random(1,255))
	Log.Sound:Play()	
	Log.ParticleEmitter.Enabled = true
	spawn(function()	
		task.wait(0.2)
		Log.ParticleEmitter.Enabled = false
	end)
	game.Debris:AddItem(Log,4)

	local Ignore = {game.Workspace.Alive,game.Workspace.Ignore}

	local function ray(startpos, endpos, dis)
		local test = Ray.new(startpos, CFrame.new(startpos, endpos).lookVector * dis)
		local hit, pos, sf = game.Workspace:FindPartOnRayWithIgnoreList(test,Ignore)
		return hit, pos, sf

	end

	local h, p, sf = ray(char.HumanoidRootPart.Position, char.HumanoidRootPart.CFrame * CFrame.new(math.random(-15,15),25,math.random(-15,15)).Position, 25)----------------------------KIDSOHERE
	if h then
		char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
	end
	char.HumanoidRootPart.CFrame = CFrame.new(p)

	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	miscmodule.Create("Temp","Folder",char.AliveData.TempValue,"Subbed",0.5)


	for i,v in pairs(char:GetDescendants()) do

		if v:IsA("Part") then
			if v.Transparency == 0 then
				v.Transparency = 1
				spawn(function() 
					task.wait(0.8)
					v.Transparency = 0 
				end)
			end
		end

		if v:IsA("Decal") then
			if v.Transparency == 0 then
				v.Transparency = 1
				spawn(function() 
					task.wait(0.8)
					v.Transparency = 0 
				end)
			end
		end

		if v:IsA("Mesh") then
			if v.Transparency == 0 then
				v.Transparency = 1
				spawn(function() 
					task.wait(0.8)
					v.Transparency = 0 
				end)
			end
		end 

		if v:IsA("ParticleEmitter") then
			if v.Enabled then 
				v.Enabled = false
				wait(0.8)
				v.Enabled = true
			end
		end

	end 

end

module.Bruise = function(char)

	local mathed = math.random(1,10)

	if mathed > 2 then return end

	local Subject = char

	local choices = {
		"Bruises",
		"Rips",
		"Rips"
	}

	local allFaces = {
		Enum.NormalId.Front,
		Enum.NormalId.Front,
		Enum.NormalId.Back,
		Enum.NormalId.Left,
		Enum.NormalId.Right,
	}

	local possibleLimbs = {
		Subject:FindFirstChild("Torso"),
		Subject:FindFirstChild("Torso"),
		Subject:FindFirstChild("Right Leg"),
		Subject:FindFirstChild("Left Leg"),
		Subject:FindFirstChild("Right Arm"),
		Subject:FindFirstChild("Left Arm")
	}

	local currChoice = choices[math.random(1,#choices)]

	local currAmounts = {
		["Bruises"] = 0,
		["Rips"] = 0
	}

	local subjectHRP = Subject:FindFirstChild("HumanoidRootPart")

	--// Getting amount \\--

	for i, v in pairs(Subject:GetDescendants()) do
		if v:IsA("Decal") then
			if v.Name == "Bruises" then

				currAmounts.Bruises += 1

			elseif v.Name == "Rips" then

				currAmounts.Rips += 1

			end
		end
	end

	--// Creating injury \\--

	if currAmounts[currChoice] <= 20 and math.random(1,2) == 1 then

		--// Getting texture \\--

		local allInjuryChoices = script:FindFirstChild("Injuries")[currChoice]:GetChildren()
		local currTexture = allInjuryChoices[math.random(1,#allInjuryChoices)].Texture

		local randomLimb = possibleLimbs[math.random(1,#possibleLimbs)]


		--// Getting face \\--

		if randomLimb.Name == "Torso" then
			table.remove(allFaces, allFaces[Enum.NormalId.Right])
			table.remove(allFaces, allFaces[Enum.NormalId.Left])
		elseif randomLimb.Name == "Left Leg" or randomLimb.Name == "Left Arm" then
			table.remove(allFaces, allFaces[Enum.NormalId.Right])
		elseif randomLimb.Name == "Right Arm" or randomLimb.Name == "Right Leg" then
			table.remove(allFaces, allFaces[Enum.NormalId.Left])
		end

		--// Creating decal \\--

		local newDecal = Instance.new("Decal")

		if currChoice == "Rips" then
			newDecal.Color3 = randomLimb.Color
		end

		newDecal.Name = tostring(currChoice)
		newDecal.Texture = currTexture
		newDecal.Face = allFaces[math.random(1, #allFaces)]
		newDecal.Parent = randomLimb

	end

end

module.DS = function(char,Echar,Ragtimer)



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

	local velocity = CFrame.lookAt(char.HumanoidRootPart.Position, Echar.HumanoidRootPart.Position).LookVector

	local root = char.HumanoidRootPart
	root.Velocity = Vector3.new(0,0,0)
	root.CFrame *= CFrame.Angles(math.rad(90), 0, 0)


	local effectName = "Crater"		
	local effectParameters = {
		CFrame = root.CFrame,
		Size = 9,
		Direction = Vector3.new(0,-5,0),
		Rows = 3,
		emitDebris = true,
		emitSmoke = true

	}

	local CreateRemote = game.ReplicatedStorage.Remotes.createEffect
	CreateRemote:FireAllClients(effectName, effectParameters)


	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	miscmodule.PlaySound("Him",char.HumanoidRootPart)

end

module.KB = function(char,Echar)

	char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position,Echar.HumanoidRootPart.Position)

	local root = char.HumanoidRootPart
	local eroot = Echar.HumanoidRootPart

	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	miscmodule.Create("Temp","BoolValue",char.AliveData.TempValue,"Ragdoll",0.8)
	miscmodule.PlaySound("Him",char.HumanoidRootPart)
	miscmodule.PlayRandomSound("Dash",char.HumanoidRootPart,2)
	miscmodule.Create("Temp","Folder",char.AliveData.TempValue,"GS",0.47)
	miscmodule.Create("Temp","Folder",char.AliveData.TempValue,"Stun",0.50)

	local BM = Instance.new("BodyVelocity")
	BM.Name = "Fling"
	BM.MaxForce  = Vector3.new(65000, 0, 65000)
	BM.P = 20000
	BM.Velocity = eroot.CFrame.LookVector * 35
	BM.Parent = root
	game.Debris:AddItem(BM, 0.4)

	local CreateRemote = game.ReplicatedStorage.Remotes.createEffect
	local HRP = char.HumanoidRootPart
	local currCFrame = HRP.CFrame * CFrame.Angles(math.rad(0), 0, math.rad(0))
	local effectEvent = game.ReplicatedStorage.Remotes.createEffect

	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	miscmodule.PlaySound("Him",char.HumanoidRootPart)
	miscmodule.PlayRandomSound("Dash",char.HumanoidRootPart,2)
end


module.UPKB = function(char,Echar)

	local KBAnim = char.Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.KNOCKBACK)
	KBAnim:Play()

	char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position,Echar.HumanoidRootPart.Position)

	local root = char.HumanoidRootPart
	local eroot = Echar.HumanoidRootPart


	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	miscmodule.PlaySound("Him",char.HumanoidRootPart)
	miscmodule.PlayRandomSound("Dash",char.HumanoidRootPart,2)
	miscmodule.Create("Temp","Folder",char.AliveData.TempValue,"GS",0.47)
	miscmodule.Create("Temp","Folder",char.AliveData.TempValue,"Stun",1.2)

	local BM = Instance.new("BodyVelocity")
	BM.Name = "Fling"
	BM.MaxForce  = Vector3.new(65000, 65000, 65000)
	BM.P = 20000
	BM.Velocity = eroot.CFrame.LookVector * 15 + Vector3.new(0,50,0)
	BM.Parent = root
	game.Debris:AddItem(BM, 0.5)

	local HRP = char.HumanoidRootPart



	local CreateRemote = game.ReplicatedStorage.Remotes.createEffect


	local HRP = char.HumanoidRootPart

	local currCFrame = HRP.CFrame * CFrame.Angles(math.rad(0), 0, math.rad(0))
	local effectEvent = game.ReplicatedStorage.Remotes.createEffect



	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	miscmodule.PlaySound("Him",char.HumanoidRootPart)
	miscmodule.PlayRandomSound("Dash",char.HumanoidRootPart,2)


	local function detectGround()

		print("DGFunction")

		--// Detecting until hit ground \\--

		local detectingGround = coroutine.wrap(function()

			--// Creating parameters \\--

			local characterTorso = char:WaitForChild("Torso")
			local additionalSize = Vector3.new(1.5, 1, 1.5)

			local overlapParameters = OverlapParams.new()
			overlapParameters.FilterType = Enum.RaycastFilterType.Include
			overlapParameters.MaxParts = 1
			overlapParameters.RespectCanCollide = true
			overlapParameters.FilterDescendantsInstances = {
				game.Workspace:FindFirstChild("Map"),

			}

			local detecting

			--// Heartbeat \\--

			detecting = game["Run Service"].Heartbeat:Connect(function()

				local continueLoop = true

				--// Pre Checking \\--



				if not char.AliveData.TempValue:FindFirstChild("Ragdoll") then
					continueLoop = false
					detecting:Disconnect()
				end

				--// Nerfing ground detection \\--

				if char.AliveData.TempValue:FindFirstChild("Air Combo") then

					continueLoop = false

				end


				--// Detecting ground \\--

				if continueLoop == true then				
					for i, v in pairs(game.Workspace:GetPartBoundsInBox(characterTorso.CFrame, characterTorso.Size + additionalSize, overlapParameters)) do

						detecting:Disconnect()

						--// Performing \\--

						local effectName = "Crater"		
						local effectParameters = {
							CFrame = root.CFrame,
							Size = 8,
							Direction = Vector3.new(0,-5,0),
							Rows = 2,
							emitDebris = true,
							emitSmoke = true

						}

						CreateRemote:FireAllClients(effectName, effectParameters)


						local hitGround = Instance.new("BoolValue")
						hitGround.Name = "Hit Ground"
						hitGround.Parent = char.AliveData.TempValue

						local soundTypes = {
							"rbxassetid://7446606796",
							"rbxassetid://7446607140",
							"rbxassetid://7446607091",
							"rbxassetid://7446607037",
							"rbxassetid://7446606925",
							"rbxassetid://7446609932"
						}

						--// Sound Effect \\--

						local soundEffect = Instance.new("Sound", char.HumanoidRootPart)
						soundEffect.Name = "Hit Ground"
						soundEffect.PlaybackSpeed = math.random(80,120) / 100
						soundEffect.Volume = 0.25

						soundEffect.RollOffMode = Enum.RollOffMode.LinearSquare
						soundEffect.RollOffMinDistance = 10
						soundEffect.RollOffMaxDistance = 50

						soundEffect.SoundId = soundTypes[math.random(1,#soundTypes)]
						soundEffect:Play()
						game.Debris:AddItem(soundEffect, 2)

						--// Breaking loop \\--

						break

					end				
				end

			end)

		end)

		detectingGround()

	end

	detectGround()

end


return module
