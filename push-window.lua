-- Push window left or right
------------------------------------------------------------------------------

local exports = {}

function push(left, div)

  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local screenFrame = screen:frame()

  -- Move to closest third.

  local oneThirdPixelWidth = screenFrame.w / div
  local windowOffsetFromScreenX = f.x - screenFrame.x
  local snapNumber
  if left then
    snapNumber = math.floor(windowOffsetFromScreenX / oneThirdPixelWidth)
  else
    snapNumber = math.ceil(windowOffsetFromScreenX / oneThirdPixelWidth) + 1
    snapNumber = math.min(snapNumber, div - 1)
  end
  print(snapNumber)
  local targetX = snapNumber / div
  local g = hs.geometry.unitrect(targetX, 0, 1 / div, 1)
  hs.window.focusedWindow():moveToUnit(g)

end

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

local oneThirdWidth = 0.333
exports.oneThirdLeft = function()
  local g = hs.geometry.unitrect(0, 0, oneThirdWidth, 1)
  hs.window.focusedWindow():moveToUnit(g)
end

exports.oneThirdMiddle = function()
  local g = hs.geometry.unitrect(oneThirdWidth * 1, 0, oneThirdWidth, 1)
  hs.window.focusedWindow():moveToUnit(g)
end

exports.oneThirdRight = function()
  local g = hs.geometry.unitrect(oneThirdWidth * 2, 0, oneThirdWidth, 1)
  hs.window.focusedWindow():moveToUnit(g)
end

exports.pushOneThirdLeft = function()
  push(true, 3)
end

exports.pushOneThirdRight = function()
  push(false, 3)
end

return exports
