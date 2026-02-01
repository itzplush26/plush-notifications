Config = {}

-- General Settings
Config.Framework = 'auto' -- 'auto', 'qb', 'esx', 'qbox', 'standalone'
Config.Debug = true

-- Notification Settings
Config.DefaultDuration = 5000 -- milliseconds
Config.MaxNotifications = 5 -- Maximum notifications visible at once
Config.QueueEnabled = true -- Enable notification queue
Config.QueueDelay = 100 -- Delay between queued notifications (ms)

-- Position Settings
Config.Position = 'top-right' -- 'top-right', 'top-left', 'top-center', 'bottom-right', 'bottom-left', 'bottom-center', 'center'
Config.OffsetX = 20 -- pixels from edge
Config.OffsetY = 20 -- pixels from edge
Config.Spacing = 10 -- pixels between notifications

-- Theme Settings
Config.Theme = 'dark' -- 'dark', 'light', 'auto'
Config.AutoTheme = false -- Automatically detect system theme (if Theme is 'auto')

-- Animation Settings
Config.AnimationDuration = 300 -- milliseconds
Config.AnimationType = 'bounce' -- 'slide', 'fade', 'scale', 'bounce'

-- Sound Settings
Config.SoundEnabled = true
Config.SoundVolume = 0.7 -- 0.0 to 1.0
-- Custom sound file (plays through NUI) - set to nil to use native GTA sounds instead
Config.CustomSound = 'sound/sfx.mp3'
-- Native sounds (used when Config.CustomSound is nil)
Config.Sounds = {
    success = { name = 'YES', set = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    error = { name = 'NO', set = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    info = { name = 'SELECT', set = 'HUD_FRONTEND_DEFAULT_SOUNDSET' },
    warning = { name = 'BACK', set = 'HUD_FRONTEND_DEFAULT_SOUNDSET' }
}

-- Notification Types
Config.Types = {
    success = {
        color = '#10b981',
        icon = 'check-circle',
        sound = 'success'
    },
    error = {
        color = '#ef4444',
        icon = 'x-circle',
        sound = 'error'
    },
    info = {
        color = '#3b82f6',
        icon = 'info',
        sound = 'info'
    },
    warning = {
        color = '#f59e0b',
        icon = 'alert-triangle',
        sound = 'warning'
    }
}

-- Icon Library (using Heroicons names)
Config.Icons = {
    ['check-circle'] = '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>',
    ['x-circle'] = '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>',
    ['info'] = '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>',
    ['alert-triangle'] = '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" /></svg>',
    ['bell'] = '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" /></svg>',
    ['star'] = '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z" /></svg>'
}
