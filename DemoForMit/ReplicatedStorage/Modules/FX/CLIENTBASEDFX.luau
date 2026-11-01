local module = {}

local plr = game.Players.LocalPlayer

module.ImpactFrames = function(Player)
	
	if Player and Player == plr then
		game.Lighting.Impact1.Enabled = true
		wait(0.1)
		game.Lighting.Impact1.Enabled = false
		game.Lighting.Impact2.Enabled = true
		wait(0.1)
		game.Lighting.Impact2.Enabled = false
		game.Lighting.Impact1.Enabled = false
	end
end

return module
