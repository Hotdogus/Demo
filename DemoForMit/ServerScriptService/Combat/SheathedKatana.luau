
local module = {}

module.LightAttack = function(char,SpaceHeld)

	local AliveData = char.AliveData
	local Perm = AliveData.PermValue
	local Temp = AliveData.TempValue
	local CDS = AliveData.CDS
	local lastAttack = 0

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

	if currentcombo.Value > 4 or (tick() - AliveData.Combat.ComboTimer.Value) > 1.25 then
		currentcombo.Value = 1
	end


	local KB = false

	if currentcombo.Value == 5 then
		KB = true
		miscmodule.Create("Temp","Folder",Temp,"EndLag",0.8)
	end

	local s = true
	local b = false

		local s = true
		local b = false


	spawn(function()

		local Params = {
			damage = 12;
			bruise = true;
			stuntime = 0.9;
			Sharp = s;
			blunt = b;
			KB = KB;
			AirComboExtend = true;
			ragdollduration = 0.8;	
		}

		if currentcombo.Value == 4 and SpaceHeld == true then
			Params.Uptilt = true
		end

		task.wait(0.07)

		local hb = require(script.Parent.HITBOXING)
		local hb = require(script.Parent.HITBOXING)

		task.wait(0.140)
		hb.LingeringFrontHB(AliveData,char,Params,5,0.2)
	end)

	AliveData.Combat.ComboTimer.Value = tick()


	

local anim = char.Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.SheathedKatana:FindFirstChild("Fist"..currentcombo.Value))
	for i, v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
		if v.Name == "Fist1" or v.Name == "Fist2" or v.Name == "Fist3" or v.Name == "Fist4" or v.Name == "Fist5" then
			v:Stop()
		end
	end 
	anim:Play()
	anim.Priority = Enum.AnimationPriority.Action3
	anim:AdjustSpeed(1.3)


	local soundName = "Fist"
	if char['Right Arm'].BodyAttach.Sheath.Transparency == 1 then
		soundName = "Slash"
	end
	if currentcombo == 4 then
		miscmodule.PlayRandomSound(soundName,char.HumanoidRootPart,3)
	elseif currentcombo.Value == 1 or currentcombo.Value == 3 then
		miscmodule.PlayRandomSound(soundName,char.HumanoidRootPart,3)
	else 
		miscmodule.PlayRandomSound(soundName,char.HumanoidRootPart,3)
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

	local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)

	local BM = Instance.new("BodyVelocity")
	BM.Name = "Fling"
	BM.MaxForce  = Vector3.new(65000, 3000, 65000)
	BM.P = 20000
	BM.Velocity = char.HumanoidRootPart.CFrame.LookVector * 28 + Vector3.new(0,-16,0)
	BM.Parent = char.HumanoidRootPart
	game.Debris:AddItem(BM, 0.6)

	local HRP = char.HumanoidRootPart


	for i, v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
		if v.Name == "Fist1" or v.Name == "Fist2" or v.Name == "Fist3" or v.Name == "Fist4" or v.Name == "Fist5" then
			v:Stop()
		end
	end 

	local anim = char.Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.Fists:FindFirstChild("AirFist"))
	anim:Play()
	anim.Priority = Enum.AnimationPriority.Action2

	miscmodule.PlaySound("Up",char.HumanoidRootPart,3)

	local Params = {
		damage = 15;
		bruise = true;
		stuntime = 0.9;
		blunt = true;
		GB = false;
		KB = false;
		ragdollduration = 0.8;	
	}

	spawn(function()
		task.wait(0.1)
		local hb = require(script.Parent.HITBOXING)
		hb.LingeringHB(AliveData,char,Params,8,0.8)
	end)


end


module.Heavy = function(char)

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


	miscmodule.Destroy(Perm,"Run")
	miscmodule.Create("Temp","Folder",Temp,"Cancel",1)
	miscmodule.Create("Temp","Folder",Temp,"NoRun",0.5)
	miscmodule.Create("Temp","Folder",Temp,"TrueSlow",0.7)
	miscmodule.Create("Temp","Folder",Temp,"SPRINTCD",0.5)
	miscmodule.Create("Temp","Folder",Temp,"HeavyCD",4)
	miscmodule.Create("Temp","Folder",Temp,"EndLag",1)


	local anim = char.Humanoid:LoadAnimation(game.ReplicatedStorage.Animations.Kunai:FindFirstChild("FistHeavy"))
	anim:Play()
	anim:AdjustSpeed(0.2)
	anim.Priority = Enum.AnimationPriority.Action2

	local HRP = char.HumanoidRootPart

	local highlight = Instance.new("Highlight", char)
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.FillColor = Color3.fromRGB(244, 25, 25)
	highlight.FillTransparency = 1
	highlight.OutlineColor = Color3.fromRGB(118, 17, 17)
	highlight.OutlineTransparency = 0.5
	
	for _, child in ipairs(script:GetChildren()) do
		if child:IsA("ParticleEmitter") then
			local Crit = child:Clone()
			Crit.Parent = char.HumanoidRootPart
			Crit:Emit(10)
			game.Debris:AddItem(Crit, 4)
		end
	end

	miscmodule.PlaySound("Crit", char.HumanoidRootPart)


	miscmodule.PlaySound("Feint",char.HumanoidRootPart)


	local Goal = {
		["FillTransparency"] = 1,
		["OutlineTransparency"] = 1,
	}
	local Info = TweenInfo.new(.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local Tween = game:GetService("TweenService"):Create(highlight, Info, Goal)
	Tween:Play()

	task.wait(0.3)

	anim:AdjustSpeed(1.4)

	for i, v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
		if string.find("Fist",v.Name) and v.Name ~= anim.Name then
			v:Stop()
		end
	end 

	miscmodule.PlaySound("Up",char.HumanoidRootPart,3)

	local Params = {
		damage = 10;
		bruise = true;
		stuntime = 0.9;
		Sharp = true;
		GB = true;
		KB = false;
		ragdollduration = 0.8;	
	}

	spawn(function()
		task.wait(0.03)
		local hb = require(script.Parent.HITBOXING)
		hb.FrontHB(AliveData,char,Params)
		task.wait(0.3)
		local hb = require(script.Parent.HITBOXING)
		hb.FrontHB(AliveData,char,Params)
	end)




end

return module
