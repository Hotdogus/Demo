local ServerStorage = game.ServerStorage
local DamageTexts = require(script.DamageTexts)
local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)

function clearBvs(bv, root)
	for _, b in pairs(root:GetChildren()) do 
		if b:IsA("BodyVelocity") and b ~= bv then
			b:Destroy()
		end
	end
end

local function ray(startpos, endpos)
	local myParams = RaycastParams.new()
	myParams.FilterType = Enum.RaycastFilterType.Blacklist
	myParams.FilterDescendantsInstances = {workspace.Alive, workspace.Ignore}
	myParams.IgnoreWater = true

	local rayResult = workspace:Raycast(startpos, endpos, myParams)

	if rayResult then
		return rayResult.Instance, rayResult.Position, rayResult.Normal
	end
end

function blockCheck(root1, root2)
	local projection = root2.CFrame.lookVector:Dot((root1.Position - root2.Position).Unit)
	local angle = math.deg(math.acos(projection))
	return angle < 100
end

function tag(character, hit, info, tool)
	if not character or not hit or not info then
		return
	end

	local player = game.Players:GetPlayerFromCharacter(character)
	local eplayer = game.Players:GetPlayerFromCharacter(hit)

	if not hit:FindFirstChild('AliveData') then
		hit = hit.Parent
	end
	local root = character.HumanoidRootPart
	local eroot = hit.HumanoidRootPart
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local CameraShaker = require(ReplicatedStorage.Modules.CameraShaker)
	local Camera = workspace.CurrentCamera
	local hum = character.Humanoid 
	local ehum = hit.Humanoid 
	local VictimHealth = ehum.Health

	local efolder = workspace.Alive:FindFirstChild(hit.Name):FindFirstChild("AliveData")
	local pfolder = workspace.Alive:FindFirstChild(character.Name):FindFirstChild("AliveData")
	local stunmodule = require(game.ServerScriptService.DamageService.StunModule)

	if efolder.TempValue:FindFirstChild("Dodged") then return end  
	if efolder.TempValue:FindFirstChild("Ragdoll") and efolder.TempValue:FindFirstChild("Knocked") == nil then return end 
	if pfolder.TempValue:FindFirstChild("Gripping") then return end
	if pfolder.TempValue:FindFirstChild("Stun") and pfolder.TempValue:FindFirstChild("GotParried") == nil then return end
	if efolder.TempValue:FindFirstChild("Subbed") then return end 

	if efolder.TempValue:FindFirstChild("Parry") then 
		
		local CameraShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(ShakeCFrame)
			Camera.CFrame = Camera.CFrame * ShakeCFrame
		end)

		CameraShake:Start()
		CameraShake:Shake(CameraShaker.Presets.Explosion)
		
		for _, v in pairs(hum:GetPlayingAnimationTracks()) do
			if v.Name == "parrytick" then
				v:Stop()
			end
		end

		if efolder.Combat.ParryNumber.Value == 1 then 
			efolder.Combat.ParryNumber.Value = 2 
		else 
			efolder.Combat.ParryNumber.Value = 1 
		end 

		if efolder.TempValue:FindFirstChild("AirCombo") then
			stunmodule.KB(hit, character)
			stunmodule.KB(character, hit)
		end 

		local parry = ehum:LoadAnimation(game.ReplicatedStorage.Animations:FindFirstChild("TrueParry"..efolder.Combat.ParryNumber.Value))
		parry.Priority = Enum.AnimationPriority.Action4
		parry:Play()

		for _, v in pairs(hit.Humanoid:GetPlayingAnimationTracks()) do
			if v.Name == "parrytick" then 
				v:Stop()
			end
		end

		if game.ReplicatedStorage.PlayerData:WaitForChild(hit.Name).Weapon.Value == "Fists" and game.ReplicatedStorage.PlayerData:WaitForChild(character.Name).Weapon.Value == "Fists" then
			local fx = game.ReplicatedStorage.Assets.VFX.Parry.Fist:Clone()
			fx.Parent = eroot
			game.Debris:AddItem(fx, 3)
			for _, v in pairs(fx:GetDescendants()) do    
				if v:IsA("ParticleEmitter") then
					v:Emit(v.Rate)
				end
			end
			local misc = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			misc.Create("Temp", "Folder", pfolder.TempValue, "Stun", 0.8)
			misc.Create("Temp", "Folder", efolder.TempValue, "Stun", 0.3)
			misc.Create("Temp", "Folder", efolder.TempValue, "Parried", 0.3)
			misc.Create("Temp", "Folder", pfolder.TempValue, "GotParried", 0.8)
			misc.PlaySound("BP", eroot)
		else
			local misc = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			misc.Create("Temp", "Folder", pfolder.TempValue, "Stun", 0.8)
			misc.Create("Temp", "Folder", efolder.TempValue, "Stun", 0.3)
			misc.Create("Temp", "Folder", efolder.TempValue, "Parried", 0.3)
			misc.Create("Temp", "Folder", pfolder.TempValue, "GotParried", 0.8)
			misc.PlaySound("Parry", eroot)
			local fx = game.ReplicatedStorage.Assets.VFX.Parry.Attach:Clone()
			fx.Parent = eroot
			game.Debris:AddItem(fx, 3)
			for _, v in pairs(fx:GetDescendants()) do    
				if v:IsA("ParticleEmitter") then
					v:Emit(v.Rate)
				end
			end
		end 

		if efolder.Combat.Posture.Value + 15 > 100 then 
			efolder.Combat.Posture.Value = 100
		else 
			efolder.Combat.Posture.Value += 15
		end
		if pfolder.Combat.Posture.Value - 20 < 0 then 
			local FX = game.ReplicatedStorage.Assets.Models.GB.Attachment:Clone()
			FX.Parent = root
			game.Debris:AddItem(FX,3)

			for i,v in pairs(FX:GetDescendants()) do
				if v:IsA("ParticleEmitter") then 
					v:Emit(v.Rate)
				end
			end

			stunmodule.Bleed(hit)

			pfolder.Combat.Posture.Value = 100

			local damage = info.damage

			if info.blunt  then
				damage  = damage * pfolder.Buffs.TaiBuff.Value
			end 

			if info.Sharp then
				damage  = damage * pfolder.Buffs.WeaponBuff.Value
			end 

			if info.Jutsu then
				damage  = damage * pfolder.Buffs.JutsuBuff.Value
			end 

			damage = damage - damage * pfolder.Buffs.DefenseBuff.Value 

			local packet = {
				blunt = true,
				damage = damage*2,
				stuntime = 1,
				GB = true,
				KB = false,
				nosub= false,
			}
			game.ServerStorage.TagHumanoid:Invoke(hit, character, packet)	
			DamageTexts(eroot)
			
		else 
			pfolder.Combat.Posture.Value -= 20
		end

		
	elseif efolder.CDS:FindFirstChild("Forward") then

		spawn(function()
			local FX = game.ReplicatedStorage.Assets.Models.Dashes.Foward:Clone()
			FX.Parent = eroot
			FX.Weld.Part0 = eroot
			game.Debris:AddItem(FX,4)

			for i,v in pairs(FX:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						v.Enabled = true
						task.wait(0.25)
						v.Enabled = false
					end)
				end
			end
		end)

	elseif efolder.CDS:FindFirstChild("Back") then

		spawn(function()
			local FX = game.ReplicatedStorage.Assets.Models.Dashes.Back:Clone()
			FX.Parent = eroot
			FX.Weld.Part0 = eroot
			game.Debris:AddItem(FX,4)

			for i,v in pairs(FX:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						v.Enabled = true
						task.wait(0.25)
						v.Enabled = false
					end)
				end
			end
		end)


	elseif efolder.CDS:FindFirstChild("Left") then

		spawn(function()
			local FX = game.ReplicatedStorage.Assets.Models.Dashes.Right:Clone()
			FX.Parent = eroot
			FX.Weld.Part0 = eroot
			game.Debris:AddItem(FX,4)

			for i,v in pairs(FX:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						v.Enabled = true
						task.wait(0.25)
						v.Enabled = false
					end)
				end
			end
		end)

	elseif efolder.CDS:FindFirstChild("Right") then

		spawn(function()
			local FX = game.ReplicatedStorage.Assets.Models.Dashes.Left:Clone()
			FX.Parent = eroot
			FX.Weld.Part0 = eroot
			game.Debris:AddItem(FX,4)

			for i,v in pairs(FX:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					spawn(function()
						v.Enabled = true
						task.wait(0.25)
						v.Enabled = false
					end)
				end
			end
		end)

	elseif efolder.PermValue:FindFirstChild("Block")  then

		if info.GB then
			efolder.PermValue:FindFirstChild("Block"):Destroy()
			local FX = game.ReplicatedStorage.Assets.Models.GB.Attachment:Clone()
			FX.Parent = eroot
			game.Debris:AddItem(FX,3)

			for i,v in pairs(FX:GetDescendants()) do
				if v:IsA("ParticleEmitter") then 
					v:Emit(v.Rate)
				end
			end
			ehum:LoadAnimation(game.ReplicatedStorage.Animations.GB):Play()

			stunmodule.Bleed(hit)

			local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			miscmodule.Create("Temp","Folder",efolder.TempValue,"Stun",1.5)
			miscmodule.Create("Temp","Folder",efolder.TempValue,"GB",1.5)
			miscmodule.Create("Temp","Folder",efolder.TempValue,"TrueSlow",1.5)
			miscmodule.Create("Temp","Folder",efolder.TempValue,"GB",1.5)
			miscmodule.PlaySound("BlockBreak",eroot)
		else 

			stunmodule.Blocked(hit)
			local posturedmg = info.damage * 3

			if efolder.Combat.Posture.Value - posturedmg < 0 then 

				efolder.PermValue:FindFirstChild("Block"):Destroy()
				local FX = game.ReplicatedStorage.Assets.Models.GB.Attachment:Clone()
				FX.Parent = eroot
				game.Debris:AddItem(FX,3)

				for i,v in pairs(FX:GetDescendants()) do
					if v:IsA("ParticleEmitter") then 
						v:Emit(v.Rate)
					end
				end

				ehum:LoadAnimation(game.ReplicatedStorage.Animations.GB):Play()

				stunmodule.Bleed(hit)

				local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
				miscmodule.Create("Temp","Folder",efolder.TempValue,"Stun",1.5)
				miscmodule.Create("Temp","Folder",efolder.TempValue,"TrueSlow",1.5)
				miscmodule.Create("Temp","Folder",efolder.TempValue,"GB",1.5)
				miscmodule.PlaySound("BlockBreak",eroot)


				efolder.Combat.Posture.Value = 100
			else 
				efolder.Combat.Posture.Value -= posturedmg
			end

		end 

	else 

		--katana spec stuff
		local mark = pfolder.PermValue:FindFirstChild('KatanaMark')

		if mark and not info.GB then
			local val = mark:GetChildren()[1]
			if hit.Name == val.Name then
				val.Value += 1
			else
				val.Value = 1
				val.Name = hit.Name
			end
			
			local mui = hit:FindFirstChild('MassacreGUI')
			if mui then
				mui.TextLabel.Script.Enabled = false
				mui.TextLabel.TrueMsg.Value = val.Value 
				mui.TextLabel.Script.Enabled = true
			else
				mui = ReplicatedStorage.VFXStorage.MassacreGUI:Clone()
				mui.TextLabel.TrueMsg.Value = val.Value 
				mui.Parent = hit
			end

			miscmodule.PlayRandomSound('Bell',character.HumanoidRootPart,3)
		end
		
		----------

		if ehum.Health - info.damage <= 5 and not info.GRIP then
			ehum.Health = 5
			local newRagdoll = Instance.new("BoolValue")
			newRagdoll.Name = "Ragdoll"
			newRagdoll.Parent = efolder.TempValue
			game.Debris:AddItem(newRagdoll,100000000000000)
			local newRagdoll1 = Instance.new("BoolValue")
			newRagdoll1.Name = "Knocked"
			newRagdoll1.Parent = efolder.TempValue
			game.Debris:AddItem(newRagdoll1,100000000000000)
			local newRagdoll2 = Instance.new("BoolValue")
			newRagdoll2.Name = "Stun"
			newRagdoll2.Parent = efolder.TempValue
			game.Debris:AddItem(newRagdoll2,100000000000000)
		else

			local damage = info.damage

			if info.blunt  then
				damage  = damage * pfolder.Buffs.TaiBuff.Value
			end 

			if info.Sharp then
				damage  = damage * pfolder.Buffs.WeaponBuff.Value
			end 

			if info.Jutsu then
				damage  = damage * pfolder.Buffs.JutsuBuff.Value
			end 

			damage = damage - damage * efolder.Buffs.DefenseBuff.Value 

			ehum.Health = ehum.Health - damage
			DamageTexts(eroot)
		end 

		if info.ragdoll then
			local newRagdoll = Instance.new("BoolValue")
			newRagdoll.Name = "Ragdoll"
			newRagdoll.Parent = efolder.TempValue
			game.Debris:AddItem(newRagdoll,info.ragdollduration)
		end

		if info.DS then
			stunmodule.DS(hit,character,info.ragdollduration)
		end 


		if info.primary then
			local char = character
			local humanoid = character.Humanoid
			local effects = character.AliveData.TempValue
			local Data = char.AliveData
			local c
			local v = hit
			local hitted = false
			local avoided = false
			local landed = false
			local c

			c = game["Run Service"].Heartbeat:connect(function()



				if hitted then return end
				if avoided then return end

				local behindd = false
				if (character.HumanoidRootPart.Position - v.HumanoidRootPart.CFrame * CFrame.new(0,0,5).Position).magnitude < 6 then
					behindd = true
				end

				if landed == true then return end 

				landed = true

				humanoid.AutoRotate = false

				local Gen = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
				Gen.Create("Temp","Folder",effects,"Cancel",2.5)
				Gen.Create("Temp","Folder",effects,"UsingSkill",2.5)
				Gen.Create("Temp","Folder",effects,"NOJUMP",2.5)
				Gen.Create("Temp","Folder",effects,"MediumSlow",2.5)
				Gen.Create("Temp","Folder",v.AliveData.TempValue,"Cancel",2.5)
				Gen.Create("Temp","Folder",v.AliveData.TempValue,"UsingSkill",2.5)
				Gen.Create("Temp","Folder",v.AliveData.TempValue,"NOJUMP",2.5)
				Gen.Create("Temp","Folder",v.AliveData.TempValue,"MediumSlow",2.5)

				--bvel:Destroy()

				if v.Parent ~= workspace.Alive or not v:FindFirstChild("HumanoidRootPart") then
					humanoid.AutoRotate = true
					return
				end

				for i,v in pairs(v.HumanoidRootPart:GetChildren()) do
					if v:IsA("BodyVelocity") then
						v:Destroy()
					end
					if v:IsA("BodyPosition") then
						v:Destroy()
					end
				end
				for i,v in pairs(character.HumanoidRootPart:GetChildren()) do
					if v:IsA("BodyVelocity") then
						v:Destroy()
					end

					if v:IsA("BodyPosition") then
						v:Destroy()
					end
				end

				local VFX = script.Part.WHIRL:Clone()
				VFX.Parent = hit.HumanoidRootPart
				game.Debris:AddItem(VFX,3)		
				for i,v in pairs(VFX:GetDescendants()) do
					v:Emit(v.Rate)
				end

				v.Humanoid.AutoRotate = false
				v.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0,0,-2.5) * CFrame.Angles(0,math.pi,0)
				character.HumanoidRootPart.Anchored = true
				v.HumanoidRootPart.Anchored = true

				wait(0.1)

				local anim = humanoid:LoadAnimation(script.Animation2)
				anim:Play()

				wait(0.35)

				character.HumanoidRootPart.Anchored = false
				v.HumanoidRootPart.Anchored = false

				v.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(0,0,-2.5) * CFrame.Angles(0,math.pi,0)

				local anim = humanoid:LoadAnimation(script.Animation3)
				anim:Play()
				anim:AdjustSpeed(1.5)
				local anim2 = v.Humanoid:LoadAnimation(script.Animation4)
				anim2:Play()
				anim2:AdjustSpeed(1.5)

				local pos1 = character.HumanoidRootPart.Position
				local pos2 = v.HumanoidRootPart.Position

				local bpos = Instance.new("BodyPosition",character.HumanoidRootPart)
				bpos.MaxForce = Vector3.new(100000,100000,100000)
				bpos.P = 5000
				bpos.D = 500
				bpos.Position = pos1

				local bgyro = Instance.new("BodyGyro",character.HumanoidRootPart)
				bgyro.MaxTorque = Vector3.new(100000,100000,100000)
				bgyro.P = 5000
				bgyro.D = 500
				bgyro.CFrame = character.HumanoidRootPart.CFrame

				local bpos2 = bpos:Clone()
				bpos2.Position = pos2
				bpos2.Parent = v.HumanoidRootPart

				local bgyro2 = bgyro:Clone()
				bgyro2.CFrame = v.HumanoidRootPart.CFrame
				bgyro2.Parent = v.HumanoidRootPart

				local DONT = false

				for i = 1,7 do	
					wait(0.1)


					if v.Parent ~= workspace.Alive then
						bpos:Destroy()
						bpos2:Destroy()
						DONT = true
						bgyro:Destroy()
						bgyro2:Destroy()
						--v.Humanoid.AutoRotate = true
						humanoid.AutoRotate = true
						break
					end


					local VFX = script.Part.WHIRL:Clone()
					VFX.Parent = hit.HumanoidRootPart
					game.Debris:AddItem(VFX,3)		
					for i,v in pairs(VFX:GetDescendants()) do
						v:Emit(v.Rate)
					end

					local genmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
					genmodule.PlaySound("Hit1",root)

					local inc = character.Name == "FireyMcBlox" and 5 or 5
					bpos.Position = bpos.Position + Vector3.new(0,inc,0)
					bpos2.Position = bpos2.Position + Vector3.new(0,inc,0)
					local packet = {
						damage = 5, -- 6.5
						stuntime = 1,
						GB = true,
						nosub= false,
						subbable = false,
					}
					game.ServerStorage.TagHumanoid:Invoke(character, hit, packet)	
				end

				if DONT then return end

				local ignore = {workspace.Projectiles, workspace.Alive}
				local ray = Ray.new(character.HumanoidRootPart.Position, character.HumanoidRootPart.CFrame.upVector * -50)
				local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignore)

				if not hit then
					bpos:Destroy()
					bpos2:Destroy()
					bgyro:Destroy()
					bgyro2:Destroy()
					--		v.Humanoid.AutoRotate = true
					humanoid.AutoRotate = true
				end

				wait(0.2)
				anim2:Stop()
				anim:Stop()

				local grabAnim = humanoid:LoadAnimation(script.AirGrab):Play()
				local s = script.Swing:Clone()
				s.Parent = character.Head
				s.Playing = true
				game.Debris:AddItem(s, 2)
				wait(0.4)
				local anim = humanoid:LoadAnimation(script.LotusSpin)
				anim:Play()
				anim:AdjustSpeed(1)

				local anim2
				if v.Parent == workspace.Alive then
					anim2 = v.Humanoid:LoadAnimation(script.LotusSpinning)
					anim2:Play()
					anim2:AdjustSpeed(1)
				end

				bpos.P = 2000
				bpos2.P = 2000

				bpos.Position = Vector3.new(bpos.Position.X, pos.Y - 5, bpos.Position.Z)
				bpos2.Position = Vector3.new(bpos2.Position.X, pos.Y - 5, bpos2.Position.Z) 

				repeat wait()
					local ignore = {workspace.Projectiles, workspace.Alive}
					local ray = Ray.new(character.HumanoidRootPart.Position, character.HumanoidRootPart.CFrame.upVector * -5)
					local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignore)
				until hit


				bpos:Destroy()
				bpos2:Destroy()
				bgyro:Destroy()
				bgyro2:Destroy()
				anim:Stop()
				anim2:Stop()

				humanoid.AutoRotate = true

				if v.Parent ~= workspace.Alive then return end

				v.Humanoid.AutoRotate = true


				local bvel = Instance.new("BodyVelocity")
				bvel.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
				bvel.Velocity = character.HumanoidRootPart.CFrame.lookVector * 65

				local ignore = {game.Workspace.Alive, game.Workspace.Projectiles}
				local ray = Ray.new(v.HumanoidRootPart.Position, v.HumanoidRootPart.CFrame.upVector * -50)
				local hit = workspace:FindPartOnRayWithIgnoreList(ray, ignore)

				local packet = {
					blunt = true,
					damage = 15, -- 6.5
					stuntime = 1,
					GB = true,
					KB = true,
					nosub= false,
				}
				game.ServerStorage.TagHumanoid:Invoke(character, v, packet)	

				if hit then

					if hit.Name ~= "Water" then


						local effectName = "Crater"		
						local effectParameters = {
							CFrame = character.HumanoidRootPart.CFrame,
							Size = 8,
							Direction = Vector3.new(0,-10,0),
							Rows = 3,
							emitDebris = true,
							emitSmoke = true

						}

						local create = game.ReplicatedStorage.Remotes.createEffect
						create:FireAllClients(effectName, effectParameters)

						spawn(function()
							for i = 1,10 do
								local debree = script.Debree:Clone()
								debree.Parent = game.Workspace
								debree.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,2,0)
								debree.Material = hit.Material
								debree.BrickColor = hit.BrickColor
								debree.Velocity = Vector3.new(math.random(-15,15),60,math.random(-15,15))
								debree.RotVelocity = Vector3.new(math.random(-5, 5), math.random(-5, 5), math.random(-5, 5))
								game.Debris:AddItem(debree,4)
							end
						end)
					else

						local effectName = "Crater"		
						local effectParameters = {
							CFrame = character.HumanoidRootPart.CFrame,
							Size = 8,
							Direction = Vector3.new(0,-10,0),
							Rows = 3,
							emitDebris = true,
							emitSmoke = true

						}

						local create = game.ReplicatedStorage.Remotes.createEffect
						create:FireAllClients(effectName, effectParameters)

					end

				end
			end)
		end

		if info.stuntime then
			efolder.Combat.CombatTag.Value = 30
			stunmodule.Stun(hit,info.stuntime)
		end

		local Temp = efolder.TempValue
		local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
		miscmodule.Destroy(efolder.TempValue,"TrueSlow")
		miscmodule.Destroy(Temp,"Stun")
		miscmodule.Destroy(Temp,"UsingCamp")

		for i,v in pairs(ehum:GetPlayingAnimationTracks()) do
			if v.Name == "Sit" then 
				v:Stop()
			end
		end

		if info.blunt then

			if ehum.MaxHealth * 0.4 > ehum.Health then
				stunmodule.Bleed(hit)
			end 


			stunmodule.Blunt(hit)
			local fx = game.ReplicatedStorage.Assets.VFX.Blunt.Attachment:Clone()
			fx.Parent = hit.HumanoidRootPart
			game.Debris:AddItem(fx,2)
			for i,v in pairs(fx:GetDescendants()) do 
				if v:IsA("ParticleEmitter") then
					v:Emit(v.Rate)
				end
			end 

			local BloodRays = require(game:GetService("ServerScriptService").Miscellaneous.BloodRays)
			BloodRays.CreateRays(hit.HumanoidRootPart,Vector2.new(5,5),Vector2.new(5,10),15)
		end

		if info.Sharp then
			
			if ehum.MaxHealth * 0.4 > ehum.Health then
				stunmodule.Bleed(hit)
			end 
			
			stunmodule.Blunt(hit)
			local fx = game.ReplicatedStorage.Assets.VFX.Sharp.Attachment:Clone()
			fx.Parent = hit.HumanoidRootPart
			game.Debris:AddItem(fx,2)
			for i,v in pairs(fx:GetDescendants()) do 
				if v:IsA("ParticleEmitter") then
					v:Emit(v.Rate)
				end
			end 

			local BloodRays = require(game:GetService("ServerScriptService").Miscellaneous.BloodRays)
			BloodRays.CreateRays(hit.HumanoidRootPart,Vector2.new(5,5),Vector2.new(5,10),15)
		end 

		if info.Uptilt2 then
			
			if character.AliveData.TempValue:FindFirstChild("AirCombo") then
				info.Uptilt = false

				if hit.HumanoidRootPart:FindFirstChild("Knockback") then
					hit.HumanoidRootPart:FindFirstChild("Knockback"):Destroy()
				end

				if character.HumanoidRootPart:FindFirstChild("Knockback") then
					character.HumanoidRootPart:FindFirstChild("Knockback"):Destroy()
				end
				
				if hit.HumanoidRootPart:FindFirstChild("Upward") then
					hit.HumanoidRootPart:FindFirstChild("Upward"):Destroy()
				end

				if character.HumanoidRootPart:FindFirstChild("Upward") then
					character.HumanoidRootPart:FindFirstChild("Upward"):Destroy()
				end
				
				local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
				miscmodule.Create("Temp","Folder",character.AliveData.TempValue,"AirCombo",info.stuntime)

				local misc = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
				misc.Clearvelocity(character)
				misc.Clearvelocity(hit)

				local tvelocity = Instance.new("BodyPosition")
				tvelocity.Name = "Upward"
				tvelocity.MaxForce = Vector3.new(1,1,1)*80000
				tvelocity.P = 10000
				tvelocity.D = 750
				tvelocity.Position = hit.HumanoidRootPart.Position + Vector3.new(0,20,0)
				tvelocity.Parent = hit.HumanoidRootPart
				game.Debris:AddItem(tvelocity,info.stuntime + 1)

				local ye = Vector3.new(character.HumanoidRootPart.Position.X,hit.HumanoidRootPart.Position.Y + 20,character.HumanoidRootPart.Position.Z)
				local velocity = Instance.new("BodyPosition")
				velocity.Name = "Upward"
				velocity.MaxForce = Vector3.new(1,1,1)*80000
				velocity.P = 10000
				velocity.D = 750
				velocity.Position = ye
				velocity.Parent = character.HumanoidRootPart
				game.Debris:AddItem(velocity,info.stuntime + 1)

				return
			end
		end

		if info.Uptilt then 
			local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			miscmodule.Create("Temp","Folder",character.AliveData.TempValue,"AirCombo",info.stuntime)

			local misc = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			misc.Clearvelocity(character)
			misc.Clearvelocity(hit)

			local tvelocity = Instance.new("BodyPosition",hit.HumanoidRootPart)
			tvelocity.MaxForce = Vector3.new(1,1,1)*80000
			tvelocity.P = 10000
			tvelocity.D = 750
			tvelocity.Position = hit.HumanoidRootPart.Position + Vector3.new(0,20,0)
			game.Debris:AddItem(tvelocity,info.stuntime + 1)
			tvelocity.Name = "Upward"
			local ye = Vector3.new(character.HumanoidRootPart.Position.X,hit.HumanoidRootPart.Position.Y + 20,character.HumanoidRootPart.Position.Z)
			local velocity = Instance.new("BodyPosition",character.HumanoidRootPart)
			velocity.MaxForce = Vector3.new(1,1,1)*80000
			velocity.P = 10000
			velocity.D = 750
			velocity.Name = "Upward"
			velocity.Position = ye
			game.Debris:AddItem(velocity,info.stuntime + 1)
		end 

		if ehum:GetState() == Enum.HumanoidStateType.Freefall then 
			if info.NoAirCombo then return end 
			if not info.AirComboExtend then return end 

			if info.KB then 
				local misc = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
				misc.Clearvelocity(hit)
				stunmodule.TreeDestroy(hit)
				stunmodule.KB(hit,character)
			else 

				local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
				miscmodule.Create("Temp","Folder",character.AliveData.TempValue,"AirCombo",info.stuntime)

				local misc = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
				misc.Clearvelocity(hit)

				local tvelocity = Instance.new("BodyVelocity",hit.HumanoidRootPart)
				tvelocity.MaxForce = Vector3.new(1,1,1)*80000
				tvelocity.Velocity = CFrame.new(character.HumanoidRootPart.Position,Vector3.new(hit.HumanoidRootPart.Position.X,character.HumanoidRootPart.Position.Y,hit.HumanoidRootPart.Position.Z)).LookVector * 10
				game.Debris:AddItem(tvelocity,0.8)
				tvelocity.Name = "Knockback"
			end 
		end 


		if hum:GetState() == Enum.HumanoidStateType.Freefall then 
			if info.NoAirCombo then return end 
			if not info.AirComboExtend then return end 

			local misc = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			misc.Clearvelocity(character)

			local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			miscmodule.Create("Temp","Folder",character.AliveData.TempValue,"AirCombo",info.stuntime)

			local velocity = Instance.new("BodyVelocity",character.HumanoidRootPart)
			velocity.MaxForce = Vector3.new(1,1,1)*80000
			velocity.Velocity = CFrame.new(character.HumanoidRootPart.Position,Vector3.new(hit.HumanoidRootPart.Position.X,character.HumanoidRootPart.Position.Y,hit.HumanoidRootPart.Position.Z)).LookVector * 10
			velocity.Name = "Knockback"
			game.Debris:AddItem(velocity,0.8)
		end
		
		if info.bruise then
			stunmodule.Bruise(hit)
		end

		if info.KB then
			stunmodule.TreeDestroy(hit)
			stunmodule.KB(hit,character)
		end
		
		

		if info.UPKB then
			stunmodule.TreeDestroy(hit)
			stunmodule.UPKB(hit,character)
		end
	end
end

ServerStorage.TagHumanoid.OnInvoke = function(a, b, c)
	return tag(a, b, c)
end