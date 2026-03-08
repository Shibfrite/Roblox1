local Unlockable = {}
Unlockable.__index = Unlockable

--[[
--Instantiation of the component.
--]]
function Unlockable.new(tycoon, sourceInstance)
  local self = setmetatable({}, Unlockable)
  self.Tycoon = tycoon
  self.SourceInstance = sourceInstance
  return self
end

--[[
--Initialisation of the component.
--Listens for the button event and executes ButtonPress to unlock itself.
--]]
function Unlockable:Init()
  self.Subscribtion = self.Tycoon:SubscribeTopic("Button", function(...)
    self:ButtonPress(...)
  end)
end

--[[
--Unlocks the instance and stop listening for events if the instance is unlockable
--]]
function Unlockable:ButtonPress(id)
  if id == self.SourceInstance:GetAttribute("UnlockId") then
    self.Tycoon:Unlock(self.SourceInstance, id)
    self.Subscribtion:Disconnect()
  end
end

return Unlockable
