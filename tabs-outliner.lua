-- Tabs Outliner
------------------------------------------------------------------------------

-- Select a Chrome Canary window and press cmd+alt+ctrl+fn+left-arrow
-- and the tabs outliner will be positioned next to the Chrome window.

-- TODO: Use pixels!

-- StackOverflow min-width < Github min-width.
-- stackOverflowMinWidth = 0.44 -- x U2515H width
-- stackOverflowMinWidth = 0.435 -- x U2515H width
stackOverflowMinWidth = 0.42 -- x U2515H width
roomyChromeWidth = 0.45

-- a. Outliner is the remaining room after fitting two StackOverflow-min-width Chrome windows side-by-side.
-- outlinerWidth = 1 - (chromeWidth * 2)
chromeWidth = stackOverflowMinWidth
-- chromeWidth = roomyChromeWidth
outlinerWidth = 0.5 - chromeWidth

outlinerWidthPx = 500

-- b. Outliner and chrome share half the screen.
-- outlinerWidth = 0.08

chromeRightWidth = 0.5

function tabsOutliner()

  local laptopScreen = "Color LCD" -- hs.screen.primaryScreen()
  local centerScreen = hs.screen.allScreens()[2]
  local rightScreen = hs.screen.allScreens()[3]

  local outlinerWindow = hs.window.find("Tabs Outliner")
  if outlinerWindow then
    print("outliner!", outlinerWidth)
    local outlinerHeight = 1
    -- local outlinerHeight = 0.5
    outlinerWindow:moveToUnit(hs.geometry(0, 0, outlinerWidth, outlinerHeight))
    -- outlinerWindow:setSize(outlinerWidthPx, outlinerWindow:size().h)
  end

  -- local chromeApp = hs.appfinder.appFromName("Google Chrome")
  local chromeApp1, chromeApp2 = hs.application.find'Google Chrome'

  local chromeCanary
  -- local chromeBundleId = "com.google.Chrome.canary"
  local chromeBundleId = "com.google.Chrome"
  if chromeApp1 and chromeApp1:bundleID() == chromeBundleId then chromeCanary = chromeApp1 end
  if chromeApp2 and chromeApp2:bundleID() == chromeBundleId then chromeCanary = chromeApp2 end

  local chromeWindow = chromeCanary:focusedWindow() -- TODO: ...that is not Tabs Outliner.
  chromeWindow:moveToUnit(hs.geometry(outlinerWidth, 0, chromeWidth, 1))
  -- chromeWindow:setSize(chromeWindow.size().w, chromeWindow:size().h)

  -- local layout = {
  --   {titles.chrome, "Tabs Outliner", centerScreen, hs.geometry({x=0, y=0, w=0.1, h=1}), nil, nil},
  --   {titles.chrome, nil, centerScreen, hs.geometry({x=0.1, y=0, w=0.4, h=1}), nil, nil},
  -- }
  -- hs.layout.apply(layout)

end

local exports = {}

exports.pushLeft = function()
  tabsOutliner()
end

exports.pushRight = function()
  local window = hs.window.focusedWindow()
  window:moveToUnit(hs.geometry(outlinerWidth + chromeWidth, 0, chromeRightWidth, 1))
end

return exports
