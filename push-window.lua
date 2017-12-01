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
  -- 0.66:
  -- Means github.com with repo tree view extension fits perfectly.
  -- Also, it allows you to see IntelliJ with slim project tool window open and 80 char editor width.
  -- Only slightly cuts into it.

  local width = 0.66
  local g = hs.geometry.unitrect(1-width,0,width,1)
  hs.window.focusedWindow():moveToUnit(g)
end

return exports
