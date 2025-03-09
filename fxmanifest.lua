fx_version 'cerulean'
game 'gta5'

author 'Mike'
description 'Duty selection menu'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    'server.lua',
    'webhook.lua' 
}

client_scripts {
    'client.lua'
}

dependencies {
    'ox_lib'
}

lua54 'yes'
