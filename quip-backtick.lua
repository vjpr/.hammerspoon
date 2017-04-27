-- See https://github.com/Hammerspoon/hammerspoon/issues/664

local fastKeyStroke = function(modifiers, character)
  local event = require("hs.eventtap").event
  event.newKeyEvent(modifiers, string.lower(character), true):post()
  event.newKeyEvent(modifiers, string.lower(character), false):post()
end

-- hs.hotkey.bind({}, "`", function()
--   --local quipWindow = hs.window.find("Quip")
--   local win = hs.window.focusedWindow()
--   local quipIsFocused
--   if win and win:application():bundleID() == "com.quip.Desktop" then quipIsFocused = true end
--   if quipIsFocused then
--     print("quip window")
--     print("backtick")
--     fastKeyStroke({"ctrl", "shift"}, "`")
--     return true
--   end
--   fastKeyStroke({}, "`")
--   return true
-- end)
