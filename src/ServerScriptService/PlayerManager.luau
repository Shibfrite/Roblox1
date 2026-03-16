local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local PlayerData = DataStoreService:GetDataStore("PlayerData")

--Creates a player's leaderStats folder containing his capital
local function LeaderboardSetup(value)
  local leaderstats = Instance.new("Folder")
  leaderstats.Name = "leaderstats"

  local money = Instance.new("IntValue")
  money.Name = "Capital"
  money.Value = value
  money.Parent = leaderstats
  return leaderstats
end

--Loads the player's data
local function LoadData(player)
  local success, result = pcall(function()
    return PlayerData:GetAsync(player.UserId)
  end)
  if not success then
    warn(result)
  end
  return success, result
end

--Saves the player's data
local function SaveData(player, data)
  local success, result = pcall(function()
    PlayerData:SetAsync(player.UserId, data)
  end)
  if not success then
    warn(result)
  end
  return success
end

--Contains player events
local PlayerManager = {}

--Contains capital and unlocked objects of a player.
local sessionData = {}

--Creates an event for joining players
local playerAdded = Instance.new("BindableEvent")
PlayerManager.PlayerAdded = playerAdded.Event

--Creates an event for leaving players
local playerRemoving = Instance.new("BindableEvent")
PlayerManager.PlayerRemoving = playerRemoving.Event


--Creates a thread for new players
--Connects PlayerAdded and PlayerRemove
--Binds session end to OnClose
function PlayerManager.Start()
  for _, player in ipairs(Players:GetPlayers()) do
    coroutine.wrap(PlayerManager.OnPlayerAdded)(player)
  end
  Players.PlayerAdded:Connect(PlayerManager.OnPlayerAdded)
  Players.PlayerRemoving:Connect(PlayerManager.OnPlayerRemoving)

  game:BindToClose(PlayerManager.OnClose)
end


--Connects character events
--Loads or initializes session data
--Sets up leaderboard
--Fires playerAdded
function PlayerManager.OnPlayerAdded(player)
  player.CharacterAdded:Connect(function(character)
    PlayerManager.OnCharacterAdded(player, character)
  end)
  local success, data = LoadData(player)
  sessionData[player.UserId] = success and data or {
    Capital = 0,
    UnlockIds = {}
  }

  local leaderstats = LeaderboardSetup(PlayerManager.GetCapital(player))
  leaderstats.Parent = player

  playerAdded:Fire(player)
end


--Respawn dead players
function PlayerManager.OnCharacterAdded(player, character)
  local humanoid = character:FindFirstChild("Humanoid")
  if humanoid then
    humanoid.Died:Connect(function()
      task.wait(1.5)
      player:LoadCharacter()
    end)
  end
end


--Gets a player's capital
function PlayerManager.GetCapital(player)
  return sessionData[player.UserId].Capital
end


--Displays the capital of a player on the leaderboard
function PlayerManager.SetCapital(player, value)
  if value then
    sessionData[player.UserId].Capital = value
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
      local money = leaderstats:FindFirstChild("Capital")
      if money then
        money.Value = value
      end
    end
  end
end

--Adds the id of an unlocked model to the player's data
function PlayerManager.AddUnlockId(player, id)
  local data = sessionData[player.UserId]
  if not table.find(data.UnlockIds, id) then
    table.insert(data.UnlockIds, id)
  end
end

--Gets all unlocked models of a player
function PlayerManager.GetUnlockIds(player)
	return sessionData[player.UserId].UnlockIds
end

--Saves the player's data
--Fires playerRemoving
function PlayerManager.OnPlayerRemoving(player)
  SaveData(player, sessionData[player.UserId])
  playerRemoving:Fire(player)
end

--Removes all players gracefully
function PlayerManager.OnClose()
  --if game:GetService("RunService"):IsStudio() then return end
  for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(PlayerManager.OnPlayerRemoving, player)
  end
end

--Not currently used
--[[
--Instantiation of the component.
function PlayerManager.new(tycoon, sourcePart)
  local self = setmetatable({}, PlayerManager)
  self.Tycoon = tycoon
  self.SourcePart = sourcePart
  return self
end

--Creates the proximity prompt and connects its trigger to Press
function PlayerManager:Init()
  self.Prompt = self:CreatePrompt()
  self.Prompt.Triggered:Connect(function(...)
    self:Press(...)
  end)
end
--]]

return PlayerManager
