-- Server-side exports for notifications
-- These can be called from other server-side scripts

exports('Notify', function(source, type, message, duration, options)
    TriggerClientEvent('plush:notify', source, type, message, duration, options)
end)

exports('Success', function(source, message, duration, options)
    TriggerClientEvent('plush:notify', source, 'success', message, duration, options)
end)

exports('Error', function(source, message, duration, options)
    TriggerClientEvent('plush:notify', source, 'error', message, duration, options)
end)

exports('Info', function(source, message, duration, options)
    TriggerClientEvent('plush:notify', source, 'info', message, duration, options)
end)

exports('Warning', function(source, message, duration, options)
    TriggerClientEvent('plush:notify', source, 'warning', message, duration, options)
end)

-- Client event handler
RegisterNetEvent('plush:notify')
AddEventHandler('plush:notify', function(type, message, duration, options)
    -- This is handled client-side, but we keep it for consistency
end)
