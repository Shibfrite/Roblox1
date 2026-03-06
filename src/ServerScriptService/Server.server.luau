local Tycoon = require(script.Parent.Tycoon)
local PlayerManager = require(script.Parent.PlayerManager)

--[
--Spawns tycoons on predefined spawn points
--]
local function FindSpawn()
  for _, spawnPoint in ipairs(workspace.Spawns:GetChildren()) do
    if not spawnPoint:GetAttribute("Occupied") then
      return spawnPoint
    end
  end
  return --error
end

PlayerManager.Start()

--[[
--Construction of a tycoon on player connection.
--]]
PlayerManager.PlayerAdded:Connect(function(player)
  local tycoon = Tycoon.new(player, FindSpawn())
  tycoon:Init()
end)
