local TrailModule = {}

function TrailModule.createTrail(character, trailType)
	if not character or not character:IsA("Model") then
		return
	end
	
	
	local function Trail(part)
		local att1 = Instance.new("Attachment", part)
		local att2 = Instance.new("Attachment", part)
		att1.Name = "att1"
		att2.Name = "att2"
		att1.CFrame = att2.CFrame * CFrame.new(0, 0, .8)
		game.Debris:AddItem(att1, 0.9)
		game.Debris:AddItem(att2, 0.9)

		local trail = Instance.new("Trail", part)
		trail.Attachment0 = att1
		trail.Attachment1 = att2
		trail.Lifetime = 0.3
		trail.Transparency = NumberSequence.new(.8, .8)
		trail.WidthScale = NumberSequence.new(1, 0)

		trail.Texture = "http://www.roblox.com/asset/?id=15570762630"

		game.Debris:AddItem(trail, 0.9)
		delay(0.6, function()
			trail.Enabled = false
		end)
	end

	for _, part in ipairs(character:GetChildren()) do
		if part:IsA("BasePart") then
			if trailType == "RightArm" and part.Name == "Right Arm" then
				Trail(part)
			elseif trailType == "LeftArm" and part.Name == "Left Arm" then
				Trail(part)
			elseif trailType == "RightLeg" and part.Name == "Right Leg" then
				Trail(part)
			elseif trailType == "RightArmAndLeftArm" and (part.Name == "Right Arm" or part.Name == "Left Arm") then
				Trail(part)
			elseif trailType == "EveryBodyPart" then
				Trail(part)
			elseif trailType == "RightLegAndLeftLeg" and (part.Name == "Right Leg" or part.Name == "Left Leg") then
				Trail(part)
			end
		end
	end
end

return TrailModule
