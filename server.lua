RegisterServerEvent('duty:confirmDuty')
AddEventHandler('duty:confirmDuty', function(department, name, callsign)
    local src = source

    -- Define department-based ACE permissions
    local departmentPermissions = {
        us_dhs = "duty.dhs",
        us_cia = "duty.cia",
        lapd = "duty.lapd"
    }

    -- Get required permission for the selected department
    local requiredPerm = departmentPermissions[department]

    -- Check if player has permission for the selected department
    if requiredPerm and not IsPlayerAceAllowed(src, requiredPerm) then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Duty System',
            description = 'You do not have permission to access this department.',
            type = 'error',
        })
        return
    end

    print("Duty confirmed: " .. name .. " in department " .. department .. " with callsign " .. callsign)

    -- Send confirmation to client
    TriggerClientEvent('duty:confirmDuty', src, department, name, callsign)
end)
