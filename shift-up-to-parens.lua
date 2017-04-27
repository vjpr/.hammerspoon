-- Notes
--------------------------------------------------------------------------------

-- This is how Karabiner use to do it:
-- https://gist.github.com/carwin/4748951

--------------------------------------------------------------------------------

local fastKeyStroke = function(modifiers, character)
  local event = require("hs.eventtap").event
  event.newKeyEvent(modifiers, string.lower(character), true):post()
  event.newKeyEvent(modifiers, string.lower(character), false):post()
end

-- local fastKeyStrokeDown = function(modifiers, character)
--   local event = require("hs.eventtap").event
--   event.newKeyEvent(modifiers, string.lower(character), true):post()
-- end

--------------------------------------------------------------------------------
-- TODO: Small problem with cmd+shift selections triggering brackets.
-- Need to differentiate left and right shift keys when shift modifier changed.
--------------------------------------------------------------------------------

local module = {}

local leftShiftDown = false
local rightShiftDown = false

--------------------------------------------------------------------------------

-- See https://github.com/Hammerspoon/hammerspoon/issues/1039

-- Which shift key was pressed and was it an up or down event.
-- e - `hs.eventtap.event.types.flagsChanged` event object
local whichShift = function(e)
  local ret
  local flags = e:getFlags()
  local keyCode = e:getKeyCode()
  -- local isDown = e:getType() == hs.eventtap.event.types.flagsChanged
  local isDown = flags.shift
  if keyCode == 0x38 then
    if not leftShiftDown and flags.shift then -- NOTE: We check shift down in case it becomes out of sync with our local var.
      leftShiftDown = true
      ret = {"left", "down"}
    else
      leftShiftDown = false
      ret = {"left", "up"}
    end
    -- if isDown then ret = {"left", "down"} else ret = {"left", "up"} end
  elseif keyCode == 0x3C then
    if not rightShiftDown and flags.shift then
      rightShiftDown = true
      ret = {"right", "down"}
    else
      rightShiftDown = false
      ret = {"right", "up"}
    end
    -- if isDown then ret = {"right", "down"} else ret = {"right", "up"} end
  else
    ret = {}
  end
  return ret
end

--------------------------------------------------------------------------------

-- local leftShiftDelay = 0
-- local rightShiftDelay = 0

--------------------------------------------------------------------------------

event = require('hs.eventtap').event

--------------------------------------------------------------------------------

watchers = {}

secureEventInputEnabled = false

function handleGlobalAppEvent(name, event, app)
  if event == hs.application.watcher.activated then
    watchers[app:pid()] = watchApp(app)
    -- On activate, we update secure event.
    secureEventInputEnabled = isSecureEventInputEnabled()
    print("isSecureEventInputEnabled", secureEventInputEnabled)
  elseif event == hs.application.watcher.deactivated then
    if watchers[app:pid()] then watchers[app:pid()]:stop() end
  end
end

appsWatcher = hs.application.watcher.new(handleGlobalAppEvent)

function watchApp(app)

  local watcher = app:newWatcher(function(element, event)
    print("Finder application activated, role: "..element:role())
    print("isApplication: "..tostring(element:isApplication()))
    print("isWindow: "..tostring(element:isWindow()))
    -- local mainWindow = element:mainWindow()
    -- if mainWindow then
    --   print("Main window: "..mainWindow:title())
    -- end
    secureEventInputEnabled = isSecureEventInputEnabled()
    print("isSecureEventInputEnabled", secureEventInputEnabled)
  end)
  watcher:start({hs.uielement.watcher.focusedElementChanged})
  return watcher

end

local js = "ObjC.bindFunction('IsSecureEventInputEnabled', ['bool', []]);\z
  $.IsSecureEventInputEnabled();"

-- NOTE: Slow enough to notice.
isSecureEventInputEnabled = function()
  local status, val, desc = hs.osascript._osascript(js, "JavaScript")
  return val
  -- return false -- DEBUG
end

--------------------------------------------------------------------------------

-- https://wiki.keyboardmaestro.com/Troubleshooting#Secure_Input_Mode
-- NOTE: This is slow when run in a webpage. It causes lag visible on Github issue input box.
-- local role = hs.uielement.focusedElement():role()
-- print(role, hs.inspect(hs.uielement.focusedElement()))
-- local role = "AXTextArea" -- Disabled.

-- TODO(vjpr): Remove module.leftShiftWasPressed. Use associative array for whether to ignore.
module.eventwatcher1 = hs.eventtap.new({hs.eventtap.event.types.keyUp, hs.eventtap.event.types.keyDown, hs.eventtap.event.types.flagsChanged}, function(e)
    local flags = e:getFlags()
    local shiftInfo = whichShift(e)
    local shiftSide = shiftInfo[1]
    local shiftState = shiftInfo[2]
    -- print("shift side:", shiftSide, shiftState)
    -- print("debug:", e:getKeyCode(), e:getType())
    -- print("mods:", hs.inspect(hs.eventtap.checkKeyboardModifiers(true)))
    -- print("debug", e:getKeyCode(), e:getType(), hs.inspect(e:getRawEventData()))

    -- if (keyCode ~= 0x38 and keyCode ~= 0x3C) then
    --   return nil
    -- end

    if shiftState == "up" and not (flags.alt or flags.cmd or flags.ctrl or flags.fn) then

      -- local ev = e:getProperty()
      -- secureEventInputEnabled = isSecureEventInputEnabled()
      -- print("isSecureEventInputEnabled", secureEventInputEnabled)

      -- If key was pressed while shift was down, then cancel.
      if not module.cancelShiftModification
        -- and role ~= "AXTextField" -- Prevent in text fields because password fields don't allow us to see keystrokes, only changes to modifiers which breaks our algorithm.
        and not secureEventInputEnabled
      then
        module.shiftDown = true
        if shiftSide == "left" then
          event.newKeyEvent({"shift"}, "9", true):post()
          event.newKeyEvent({"shift"}, "9", false):post()
        else
          event.newKeyEvent({"shift"}, "0", true):post()
          event.newKeyEvent({"shift"}, "0", false):post()
        end
      end
    end

    -- Reset.
    if not flags.shift then
      -- print("reset cancelling shift")
      module.cancelShiftModification = false
    end

    return false;

end)

module.eventwatcher2 = hs.eventtap.new({
  hs.eventtap.event.types.keyUp,
  hs.eventtap.event.types.keyDown,
  hs.eventtap.event.types.leftMouseDown,
  hs.eventtap.event.types.rightMouseDown
}, function(e)

    local flags = e:getFlags()
    local keyCode = e:getKeyCode()
    local type_ = e:getType()

    -- If shift is down and a key that is not a shift is pressed down then cancel the shift modification.
    local keyCode = e:getKeyCode()
    -- DEBUG
    --print("key", keyCode, flags.shift, type_)
    if (flags.shift
      and keyCode ~= 0x38 and keyCode ~= 0x3C
      and (type_ == hs.eventtap.event.types.keyDown or type_ == hs.eventtap.event.types.leftMouseDown) -- Sometimes the last keyup before the shift is pressed has the shift flag enabled because of the speed of typing.
      and not module.shiftDown) -- Ensure it is not our generated shift event. function
      then
        --print("canceling shift")
        module.cancelShiftModification = true
    end

    -- Indicate that generated shift down event finished.
    if module.shiftDown then
      module.shiftDown = false
    end

    return false;
end)

--------------------------------------------------------------------------------

init = function()

  -- Key remapping
  module.eventwatcher1:start()
  module.eventwatcher2:start()
  
  -- Watch for change in focused element and check whether secure input is enabled.
  -- NOTE: Disabled because it caused Hammerspoon to crash. Probably a memory leak.
  -- appsWatcher:start()

end

init()

-- Old
--------------------------------------------------------------------------------

-- local globalShiftState = {nil, nil}
-- local globalShiftIgnoreState = {nil, nil}

-- local foo = function()

--     if shiftState == "down" and not (flags.alt or flags.cmd or flags.ctrl or flags.fn) then
--         if shiftSide == "left" then
--           globalShiftState[1] = "down"
--         else
--           globalShiftState[2] = "up"
--         end

--         leftShiftDown = true
--         module.leftShiftShouldBeIgnored = false
--         return false;
--     end

--     if shiftState == "down"
--        and (flags.alt or flags.cmd or flags.ctrl or flags.fn)
--        and module.leftShiftWasPressed
--     then
--       module.leftShiftShouldBeIgnored = true
--       return false
--     end

--     if not flags.shift then
        
--         -- TODO: If one shift key is pressed before other released...only last key up event will fire. Need to track the individually.
--         if module.leftShiftWasPressed and not module.leftShiftShouldBeIgnored then
--             local keyCode = e:getKeyCode()
--             if keyCode == 0x38 then
--               fastKeyStroke({"shift"}, "9")
--             elseif keyCode == 0x3C then
--               fastKeyStroke({"shift"}, "0")
--             end
--         end
      
--       module.leftShiftWasPressed = false
--       module.leftShiftShouldBeIgnored = false

--     end

--     return false;

-- end
