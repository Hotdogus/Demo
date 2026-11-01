local manager = {}

local SoundsList = {
	["plastic"] = { --Will add more sounds later, to randomize between them and have some variation
		"rbxassetid://7326203155";
	};
	
	["grass"] = {
		"rbxassetid://507863105";
	};
	
	["metal"] = {
		"rbxassetid://6876957898";
	};
	
	["wood"] = {
		"rbxassetid://507863457";
	};
	
	["concrete"] = {
		"rbxassetid://5761648082";
	};
	
	["fabric"] = {
		"rbxassetid://6240702531";
	};
	
	["sand"] = {
		"rbxassetid://265653329";
	};
	
	["glass"] = {
		"rbxassetid://9117949159";
	};
}

local MaterialMap = {
	smoothplastic = SoundsList.plastic;
	forcefield =    SoundsList.plastic;
	foil =          SoundsList.plastic;
	
	woodplanks =    SoundsList.wood;
	
	ground =        SoundsList.fabric;
	
	diamondplate =  SoundsList.metal;
	corrodedmetal = SoundsList.metal;
	
	leafygrass =    SoundsList.grass;
	mud =           SoundsList.grass;
	snow =          SoundsList.grass;
	glacier =       SoundsList.grass;
	
	pavament =      SoundsList.concrete;
	limestone =     SoundsList.concrete;
	salt =          SoundsList.concrete;
	asphalt =       SoundsList.concrete;
	neon =          SoundsList.concrete;
	crackedlava =   SoundsList.concrete;
	basalt =        SoundsList.concrete;
	sandstone =     SoundsList.concrete;
	rock =          SoundsList.concrete;
	cobblestone =   SoundsList.concrete;
	pebble =        SoundsList.concrete;
	brick =         SoundsList.concrete;
	granite =       SoundsList.concrete;
	marble =        SoundsList.concrete;
	ice =           SoundsList.concrete;
	slate =         SoundsList.concrete;
}

function manager:CreateSoundsFolder(parent)
	local folder = Instance.new("Folder")
	folder.Name = "FootstepSounds"
	folder.Parent = parent
	
	for name , material in pairs(SoundsList) do
		local materialFolder = Instance.new("Folder")
		materialFolder.Name = name
		materialFolder.Parent = folder
		
		for j , id in ipairs(material) do
			local sound = Instance.new("Sound")
			sound.Name = "variant_" .. j
			sound.SoundId = id
			sound.Volume = 2
			sound.Parent = materialFolder
		end
	end
	
	for name, material in pairs(MaterialMap) do
		local materialFolder = Instance.new("Folder")
		materialFolder.Name = tostring(name)
		materialFolder.Parent = folder

		for j , id in ipairs(material) do
			local sound = Instance.new("Sound")
			sound.Name = "variant_" .. j
			sound.SoundId = id
			sound.Volume = 2
			sound.Parent = materialFolder
		end 
	end
	
	return folder
end

function manager:GetRandomSound(j_)
	self.title = j_[1]
	self.soundsFolder = j_[2]
	math.randomseed(tick())
	
	local sound = SoundsList[self.title] or MaterialMap[self.title]
	if sound then
		self.soundsFolder = self.soundsFolder[self.title]
		local footstep = self.soundsFolder:GetChildren()[math.random(1, #self.soundsFolder:GetChildren())]
		return footstep.SoundId, footstep.Volume
	else
		return ""
	end
end

return manager
