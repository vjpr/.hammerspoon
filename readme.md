# Vaughan's Hammerspoon Config

# Install

## Install Hammerspoon

Ensure you have hammerspoon installed.

## Install Lua

Hammerspoon bundles lua@5.3 at the moment.

You should install lua@5.3 with homebrew here:
https://github.com/Hammerspoon/hammerspoon/issues/363#issuecomment-138718726

```
brew tap homebrew/versions
brew install lua53
```

This will allow you to use luarocks.

## Luarocks

Use `luarocks-5.3` instead of `luarocks`. E.g:

```
luarocks-5.3 install foo
```

You must install:

```
luarocks-5.3 install inspect
```

# Usage

## Useful key bindings

`cmd-alt-ctrl-n` = Layout all windows

`cmd-alt-ctrl-left/right` =  Push to left or right window

`fn-ctrl-shift/right` =  Push to left or right screen

# Development

## Print a value in console

```
luarocks-5.3 install inspect
```

In the Hammerspoon console type for example:

```
require('inspect')(hs.screen.allScreens())
```

To read `userdata` entries (C pointers), you can only read the metatable (keys) data with inspect, otherwise you must use function calls. This can be useful to see what functions are available.

```
require('inspect')(getmetatable(hs.screen.allScreens()[1]))
```
