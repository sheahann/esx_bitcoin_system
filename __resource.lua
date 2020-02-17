resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts{
    'config.lua',
    'client/main-c.lua'
}

ui_page 'html/index.html'

files{
    'html/index.html',
    'html/css/style.css',
    'html/fonts/bitcoin.ttf',
    'html/fonts/bitcoin-bold.ttf',
    'html/images/arrow.png',
    'html/images/bitcointxt.png',
    'html/js/main.js'
}

server_scripts{
    'config.lua',
    'server/main-s.lua',
    '@mysql-async/lib/MySQL.lua'
}