fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'ori(us3rrrr.)'
description 'Trading Script using ox_lib'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'

dependencies {
    'ox_lib'
}
