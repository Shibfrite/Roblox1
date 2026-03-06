local Collector = {}
Collector.__index = Collector

--[[
--Instantiation of the component.
--]]
function Collector.new(tycoon, sourcePart)
  local self = setmetatable({}, Collector)
  self.Tycoon = tycoon
  self.SourcePart = sourcePart
  return self
end

--[[
--Initialisation of the component.
--]]
function Collector:Init()
  self.SourcePart.Collider.Touched:Connect(function(...)
    self:OnTouched(...)
  end)
end

--[[
--Once a drop touches the collector it's capital is transmitted into the bank
--]]
function Collector:OnTouched(hitPart)
  local value = hitPart:GetAttribute("Value")
  if value then
    self.Tycoon:PublishTopic("CapitalChange", value)
    hitPart:Destroy()
  end
end

return Collector
