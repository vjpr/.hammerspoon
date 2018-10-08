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

ax = require("hs._asm.axuielement")

-- Print out running application names.
print(dump(hs.application.runningApplications()))

-- Time all window move operations.
-- hs.window._timed_allWindows()

inspect = require("hs.inspect")

local chrome1,chrome2 = hs.application.find'Google Chrome'

local app = chrome1
local windows = chrome1:allWindows()

print(dump(windows))


local hsWindow = windows[15]
local window = ax.windowElement(hsWindow)

-- print('wintitle', hsWindow:title())
-- print('tabs?', window:elementSearch({role="AXTabGroup"}))




-- print(inspect(window:buildTree()))


-- print("win", dump(window))


-- print('names', dump(ax.applicationElement(app)))

-- print('app windows', dump(ax.applicationElement(app):elementSearch({role="AXWindow", subrole="AXStandardWindow"})()))

-- print('app childs #2', dump(ax.applicationElement(app[2])))

-- print('childs', dump(ax.applicationElement(app)[2]:elementSearch({role="AXTabGroup"})))
-- -- print('childs', dump(ax.applicationElement(app)[2]:getAllChildElements()[1]:getAllChildElements()[1]:getAllChildElements()))
