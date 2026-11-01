local manager = require(script:WaitForChild("Manager"))
local configs = require(script:WaitForChild("Configuration"))
local soundsFolder = manager:CreateSoundsFolder(game:GetService("SoundService"))

local humanoid = script.Parent:WaitForChild("Humanoid")

function createSound(soundId)
	local sound = Instance.new("Sound")
	sound.Volume = configs.Volume
	sound.SoundId = soundId
	sound.Parent = game:GetService("SoundService")
	
	coroutine.wrap(function()
		sound:Play()
		task.wait(sound.TimeLength)
		sound:Destroy()
	end)()
end

while true do
	if humanoid.MoveDirection.Magnitude > 0 and humanoid.WalkSpeed > 0 then
		local material = string.lower(tostring(humanoid.FloorMaterial))
		local bits = string.split(material, ".")
		material = bits[3]
		local id, vol = manager:GetRandomSound({tostring(material), soundsFolder})
		createSound(id)
		task.wait(configs.Factor / humanoid.WalkSpeed)
	else
		task.wait()
	end
end