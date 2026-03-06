--Would be nice to get ride of this line, if it's used only once it shouldn't be global
local tycoonTemplate = game:GetService("ServerStorage").tycoonTemplate
local tycoonStorage = game:GetService("ServerStorage").tycoonStorage
local CollectionService = game:GetService("CollectionService")
local componentFolder = script.Parent.Components
local PlayerManager = require(script.Parent.PlayerManager)
local playerManager = require(script.Parent.PlayerManager)

--[[
--Uses the template of a model to construct a copy of it
--]]
local function NewModel(modelTemplate, cframeOfTemplate)
  local newModel = modelTemplate:Clone()
  newModel:SetPrimaryPartCFrame(cframeOfTemplate)
  newModel.Parent = workspace
  return newModel
end

local Tycoon = {}
Tycoon.__index = Tycoon

--[[
--Instantiation of a Tycoon.
--]]
function Tycoon.new(player, spawnPoint)
  local self = setmetatable({}, Tycoon)
  self.Owner = player

  self._topicEvent = Instance.new("BindableEvent")
  self._spawn = spawnPoint
  return self
end

--[[
--Initialisation of a Tycoon.
--Creates a Tycoon at a spawn point, making it the Owner's spawnCreates a Tycoon at a spawn point, making it the Owner's spawn.
--]]
function Tycoon:Init()
  self.Model = NewModel(tycoonTemplate, self._spawn.CFrame)
  self._spawn:SetAttribute("Occupied", true)
  self.Owner.RespawnLocation = self.Model.Spawn
  self.Owner:LoadCharacter()

  self:SetupComponents()
  self:WaitForExit()
end

--[[
--Locks every component with the Unlockable tag and adds the rest to the tycoon.
--]]
function Tycoon:SetupComponents()
  for _, instance in ipairs(self.Model:GetDescendants()) do
    if CollectionService:HasTag(instance, "Unlockable") then
      self:Lock(instance)
    else
      self:AddComponents(instance)
    end
  end
end

--[[
--constructs and locks a component within tycoonStorage
--]]
function Tycoon:Lock(instance)
  instance.Parent = tycoonStorage
  self:constructComponent(instance, componentFolder.Unlockable)
end

--[[
--Gets a component from the storage to the tycoon, unlocking it.
--]]
function Tycoon:Unlock(instance, id)
  CollectionService:RemoveTag(instance, "Unlockable")
  self:AddComponents(instance)
  instance.Parent = self.Model
end

--[[
--constructs each component from an instance that has a corresponding tag.
--]]
function Tycoon:AddComponents(taggedInstance)
  for _, tag in ipairs(CollectionService:GetTags(taggedInstance)) do
    local component = componentFolder:FindFirstChild(tag)
    if component then
      self:constructComponent(taggedInstance, component)
    end
  end
end

--[[
--Sends a signal with a specific topicName.
--]]
function Tycoon:PublishTopic(topicName, ...)
  self._topicEvent:Fire(topicName, ...)
end

--[[
--Catches a signal with a specifc topicName and executes the given callback function.
--]]
function Tycoon:SubscribeTopic(topicName, callback)
  local connection = self._topicEvent.Event:Connect(function(name, ...)
    if name == topicName then
      callback(...)
    end
  end)
  return connection
end

--[[
--Instantiate and initialise a component through it's script.
--]]
function Tycoon:constructComponent(sourceInstance, componentScript)
  local compModule = require(componentScript)
  local newComp = compModule.new(self, sourceInstance)
  newComp:Init()
end

--[
--Destroy Tycoon once owner leaves
--]
function Tycoon:WaitForExit()
  PlayerManager.PlayerRemoving:Connect(function(player)
    if self.Owner == player then
      self:Destroy()
    end
  end)
end

--Destroyes a Tycoon gracefully.
function Tycoon:Destroy()
  self.Model:Destroy()
  self._topicEvent:Destroy()
  self._spawn:SetAttribute("Occupied", false)
end

return Tycoon
