local spawn = require("awful.spawn")

spawn.with_shell("picom -b")
spawn.once("kdeconnectd")
spawn.once("fcitx5 fcitx5")
spawn.once("copyq --start-server")
