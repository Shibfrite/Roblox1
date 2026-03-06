local Players = game:GetService("Players")

--[[
--Instantiates the Leaderboard.
--Shows each player's money.
--]]
local function LeaderboardSetup()
  local leaderstats = Instance.new("Folder")
  leaderstats.Name = "leaderstats"

  local money = Instance.new("IntValue")
  money.Name = "Capital"
  money.Value = 0
  money.Parent = leaderstats
  return leaderstats
end

local PlayerManager = {}

--Makes an event for when players are added to a Tycoon
local playerAdded = Instance.new("BindableEvent")
PlayerManager.PlayerAdded = playerAdded.Event

--Makes an event for when players are removed to a Tycoon
local playerRemoving = Instance.new("BindableEvent")
PlayerManager.PlayerRemoving = playerRemoving.Event

--[[
--Creates a thread for new players
--Connects Player added and Player remove events
--]]
function PlayerManager.Start()
  for _, player in ipairs(Players:GetPlayers()) do
    coroutine.wrap(PlayerManager.OnPlayerAdded)(player)
  end
  Players.PlayerAdded:Connect(PlayerManager.OnPlayerAdded)
  Players.PlayerRemoving:Connect(PlayerManager.OnPlayerRemoving)
end

--[[
--Creates a leaderstat folder for a player and fires an event
--]]
function PlayerManager.OnPlayerAdded(player)
  player.CharacterAdded:Connect(function(character)
    PlayerManager.OnCharacterAdded(player, character)
  end)
  local leaderstats = LeaderboardSetup()
  leaderstats.Parent = player

  playerAdded:Fire(player)
end

--[
--When player dies, respawn him
--]
function PlayerManager.OnCharacterAdded(player, character)
  local humanoid = character:FindFirstChild("Humanoid")
  if humanoid then
    humanoid.Died:Connect(function()
      task.wait(1.5)
      player:LoadCharacter()
    end)
  end
end

--[[
--Returns a player's capital
--]]
function PlayerManager.GetCapital(player)
  local leaderstats = player:FindFirstChild("leaderstats")
  if leaderstats then
    local money = leaderstats:FindFirstChild("Capital")
    if money then
      return money.Value
    end
  end
  return 0
end

--[[
--Displays the capital of a player on the leaderboard
--]]
function PlayerManager.SetCapital(player, value)
  if value then
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
      local money = leaderstats:FindFirstChild("Capital")
      if money then
        money.Value = value
      end
    end
  end
end

--[
--Fires an event
--]
function PlayerManager.OnPlayerRemoving(player)
  playerRemoving:Fire(player)
end

--Not currently used
--[[
--[
--Instantiation of the component.
--]
function PlayerManager.new(tycoon, sourcePart)
  local self = setmetatable({}, PlayerManager)
  self.Tycoon = tycoon
  self.SourcePart = sourcePart
  return self
end

--[
--Creates the proximity prompt and connects its trigger to Press
--]
function PlayerManager:Init()
  self.Prompt = self:CreatePrompt()
  self.Prompt.Triggered:Connect(function(...)
    self:Press(...)
  end)
end
--]]

return PlayerManager
