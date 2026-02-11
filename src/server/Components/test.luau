--[[
--File responsible for managing a component
--]]
local Test = {}
Test.__index = Test

--[[
--Instantiation of the component.
--]]
function Test.new(tycoon, sourceInstance)
  local self = setmetatable({}, Test)
  self.Tycoon = tycoon
  self.SourceInstance = sourceInstance
  return self
end

--[[
--Initialisation of the component.
--]]
function Test:Init()
  print "Test initilalised"
end

return Test
