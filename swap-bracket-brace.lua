-- module.eventwatcher3 = hs.eventtap.new({"all"}, function(e)
--   local keyCode = e:getKeyCode()
--   local flags = e:getFlags()
--   local type = e:getType()
--   -- hs.eventtap.event.types.keyUp

--   if not flags.shift then

--     if keyCode == 33 then
--       print("[")
--       -- fastKeyStroke({"shift"}, "[")
--       -- return true
--     elseif keyCode == 30 then
--       print("]")
--       -- fastKeyStroke({}, "{")
--       -- return true
--     end

--   else

--       print("hello")

--   end

-- end):start()

-------------------------------------------------------------------------------

-- DISABLED: Use custom keyboard with Ukelele.

-- -- Swap brackets and braces.

-- -- TODO(vjpr): Make everything use this module namespace.
-- swapBracketAndBracesModule = {}

-- -- local trigger = function()
  
-- -- end

-- -- TODO(vjpr): Set properties.
-- local swapBracketsAndBraces = function(e)
--   local event = require("hs.eventtap").event
--   local keyCode = e:getKeyCode()
--   local isDown = e:getType() == hs.eventtap.event.types.keyDown
--   local flags = e:getFlags()
--   print("data", hs.inspect(e:getRawEventData()))
  
--   if keyCode == 0x21 then
--     print("opening bracket/brace key")
--     if (flags.shift) then
--       event.newKeyEvent({}, string.lower("["), isDown):post()
--     else
--       event.newKeyEvent({"shift"}, string.lower("["), isDown):post()
--     end
--     return true
--   elseif keyCode == 0x1e then
--     print("closing bracket/brace key")
--     if (flags.shift) then
--       event.newKeyEvent({}, string.lower("]"), isDown):post()
--     else
--       event.newKeyEvent({"shift"}, string.lower("]"), isDown):post()
--     end
--     return true
--   end
--   return false
-- end

-------------------------------------------------------------------------------

-- hs.hotkey.bind({}, string.lower("["), nil, function() hs.eventtap.keyStroke({"shift"}, string.lower("[")) end

--------------------------------------------------------------------------------

-- hs.eventtap.new({hs.eventtap.event.types.keyUp, hs.eventtap.event.types.keyDown}, function(e)
--   -- print(e:getKeyCode(), e:getType(), hs.inspect(e:getFlags()))
--   -- TODO(vjpr): Not working. Using a custom keyboard layout instead.
--   -- return swapBracketsAndBraces(e)
-- end):start()
