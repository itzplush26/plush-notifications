# Plush Notifications - Premium FiveM Notification System

A modern, lightweight, and highly customizable notification system for FiveM servers. Framework-agnostic with support for QBCore, ESX, QBox, and standalone usage.

## Features

- 🎨 **Modern UI** - Clean, polished design with smooth animations
- ⚡ **Performance Optimized** - Low resource usage, efficient rendering
- 🎯 **Framework Agnostic** - Works with QBCore, ESX, QBox, or standalone
- 🎨 **Highly Customizable** - Themes, colors, positions, icons, sounds
- 📦 **Queue System** - Prevents notification spam with intelligent queuing
- 🔌 **Developer Friendly** - Simple exports and API
- 🎭 **Multiple Types** - Success, Error, Info, Warning notifications
- 🎬 **Smooth Animations** - Slide, fade, scale, and bounce effects
- 🔊 **Sound Support** - Optional audio alerts
- 🌓 **Theme Support** - Light, dark, and auto themes

## Installation

1. Place the resource in your `resources` folder
2. Add `ensure plush-notifications` (or your folder name) to your `server.cfg`
3. Restart your server or start the resource

## Configuration

Edit `config.lua` to customize:

- **Framework**: Set to `'auto'`, `'qb'`, `'esx'`, `'qbox'`, or `'standalone'`
- **Position**: Choose from `'top-right'`, `'top-left'`, `'top-center'`, `'bottom-right'`, `'bottom-left'`, `'bottom-center'`, or `'center'`
- **Theme**: Set to `'dark'`, `'light'`, or `'auto'` (follows system theme)
- **Animation**: Choose `'slide'`, `'fade'`, `'scale'`, or `'bounce'`
- **Sounds**: Enable/disable and customize notification sounds
- **Duration**: Set default notification duration
- **Max Notifications**: Limit visible notifications

## Usage

### Client-Side

#### Basic Usage

```lua
-- Simple notification
exports['plush-notifications']:Notify('success', 'Operation completed successfully!')

-- With duration
exports['plush-notifications']:Notify('error', 'Something went wrong!', 3000)

-- Type-specific exports
exports['plush-notifications']:Success('Great job!')
exports['plush-notifications']:Error('Failed to process')
exports['plush-notifications']:Info('New message received')
exports['plush-notifications']:Warning('Low fuel warning')
```

#### Advanced Usage

```lua
-- With custom options
exports['plush-notifications']:Notify('info', 'Custom notification', 5000, {
    title = 'Custom Title',
    icon = 'bell',
    color = '#8b5cf6',
    position = 'top-left',
    silent = false -- Set to true to disable sound
})

-- Remove specific notification
local notifId = exports['plush-notifications']:Notify('info', 'This can be removed', 0) -- 0 = no auto-remove
exports['plush-notifications']:Remove(notifId)

-- Clear all notifications
exports['plush-notifications']:Clear()
```

### Server-Side

```lua
-- Notify a specific player
exports['plush-notifications']:Notify(source, 'success', 'You received a reward!')

-- Type-specific server exports
exports['plush-notifications']:Success(source, 'Welcome to the server!')
exports['plush-notifications']:Error(source, 'You do not have permission')
exports['plush-notifications']:Info(source, 'Server maintenance in 5 minutes')
exports['plush-notifications']:Warning(source, 'Your account will expire soon')
```

### Framework Integration

#### QBCore

The notification system automatically hooks into QBCore's notification system:

```lua
-- Works automatically
TriggerEvent('QBCore:Notify', 'Hello!', 'success', 5000)
```

#### QBox

The notification system automatically hooks into QBox's notification system:

```lua
-- Works automatically with multiple event patterns
TriggerEvent('qbx:notify', 'Hello!', 'success', 5000)
TriggerEvent('QBox:Notify', 'Hello!', 'info', 5000)
TriggerEvent('qbx_core:client:notify', 'Hello!', 'warning', 5000)
```

#### ESX

The notification system automatically hooks into ESX's notification system:

```lua
-- Works automatically
TriggerEvent('esx:showNotification', 'Hello!', 'info', 5000)
```

## Notification Types

- **success** - Green, check-circle icon
- **error** - Red, x-circle icon
- **info** - Blue, info icon
- **warning** - Orange, alert-triangle icon

## Custom Icons

Available icons: `check-circle`, `x-circle`, `info`, `alert-triangle`, `bell`, `star`

You can add more icons in `config.lua` under `Config.Icons`.

## Positions

- `top-right` (default)
- `top-left`
- `top-center`
- `bottom-right`
- `bottom-left`
- `bottom-center`
- `center`

## Examples

### Example 1: Simple Success Notification

```lua
exports['plush-notifications']:Success('You earned $500!')
```

### Example 2: Custom Error with Title

```lua
exports['plush-notifications']:Error('Failed to connect to database', 5000, {
    title = 'Database Error',
    icon = 'x-circle'
})
```

### Example 3: Persistent Info Notification

```lua
local notifId = exports['plush-notifications']:Info('Waiting for response...', 0, {
    title = 'Processing',
    icon = 'info'
})

-- Remove it later
Citizen.SetTimeout(10000, function()
    exports['plush-notifications']:Remove(notifId)
end)
```

### Example 4: Server-Side Notification

```lua
-- In a server script
RegisterCommand('notify', function(source, args)
    local message = table.concat(args, ' ')
    exports['plush-notifications']:Notify(source, 'info', message)
end, false)
```

### Example 5: Custom Themed Notification

```lua
exports['plush-notifications']:Notify('info', 'Special event starting!', 7000, {
    title = 'Event',
    icon = 'star',
    color = '#fbbf24',
    position = 'center'
})
```

## API Reference

### Client Exports

- `exports['plush-notifications']:Notify(type, message, duration, options)`
- `exports['plush-notifications']:Success(message, duration, options)`
- `exports['plush-notifications']:Error(message, duration, options)`
- `exports['plush-notifications']:Info(message, duration, options)`
- `exports['plush-notifications']:Warning(message, duration, options)`
- `exports['plush-notifications']:Remove(notificationId)`
- `exports['plush-notifications']:Clear()`

### Server Exports

- `exports['plush-notifications']:Notify(source, type, message, duration, options)`
- `exports['plush-notifications']:Success(source, message, duration, options)`
- `exports['plush-notifications']:Error(source, message, duration, options)`
- `exports['plush-notifications']:Info(source, message, duration, options)`
- `exports['plush-notifications']:Warning(source, message, duration, options)`

### Options Object

```lua
{
    id = 'custom-id',           -- Custom notification ID
    title = 'Title',            -- Notification title
    icon = 'bell',              -- Icon name
    color = '#3b82f6',          -- Custom color
    position = 'top-right',     -- Override default position
    duration = 5000,            -- Override default duration
    silent = false              -- Disable sound
}
```

## Performance

- **Low Resource Usage**: Optimized rendering and minimal DOM manipulation
- **Queue System**: Prevents notification spam and UI lag
- **Efficient Animations**: CSS-based animations for smooth performance
- **Memory Management**: Automatic cleanup of removed notifications

## Customization

### Adding Custom Icons

Edit `config.lua` and add to `Config.Icons`:

```lua
Config.Icons = {
    ['my-icon'] = '<svg>...</svg>'
}
```

### Custom Colors

Edit `config.lua` and modify `Config.Types`:

```lua
Config.Types = {
    success = {
        color = '#your-color',
        icon = 'check-circle',
        sound = 'success'
    }
}
```

### Custom Sounds

Edit `config.lua` and modify `Config.Sounds`:

```lua
Config.Sounds = {
    success = 'YOUR_SOUND_NAME'
}
```

## Troubleshooting

### Notifications not showing?

1. Check that the resource is started: `ensure plush-notifications`
2. Check browser console (F8) for errors
3. Verify `fxmanifest.lua` is correct
4. Check `config.lua` for any syntax errors

### Framework not detected?

1. Set `Config.Framework = 'auto'` in `config.lua`
2. Or manually set to `'qb'`, `'esx'`, `'qbox'`, or `'standalone'`
3. Ensure your framework resource is started before this one
4. For QBox, ensure the resource name is either `qbx_core` or `qbox-core`

### Sounds not playing?

1. Check `Config.SoundEnabled = true` in `config.lua`
2. Verify sound names in `Config.Sounds` are valid GTA V sound names
3. Check `Config.SoundVolume` is between 0.0 and 1.0

## License

This resource is provided as-is. Feel free to modify and use in your server.

## Support

For issues or questions, check the configuration file and ensure all dependencies are met.

---

**Enjoy your premium notification system!** 🎉
