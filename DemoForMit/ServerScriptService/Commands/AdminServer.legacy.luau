-- Services
local replicatedstorage = game:GetService("ReplicatedStorage")
local serverstorage = game:GetService("ServerStorage")
local serverscriptservice = game:GetService("ServerScriptService")
-- Remotes
local commandevent = replicatedstorage.Events.Commands -- Fires from ConsoleClient
-- Variables
--local admins = serverstorage.Admins For portfolio, everyone has admin
-- Module
local commandsmodule:ModuleScript = require(serverscriptservice.Commands.Commands)
-- Function
local function ExecuteCommand(player,text)
	local args = string.split(text," ")
	
	for _,command in pairs(commandsmodule) do
		if args[1]:lower() == command["name"]:lower() then
			command["execute"](player,args)
		end
		
		for _,alias in pairs(command["aliases"]) do
			if args[1]:lower() == (alias:lower()) then
				command["execute"](player,args)
			end
		end
	end
end

local function CheckAdmin(player:Player,text)
	--for _,adminid in pairs(admins:GetChildren()) do
	--	if player.UserId == tonumber(adminid.Name) then
			ExecuteCommand(player,text)
		--end
	--end
end
-- Events
commandevent.OnServerEvent:Connect(CheckAdmin)
