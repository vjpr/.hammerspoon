-- Push window left or right
------------------------------------------------------------------------------

local exports = {}

exports.pushLeft = function()
  hs.window.focusedWindow():moveToUnit(hs.layout.left50)
end

exports.pushRight = function()
  hs.window.focusedWindow():moveToUnit(hs.layout.right50)
end

exports.twoThirdsLeft = function()
  local g = hs.geometry.unitrect(0,0,0.6,1)
  hs.window.focusedWindow():moveToUnit(g)
end

exports.twoThirdsRight = function()
  local g = hs.geometry.unitrect(0.4,0,0.6,1)
  hs.window.focusedWindow():moveToUnit(g)
end

return exports
