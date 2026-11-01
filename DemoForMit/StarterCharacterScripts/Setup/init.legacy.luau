--Services
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")
local SSS = game:GetService("ServerScriptService")
local WS = game:GetService("Workspace")
local L = game:GetService("Lighting")

local vfx = RS:WaitForChild('VFXStorage')

--Character
local alive = game.Workspace.Alive
local char = script.Parent
local character = char

--Bodies
local larm = character:WaitForChild("Left Arm")
local rarm = character:WaitForChild("Right Arm")
local torso = character:WaitForChild("Torso")
local lleg = character:WaitForChild("Left Leg")
local rleg = character:WaitForChild("Right Leg")
local head = character:WaitForChild("Head")
local root = character:WaitForChild("HumanoidRootPart")

--Player
local player = game.Players:WaitForChild(character.Name)
local plr = player
local plrgui = player.PlayerGui

--Character Setup
char.Parent = workspace.Alive

local DataFolder = game.ReplicatedStorage["PlayerData"]:WaitForChild(player.Name)

local function onCharacterAdded(c)	

	repeat task.wait(1) until character

	for i, v in pairs(character:GetChildren()) do
		if v:IsA('BasePart') then
			v.CollisionGroup = "Player"
		end
	end

	print(character.Name.." Data has loaded")
	
	local accessKatana = vfx.AccessoryKatana:Clone()
	accessKatana.Attach.Part0 = torso
	accessKatana.Parent = char
end


local PlayerData = game:GetService("ReplicatedStorage")["PlayerData"][player.Name]

character.ChildAdded:Connect(function(Child)

end)


char.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
	game.ReplicatedStorage.PlayerData:WaitForChild(char.Name).LastHealth.Value = char.Humanoid.Health
end)

player.CharacterAdded:Connect(onCharacterAdded)

if player.Character then	
	onCharacterAdded(player.Character)
end