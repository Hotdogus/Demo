local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

for i, v in pairs(char:GetDescendants()) do
	if v:IsA('Animation') then print(v)	end
end

for i, v in pairs(game.Players.LocalPlayer:GetDescendants()) do
	if v:IsA('Animation') then print(v)	end
end