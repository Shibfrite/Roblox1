--script containing all server runned code

local Tycoon = require(script.Parent.Tycoon)
local PlayerManager = require(script.Parent.PlayerManager)

PlayerManager.Start()
--[[
--Construction of a tycoon on player connection.
--]]
game:GetService("Players").PlayerAdded:Connect(function(player)
  local tycoon = Tycoon.new(player)
  tycoon:Init()
end)
