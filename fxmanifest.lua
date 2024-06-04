fx_version 'cerulean'
game 'gta5'

description 'qbx_scoreboard'
repository 'https://github.com/Qbox-project/qbx_scoreboard'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
}

client_scripts {
    'config/client.lua',
    'client/*.lua'
}

server_scripts {
    'config/server.lua',
    'server/*.lua'
}

ui_page 'html/ui.html'

files {
    'html/*',
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'
