# Demo
A few things to note about the files here:

1. These are files moved from the original game over to a demo; this is to prevent errors from things I'm working on at the moment and to make it easier to actually upload to GitHub
2. On that same idea, uploading this to GitHub was really confusing, so there are lots of things missing that are in the actual game. Remote events, for example, could not be uploaded from what I saw. In addition, the few scripts I had for health, stamina, and posture couldn't be uploaded to GitHub using the script sync feature in Studio. There shouldn't be anything too crazy missing, and it's not like remote events are anything other than just an object that sends signals.
3. I believe Visual Studio and other IDEs have LuaU plugins, but I doubt anything will actually run because all Roblox (and game engine in general) code depends on objects in the studio workspace.

Please note, one of my scripts was edited by an AI. Not going to hide it or try and make excuses; it was several years ago and back when AI was getting into its groove. I needed a way to make cutscenes, and my old cutscene script was getting really confusing to use. I'll include a copy of its original code at the bottom of this file. I used AI to edit and expand upon it, but only ended up using the more readable versions of my old functions it rewrote. I regret doing it now, but it's baked into my project. All it really handles in my cutscenes is tweening cameras, doing cuts, and keeping track of the camera's original location

Finally, please forgive my severe lack of comments. These were all made in the few days between the live events I used the game for, so all of the code is a bit disorganized, and my notes to self are all scribbles on my notes app.

Here are the most interesting scripts:

1. TagHumanoid
serverscriptservice > taghumanoid > init.legacy
Anytime damage needs to be dealt to a character, it runs through here.

2. HITBOXING
serverscriptservice > combat > HITBOXING.luau
My main method of hit detection, works in tandem with taghumanoid. There is another, newer and better labeled, hitbox module that is used for some abilities, but this one is used for the base combat system and has some of the more interesting methods for hit detection.

3. Ability Server
serverscriptservice > combat > AbilityServer.legacy.luau
Has all the server-side code of the abilities, many of which I decided not to showcase in the portfolio but are still cool to look at. Line 953 is where the showcased cutscene's code is.

4. Ability Client
starterplayerscripts > AbilityClient.local.luau
Has all the client-side of the abilities. Line 172 has the client-side of the cutscene, including the camera movements.


--ORIGINAL CAMERA SCRIPT
local RP = game:GetService('ReplicatedStorage')
local TS = game:GetService('TweenService')

local plr = game:GetService('Players').LocalPlayer

local events = RP:WaitForChild('Events')

local returnPoint = nil
local returnType = nil
local cam = workspace.CurrentCamera

local currTween = false
local paused = false

local function cutCam(target)
	cam.CameraType = Enum.CameraType.Scriptable
	cam.CFrame = target
end

local function pauseCam(target)
	if paused then
		cam.CameraType = Enum.CameraType.Scriptable
		cam.CFrame = paused
		paused = false
		currTween:Play()
	else
		paused = cam.CFrame
		currTween:Pause()
		cam.CameraType = Enum.CameraType.Scriptable
		cam.CFrame = target
	end
end

local function tweenCam(target, tweenTime)
	cam.CameraType = Enum.CameraType.Scriptable
	currTween = TS:Create(cam, TweenInfo.new(tweenTime), {CFrame = target})
	currTween:Play()
end

local vfx = RP:WaitForChild('Abilities')

local disabled = {}

events:WaitForChild('Camera').OnClientEvent:Connect(function(target, returnTo, tweenTo, disableUi, pause)
	
	if disableUi then
		if #disabled > 0 then
			for i, v in pairs(disabled) do
				v.Enabled = true
			end
			table.clear(disabled)
		else
			for i, v in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
				if v:IsA('ScreenGui') and v.Enabled then
					table.insert(disabled, v)
					v.Enabled = false
				end
			end
		end
		return
	elseif pause then
		pauseCam(target)
		return
	end
	
	if returnTo then
		if returnPoint == nil then
			returnType = cam.CameraType
			returnPoint = cam.CFrame
			
			if tweenTo then
				tweenCam(target, tweenTo)
			else
				cutCam(target)
			end
		else
			cam.CameraType = returnType
			cam.CFrame = returnPoint
		end
	else
		if tweenTo then
			tweenCam(target, tweenTo)
		else
			cutCam(target)
		end
	end
end)
