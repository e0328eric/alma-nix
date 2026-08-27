-- ======================================================================
-- ae configuration entry point (init.lua)
--
-- This file does three things:
--   1. sets editor options,
--   2. locates the config directory this file lives in,
--   3. loads the split-out modules:
--        keybindings.lua   - your key overrides (defaults are baked in)
--        theme.lua         - colors + status bar (+ optional color theme)
--        snippet.lua       - snippet definitions (rust / tex / latex / vesti)
--        lsp.lua           - language server configuration
--
-- Default keybindings are baked into the binary and always installed first,
-- so keybindings.lua only needs the keys you want to change, not the full set.
--
-- Put this whole folder at one of (checked in this order):
--   $AE_CONFIG_DIR                 (set the env var to point anywhere)
--   <project>/.ae/                 (project-local; found by searching upward)
--   ~/.config/ae/  (Linux)  |  %APPDATA%\ae\  (Windows)  |
--   ~/Library/Application Support/ae/  (macOS)
-- ======================================================================

-- ---------- editor options ----------
ae.set_number("hybrid")     -- "none" | "absolute" | "relative" | "hybrid"
ae.set_scrolloff(3)         -- keep N lines of context above/below the cursor
ae.set_colorcolumn(90)      -- 0 = off; e.g. 80 tints column 80
ae.set_textwidth(0)         -- 0 = off; e.g. 80 hard-wraps typed text at 80
ae.set_autoindent(true)     -- new lines inherit the previous line's indent
ae.set_format_on_save(true) -- format via the language server on write
ae.set_wrap(true)           -- soft wrap

-- the second parameter denoting the filetype (the extension of the file)
-- with comma separated. (e.g. "rs" or "rs,py")
ae.set_colorcolumn(80, "ves")
ae.set_textwidth(80, "ves")

-- ---------- locate this config's directory ----------
-- The editor hands us the config directory in `ae.config_dir` (with a
-- trailing separator), so loading sibling files is reliable with no
-- guessing. If you are on an older build that does not set it, we fall back
-- to probing the standard per-OS config locations.
local SEP = package.config:sub(1, 1)

local function file_exists(p)
    local f = io.open(p, "r")
    if f then f:close() return true end
    return false
end

local function probe_dir()
    local home = os.getenv("HOME") or os.getenv("USERPROFILE") or "."
    local cands = {}
    if SEP == "\\" then
        local appdata = os.getenv("APPDATA") or (home .. "\\AppData\\Roaming")
        cands[#cands + 1] = appdata .. "\\ae\\"
    else
        local xdg = os.getenv("XDG_CONFIG_HOME")
        if xdg and #xdg > 0 then cands[#cands + 1] = xdg .. "/ae/" end
        cands[#cands + 1] = home .. "/.config/ae/"                      -- Linux
        cands[#cands + 1] = home .. "/Library/Application Support/ae/"  -- macOS
    end
    for _, d in ipairs(cands) do
        if file_exists(d .. "init.lua") then return d end
    end
    return cands[1]
end

local DIR = ae.config_dir or probe_dir()

local report = {}
if ae.config_dir then
    report[#report + 1] = "dir(ae.config_dir)=" .. tostring(ae.config_dir)
else
    report[#report + 1] = "dir(probed)=" .. tostring(DIR)
        .. " [old binary: ae.config_dir is nil]"
end

local function load_module(name)
    local path = DIR .. name
    if not file_exists(path) then
        report[#report + 1] = name .. ": MISSING at " .. path
        return
    end
    local ok, err = pcall(dofile, path)
    report[#report + 1] = name .. (ok and ": ok" or (": ERR " .. tostring(err)))
end

load_module("keybindings.lua")
load_module("languages.lua")
load_module("theme.lua")
load_module("snippet.lua")
load_module("lsp.lua")

-- ---------- optional: extra tree-sitter grammars ----------
-- Language servers are configured in lsp.lua (loaded above).
-- ae.add_language{ extensions = { "ves" }, grammar = "rust" }  -- rough highlight for .ves

-- Show the load report so the state is always visible. Once everything reads
-- "ok" you can replace this with your own message.
-- ae.message(table.concat(report, "\n"))
