local PS = game:GetService('Players')
local SS = game:GetService('ServerStorage')
local charData = require(SS:WaitForChild('Modules'):WaitForChild('CharacterData'))

PS.PlayerAdded:Connect(function(player)
	task.wait(2)
	
	
	while not player:FindFirstChild('PlayerData') do
		task.wait(0.3)
	end

	local char = player.Character or player.CharacterAdded:Wait()
	charData.Load(player, player.PlayerData)
end)