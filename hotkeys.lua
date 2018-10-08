hs.hotkey.bind({"ctrl", "alt", "cmd"}, "left", function()
  if #hs.screen.allScreens() <= 4 then -- TODO(vjpr): Why do we need this guard?
    pusher.pushLeft()
  end
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "right", function()
  if #hs.screen.allScreens() <= 4 then -- TODO(vjpr): Why do we need this guard?
    pusher.pushRight()
  end
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "j", function()
  pusher.oneThirdLeft()
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "k", function()
  pusher.oneThirdMiddle()
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "l", function()
  pusher.oneThirdRight()
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "{", function()
  pusher.pushOneThirdLeft()
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "}", function()
  pusher.pushOneThirdRight()
end)

local allowTabOutliner = false

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "home", function()
  if not allowTabOutliner or #hs.screen.allScreens() < 3 then
    pusher.twoThirdsLeft()
  else
    tabsOutlinerModule.pushLeft()
  end
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "end", function()
  if not allowTabOutliner or #hs.screen.allScreens() < 3 then
    pusher.twoThirdsRight()
  else
    tabsOutlinerModule.pushRight()
  end
end)

--hs.hotkey.bind({"cmd", "alt", "ctrl"}, "<", function()
--  tabsOutlinerModule.pushLeft()
--end)
--
--hs.hotkey.bind({"cmd", "alt", "ctrl"}, ">", function()
--  tabsOutlinerModule.pushRight()
--end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, ",", function()
  tabsOutlinerModule.pushLeft()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, ".", function()
  tabsOutlinerModule.pushRight()
end)
