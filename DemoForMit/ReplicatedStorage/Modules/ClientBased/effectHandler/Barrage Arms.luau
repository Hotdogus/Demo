--// Variables \\--

local TS = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local bezierModule = require(replicatedStorage:FindFirstChild("Modules"):FindFirstChild("bezierCurve"))
local DebrisModule = require(game.ReplicatedStorage.Modules.DebrisModule) -- Add this line
local debrisManager = DebrisModule.new() -- Add this line

local effectCreator = {}

local effectFolder = game:GetService("Workspace").Ignore

--// Create Effect \\--

local function raycast(origin, direction, filterType, filterTable)

	--// Creating raycast \\--

	local raycastParameters = RaycastParams.new()
	raycastParameters.FilterType = filterType
	raycastParameters.FilterDescendantsInstances = filterTable
	raycastParameters.RespectCanCollide = true

	local raycastResult = game:GetService("Workspace"):Raycast(origin, direction, raycastParameters)

	--// Returning result \\--

	if raycastResult ~= nil then		
		return raycastResult	
	else		
		return "Nothing was hit"		
	end

end

local function createSoundEffect(Object, soundId, Volume, playbackSpeed)

	local newSound = Instance.new("Sound")
	newSound.Name = "Body Explode"
	newSound.SoundId = soundId

	newSound.RollOffMinDistance = 0
	newSound.RollOffMaxDistance = 100
	newSound.RollOffMode = Enum.RollOffMode.LinearSquare

	newSound.PlaybackSpeed = math.random((playbackSpeed * 100) * 0.8, (playbackSpeed * 100) * 1.2) / 100
	newSound.Volume = Volume

	newSound.Parent = Object
	newSound:Play()
	debrisManager:Add(newSound, newSound.TimeLength + 2) -- Changed this line

end

function effectCreator.Create(Parameters)

	print("Madeittocrreate")

	--// Variables \\--

	local localPlayer = players.LocalPlayer

	local barrageSubject = Parameters.Subject
	local Finisher = Parameters.Finisher

	local subjectHRP = barrageSubject:FindFirstChild("HumanoidRootPart")
	local subjectHumanoid = barrageSubject:FindFirstChildOfClass("Humanoid")

	local allBarrageArms = Instance.new("Model")
	allBarrageArms.Name = "All ".. barrageSubject.Name .. " Barrage Arms"
	allBarrageArms.Parent = effectFolder

	--// Creating arm preset \\--

	local armPreset = game.ReplicatedStorage.Assets.Models:FindFirstChild("Barrage Arms"):Clone()
	armPreset.Name = tostring(barrageSubject.Name .. " Barrage Arms")

	for i, v in pairs(armPreset:GetChildren()) do
		if v:IsA("BasePart") and barrageSubject:FindFirstChild(v.Name) then

			v.Color = barrageSubject:FindFirstChild(v.Name).Color

		elseif v:IsA("Shirt") then
			if barrageSubject:FindFirstChildOfClass("Shirt") then

				local shirtId = barrageSubject:FindFirstChildOfClass("Shirt").ShirtTemplate
				v.ShirtTemplate = shirtId

			end
		end
	end

	--// Making subjects arms dissappear \\--

	for i, v in pairs(barrageSubject:GetChildren()) do
		if v.Name == "Left Arm" then

			TS:Create(v, TweenInfo.new(0.3),{
				Transparency = 1
			}):Play()

		end
	end

	--// Creating effect \\--

	local createEffect = coroutine.wrap(function()

		local tweenConnections = {}
		local armOrder = 0

		local creatingArms

		creatingArms = game["Run Service"].Heartbeat:Connect(function()

			local rng = math.random(1,10)	
			if rng > 2 then return end 

			local canCreate = true

			--// Checking \\--

			if barrageSubject.Parent == nil or subjectHumanoid.Health <= 0 or not barrageSubject:FindFirstChild("HumanoidRootPart") or not barrageSubject:FindFirstChild("Barraging") then

				--// Disconnecting all connections \\--

				canCreate = false
				creatingArms:Disconnect()

				debrisManager:Add(allBarrageArms, 1.5) -- Changed this line
				armPreset:Destroy()

				--// Making arms appear \\--

				for i, v in pairs(barrageSubject:GetChildren()) do
					if v.Name == "Left Arm" or v.Name == "Right Arm" then

						TS:Create(v, TweenInfo.new(0.35),{
							Transparency = 0
						}):Play()

					end
				end

			end

			--// Creating \\--

			if canCreate == true then

				print("MadeitToCanCreate")

				--// Performing \\\--

				local create = coroutine.wrap(function()

					--// Creating arms \\--

					local Pos, InScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(subjectHRP.CFrame.Position)
					local distanceTo = (game.Workspace.CurrentCamera.CFrame.Position - subjectHRP.CFrame.Position).Magnitude

					if distanceTo < 200 then

						print("Weindascreen")

						local barrageArms = armPreset:Clone()
						barrageArms:SetPrimaryPartCFrame(subjectHRP.CFrame)

						--// Tweening arms \\--

						for i, v in pairs(barrageArms:GetChildren()) do
							if v:IsA("BasePart") and v:FindFirstChild("Arm") then

								armOrder += 1

								--// Creating curve \\--

								local bezierProgress = 0

								local sideOffset = math.random(50,160)

								if Finisher == true then
									sideOffset =  math.random(0,400)
								end

								local startPoint = v.CFrame * CFrame.new(math.random(-10,10) / 10, math.random(-10,10) / 10, math.random(4,8) / 10)
								local endPoint = subjectHRP.CFrame * CFrame.new(math.random(-15,15) / 10, math.random(-25,25) / 10, -6 * (math.random(75,125) / 100))
								local middlePoint = v.CFrame * CFrame.new(
									v:FindFirstChild("sideOffset").Value * (sideOffset / 100),
									math.random(-40,40) / 10,
									-2.5 * (math.random(75,125) / 100)
								)

								local armCurve = bezierModule.new(
									startPoint.Position,
									middlePoint.Position,
									endPoint.Position
								)

								--// Tweening arm \\--

								local tweenArm = coroutine.wrap(function()

									local currConnection = tostring("Barrage Arms ".. armOrder)

									local armDissappeared = false
									local armCreatedShockwave = false
									local armMadeSound = false

									local transparency = 0.5

									local start = tick()

									v.Position = armCurve:Get(bezierProgress)
									v.CFrame = CFrame.lookAt(v.Position, armCurve:Get(0.05)) * CFrame.Angles(math.rad(90), 0, 0)

									barrageArms.Parent = barrageSubject

									tweenConnections[currConnection] = game["Run Service"].RenderStepped:Connect(function()

										--// Disconnecting \\--

										if bezierProgress >= 1 or v.Parent == nil then
											tweenConnections[currConnection]:Disconnect()
										end

										--// Adding progress \\--

										bezierProgress += 0.125

										--// Arm Effects \\--

										if bezierProgress >= 0.25 and armMadeSound == false then

											armMadeSound = true

											createSoundEffect(
												subjectHRP,
												v:FindFirstChild("Swing").SoundId,
												0.3,
												1
											)

										end

										if bezierProgress >= 0.85 and armCreatedShockwave == false then

											armCreatedShockwave = true							

										end

										if bezierProgress >= 0.6 and armDissappeared == false then

											armDissappeared = true

											TS:Create(v, TweenInfo.new(0.175, Enum.EasingStyle.Sine),{
												Transparency = 1
											}):Play()

											--// Tweening trails \\--

											for i, trail in pairs(v:GetDescendants()) do
												if trail:IsA("Trail") then

													local tween = coroutine.wrap(function()

														local frames = 3

														local currValue = 0.5
														local endValue = 1

														local range = endValue - currValue

														for i = 1, frames do

															trail.Transparency = NumberSequence.new(currValue, 1)
															currValue += (range / frames)

															game:GetService("RunService").RenderStepped:Wait()

														end

													end)

													tween()

												end
											end

										end

										--// Positioning arm \\--

										if bezierProgress <= 1 then

											local offset = 25

											if v.Name == "Left Arm" then
												offset = 25
											end

											v.Position = armCurve:Get(bezierProgress)
											v.CFrame = CFrame.lookAt(v.Position, armCurve:Get(bezierProgress + 0.05)) * CFrame.Angles(math.rad(90), 0, math.rad(offset))

										else
											v.Transparency = 1

										end

										--// Disconnecting \\--

										if bezierProgress >= 1 or v.Parent == nil then
											tweenConnections[currConnection]:Disconnect()
										end

									end)

								end)

								tweenArm()

							end
						end

						debrisManager:Add(barrageArms, 0.35) -- Changed this line

					end

				end)

				create()

			end

		end)

	end)

	createEffect()

end

--// Returning \\--

return effectCreator
