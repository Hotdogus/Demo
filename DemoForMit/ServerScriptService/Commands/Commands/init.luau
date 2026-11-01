local PS = game:GetService('Players')
local SS = game:GetService('ServerStorage')
local RP = game:GetService('ReplicatedStorage')
local HS = game:GetService("HttpService")

local modules = SS:WaitForChild('Modules')
local charData = require(modules:WaitForChild('CharacterData'))

local tools = SS:WaitForChild('HotdogianTools')
local events = RP:WaitForChild('Events')

local vfx = RP:WaitForChild('VFXStorage')

local lightsActive = true


local TS = game.TweenService

local function findPlayer(sender, name)
	
	if string.lower(name) == 'me' then
		return sender
	end

	local nameLength = string.len(name)

	for _, player in game.Players:GetChildren() do
		local plrName = player.Name:sub(1, nameLength)

		if string.lower(plrName) == string.lower(name) then
			return player
		end
	end
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

local Commands = {
	{
		name = "ServerMessage",
		aliases = {'sm'},
		
		execute = function(_,args)
			local player = args[2]
			local message = table.concat(args,' ',3)
			
			
		end,
	};
	{
		name = "Blind",
		aliases = {},
		
		execute = function(sender,args)
			local targetPlayer:Players = findPlayer(sender, args[2])
			
			targetPlayer.PlayerGui.Blind.Enabled = true
		end,
	};
	{
		name = "Unblind",
		aliases = {},
		
		execute = function(sender,args)
			local targetPlayer:Players = findPlayer(sender, args[2])

			targetPlayer.PlayerGui.Blind.Enabled = false
		end,
	};
	{
		name = "GiveSpec",
		aliases = {'spec'},

		execute = function(sender,args)
			local specName = args[3]
			
			local specs = game.ServerStorage.Specs:GetChildren()
			local folder = nil
			
			for i, spec in pairs(specs) do
				if spec.Name == specName then
					folder = spec
				end
			end
			
			local targetPlayer = findPlayer(sender, args[2])

			if not targetPlayer then
				-- Send a message back to the command sender if the player is not found
				game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, 'Player not found!')
				return
			end
			
			if not folder then
				game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, 'Invalid spec name!')
				return
			end
			
			local auth = Instance.new('Folder', folder)
			auth.Name = tostring(targetPlayer.UserId)
			
		end,
	};
	{
		name = "Name",
		aliases = {"name"},
		
		execute = function(sender,args)
			local name = table.concat(args,' ',3)
			
			local target = findPlayer(sender, args[2])
			if target then

				local data = target:FindFirstChild('PlayerData')
				if not data then
					print('Data not found')
					return
				end

				data.PlayerName.Value = name
				events.UpdateName:FireClient(target)

				print('Name Changed')
			else
				print('Player not found')
			end
		end,
	};
	{
		name = "AssetFace",
		aliases = {"face"},
		
		execute = function(sender,args)
			
			local target = findPlayer(sender, args[2])
			if target then
				
				local char = target.Character or target.CharacterAdded:Wait()
				local hum = char.Humanoid
				local faceObj = Instance.new('Decal', char.Head.face)
				faceObj.Name = 'face'
				if tonumber(args[3]) then
					faceObj.Texture = 'rbxassetid://'..args[3]
				else
					faceObj.Texture = args[3]
				end
				local data = target:FindFirstChild('PlayerData')
				if not data then
					print('Data not found')
					return
				end

				local faceId = faceObj.Texture
				local newFace = Instance.new('Folder', data.Faces)
				newFace.Name = faceId

				print('Face Changed')
			else
				print('Player not found')
			end
		end,
	};
	{
		name = "RemoveFaces",
		aliases = {"unface"},

		execute = function(sender,args)

			local target = findPlayer(sender, args[2])
			if target then

				local char = target.Character or target.CharacterAdded:Wait()
				local hum = char.Humanoid
				for i, v in pairs(char.Head:GetChildren()) do
					if v.Name == 'face' then
						v:Destroy()
					end
				end
				local data = target:FindFirstChild('PlayerData')
				if not data then
					print('Data not found')
					return
				end

				data.Faces:Destroy()
				local newFolder = Instance.new('Folder', data)
				newFolder.Name = 'Faces'

				print('Faces Removed')
			else
				print('Player not found')
			end
		end,
	};
	{
		name = "MarketFace",
		aliases = {"mface"},

		execute = function(sender,args)
			
			local target = findPlayer(sender, args[2])
			if target then

				local char = target.Character or target.CharacterAdded:Wait()
				local hum = char.Humanoid
				local data = target:FindFirstChild('PlayerData')
				if not data then
					print('Data not found')
					return
				end
				if not tonumber(args[3]) then
					print('requires numerical id')
					return
				end

				local description = hum and hum:FindFirstChildOfClass("HumanoidDescription")
				if not description then
					return
				end

				local attribute = "_KFace"
				local original = attribute .. "Original"
				if not target:GetAttribute(original) then
					target:SetAttribute(original, description["Face"])
				end
				description["Face"] = tonumber(args[3]) or target:GetAttribute(original)

				target:SetAttribute("_KFace", tonumber(args[3]))

				hum:ApplyDescriptionReset(description)
				hum:ApplyDescription(description)

				for i, obj in pairs(char:GetChildren()) do
					if obj:IsA('Accessory') then
						obj:Destroy()
					end
				end

				local faceId = char.Head.face.Texture
				local newFace = Instance.new('Folder', data.Faces)
				newFace.Name = faceId

				print('Face Changed')
			else
				print('Player not found')
			end
		end,
	};
	{
		name = "RemoveFaces",
		aliases = {"unface"},

		execute = function(sender,args)

			local target = findPlayer(sender, args[2])
			if target then

				local char = target.Character or target.CharacterAdded:Wait()
				local hum = char.Humanoid
				
				for i, v in pairs(char.Head:GetChildren()) do
					if v.Name == 'face' then
						v:Destroy()
					end
				end
				
				local data = target:FindFirstChild('PlayerData')
				if not data then
					print('Data not found')
					return
				end

				local newFace = Instance.new('Folder', data)
				data.Faces:Destroy()
				newFace.Name = 'Faces'

				print('Face Changed')
			else
				print('Player not found')
			end
		end,
	};
	{
		name = "AssetShirt",
		aliases = {"ashirt"},

		execute = function(sender,args)
			
			local target = findPlayer(sender, args[2])
			if target then

				local char = target.Character or target.CharacterAdded:Wait()
				local hum = char.Humanoid
				if tonumber(args[3]) then
					char.Shirt.ShirtTemplate = 'rbxassetid://'..args[3]
				else
					char.Shirt.ShirtTemplate = args[3]
				end
				local data = target:FindFirstChild('PlayerData')
				if not data then
					print('Data not found')
					return
				end


				data.Shirt.Value = char.Shirt.ShirtTemplate

				print('Shirt Changed')
			else
				print('Player not found')
			end
		end,
	};
	{
		name = "MarketShirt",
		aliases = {"shirt"},

		execute = function(sender,args)
			
			local target = findPlayer(sender, args[2])
			if target then
				local char = target.Character or target.CharacterAdded:Wait()
				local hum = char.Humanoid
				local data = target:FindFirstChild('PlayerData')
				if not data then
					print('Data not found')
					return
				end
				if not tonumber(args[3]) then
					print('requires numerical id')
					return
				end

				local model = game.InsertService:LoadAsset(args[3])
				local id = model.Shirt.ShirtTemplate

				char.Shirt.ShirtTemplate = id
				data.Shirt.Value = id
				
				model:Destroy()

				print('Shirt Changed')
			else
				print('Player not found')
			end
		end,
	};
	{
		name = "AssetPants",
		aliases = {"apants"},

		execute = function(sender,args)
			
			local target = findPlayer(sender, args[2])
			if target then

				local char = target.Character or target.CharacterAdded:Wait()
				local hum = char.Humanoid
				if tonumber(args[3]) then
					char.Pants.PantsTemplate = 'rbxassetid://'..args[3]
				else
					char.Pants.PantsTemplate = args[3]
				end
				local data = target:FindFirstChild('PlayerData')
				if not data then
					print('Data not found')
					return
				end


				data.Pants.Value = char.Pants.PantsTemplate

				print('Pants Changed')
			else
				print('Player not found')
			end
		end,
	};
	{
		name = "MarketPants",
		aliases = {"pants"},

		execute = function(sender,args)
			
			local target = findPlayer(sender, args[2])
			if target then

				local char = target.Character or target.CharacterAdded:Wait()
				local hum = char.Humanoid
				local data = target:FindFirstChild('PlayerData')
				if not data then
					print('Data not found')
					return
				end
				if not tonumber(args[3]) then
					print('requires numerical id')
					return
				end


				local model = game.InsertService:LoadAsset(args[3])
				local id = model.Pants.PantsTemplate
				
				char.Pants.PantsTemplate = id
				data.Pants.Value = id

				model:Destroy()

				print('Pants Changed')
			else
				print('Player not found')
			end
		end,
	};
	{
		name = "Color",
		aliases = {"color"},

		execute = function(sender,args)

			local target = findPlayer(sender, args[2])
			if target then

				local char = target.Character or target.CharacterAdded:Wait()
				local hum = char.Humanoid
				local data = target:FindFirstChild('PlayerData')
				if not data then
					print('Data not found')
					return
				end
				
				for i, v in pairs(char:GetChildren()) do
					if v:IsA('Part') then
						v.Color = Color3.fromRGB(args[3], args[4], args[5])
					end
				end
				
			else
				print('Player not found')
			end
		end,
	};
	{
		name = "Hat",
		aliases = {"hat"},

		execute = function(sender,args)
			local player = findPlayer(sender, args[2])
			local hatId = tonumber(args[3])

			-- Get the player's character
			local character = player.Character
			if not character then
				warn("Player has no character")
				return false
			end

			-- Load the asset from the website
			local success, asset = pcall(function()
				return game.InsertService:LoadAsset(tonumber(hatId))
			end)

			if not success or not asset then
				warn("Failed to load asset with ID:", hatId)
				return false
			end

			-- Find the accessory in the loaded asset
			local accessory = asset:FindFirstChildOfClass("Accessory")
			if not accessory then
				-- Check if the asset itself is an accessory
				if asset:IsA("Accessory") then
					accessory = asset
				else
					warn("No accessory found in asset with ID:", hatId)
					asset:Destroy()
					return false
				end
			end

			-- Attach the accessory to the character
			accessory.Parent = character
			
			local newAccessory = Instance.new('Folder', player.PlayerData.Accessories)
			newAccessory.Name = tostring(hatId)
		end,
	};
	{
		name = "Removehats",
		aliases = {"unhat"},

		execute = function(sender,args)
			local player = findPlayer(sender, args[2])
		
			for i, child in pairs(player.Character:GetChildren()) do
				if child:IsA('Accessory') then
					child:Destroy()
				end
			end
			
			player.PlayerData.Accessories:Destroy()
			local newFolder = Instance.new('Folder', player.PlayerData)
			newFolder.Name = 'Accessories'
		end,
	};
	{
		name = "InnerDialogue",
		aliases = {"ID"},
		
		execute = function(playerwhosent,args)
			print(args)
			
			if tonumber(args[2]) then
				
				local range = tonumber(args[2])

				for _,player in pairs(PS:GetPlayers()) do
					
					local targetHMRP = player.Character.HumanoidRootPart
					local senderHMRP = playerwhosent.Character.HumanoidRootPart
					
					if (targetHMRP.Position - senderHMRP.Position).Magnitude <= range then

						RP.Events.ManualInnerDialogue:FireClient(player,table.concat(args,' ',3))
					else
						print(player.Name..' is out of range')
					end
				end


			else
				local target = findPlayer(playerwhosent, args[2])
				if target then
					RP.Events.ManualInnerDialogue:FireClient(target,table.concat(args,' ',3))
				end
			end 
			
			
		end,
	};
	{
		name = "HFAnnouncement",
		aliases = {"HFA"},

		execute = function(sender,args)

			local gui = script:WaitForChild('HF_Announcement')
			local TS = game:GetService('TweenService')
			for i,v in pairs(game:GetService('Players'):GetChildren()) do
				if v:IsA('Player') and v.Character ~= nil and v:FindFirstChildOfClass('PlayerGui') then
					local c = gui:Clone()
					c.Parent = v:FindFirstChildOfClass('PlayerGui')
					for i,t in pairs(c:GetDescendants()) do
						if t:IsA('TextLabel') then
							t.Text = ""
							t.TextTransparency = 1
							t.TextStrokeTransparency = 1
						end
					end
					spawn(function()
						local frame = c.Frame.Hint
						frame.Msg.Text = table.concat(args,' ',2)
						TS:Create(frame.Msg,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{TextTransparency = 0,TextStrokeTransparency = 0.5}):Play()
						wait(11)
						TS:Create(frame.Msg,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{TextTransparency = 1,TextStrokeTransparency = 1}):Play()
						wait(2)
						c:Destroy()
					end)
				end
			end		


		end,
	};
	{
		name = "CFAnnouncement",
		aliases = {"CFA"},

		execute = function(sender,args)

			local gui = script:WaitForChild('Creature_Announcement')
			local TS = game:GetService('TweenService')
			for i,v in pairs(game:GetService('Players'):GetChildren()) do
				if v:IsA('Player') and v.Character ~= nil and v:FindFirstChildOfClass('PlayerGui') then
					local c
					if v.PlayerGui:FindFirstChild('Creature_Announcement') then
						c = v.PlayerGui.Creature_Announcement
					else
						c = gui:Clone()
					end
					c.Parent = v:FindFirstChildOfClass('PlayerGui')
					for i,t in pairs(c.Frame.Low:GetDescendants()) do
						if t:IsA('TextLabel') then
							t.Text = ""
							t.TextTransparency = 1
							t.TextStrokeTransparency = 1
						end
					end
					spawn(function()
						local frame = c.Frame.Low
						local text = table.concat(args,' ',2)
						TS:Create(c.Frame.Hint.ImageLabel,TweenInfo.new(3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{ImageTransparency = 0}):Play()
						TS:Create(frame.Msg,TweenInfo.new(3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{TextTransparency = 0,TextStrokeTransparency = 0.5}):Play()
						task.wait(0.3)
						for i=1, string.len(text) do
							task.wait(0.07)
							frame.TrueMsg.Value = string.sub(text, 1, i)
						end
						wait(8)
						if frame.TrueMsg.Value == text then
							TS:Create(c.Frame.Hint.ImageLabel,TweenInfo.new(3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{ImageTransparency = 1}):Play()
							TS:Create(frame.Msg,TweenInfo.new(3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{TextTransparency = 1,TextStrokeTransparency = 1}):Play()
							wait(2)
							c:Destroy()
						end
					end)
				end
			end		


		end,
	};
	{
		name = "TFAnnouncement",
		aliases = {"TFA"},

		execute = function(sender,args)

			if #args < 2 then
				game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, 'Please provide a message.')
				return
			end
			local msg = table.concat(args,' ',2)

			local gui = script:WaitForChild('TF_Announcement')
			local TS = game:GetService('TweenService')
			local rand = Random.new()
			local Sound = game.SoundService.SFX.GUI.Typing
			
			for i,v in pairs(game:GetService('Players'):GetChildren()) do

				spawn(function()
					if v:IsA('Player') and v.Character ~= nil and v:FindFirstChildOfClass('PlayerGui') then
						local announcement = gui:Clone()
						gui.Enabled = true
						announcement.Parent = v:FindFirstChildOfClass('PlayerGui')
						local textBar = announcement.Frame.Text2

						for i=1, string.len(msg) do
							task.wait(0.1)
							textBar.Text = string.sub(msg, 1, i)
							Sound.PitchShiftSoundEffect.Octave = rand:NextNumber(0.9, 1.1)
							Sound:Play()
						end
						task.wait(2)
						announcement:Destroy()

					end
				end)
			end		


		end,
	};
	{
		name = "Rebound",
		aliases = {"Reb"},

		execute = function(sender,args)	
			local target = findPlayer(sender, args[2])
			
			if target then
				if target.Character:FindFirstChild('Rebound') then
					target.Character.Rebound:Destroy()
					
				else
					local reboundFolder = Instance.new('Folder', target.Character)
					reboundFolder.Name = 'Rebound'
					
				end
			else
				-- Send a message back to the command sender if the player is not found
				game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, 'Player not found.')
				
			end
		end,
	};
	{
		name = "MFAnnouncement",
		aliases = {"MFA"},

		execute = function(sender,args)
			if #args < 3 then
				game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, 'Please provide a message and a player name.')
				return
			end
			local msg = table.concat(args,' ',3)

			local targetPlayer = findPlayer(sender, args[2])

			if targetPlayer then
				game.ReplicatedStorage.events.MFAnnounce:FireClient(targetPlayer, msg)
				game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, 'Sent \"'..msg..'\" to '..targetPlayer.Name..'.')
			else
				-- Send a message back to the command sender if the player is not found
				game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, 'Player not found.')
			end


		end,
	};
	{
		name = "FlickerLights",
		aliases = {"light"},

		execute = function(sender,args)

			local batcave = game.Workspace
			local lights = {}
			for i, v in batcave:GetDescendants() do
				if v:IsA('PointLight') then
					table.insert(lights, v)
				end
			end
			
			if lightsActive then

				local k = 0
				while k < 30 do
					for i, light in pairs(lights) do
						light.Enabled = not light.Enabled
					end
					k+=1
					task.wait(0.05)
				end

				for i, light in pairs(lights) do
					light.Enabled = false
				end
				lightsActive = false
			else
				local k = 0
				while k < 30 do
					for i, light in pairs(lights) do
						light.Enabled = not light.Enabled
					end
					k+=1
					task.wait(0.05)
				end

				for i, light in pairs(lights) do
					light.Enabled = true
				end
				lightsActive = true
			end

		end,
	};
	{
		name = "GiveTool",
		aliases = {"give"},

		execute = function(sender,args)	

			local targetPlayer = findPlayer(sender, args[2])

			if targetPlayer then
				local tool = findTool(table.concat(args,' ',3))
				if tool then
					tool:Clone().Parent = targetPlayer.Backpack

					local data = targetPlayer:FindFirstChild('PlayerData')
					if not data then
						print('Data not found')
						game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, tool.Name..' given to '..targetPlayer.Name.. '[UNABLE TO SAVE]')
						return
					else
						local newTool = Instance.new('Folder', data.Tools)
						newTool.Name = tool.Name
						game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, tool.Name..' given to '..targetPlayer.Name)
					end
				else
					-- Send a message back to the command sender if the tool is not found
					game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, table.concat(args,' ',3)..' not found.')
				end
			else
				-- Send a message back to the command sender if the player is not found
				game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, 'Player not found.')
			end	


		end,
	};
	{
		name = "RemoveTool",
		aliases = {"remove"},

		execute = function(sender,args)	

			local targetPlayer = findPlayer(sender, args[2])

			if targetPlayer then
				local tool = findTool(table.concat(args,' ',3))
				if tool then
					local toolObj1 = targetPlayer.Backpack:FindFirstChild(tool.Name)
					local toolObj2 = targetPlayer.Character:FindFirstChild(tool.Name)
					
					if toolObj1 then
						toolObj1:Destroy()
					elseif toolObj2 then
						toolObj2:Destroy()
					end
						
					if toolObj1 or toolObj2 then
						local data = targetPlayer:FindFirstChild('PlayerData')
						if not data then
							print('Data not found')
							game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, tool.Name..' removed from '..targetPlayer.Name.. '[UNABLE TO SAVE]')
							return
						else
							local dataTool = data.Tools:FindFirstChild(tool.Name)
							if dataTool then
								dataTool:Destroy()
							end
							game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, tool.Name..' removed from '..targetPlayer.Name)
						end
					else
						-- Send a message back to the command sender if the tool is not found
						game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, tool.Name..' not in inventory.')
					end

				else
					-- Send a message back to the command sender if the tool is not found
					game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, table.concat(args,' ',3)..' not found.')
				end
			else
				-- Send a message back to the command sender if the player is not found
				game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, 'Player not found.')
			end	


		end,
	};
	{
		name = "ClearInventory",
		aliases = {"clear"},

		execute = function(sender,args)	

			local targetPlayer = findPlayer(sender, args[2])

			if targetPlayer then
				local data = targetPlayer:FindFirstChild('PlayerData')
				if not data then
					print('Data not found')
					game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, 'Data not found.')
					return
				end
				
				local equippedTool = targetPlayer.Character:FindFirstChildOfClass("Tool")
				if equippedTool and equippedTool.Name ~= 'Fists' then
					equippedTool:Destroy()
				end
				
				for i, tool in pairs(targetPlayer.Backpack:GetChildren()) do
					if tool.Name ~= 'Fists' then
						tool:Destroy()
					end
				end

				for i, dataTool in pairs(data.Tools:GetChildren()) do
					if dataTool.Name ~= 'Fists' then
						dataTool:Destroy()
					end
				end
			end	

			game.ReplicatedStorage.events.MFAnnounce:FireClient(sender, args[2]..' not found.')

		end,
	};
	{
		name = "LoadSlot",
		aliases = {"load"},

		execute = function(plr,args)	
			local player = findPlayer(plr, args[2])
			
			--charData.Save(player, player.Name)

			local data
			local success, err = pcall(function()

				data = game:GetService('DataStoreService'):GetDataStore("PlayerData"):GetAsync(table.concat(args,' ',3))

			end)
	
			if success and data then

				print(data)
				
				local playerData = player:FindFirstChild('PlayerData')
				if playerData then playerData:Destroy() end
				playerData = Instance.new("Folder") 
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
					local newTool = Instance.new('Folder', tools)
					newTool.Name = tool
				end
				
				weapon.Value = data[9]

				charData.Load(player)
			else
				print("The player has no data!")
				-- Send a message back to the command sender
				game.ReplicatedStorage.events.MFAnnounce:FireClient(plr, 'Invalid slot.')
			end

		end,
	};
	{
		name = "SetGroup",
		aliases = {"npcgroup"},

		execute = function(plr,args)	

			local target = plr.Character:FindFirstChild('NPC')

			if target then
				target:WaitForChild('Group').Value = table.concat(args,' ',2)
			else
				-- Send a message back to the command sender
				game.ReplicatedStorage.events.MFAnnounce:FireClient(plr, 'Equip the NPC tool to use this command.')
			end

		end,
	};
	{
		name = "SetWeapon",
		aliases = {"setWeapon", "weapon"},

		execute = function(plr,args)
			local target = findPlayer(plr, args[2])
			local weaponName = args[3]
			
			target.PlayerData.Weapon.Value = weaponName
			events.SetStat:Fire(target,'Weapon',weaponName)
		end,
	};
	{
		name = "Katana",
		aliases = {"katana"},

		execute = function(plr,args)
			local target = findPlayer(plr, args[2])

			if not target.Character:FindFirstChild("AccessoryKatana") then
				local accessKatana = vfx.AccessoryKatana:Clone()
				accessKatana.Attach.Part0 = target.Character.Torso
				accessKatana.Parent = target.Character
			end

			events.SetStat:Fire(target,'Weapon','SheathedKatana')
		end,
	};
	{
		name = "MassacreMsg",
		aliases = {"massacre", "mmsg", "foxmsg"},

		execute = function(plr,args)
			local target = findPlayer(plr, args[2])
			
			local msg = table.concat(args,' ',3)

			local targetPlayer = findPlayer(plr, args[2])

			if targetPlayer then
				events.MassacreMsg:FireAllClients(target.Character, msg)
			else
				-- Send a message back to the command sender if the player is not found
				game.ReplicatedStorage.events.MFAnnounce:FireClient(plr, 'Player not found.')
			end
			
		end,
	};
	{
		name = "SetColor",
		aliases = {"npccolor"},

		execute = function(plr,args)	

			local target = plr.Character:FindFirstChild('NPC')
			
			if #args < 4 then
				game.ReplicatedStorage.events.MFAnnounce:FireClient(plr, 'You need three values for a color (RED GREEN BLUE).')
			end
			print('hola')
			if target then
				print('cool', args[2], args[3], args[4])
				target:WaitForChild('Color').Value = Color3.fromRGB(args[2], args[3], args[4])
				print('target', target, target.Color.Value)
			else
				-- Send a message back to the command sender
				game.ReplicatedStorage.events.MFAnnounce:FireClient(plr, 'Equip the NPC tool to use this command.')
			end

		end,
	};
	{
		name = "SetData",
		aliases = {"npcdata"},

		execute = function(plr,args)		

			local target = plr.Character:FindFirstChild('NPC')

			if target then
				target:WaitForChild('Data').Value = table.concat(args,' ',2)
			else
				-- Send a message back to the command sender
				game.ReplicatedStorage.events.MFAnnounce:FireClient(plr, 'Equip the NPC tool to use this command.')
			end

		end,
	};
	{
		name = "SaveSlot",
		aliases = {"save"},

		execute = function(plr,args)	
			if #args<3 then
				-- Send a message back to the command sender
				game.ReplicatedStorage.events.MFAnnounce:FireClient(plr, 'Minimum 3 parameters: Save [username] [slot name]')
				return
			end
			
			local target = findPlayer(plr, args[2])
			
			if target then
				charData.Save(target, table.concat(args,' ',3))
				-- Send a message back to the command sender
				game.ReplicatedStorage.events.MFAnnounce:FireClient(plr, table.concat(args,' ',3) ..' saved to '.. target.Name)
			else
				-- Send a message back to the command sender
				game.ReplicatedStorage.events.MFAnnounce:FireClient(plr, args[2] .. ' is not a valid username.')
			end

		end,
	};
	{
		name = "Creature",
		aliases = {"creature"},

		execute = function(plr,args)	
			print(args)

			local target = findPlayer(plr, args[2])
			
			if target then
				local cre = script.TheExperiment:Clone()
				cre.Name = target.Name
				local anim = script.Animate:Clone()
				cre.Parent = game.Workspace
				cre:PivotTo(target.Character.HumanoidRootPart.CFrame)
				target.Character = cre
				task.wait(0.5)
				anim.Parent=cre
				RP.events.Creature:FireClient(target)
			end
		end,
	};
	{
		name = "Roomba",
		aliases = {"room"},

		execute = function(plr,args)	
			print(args)

			local target = findPlayer(plr, args[2])

			if target then
				local cre = script.Roomba:Clone()
				cre.Name = target.Name
				cre.Parent = game.Workspace
				cre:PivotTo(target.Character.HumanoidRootPart.CFrame)
				target.Character = cre
				RP.events.Creature:FireClient(target)
			end
		end,
	};
	{
		name = "Phoenix",
		aliases = {"pawaken"},

		execute = function(plr,args)	
			local target = findPlayer(plr, args[2])

			if target then
				for i, v in pairs(game.Players:GetChildren()) do
					v.Character:SetAttribute('Stunned', true)
				end
				RP.events.PhoenixAwaken:FireAllClients(target.Name)
				task.wait(30)

				for i, v in pairs(game.Players:GetChildren()) do
					v.Character:SetAttribute('Stunned', false)
				end
			end
		end,
	};
	{
		name = "Radio",
		aliases = {"rad"},

		execute = function(plr,args)	

			local radioFolder = SS.Radio
			local channel = args[2]
			local message = table.concat(args,' ',3)
			local channelFolder = radioFolder:FindFirstChild(channel)

			if channelFolder then
				local ChatService = game:GetService('Chat')
				for i, recipent in channelFolder:GetChildren() do
					local rPlayer = game.Players:GetPlayerByUserId(tonumber(recipent.Name))
					local rChar = rPlayer.Character
					local proxy = rChar:FindFirstChild('BubbleProxy')

					if proxy then

						local data = plr:FindFirstChild('PlayerData')
						if data then
							local sName = data.PlayerName.Value
							ChatService:Chat(proxy, '['..sName..'] '..message, Enum.ChatColor.Red)
						else
							ChatService:Chat(proxy, message, Enum.ChatColor.Red)
						end
					end
				end
			end
		end,
	};
	{
		name = "Respawn",
		aliases = {"re"},

		execute = function(plr,args)	
			local target = findPlayer(plr, args[2])

			if target then
				local char = target.Character or target.CharacterAdded:Wait()
				local location = char.HumanoidRootPart.CFrame
				
				pcall(target.LoadCharacter, target)
				--Remote.Send(target, "Function", "SetView", "reset")
				
				char = target.Character or target.CharacterAdded:Wait()
				
				local data
				local success, err = pcall(function()

					data = game:GetService('DataStoreService'):GetDataStore("PlayerData"):GetAsync(target.Name)

				end)

				if success and data then

					print(data)

					local playerData = target:FindFirstChild('PlayerData')
					if playerData then playerData:Destroy() end
					playerData = Instance.new("Folder") 
					playerData.Name = "PlayerData"
					playerData.Parent = target 

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
						local newTool = Instance.new('Folder', tools)
						newTool.Name = tool
					end

					charData.Load(target)
					
					task.wait(0.1)
					
					char.HumanoidRootPart.CFrame = location
				else
					print("The player has no data!")
					-- Send a message back to the command sender
					game.ReplicatedStorage.events.MFAnnounce:FireClient(plr, 'Invalid slot.')
				end
			end
		end,
	}			
}

return Commands
