local M = {}
local home = os.getenv("HOME")

M.mainmod = "SUPER"
M.terminal = "kitty"
M.filemanager = "nemo"
M.applauncher = "vicinae toggle"
M.browser = "brave --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime"
M.private_browser = "brave --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --incognito"

M.scripts = home .. "/.config/alma-scripts"

return M
