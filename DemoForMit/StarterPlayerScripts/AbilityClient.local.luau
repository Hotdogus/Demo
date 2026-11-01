local plr = game:GetService('Players').LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

local RP = game:GetService('ReplicatedStorage')
local PS = game:GetService('Players')
local TS = game:GetService('TweenService')
local SoundService = game:GetService('SoundService')

local abilitySettings = RP:WaitForChild('AbilitySettings')

local events = RP:WaitForChild('Events')
local vfx = RP:WaitForChild('VFXStorage')
local anims = RP:WaitForChild('Animations')
local sounds = SoundService:WaitForChild('Abilities')

local abilityEvent = events:WaitForChild('Ability')
local camHandler = require(RP:WaitForChild('CameraHandler'))

local function ToggleAnchor(val)
	for i, v in pairs(char:GetChildren()) do
		if v:IsA('Part') then
			v.Anchored = val
		end
	end
end

abilityEvent.OnClientEvent:Connect(function(spec, abilityID, ...)
	local args = {...}

	if spec == 2 then
		--Time Spec

		if abilityID == 1 then
			--Timestop on

			ToggleAnchor(true)

			local blackAndWhite = vfx.BlackAndWhite:Clone()
			blackAndWhite.Parent = game.Lighting
			local tsInfo = TweenInfo.new(0.2)
			TS:Create(blackAndWhite, tsInfo, {Saturation = -1}):Play()

		elseif abilityID == 2 then
			--Timestop off

			ToggleAnchor(false)

			local blackAndWhite = game.Lighting:FindFirstChild('BlackAndWhite')
			if blackAndWhite then
				local tsInfo = TweenInfo.new(0.2)
				TS:Create(blackAndWhite, tsInfo, {Saturation = 0}):Play()
				task.wait(0.2)
				blackAndWhite:Destroy()
			end

		elseif abilityID == 3 then
			--UI toggle
			local ui = plr.PlayerGui:FindFirstChild('TimeReverseToggle')
			if ui then
				ui:Destroy()
			else
				ui = RP.VFXStorage.TimeReverseToggle:Clone()
				ui.Parent = plr.PlayerGui
			end

		elseif abilityID == 4 then
			--Time Freeze
			local target = args[1]
			local duration = RP.AbilitySettings.TimeFreezeDURR.Value

			if target == plr.Name then
				--Self
				local crashUi = vfx.CrashUI:Clone()
				crashUi.Parent = plr.PlayerGui

				local crashSound = sounds.Crash
				crashSound:Play()
				task.delay(duration, function()
					crashSound:Stop()()
				end)
			end
			local billUi = vfx.CrashBillboard:Clone()
			billUi.Parent = game.Players[target].Character

			local progress = billUi.Frame.Progress

			local tsInfo = TweenInfo.new(duration)

			TS:Create(progress, tsInfo, {Size = UDim2.new(1, 0, 1, 0)}):Play()
			task.wait(duration + 0.3)

			billUi:Destroy()
		end
	elseif spec == 5 then
		--Baseball spec

		if abilityID == 2 then
			local white = Color3.new(1, 1, 1)
			local black = Color3.new(0, 0, 0)

			local blackFlash = vfx.BlackBack:Clone()
			local whiteFlash = vfx.WhiteBack:Clone()
			blackFlash.Parent = game.Lighting
			whiteFlash.Parent = game.Lighting

			local scene = args[1]

			local skele = scene.Skeleton
			skele.Transparency = 0

			local skullImp = scene.SkullImpact
			local batImp = scene.BatImpact

			--place highlight in char
			local highlight = vfx.HomerunHighlight:Clone()
			highlight.Parent = plr.Character

			blackFlash.Enabled = true
			highlight.Enabled = true
			skele.Highlight.Enabled = true
			skullImp.Highlight.Enabled = true
			batImp.Highlight.Enabled = true

			local flickerTime = 0.035
			scene.P1Root.SonicBoom2:Play()

			for i = 1, 3 do
				whiteFlash.Enabled = false
				blackFlash.Enabled = true

				highlight.FillColor = white
				skele.Highlight.FillColor = white
				skullImp.Highlight.FillColor = white
				batImp.Highlight.FillColor = white
				highlight.OutlineColor = black
				skele.Highlight.OutlineColor = black
				skullImp.Highlight.OutlineColor = black
				batImp.Highlight.OutlineColor = black

				task.wait(flickerTime)

				blackFlash.Enabled = false
				whiteFlash.Enabled = true

				highlight.FillColor = black
				skele.Highlight.FillColor = black
				skullImp.Highlight.FillColor = black
				batImp.Highlight.FillColor = black
				highlight.OutlineColor = white
				skele.Highlight.OutlineColor = white
				skullImp.Highlight.OutlineColor = white
				batImp.Highlight.OutlineColor = white

				task.wait(flickerTime)
			end

			skele.Transparency = 1
			highlight.Enabled = false
			skele.Highlight.Enabled = false
			skullImp.Highlight.Enabled = false
			batImp.Highlight.Enabled = false

			whiteFlash:Destroy()
			blackFlash:Destroy()

			scene.P2Root.BatHit:Play()
			scene.P2Root.BoneBreak:Play()
		end
	elseif spec==6 then
		--Katana spec

		if abilityID == 3 then
			--Slaughter cutscene

			local userChar = args[1]
			local hitChar = args[2]
			local sceneReference = args[3]

			local userAnim = anims.SlaughterExecute
			local targetAnim = anims.SlaughterHit
			local deadAnim = anims.Dead
			local userTrack = userChar.Humanoid.Animator:LoadAnimation(userAnim)
			local targetTrack = hitChar.Humanoid.Animator:LoadAnimation(targetAnim)
			local deadTrack = hitChar.Humanoid.Animator:LoadAnimation(deadAnim)
			userTrack:Play(0, 1, 0)
			targetTrack:Play(0, 1, 0)
			userTrack:AdjustWeight(1)
			targetTrack:AdjustWeight(1)



			local camCFs = sceneReference.CameraCFs

			--[[
			-Snap to cam1
			user swings, cleans their blade, and rests their sword on their shoulder.
			-Begin tween to cam2
			user begins to raise their hand.
			-Pause user anim---------------------------------
			-Snap to cam3
			-Begin tween to cam4
			target takes a step back.
			-Pause target anim---------------------------------
			-Snap to cam5
			-Unpause user anim---------------------------------
			user twists their hand.
			-Snap to cam6
			-Begin tween to cam7
			-Unpause target anim---------------------------------
			Target looks around, then quickly turns around
			-Snap to cam8
			-Begin tween to cam9
			]]
			local scene = camHandler.CreateCutscene()
			scene:Snap(camCFs.Cam1.CFrame) --1

			scene:Wait(3) --2
			scene:Tween(camCFs.Cam2.CFrame, 4) --3
			scene:Snap(camCFs.Cam3.CFrame) --4
			scene:Tween(camCFs.Cam4.CFrame, 3) --5
			scene:Snap(camCFs.Cam5.CFrame) --6

			scene:Wait(2) --7
			scene:Snap(camCFs.Cam6.CFrame * CFrame.new(Vector3.new(0,50,0))) --8
			scene:Tween(camCFs.Cam7.CFrame * CFrame.new(Vector3.new(0,50,0))) --9

			scene:Wait(3.5) --10
			scene:Snap(camCFs.Cam8.CFrame * CFrame.new(Vector3.new(0,50,0))) --11
			scene:Tween(camCFs.Cam9.CFrame * CFrame.new(Vector3.new(0,50,0)),2.8) --12
			scene:Snap(camCFs.Cam10.CFrame * CFrame.new(Vector3.new(0,50,0))) --13
			scene:Tween(camCFs.Cam11.CFrame * CFrame.new(Vector3.new(0,50,0)), 9) --13

			userTrack:AdjustSpeed(1)

			local sfx = sounds.Slaughter

			local ritualInfo = TweenInfo.new(2)
			local staticInfo = TweenInfo.new(4)
			local atmosphere = sceneReference.Atmosphere
			local oldAmb = game.Lighting.Ambient
			local start
			local ui
			local currStep = 0
			local black = sceneReference.Black
			black.Parent = plr.PlayerGui

			scene:OnStep(function()
				currStep += 1
				print('currStep ='..currStep)
				print(time()-start)

				if currStep == 4 then
					userTrack:AdjustSpeed(0)
					targetTrack:AdjustSpeed(1)
				elseif currStep == 6 then
					userTrack:AdjustSpeed(1)
					targetTrack:AdjustSpeed(0)
				elseif currStep == 8 then
					targetTrack:AdjustSpeed(0.7)
				elseif currStep == 13 then
					task.spawn(function()
						black.Enabled = true
						deadTrack:AdjustWeight(1)
						deadTrack:Play(0, 1)


						sfx.Whispers:Stop()
						sfx.HorrorDrone:Stop()
						sfx.Bell3:Stop()
						sfx.Static:Play()
						TS:Create(sfx.Static, staticInfo, {Volume = 3}):Play()
						task.wait(0.1)
						black.Enabled = false

						task.wait(9.5)
						scene:Stop()
						sfx.Static:Stop()
						sfx.Static.Volume = 0.5
						atmosphere:Destroy()
						game.Lighting.Ambient = oldAmb
						black:Destroy()

						print(time()-start)
						deadTrack:Stop()
					end)
				end
			end)


			--[[
			Step - victim finished stepping back
			Look - victim finished looking around, about to turn around
			Dread - victim starts looking up

			Swing - user finished swinging blood off sword
			Clean - user finished cleaning blood off sword
			Rest - user finished swinging their sword to rest on their shoulder
			Raise - user began raising their hand
			Twist - user finished twisting their hand
			]]
			local ritualMusic = sfx.Ritual
			ritualMusic:Play()
			TS:Create(ritualMusic, ritualInfo, {Volume = 1}):Play()

			userTrack.KeyframeReached:Connect(function(name)
				if name=='Swing' then
					sfx.BloodSwing:Play()
					local blood = vfx.SlashBlood:Clone()
					blood.Parent = char['Right Arm'].BodyAttach.Blade
					blood.Blood:Emit(20)
					blood.Splash:Emit(20)
					task.wait(1.5)
					sfx.CleanSword:Play()
					task.wait(0.1)
					sfx.SmallBlood:Play()

				elseif name=='Clean' then
					local blood = vfx.SlashBlood:Clone()
					blood.Parent = char['Right Arm'].BodyAttach.Blade
					blood.Blood:Emit(5)
					blood.Splash:Emit(5)
					task.wait(1.5)
					sfx.SwingLight:Play()

				elseif name=='Rest' then
					sfx.ClothHit:Play()
					local mid = vfx.Middle:Clone()
					mid.Parent = char['Right Arm']
					mid.Hit:Emit(4)

					task.wait(5)
					sfx.Footstep:Play()

				elseif name=='Raise' then

				elseif name=='Twist' then
					TS:Create(ritualMusic, ritualInfo, {Volume = 0}):Play()
					sfx.Bell1:Play()
					game.Lighting.Ambient = Color3.new(0,0,0)
					atmosphere.Parent = game.Lighting
					ui = sceneReference.LoadUi.BillboardGui
					ui.Light2.PointLight.Enabled = true
					task.wait(2)
					sfx.Bell2:Play()
					task.wait(3)
					sfx.Bell3:Play()
					ritualMusic:Stop()
				end
			end)

			targetTrack.KeyframeReached:Connect(function(name)
				if name=='Step' then

				elseif name=='Look' then
					sfx.Whispers:Play()
					task.wait(1)
					targetTrack:AdjustSpeed(0.5)
					--task.wait(3.5)
					task.wait(0.4)
					ui.Parent = hitChar.HumanoidRootPart
					ui.Enabled = true
					ui.Animate.Enabled = true
					task.wait(4)
					ui:Destroy()

				elseif name=='Dread' then
				end
			end)

			start = time()
			scene:Play()
		end
	end
end)