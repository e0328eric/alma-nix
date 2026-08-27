-- ======================================================================
-- theme.lua  -  colors and the status bar
--
-- Two things live here:
--   * an optional syntax color theme loaded from a file, and
--   * the status line, returned as a list of styled segments.
--
-- A segment is { text = "...", fg = "#rrggbb" | "blue", bg = ..., bold = }.
-- A { flex = true } segment is a spacer that shares the leftover width, so
-- one gives left/right and two give left/center/right.
-- ======================================================================

-- ---------- syntax color theme ----------
-- A flat .toml/.json mapping color names (red, green, blue, purple, yellow,
-- grey, orange, fg, ...) to "#rrggbb". The editor hands us the config dir in
-- ae.config_dir, so this loads colorscheme.json sitting next to this file.
if ae.config_dir then
    ae.load_theme(ae.config_dir .. "colorscheme.json")
end

-- ---------- palette ----------
local C = {
    bg      = "#24283b",
    blue    = "#7aa2f7",
    magenta = "#bb9af7",
    green   = "#9ece6a",
    cyan    = "#7dcfff",
    grey    = "#565f89",
    fg      = "#c0caf5",
}

local function seg(text, fg, bold) return { text = text, fg = fg, bold = bold } end
local function flex() return { flex = true } end
local function icon(cp) return utf8.char(cp) end  -- Nerd Font glyph by codepoint

-- ---------- status bar ----------
ae.set_statusline(function()
    local m = ae.mode()
    local mode_fg = (m == "INSERT" and C.green)
        or (m == "VISUAL" and C.magenta)
        or C.blue
    local star = ae.modified() and " *" or ""
    local l, c = ae.cursor()
    local lsp = ae.lsp_status()
    if lsp == "" then lsp = "No LSP" end
    local branch = ae.git_branch()
    local ft = ae.filetype()

    local segs = {
        { text = " ", bg = C.blue },
        seg(" " .. m:sub(1, 1) .. " ", mode_fg, true),
        seg(" " .. ae.filename() .. star .. "  ", C.magenta, true),
        seg(l .. ":" .. c .. "   ", C.grey, false),
        seg(ae.scroll_label() .. " ", C.fg, true),
        flex(),
        seg(icon(0x2699) .. " " .. lsp, C.fg, true),  -- gear
        flex(),
        seg(ae.encoding() .. "  ", C.green, true),
        seg(ae.eol() .. "  ", C.grey, false),
    }
    if ft ~= "" then
        segs[#segs + 1] = seg(icon(0xf15b) .. " " .. ft .. "  ", C.cyan, false)
    end
    if branch ~= "" then
        segs[#segs + 1] = seg(icon(0xe0a0) .. " " .. branch .. " ", C.magenta, true)
    end
    segs[#segs + 1] = { text = " ", bg = C.blue }
    return segs
end)

-- ---------- file-tree bar (shown when the tree is open) ----------
ae.set_filetree_statusline(function()
    return {
        { text = " ", bg = C.green },
        seg("  files  ", C.green, true),
        flex(),
        seg(ae.filetree_selected() .. " ", C.fg, false),
        { text = " ", bg = C.green },
    }
end)
