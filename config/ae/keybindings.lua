-- ======================================================================
-- keybindings.lua  -  all key maps (a practical vim-like subset)
--
-- A binding is a lua function calling one or more ae.* primitives. Key
-- specs support nested sequences ("gg" = g then g, "<C-w>s" = ctrl-w then
-- s). The 4th arg to map() is the description shown in the palette/help.
-- ======================================================================

local function map(keys, mode, fn, desc) ae.keybinding(keys, mode, fn, desc) end
local BS = string.char(92) -- a single backslash

-- run fn() once per count prefix (3w -> word_forward x3). Bare motion = 1.
local function rep(fn) for _ = 1, ae.count() do fn() end end

-- ---------- motions ----------
map("h", "normal", function() ae.move_cursor("left", ae.count()) end, "left")
map("j", "normal", function() ae.move_cursor("down", ae.count()) end, "down")
map("k", "normal", function() ae.move_cursor("up", ae.count()) end, "up")
map("l", "normal", function() ae.move_cursor("right", ae.count()) end, "right")
map("<left>", "normal", function() ae.move_cursor("left", ae.count()) end, "left")
map("<down>", "normal", function() ae.move_cursor("down", ae.count()) end, "down")
map("<up>", "normal", function() ae.move_cursor("up", ae.count()) end, "up")
map("<right>", "normal", function() ae.move_cursor("right", ae.count()) end, "right")
map("w", "normal", function() rep(ae.word_forward) end, "word forward")
map("b", "normal", function() rep(ae.word_backward) end, "word back")
map("e", "normal", function() rep(ae.word_end) end, "word end")
map("W", "normal", function() rep(ae.big_word_forward) end, "WORD forward")
map("B", "normal", function() rep(ae.big_word_backward) end, "WORD back")
map("E", "normal", function() rep(ae.big_word_end) end, "WORD end")
map("0", "normal", function() ae.line_start() end, "line start (column 0)")
map("^", "normal", function() ae.line_first_nonblank() end, "first non-blank")
map("$", "normal", function() ae.line_end() end, "line end")
-- gg / G honor a count as a line number (5G -> line 5), like vim.
map("gg", "normal", function() if ae.has_count() then ae.goto_line(ae.count()) else ae.file_start() end end, "file start / NNgg")
map("G", "normal", function() if ae.has_count() then ae.goto_line(ae.count()) else ae.file_end() end end, "file end / NNG")
-- scrolling moves the VIEWPORT by a fraction of the window height and takes
-- the cursor with it, keeping its row; <C-e>/<C-y> leave the cursor put.
map("<C-d>", "normal", function() ae.scroll("half-down") end, "half page down")
map("<C-u>", "normal", function() ae.scroll("half-up") end, "half page up")
map("<C-f>", "normal", function() ae.scroll("page-down") end, "page down")
map("<C-b>", "normal", function() ae.scroll("page-up") end, "page up")
map("<C-e>", "normal", function() ae.scroll("line-down") end, "scroll one line down")
map("<C-y>", "normal", function() ae.scroll("line-up") end, "scroll one line up")
map("H", "normal", function() ae.screen_line("top") end, "top of window")
map("M", "normal", function() ae.screen_line("middle") end, "middle of window")
map("L", "normal", function() ae.screen_line("bottom") end, "bottom of window")
map("<C-d>", "visual", function() ae.scroll("half-down") end, "half page down")
map("<C-u>", "visual", function() ae.scroll("half-up") end, "half page up")
-- zt / zz / zb : cursor line to top / center / bottom of the window
map("zt", "normal", function() ae.scroll_cursor("top") end, "cursor line to top")
map("zz", "normal", function() ae.scroll_cursor("center") end, "cursor line to center")
map("zb", "normal", function() ae.scroll_cursor("bottom") end, "cursor line to bottom")
-- manual folds. NOTE: a fold is a line range, so all folds are dropped when
-- an edit changes how many lines the buffer has (see README).
map("zf", "normal", function() ae.fold_create() end, "fold [count] lines")
map("zf", "visual", function() ae.fold_create() end, "fold the selection")
map("zo", "normal", function() ae.fold_open() end, "open fold")
map("zc", "normal", function() ae.fold_close() end, "close fold")
map("za", "normal", function() ae.fold_toggle() end, "toggle fold")
map("zd", "normal", function() ae.fold_delete() end, "delete fold")
map("zR", "normal", function() ae.fold_open_all() end, "open all folds")
map("zM", "normal", function() ae.fold_close_all() end, "close all folds")
-- K : LSP hover (a floating box; j/k or <C-e>/<C-y> scroll, any key dismisses)
map("K", "normal", function() ae.hover() end, "lsp hover")
map("gd", "normal", function() ae.goto_definition() end, "lsp goto definition")
-- display-line motions for soft-wrapped lines: move by screen rows / cells
map("gj", "normal", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_down() end end, "display line down")
map("gk", "normal", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_up() end end, "display line up")
map("gh", "normal", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_left() end end, "display char left")
map("gl", "normal", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_right() end end, "display char right")
map("g<down>", "normal", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_down() end end, "display line down")
map("g<up>", "normal", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_up() end end, "display line up")
map("g<left>", "normal", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_left() end end, "display char left")
map("g<right>", "normal", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_right() end end, "display char right")
-- <space>l... : LSP actions (rename, format, list diagnostics)
map("<space>lr", "normal", function() ae.rename() end, "lsp rename symbol")
map("<space>lf", "normal", function() ae.format() end, "lsp format buffer")
map("<space>ll", "normal", function() ae.diagnostics_list() end, "lsp list diagnostics")
-- find char on the line: f/F/t/T then a character; ; and , repeat it
map("f", "normal", function() ae.find_char("f") end, "find char forward")
map("F", "normal", function() ae.find_char("F") end, "find char backward")
map("t", "normal", function() ae.find_char("t") end, "till char forward")
map("T", "normal", function() ae.find_char("T") end, "till char backward")
map(";", "normal", function() ae.find_repeat("same") end, "repeat find")
map(",", "normal", function() ae.find_repeat("reverse") end, "repeat find reversed")
map("%", "normal", function() ae.match_pair() end, "matching bracket")
map("{", "normal", function() ae.paragraph_backward() end, "paragraph back")
map("}", "normal", function() ae.paragraph_forward() end, "paragraph forward")
map("(", "normal", function() ae.sentence_backward() end, "sentence back")
map(")", "normal", function() ae.sentence_forward() end, "sentence forward")
map("|", "normal", function() ae.goto_column() end, "go to column")
map("ge", "normal", function() rep(ae.word_end_back) end, "back to word end")
map("gE", "normal", function() rep(ae.big_word_end_back) end, "back to WORD end")
map("g_", "normal", function() ae.line_last_nonblank() end, "last non-blank")
-- [( [{ ]) ]} : jump to the unmatched bracket delimiting the enclosing block
map("[(", "normal", function() ae.unmatched_bracket("(", "back") end, "unmatched ( before")
map("[{", "normal", function() ae.unmatched_bracket("{", "back") end, "unmatched { before")
map("])", "normal", function() ae.unmatched_bracket("(", "forward") end, "unmatched ) after")
map("]}", "normal", function() ae.unmatched_bracket("{", "forward") end, "unmatched } after")

-- ---------- entering insert ----------
map("i", "normal", function() ae.enter_mode("insert") end, "insert")
map("R", "normal", function() ae.enter_mode("replace") end, "replace")
-- `a` uses the dedicated append step: a plain right motion stops on the last
-- character in normal mode (as vim's `l` does), which is one column short of
-- where an append has to start.
map("a", "normal", function() ae.append() end, "append")
map("A", "normal", function() ae.line_end(); ae.enter_mode("insert") end, "append at end")
map("I", "normal", function() ae.line_first_nonblank(); ae.enter_mode("insert") end, "insert at start")
map("o", "normal", function() ae.open_newline("below"); ae.enter_mode("insert") end, "open below")
map("O", "normal", function() ae.open_newline("above"); ae.enter_mode("insert") end, "open above")
map("<C-\\>", "normal", function() ae.open_newline("above"); ae.enter_mode("insert") end, "open above")
map("<C-\\>", "insert", function() ae.open_newline("above"); ae.enter_mode("insert") end, "open above")

map("<left>", "insert", function() ae.move_cursor("left", ae.count()) end, "left")
map("<down>", "insert", function() ae.move_cursor("down", ae.count()) end, "down")
map("<up>", "insert", function() ae.move_cursor("up", ae.count()) end, "up")
map("<right>", "insert", function() ae.move_cursor("right", ae.count()) end, "right")

-- ---------- changes / deletes ----------
map("x", "normal", function() rep(ae.delete_forward) end, "delete char")
map("r", "normal", function() ae.replace_char() end, "replace char")
map("X", "normal", function() rep(ae.delete_char_before) end, "delete char before")
-- Real operators. `d`, `c`, `y`, `>`, `<`, `=`, `gu`, `gU`, `g~` and `gq` each
-- wait for a motion or text object, so dj, d}, dG, dgg, df,, dtx, d2w, 2dw,
-- de, db, dW, ciw, di(, ya", >j, gUiw ... all work without a binding apiece.
-- The doubled form (dd, cc, yy, >>, guu) is linewise, as in vim.
map("d", "normal", function() ae.operator("delete") end, "delete operator")
map("c", "normal", function() ae.operator("change") end, "change operator")
map("y", "normal", function() ae.operator("yank") end, "yank operator")
map(">", "normal", function() ae.operator("indent") end, "indent operator")
map("<", "normal", function() ae.operator("dedent") end, "dedent operator")
map("=", "normal", function() ae.operator("reindent") end, "re-indent operator")
map("gu", "normal", function() ae.operator("lower") end, "lowercase operator")
map("gU", "normal", function() ae.operator("upper") end, "uppercase operator")
map("g~", "normal", function() ae.operator("toggle_case") end, "swap-case operator")
map("gq", "normal", function() ae.operator("format") end, "reflow operator")
-- operator shorthands
map("D", "normal", function() ae.delete_to_line_end() end, "delete to end of line")
map("C", "normal", function() ae.delete_to_line_end(); ae.enter_mode("insert") end, "change to end of line")
map("s", "normal", function() rep(ae.delete_forward); ae.enter_mode("insert") end, "substitute char")
map("S", "normal", function() ae.change_line() end, "substitute line (keeps indent)")
map("~", "normal", function() ae.toggle_case_char() end, "swap case of the character")
map("J", "normal", function() local n = ae.count(); if n < 2 then n = 2 end; for _ = 1, n - 1 do ae.join_lines() end end, "join lines")
map("u", "normal", function() rep(ae.undo) end, "undo")
map("<C-r>", "normal", function() rep(ae.redo) end, "redo")
map(".", "normal", function() ae.repeat_change() end, "repeat last change")
map("<C-a>", "normal", function() ae.increment() end, "increment number")
map("<C-x>", "normal", function() ae.decrement() end, "decrement number")

-- ---------- yank / paste ----------
-- neovim's default Y is y$ (yank to end of line), not yy.
map("Y", "normal", function() ae.yank_to_line_end() end, "yank to end of line")
map("p", "normal", function() ae.paste(ae.count()) end, "paste")
map("P", "normal", function() ae.paste_before(ae.count()) end, "paste before")
-- "x selects a register for the next yank / delete / paste ("a, "0-"9, "-, "+)
map('"', "normal", function() ae.await_register() end, "select register")
map('"', "visual", function() ae.await_register() end, "select register")
-- marks and the jump list
map("m", "normal", function() ae.set_mark() end, "set mark")
map("`", "normal", function() ae.goto_mark() end, "go to mark")
map("'", "normal", function() ae.goto_mark_line() end, "go to mark line")
map("<C-o>", "normal", function() ae.jump_back() end, "jump back")
map("<C-i>", "normal", function() ae.jump_forward() end, "jump forward")
map("g;", "normal", function() ae.change_back() end, "previous change position")
map("g,", "normal", function() ae.change_forward() end, "next change position")
-- macros: q is close-view in this config, so recording lives on Q (see README)
map("Q", "normal", function() ae.record_macro() end, "record macro (Q again to stop)")
map("@", "normal", function() ae.play_macro() end, "play macro (@@ repeats)")
map("<space>y", "normal", function() ae.yank_clipboard() end, "yank line to clipboard")
map("<space>p", "normal", function() ae.paste_clipboard() end, "paste from clipboard")
map("<space>P", "normal", function() ae.paste_clipboard_above() end, "paste from clipboard above")

-- ---------- visual mode ----------
map("v", "normal", function() ae.enter_visual("char") end, "visual")
map("V", "normal", function() ae.enter_visual("line") end, "visual line")
map("<C-v>", "normal", function() ae.enter_visual("block") end, "visual block")
map("<esc>", "visual", function() ae.enter_mode("normal") end, "leave visual")
map("h", "visual", function() ae.move_cursor("left", ae.count()) end, "extend left")
map("j", "visual", function() ae.move_cursor("down", ae.count()) end, "extend down")
map("k", "visual", function() ae.move_cursor("up", ae.count()) end, "extend up")
map("l", "visual", function() ae.move_cursor("right", ae.count()) end, "extend right")
map("<left>", "visual", function() ae.move_cursor("left", ae.count()) end, "left")
map("<down>", "visual", function() ae.move_cursor("down", ae.count()) end, "down")
map("<up>", "visual", function() ae.move_cursor("up", ae.count()) end, "up")
map("<right>", "visual", function() ae.move_cursor("right", ae.count()) end, "right")
map("g<down>", "visual", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_down() end end, "display line down")
map("g<up>", "visual", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_up() end end, "display line up")
map("g<left>", "visual", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_left() end end, "display char left")
map("g<right>", "visual", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_right() end end, "display char right")
map("w", "visual", function() rep(ae.word_forward) end, "extend word")
map("b", "visual", function() rep(ae.word_backward) end, "extend word back")
map("e", "visual", function() rep(ae.word_end) end, "extend word end")
map("0", "visual", function() ae.line_start() end, "extend to col 0")
map("^", "visual", function() ae.line_first_nonblank() end, "extend to first non-blank")
map("$", "visual", function() ae.line_end() end, "extend to end")
map("gg", "visual", function() if ae.has_count() then ae.goto_line(ae.count()) else ae.file_start() end end, "file start / NNgg")
map("G", "visual", function() if ae.has_count() then ae.goto_line(ae.count()) else ae.file_end() end end, "file end / NNG")
map("f", "visual", function() ae.find_char("f") end, "extend to char")
map("t", "visual", function() ae.find_char("t") end, "extend till char")
map(";", "visual", function() ae.find_repeat("same") end, "repeat find")
map(",", "visual", function() ae.find_repeat("reverse") end, "repeat find reversed")
map("y", "visual", function() ae.yank(); ae.enter_mode("normal") end, "yank selection")
map("<space>y", "visual", function() ae.yank_clipboard(); ae.enter_mode("normal") end, "yank selection to clipboard")
-- in vim every delete yanks, so visual d / x / c all fill the register
map("d", "visual", function() ae.delete_selection_yank(); ae.enter_mode("normal") end, "yank + delete selection")
map("x", "visual", function() ae.delete_selection_yank(); ae.enter_mode("normal") end, "yank + delete selection")
map("c", "visual", function() ae.delete_selection_yank(); ae.enter_mode("insert") end, "change selection")
map("Q", "visual", function() ae.hard_wrap_selection(); ae.enter_mode("normal") end, "hard-wrap selection")
map(">", "visual", function() ae.indent("in"); ae.enter_mode("normal") end, "indent selection")
map("<", "visual", function() ae.indent("out"); ae.enter_mode("normal") end, "dedent selection")
map("=", "visual", function() ae.operator("reindent") end, "re-indent selection")
map("gu", "visual", function() ae.operator("lower") end, "lowercase selection")
map("gU", "visual", function() ae.operator("upper") end, "uppercase selection")
map("g~", "visual", function() ae.operator("toggle_case") end, "swap case of selection")
map("~", "visual", function() ae.operator("toggle_case") end, "swap case of selection")
map("gq", "visual", function() ae.operator("format") end, "reflow selection")
map("p", "visual", function() ae.visual_paste() end, "replace selection with register")
map("P", "visual", function() ae.visual_paste() end, "replace selection with register")
-- text objects: iw/aw, iW/aW, is/as, ip/ap, i( i[ i{ i< i" i' i` it and the a-forms
map("i", "visual", function() ae.text_object_inner() end, "inner text object")
map("a", "visual", function() ae.text_object_around() end, "a text object")
map("o", "visual", function() ae.swap_visual_ends() end, "swap selection ends")
map("O", "visual", function() ae.swap_visual_ends() end, "swap selection ends")
map("gv", "normal", function() ae.reselect_visual() end, "reselect last visual")
map("I", "visual", function() ae.block_insert() end, "insert on every selected line")
map("A", "visual", function() ae.block_append() end, "append on every selected line")
map("%", "visual", function() ae.match_pair() end, "matching bracket")
map("{", "visual", function() ae.paragraph_backward() end, "paragraph back")
map("}", "visual", function() ae.paragraph_forward() end, "paragraph forward")
-- display-line motions for soft-wrapped lines: move by screen rows / cells
map("gj", "visual", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_down() end end, "display line down")
map("gk", "visual", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_up() end end, "display line up")
map("gh", "visual", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_left() end end, "display char left")
map("gl", "visual", function() local n=ae.has_count() and ae.count() or 1; for _=1,n do ae.display_right() end end, "display char right")

-- ---------- search ----------
map("/", "normal", function() ae.search_forward() end, "search forward")
map("?", "normal", function() ae.search_backward() end, "search backward")
map("n", "normal", function() ae.search_next(ae.count()) end, "next match")
map("N", "normal", function() ae.search_prev(ae.count()) end, "previous match")

-- ---------- multiple cursors and anchors ----------
map("<C-n>", "normal", function() ae.add_cursor_match() end, "select word / add cursor at next match")
map("<C-S-n>", "normal", function() ae.add_cursor_match_prev() end, "add cursor at previous match")
map(BS .. "a", "normal", function() ae.select_all_matches() end, "select all word/symbol matches")
map(BS .. "A", "normal", function() ae.align_cursors() end, "align cursors")
map(BS:rep(3), "normal", function() ae.drop_anchor() end, "drop cursor anchor")
map("g" .. BS, "normal", function() ae.activate_anchors() end, "activate cursor anchors")
map("<C-Down>", "normal", function() ae.add_cursor_below() end, "add cursor below")
map("<C-Up>", "normal", function() ae.add_cursor_above() end, "add cursor above")
map("<esc>", "normal", function() ae.clear_cursors() end, "clear cursors / anchors")

-- ---------- windows ----------
map("<C-w>s", "normal", function() ae.new_window("down") end, "split horizontally")
map("<C-w>v", "normal", function() ae.new_window("right") end, "split vertically")
map("<C-w>w", "normal", function() ae.cycle_window() end, "cycle windows")
map("<C-w>h", "normal", function() ae.focus_window("left") end, "focus left")
map("<C-w>l", "normal", function() ae.focus_window("right") end, "focus right")
map("<C-w>j", "normal", function() ae.focus_window("down") end, "focus below")
map("<C-w>k", "normal", function() ae.focus_window("up") end, "focus above")
map("<C-w><left>", "normal", function() ae.focus_window("left") end, "focus left")
map("<C-w><right>", "normal", function() ae.focus_window("right") end, "focus right")
map("<C-w><down>", "normal", function() ae.focus_window("down") end, "focus below")
map("<C-w><up>", "normal", function() ae.focus_window("up") end, "focus above")
map("<C-w>q", "normal", function() ae.close_window() end, "close window")
map("<C-w>c", "normal", function() ae.close_window() end, "close window")

-- ---------- files, help, palette ----------
map("<space>e", "normal", function() ae.toggle_filetree() end, "toggle file tree")
map("<space>ff", "normal", function() ae.find_files() end, "find files")
map("<space>w", "normal", function() ae.save() end, "save")
map("<space>q", "normal", function() ae.quit() end, "quit")
map("<space>h", "normal", function() ae.help() end, "show help")
map("<space>F", "normal", function() ae.format() end, "format buffer (LSP)")
map("q", "normal", function() ae.close_view() end, "close help / view")
map(":", "normal", function() ae.command_palette() end, "command palette")
map("ZQ", "normal", function() ae.quit() end, "quit")
map("ZZ", "normal", function() ae.save(); ae.quit() end, "save and quit")

-- ---------- buffers ----------
map("<tab>", "normal", function() ae.next_buffer() end, "next buffer")
map("<s-tab>", "normal", function() ae.prev_buffer() end, "previous buffer")
map("<space>bn", "normal", function() ae.next_buffer() end, "next buffer")
map("<space>bp", "normal", function() ae.prev_buffer() end, "previous buffer")
map("<space>bl", "normal", function() ae.buffer_list() end, "list open buffers")
map("<space>bd", "normal", function() ae.close_buffer() end, "close buffer")
map("<space>b/", "normal", function() ae.buffer_search() end, "search all buffers")

-- ---------- insert mode (incl. snippet keys) ----------
map("<esc>", "insert", function() ae.enter_mode("normal") end, "leave insert")
map("<C-c>", "insert", function() ae.enter_mode("normal") end, "leave insert")
map("<C-w>", "insert", function() ae.insert_delete_word_back() end, "delete word before cursor")
map("<C-u>", "insert", function() ae.insert_delete_to_line_start() end, "delete to line start")
map("<C-r>", "insert", function() ae.insert_register() end, "insert a register")
map("<C-o>", "insert", function() ae.insert_one_normal_command() end, "one normal-mode command")
map("<cr>", "insert", function() ae.insert_newline() end, "newline")
map("<bs>", "insert", function() ae.backspace() end, "backspace")
-- <tab>   : expand the snippet before the cursor, else jump to next stop,
--           else insert an indent.   <s-tab> : jump to previous stop.
map("<tab>", "insert", function() ae.snippet_tab() end, "snippet / indent")
map("<s-tab>", "insert", function() ae.snippet_jump_prev() end, "prev tabstop")
-- LSP completion: open the popup; once open, <C-n>/<C-p> or arrows move,
-- <tab>/<cr> accept, <esc> closes. (Ctrl-[ cannot be used: terminals send it
-- as Escape.)
map("<c-]>", "insert", function() ae.complete() end, "LSP complete")
-- <C-v> then hex digits then <cr> inserts the Unicode codepoint (e.g.
-- <C-v>ac00<cr> -> U+AC00). Case of the hex digits does not matter.
map("<c-v>", "insert", function() ae.unicode_input() end, "insert unicode codepoint")
