fx_version 'cerulean'
game 'gta5'

description 'QBX_Scoreboard'
version '1.0.1'

ui_page 'html/ui.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/utils.lua',
    'config.lua',
}
client_script 'client.lua'
server_script 'server.lua'

files {
    'html/*'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'