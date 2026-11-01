local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")

task.wait(0.5)

local FX = require(ReplicatedStorage.Modules.FX.FX)
local AliveData = script.AliveData:Clone()
AliveData.Parent = script.Parent
print(script.Parent.Name.." has been granted AliveData")
local rem = script.Remotes.ControllerRemote
local parrytick = 0 
local on = false

rem.OnServerEvent:Connect(function(plr,Action,SpaceHeld)

	local char = plr.Character
	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local Temp = AliveData.TempValue
	local CDS = AliveData.CDS
	local idle = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.Idle)
	local miscmodule = require(ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	
	if Action == "GetUp" then
		local miscmodule = require(ReplicatedStorage.Modules.GeneralUse.ModuleScript)
		miscmodule.Destroy(Temp,"TrueSlow")
		miscmodule.Destroy(Temp,"Stun")
		miscmodule.Destroy(Temp,"UsingCamp")
		for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
			if v.Name == "Sit" then 
				v:Stop()
			end
		end

	end 

	--if Action == "Head" then

	--	if ReplicatedStorage.PlayerData:WaitForChild(char.Name).Torso.Value == "Hood" then
	--		if on == false then 
	--			on = true
	--			for i,v in pairs(char:GetDescendants()) do
	--				if v.Name == "HoodNeck" then
	--					v.Transparency = 1
	--				end 
	--			end  

	--			for i,v in pairs(char:GetDescendants()) do
	--				if v.Name == "Hoodie" then
	--					v.Transparency = 0
	--				end 
	--			end   

	--			for i,v in pairs(char:GetDescendants()) do
	--				if v.Name == "PlayerHair" then
	--					v.Handle.Transparency = 1
	--				end 
	--			end  
	--		else 
	--			on = false

	--			for i,v in pairs(char:GetDescendants()) do
	--				if v.Name == "Hoodie" then
	--					v.Transparency = 1
	--				end 
	--			end  

	--			for i,v in pairs(char:GetDescendants()) do
	--				if v.Name == "HoodNeck" then
	--					v.Transparency = 0
	--				end 
	--			end   

	--			for i,v in pairs(char:GetDescendants()) do
	--				if v.Name == "PlayerHair" then
	--					v.Handle.Transparency = 0
	--				end 
	--			end  

	--		end 
	--	end

	--end 

	if Action == "Runn" then
		miscmodule.Create("Perm","Folder",Perm,"Run")
	end

	if Action == "NoRun" then
		miscmodule.Destroy(AliveData,"Run")
	end
	
	if Action == "M2" then
		miscmodule.Create("Perm","Folder",Perm,"M2")
	end


	if Action == "M2Stop" then
		miscmodule.Destroy(AliveData,"M2")
	end


	if Action == "Equip" then
		if ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Dagger" then
			if AliveData.Combat:FindFirstChild("Equipped") then

				print("Destroyed Kunai")
				for i,v in pairs(char:GetDescendants())do
					if v.Name == "BodyAttach" then
						v:Destroy()
					end
				end 

				for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					if v.Name == "IDLE" then 
						v:Stop()
					end
				end 

				miscmodule.Destroy(AliveData,"Equipped")

			else 
				local Kunai = ReplicatedStorage.Assets.Models.Dagger["BodyAttach"]:Clone()
				Kunai.Parent = char["Right Arm"]
				Kunai.Cool.Part0 = char["Right Arm"]

				local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.Dagger.IDLE)
				anim:Play()

				miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")
			end 


		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Katana" then
			if AliveData.Combat:FindFirstChild("Equipped") then

				print("Destroyed Kunai")
				for i,v in pairs(char:GetDescendants())do
					if v.Name == "BodyAttach" then
						v:Destroy()
					end
				end 

				for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					if v.Name == "IDLE" then 
						v:Stop()
					end
				end 

				miscmodule.Destroy(AliveData,"Equipped")


			else 

				local Kunai = ReplicatedStorage.Assets.Models.Katana["BodyAttach"]:Clone()
				Kunai.Parent = char["Right Arm"]
				Kunai.ToolGrip.Part0 = char["Right Arm"]

				local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.Katana.IDLE)
				anim:Play()

				miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")

			end 


		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Scythe" then
			if AliveData.Combat:FindFirstChild("Equipped") then

				print("Destroyed Kunai")
				for i,v in pairs(char:GetDescendants())do
					if v.Name == "BodyAttach" then
						v:Destroy()
					end
				end 

				for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					if v.Name == "IDLE" then 
						v:Stop()
					end
				end 

				miscmodule.Destroy(AliveData,"Equipped")


			else 

				local Kunai = ReplicatedStorage.Assets.Models.Scythe["BodyAttach"]:Clone()
				Kunai.Parent = char["Right Arm"]
				Kunai.ToolGrip.Part0 = char["Right Arm"]

				local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.Scythe.IDLE)
				anim:Play()

				miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")

			end 


		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Bat" then
			if AliveData.Combat:FindFirstChild("Equipped") then

				print("Destroyed Kunai")
				for i,v in pairs(char:GetDescendants())do
					if v.Name == "BodyAttach" then
						v:Destroy()
					end
				end 

				for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					if v.Name == "IDLE" then 
						v:Stop()
					end
				end 

				miscmodule.Destroy(AliveData,"Equipped")


			else 

				local Kunai = ReplicatedStorage.Assets.Models.Bat["BodyAttach"]:Clone()
				Kunai.Parent = char["Right Arm"]
				Kunai.ToolGrip.Part0 = char["Right Arm"]

				local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.Bat.IDLE)
				anim:Play()

				miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")

			end 

		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "SheathedKatana" then
			if AliveData.Combat:FindFirstChild("Equipped") then

				print("Destroyed Kunai")
				for i,v in pairs(char:GetDescendants())do
					if v.Name == "BodyAttach" then
						v:Destroy()
					end
				end 
				
				char.AccessoryKatana.Transparency = 0
				for i,v in pairs(char.AccessoryKatana:GetChildren()) do
					if v:IsA('MeshPart') or v:IsA('Part') then
						v.Transparency = 0
					end
				end

				for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					if v.Name == "IDLE" then 
						v:Stop()
					end
				end 

				miscmodule.Destroy(AliveData,"Equipped")


			else 

				local Kunai = ReplicatedStorage.Assets.Models.SheathedKatana["BodyAttach"]:Clone()
				Kunai.Parent = char["Right Arm"]
				Kunai.ToolGrip.Part0 = char["Right Arm"]

				char.AccessoryKatana.Transparency = 1
				for i,v in pairs(char.AccessoryKatana:GetChildren()) do
					if v:IsA('MeshPart') or v:IsA('Part') then
						v.Transparency = 1
					end
				end
				
				local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.SheathedKatana.IDLE)
				anim:Play()

				miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")

			end
			
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Rapier" then
			if AliveData.Combat:FindFirstChild("Equipped") then

				print("Destroyed Kunai")
				for i,v in pairs(char:GetDescendants())do
					if v.Name == "BodyAttach" then
						v:Destroy()
					end
				end 

				for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					if v.Name == "IDLE" then 
						v:Stop()
					end
				end 

				miscmodule.Destroy(AliveData,"Equipped")


			else 

				local Kunai = ReplicatedStorage.Assets.Models.Rapier["BodyAttach"]:Clone()
				Kunai.Parent = char["Right Arm"]
				Kunai.cool.Part0 = char["Right Arm"]

				local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.Rapier.IDLE)
				anim:Play()

				miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")

			end 
			
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Pistol" then
			if AliveData.Combat:FindFirstChild("Equipped") then
				for i,v in pairs(char:GetDescendants())do
					if v.Name == "BodyAttach" then
						v:Destroy()
					end
				end 

				for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					if v.Name == "Idle" then 
						v:Stop()
					end
				end 

				miscmodule.Destroy(AliveData,"Equipped")

			else 

				local Kunai = ReplicatedStorage.Assets.Models.Pistol["BodyAttach"]:Clone()
				Kunai.ToolGrip.Part0 = char["Right Arm"]
				Kunai.Position = char["Right Arm"].RightGripAttachment.Position
				Kunai.Parent = char["Right Arm"]

				local Kunai = ReplicatedStorage.Assets.Models.Pistol["BodyAttach"]:Clone()
				Kunai.ToolGrip.Part0 = char["Left Arm"]
				Kunai.Position = char["Left Arm"].LeftGripAttachment.Position
				Kunai.Parent = char["Left Arm"]

				local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.Pistol.Idle)
				anim:Play()

				miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")
			end
			
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Nyvox" then
			if AliveData.Combat:FindFirstChild("Equipped") then
				for i,v in pairs(char:GetDescendants())do
					if v.Name == "BodyAttach" then
						v:Destroy()
					end
				end 

				for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					if v.Name == "Idle" then 
						v:Stop()
					end
				end 

				miscmodule.Destroy(AliveData,"Equipped")

			else 

				local Kunai = ReplicatedStorage.Assets.Models.InvertedSpear["BodyAttach"]:Clone()
				Kunai.ToolGrip.Part0 = char["Right Arm"]
				Kunai.Position = char["Right Arm"].RightGripAttachment.Position
				Kunai.Parent = char["Right Arm"]

				local Kunai = ReplicatedStorage.Assets.Models.InvertedSpear["BodyAttach"]:Clone()
				Kunai.ToolGrip.Part0 = char["Left Arm"]
				Kunai.Position = char["Left Arm"].LeftGripAttachment.Position
				Kunai.Parent = char["Left Arm"]

				local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.Nyvox.Idle)
				anim:Play()
				anim.Priority = Enum.AnimationPriority.Idle

				miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")
			end
			
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Nyvox2" then
			if AliveData.Combat:FindFirstChild("Equipped") then
				for i,v in pairs(char:GetDescendants())do
					if v.Name == "BodyAttach" then
						v:Destroy()
					end
				end 

				for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					if v.Name == "Idle" then 
						v:Stop()
					end
				end 

				miscmodule.Destroy(AliveData,"Equipped")

			else 

				local Kunai = ReplicatedStorage.Assets.Models.Nyvox["BodyAttach"]:Clone()
				Kunai.ToolGrip.Part0 = char["Right Arm"]
				Kunai.Position = char["Right Arm"].RightGripAttachment.Position
				Kunai.Parent = char["Right Arm"]


				local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.Nyvox2.IDLE)
				anim:Play()

				miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")
			end
			
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Sickles" then
			if AliveData.Combat:FindFirstChild("Equipped") then
				for i,v in pairs(char:GetDescendants())do
					if v.Name == "BodyAttach" then
						v:Destroy()
					end
				end 

				for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					if v.Name == "Idle" then 
						v:Stop()
					end
				end 

				miscmodule.Destroy(AliveData,"Equipped")

			else 

				local Kunai = ReplicatedStorage.Assets.Models.Sickles["BodyAttach"]:Clone()
				Kunai.Cool.Part0 = char["Right Arm"]
				Kunai.Position = char["Right Arm"].RightGripAttachment.Position
				Kunai.Parent = char["Right Arm"]

				local Kunai = ReplicatedStorage.Assets.Models.Sickles["BodyAttach"]:Clone()
				Kunai.Cool.Part0 = char["Left Arm"]
				Kunai.Position = char["Left Arm"].LeftGripAttachment.Position
				Kunai.Parent = char["Left Arm"]

				local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.Pistol.Idle)
				anim:Play()

				miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")
			end
			
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Spear" then
			if AliveData.Combat:FindFirstChild("Equipped") then

				print("Destroyed Kunai")
				for i,v in pairs(char:GetDescendants())do
					if v.Name == "BodyAttach" then
						v:Destroy()
					end
				end 

				for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					if v.Name == "IDLE" then 
						v:Stop()
					end
				end 

				miscmodule.Destroy(AliveData,"Equipped")


			else 

				local Kunai = ReplicatedStorage.Assets.Models.Spear["BodyAttach"]:Clone()
				Kunai.Parent = char["Right Arm"]
				Kunai.cool.Part0 = char["Right Arm"]

				local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.Spear.IDLE)
				anim:Play()

				miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")

			end 
			
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "GreatSword" then
			if AliveData.Combat:FindFirstChild("Equipped") then

				print("Destroyed Kunai")
				for i,v in pairs(char:GetDescendants())do
					if v.Name == "BodyAttach" then
						v:Destroy()
					end
				end 

				for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					if v.Name == "IDLE" then 
						v:Stop()
					end
				end 

				miscmodule.Destroy(AliveData,"Equipped")


			else 

				local Kunai = ReplicatedStorage.Assets.Models.GreatSword["BodyAttach"]:Clone()
				Kunai.Parent = char["Right Arm"]
				Kunai.Weld.Part0 = char["Right Arm"]

				local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.GreatSword.IDLE)
				anim:Play()

				miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")

			end
			
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Nichrin" then
			if AliveData.Combat:FindFirstChild("Equipped") then
				for i,v in pairs(char:GetDescendants())do
					if v.Name == "BodyAttach" then
						v:Destroy()
					end
				end 

				for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					if v.Name == "Idle" then 
						v:Stop()
					end
				end 

				miscmodule.Destroy(AliveData,"Equipped")

			else 

				local Kunai = ReplicatedStorage.Assets.Models.Nichrin["BodyAttach"]:Clone()
				Kunai.ToolGrip.Part0 = char["Right Arm"]
				Kunai.Position = char["Right Arm"].RightGripAttachment.Position
				Kunai.Parent = char["Right Arm"]

				local Kunai = ReplicatedStorage.Assets.Models.Nichrin["BodyAttach"]:Clone()
				Kunai.ToolGrip.Part0 = char["Left Arm"]
				Kunai.Position = char["Left Arm"].LeftGripAttachment.Position
				Kunai.Parent = char["Left Arm"]

				local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.Pistol.Idle)
				anim:Play()

				miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")
			end
			
			
		 


		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Fist" then
			if AliveData.Combat:FindFirstChild("Equipped") then

			for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
			end 

			miscmodule.Destroy(AliveData,"Equipped")

		else 
			miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped") 
			idle:Play()
			idle.Priority = Enum.AnimationPriority.Idle
			miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")
		end 
		

			
			elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Admin" then
	if AliveData.Combat:FindFirstChild("Equipped") then

		print("Destroyed Kunai")
		for i,v in pairs(char:GetDescendants())do
			if v.Name == "BodyAttach" then
				v:Destroy()
			end
		end 

		for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
			if v.Name == "IDLE" then 
				v:Stop()
			end
		end 

		miscmodule.Destroy(AliveData,"Equipped")


	else 

		local Kunai = ReplicatedStorage.Assets.Models.Admin["BodyAttach"]:Clone()
		Kunai.Parent = char["Right Arm"]
		Kunai.Weld.Part0 = char["Right Arm"]

		local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.Admin.IDLE)
		anim:Play()

		miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")

	end
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Rifle" then
			if AliveData.Combat:FindFirstChild("Equipped") then
				for i,v in pairs(char:GetDescendants())do
					if v.Name == "BodyAttach" then
						v:Destroy()
					end
				end 

				for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
					if v.Name == "Idle" then 
						v:Stop()
					end
				end 

				miscmodule.Destroy(AliveData,"Equipped")

			else 
				
				local anim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.Rifle.Idle)
				anim:Play()

				local Kunai = ReplicatedStorage.Assets.Models.Rifle["BodyAttach"]:Clone()
				Kunai.ToolGrip.Part0 = char["Right Arm"]
				Kunai.Position = char["Right Arm"].RightGripAttachment.Position
				Kunai.Parent = char["Right Arm"]

				miscmodule.Create("Perm","Folder",AliveData.Combat,"Equipped")
			end
				miscmodule.Destroy(AliveData,"Equipped")
		end 

	end 
	
	------------EQUIPPING KUNAI ------------

	if Action == "Block" then
		if Temp:FindFirstChild("Ragdoll") then return end 
		if AliveData.TempValue:FindFirstChild("Cancel") then return end 
		if AliveData.TempValue:FindFirstChild("LA") then return end 
		if AliveData.TempValue:FindFirstChild("UsingSkill") then return end 
		if AliveData.TempValue:FindFirstChild("GB") then return end 

		spawn(function()
			miscmodule.Create("Temp","Folder",Temp,"NoRun",0.5)
			miscmodule.PlaySound("Block",char.HumanoidRootPart)
		end)



		local blockanim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations.FistBlock)
		blockanim:Play()
		blockanim.Priority = Enum.AnimationPriority.Action

		local Blocking = Instance.new("Folder")
		Blocking.Name = "Block"
		Blocking.Parent = Perm

		if tick() - parrytick >= 2 then	
			parrytick = tick()

			local Parry = Instance.new("Folder")
			Parry.Name = "Parry"
			Parry.Parent = Temp
			game.Debris:AddItem(Parry,0.3)

			local parryanim = char.Humanoid:LoadAnimation(ReplicatedStorage.Animations:WaitForChild("ParryTick"..math.random(1,3)))
			parryanim:Play()
			parryanim.Priority = Enum.AnimationPriority.Action2

			miscmodule.PlaySound("ParryTick",char.Torso)
		end


		local StopBlocking = nil
		StopBlocking = Perm.ChildRemoved:Connect(function(t)
			task.wait()
			if not Blocking.Parent then
				if Blocking.Parent then
					Blocking:Destroy()
				end
				blockanim:Stop()
				StopBlocking:Disconnect()
			end
		end)

	end

	if Action == "UnBlock" then
		miscmodule.Destroy(Perm,"Block")
	end

	if Action == "NoRun" then
		miscmodule.Destroy(Perm,"Run")
	end

	if Action == "M1" then
		if AliveData.PermValue:FindFirstChild("Block") then return end 
		if AliveData.TempValue:FindFirstChild("UsingSkill") then return end 
		miscmodule.Destroy(Perm,"Block")
		if ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Dagger" or ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "InvertedSpear" then
			local combat = require(game.ServerScriptService.Combat.Dagger)
			combat.LightAttack(char,SpaceHeld)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Sickles" or ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "InvertedSpear" then
				local combat = require(game.ServerScriptService.Combat.Sickles)
				combat.LightAttack(char,SpaceHeld)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Nyvox2" or ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "InvertedSpear" then
			local combat = require(game.ServerScriptService.Combat.Nyvox2)
			combat.LightAttack(char,SpaceHeld)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Katana" then
			local combat = require(game.ServerScriptService.Combat.Katana)
			combat.LightAttack(char,SpaceHeld)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Bat" then
			local combat = require(game.ServerScriptService.Combat.Bat)
			combat.LightAttack(char,SpaceHeld)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "SheathedKatana" then
			local combat = require(game.ServerScriptService.Combat.SheathedKatana)
			combat.LightAttack(char,SpaceHeld)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Scythe" then
			local combat = require(game.ServerScriptService.Combat.Scythe)
			combat.LightAttack(char,SpaceHeld)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Nichrin" then
			local combat = require(game.ServerScriptService.Combat.Pistol)
			combat.LightAttack(char,SpaceHeld)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Spear" then
			local combat = require(game.ServerScriptService.Combat.Spear)
			combat.LightAttack(char,SpaceHeld)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Nyvox" then
			local combat = require(game.ServerScriptService.Combat.InvertedSpear)
			combat.LightAttack(char,SpaceHeld)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Pistol" then
			local combat = require(game.ServerScriptService.Combat.Pistol)
			combat.LightAttack(char,SpaceHeld)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Rapier" then
			local combat = require(game.ServerScriptService.Combat.Rapier)
			combat.LightAttack(char,SpaceHeld)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Rifle" then
			local combat = require(game.ServerScriptService.Combat.Rifle)
			combat.LightAttack(char,SpaceHeld)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Admin" then
			local combat = require(game.ServerScriptService.Combat.GreatSword)
			combat.LightAttack(char,SpaceHeld)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "GreatSword" then
			local combat = require(game.ServerScriptService.Combat.GreatSword)
			combat.LightAttack(char,SpaceHeld)
		else
			local combat = require(game.ServerScriptService.Combat.Fists)
			combat.LightAttack(char,SpaceHeld)
		end
	end
	
	if Action == "AirM1" then
		if AliveData.PermValue:FindFirstChild("Block") then return end 
		if AliveData.TempValue:FindFirstChild("UsingSkill") then return end 
		if ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Fist" then
			local combat = require(game.ServerScriptService.Combat.Fists)
			combat.AirM1(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Pistol" then
			local combat = require(game.ServerScriptService.Combat.Pistol)
			combat.AirM1(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Dagger" then
			local combat = require(game.ServerScriptService.Combat.Dagger)
			combat.AirM1(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Nyvox2" then
			local combat = require(game.ServerScriptService.Combat.Nyvox2)
			combat.AirM1(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Rapier" then
			local combat = require(game.ServerScriptService.Combat.Rapier)
			combat.AirM1(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Spear" then
			local combat = require(game.ServerScriptService.Combat.Spear)
			combat.AirM1(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "GreatSword" then
			local combat = require(game.ServerScriptService.Combat.GreatSword)
			combat.AirM1(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Katana" then
			local combat = require(game.ServerScriptService.Combat.Katana)
			combat.AirM1(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Scythe" then
			local combat = require(game.ServerScriptService.Combat.Scythe)
			combat.AirM1(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Bat" then
			local combat = require(game.ServerScriptService.Combat.Bat)
			combat.AirM1(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "SheathedKatana" then
			local combat = require(game.ServerScriptService.Combat.SheathedKatana)
			combat.AirM1(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Nyvox" then
			local combat = require(game.ServerScriptService.Combat.InvertedSpear)
			combat.AirM1(char)
		end
	end

	if Action == "RushM2" then
		if AliveData.PermValue:FindFirstChild("Block") then return end 
		if AliveData.TempValue:FindFirstChild("UsingSkill") then return end 
		local combat = require(game.ServerScriptService.Combat.Fists)
		combat.Rush(char)
	end

	if Action == "Heavy" then
		if AliveData.PermValue:FindFirstChild("Block") then return end 
		if AliveData.TempValue:FindFirstChild("UsingSkill") then return end 
		
		if ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Dagger" then
			local combat = require(game.ServerScriptService.Combat.Dagger)
			combat.Heavy(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Sickles" then
					local combat = require(game.ServerScriptService.Combat.Sickles)
					combat.Heavy(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Spear" then
			local combat = require(game.ServerScriptService.Combat.Spear)
			combat.Heavy(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Rapier" then
			local combat = require(game.ServerScriptService.Combat.Rapier)
			combat.Heavy(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Nyvox" then
			local combat = require(game.ServerScriptService.Combat.InvertedSpear)
			combat.Heavy(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Pistol" then
			local combat = require(game.ServerScriptService.Combat.Pistol)
			combat.Heavy(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Scythe" then
			local combat = require(game.ServerScriptService.Combat.Scythe)
			combat.Heavy(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Nichrin" then
			local combat = require(game.ServerScriptService.Combat.Pistol)
			combat.Heavy(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Nyvox2" then
			local combat = require(game.ServerScriptService.Combat.Nyvox2)
			combat.Heavy(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Rifle" then
			local combat = require(game.ServerScriptService.Combat.Rifle)
			combat.Heavy(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "Admin" then
			local combat = require(game.ServerScriptService.Combat.GreatSword)
			combat.Heavy(char)
		elseif ReplicatedStorage.PlayerData:FindFirstChild(char.Name).Weapon.Value == "GreatSword" then
			local combat = require(game.ServerScriptService.Combat.GreatSword)
			combat.Heavy(char)
		else
			local combat = require(game.ServerScriptService.Combat.Fists)
			combat.Heavy(char)
		end
	end
	
	if Action == "Slam" then
		if AliveData.PermValue:FindFirstChild("Block") then return end 
		if AliveData.TempValue:FindFirstChild("UsingSkill") then return end 
		local combat = require(game.ServerScriptService.Combat.Fists)
		combat.AirHeavy(char)
	end

end)

game:GetService("RunService").Stepped:Connect(function()
	local c = script.Parent
	if c.AliveData.TempValue:FindFirstChild("Parried") then
		parrytick = 0 
	end 
	
	if c.Humanoid.Health > 5 then 
		if c.AliveData.TempValue:FindFirstChild("Knocked") then

			local miscmodule = require(ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			miscmodule.Destroy(c.AliveData,"Knocked")
			miscmodule.Destroy(c.AliveData,"Ragdoll")
			miscmodule.Destroy(c.AliveData,"Stun")

		end
	end

	local char = script.Parent
	char:WaitForChild("Head")

	if char:WaitForChild("AliveData").Combat.CombatTag.Value > 0 then 
		if char:WaitForChild("AliveData"):WaitForChild("TempValue"):FindFirstChild("Stim") then
			char.Humanoid.Health = char.Humanoid.Health + char.Humanoid.MaxHealth * 0.001
		elseif char:WaitForChild("AliveData"):WaitForChild("TempValue"):FindFirstChild("UsingCamp") then
			char.Humanoid.Health = char.Humanoid.Health + char.Humanoid.MaxHealth * 0.0001
		end 
	else
		if char:WaitForChild("AliveData"):WaitForChild("TempValue"):FindFirstChild("Stim") then 
			char.Humanoid.Health = char.Humanoid.Health + char.Humanoid.MaxHealth * 0.002
		elseif char:WaitForChild("AliveData"):WaitForChild("TempValue"):FindFirstChild("UsingCamp") then
			char.Humanoid.Health = char.Humanoid.Health + char.Humanoid.MaxHealth * 0.001
		end 
		char.Humanoid.Health = char.Humanoid.Health + char.Humanoid.MaxHealth * 0.00005
	end

end)