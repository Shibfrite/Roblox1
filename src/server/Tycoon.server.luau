local Tycoon = {}
Tycoon.__index = Tycoon

function Tycoon.new(player)
  local self = setmetatable({}, Tycoon)
  self.Owner = player

  return self
end

function Tycoon:Init()
  print("tycoon initialised")
end

function Tycoon:Destroy()

end

return Tycoon
