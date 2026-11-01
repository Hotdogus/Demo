

local bald = {
	"Dullahan",
	"DullahanBlue",
	"DullahanPurple",
	"Gaian",
	"CastellanShiny",
	"Gaian90",
	"Kasparan",
	"LesserNavaran",
	"ShinyNavaran",
	"Scroom",
	"PurpleScroom",
	"Metascroom",
	"Goldscroom",
	"Glowscroom",
	"Florian",
}

_G.GetPlayerAppearanceInfo = function(player,Stats)
_G.GetPlayerAppearanceInfo = function(player,Stats)

		task.wait(0.1)
		
		local Accessory = require(script.Accessory)
		local nameList = Accessory.nameList
		local nameList2 = Accessory.nameList2
		print("made it to char")
		local Char = game.Players:GetCharacterAppearanceAsync(player.CharacterAppearanceId)
		
		game.Debris:AddItem(Char,1)
		
		Char.Parent = game.ReplicatedStorage
		
		local Hair = {}
		local Accessories = {}
		local Face = {}
		
		for _,x in pairs(Char:GetChildren()) do
			
			if x:IsA('Accessory') then
				local attachment = x:FindFirstChildWhichIsA('Attachment',true)
				if attachment and nameList[attachment.Name] then
					if nameList2[attachment.Name] == 'HairAttachment' or "FaceCenterAttachment" then
						table.insert(Hair,x)
					else
						table.insert(Accessories,x)
					end
				end
			end
			
			for _,x in pairs(Char:GetChildren()) do
				if x:IsA('Accessory') then
					local attachment = x:FindFirstChildWhichIsA('Attachment',true)
					if attachment and nameList[attachment.Name] then
						if nameList2[attachment.Name] == "FaceCenterAttachment" then
							table.insert(Face,x)
						else
							table.insert(Accessories,x)
						end
					end
				end
			end
			
		end


		local character = player.Character
		Accessories = {}


		return 
			{
				["Face"] = Face;	
				["Hair"] = Hair;
				["Accessories"] = Accessories;
			}
		
	end
	

end