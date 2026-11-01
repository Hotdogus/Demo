--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Variables
local TextRemote = ReplicatedStorage.ClientReplication.DamageText
local Random = Random.new()
local DamageTexts = {
	"Tch!",
	"Agh!",
	"Argh!",
	"Gah!",
}

local JustTaggedInstances = {}

--Main
return function(PartOrCharacter)
	if Random:NextNumber() <= 0.5 and not JustTaggedInstances[PartOrCharacter] then
		TextRemote:FireAllClients(PartOrCharacter, DamageTexts[Random:NextInteger(1, #DamageTexts)])
		
		JustTaggedInstances[PartOrCharacter] = true
		task.delay(5, function()
			JustTaggedInstances[PartOrCharacter] = nil
		end)
	end
end
