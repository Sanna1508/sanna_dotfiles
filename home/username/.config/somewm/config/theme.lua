local beautiful = require("beautiful")

beautiful.init((os.getenv("HOME") .. "/.config") .. "/somewm/config/theme_catpuccin.lua")

beautiful.screenshot_frame_color = beautiful.fg_focus

beautiful.font = "MapleMonoNFCN 8 semibold"

beautiful.notification_width = 400
-- beautiful.notification_max_width = 200
-- beautiful.notification_max_height = 200
beautiful.notification_opacity = 0.9

-- animation
beautiful.animation_appear_duration = 0.06
beautiful.animation_disappear_duration = 0.1

beautiful.animation_maximize_duration = 0.2

beautiful.animation_focus_duration = 0.1
beautiful.animation_tag = "none"

beautiful.dpi_rounded_corner = 8
-- layout
beautiful.useless_gap = 5

-- casrousel layout
beautiful.carousel_default_column_width = 0.75
beautiful.animation_layout_duration = 0.3
beautiful.carousel_center_mode = "on-overflow"
-- beautiful.carousel_peek_width = 10
-- beautiful.carousel_dynamic_peek_width = 40
