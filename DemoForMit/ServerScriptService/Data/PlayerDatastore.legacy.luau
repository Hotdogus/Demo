local DataStoreService = game:GetService("DataStoreService")
local dataStore = DataStoreService:GetDataStore("PlayerData")

local function toNameList(children)
	local newList = {}
	for i, child in pairs(children) do
		table.insert(newList, child.Name)
	end
	return newList
end

local function saveData(player)
	local dataToSave = {}
	local talents = toNameList(player.PlayerData.Talents:GetChildren())
	local skills = toNameList(player.PlayerData.Skills:GetChildren())
	local accessories = toNameList(player.PlayerData.Accessories:GetChildren())
	local faces = toNameList(player.PlayerData.Faces:GetChildren())
	local tools = toNameList(player.PlayerData.Tools:GetChildren())
	print(tools)

	table.insert(dataToSave, talents)
	table.insert(dataToSave, skills)
	table.insert(dataToSave, accessories)
	table.insert(dataToSave, player.PlayerData.PlayerName.Value)
	table.insert(dataToSave, faces)
	table.insert(dataToSave, player.PlayerData.Shirt.Value)
	table.insert(dataToSave, player.PlayerData.Pants.Value)
	table.insert(dataToSave, tools)
	table.insert(dataToSave, player.PlayerData.Weapon.Value)
	
	print(player.PlayerData)
	
	local success, err = pcall(function()
		dataStore:SetAsync(player.Name, dataToSave)
	end)

	if success then
		print("Data has been saved!")
	else
		print("Data hasn't been saved!")
		warn(err)		
	end
end


game.Players.PlayerRemoving:Connect(function(player) 
	saveData(player)
end)

game.Players.PlayerAdded:Connect(function(player)
	local playerData = Instance.new("Folder") 
	playerData.Name = "PlayerData"
	playerData.Parent = player 

	local talents = Instance.new("Folder") 
	talents.Name = "Talents"
	talents.Parent = playerData

	local skills = Instance.new("Folder") 
	skills.Name = "Skills"
	skills.Parent = playerData

	local accessories = Instance.new("Folder") 
	accessories.Name = "Accessories"
	accessories.Parent = playerData

	local playerName = Instance.new("StringValue") 
	playerName.Name = "PlayerName"
	playerName.Parent = playerData
	
	local faces = Instance.new("Folder") 
	faces.Name = "Faces"
	faces.Parent = playerData

	local shirt = Instance.new("StringValue") 
	shirt.Name = "Shirt"
	shirt.Parent = playerData

	local pants = Instance.new("StringValue") 
	pants.Name = "Pants"
	pants.Parent = playerData
	
	local tools = Instance.new("Folder") 
	tools.Name = "Tools"
	tools.Parent = playerData

	local weapon = Instance.new("StringValue") 
	weapon.Name = "Weapon"
	weapon.Parent = playerData
	
	local data
	local success, err = pcall(function()

		data = dataStore:GetAsync(player.Name)

	end)

	if success and data then

		print(data)

		for i, talent in pairs(data[1]) do
			local newTalent = Instance.new('Folder', talents)
			newTalent.Name = talent
		end

		for i, skill in pairs(data[2]) do
			local newSkill = Instance.new('Folder', skills)
			newSkill.Name = skill
		end

		for i, accessory in pairs(data[3]) do
			local newAcess = Instance.new('Folder', accessories)
			newAcess.Name = accessory
			print(accessory)
		end
		
		playerName.Value = data[4]

		for i, face in pairs(data[5]) do
			local newFace = Instance.new('Folder', faces)
			newFace.Name = face
			print(face)
		end

		shirt.Value = data[6]
		
		pants.Value = data[7]

		for i, tool in pairs(data[8]) do
			local newWeapon = Instance.new('Folder', tools)
			newWeapon.Name = tool
		end

		weapon.Value = data[9]
	else
		print("The player has no data! Loading default.")
		
		local success, err = pcall(function()

			data = dataStore:GetAsync("default")

		end)

		if success and data then

			print(data)

			for i, talent in pairs(data[1]) do
				local newTalent = Instance.new('Folder', talents)
				newTalent.Name = talent
			end

			for i, skill in pairs(data[2]) do
				local newSkill = Instance.new('Folder', skills)
				newSkill.Name = skill
			end

			for i, accessory in pairs(data[3]) do
				local newAcess = Instance.new('Folder', accessories)
				newAcess.Name = accessory
				print(accessory)
			end

			playerName.Value = data[4]

			for i, face in pairs(data[5]) do
				local newFace = Instance.new('Folder', faces)
				newFace.Name = face
				print(face)
			end

			shirt.Value = data[6]

			pants.Value = data[7]

			for i, tool in pairs(data[8]) do
				local newWeapon = Instance.new('Folder', tools)
				newWeapon.Name = tool
			end

			weapon.Value = data[9]
		end
	end
end)
