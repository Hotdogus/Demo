local Bezier = {}
Bezier.__index = Bezier


function Bezier.new(...)
	
	local points = {...}
	assert(#points >= 3, "Must have at least 3 points")
	
	local isQuadratic = (#points == 3)
	local isCubic = (#points == 4)
	
	local bezier = {}
	
	local V3 = Vector3.new
	local lerpV3 = V3().lerp
	
	local length = nil
	
	local lines = {}
	local numLines = 0
	local finalLine = nil
		-- Line index key:
			-- [1] = First point
			-- [2] = Second point
			-- [3] = Current Midpoint
	
	
	-- Create mutable pseudo-Vector3 points:
	local function CreatePoint(v3)
		--local point = {X = v3.X; Y = v3.Y; Z = v3.Z}
		local point = {v3.X, v3.Y, v3.Z}
		function point:ToVector3()
			return V3(self[1], self[2], self[3])
		end
		function point:lerp(other, ratio)
			return lerpV3(self:ToVector3(), other:ToVector3(), ratio)
		end
		return point
	end
	
	
	-- Initialize lines:
	if (not isQuadratic and not isCubic) then
	
		-- Initialize first lines:
		for i = 1,#points-1 do
			local p1 = CreatePoint(points[i])
			local p2 = CreatePoint(points[i + 1])
			local line = {p1, p2, CreatePoint(p1)}
			lines[#lines + 1] = line
		end
		
		local relativeLines = lines
		
		-- Initialize rest of lines:
		for n = #lines,2,-1 do
			local newLines = {}
			for i = 1,n-1 do
				local l1, l2 = relativeLines[i], relativeLines[i + 1]
				local line = {l1[3], l2[3], CreatePoint(l1[3])}
				newLines[i] = line
				lines[#lines + 1] = line
			end
			relativeLines = newLines
		end
		
		finalLine = relativeLines[1]
		
		numLines = #lines
		
	end
	
	
	-- Get a point on the curve with the given ratio:
	if (isQuadratic) then
		
		local p0, p1, p2 = points[1], points[2], points[3]
		
		-- Quadratic solution:
		function bezier:Get(r, clampRatio)
			if (clampRatio) then
				r = (r < 0 and 0 or r > 1 and 1 or r)
			end
			return (1-r)*(1-r)*p0+2*(1-r)*r*p1+r*r*p2
		end
	
	elseif (isCubic) then
		
		local p0, p1, p2, p3 = points[1], points[2], points[3], points[4]
		
		-- Cubic solution:
		function bezier:Get(r, clampRatio)
			if (clampRatio) then
				r = (r < 0 and 0 or r > 1 and 1 or r)
			end
			return (1-r)*(1-r)*(1-r)*p0+3*(1-r)*(1-r)*r*p1+3*(1-r)*r*r*p2+r*r*r*p3
		end
	
	else
		
		function bezier:Get(ratio, clampRatio)
			if (clampRatio) then
				ratio = (ratio < 0 and 0 or ratio > 1 and 1 or ratio)
			end
			-- Any degree solution:
			for i = 1,numLines do
				local line = lines[i]
				local mid = line[1]:lerp(line[2], ratio)
				local pt = line[3]
				pt[1], pt[2], pt[3] = mid.X, mid.Y, mid.Z
			end
			return finalLine[3]:ToVector3()
		end
	
	end
	
	
	-- Approximated length:
	function bezier:GetLength(step)
		if (not length) then
			local path = self:GetPath(step or 0.1)
			local l = 0
			for i = 2,#path do
				local dist = (path[i - 1] - path[i]).Magnitude
				l = (l + dist)
			end
			length = l
		end
		return length
	end
	
	
	-- Get a path of the curve with the given step:
	-- Returns a table of Vector3 points
	function bezier:GetPath(step)
		assert(type(step) == "number", "Must provide a step increment")
		-- Check step domain is within interval (0.0, 1.0):
		assert(step > 0 and step < 1, "Step out of domain; should be between 0 and 1 (exclusive)")
		local path = {}
		local lastI = 0
		for i = 0,1,step do
			lastI = i
			path[#path + 1] = self:Get(i)
		end
		-- In case 'step' didn't fill path fully, properly handle last remaining point:
		if (lastI < 1) then
			local overrideLast = ((1 - lastI) < (step * 0.5))
			path[#path + (overrideLast and 0 or 1)] = self:Get(1)
		end
		return path
	end
	
	
	function bezier:GetPathByNumberSegments(numSegments)
		assert(type(numSegments) == "number", "Must provide number of segments")
		assert(numSegments > 0, "Number of segments must be greater than 0")
		return self:GetPath(1 / numSegments)
	end
	
	
	function bezier:GetPathBySegmentLength(segmentLength)
		assert(type(segmentLength) == "number", "Must provide a segment length")
		assert(segmentLength > 0, "Segment length must be greater than 0")
		local length = self:GetLength()
		local numSegments = length / segmentLength
		return self:GetPathByNumberSegments(math.floor(numSegments + 0.5))
	end
	
	
	-- Get the control points (the original Vector3 arguments passed to create the object)
	function bezier:GetPoints()
		return points
	end
	
	
	return setmetatable(bezier, Bezier)
	
end



return Bezier