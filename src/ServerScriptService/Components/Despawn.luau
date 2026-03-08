local Despawn = {}
Despawn.__index = Despawn

--Instantiation of the component.
function Despawn.new(tycoon, sourceInstance)
  local self = setmetatable({}, Despawn)
  self.Tycoon = tycoon
  self.SourceInstance = sourceInstance
  return self
end

--Initialisation of the component.
--Destroys the instance
function Despawn:Init()
	self.Tycoon:SubscribeTopic("Button", function(id)
		if id == self.SourceInstance:GetAttribute("Id") then
			self.SourceInstance:Destroy()
		end
	end)
end

return Despawn
