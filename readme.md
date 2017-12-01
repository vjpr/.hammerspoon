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

⌘ ⌥ ⇧ ⌃ ⇪  Fn ⟵ ⟶ ↑ ↓

## Useful key bindings

`⌘ ⌥ ⌃ n` = Layout all windows

`⌘ ⌥ ⌃ ⟵/⟶` = Push to left or right window

`Fn ⌘ ⌥ ⌃ ⟵/⟶` = Push to left 2/3 or right 2/3 of window

`Fn ⌃ ⇧ ⟶` = Push to left or right screen

## Config

`⌘ ⌥ ⌃ b` = Toggle between 2/3 or 1/2 screen width for windows wheen using "layout all windows" shortcut.

`⌘ ⌥ p` = Disable

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
