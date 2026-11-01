local BloodRays = {}

local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local Random = Random.new()

local Params = RaycastParams.new()
Params.FilterType = Enum.RaycastFilterType.Exclude
Params.FilterDescendantsInstances = {workspace.Alive, workspace.Ignore}

local function InvRandom(a)
	return Random:NextNumber(-a, a)
end

local function QuadBezier(Time : number, Start : CFrame, Middle : CFrame, End : CFrame) 
	local Difference = (1 - Time)
	
	return Difference ^ 2 * Start + 2 * Difference * Time * Middle + Time ^ 2 * End
end

function BloodRays.CreateRays(Origin: a, Distance : (Vector2), Amount : (Vector2), CurveSegments : number)	
	local MinDistance = Distance.X
	local MaxDistance = Distance.Y
	
	local StartPosition = Origin.Position

	for AmountIndex = 1, math.random(Amount.X, Amount.Y) do
		local StartCFrame = CFrame.new(StartPosition, StartPosition + Vector3.new(InvRandom(MinDistance), 0, InvRandom(MaxDistance)))
		
		local Result = workspace:Raycast((StartCFrame * CFrame.new(0, 0, -Random:NextNumber(MinDistance, MaxDistance))).Position, Vector3.new(0, -150, 0), Params)

		if Result ~= nil then
			local EndPosition = Result.Position

			local MidLerp = Origin.Position:Lerp(EndPosition, 0.75)
			local MiddlePosition = Vector3.new(MidLerp.X, StartPosition.Y + math.clamp((StartPosition - MidLerp).Magnitude, 1.5, 7.5) , MidLerp.Z)

			local TweenDuration = 0.1 / (CurveSegments / 2.5)

			local Blood = script.Blood:Clone()
			Blood.Position = StartPosition
			Blood.Parent = workspace.Ignore

			coroutine.resume(coroutine.create(function()
				for WaypointIndex = 1, CurveSegments do
					local OldPosition = Blood.Position
					local NewPosition = QuadBezier(WaypointIndex / CurveSegments, StartPosition, MiddlePosition, EndPosition)

					local VectorDifference = (NewPosition - Blood.Position)

					TweenService:Create(Blood, TweenInfo.new(TweenDuration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = NewPosition}):Play()

					task.wait(TweenDuration)

					Result = workspace:Raycast(OldPosition, VectorDifference.Unit * (VectorDifference.Magnitude + 0.4), Params)

					if Result then
						local Splatter = script.Splatter:Clone()
						Splatter.CFrame = CFrame.new(Result.Position, Result.Position + Result.Normal) * CFrame.Angles(0, 0, math.rad(Random:NextNumber(0, 180)))
						Splatter.Size *= Random:NextNumber(0.75, 1.25)
						Splatter.Parent = workspace.Ignore

						if Splatter:FindFirstChild("Impact") then
							Splatter.Impact:Play()
						end
						
						task.delay(4, function()
							TweenService:Create(Splatter.Decal, TweenInfo.new(0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1}):Play()
							Debris:AddItem(Splatter, 0.85)
						end)

						break
					end
				end

				Debris:AddItem(Blood, if Blood and Blood:FindFirstChild("Trail") then Blood.Trail.Lifetime else 0.3)
			end))
		end
	end
end

return BloodRays