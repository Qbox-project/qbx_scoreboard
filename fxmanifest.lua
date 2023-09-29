fx_version 'cerulean'
game 'gta5'

description 'QB-Scoreboard'
version '1.0.1'

ui_page 'html/ui.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/import.lua',
    'config.lua',
}
client_script 'client.lua'
server_script 'server.lua'

files {
    'html/*'
}

modules {
    'qbx_core:utils'
}

lua54 'yes'
