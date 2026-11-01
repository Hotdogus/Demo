--Variables

local characterSubject = script.Parent
local Humanoid = characterSubject:WaitForChild("Humanoid")
local HRP = characterSubject:FindFirstChild("HumanoidRootPart")

local characterStates = characterSubject:WaitForChild("AliveData"):WaitForChild("TempValue")

local jointPreset = script:WaitForChild("Ragdoll Joint")
local boxPreset = script:WaitForChild("Ragdoll Colission")

local ragdollSetup = false
local ragdolled = false

local allCollisionBoxes = {}
local allJoints = {}
local allMotorJoints = {}

local ragdolledValues = {}

local limbNames = {
	"Left Leg",
	"Right Leg",
	"Left Arm",
	"Right Arm"
}

--Functions

local function setupJoints(character)

	--Setting up colission boxes

	for i, v in pairs(character:GetChildren()) do
		if table.find(limbNames, v.Name) then

			local newBox = boxPreset:Clone()
			newBox:FindFirstChildOfClass("Weld").Part0 = v
			newBox.Parent = v
			newBox.Name = tostring(v.Name .. " Ragdoll Colission")

			table.insert(allCollisionBoxes, newBox)

		end
	end

	--Setting up joints

	for i, v in pairs(character:FindFirstChild("Torso"):GetChildren()) do
		if v:IsA("Motor6D") and table.find(limbNames, v.Part1.Name) then

			table.insert(allMotorJoints, v)

			--Creating attachments

			local targetLimb = v.Part1

			local attachment0 = Instance.new("Attachment")
			attachment0.Name = tostring("Attachment0 of ".. targetLimb.Name.. " joint")
			attachment0.Position = v.C0.Position
			attachment0.Parent = character:FindFirstChild("Torso")

			local attachment1 = Instance.new("Attachment")
			attachment1.Name = tostring("Attachment1 of ".. targetLimb.Name .. " joint")
			attachment1.Position = v.C1.Position
			attachment1.Parent = targetLimb

			--Creating joint

			local newJoint = jointPreset:Clone()
			newJoint.Name = tostring("Ragdoll Joint of ".. targetLimb.Name)

			newJoint.Attachment0 = attachment0
			newJoint.Attachment1 = attachment1

			table.insert(allJoints, newJoint)	
			newJoint.Parent = targetLimb

		end
	end

	--Clearing presets

	ragdollSetup = true
	print("Ragdoll was set up for ".. character.Name)

	for i, v in pairs(script:GetChildren()) do
		v:Destroy()
	end

end

local function adjustRagdoll(state)
	if ragdolled ~= state and ragdollSetup == true then

		--Adjusting value

		ragdolled = state

		--Adding ragdoll state

		if state == true then

			local hardStun = Instance.new("BoolValue")
			hardStun.Name = "Hard Stun"
			hardStun.Parent = characterStates
			table.insert(ragdolledValues, hardStun)
			game.Debris:AddItem(hardStun, 0.4)

			local Stunned = Instance.new("BoolValue")
			Stunned.Name = "Stunned"
			Stunned.Parent = characterStates
			table.insert(ragdolledValues, Stunned)

			local ragdolled = Instance.new("BoolValue")
			ragdolled.Name = "Ragdolled"
			ragdolled.Parent = characterStates
			table.insert(ragdolledValues, ragdolled)

		else

			--Clearing any stuns to prevent inf combos

			for i, v in pairs(ragdolledValues) do
				v:Destroy()
			end

			--Invulnerability

			local Invulnerable = Instance.new("BoolValue")
			Invulnerable.Name = "Invulnerable"
			Invulnerable.Parent = characterStates
			game.Debris:AddItem(Invulnerable, 0.5)

			--Clearing state

			for i, v in pairs(characterStates:GetChildren()) do
				if v.Name == "Ragdolled" or v.Name == "Hit Ground" then		
					v:Destroy()				
				end
			end

		end

		--Enabling humanoid activity

		if not characterStates:FindFirstChild("Being Held") then
			Humanoid.PlatformStand = state
		end

		if state == false then			

			local newPosition = HRP.Position + Vector3.new(0,1.5,0)		
			HRP.CFrame = CFrame.new(newPosition.X, newPosition.Y, newPosition.Z) * CFrame.Angles(math.rad(0), math.rad(HRP.Orientation.Y), math.rad(0))

		end

		--Adjusting ragdoll joints & colissions

		for i, v in pairs(allCollisionBoxes) do

			v.Massless = not state
			v.CanCollide = state

		end

		for i, v in pairs(allJoints) do

			v.Enabled = state

		end

		for i, v in pairs(allMotorJoints) do

			v.Enabled = not state

		end

	end
end

setupJoints(characterSubject)

--Ragdoll on death

Humanoid.Died:Connect(function()

	--Creating new ragdoll

	local newRagdoll = Instance.new("BoolValue")
	newRagdoll.Name = "Ragdoll"
	newRagdoll.Parent = characterStates

	game.ReplicatedStorage.PlayerData:FindFirstChild(characterSubject.Name).CombatTagged.Value = false

end)

--Detecting children added

characterStates.ChildAdded:Connect(function(newChild)
	if newChild:IsA("BoolValue") and newChild.Name == "Ragdoll" and ragdolled == false then

		adjustRagdoll(true)

	end
end)

characterStates.ChildRemoved:Connect(function(removedChild)
	if removedChild:IsA("BoolValue") and removedChild.Name == "Ragdoll" and ragdolled == true and not characterStates:FindFirstChild("Ragdoll") then

		adjustRagdoll(false)

	end
end)