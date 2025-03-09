local webhookURL = "your_webhook" -- Replace with your actual webhook URL
local guildID = "your_guild_id" -- Replace with your actual Discord Guild ID

function sendDutyLog(playerName, department, callsign, status)
    local embed = {
        {
            ["title"] = "Clockin",
            ["description"] = "**Player:** " .. playerName ..  
                             "\n**Department:** " .. department ..  
                             "\n**Callsign:** " .. callsign ..  
                             "\n**Status:** " .. status,
            ["color"] = status == "On Duty" and 65280 or 16711680, -- Green for on duty, red for off duty
            ["footer"] = {
                ["text"] = "Guild ID: " .. guildID,
            }
        }
    }

    PerformHttpRequest(webhookURL, function(err, text, headers) end, "POST", json.encode({
        username = "Duty Logger",
        embeds = embed
    }), { ["Content-Type"] = "application/json" })
end
