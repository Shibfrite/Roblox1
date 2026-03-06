--[[
--File responsible for managing buttons
--]]

local PlayerManager = require(script.Parent.Parent.PlayerManager)
local Button = {}

--[[
--Instantiation of the component.
--]]
function Button.new(tycoon, sourcePart)
  local self = {}
  self.Tycoon = tycoon
  self.SourcePart = sourcePart
  return self
end

--[[
--]]
function Button:Init()
  self.Prompt = self:CreatePrompt()
  self.Prompt.Triggered:Connect(function(...)
    self:Press(...)
  end)
end

--[[
--
--]]
function Button:CreatePrompt()
  local prompt = Instance.new("ProximityPrompt")
  prompt.HoldDuration = 0.5
  prompt.ActionText = self.SourcePart:GetAttribute("Display")
  prompt.ObjectText = self.SourcePart:GetAttribute("Cost") .. "$"

  prompt.Parent = self.SourcePart
  return prompt
end

function Button:Press(player)
  local id = self.SourcePart:GetAttribute("Id")
  local cost = self.SourcePart:GetAttribute("Cost")
  local money = PlayerManager.GetMoney(player)
  if player == self.Tycoon.Owner and money >= cost then
    PlayerManager.SetMoney(player, money - cost)
    self.Tycoon:PublishTopic("Button", id)
    self.SourcePart:Destroy()
  end
end

return Button
