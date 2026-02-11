--[[
--File managing the tycoons
--]]

--Would be nice to get ride of this line, if it's used only once it shouldn't be global
local tycoonTemplate = game:GetService("ServerStorage").tycoonTemplate
local CollectionService = game:GetService("CollectionService")
local componentFolder = script.Parent.Components

--[[
--Uses the template of a model to create a copy of it
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
function Tycoon.new(player)
  local self = setmetatable({}, Tycoon)
  self.Owner = player

  return self
end

--[[
--Initialisation of a Tycoon.
--]]
function Tycoon:Init()
  self.Model = NewModel(tycoonTemplate, CFrame.new(0, 1, 0))

  self:AddComponents(self.Model.Part)
end

--[[
--Creates each component from an instance that has a corresponding tag.
--]]
function Tycoon:AddComponents(taggedInstance)
  for _, tag in ipairs(CollectionService:GetTags(taggedInstance)) do
    local component = componentFolder:FindFirstChild(tag)
    if component then
      self:CreateComponent(taggedInstance, component)
    end
  end
end

--[[
--Instantiate and initialise a component through it's script.
--]]
function Tycoon:CreateComponent(sourceInstance, componentScript)
  local compModule = require(componentScript)
  local newComp = compModule.new(self, sourceInstance)
  newComp:Init()
end

--Destroyes a Tycoon gracefully.
function Tycoon:Destroy()
  self.Model:Destroy()
end

return Tycoon
