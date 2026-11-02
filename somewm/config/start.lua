local spawn = require("awful.spawn")

spawn.once("kdeconnectd")
spawn.once("fcitx5 -d")
spawn.once("copyq --start-server")
