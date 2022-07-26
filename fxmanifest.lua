fx_version 'adamant'

game 'gta5'

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua"
}

client_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'client/client.lua',
    'client/cl_coffre.lua',
    'client/cl_boss.lua',
    'client/cl_vestiaire.lua',
    'client/cl_garage.lua',
    'client/cl_fire.lua'
  

}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'server/server.lua',
    'server/sv_fire.lua',
    'config.lua'
}

dependencies {
    'es_extended'
}
