local spawn = require("awful.spawn")

spawn.with_shell("kdeconnected")
spawn.once("fcitx5 -d")
spawn.once("copyq --start-server")
