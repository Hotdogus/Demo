
function GetMouseInfo(player,ignore)
	local mousehit,mousehitp,mousetarget
	local character = player:IsA("Player") and player.Character or player
	local defaultIgnore = {workspace.Projectiles,character}
	ignore = ignore and {unpack(ignore),unpack(defaultIgnore)} or defaultIgnore
	if not player:IsA("Player") then
		--mousehit,mousehitp,mousetarget = BotService.AttackPlayer(character)
	else
		
		local mH,mHP,mT,unitRay = game.ReplicatedStorage.getMouse:InvokeClient(player)
		
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
		raycastParams.FilterDescendantsInstances = ignore
		raycastParams.IgnoreWater = true
		local raycastResult = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, raycastParams)
		
		if raycastResult then
			mousehit,mousehitp,mousetarget = CFrame.new(raycastResult.Position),raycastResult.Position,raycastResult.Instance
		else
			mousehit,mousehitp,mousetarget = mH,mHP,mT
		end
	end
	print("Gotmouseinfo")
	return mousehit,mousehitp,mousetarget
end
return GetMouseInfo