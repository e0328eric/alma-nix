-- ======================================================================
-- lsp.lua  -  language server configuration
--
-- ae.lsp_config(language, {
--     command    = "<server binary on your PATH>",
--     args       = { ... },          -- optional launch arguments
--     extensions = { "ext", ... },   -- file extensions that start it
-- })
--
-- The server starts lazily the first time you open a matching file, so an
-- entry whose binary you have not installed is harmless until then (you'll
-- just see an error in ae.lsp_status() when you open that file type).
--
-- Install the binaries yourself; ae does not bundle them. In the editor,
-- `:lsp restart | stop | enable | disable` controls the running servers, `K`
-- shows hover (put the cursor on a symbol), diagnostics appear inline, and
-- `<space>F` (or `:format`) formats the buffer via the server's formatter.
--
-- Debugging: launch with AE_LSP_LOG=/path/to/lsp.log to capture the server's
-- own stderr to that file - useful when a server "says ready" but produces no
-- hover or diagnostics (the log usually explains why).
-- ======================================================================

ae.lsp_config("rust", {
    command    = "rust-analyzer",
    args       = {},
    extensions = { "rs" },
})

ae.lsp_config("zig", {
    command    = "zls",
    args       = {},
    extensions = { "zig" },
})