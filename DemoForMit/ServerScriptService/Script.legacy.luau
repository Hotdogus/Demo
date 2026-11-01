for i, v in pairs(game.ServerStorage:GetDescendants()) do
	if v:IsA('Animation') then print(v)	end
end

for i, v in pairs(game.ServerScriptService:GetDescendants()) do
	if v:IsA('Animation') then print(v)	end
end

for i, v in pairs(game.ReplicatedStorage:GetDescendants()) do
	if v:IsA('Animation') then print(v)	end
end

for i, v in pairs(game.Workspace:GetDescendants()) do
	if v:IsA('Animation') then print(v)	end
end