print('--------------------------------------------------------------------------------')
print('Started loading config')
print('--------------------------------------------------------------------------------')

-- See here for a cool config: https://gist.github.com/sprig/7cfb5664fc52fda8f2a88529ce94f49f
-- And tips on using luarocks modules.

-- Config
--------------------------------------------------------------------------------

local enableShiftUpToParens = true

-- Paths
--------------------------------------------------------------------------------

--
-- From https://github.com/Hammerspoon/hammerspoon/issues/363#issuecomment-138720696
package.path = "/usr/local/share/lua/5.3/?.lua;/usr/local/share/lua/5.3/?/init.lua;"..package.path
-- Allow requiring files relative to this one.
package.path = "../?.lua;"..package.path
package.cpath = "/usr/local/lib/lua/5.3/?.so;"..package.cpath

--------------------------------------------------------------------------------

require('luarocks.loader')

-- Global Hammerspoon options
--------------------------------------------------------------------------------

-- Disable Animations
hs.window.animationDuration = 0

hs.application.enableSpotlightForNameSearches(true)

--------------------------------------------------------------------------------

require('./config')
require('./vaughan-layout')
tabsOutlinerModule = require('./tabs-outliner')
-- require('util')
require('./debug')
if (enableShiftUpToParens) then require('./shift-up-to-parens') end
require('./quip-backtick')
pusher = require('push-window')

-- NOTE: Relies on global exports from tabsOutliner/push-window.
hotkeys = require('./hotkeys')

-- NOTE: We do this with a custom keyboard. It's easier.
-- require('swap-bracket-brace')

-- Wifi
--------------------------------------------------------------------------------

-- TODO(vjpr): Detect wifi name and configure things.

homeArrived = function()
end

homeDeparted = function()
end

--------------------------------------------------------------------------------

hs.alert.show("Config loaded")

--------------------------------------------------------------------------------

-- Pause SoundCloud native app.
-- TODO(vjpr)

-- local soundCloud = hs.application.find('SoundCloud')
-- print soundCloud

--------------------------------------------------------------------------------

-- TODO(vjpr): Launch apps by keyboard shortcut.

-- hs.hotkey.new({"esc"}, "q", nil, function()
--   local app = hs.application.find("Quip")
--   app:activate()
-- end)
