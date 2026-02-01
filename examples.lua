-- Example usage file for Plush Notifications
-- This file is for reference only and is not required for the resource to work

-- ============================================
-- CLIENT-SIDE EXAMPLES
-- ============================================

-- Basic notifications
Citizen.CreateThread(function()
    Wait(2000)
    
    -- Simple success notification
    exports['plush-notifications']:Success('Welcome to the server!')
    
    Wait(3000)
    
    -- Error notification with duration
    exports['plush-notifications']:Error('Connection failed', 4000)
    
    Wait(3000)
    
    -- Info notification
    exports['plush-notifications']:Info('New update available', 5000)
    
    Wait(3000)
    
    -- Warning notification
    exports['plush-notifications']:Warning('Low fuel warning!', 3000)
end)

-- Advanced example: Custom notification
RegisterCommand('testnotify', function()
    exports['plush-notifications']:Notify('info', 'This is a custom notification!', 5000, {
        title = 'Custom Title',
        icon = 'bell',
        color = '#8b5cf6',
        position = 'top-left'
    })
end, false)

-- Example: Persistent notification that can be removed
RegisterCommand('persistent', function()
    local notifId = exports['plush-notifications']:Info('This notification stays until removed', 0, {
        title = 'Persistent',
        icon = 'info'
    })
    
    -- Remove after 10 seconds
    Citizen.SetTimeout(10000, function()
        exports['plush-notifications']:Remove(notifId)
    end)
end, false)

-- Example: Clear all notifications
RegisterCommand('clearnotify', function()
    exports['plush-notifications']:Clear()
end, false)

-- ============================================
-- SERVER-SIDE EXAMPLES
-- ============================================

-- Example: Notify player on command
RegisterCommand('notifyplayer', function(source, args)
    local message = table.concat(args, ' ')
    if message == '' then
        message = 'Hello from server!'
    end
    exports['plush-notifications']:Notify(source, 'success', message, 5000)
end, false)

-- Example: Notify player on resource start
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Notify all players
        local players = GetPlayers()
        for _, playerId in ipairs(players) do
            exports['plush-notifications']:Info(tonumber(playerId), 'Resource ' .. resourceName .. ' has started!')
        end
    end
end)

-- Example: Framework integration (QBCore)
-- This works automatically if QBCore is detected
-- TriggerEvent('QBCore:Notify', 'Hello!', 'success', 5000)

-- Example: Framework integration (QBox)
-- This works automatically if QBox is detected
-- Multiple event patterns are supported:
-- TriggerEvent('qbx:notify', 'Hello!', 'success', 5000)
-- TriggerEvent('QBox:Notify', 'Hello!', 'info', 5000)
-- TriggerEvent('qbx_core:client:notify', 'Hello!', 'warning', 5000)

-- Example: Framework integration (ESX)
-- This works automatically if ESX is detected
-- TriggerEvent('esx:showNotification', 'Hello!', 'info', 5000)
