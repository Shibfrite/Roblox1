--[[
--File responsible for managing unlockable components
--]]
local Players = game:GetService("Players")

--[[
--Instantiates the Leaderboard.
--It shows each player's money.
--]]
local function LeaderboardSetup()
  local leaderstats = Instance.new("Folder")
  leaderstats.Name = "leaderstats"

  local money = Instance.new("IntValue")
  money.Name = "Money"
  money.Value = 0
  money.Parent = leaderstats
  return leaderstats
end

local PlayerManager = {}
PlayerManager.__index = PlayerManager 

--[[
--Triggers OnPlayerAdded when a player connects
--]]
function PlayerManager.Start()
  Players.PlayerAdded:Connect(PlayerManager.OnPlayerAdded)
end

--[[
--Creates a leaderstat folder for a player
--]]
function PlayerManager.OnPlayerAdded(player)
  local leaderstats = LeaderboardSetup()
  leaderstats.Parent = player
end

--[[
--Gets how much money a player has
--]]
function PlayerManager.GetMoney(player)
  local leaderstats = player:FindFirstChild("leaderstats")
  if leaderstats then
    local money = leaderstats:FindFirstChild("Money")
    if money then
      return money.Value
    end
  end
  return 0
end

--[[
--Sets how much money a player has
--]]
function PlayerManager.SetMoney(player, value)
  if value then
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
      local money = leaderstats:FindFirstChild("Money")
      if money then
        money.Value = value
      end
    end
  end
end

--Not currently used
--[[
--Instantiation of the component.
--]]
function PlayerManager.new(tycoon, sourcePart)
  local self = setmetatable({}, PlayerManager)
  self.Tycoon = tycoon
  self.SourcePart = sourcePart
  return self
end

--[[
--Creates the proximity prompt and connects its trigger to Press
--]]
function PlayerManager:Init()
  self.Prompt = self:CreatePrompt()
  self.Prompt.Triggered:Connect(function(...)
    self:Press(...)
  end)
end

return PlayerManager
