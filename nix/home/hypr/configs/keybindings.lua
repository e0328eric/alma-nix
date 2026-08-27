local var = require("variables")
local mainMod = var.mainmod

local SHIFT = "SHIFT"
local CTRL = "CTRL"
local ALT = "ALT"

local function bind(keylist, cmd, options)
    key_sequence = mainMod
    for _, key in ipairs(keylist) do
        key_sequence = key_sequence .. " + " .. key
    end
    hl.bind(key_sequence, cmd, options)
end

bind({ "return" },              hl.dsp.exec_cmd(var.terminal))
bind({ SHIFT, "return" },       hl.dsp.exec_cmd(var.browser))
bind({ CTRL, SHIFT, "return" }, hl.dsp.exec_cmd(var.private_browser))
bind({ "E" },                   hl.dsp.exec_cmd(var.filemanager))
bind({ SHIFT, "Q" },            hl.dsp.window.close())
bind({ SHIFT, "X" },            hl.dsp.exec_cmd("noctalia msg session lock"))
bind({ "space" },               hl.dsp.exec_cmd(var.applauncher))

-- screenshots
bind({ "S" },        hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen pick"))
bind({ SHIFT, "S" }, hl.dsp.exec_cmd("noctalia msg screenshot-region"))

bind({ "F" },        hl.dsp.window.float())
bind({ SHIFT, "F" }, hl.dsp.window.fullscreen())
bind({ "P" },        hl.dsp.window.pin())

-- Move focus with mainMod + arrow keys
bind({ "left" },  hl.dsp.focus({ direction = "left" }))
bind({ "right" }, hl.dsp.focus({ direction = "right" }))
bind({ "up" },    hl.dsp.focus({ direction = "up" }))
bind({ "down" },  hl.dsp.focus({ direction = "down" }))

bind({ SHIFT, "left" },  hl.dsp.window.swap({ direction = "left" }))
bind({ SHIFT, "right" }, hl.dsp.window.swap({ direction = "right" }))
bind({ SHIFT, "up" },    hl.dsp.window.swap({ direction = "up" }))
bind({ SHIFT, "down" },  hl.dsp.window.swap({ direction = "down" }))

bind({ ALT, SHIFT, "left" },  hl.dsp.window.resize({ x = -10, y = 0 }))
bind({ ALT, SHIFT, "right" }, hl.dsp.window.resize({ x = 10,  y = 0 }))
bind({ ALT, SHIFT, "up" },    hl.dsp.window.resize({ x = 0,   y = -10 }))
bind({ ALT, SHIFT, "down" },  hl.dsp.window.resize({ x = 0,   y = 10 }))

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    bind({ key },        hl.dsp.focus({ workspace = i }))
    bind({ SHIFT, key }, hl.dsp.window.move({ workspace = i }))
end

for i = 11, 20 do
    local key = i % 10 -- 10 maps to key 0
    bind({ CTRL, key },        hl.dsp.focus({ workspace = i }))
    -- bind({ CTRL, SHIFT, key }, hl.dsp.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
bind({ "mouse_down" }, hl.dsp.focus({ workspace = "e+1" }))
bind({ "mouse_up" },   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
bind({ "mouse:272" },        hl.dsp.window.drag(),   { mouse = true })
bind({ SHIFT, "mouse:272" }, hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
