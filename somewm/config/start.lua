local spawn = require("awful.spawn")

spawn.once("kdeconnected")
spawn.once("fcitx5 -d")
spawn.once("copyq --start-server")
