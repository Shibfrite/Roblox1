local Conveyor = {}
Conveyor.__index = Conveyor

--[[
--Instantiation of the component.
--]]
function Conveyor.new(tycoon, sourcePart)
  local self = setmetatable({}, Conveyor)
  self.SourcePart = sourcePart
  self.Speed = sourcePart:GetAttribute("Speed")
  return self
end

--[[
--Initialisation of the component.
--Makes parts move along the belt.
--]]
function Conveyor:Init()
  local belt = self.SourcePart.Belt
  belt.AssemblyLinearVelocity = belt.CFrame.LookVector * self.Speed
end

return Conveyor
