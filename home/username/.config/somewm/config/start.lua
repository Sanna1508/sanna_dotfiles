local spawn = require("awful.spawn")

spawn.once("kdeconnectd")
spawn.once("fcitx5 fcitx5")
spawn.once("copyq --start-server")
spawn.once("wlsunset -S 6:30 -s 17:30 -t 5000 -T 6500")
spawn.once("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &")
