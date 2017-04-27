require('util')

-- Fix stuck modifiers.
------------------------------------------------------------------------------

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "F", function()
  hs.eventtap.keyStroke({"shift"}, "A")
  hs.alert.show("Fixing modifiers")
end)

-- Universal Layout
------------------------------------------------------------------------------

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "N", function()
  universalLayout()
end)

------------------------------------------------------------------------------

positions = {
  maximized = hs.layout.maximized,
  centered = {x=0.20, y=0.20, w=0.8, h=0.8},
  centeredAlt = {x=0.10, y=0.10, w=0.8, h=0.8},

  left34 = {x=0, y=0, w=0.34, h=1},
  left50 = hs.layout.left50,
  left66 = {x=0, y=0, w=0.66, h=1},

  right34 = {x=0.66, y=0, w=0.34, h=1},
  right50 = hs.layout.right50,
  right66 = {x=0.34, y=0, w=0.66, h=1},

  upper50 = {x=0, y=0, w=1, h=0.5},
  upper50Left50 = {x=0, y=0, w=0.5, h=0.5},
  upper50Right50 = {x=0.5, y=0, w=0.5, h=0.5},

  lower50 = {x=0, y=0.5, w=1, h=0.5},
  lower50Left50 = {x=0, y=0.5, w=0.5, h=0.5},
  lower50Right50 = {x=0.5, y=0.5, w=0.5, h=0.5}
}

titles = {
  intellij = 'IntelliJ IDEA-EAP',
  appCode = 'AppCode-EAP',
  safari = 'Safari',
  eclipse = 'Eclipse',
  chrome = 'Google Chrome',
  atom = 'Atom',
  atomBeta = 'Atom Beta',
  sourceTree = 'SourceTree',
  iterm = 'iTerm2',
  sublime = 'Sublime Text',
  dash = 'Dash',
  hyper = 'Hyper',
  outlook = 'Microsoft Outlook',
  calendar = 'Calendar',
}

commonWindowLayout = {
  {'WhatsApp', nil, laptopScreen, hs.layout.right50, nil, nil},
  {'Messenger', nil, laptopScreen, hs.layout.right50, nil, nil},
  {'Quip', nil, laptopScreen, hs.layout.right50, nil, nil},
  {'Slack', nil, laptopScreen, hs.layout.right50, nil, nil},
  {'Spotify', nil, laptopScreen, positions.centered, nil, nil},
  {'iTunes', nil, laptopScreen, positions.centered, nil, nil},
  {titles.outlook, nil, laptopScreen, positions.centered, nil, nil},
  {titles.calendar, nil, laptopScreen, positions.centered, nil, nil},
}

------------------------------------------------------------------------------

function universalLayout()
  local allScreens = hs.screen.allScreens()
  local screenCount = tableLength(allScreens)
  local windowLayout
  print('Screen count:', screenCount)
  if (screenCount == 4) then
    windowLayout = screenLayoutPrimaryAnd2xU2515HAnd1xLG()
  elseif (screenCount == 3) then
    windowLayout = screenLayoutPrimaryAnd2xU2515H()
  elseif (screenCount == 2) then
    local secondScreen = allScreens[2]
    -- TODO: Check resolution to detect if main monitor or iPad.
    windowLayout = screenLayoutPrimaryAndIPad()
    -- windowLayout = screenLayoutPrimaryAnd1xU2515H()
  elseif (screenCount == 1) then
    windowLayout = screenLayoutPrimary()
  end

  local layout = {}
  tableConcat(layout, commonWindowLayout)
  tableConcat(layout, windowLayout)
  hs.layout.apply(layout)
  
  -- Arrange iTerm windows.
  --------------------

  if (screenCount == 3 or screenCount == 4) then

    local rightScreen = hs.screen.primaryScreen():toEast()

    -- Workaround while waiting for
    -- [`hs.layout.apply` and multiple windows of same application](https://github.com/Hammerspoon/hammerspoon/issues/298)
    local app = hs.application.find("iTerm2")
    local iTermWindows = app:allWindows()
    local gridSize
    
    -- 2x2 grid
    -- local positions = {positions.upper50Left50, positions.upper50Right50, positions.lower50Left50, positions.lower50Right50}
    -- gridSize = 4
    
    -- 1x1 next to each other
    local positionDefs = {positions.left50, positions.right50}
    gridSize = 2
    
    local i = 0
    for i, win in pairs(iTermWindows) do
      -- iterate between 
      -- local position = positionDefs[i % gridSize + 1] -- `+1` because Lua indexes start at 1.
      local position = positions.right50
      -- print(win)
      win:move(position, rightScreen)
    end
  
    -- Main window on left, other windows stacked on right.
    local app = hs.application.find("iTerm2")
    app:mainWindow():move(positions.left50, rightScreen)
  end
  
  --------------------

end

------------------------------------------------------------------------------

function screenLayoutPrimaryAnd2xU2515HAnd1xLG()
  hs.alert.show("screenLayoutPrimaryAnd2xU2515HAnd1xLG layout")
  local laptopScreen = "Color LCD" -- hs.screen.primaryScreen()

  -- local centerScreen = hs.screen.allScreens()[2]
  local centerScreen = hs.screen.primaryScreen():toNorth()
  local rightScreen = hs.screen.primaryScreen():toEast()
  local leftScreen = centerScreen:toWest()

  local chrome1,chrome2 = hs.application.find'Google Chrome'

  local windowLayout = {
    {titles.intellij, nil, laptopScreen, hs.layout.maximized, nil, nil},
    {titles.appCode, nil, laptopScreen, hs.layout.maximized, nil, nil},
    {titles.eclipse, nil, laptopScreen, hs.layout.maximized, nil, nil},
    {chrome1, nil, centerScreen, hs.layout.left50, nil, nil},
    {chrome2, nil, centerScreen, hs.layout.left50, nil, nil},
    {titles.safari, nil, centerScreen, hs.layout.right50, nil, nil},
    {titles.sublime, nil, laptopScreen, positions.centeredAlt, nil, nil},
    {titles.dash, nil, laptopScreen, positions.centeredAlt, nil, nil},
    -- {titles.atom, nil, centerScreen, hs.layout.left50, nil, nil},
    -- {titles.atomBeta, nil, centerScreen, hs.layout.left50, nil, nil},
    {titles.atom, nil, leftScreen, hs.layout.maximized, nil, nil},
    {titles.atomBeta, nil, leftScreen, hs.layout.maximized, nil, nil},
    
    {titles.sourceTree, nil, centerScreen, positions.centered, nil, nil},
    -- TODO: One on each monitor. windowTitleComparator?
    -- {titles.iterm, nil, rightScreen, hs.layout.right50, nil, nil}, -- Done manually.
    {titles.hyper, nil, rightScreen, hs.layout.right50, nil, nil},
  }
  return windowLayout
end

------------------------------------------------------------------------------

function screenLayoutPrimaryAnd2xU2515H()
  hs.alert.show("screensPrimaryAnd2xU2515H layout")
  local laptopScreen = "Color LCD" -- hs.screen.primaryScreen()

  -- local centerScreen = hs.screen.allScreens()[2]
  local centerScreen = hs.screen.primaryScreen():toNorth()
  local rightScreen = hs.screen.primaryScreen():toEast()

  local chrome1,chrome2 = hs.application.find'Google Chrome'

  local windowLayout = {
    {titles.intellij, nil, laptopScreen, hs.layout.maximized, nil, nil},
    {titles.appCode, nil, laptopScreen, hs.layout.maximized, nil, nil},
    {titles.eclipse, nil, laptopScreen, hs.layout.maximized, nil, nil},
    {chrome1, nil, centerScreen, hs.layout.left50, nil, nil},
    {chrome2, nil, centerScreen, hs.layout.left50, nil, nil},
    {titles.safari, nil, centerScreen, hs.layout.right50, nil, nil},
    {titles.sublime, nil, laptopScreen, positions.centeredAlt, nil, nil},
    {titles.dash, nil, laptopScreen, positions.centeredAlt, nil, nil},
    {titles.atom, nil, centerScreen, hs.layout.left50, nil, nil},
    {titles.atomBeta, nil, centerScreen, hs.layout.left50, nil, nil},
    {titles.sourceTree, nil, centerScreen, positions.centered, nil, nil},
    -- TODO: One on each monitor. windowTitleComparator?
    -- {titles.iterm, nil, rightScreen, hs.layout.right50, nil, nil}, -- Done manually.
    {titles.hyper, nil, rightScreen, hs.layout.right50, nil, nil},
  }
  return windowLayout
end

------------------------------------------------------------------------------

function screenLayoutPrimaryAnd1xU2515H()
  hs.alert.show("screensPrimaryAnd2xU2515H layout")
  local laptopScreen = "Color LCD" -- hs.screen.primaryScreen()
  local centerScreen = hs.screen.allScreens()[2]
  local rightScreen = hs.screen.allScreens()[3]
  
  local chrome1,chrome2 = hs.application.find'Google Chrome'

  local windowLayout = {
    {titles.intellij, nil, laptopScreen, hs.layout.maximized, nil, nil},
    {titles.appCode, nil, laptopScreen, hs.layout.maximized, nil, nil},
    {titles.eclipse, nil, laptopScreen, hs.layout.maximized, nil, nil},
    {chrome1, nil, centerScreen, hs.layout.left50, nil, nil},
    {chrome2, nil, centerScreen, hs.layout.left50, nil, nil},
    {titles.safari, nil, centerScreen, hs.layout.right50, nil, nil},
    {titles.sublime, nil, laptopScreen, positions.centered, nil, nil},
    {titles.dash, nil, laptopScreen, positions.centered, nil, nil},
    {titles.atom, nil, centerScreen, hs.layout.left50, nil, nil},
    {titles.atomBeta, nil, centerScreen, hs.layout.left50, nil, nil},
    {titles.sourceTree, nil, centerScreen, positions.centered, nil, nil},
    -- TODO: One on each monitor. windowTitleComparator?
    {titles.iterm, nil, centerScreen, hs.layout.right50, nil, nil},
    -- {titles.iterm, nil, centerScreen, hs.layout.right50, nil, nil},
  }
  return windowLayout
end

------------------------------------------------------------------------------

function screenLayoutPrimaryAndIPad()
  hs.alert.show("screensPrimaryAndIPad layout")
  local laptopScreen = "Color LCD" -- hs.screen.primaryScreen()
  local iPadScreen = hs.screen.allScreens()[2]
  
  local chrome1,chrome2 = hs.application.find'Google Chrome'
  
  local windowLayout = {
    {titles.safari, nil, laptopScreen, hs.layout.right70, nil, nil},
    {chrome1, nil, laptopScreen, hs.layout.right70, nil, nil},
    {chrome2, nil, laptopScreen, hs.layout.right70, nil, nil},
    {titles.intellij, nil, laptopScreen, hs.layout.maximized, nil, nil},
    {titles.appCode, nil, laptopScreen,hs.layout.maximized, nil, nil},
    {titles.eclipse, nil, laptopScreen, hs.layout.maximized, nil, nil},
    {titles.sublime, nil, laptopScreen, hs.layout.centered, nil, nil},
    {titles.atom, nil, laptopScreen, hs.layout.left50, nil, nil},
    {titles.atomBeta, nil, laptopScreen, hs.layout.left50, nil, nil},
    {titles.iterm, nil, iPadScreen, hs.layout.maximized, nil, nil},
  }
  return windowLayout
end

------------------------------------------------------------------------------

function screenLayoutPrimary()
  hs.alert.show("screensPrimary layout")
  local laptopScreen = "Color LCD" -- hs.screen.primaryScreen()
  
  local chrome1,chrome2 = hs.application.find'Google Chrome'
  
  local windowLayout = {
    {titles.safari, nil, laptopScreen, hs.layout.right50, nil, nil},
    {chrome1, nil, laptopScreen, hs.layout.right50, nil, nil},
    {chrome2, nil, laptopScreen, hs.layout.right50, nil, nil},
    {titles.intellij, nil, laptopScreen, hs.layout.maximized, nil, nil},
    {titles.appCode, nil, laptopScreen, hs.layout.maximized, nil, nil},
    {titles.eclipse, nil, laptopScreen, hs.layout.maximized, nil, nil},
    {titles.iterm, nil, laptopScreen, hs.layout.right50, nil, nil},
  }
  return windowLayout
end
