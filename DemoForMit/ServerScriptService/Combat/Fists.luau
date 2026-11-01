local module = {}

module.LightAttack = function(char,SpaceHeld)
	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local Temp = AliveData.TempValue

	if Perm:FindFirstChild("Block") then return end 
	if Temp:FindFirstChild("LA") then return end 
	if Temp:FindFirstChild("EndLag") then return end 
	if Temp:FindFirstChild("Cancel") then return end
	if Temp:FindFirstChild("Stun") or Temp:FindFirstChild("Ragdoll") then return end 

	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)

	miscmodule.Destroy(Perm,"Run")
	miscmodule.Create("Temp","Folder",Temp,"LA",0.5)
	miscmodule.Create("Temp","Folder",Temp,"MediumSlow",0.6)
	miscmodule.Create("Temp","Folder",Temp,"NoRun",0.6)
	miscmodule.Create("Temp","Folder",Temp,"SPRINTCD",0.4)
	miscmodule.Create("Temp","Folder",Temp,"JUMPCD",0.9)

	spawn(function()
		task.wait(0.1)
		miscmodule.Create("Temp","Folder",Temp,"CanFeint",0.24)
	end)

	local currentcombo = AliveData.Combat.ComboValue
	currentcombo.Value = currentcombo.Value + 1

	if currentcombo.Value > 5 or (tick() - AliveData.Combat.ComboTimer.Value) > 1.25 then
		currentcombo.Value = 1
	end

	local KB = false

	if currentcombo.Value == 5 then
		KB = true
		miscmodule.Create("Temp","Folder",Temp,"EndLag",0.8)
	end

	spawn(function()
		local Params = {
			damage = 8;
			bruise = true;
			stuntime = 0.9;
			blunt = true;
			KB = KB;
			AirComboExtend = true;
			ragdollduration = 0.8;	
		}
		
		if currentcombo.Value == 4 and SpaceHeld == true then
			Params.Uptilt = true
		end

		task.wait(0.07)

		local hb = require(script.Parent.HITBOXING)

		task.wait(0.140)
		hb.LingeringFrontHB(AliveData,char,Params,4,0.2)
	end)

	AliveData.Combat.ComboTimer.Value = tick()

	local anim = char.Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.Fists:FindFirstChild("Fist"..currentcombo.Value))
	for i, v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
		if string.find("Fist",v.Name) and v.Name ~= anim.Name then
			v:Stop()
		end
	end 
	anim:Play()
	anim.Priority = Enum.AnimationPriority.Action2
	anim:AdjustSpeed(1.3)

	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	if currentcombo == 4 then
		miscmodule.PlayRandomSound("Fist",char.HumanoidRootPart,3)
	elseif currentcombo.Value == 1 or currentcombo.Value == 3 then
		miscmodule.PlayRandomSound("Fist",char.HumanoidRootPart,3)
	else 
		miscmodule.PlayRandomSound("Fist",char.HumanoidRootPart,3)
	end 

	local jalooper

	jalooper = game:GetService("RunService").Stepped:Connect(function()
		if Perm:FindFirstChild("M2") and Temp:FindFirstChild("CanFeint") then
			if Temp:FindFirstChild("FeintCD") then return end 

			spawn(function()
				task.wait(0.13)
				miscmodule.Destroy(AliveData,"LA")
			end)

			local FeintCD = Instance.new("Folder",Temp)
			FeintCD.Name = "FeintCD"
			game.Debris:AddItem(FeintCD,2)

			local Feinted = Instance.new("Folder",Temp)
			Feinted.Name = "Feinted"
			game.Debris:AddItem(Feinted,0.5) 

			anim:Stop()

			local highlight = Instance.new("Highlight", char)
			highlight.DepthMode = Enum.HighlightDepthMode.Occluded
			highlight.FillColor = Color3.fromRGB(255, 234, 149)
			highlight.FillTransparency = 1
			highlight.OutlineColor = Color3.fromRGB(255, 242, 93)
			highlight.OutlineTransparency = 0.55

			currentcombo.Value -= 1 

			local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			miscmodule.PlaySound("Feint",char.HumanoidRootPart)

			local Goal = {
				["FillTransparency"] = 1,
				["OutlineTransparency"] = 1,
			}
			local Info = TweenInfo.new(.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local Tween = game:GetService("TweenService"):Create(highlight, Info, Goal)
			Tween:Play()

			game:GetService("Debris"):AddItem(highlight, Info.Time)
			jalooper:Disconnect()
		end
	end)
end

module.AirM1 = function(char)
	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local Temp = AliveData.TempValue
	local CDS = AliveData.CDS
	local lastAttack = 0

	if Perm:FindFirstChild("Block") then return end 
	if Temp:FindFirstChild("LA") then return end 
	if Temp:FindFirstChild("EndLag") then return end 
	if Temp:FindFirstChild("Cancel") then return end
	if Temp:FindFirstChild("AirCD") then return end
	if Temp:FindFirstChild("Stun") or Temp:FindFirstChild("Ragdoll") then return end 
	if Temp:FindFirstChild("AIRM1MCD") then return end

	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)

	miscmodule.Destroy(Perm,"Run")
	miscmodule.Create("Temp","Folder",Temp,"LA",0.6)
	miscmodule.Create("Temp","Folder",Temp,"MediumSlow",0.6)
	miscmodule.Create("Temp","Folder",Temp,"NoRun",0.6)
	miscmodule.Create("Temp","Folder",Temp,"SPRINTCD",0.4)
	miscmodule.Create("Temp","Folder",Temp,"AIRM1MCD",6)

	local BM = Instance.new("BodyVelocity")
	BM.Name = "Fling"
	BM.MaxForce  = Vector3.new(65000, 3000, 65000)
	BM.P = 20000
	BM.Velocity = char.HumanoidRootPart.CFrame.LookVector * 28 + Vector3.new(0,-16,0)
	BM.Parent = char.HumanoidRootPart
	game.Debris:AddItem(BM, 0.6)

	local anim = char.Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.Fists:FindFirstChild("AirFist"))
	anim:Play()
	anim.Priority = Enum.AnimationPriority.Action2

	local HRP = char.HumanoidRootPart

	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	miscmodule.PlaySound("Up",char.HumanoidRootPart,3)

	local Params = {
		damage = 25;
		bruise = true;
		stuntime = 0.9;
		blunt = true;
		GB = true;
		KB = false;
		ragdollduration = 0.8;	
	}

	spawn(function()
		task.wait(0.1)
		local hb = require(script.Parent.HITBOXING)
		hb.LingeringFrontHB(AliveData,char,Params,10,0.6)
	end)
end

module.Heavy = function(char)
	local DataFolder = game.ReplicatedStorage["PlayerData"]:WaitForChild(char.Name)
	local Weapon = DataFolder.Weapon.Value
	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local Temp = AliveData.TempValue
	local CDS = AliveData.CDS
	local lastAttack = 0

	if Perm:FindFirstChild("Block") then return end 
	if Temp:FindFirstChild("LA") then return end 
	if Temp:FindFirstChild("EndLag") then return end 
	if Temp:FindFirstChild("Cancel") then return end
	if Temp:FindFirstChild("HeavyCD") then return end
	if Temp:FindFirstChild("Stun") or Temp:FindFirstChild("Ragdoll") then return end 

	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	local FXMOD = require(game.ReplicatedStorage.Modules.FX.FX)
	FXMOD.Rush(char,false)
	local character = char

	miscmodule.Destroy(Perm,"Run")
	miscmodule.Create("Temp","Folder",Temp,"Cancel",1)
	miscmodule.Create("Temp","Folder",Temp,"NoRun",0.5)
	miscmodule.Create("Temp","Folder",Temp,"TrueSlow",0.7)
	miscmodule.Create("Temp","Folder",Temp,"SPRINTCD",0.5)
	miscmodule.Create("Temp","Folder",Temp,"HeavyCD",4)
	miscmodule.Create("Temp","Folder",Temp,"EndLag",0.8)

	local VFX1 = game.ReplicatedStorage.Assets.VFX.FistCrit.Crit:Clone()
	VFX1.Parent = char.HumanoidRootPart
	game.Debris:AddItem(VFX1,3)
	for i,v in pairs(VFX1:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v:Emit(v.Rate)
		end 
	end

	local anim = char.Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.Fists:FindFirstChild("FistHeavy"))
	anim:Play()
	anim:AdjustSpeed(0.2)
	anim.Priority = Enum.AnimationPriority.Action2

	local HRP = char.HumanoidRootPart
	miscmodule.PlaySound("Crit",char.HumanoidRootPart)

	local stunned = false
	local con
	con = char.AliveData.TempValue.ChildAdded:Connect(function(v)
		if v.Name == "Stunned" or v.Name == "Stun" then
			stunned = true
		end
	end)
	local t = tick()
	while true do
		if tick() - t >= 0.3 then
			break
		end


		if stunned then
			break
		end
		task.wait()
	end
	con:Disconnect()

	anim:AdjustSpeed(1.5)
	
		local Params = { 
		damage = 10;               
		bruise = true;          
		stuntime = 0.9;
		blunt = true;
		GB = true;
		KB = false;   
		TrailManager = {          
			Enabled = false;
			Limbs = {"RightArm", "LeftArm"};
		}
	}

	if not stunned then
		miscmodule.PlaySound("Up",char.HumanoidRootPart,3)



		spawn(function()
			task.wait(0.1)
			local hb = require(script.Parent.HITBOXING)
			hb.FrontHB(AliveData,char,Params,6,0.6)


			local vfx = game.ReplicatedStorage.Assets.VFX.FistCrit.Attachment:Clone()
			vfx.Parent = char.HumanoidRootPart
			game.Debris:AddItem(vfx,4)
			if char.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then

			else 
				task.wait(0.15)
				for i,v in pairs(vfx:GetDescendants()) do
					task.wait()
					if v:IsA("ParticleEmitter") then
						v:Emit(v.Rate)
					end 
				end
			end
		end)
	else
		for i, v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
			if v.Name == anim.Name then
				v:Stop()
			end
		end 
	end
end

module.AirHeavy = function(char)
	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local Temp = AliveData.TempValue
	local CDS = AliveData.CDS
	local lastAttack = 0

	if Perm:FindFirstChild("Block") then return end 
	if Temp:FindFirstChild("LA") then return end 
	if Temp:FindFirstChild("EndLag") then return end 
	if Temp:FindFirstChild("Cancel") then return end
	if Temp:FindFirstChild("HeavyCD") then return end
	if Temp:FindFirstChild("Stun") or Temp:FindFirstChild("Ragdoll") then return end 

	local function printreturn  ()
		print("Returned Slam")
	end

	print("Slam")

	if Perm:FindFirstChild("Block") then return end 
	if Temp:FindFirstChild("LA") then return end 
	if Temp:FindFirstChild("EndLag") then return end 
	if Temp:FindFirstChild("Cancel") then return end
	if Temp:FindFirstChild("HeavyCD") then return end
	if Temp:FindFirstChild("Stun") or Temp:FindFirstChild("Ragdoll") then return end 

	printreturn()
end

return module
