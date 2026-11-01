local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")

local Remote = game.ReplicatedStorage.Remotes.ServerFX

Remote.OnServerEvent:Connect(function(p,Value,Extra)

	local char = p.Character
	local FX = require(game.ReplicatedStorage.Modules.FX.FX)

	if Value == "FlashStep" then

		local m = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
		m.Create("Temp","Folder",char.AliveData.TempValue,"FlashStep",0.6)
		m.PlaySound("Sonido",char.HumanoidRootPart)
		local VFX = script.VFZ.Flashstep


		for i,v in pairs(char:GetDescendants()) do

			if v.Name == "HumanoidRootPart" then
				for _,poop in pairs(VFX:GetDescendants())do
					if poop:IsA("ParticleEmitter") and poop.Name == "flashblack" then
						local shit = poop:Clone()
						shit.Parent = v
						shit.Enabled = true
						spawn(function()
							wait(0.6)
							shit.Enabled = false
						end)
						game.Debris:AddItem(shit,2)
					elseif poop.Name == "att" then
						local shit = poop:Clone()
						shit.Parent = v
						shit.smoke:Emit(20)
						game.Debris:AddItem(shit,2)
					end 		
				end
			end


			if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture") or v:IsA("MeshPart") then
				if v.Transparency < 1 then
					local pooptransparency = v.Transparency
					local Goal = {
						["Transparency"] = 1,
					}
					local Info = TweenInfo.new(.08, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
					local Tween = game:GetService("TweenService"):Create(v, Info, Goal)
					Tween:Play()
					spawn(function()
						task.wait(0.6)
						local Goal = {
							["Transparency"] = pooptransparency,
						}
						local Info = TweenInfo.new(.08, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
						local Tween = game:GetService("TweenService"):Create(v, Info, Goal)
						Tween:Play()
					end)
				end
			end 
			if v:IsA("ParticleEmitter") and v.Name ~= "flashblack" then
				if v.Enabled == true then
					v.Enabled = false
					if v.LockedToPart == true then
						v.LockedToPart = false
						spawn(function()
							task.wait(0.6)
							v.LockedToPart = false
						end)
					end 
					spawn(function()
						task.wait(0.6)
						v.Enabled = true
					end)
				end 
			end 

		end
	end 

	if Value == "GroundSlam" then
		local root = char.HumanoidRootPart
		local effectName = "Crater"	

		print("We Fired??")

		local effectParameters = {
			CFrame = root.CFrame,
			Size = 4,
			Direction = Vector3.new(0,-50,0),
			Rows = 1,
			emitSmoke = true

		}

		local create = game.ReplicatedStorage.Remotes.createEffect
		create:FireAllClients(effectName, effectParameters)

	end
	
	if Value == "DashCancel" then

		local VFX = game.ReplicatedStorage.Assets.VFX.DashCancel:Clone()
		VFX.Parent = workspace.Ignore
		VFX.Weld.Part0 = char.Torso
		game:GetService("Debris"):AddItem(VFX, 1)
		task.wait()
		for i,v in pairs(VFX:GetDescendants()) do
			if v:IsA("ParticleEmitter") then
				v:Emit(v.Rate)
			end 
		end 

	end

	if Value == "Dash" then
		FX.Dash(char)
		if char.AliveData.CDS:FindFirstChild("Dashed") then return end 

		if Extra == "Forward" then

			local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Foward",0.5)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Dashed",0.5)
		elseif Extra == "Back" then

			local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Back",0.5)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Dashed",0.5)
		elseif Extra == "Right" then

			local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Right",0.5)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Dashed",0.5)

		elseif Extra == "Left" then

			local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Left",0.5)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Dashed",0.5)
		end

	if char.AliveData.CDS:FindFirstChild("Dashed") then return end 

		if Extra == "Forward" then
		
			local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Foward",0.5)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Dashed",0.5)
	elseif Extra == "Back" then

			local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Back",0.5)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Dashed",0.5)
	elseif Extra == "Right" then

			local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Right",0.5)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Dashed",0.5)

	elseif Extra == "Left" then

			local miscmodule = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Left",0.5)
			miscmodule.Create("Temp","Folder",char.AliveData.CDS,"Dashed",0.5)
	end


end

	if Value == "Double Jump" then
		local FX = script.VFZ.HumanoidRootPart:Clone()
		FX.Parent = char.HumanoidRootPart
		FX.Weld.Part0 = char.HumanoidRootPart
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

	end 

	if Value == "Double Jump1" then
		local FX = script.VFZ.HumanoidRootPart:Clone()
		FX.Parent = char.Torso
		FX.Weld.Part0 = char.Torso
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

	end 
	
end)