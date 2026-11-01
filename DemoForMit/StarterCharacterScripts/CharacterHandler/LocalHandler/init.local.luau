local isSliding = false

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGUI = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local TrailManager = require(game.ReplicatedStorage.Modules.TrailManager)


task.wait(1)

local Player = game.Players.LocalPlayer
local Character = Player.Character
Character:WaitForChild("Head")
Character:WaitForChild("Torso")
Character:WaitForChild("AliveData",10)

local Humanoid = Character.Humanoid
local PlayerGui = Player.PlayerGui
local Camera = game.Workspace.CurrentCamera

local rem = script.Parent.Remotes.ControllerRemote

local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)

local dashbind = Enum.KeyCode.Q
local HRP = Character.HumanoidRootPart
local Blockbind = Enum.KeyCode.F

local BackDash = Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.Movement.BackDash)
local Fow = Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.Movement.FrontDash)
local left = Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.Movement.LeftDash)
local right = Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.Movement.RightDash)
local runanim = Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.Movement.Sprint)

local f = tick() - 30
local x = {}
local b = game:GetService("TweenService")
local q = true
local v = game.Players.LocalPlayer
local c = v.Backpack
local A = v.Character
local player = game.Players.LocalPlayer
local y = A:WaitForChild("Humanoid")
local z = A:WaitForChild("HumanoidRootPart")
local g = game:GetService("UserInputService")
local w = game.Workspace.CurrentCamera
local s = v:GetMouse()
local k = 1
local ij = false
local t = false
local j = false
local i = false
local h = true
local a = tick()
local m = true
local l = 1
local n = false
local o = 0
local e = Vector3.new(0, 0, 0)
local ANIM = y:LoadAnimation(script.Anims:FindFirstChild("Wj1"))

local FXRemote = game.ReplicatedStorage.Remotes.ServerFX

local AliveData = Character:WaitForChild("AliveData")
local CD = AliveData.CDS
local TempValue = AliveData.TempValue
local PermValue = AliveData.PermValue
local hrp = Character.HumanoidRootPart

local WRL = Humanoid:LoadAnimation(script:WaitForChild("Anims").WallRunLeft)
local WRR = Humanoid:LoadAnimation(script:WaitForChild("Anims").WallRunRight)

local wallRunRange = 1; 

local wallRunSpeed = 45;

local wallRunGravity = 3;

local dashcd = false

local isGrounded = true
local u3 = 0
local treeJumping = false
local lastTreeJump = 0


function NormalLand()
	local NewYAxis = HRP.Position.Y
	local OldWs = Humanoid.WalkSpeed

	if math.abs(u3 - Character.HumanoidRootPart.Position.Y) > 60 then
		spawn(function()
			local Anim = player.Character:WaitForChild("Humanoid"):LoadAnimation(script.Anims.Land)
			Anim:Play()
			Anim.Priority = Enum.AnimationPriority.Action
			Anim:AdjustSpeed(1.15)
			FXRemote:FireServer("GroundSlam")
		end)
		task.wait(.1)
		--	Fall:Stop()
	end
end

function FindSurface(part, position)
	local obj = part.CFrame:pointToObjectSpace(position)
	local siz = part.Size/2
	for i,v in pairs(Enum.NormalId:GetEnumItems()) do
		local vec = Vector3.FromNormalId(v)
		local wvec = part.CFrame:vectorToWorldSpace(vec)
		local vz = (obj)/(siz*vec)
		if (math.abs(vz.X-1) < 0.01 or math.abs(vz.Y-1) < 0.01 or math.abs(vz.Z-1) < 0.01) then
			return wvec,vec
		end
	end
	if part.className == "WedgePart" then
		return part.CFrame:vectorToWorldSpace(Vector3.new(0,0.707,-0.707)), Vector3.new(0,0.707,-0.707)
	end
end


local isdashing = false


function dash()

	if dashcd == true then return end 
	if TempValue:FindFirstChild("Stun") or TempValue:FindFirstChild("Ragdoll") or TempValue:FindFirstChild("DisableDash") then return end 

	local dashDirection = "Forward"	

	local movementDirection = Camera.CFrame:vectorToObjectSpace(Humanoid.MoveDirection).Unit
	if Humanoid.MoveDirection == Vector3.new(0,0,0)  then return end 
	if TempValue:FindFirstChild("Dashing") then return end 
	if TempValue:FindFirstChild("UsingSkill") then return end 
	if CD:FindFirstChild("DASHCD") then return end 
	miscmodule.Create("Temp","Folder",CD,"DASHCD",2)
	if movementDirection.Z > 0.5 then
		dashDirection = "Back"
		TrailManager.createTrail(Character, "RightArmAndLeftArm")
		TrailManager.createTrail(Character, "RightLegAndLeftLeg")
		Fow:Stop()
		left:Stop()
		BackDash:Stop()
		right:Stop()
		BackDash:Play()
		BackDash.Priority = Enum.AnimationPriority.Action2
	elseif movementDirection.Z < -0.5 then
		dashDirection = "Forward"
		Fow:Stop()
		left:Stop()
		BackDash:Stop()
		right:Stop()
		Fow:Play()
		Fow.Priority = Enum.AnimationPriority.Action2
		miscmodule.Create("Temp","Folder",CD,"Forward",4)
	elseif movementDirection.X > 0.5 then
		dashDirection = "Right"
		TrailManager.createTrail(Character, "RightArmAndLeftArm")
		TrailManager.createTrail(Character, "RightLegAndLeftLeg")
		Fow:Stop()
		left:Stop()
		BackDash:Stop()
		right:Stop()
		right:Play()
		right.Priority = Enum.AnimationPriority.Action2
		miscmodule.Create("Temp","Folder",CD,"Right",3)
	elseif movementDirection.X < -0.5 then
		dashDirection = "Left"
		TrailManager.createTrail(Character, "RightArmAndLeftArm")
		TrailManager.createTrail(Character, "RightLegAndLeftLeg")
		Fow:Stop()
		left:Stop()
		BackDash:Stop()
		right:Stop()
		left:Play()
		left.Priority = Enum.AnimationPriority.Action2
		miscmodule.Create("Temp","Folder",CD,"Left",3)
	end

	FXRemote:FireServer("Dash",dashDirection)
	local dashVelocity = coroutine.wrap(function()

		--// Creating body position \\--

		local dashDistance = 35
		local dashDuration = 0.4


		local boost = Character.AliveData.Buffs.SpeedBuff.Value

		dashDistance= dashDistance + boost

		dashDuration = dashDuration - (boost/4)/10

		if dashDirection == "Forward" then 
			dashDistance = 35
			dashDuration = 0.4
		end

		if dashDirection == "Back" then
			dashDistance = 35
			dashDuration = 0.4
		end

		local baseHRPCFrame = CFrame.new(HRP.Position.X, HRP.Position.Y, HRP.Position.Z) * CFrame.Angles(0, math.rad(HRP.Orientation.Y), 0)

		local directionVelocities = {
			["Forward"] = baseHRPCFrame * CFrame.new(0, 0, -dashDistance),
			["Back"] = baseHRPCFrame * CFrame.new(0, 0, dashDistance),
			["Left"] = baseHRPCFrame * CFrame.new(-dashDistance, 0, 0),
			["Right"] = baseHRPCFrame * CFrame.new(dashDistance, 0, 0),
		}

		local bodyPosition = Instance.new("BodyPosition")
		bodyPosition.Name = "Dash Velocity"
		bodyPosition.P = 15000
		bodyPosition.D = 1900
		bodyPosition.Position = directionVelocities[dashDirection].Position
		bodyPosition.MaxForce = Vector3.new(80000, 0, 80000)
		game.Debris:AddItem(bodyPosition, dashDuration)
		bodyPosition.Parent = HRP

		FXRemote:FireServer("Dash")

		--// Adjusting velocity \\--

		local start = tick()

		local adjusting

		adjusting = game:GetService("RunService").RenderStepped:Connect(function()

			--// Disconnecting \\--

			if bodyPosition.Parent == nil  then

				bodyPosition:Destroy()
				adjusting:Disconnect()
				--print(tick() - start)
				return


			end

			--// Presetting direction values \\--

			baseHRPCFrame = CFrame.new(HRP.Position.X, HRP.Position.Y, HRP.Position.Z) * CFrame.Angles(0, math.rad(HRP.Orientation.Y), 0)

			directionVelocities = {
				["Forward"] = baseHRPCFrame * CFrame.new(0, 0, -dashDistance),
				["Back"] = baseHRPCFrame * CFrame.new(0, 0, dashDistance),
				["Left"] = baseHRPCFrame * CFrame.new(-dashDistance, 0, 0),
				["Right"] = baseHRPCFrame * CFrame.new(dashDistance, 0, 0),
			}

			--// Setting \\--

			if bodyPosition.Parent ~= nil then
				bodyPosition.Position = directionVelocities[dashDirection].Position
			end

		end)

	end)
	miscmodule.Create("Temp","Folder",TempValue,"Dashing",0.3)
	Character:SetAttribute("Dashing", true)
	if dashDirection == "Back" then 
		miscmodule.Create("Temp","Folder",TempValue,"Dashing",0.45)
	end
	dashVelocity()

	task.wait(0.45)



	Character:SetAttribute("Dashing", false)


end
local DB_1=false
local CD = true
local LastTime = tick()
local dashcd = true

function ray(d, a, b, c)
	local a = Ray.new(d, CFrame.new(d, a).lookVector * b)
	local a, c, b = game.Workspace:FindPartOnRay(a, c)
	return a, c, b
end

function fall_check()
	if not (z.Position.Y > -300) or not A.Torso:findFirstChild("Swimming") then
	end
	o = z.Position.Y
end

local WJdeb = true

function walljump()
	if not q then
		return false
	end

	if WJdeb == false then return end 


	local c, b, a = ray(z.Position, z.CFrame.lookVector + z.Position, 3, A)
	if c and c.Anchored and c.CanCollide and c.Transparency ~= 1 and (c.Name ~= "NoTClimb" or l ~= 2) then
		if (a - e).magnitude < 0.1 then
			return false
		else
			q = false
			fall_check()
			do	
				u3 = -1000
				WJdeb = false
				spawn(function()
					task.wait(0.35)
					WJdeb = true
				end)
				ANIM:Play(0.1, 1, 2)
				script.POOPYBUTT:FireServer(Character)
				z.Anchored = true
				z.CFrame = CFrame.new(b + CFrame.new(b, z.Position).lookVector * 2, b)
				l = 2
				task.wait(0.15)
				ANIM:AdjustSpeed(1.5)
				spawn(function()
					task.wait(0.25)
					ANIM:Stop(0.3)
				end)
				z.Anchored = false
				z.Velocity = Vector3.new(0,60, 0) + z.CFrame.lookVector * -40
				miscmodule.Create("Temp","Folder",TempValue,"SUPERDASH",0.5)
				miscmodule.Create("Temp","Folder",TempValue,"Cancel",0.6)
				task.wait(0.2)
				q = true
				return true
			end
		end
	end
	return false
end

local CD = true
local LastTime = tick()


function treejump()

	if treeJumping then return end

	local ignore = {game.Workspace.Alive, game.Workspace.Projectiles}
	local wallRay = Ray.new(Character.HumanoidRootPart.CFrame.p, Character.HumanoidRootPart.CFrame.lookVector * 3)
	--local wallHit, wallPos = workspace:FindPartOnRay(wallRay, character)
	local wallHit, wallPos = game.Workspace:FindPartOnRayWithIgnoreList(wallRay,ignore)

	local treeHit,treePos

	if AliveData.Combat.CombatTag.Value == 0 then
		for i=0,60,1 do
			local rotatedCF = HRP.CFrame * CFrame.Angles(math.rad(-i),0,0)
			local treeRay = Ray.new(HRP.CFrame.p,rotatedCF.LookVector * 20)
			local tempHit,tempPos = workspace:FindPartOnRayWithIgnoreList(treeRay,{workspace.Alive,workspace.Projectiles})
			if tempHit 
				and tempHit.Anchored 
				and (tempHit.Name == "Leaves" or tempHit.Name == "Branch" or tempHit.Name == "BranchPart" or tempHit.Name == "Leafs") 
				and tempHit.Transparency < 1 then

				treeHit,treePos = tempHit,tempPos
				break
			end
		end
	end

	local zipHit,zipPos

	if treeHit then
		local recentTreeJump = tick() - lastTreeJump < .8
		--print(tick() - lastTreeJump)
		treeJumping = true
		treePos = treePos + Vector3.new(0,3,0) -- to account for char's size so it actually looks like they are on the tree
		local treeJumpAnim = Character.Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.TreeJump)
		treeJumpAnim:Play()

		local tween = game:GetService("TweenService"):Create(HRP,TweenInfo.new(0.3),{CFrame = CFrame.new(treePos,treePos + HRP.CFrame.LookVector)})
		tween:Play()
		treeJumpAnim:Play(.1,1,0) -- fadeTime,weight,speed

		script.POOPYBUTT:FireServer(Character)

		local velCon
		velCon = game:GetService("RunService").RenderStepped:Connect(function() -- basically anchored, 
			-- but roblox doesn't replicate physics of locally anchored parts so gotta do this
			if HRP then
				HRP.Velocity = Vector3.new(0,0,0)
				HRP.RotVelocity = Vector3.new(0,0,0)
			end
		end)
		wait(0.3)

		treeJumpAnim:AdjustSpeed(1)
		if recentTreeJump then
			treeJumpAnim.TimePosition = 0.3
			wait(.1)
		else
			treeJumpAnim.TimePosition = 0.2
			wait(.2)
		end

		velCon:Disconnect()

		miscmodule.Destroy(AliveData.CDS,"DOUBLEJUMP")
		miscmodule.Create("Temp","Folder",TempValue,"SUPERDASHH",1)


		local tickThing = tick()
		local moveDirAdd = Humanoid.MoveDirection
		local bodyVel = Instance.new("BodyVelocity")
		bodyVel.MaxForce = Vector3.new(100000,100000,100000)
		bodyVel.P = 3000
		bodyVel.Velocity = moveDirAdd * 70 + Vector3.new(0,25,0)
		bodyVel.Parent = HRP
		game:GetService("Debris"):AddItem(bodyVel,0.4)
		local rCon
		rCon = game:GetService("RunService").RenderStepped:Connect(function()
			if bodyVel and bodyVel.Parent ~= nil then
				moveDirAdd = moveDirAdd:lerp(Humanoid.MoveDirection,0.1)
				local velToSet = moveDirAdd * 70
				if tick() - tickThing < .2 then
					velToSet = velToSet + Vector3.new(0,45,0)
				else
					velToSet = (velToSet + Vector3.new(0,45,0)):lerp(velToSet,math.clamp(((tick() - tickThing)-.2) * 5,0,1))
				end
				bodyVel.Velocity = velToSet
			else
				rCon:Disconnect()
			end
		end)
		wait(0.4)
		treeJumping = false
		lastTreeJump = tick()

		local land
		land = game["Run Service"].RenderStepped:connect(function()
			if Humanoid.FloorMaterial ~= Enum.Material.Air then
				--	print("LANDDE")
				land:Disconnect()
			end
		end)
		spawn(function()
			wait(1)
			land:Disconnect()
		end)
	end

end

local SpaceHeld = false

UserInputService.InputBegan:Connect(function(Key,GPE)
	if GPE then return end 

	if Key.KeyCode == Enum.KeyCode.LeftShift then 
		rem:FireServer("Runn")	
	end 

	if Key.UserInputType == Enum.UserInputType.MouseButton2   then 
		--if character:GetAttribute("Attacking") == false then return end
		rem:FireServer("M2")
	end 

	if Key.KeyCode == Enum.KeyCode.L then 
		rem:FireServer("Head")	
	end 
	
	if Key.KeyCode == Enum.KeyCode.Space then
		SpaceHeld = true
	end
	
	if Key.KeyCode == dashbind then
		if Character:GetAttribute("DoCritical") == true then return end
		if string.find(game.ReplicatedStorage.PlayerData:WaitForChild(Character.Name).UnlockedSkills.Value,"FlashStep") and dashcd == true then
			FXRemote:FireServer("FlashStep")
			dashcd = false
			spawn(function()	
				wait(2.5)
				dashcd = true
			end)

		else
			dash()
		end 
	end

	if Key.KeyCode == dashbind then
		if TempValue:FindFirstChild("SUPERDASH") or TempValue:FindFirstChild("SUPERDASHH") then
			if CD == false then return end 
			if AliveData.Combat.CombatTag.Value > 0  then
				CD = false
				spawn(function()
					task.wait(8)
					CD = true
				end)
			end 
			ANIM:Stop()

			miscmodule.Clearvelocity(Character)
			local Anim = Humanoid:LoadAnimation(script.Anims.AirDash)
			Anim:Play()



			local stepp = 100
			if TempValue:FindFirstChild("SUPERDASHH") then
				stepp = 120
			end 

			miscmodule.Destroy(AliveData.TempValue,"SUPERDASH")
			miscmodule.Destroy(AliveData.CDS,"SUPERDASHH")
			miscmodule.Destroy(AliveData.CDS,"DOUBLEJUMP")




			local bvel = Instance.new("BodyVelocity",Character.HumanoidRootPart)
			if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
				bvel.MaxForce = Vector3.new(100000,100000,100000)
			else
				bvel.MaxForce = Vector3.new(100000,0,100000)	
			end
			FXRemote:FireServer("Double Jump1")
			u3 = -1000
			local cf = CFrame.new(Character.HumanoidRootPart.CFrame.p + -workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1,1,1))
			bvel.Velocity = CFrame.new(Character.HumanoidRootPart.Position, cf.Position).lookVector * -stepp 
			game.Debris:AddItem(bvel,0.5)
		else
			dash()
		end
	end

	if Key.KeyCode == Enum.KeyCode.R then
		if AliveData.Combat:FindFirstChild("Equipped") == nil then return end 
		if Character:FindFirstChildOfClass("Tool") then return end
		if Character.AliveData.TempValue:FindFirstChild("LA") then return end 
		rem:FireServer("Heavy")
	end

	if Key.KeyCode == Enum.KeyCode.E then
		rem:FireServer("Equip")
	end
	
	if Key.KeyCode == Enum.KeyCode.G then
		rem:FireServer("Evasive")
	end
	

	if Key.KeyCode == Blockbind then
		if AliveData.Combat:FindFirstChild("Equipped") == nil then return end 
		rem:FireServer("Block")
	end

	if Key.UserInputType == Enum.UserInputType.MouseButton1 then
		if AliveData.Combat:FindFirstChild("Equipped") == nil then return end 
		if Character:FindFirstChildOfClass("Tool") then return end
		if Humanoid:GetState() == Enum.HumanoidStateType.Freefall and TempValue:FindFirstChild("AirCombo") == nil then
			if AliveData.CDS:FindFirstChild("DOUBLEJUMP") then return end 
			rem:FireServer("AirM1")
		else 
			rem:FireServer("M1",SpaceHeld)
		end
	end

	if Key.KeyCode == Enum.KeyCode.Space then
		rem:FireServer("GetUp")

		if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
			walljump()
			treejump()
		end
	end

end)


Humanoid.StateChanged:Connect(function(state)
	if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
		m = true	
	else
		m = false	
		WJdeb = true
	end

	if state == Enum.HumanoidStateType.Jumping then
		if AliveData.Combat.CombatTag.Value > 0 then 
			if AliveData.TempValue:FindFirstChild("JUMPCD") then return end 
			miscmodule.Create("Temp","Folder",TempValue,"JUMPCD",3.5)
		end 
	end 

	if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
		isGrounded = false
	elseif Humanoid:GetState() == Enum.HumanoidStateType.Landed or Humanoid:GetState() == Enum.HumanoidStateType.Climbing then
		
		miscmodule.Destroy(AliveData.CDS,"DOUBLEJUMP")
	end

end)

UserInputService.InputEnded:Connect(function(Key,GPE)
	if GPE then return end 

	if Key.KeyCode == Blockbind then
		rem:FireServer("UnBlock")
	end

	if Key.KeyCode == Enum.KeyCode.LeftShift then 
		rem:FireServer("NoRun")
	end 


	if Key.UserInputType == Enum.UserInputType.MouseButton2 then 
		rem:FireServer("M2Stop")	
	end 
	
	if Key.KeyCode == dashbind then
		if Character:GetAttribute("DoCritical") == true then return end
		if string.find(game.ReplicatedStorage.PlayerData:WaitForChild(Character.Name).UnlockedSkills.Value,"FlashStep") and dashcd == true then
			FXRemote:FireServer("FlashStep")
			dashcd = false
			spawn(function()	
				wait(2.5)
				dashcd = true
			end)

		else
			dash()
		end 
	end

	if Key.KeyCode == Enum.KeyCode.Space then
		SpaceHeld = false
	end
end)

local canidle = true
local standingstill 
local canidled = false
local value = 0
local DashCancelCD = true

RunService.RenderStepped:Connect(function()

	if TempValue:FindFirstChild("Ragdoll") or TempValue:FindFirstChild("UsingCamp") then
		Humanoid.AutoRotate = false
	else 
		if not Character:FindFirstChild('disableRotate') then
			Humanoid.AutoRotate = true
		end
	end 
	
	if HRP:FindFirstChild("Dash Velocity") and AliveData.PermValue:FindFirstChild("M2") and DashCancelCD == true then
		if Humanoid:GetState() == Enum.HumanoidStateType.Freefall and Character:GetAttribute("DownSlam") == true then
			DashCancelCD = false

			spawn(function()
				task.wait(2)
				DashCancelCD = true
			end) 
			HRP:FindFirstChild("Dash Velocity"):Destroy()
			FXRemote:FireServer("DashCancel")
			for i, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
				if string.find(v.Name, "Dash") then
					print(v.Name)
					v:Stop()
				end 
			end

			local Dashcancelanim = Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.Movement.DashCancel)
			Dashcancelanim:Play()
			Dashcancelanim.Priority = Enum.AnimationPriority.Action2
		elseif Humanoid:GetState() == Enum.HumanoidStateType.Freefall and Character:GetAttribute("DownSlam") ~= true then
			task.spawn(function()
				HRP:FindFirstChild("Dash Velocity"):Destroy()
				DashCancelCD = false
				while true do
					if Character:GetAttribute("DownSlam") == true then
						break
					end

					task.wait()
				end
				task.delay(.3, function()
					DashCancelCD = true
				end)
			end)
		elseif Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
			DashCancelCD = false

			spawn(function()
				task.wait(2)
				DashCancelCD = true
			end) 
			HRP:FindFirstChild("Dash Velocity"):Destroy()
			FXRemote:FireServer("DashCancel")
			for i, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
				if string.find(v.Name, "Dash") then
					print(v.Name)
					v:Stop()
				end 
			end

			local Dashcancelanim = Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.Movement.DashCancel)
			Dashcancelanim:Play()
			Dashcancelanim.Priority = Enum.AnimationPriority.Action2
		else
			DashCancelCD = false

			task.spawn(function()
				task.wait(2)
				DashCancelCD = true
			end) 
			HRP:FindFirstChild("Dash Velocity"):Destroy()
			FXRemote:FireServer("DashCancel")
			for i, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
				if string.find(v.Name, "Dash") then
					print(v.Name)
					v:Stop()
				end 
			end

			local Dashcancelanim = Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.Movement.DashCancel)
			Dashcancelanim:Play()
			Dashcancelanim.Priority = Enum.AnimationPriority.Action2
		end
	end 

	local lighting = game.Lighting 

	if Humanoid.MoveDirection == Vector3.new(0,0,0) and Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
		value = value +0.04
	else 
		value = 0 
	end 

	local WS = 14
	local JS = 45

	if TempValue:FindFirstChild("UsingSkill") then
		JS = 0 
	end

	if TempValue:FindFirstChild("Cancel") then
		JS = 0 
	end

	if TempValue:FindFirstChild("LA") then
		WS = 12
		JS = 0 
	end

	if TempValue:FindFirstChild("Stun") then
		WS = 3
		JS = 0 
	end
	
	local mod = TempValue:FindFirstChild("Modify")
	if mod then
		WS = mod.WalkSpeed.Value
		JS = mod.JumpPower.Value
	end

	if TempValue:FindFirstChild("Subbed") then
		WS = 40
	end

	if TempValue:FindFirstChild("TrueSlow") then
		WS = WS - 1000000000
		JS = 0 
	end

	if TempValue:FindFirstChild("JUMPCD") then
		JS = 0
	end 

	if TempValue:FindFirstChild("UsingSkill") or  TempValue:FindFirstChild("TrueSlow") or  TempValue:FindFirstChild("NoRun")  or TempValue:FindFirstChild("Stun") or TempValue:FindFirstChild("SPRINTCD") then 
		if PermValue:FindFirstChild("Run") then
			rem:FireServer("NoRun")
		end
	end

	if runanim.IsPlaying == true and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
		runanim:Stop()
	end

	if PermValue:FindFirstChild("Run") and Humanoid.MoveDirection ~= Vector3.new(0,0,0) and not TempValue:FindFirstChild("SPRINTCD") and not TempValue:FindFirstChild("LA") and not PermValue:FindFirstChild("Block") and not TempValue:FindFirstChild("UsingSkill") and not TempValue:FindFirstChild("TrueSlow") then

		local boost = 8
		local buff = Character.AliveData.Buffs.SpeedBuff.Value

		WS = WS + boost
		WS = WS + buff
		
		if TempValue:FindFirstChild("Stim") then
			WS = WS + 12
		end
		
		if runanim.IsPlaying == false and Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
			runanim:Play()
			runanim.Priority = Enum.AnimationPriority.Action
		end

	else 

		runanim:Stop()
	end

	if TempValue:FindFirstChild("SlowDown") then
		WS = 2
	end

	Humanoid.WalkSpeed = WS
	Humanoid.JumpPower = JS
end)


