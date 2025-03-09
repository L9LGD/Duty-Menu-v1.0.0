-- Register the /duty command
RegisterCommand("duty", function(source)
    local player = source
    
    -- Get filtered departments based on ACE permissions
    local filteredDepartments = getFilteredDepartments(player)

    if #filteredDepartments == 0 then
        TriggerEvent('ox_lib:notify', {
            title = 'Duty System',
            description = 'You do not have access to any departments.',
            type = 'error',
        })
        return
    end

    -- Step 1: Choose department
    lib.inputDialog('Select Duty Department', {
        {type = 'select', label = 'Choose your department', options = filteredDepartments},
    }, function(input)
        if not input then return end

        local department = input[1]

        -- Step 2: Enter details
        lib.inputDialog('Enter Details', {
            {type = 'input', label = 'Enter your name (e.g. Mike S.)'},
            {type = 'input', label = 'Enter your callsign (e.g. 1B-01 or 101)'}
        }, function(details)
            if not details then return end

            local name = details[1]
            local callsign = details[2]

            if department == "" or name == "" or callsign == "" then
                TriggerEvent('ox_lib:notify', {
                    title = 'Duty System',
                    description = 'All fields must be filled!',
                    type = 'error',
                })
                return
            end

            -- Send duty details to Discord
            sendDutyToDiscord(department, name, callsign)

            -- Confirm duty status
            TriggerServerEvent('duty:confirmDuty', department, name, callsign)
        end)
    end)
end)

-- Function to check ACE permissions
function getFilteredDepartments(player)
    local departments = {
        {value = 'us_dhs', label = 'U.S. DHS', perm = 'duty.us_dhs'},
        {value = 'us_cia', label = 'U.S. CIA', perm = 'duty.us_cia'},
        {value = 'lapd', label = 'LAPD', perm = 'duty.lapd'},
        {value = 'lasd', label = 'LASD', perm = 'duty.lasd'},
        {value = 'bcso', label = 'BCSO', perm = 'duty.bcso'},
    }
    
    local filtered = {}
    for _, dept in ipairs(departments) do
        if IsPlayerAceAllowed(player, dept.perm) then
            table.insert(filtered, {value = dept.value, label = dept.label})
        end
    end
    return filtered
end

-- Function to send duty details to Discord
function sendDutyToDiscord(department, name, callsign)
    local webhookUrl = 'YOUR_DISCORD_WEBHOOK_URL'
    local guildID = "YOUR_GUILD_ID" -- Replace with your actual Guild ID

    local embed = {
        {
            ["color"] = 3447003,
            ["description"] = "**Department:** " .. department ..  
                             "\n**Officer:** " .. name .. " (" .. callsign .. ")",
            ["footer"] = {
                ["text"] = "Guild ID: " .. guildID,
            },
        }
    }
    
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({
        username = "Duty System",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end
