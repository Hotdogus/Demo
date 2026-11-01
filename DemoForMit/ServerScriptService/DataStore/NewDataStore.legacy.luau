--local DS = game:GetService("DataStoreService"):GetDataStore("Main_Datastore_"..game.ServerStorage.DatastoreValue.Value,'global')

local Players = game:GetService("Players")
local run = game:GetService("RunService")
_G.Disconnect = false

local Base = {

	["Numbers"] = {

		["Yen"] = 0,
		["Scrap"] = 0,

		["SP"] = 0,
		["Stims"] = 6,

		["Lives"] = 3,
		["Grips"] = 0,
		["MissionEXP"] = 0,
		
		["Health"] = 200,
		["LastHealth"] = 200,
		
		["Stamina"] = 100,
		["MaxStamina"] = 100,

		["Face"] = 1,
		["Variation"] = 0,

	},

	["Strings"] = {	

		["Primary"] = "",
		["Secondary"] = "",

		["Weapon"] = "SheathedKatana",

		["Gender"] = "",

		["Marking"] = "",

		["FirstName"] = "",
		["Clan"] = "",

		["LeftEye"] = "",
		["RightEye"] = "",

		["LeftArm"] = "",
		["LeftEar"] = "",
		["RightEar"] = "",
		["RightArm"] = "",
		["Torso"] = "",
		["Head"] = "",
		["Faction"] = "Human",
		["Neck"] = "",
		["FaceAcc"] = "",
		["LeftLeg"] = "",
		["RightLeg"] = "",

		["Outfit"] = "",

		["Grade"] = "",

		["UnlockedSkills"] = "",
		["HasLoaded"] = "",	

		["Slot1"] = "",
		["Slot2"] = "",
		["Slot3"] = "",
		["Slot4"] = "",
		["Slot5"] = "",
		["Slot6"] = "",
		["Slot7"] = "",
		["Slot8"] = "",
		["Slot9"] = "",
		["Slot0"] = "",
		
		
		HairColorR = math.random(0,255),
		HairColorG = math.random(0,255),
		HairColorB = math.random(0,255),
		
		LeftEyeColorR = math.random(0,255),
		LeftEyeColorG = math.random(0,255),
		LeftEyeColorB = math.random(0,255),
		RightEyeColorR = math.random(0,255),
		RightEyeColorG = math.random(0,255),
		RightEyeColorB = math.random(0,255),
		

	},

	["Bools"] = {

		["PReveal"] = false,
		["SReveal"] = false,
		["CombatTagged"] = false,


	}
}

local function Update(pfolder,tab,type)
	if type == "Join" then
		for i,v in pairs(Base) do
			for i2,v2 in pairs(v) do
				if typeof(v2) == 'string' then
					local n = Instance.new("StringValue",pfolder)
					n.Name = i2
					n.Value = v2
					if tab[i] and tab[i][i2] then
						n.Value = tab[i][i2]
					end						
				elseif typeof(v2) == 'boolean' then
					local n = Instance.new("BoolValue",pfolder)
					n.Name = i2
					n.Value = v2
					if tab[i] and tab[i][i2] then
						n.Value = tab[i][i2]
					end							
				elseif typeof(v2) == 'number' then
					local n = Instance.new("NumberValue",pfolder)
					n.Name = i2
					n.Value = v2
					if tab[i] and tab[i][i2] then
						n.Value = tab[i][i2]
					end											
				end
			end			
		end

	else
		local new = {
			["Numbers"] = {},
			["Strings"] = {},
			["Bools"] = {}
		}
		for i,v in pairs(pfolder:GetChildren()) do
			if v:IsA("BoolValue") then
				new.Bools[v.Name] = v.Value
			elseif v:IsA("StringValue") then
				new.Strings[v.Name] = v.Value 
			elseif v:IsA("NumberValue") then
				new.Numbers[v.Name] = v.Value
			end	
		end

		return new		
	end
end

game:GetService("Players").PlayerAdded:Connect(function(Player)
	--local Data = DS:GetAsync(Player.UserId)
	local pfolder = Instance.new("Folder", game.ReplicatedStorage:WaitForChild("PlayerData")) 
	pfolder.Name = Player.Name
	print(pfolder)
	--if Data then
		--Update(pfolder,Data,"Join")

	--else
		local tab = Base
		Update(pfolder,tab,"Join")
		--local success = pcall(function() DS:SetAsync(Player.UserId,tab) end)
	--end		
end)

--Players.PlayerRemoving:Connect(function(Player)
--	if _G.Disconnect == true then
--		return 
--	end

--	local folder = game.ReplicatedStorage:WaitForChild("PlayerData"):FindFirstChild(Player.Name)
--	if folder then
--		local Data = Update(folder,nil,"Leave")
--		--local success = pcall(function() DS:SetAsync(Player.UserId,Data) end)
--		folder:Destroy()	
--	end	
--end)

--game:BindToClose(function()
--	if run:IsStudio() then
--	else
--		_G.Disconnect = true
--		for i,Player in pairs(Players) do
--			local folder = game.ReplicatedStorage:WaitForChild("PlayerData"):WaitForChild(Player.Name)
--			if folder then

--				local Data = Update(folder,nil,"Disconnect")
--				--local success = pcall(function() DS:SetAsync(Player.UserId,Data) end)
--			end	
--		end		
--		task.wait(15)
--	end
--end)





