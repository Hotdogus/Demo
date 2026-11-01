local effectHandler = {}

function effectHandler.performEffect(effectName, Parameters)
	if script:FindFirstChild(effectName) and Parameters ~= nil then
		
		local requiredModule = require(script:FindFirstChild(effectName))
		requiredModule.Create(Parameters)
		
	end
end

return effectHandler
