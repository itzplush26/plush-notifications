local NotificationQueue = {}
local ActiveNotifications = {}
local NotificationIdCounter = 0

-- Framework Detection
local Framework = nil
local QBCore = nil
local ESX = nil
local QBox = nil

-- Initialize Framework
Citizen.CreateThread(function()
    if Config.Framework == 'auto' then
        -- Try QBCore
        if GetResourceState('qb-core') == 'started' then
            QBCore = exports['qb-core']:GetCoreObject()
            Framework = 'qb'
            if Config.Debug then print('[Notifications] Framework detected: QBCore') end
        -- Try QBox
        elseif GetResourceState('qbx_core') == 'started' or GetResourceState('qbox-core') == 'started' then
            local qboxResource = GetResourceState('qbx_core') == 'started' and 'qbx_core' or 'qbox-core'
            QBox = exports[qboxResource]:GetCoreObject()
            Framework = 'qbox'
            if Config.Debug then print('[Notifications] Framework detected: QBox') end
        -- Try ESX
        elseif GetResourceState('es_extended') == 'started' then
            ESX = exports['es_extended']:getSharedObject()
            Framework = 'esx'
            if Config.Debug then print('[Notifications] Framework detected: ESX') end
        else
            Framework = 'standalone'
            if Config.Debug then print('[Notifications] Framework detected: Standalone') end
        end
    else
        Framework = Config.Framework
        if Framework == 'qb' and GetResourceState('qb-core') == 'started' then
            QBCore = exports['qb-core']:GetCoreObject()
        elseif Framework == 'qbox' then
            if GetResourceState('qbx_core') == 'started' then
                QBox = exports['qbx_core']:GetCoreObject()
            elseif GetResourceState('qbox-core') == 'started' then
                QBox = exports['qbox-core']:GetCoreObject()
            end
        elseif Framework == 'esx' and GetResourceState('es_extended') == 'started' then
            ESX = exports['es_extended']:getSharedObject()
        end
    end
end)

-- Send notification to NUI
function SendNotificationToNUI(data)
    SendNUIMessage({
        action = 'showNotification',
        data = data
    })
end

-- Play notification sound (custom file via NUI, or native GTA sounds)
function PlayNotificationSound(soundName)
    if not Config.SoundEnabled then return end
    
    if Config.CustomSound then
        -- Custom sound: send to NUI to play via HTML5 Audio
        SendNUIMessage({
            action = 'playSound',
            sound = Config.CustomSound,
            volume = Config.SoundVolume or 0.7
        })
    else
        -- Native GTA sounds
        local soundData = Config.Sounds and Config.Sounds[soundName]
        if soundData then
            local soundId = GetSoundId()
            local soundNameStr = type(soundData) == 'table' and soundData.name or soundData
            local soundSet = type(soundData) == 'table' and soundData.set or 'HUD_FRONTEND_DEFAULT_SOUNDSET'
            PlaySoundFrontend(soundId, soundNameStr, soundSet, true)
            ReleaseSoundId(soundId)
        end
    end
end

-- Generate unique notification ID
function GenerateNotificationId()
    NotificationIdCounter = NotificationIdCounter + 1
    return 'notification_' .. NotificationIdCounter
end

-- Show notification
function ShowNotification(type, message, duration, options)
    options = options or {}
    
    local notificationId = options.id or GenerateNotificationId()
    local notificationDuration = duration or options.duration or Config.DefaultDuration
    local notificationType = type or 'info'
    
    -- Get type config safely
    local typeConfig = Config.Types[notificationType] or Config.Types.info
    local icon = options.icon or typeConfig.icon or 'info'
    local color = options.color or typeConfig.color or Config.Types.info.color
    local sound = options.sound or typeConfig.sound or 'info'
    local position = options.position or Config.Position
    local title = options.title or nil
    
    -- Play sound
    if not options.silent then
        PlayNotificationSound(sound)
    end
    
    -- Prepare notification data
    local notificationData = {
        id = notificationId,
        type = notificationType,
        message = message,
        title = title,
        duration = notificationDuration,
        icon = icon,
        color = color,
        position = position,
        timestamp = GetGameTimer()
    }
    
    -- Add to active notifications
    ActiveNotifications[notificationId] = notificationData
    
    -- Send to NUI
    SendNotificationToNUI(notificationData)
    
    -- Auto-remove after duration
    if notificationDuration > 0 then
        Citizen.SetTimeout(notificationDuration, function()
            RemoveNotification(notificationId)
        end)
    end
    
    return notificationId
end

-- Remove notification
function RemoveNotification(notificationId)
    if ActiveNotifications[notificationId] then
        SendNUIMessage({
            action = 'removeNotification',
            id = notificationId
        })
        ActiveNotifications[notificationId] = nil
    end
end

-- Process notification queue
function ProcessNotificationQueue()
    if not Config.QueueEnabled or #NotificationQueue == 0 then
        return
    end
    
    local activeCount = 0
    for _ in pairs(ActiveNotifications) do
        activeCount = activeCount + 1
    end
    
    if activeCount < Config.MaxNotifications then
        local nextNotification = table.remove(NotificationQueue, 1)
        if nextNotification then
            Citizen.Wait(Config.QueueDelay)
            ShowNotification(
                nextNotification.type,
                nextNotification.message,
                nextNotification.duration,
                nextNotification.options
            )
        end
    end
end

-- Queue notification
function QueueNotification(type, message, duration, options)
    if Config.QueueEnabled then
        table.insert(NotificationQueue, {
            type = type,
            message = message,
            duration = duration,
            options = options
        })
    else
        ShowNotification(type, message, duration, options)
    end
end

-- Main queue processor
Citizen.CreateThread(function()
    while true do
        ProcessNotificationQueue()
        Citizen.Wait(100)
    end
end)

-- Exports
exports('Notify', function(type, message, duration, options)
    QueueNotification(type, message, duration, options)
end)

exports('Success', function(message, duration, options)
    QueueNotification('success', message, duration, options)
end)

exports('Error', function(message, duration, options)
    QueueNotification('error', message, duration, options)
end)

exports('Info', function(message, duration, options)
    QueueNotification('info', message, duration, options)
end)

exports('Warning', function(message, duration, options)
    QueueNotification('warning', message, duration, options)
end)

exports('Remove', function(notificationId)
    RemoveNotification(notificationId)
end)

exports('Clear', function()
    SendNUIMessage({ action = 'clearNotifications' })
    ActiveNotifications = {}
    NotificationQueue = {}
end)

-- Server-triggered notifications
RegisterNetEvent('plush:notify')
AddEventHandler('plush:notify', function(type, message, duration, options)
    QueueNotification(type, message, duration, options)
end)

-- Framework-specific exports (for compatibility)
Citizen.CreateThread(function()
    Wait(2000) -- Wait for framework detection
    if Framework == 'qb' then
        RegisterNetEvent('QBCore:Notify')
        AddEventHandler('QBCore:Notify', function(message, type, duration)
            QueueNotification(type or 'info', message, duration)
        end)
    elseif Framework == 'qbox' then
        -- QBox notification events
        RegisterNetEvent('qbx:notify')
        AddEventHandler('qbx:notify', function(message, type, duration)
            QueueNotification(type or 'info', message, duration)
        end)
        
        RegisterNetEvent('QBox:Notify')
        AddEventHandler('QBox:Notify', function(message, type, duration)
            QueueNotification(type or 'info', message, duration)
        end)
        
        -- QBox also uses similar pattern to QBCore sometimes
        RegisterNetEvent('qbx_core:client:notify')
        AddEventHandler('qbx_core:client:notify', function(message, type, duration)
            QueueNotification(type or 'info', message, duration)
        end)
    elseif Framework == 'esx' then
        RegisterNetEvent('esx:showNotification')
        AddEventHandler('esx:showNotification', function(message, type, duration)
            QueueNotification(type or 'info', message, duration)
        end)
    end
end)

-- Test command: Shows all notification types and UI variations for testing
RegisterCommand('testnotifications', function()
    local delay = 1500 -- Delay between each notification
    
    -- 1. Success notification
    exports['plush-notifications']:Success('This is a success notification!', Config.DefaultDuration)
    Citizen.Wait(delay)
    
    -- 2. Error notification
    exports['plush-notifications']:Error('This is an error notification!', Config.DefaultDuration)
    Citizen.Wait(delay)
    
    -- 3. Info notification
    exports['plush-notifications']:Info('This is an info notification!', Config.DefaultDuration)
    Citizen.Wait(delay)
    
    -- 4. Warning notification
    exports['plush-notifications']:Warning('This is a warning notification!', Config.DefaultDuration)
    Citizen.Wait(delay)
       
    print('[Plush Notifications] Test sequence complete! Use /clearnotify to clear all.')
end, false)

-- Clear notifications command (use plush_clearnotify if clearnotify conflicts with another resource)
RegisterCommand('clearnotify', function()
    SendNUIMessage({ action = 'clearNotifications' })
    ActiveNotifications = {}
    NotificationQueue = {}
    print('[Plush Notifications] All notifications cleared.')
end, false)

RegisterCommand('plush_clearnotify', function()
    SendNUIMessage({ action = 'clearNotifications' })
    ActiveNotifications = {}
    NotificationQueue = {}
    print('[Plush Notifications] All notifications cleared.')
end, false)

-- NUI Callbacks
RegisterNUICallback('notificationRemoved', function(data, cb)
    if data.id and ActiveNotifications[data.id] then
        ActiveNotifications[data.id] = nil
    end
    cb('ok')
end)

RegisterNUICallback('notificationClicked', function(data, cb)
    -- Can be extended for click handlers
    cb('ok')
end)

-- Initialize NUI
Citizen.CreateThread(function()
    Wait(1000)
    SendNUIMessage({
        action = 'init',
        config = {
            position = Config.Position,
            offsetX = Config.OffsetX,
            offsetY = Config.OffsetY,
            spacing = Config.Spacing,
            theme = Config.Theme,
            autoTheme = Config.AutoTheme,
            animationDuration = Config.AnimationDuration,
            animationType = Config.AnimationType,
            maxNotifications = Config.MaxNotifications,
            soundEnabled = Config.SoundEnabled,
            soundVolume = Config.SoundVolume,
            customSound = Config.CustomSound
        }
    })
end)
