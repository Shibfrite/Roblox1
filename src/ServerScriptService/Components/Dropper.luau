local dropsFolder = game:GetService("ServerStorage").Drops
local Debris = game:GetService("Debris")

local Dropper = {}
Dropper.__index = Dropper

--[[
--Instantiation of the component.
--]]
function Dropper.new(tycoon, sourcePart)
  local self = setmetatable({}, Dropper)
  self.Tycoon = tycoon
  self.SourcePart = sourcePart
  self.Rate = sourcePart:GetAttribute("Rate")
  self.DropTemplate = dropsFolder[sourcePart:GetAttribute("Drop")]
  self.DropSpawn = sourcePart.Spout.Spawn
  return self
end

--[[
--Initialisation of the component.
--]]
function Dropper:Init()
  coroutine.wrap(function()
    while self.SourcePart.Parent do
      self:Drop()
      task.wait(self.Rate)
    end
  end)()
end

--[[
--Makes the dropper spawn drops
--]]
function Dropper:Drop()
  local drop = self.DropTemplate:Clone()
  drop.Position = self.DropSpawn.WorldPosition
  drop.Parent = self.SourcePart

  local life_time = 10
  Debris:AddItem(drop, life_time)
end

return Dropper
