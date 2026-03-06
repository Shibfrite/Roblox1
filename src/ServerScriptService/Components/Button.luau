local PlayerManager = require(script.Parent.Parent.PlayerManager)
local Button = {}
Button.__index = Button

--[[
--Instantiation of the component.
--]]
function Button.new(tycoon, sourcePart)
  local self = setmetatable({}, Button)
  self.Tycoon = tycoon
  self.SourcePart = sourcePart
  return self
end

--[[
--Initialisation of the component.
--Creates an interactible prompt on the button and makes it pressable.
--]]
function Button:Init()
  self.Prompt = self:CreatePrompt()
  self.Prompt.Triggered:Connect(function(...)
    self:Press(...)
  end)
end

--[[
--Creates a proximity prompt.
--]]
function Button:CreatePrompt()
  local prompt = Instance.new("ProximityPrompt")
  prompt.HoldDuration = 0.5
  prompt.ActionText = self.SourcePart:GetAttribute("Display")
  prompt.ObjectText = "$" .. self.SourcePart:GetAttribute("Cost")

  prompt.Parent = self.SourcePart
  return prompt
end

--[[
--Unlocks associated unlockable if the owner's capital is sufficient.
--And self-destructs.
--]]
function Button:Press(player)
  local id = self.SourcePart:GetAttribute("Id")
  local cost = self.SourcePart:GetAttribute("Cost")
  local money = PlayerManager.GetCapital(player)
  if player == self.Tycoon.Owner and money >= cost then
    PlayerManager.SetCapital(player, money - cost)
    self.Tycoon:PublishTopic("Button", id)
    self.SourcePart:Destroy()
  end
end

return Button
