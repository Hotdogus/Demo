local module = {}

local CreateRemote = game.ReplicatedStorage.Remotes.createEffect

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

module.Rush = function(char,var,p)


	local genmod = require(game.ReplicatedStorage.Modules.GeneralUse.ModuleScript)
	genmod.Create("Temp","Folder",char.AliveData.TempValue,"GS",0.5)


	if var == true then
	genmod.PlaySound("Rush",char.HumanoidRootPart)
	end
	local HRP = char.HumanoidRootPart



	local CreateRemote = game.ReplicatedStorage.Remotes.createEffect

	

end



module.Dash = function(char)

	local genmod = require(script.Parent.Parent.GeneralUse.ModuleScript)
	genmod.Create("Temp","Folder",char.AliveData.TempValue,"GS",0.4)
	genmod.PlayRandomSound("Dash",char.HumanoidRootPart,2)
	local HRP = char.HumanoidRootPart

	local vfx = game.ReplicatedStorage.Assets.VFX.Dash.Attachment:Clone()
	vfx.Parent = HRP
	for i,v in pairs(vfx:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			spawn(function()
				v.Enabled = true
				task.wait(0.4)
				v.Enabled = false
			end)
		end
	end 
	game.Debris:AddItem(vfx,4)
end

return module
