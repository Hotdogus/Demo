local PS = game:GetService('Players')
local SS = game:GetService('ServerStorage')
local RP = game:GetService('ReplicatedStorage')
local DataStoreService = game:GetService("DataStoreService")

local events = RP:WaitForChild('Events')

local dataStore = DataStoreService:GetDataStore("PlayerData")
local tools = SS:WaitForChild('HotdogianTools')

local faceModel = script.FaceModel

local function toNameList(children)
	local newList = {}
	for i, child in pairs(children) do
		table.insert(newList, child.Name)
	end
	return newList
end

local function findTool(name)
	local nameLength = string.len(name)

	for _, tool in tools:GetChildren() do
		local toolName = tool.Name:sub(1, nameLength)

		if string.lower(toolName) == string.lower(name) then
			return tool
		end
	end
end

local CharacterData = {}

function CharacterData.Load(player)
	local data = player.PlayerData
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char.Humanoid
	
	task.wait(1)

	local equippedTool = player.Character:FindFirstChildOfClass("Tool")
	if equippedTool and equippedTool.Name ~= 'Fists' then
		equippedTool:Destroy()
	end

	for i, tool in pairs(player.Backpack:GetChildren()) do
		tool:Destroy()
	end
	
	for i, obj in pairs(char:GetDescendants()) do
		if obj:IsA('Accessory') then
			obj:Destroy()
		end
	end

	if char.Head:FindFirstChild('face') then char.Head.face:Destroy() end
	local faceModelClone = faceModel:Clone()
	faceModelClone:PivotTo(char.Head.CFrame)
	faceModelClone.face.ToHead.Part1 = char.Head
	faceModelClone.Parent = char
	
	local face = faceModelClone.face
	face.Parent = char.Head
	faceModelClone:Destroy()
	face.ToRoot:Destroy()
	

	for i, faceId in data.Faces:GetChildren() do
		local currFaceId = faceId.Name
		local newFace = Instance.new('Decal', face)
		newFace.Texture = currFaceId
	end

	local shirtId = data.Shirt.Value
	
	if char:FindFirstChild('Shirt') then
		char.Shirt.ShirtTemplate = shirtId
	else
		local shirt = Instance.new('Shirt', char)
		shirt.Name = 'Shirt'
		shirt.ShirtTemplate = shirtId
	end

	local pantsId = data.Pants.Value

	if char:FindFirstChild('Pants') then
		char.Pants.PantsTemplate = pantsId
	else
		local pants = Instance.new('Pants', char)
		pants.Name = 'Pants'
		pants.PantsTemplate = pantsId
	end

	for i, hatObj in pairs(data.Accessories:GetChildren()) do
		local accessoryId = tonumber(hatObj.Name)

		-- Get the player's character
		if not char then
			warn("Player has no character")
			return false
		end

		-- Load the asset from the website
		local success, asset = pcall(function()
			return game.InsertService:LoadAsset(tonumber(accessoryId))
		end)

		if not success or not asset then
			warn("Failed to load asset with ID:", accessoryId)
			return false
		end

		-- Find the accessory in the loaded asset
		local accessory = asset:FindFirstChildOfClass("Accessory")
		if not accessory then
			-- Check if the asset itself is an accessory
			if asset:IsA("Accessory") then
				accessory = asset
			else
				warn("No accessory found in asset with ID:", accessoryId)
				asset:Destroy()
				return false
			end
		end

		-- Attach the accessory to the character
		accessory.Parent = char
		accessory.Name = tostring(accessoryId)
	end	
	
	for i, tool in pairs(data.Tools:GetChildren()) do
		local toolObj = findTool(tool.Name)
		if toolObj then
			toolObj:Clone().Parent = player.Backpack
		end
	end
	
	local weaponName = data.Weapon.value
	events.SetStat:Fire(player,'Weapon',weaponName)
	
	task.wait(0.2)
	
	for i, v in pairs(char:GetDescendants()) do
		if v:IsA('Part') or v:IsA('BasePart') then
			v.CollisionGroup = 'Player'
		end
	end
end

function CharacterData.Pseudoload(player)
	local data = player.PlayerData
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char.Humanoid

	--task.wait(1)

	for i, obj in pairs(char:GetDescendants()) do
		if obj:IsA('Accessory') then
			obj:Destroy()
		end
	end

	if char.Head:FindFirstChild('face') then char.Head.face:Destroy() end
	local faceModelClone = faceModel:Clone()
	faceModelClone:PivotTo(char.Head.CFrame)
	faceModelClone.face.ToHead.Part1 = char.Head
	faceModelClone.Parent = char

	local face = faceModelClone.face
	face.Parent = char.Head
	faceModelClone:Destroy()
	face.ToRoot:Destroy()


	for i, faceId in data.Faces:GetChildren() do
		local currFaceId = faceId.Name
		local newFace = Instance.new('Decal', face)
		newFace.Texture = currFaceId
	end

	local shirtId = data.Shirt.Value

	if char:FindFirstChild('Shirt') then
		char.Shirt.ShirtTemplate = shirtId
	else
		local shirt = Instance.new('Shirt', char)
		shirt.Name = 'Shirt'
		shirt.ShirtTemplate = shirtId
	end

	local pantsId = data.Pants.Value

	if char:FindFirstChild('Pants') then
		char.Pants.PantsTemplate = pantsId
	else
		local pants = Instance.new('Pants', char)
		pants.Name = 'Pants'
		pants.PantsTemplate = pantsId
	end

	for i, hatObj in pairs(data.Accessories:GetChildren()) do
		local accessoryId = tonumber(hatObj.Name)

		-- Get the player's character
		if not char then
			warn("Player has no character")
			return false
		end

		-- Load the asset from the website
		local success, asset = pcall(function()
			return game.InsertService:LoadAsset(tonumber(accessoryId))
		end)

		if not success or not asset then
			warn("Failed to load asset with ID:", accessoryId)
			return false
		end

		-- Find the accessory in the loaded asset
		local accessory = asset:FindFirstChildOfClass("Accessory")
		if not accessory then
			-- Check if the asset itself is an accessory
			if asset:IsA("Accessory") then
				accessory = asset
			else
				warn("No accessory found in asset with ID:", accessoryId)
				asset:Destroy()
				return false
			end
		end

		-- Attach the accessory to the character
		accessory.Parent = char
		accessory.Name = tostring(accessoryId)
	end	

	--task.wait(0.2)

	for i, v in pairs(char:GetDescendants()) do
		if v:IsA('Part') or v:IsA('BasePart') then
			v.CollisionGroup = 'Player'
		end
	end
end

function CharacterData.Save(player, id)

	local dataToSave = {}
	local talents = toNameList(player.PlayerData.Talents:GetChildren())
	local skills = toNameList(player.PlayerData.Skills:GetChildren())
	local accessories = toNameList(player.PlayerData.Accessories:GetChildren())
	local faces = toNameList(player.PlayerData.Faces:GetChildren())
	local tools = toNameList(player.PlayerData.Tools:GetChildren())

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
		dataStore:SetAsync(id, dataToSave)
	end)

	if success then
		print("Data has been saved!")
	else
		print("Data hasn't been saved!")
		warn(err)		
	end
end

function CharacterData.LoadNPC(char, data)
	local hum = char.Humanoid

	if char.Head:FindFirstChild('face') then char.Head.face:Destroy() end
	local faceModelClone = faceModel:Clone()
	faceModelClone:PivotTo(char.Head.CFrame)
	faceModelClone.face.ToHead.Part1 = char.Head
	faceModelClone.Parent = char

	local face = faceModelClone.face
	face.Parent = char.Head
	faceModelClone:Destroy()
	face.ToRoot:Destroy()


	for i, faceId in data.Faces:GetChildren() do
		local currFaceId = faceId.Name
		local newFace = Instance.new('Decal', face)
		newFace.Texture = currFaceId
	end

	local shirtId = data.Shirt.Value

	if char:FindFirstChild('Shirt') then
		char.Shirt.ShirtTemplate = shirtId
	else
		local shirt = Instance.new('Shirt', char)
		shirt.ShirtTemplate = shirtId
	end

	local pantsId = data.Pants.Value

	if char:FindFirstChild('Pants') then
		char.Pants.PantsTemplate = pantsId
	else
		local pants = Instance.new('Pants', char)
		pants.PantsTemplate = pantsId
	end

	for i, hatObj in pairs(data.Accessories:GetChildren()) do
		local accessoryId = tonumber(hatObj.Name)

		-- Get the player's character
		if not char then
			warn("Player has no character")
			return false
		end

		-- Load the asset from the website
		local success, asset = pcall(function()
			return game.InsertService:LoadAsset(tonumber(accessoryId))
		end)

		if not success or not asset then
			warn("Failed to load asset with ID:", accessoryId)
			return false
		end

		-- Find the accessory in the loaded asset
		local accessory = asset:FindFirstChildOfClass("Accessory")
		if not accessory then
			-- Check if the asset itself is an accessory
			if asset:IsA("Accessory") then
				accessory = asset
			else
				warn("No accessory found in asset with ID:", accessoryId)
				asset:Destroy()
				return false
			end
		end

		-- Attach the accessory to the character
		accessory.Parent = char
		accessory.Name = tostring(accessoryId)
	end	

	task.wait(0.2)

	for i, v in pairs(char:GetDescendants()) do
		if v:IsA('Part') or v:IsA('BasePart') then
			v.CollisionGroup = 'Player'
		end
	end
end

return CharacterData
