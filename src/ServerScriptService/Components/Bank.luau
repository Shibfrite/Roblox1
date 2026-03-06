local PlayerManager = require(script.Parent.Parent.PlayerManager)
local Bank = {}
Bank.__index = Bank

--[[
--Instantiation of the component.
--]]
function Bank.new(tycoon, sourcePart)
  local self = setmetatable({}, Bank)
  self.Tycoon = tycoon
  self.SourcePart = sourcePart
  self.Balance = 0
  return self
end

--[[
--Initialisation of the component.
--1. Receives money from the collector after a drop got collected
--2. Gets the capital from the bank to the owner when he steps on the pad
--]]
function Bank:Init()
  self.Tycoon:SubscribeTopic("CapitalChange", function(...)
    self:OnCapitalChange(...)
  end)
  self.SourcePart.Pad.Touched:Connect(function(...)
    self:OnTouched(...)
  end)
end

--[[
--Adjusts the bank's balance and displays it
--]]
function Bank:OnCapitalChange(capital)
  self.Balance += capital
  self:SetDisplay("$" .. self.Balance)
end

--[[
--Adjusts the bank's display
--]]
function Bank:SetDisplay(textToDisplay)
  self.SourcePart.Display.Capital.Text = textToDisplay
end

--[[
--Transfers the money from the bank to the owner
--]]
function Bank:OnTouched(hitPart)
  local character = hitPart:FindFirstAncestorWhichIsA("Model")
  if character then
    local player = game:GetService("Players"):GetPlayerFromCharacter(character)
    if player and player == self.Tycoon.Owner then
      local playerCapital = PlayerManager.GetCapital(player) + self.Balance
      PlayerManager.SetCapital(player, playerCapital)
      self.Balance = 0
      self:SetDisplay("$0")
    end
  end
end

return Bank
