local spawn = require("awful.spawn")

-- spawn.with_shell("picom -b")
spawn.once("kdeconnectd")
spawn.once("fcitx5 fcitx5")
spawn.once("copyq --start-server")
spawn.once("wlsunset -S 6:30 -s 17:30 -t 5000 -T 6500")
