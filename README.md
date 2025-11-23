# 🎭 FiveM Mask Face Fixer

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![FiveM](https://img.shields.io/badge/FiveM-Compatible-blue.svg)](https://fivem.net/)
[![Lua](https://img.shields.io/badge/Lua-5.4-purple.svg)](https://www.lua.org/)

A lightweight, performance-optimized FiveM script that automatically fixes visual clipping and facial distortion issues when players equip certain masks and headwear. Dynamically adjusts head blend data and facial features, then seamlessly restores original appearance when items are removed.

## Preview
**Streamable**: <a href="https://streamable.com/rnowcr" target="_blank">View</a>

## Problem This Solves

In FiveM/GTA V, certain masks and head accessories cause visual glitches:
- **Face clipping through masks** - Nose, lips, or chin poking through
- **Distorted proportions** - Stretched or compressed facial features
- **Accessories misalignment** - Goggles, helmets, or masks sitting incorrectly
- **Head shape conflicts** - Custom head blends incompatible with specific items

This script **automatically detects** problematic items and applies real-time corrections without player intervention.

## Features

- **Automatic Detection** - Instantly recognizes problematic masks/headwear
- **Smart Caching** - Saves original head blend and facial features
- **Performance Optimized** - Efficient change detection (1-second intervals)
- **Seamless Restoration** - Reverts to original appearance when mask removed
- **Safe Unloading** - Ensures restoration on resource stop/restart
- **Debug Logging** - Optional detailed console output for troubleshooting
- **Zero Configuration** - Works out-of-the-box for most scenarios
- **Gender Aware** - Different handling for male/female characters

## Installation

1. Download or clone this repository
2. Place the resource folder in your FiveM server's `resources` directory
3. Add to your `server.cfg`:

```bash
ensure maskfacefixer
```

4. Restart your server or use `refresh` + `ensure maskfacefixer` command line

## Affected Masks/Items

### Known Problematic Masks
The script automatically handles:
- Mask ID **108** - Full face masks
- Mask ID **30** - Specific helmet types
- Mask ID **11** - Earpiece exceptions
- Mask ID **114**, **145**, **148** - Special accessories
- Any item with `SHRINK_HEAD` tag
- Items without `HAT` or `EAR_PIECE` tags

### Tag-Based Detection
Items are identified by GTA V's internal tags:
- `SHRINK_HEAD` - Indicates head shape conflicts
- `HAT` - Standard headwear (usually safe)
- `EAR_PIECE` - Ear-mounted accessories