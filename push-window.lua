-- Push window left or right
------------------------------------------------------------------------------

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "left", function()
  if #hs.screen.allScreens() <= 4 then -- TODO(vjpr): Why do we need this guard?
    hs.window.focusedWindow():moveToUnit(hs.layout.left50)
  end
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "right", function()
  if #hs.screen.allScreens() <= 4 then -- TODO(vjpr): Why do we need this guard?
    hs.window.focusedWindow():moveToUnit(hs.layout.right50)
  end
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "home", function()
  if #hs.screen.allScreens() < 3 then
    local g = hs.geometry.unitrect(0,0,0.6,1)
    hs.window.focusedWindow():moveToUnit(g)
  end
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "end", function()
  if #hs.screen.allScreens() < 3 then
    local g = hs.geometry.unitrect(0.4,0,0.6,1)
    hs.window.focusedWindow():moveToUnit(g)
  end
end)
