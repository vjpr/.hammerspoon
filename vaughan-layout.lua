require('util')

-- Screens table helpers.
------------------------------------------------------------------------------

function serialiseScreensTable(screens)
  if screens == nil then return end
  local screensString = ''
  for _, screen in pairs(screens) do
    screensString = screensString .. tostring(screen)
  end
  -- print(screensString)
  return screensString
end

function screensIsSame(screensA, screensB)
  return serialiseScreensTable(screensA) ~= serialiseScreensTable(screensB)
end

local lastScreens = null

function hasScreensChanged()
  local newScreens = hs.screen.allScreens()
  return not screensIsSame(newScreens, lastScreens)
end

-- Watch for changes to monitor layout.
------------------------------------------------------------------------------

local timer = null
-- It takes about 4s for macOS to finish its monitor re-org.
local DEBOUNCE_DELAY = 5

function debouncedLayout(reason)
  
  print('screens changed!')
  
  if (timer) then
    -- `stop` means callback will not be called.
    timer:stop()
  end

  -- If the screens change, do layout if no further screen
  -- change for X seconds.
  timer = hs.timer.doAfter(DEBOUNCE_DELAY, function()
    -- Alert with reason for relayout.
    if reason == 'screen' then
      hs.alert.show("Monitor layout changed")
    elseif reason == 'systemDidWake' then
      hs.alert.show("System woke up")
    elseif reason == 'screensDidUnlock' then
      hs.alert.show("Screens did unlock")
    end
    
    universalLayout()
  end)

end

function handleScreenWatcher()
  lastScreens = hs.screen.allScreens()
  debouncedLayout('screen')
end

-- NOTE: Can also detect when active screen changes with `newWithActiveScreen` if needed.
local screenWatcher = hs.screen.watcher.new(handleScreenWatcher)
screenWatcher:start()

-- Watch for changes to screens.
------------------------------------------------------------------------------

-- NOTE: `system wake` always followed by `screen unlock` when lock on sleep enabled.

function handleCaffeinateEvent(event)
  if event == hs.caffeinate.watcher.systemDidWake then
    print('system did wake')
    if hasScreensChanged() then
      print('screens have changed')
      debouncedLayout('systemDidWake')
    else
      print('screens have NOT changed. not laying out.')
    end
  elseif event == hs.caffeinate.watcher.screensDidUnlock then
    print('screens did unlock')
    -- debouncedLayout('screensDidUnlock')
  end
end

local caffeinateWatcher = hs.caffeinate.watcher.new(handleCaffeinateEvent)
caffeinateWatcher:start()

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

-- We use this hash instead of `hs.layout` because we can invert things
-- depending on which side the secondary screen (or iPad) is placed.

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
  finder = 'Finder',
}

commonWindowLayout = {
  {'WhatsApp', nil, laptopScreen, positions.right50, nil, nil},
  {'Messenger', nil, laptopScreen, positions.right50, nil, nil},
  {'Quip', nil, laptopScreen, positions.right50, nil, nil},
  {'Slack', nil, laptopScreen, positions.right50, nil, nil},
  {'Spotify', nil, laptopScreen, positions.centered, nil, nil},
  {'iTunes', nil, laptopScreen, positions.centered, nil, nil},
  {titles.outlook, nil, laptopScreen, positions.centered, nil, nil},
  {titles.calendar, nil, laptopScreen, positions.centered, nil, nil},
  {titles.finder, nil, laptopScreen, positions.left50, nil, nil},
}

------------------------------------------------------------------------------

-- DEBUG!
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "0", function()
--   findIpadScreen()
-- end)

function compareGeomSize(a, b)
  if (not a or not b) then return false end
  return a:fullFrame().w == b:fullFrame().w and a:fullFrame().h == b:fullFrame().h
end

function compareSize(a, b)
  if (not a or not b) then return false end
  return a.w == b.w and a.h == b.h
end

local inspect = require('inspect')

local laptopDisplay = hs.geometry.new('1920x1200')
local monitor1440p = hs.geometry.new('2560x1440')
local monitor1080pVertical = hs.geometry.new('1080x1920')
local iPadDuetStandard = hs.geometry.new('1024x768')
local projector720p = hs.geometry.new('1280x720')

function detectScreenType(screen)
  local screenFrame = screen:fullFrame()
  local screenSize = screenFrame.size
  
  local out

  if (compareSize(screenSize, iPadDuetStandard)) then
    out = 'ipad'
  elseif (compareSize(screenSize, monitor1440p)) then
    out = '1440p'
  elseif (screenSize:equals(monitor1080pVertical)) then
    out = 'tertiary'
  elseif (screenSize:equals(laptopDisplay)) then
    out = 'laptop'
  elseif (screenSize:equals(projector720p)) then
    out = '720p'
  end
  
  print('w', screenSize.w, 'h', screenSize.h, name)
  
  return name
  
end

-- function getAllScreens()
--     local allScreens = hs.screen.allScreens()
--     local out = {}
--     for _, screen in pairs(allScreens) do
--       out.insert(screen, detectScreenType(screen))
--     end
--     return out
-- end

function isIpadConnected()
  local allScreens = hs.screen.allScreens()
  for _, screen in pairs(allScreens) do
    local screenFrame = screen:fullFrame()
    local screenSize = screenFrame.size
    if (compareSize(screenSize, iPadDuetStandard)) then
      return true
    end
  end
  return false
end

function isVerticalScreenConnected()
  local allScreens = hs.screen.allScreens()
  for _, screen in pairs(allScreens) do
    local screenFrame = screen:fullFrame()
    local screenSize = screenFrame.size
    if (compareSize(screenSize, monitor1080pVertical)) then
      return true
    end
  end
  return false
end

function printScreens()
  local allScreens = hs.screen.allScreens()
  print(inspect(allScreens))
  print('Found monitors:')
  for _, screen in pairs(allScreens) do
    detectScreenType(screen)
  end
  print('---')
end

printScreens()

function universalLayout()
  local allScreens = hs.screen.allScreens()
  local screenCount = tableLength(allScreens)
  local windowLayout
  
  print('Screen count:', screenCount)
  print('Dimensions:', dimensions)
  
  -- TODO(vjpr): Maybe use find to improve code.
  -- http://www.hammerspoon.org/docs/hs.screen.html#find.
  
  if (screenCount == 5) then
    
    if (isIpadConnected()) then
      -- a. Laptop, Main, Secondary, Tertiary, iPad
      windowLayout = screenLayoutPrimaryAnd2xU2515HAnd1xLG()
    else
      -- b. Laptop, Main, Secondary, Tertiary, Projector
      windowLayout = screenLayoutPrimaryAnd2xU2515HAnd1xLG()
    end
  
  elseif (screenCount == 4) then
    
    if (isIpadConnected()) then
      -- a. Laptop, Main, Secondary, iPad
      windowLayout = screenLayoutPrimaryAnd2xU2515H()
    elseif (isVerticalScreenConnected()) then
      -- b. Laptop, Main, Secondary, Tertiary
      windowLayout = screenLayoutPrimaryAnd2xU2515HAnd1xLG()
    else
      -- c. Laptop, Main, Secondary, Projector?
      -- TODO(vjpr)
      windowLayout = screenLayoutPrimaryAnd2xU2515H()
    end
  
  elseif (screenCount == 3) then
    
    if (isIpadConnected()) then
      -- a. Laptop, Main, iPad
      windowLayout = screenLayoutPrimaryAnd1xU2515H()
    elseif (isVerticalScreenConnected()) then
      -- b. Laptop, Main, Vertical
      -- TODO(vjpr): Not robust.
      windowLayout = screenLayoutPrimaryAnd1xU2515H()
    else
      -- c. Laptop, Main, Secondary
      windowLayout = screenLayoutPrimaryAnd2xU2515H()
    end
  
  elseif (screenCount == 2) then

    local secondScreen = allScreens[2]
    local secondScreenSize = secondScreen:fullFrame().size
    if (compareSize(secondScreenSize, iPadScreen)) then
      -- a. Laptop, iPad (Duet)
      windowLayout = screenLayoutPrimaryAndIPad()
    elseif (compareSize(secondScreenSize, projector720p)) then
      -- b. Laptop, Projector/AppleTV
      windowLayout = screenLayoutPrimary()
    elseif (compareSize(secondScreenSize, monitor1080pVertical)) then
      -- c. Laptop, LG
      windowLayout = screenLayoutPrimary()
    else
      -- d. Laptop, Main
      windowLayout = screenLayoutPrimaryAnd1xU2515H()
    end
    
  elseif (screenCount == 1) then
    
    -- Only laptop display.
    windowLayout = screenLayoutPrimary()
    
  end

  local layout = {}
  tableConcat(layout, commonWindowLayout)
  tableConcat(layout, windowLayout)
  hs.layout.apply(layout)
  
  arrangeItermWindows(screenCount)

end

function arrangeItermWindows(screenCount)

  local app = hs.application.find("iTerm2")
  if not app then return end

  if (screenCount == 3 or screenCount == 4) then

    local rightScreen = hs.screen.primaryScreen():toEast()

    -- Workaround while waiting for
    -- [`hs.layout.apply` and multiple windows of same application](https://github.com/Hammerspoon/hammerspoon/issues/298)
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
    app:mainWindow():move(positions.left50, rightScreen)
  end
  
end

------------------------------------------------------------------------------

function getSecondScreen()
  local centerScreen = hs.screen.primaryScreen():toNorth()
  
  -- TODO(vjpr): Not robust.
  if (not centerScreen) then
    local allScreens = hs.screen.allScreens()
    return allScreens[2], allScreens[3]
  end
  
  -- strict - disregard screens that lie completely above or below this one
  local strict = true
  local screenEast = centerScreen:toEast(null, strict)
  local screenWest = centerScreen:toWest(null, strict)
  local secondScreen
  local thirdScreen
  
  local targetSecondScreenSize = monitor1440p
  
  local screenEastSize = screenEast:fullFrame().size
  
  if (compareSize(screenEastSize, targetSecondScreenSize)) then
    -- Second screen is east of center screen.
    secondScreen = screenEast
    thirdScreen = screenWest
  else
    -- Second screen is west of center screen.
    secondScreen = screenWest
    thirdScreen = screenEast
  end
  
  return secondScreen, thirdScreen
  
end

function screenLayoutPrimaryAnd2xU2515HAnd1xLG()
  hs.alert.show("screenLayoutPrimaryAnd2xU2515HAnd1xLG layout")
  local laptopScreen = "Color LCD" -- hs.screen.primaryScreen()

  local centerScreen = hs.screen.primaryScreen():toNorth()
  local secondScreen, thirdScreen = getSecondScreen()
  
  print(secondScreen, thirdScreen)

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
    -- TODO(vjpr): If atom is maximized before being moved, this does not work.
    {titles.atom, nil, thirdScreen, hs.layout.maximized, nil, nil},
    {titles.atomBeta, nil, thirdScreen, hs.layout.maximized, nil, nil},
    
    {titles.sourceTree, nil, centerScreen, positions.centered, nil, nil},
    -- TODO: One on each monitor. windowTitleComparator?
    -- {titles.iterm, nil, rightScreen, hs.layout.right50, nil, nil}, -- Done manually.
    {titles.hyper, nil, secondScreen, hs.layout.right50, nil, nil},
  }
  return windowLayout
end

------------------------------------------------------------------------------

function screenLayoutPrimaryAnd2xU2515H()
  hs.alert.show("screensPrimaryAnd2xU2515H layout")
  local laptopScreen = "Color LCD" -- hs.screen.primaryScreen()

  -- local centerScreen = hs.screen.allScreens()[2]
  local centerScreen = hs.screen.primaryScreen():toNorth()
  local secondScreen, thirdScreen = getSecondScreen()

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
    {titles.hyper, nil, secondScreen, hs.layout.right50, nil, nil},
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
