-- DEBUG: Print every key press.
-- a = hs.eventtap.new({hs.eventtap.event.types.keyUp, hs.eventtap.event.types.keyDown}, function(o) print(o:getKeyCode(), o:getType(), hs.inspect(o:getFlags())) ; return false end):start()

-- DEBUG: Prints when shift key down pressed.
-- shiftWatcher = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(e)
--     local flags = e:getFlags()
--     if flags.shift and not (flags.alt or flags.cmd or flags.ctrl or flags.fn) then
--         local keyCode = e:getKeyCode()
--         if keyCode == 0x38 then
--             print("~~ left shift key")
--             print(e)
--         elseif keyCode == 0x3C then
--             print("~~ right shift key")
--         end
--     end
-- end):start()


-- Print out running application names.
print(dump(hs.application.runningApplications()))

-- Time all window move operations.
-- hs.window._timed_allWindows()
