-- ======================================================================
-- keybindings.lua  -  ae's default keys
--
-- Vim's keys with vim's meaning. What vim has no key for (the file tree,
-- LSP, buffers, the system clipboard, multiple cursors) sits on the
-- leader, <Space>, and on <Bslash>, the keys vim leaves free for user
-- mappings.
--
-- map(keys, mode, fn, desc): keys are in vim notation ("gg", "<C-w>s",
-- "<S-Tab>"); fn calls ae.* functions, or is a string of keys to replay
-- (map("Y", "normal", "y$")); desc is what the help view and the `:`
-- palette show. Modes: normal, visual, insert, replace, command (the `:`
-- palette and the / ? prompts), filetree, hover and completion.
--
-- This file is built into the binary and installed before any config runs,
-- so a user config only needs the keys it changes
-- (ae.clear_keybindings() starts from nothing).
-- ======================================================================

local function map(keys, mode, fn, desc) ae.keybinding(keys, mode, fn, desc) end
-- the same binding in normal and visual mode (motions and operators)
local function nv(keys, fn, desc)
  map(keys, "normal", fn, desc)
  map(keys, "visual", fn, desc)
end
-- run fn [count] times (3w = www); with no count, once
local function rep(fn) return function() for _ = 1, ae.count() do fn() end end end
-- the typed count, or nil when none was typed. Every ae.* action takes an
-- optional trailing count; without one it runs once (`G`, `zt`, `%` and
-- `<C-d>` mean something else with no count at all, hence nil, not 1).
local function cnt() if ae.has_count() then return ae.count() end end

-- ======================================================================
-- Motions (normal and visual)                              :h motion.txt
-- ======================================================================

-- ---------- left-right ----------
nv("h", function() ae.move_cursor("left", ae.count()) end, "left")
nv("l", function() ae.move_cursor("right", ae.count()) end, "right")
nv("<Left>", function() ae.move_cursor("left", ae.count()) end, "left")
nv("<Right>", function() ae.move_cursor("right", ae.count()) end, "right")
-- <BS> / <Space> go on across line ends ('whichwrap' b,s). <Space> is also
-- the leader, so a lone <Space> moves once timeoutlen passes without a
-- second key.
nv("<BS>", function() ae.wrap_left(cnt()) end, "left, across lines")
nv("<Space>", function() ae.wrap_right(cnt()) end, "right, across lines")
nv("0", function() ae.line_start() end, "line start (column 0)")
nv("<Home>", function() ae.line_start() end, "line start")
nv("^", function() ae.line_first_nonblank() end, "first non-blank")
nv("$", function() ae.line_end(cnt()) end, "line end")
nv("<End>", function() ae.line_end() end, "line end")
nv("g_", function() ae.line_last_nonblank() end, "last non-blank")
nv("|", function() ae.goto_column(cnt()) end, "go to column")
-- f/F/t/T then a character; ; and , repeat it
nv("f", function() ae.find_char("f", cnt()) end, "find char forward")
nv("F", function() ae.find_char("F", cnt()) end, "find char backward")
nv("t", function() ae.find_char("t", cnt()) end, "till char forward")
nv("T", function() ae.find_char("T", cnt()) end, "till char backward")
nv(";", function() ae.find_repeat("same", cnt()) end, "repeat find")
nv(",", function() ae.find_repeat("reverse", cnt()) end, "repeat find reversed")

-- ---------- up-down ----------
nv("j", function() ae.move_cursor("down", ae.count()) end, "down")
nv("k", function() ae.move_cursor("up", ae.count()) end, "up")
nv("<Down>", function() ae.move_cursor("down", ae.count()) end, "down")
nv("<Up>", function() ae.move_cursor("up", ae.count()) end, "up")
nv("<C-n>", function() ae.move_cursor("down", ae.count()) end, "down (= j)")
nv("<C-p>", function() ae.move_cursor("up", ae.count()) end, "up (= k)")
nv("+", function() ae.next_line(cnt()) end, "next line, first non-blank")
nv("<CR>", function() ae.next_line(cnt()) end, "next line, first non-blank")
nv("-", function() ae.prev_line(cnt()) end, "previous line, first non-blank")
nv("_", function() ae.current_line(cnt()) end, "first non-blank, [count] - 1 lines down")
-- gg / G take a count as a line number (5G = line 5)
nv("gg", function() if ae.has_count() then ae.goto_line(ae.count()) else ae.file_start() end end, "first line / line [count]")
nv("G", function() if ae.has_count() then ae.goto_line(ae.count()) else ae.file_end() end end, "last line / line [count]")

-- ---------- screen lines (soft-wrapped text) ----------
nv("gj", rep(ae.display_down), "display line down")
nv("gk", rep(ae.display_up), "display line up")
nv("gh", rep(ae.display_left), "display char left")
nv("gl", rep(ae.display_right), "display char right")
nv("g<Down>", rep(ae.display_down), "display line down")
nv("g<Up>", rep(ae.display_up), "display line up")
nv("g<Left>", rep(ae.display_left), "display char left")
nv("g<Right>", rep(ae.display_right), "display char right")
nv("g0", function() ae.screen_line_motion("start") end, "start of screen line")
nv("g^", function() ae.screen_line_motion("first_nonblank") end, "first non-blank of screen line")
nv("gm", function() ae.screen_line_motion("middle") end, "middle of the screen width")
nv("g$", function() ae.screen_line_motion("end") end, "end of screen line")
map("gM", "normal", function() ae.screen_line_motion("half") end, "middle of the line")
map("go", "normal", function() ae.goto_byte(cnt()) end, "go to byte [count]")

-- ---------- words ----------
nv("w", rep(ae.word_forward), "word forward")
nv("b", rep(ae.word_backward), "word back")
nv("e", rep(ae.word_end), "word end")
nv("ge", rep(ae.word_end_back), "back to word end")
nv("W", rep(ae.big_word_forward), "WORD forward")
nv("B", rep(ae.big_word_backward), "WORD back")
nv("E", rep(ae.big_word_end), "WORD end")
nv("gE", rep(ae.big_word_end_back), "back to WORD end")
nv("<S-Left>", rep(ae.word_backward), "word back")
nv("<S-Right>", rep(ae.word_forward), "word forward")

-- ---------- text objects as motions ----------
nv("(", function() ae.sentence_backward(cnt()) end, "sentence back")
nv(")", function() ae.sentence_forward(cnt()) end, "sentence forward")
nv("{", function() ae.paragraph_backward(cnt()) end, "paragraph back")
nv("}", function() ae.paragraph_forward(cnt()) end, "paragraph forward")
nv("%", function() ae.match_pair(cnt()) end, "matching bracket / [count]% of the file")
-- [( [{ ]) ]} : the unmatched bracket around the cursor
map("[(", "normal", function() ae.unmatched_bracket("(", "back") end, "unmatched ( before")
map("[{", "normal", function() ae.unmatched_bracket("{", "back") end, "unmatched { before")
map("])", "normal", function() ae.unmatched_bracket("(", "forward") end, "unmatched ) after")
map("]}", "normal", function() ae.unmatched_bracket("{", "forward") end, "unmatched } after")

-- ---------- the window and scrolling ----------
nv("H", function() ae.screen_line("top", cnt()) end, "top of window")
nv("M", function() ae.screen_line("middle") end, "middle of window")
nv("L", function() ae.screen_line("bottom", cnt()) end, "bottom of window")
-- scrolling moves the view and takes the cursor with it, keeping its row;
-- <C-e> / <C-y> leave the cursor where it is
nv("<C-d>", function() ae.scroll("half-down", cnt()) end, "half page down")
nv("<C-u>", function() ae.scroll("half-up", cnt()) end, "half page up")
nv("<C-f>", function() ae.scroll("page-down", cnt()) end, "page down")
nv("<C-b>", function() ae.scroll("page-up", cnt()) end, "page up")
nv("<C-e>", function() ae.scroll("line-down", cnt()) end, "scroll one line down")
nv("<C-y>", function() ae.scroll("line-up", cnt()) end, "scroll one line up")
nv("<PageDown>", function() ae.scroll("page-down") end, "page down")
nv("<PageUp>", function() ae.scroll("page-up") end, "page up")
nv("<S-Down>", function() ae.scroll("page-down") end, "page down")
nv("<S-Up>", function() ae.scroll("page-up") end, "page up")

-- ---------- marks and jumps ----------
map("m", "normal", function() ae.set_mark() end, "set mark")
nv("`", function() ae.goto_mark() end, "go to mark")
nv("'", function() ae.goto_mark_line() end, "go to mark line")
map("<C-o>", "normal", function() ae.jump_back(cnt()) end, "jump back")
map("<C-i>", "normal", function() ae.jump_forward(cnt()) end, "jump forward")
map("g;", "normal", function() ae.change_back(cnt()) end, "previous change position")
map("g,", "normal", function() ae.change_forward(cnt()) end, "next change position")

-- ---------- search ----------
nv("/", function() ae.search_forward(cnt()) end, "search forward")
nv("?", function() ae.search_backward(cnt()) end, "search backward")
nv("n", function() ae.search_next(ae.count()) end, "next match")
nv("N", function() ae.search_prev(ae.count()) end, "previous match")
nv("gn", function() ae.select_match("forward") end, "select next match")
nv("gN", function() ae.select_match("backward") end, "select previous match")
map("*", "normal", function() ae.search_word("forward", true, cnt()) end, "search word under cursor")
map("#", "normal", function() ae.search_word("backward", true, cnt()) end, "search word under cursor backward")
map("g*", "normal", function() ae.search_word("forward", false, cnt()) end, "search text under cursor")
map("g#", "normal", function() ae.search_word("backward", false, cnt()) end, "search text under cursor backward")

-- ======================================================================
-- Operators (normal and visual)                            :h operator
-- ======================================================================
-- Each waits for a motion or text object (dj, d}, df,, ciw, di(, ya", gUiw
-- ...), and the doubled form (dd, cc, yy, guu) is linewise. In visual mode
-- they act on the selection.
nv("d", function() ae.operator("delete") end, "delete")
nv("c", function() ae.operator("change") end, "change")
nv("y", function() ae.operator("yank") end, "yank")
nv("=", function() ae.operator("reindent") end, "re-indent")
nv("gu", function() ae.operator("lower") end, "lowercase")
nv("gU", function() ae.operator("upper") end, "uppercase")
nv("g~", function() ae.operator("toggle_case") end, "swap case")
nv("gq", function() ae.operator("format") end, "reflow")
nv("gw", function() ae.operator("format_keep") end, "reflow, keep the cursor")
nv("g?", function() ae.operator("rot13") end, "rot13")
nv("g@", function() ae.operator("g@") end, "call the ae.set_operatorfunc function")
nv("zf", function() ae.operator("fold") end, "create a fold")
map(">", "normal", function() ae.operator("indent") end, "indent")
map("<", "normal", function() ae.operator("dedent") end, "dedent")
-- "x picks the register of the next yank / delete / paste ("a, "0-"9, "-, "+)
nv('"', function() ae.await_register() end, "select register")

-- ======================================================================
-- Normal mode
-- ======================================================================

-- ---------- inserting ----------
-- a count repeats the typed text when insert mode is left (3ihi<Esc>, 2o);
-- ae.insert_repeat(n) sets it for the insert just entered
map("i", "normal", function() ae.enter_mode("insert"); ae.insert_repeat(ae.count()) end, "insert")
-- `a` has its own step: in normal mode the cursor stops on the last
-- character, one short of where an append starts
map("a", "normal", function() ae.append(); ae.insert_repeat(ae.count()) end, "append")
map("I", "normal", function() ae.line_first_nonblank(); ae.enter_mode("insert"); ae.insert_repeat(ae.count()) end, "insert at start")
map("A", "normal", function() ae.line_end(); ae.enter_mode("insert"); ae.insert_repeat(ae.count()) end, "append at end")
map("gI", "normal", function() ae.line_start(); ae.enter_mode("insert"); ae.insert_repeat(ae.count()) end, "insert at column 0")
map("gi", "normal", function() ae.insert_at_last_insert(); ae.insert_repeat(ae.count()) end, "insert where insert mode was left")
map("o", "normal", function() ae.open_newline("below"); ae.enter_mode("insert"); ae.insert_repeat(ae.count()) end, "open below")
map("O", "normal", function() ae.open_newline("above"); ae.enter_mode("insert"); ae.insert_repeat(ae.count()) end, "open above")
map("R", "normal", function() ae.enter_mode("replace"); ae.insert_repeat(ae.count()) end, "replace mode")

-- ---------- simple changes ----------
map("x", "normal", function() ae.delete_forward(cnt()) end, "delete char")
map("X", "normal", function() ae.delete_char_before(cnt()) end, "delete char before")
map("r", "normal", function() ae.replace_char(cnt()) end, "replace char")
map("s", "normal", function() ae.delete_forward(cnt()); ae.enter_mode("insert") end, "substitute char")
map("S", "normal", function() ae.change_line(cnt()) end, "substitute line (keeps indent)")
map("D", "normal", function() ae.delete_to_line_end(cnt()) end, "delete to end of line")
map("C", "normal", function() ae.change_to_line_end(cnt()) end, "change to end of line")
-- Neovim's Y is y$, not yy
map("Y", "normal", function() ae.yank_to_line_end(cnt()) end, "yank to end of line")
map("~", "normal", function() ae.toggle_case_char(cnt()) end, "swap case of the character")
map("J", "normal", function() ae.join_lines(math.max(ae.count(), 2) - 1) end, "join lines")
map("gJ", "normal", function() ae.join_lines_raw(cnt()) end, "join lines without spaces")
map("<C-a>", "normal", function() ae.increment(cnt()) end, "increment number")
map("<C-x>", "normal", function() ae.decrement(cnt()) end, "decrement number")
map("&", "normal", function() ae.repeat_substitute(false) end, "repeat last :s on this line")
map("g&", "normal", function() ae.repeat_substitute(true) end, "repeat last :s on every line")

-- ---------- put ----------
map("p", "normal", function() ae.paste(ae.count()) end, "paste")
map("P", "normal", function() ae.paste_before(ae.count()) end, "paste before")
map("gp", "normal", function() ae.paste_end(ae.count()) end, "paste, cursor after it")
map("gP", "normal", function() ae.paste_before_end(ae.count()) end, "paste before, cursor after it")
map("]p", "normal", function() ae.paste_indent(ae.count()) end, "paste with the current line's indent")
map("[p", "normal", function() ae.paste_before_indent(ae.count()) end, "paste above with the current line's indent")
map("]P", "normal", function() ae.paste_before_indent(ae.count()) end, "paste above with the current line's indent")
map("[P", "normal", function() ae.paste_before_indent(ae.count()) end, "paste above with the current line's indent")

-- ---------- undo, redo, repeat ----------
map("u", "normal", rep(ae.undo), "undo")
map("<C-r>", "normal", rep(ae.redo), "redo")
map("U", "normal", function() ae.undo_line() end, "undo the changes on the last changed line")
-- g- / g+ walk the undo tree in time order, across branches
map("g-", "normal", function() ae.undo_time(-ae.count()) end, "older text state")
map("g+", "normal", function() ae.undo_time(ae.count()) end, "newer text state")
map(".", "normal", function() ae.repeat_change(cnt()) end, "repeat last change")

-- ---------- macros ----------
-- q{reg} records (q again stops), @{reg} plays, @@ and Q replay the last
-- recorded one (Neovim's Q)
map("q", "normal", function() ae.record_macro() end, "record macro (q again to stop)")
map("@", "normal", function() ae.play_macro(nil, cnt()) end, "play macro (@@ repeats)")
map("Q", "normal", function() ae.play_last_recording(cnt()) end, "replay the last recorded macro")

-- ---------- visual mode ----------
map("v", "normal", function() ae.enter_visual("char", cnt()) end, "visual")
map("V", "normal", function() ae.enter_visual("line", cnt()) end, "visual line")
map("<C-v>", "normal", function() ae.enter_visual("block", cnt()) end, "visual block")
map("gv", "normal", function() ae.reselect_visual() end, "reselect last visual")

-- ---------- scrolling relative to the cursor (z) ----------
map("zt", "normal", function() ae.scroll_cursor("top", cnt()) end, "cursor line to top")
map("zz", "normal", function() ae.scroll_cursor("center", cnt()) end, "cursor line to center")
map("zb", "normal", function() ae.scroll_cursor("bottom", cnt()) end, "cursor line to bottom")
map("z<CR>", "normal", function() ae.scroll_cursor("top-nonblank", cnt()) end, "cursor line to top, first non-blank")
map("z.", "normal", function() ae.scroll_cursor("center-nonblank", cnt()) end, "cursor line to center, first non-blank")
map("z-", "normal", function() ae.scroll_cursor("bottom-nonblank", cnt()) end, "cursor line to bottom, first non-blank")
-- with 'wrap' off: by [count] columns, by half a window, or to put the
-- cursor at the left / right edge
map("zl", "normal", function() ae.scroll("col-right", cnt()) end, "scroll view right")
map("zh", "normal", function() ae.scroll("col-left", cnt()) end, "scroll view left")
map("z<Right>", "normal", function() ae.scroll("col-right", cnt()) end, "scroll view right")
map("z<Left>", "normal", function() ae.scroll("col-left", cnt()) end, "scroll view left")
map("zL", "normal", function() ae.scroll("half-right", cnt()) end, "scroll view half a screen right")
map("zH", "normal", function() ae.scroll("half-left", cnt()) end, "scroll view half a screen left")
map("zs", "normal", function() ae.scroll_cursor("cursor-left") end, "cursor column to left edge")
map("ze", "normal", function() ae.scroll_cursor("cursor-right") end, "cursor column to right edge")

-- ---------- folds ----------
-- manual folds only. A fold is a line range, so all folds are dropped when
-- an edit changes the number of lines (see README).
map("zF", "normal", function() ae.fold_create(cnt()) end, "fold [count] lines")
map("zo", "normal", function() ae.fold_open() end, "open fold")
map("zc", "normal", function() ae.fold_close() end, "close fold")
map("za", "normal", function() ae.fold_toggle() end, "toggle fold")
map("zd", "normal", function() ae.fold_delete() end, "delete fold")
map("zR", "normal", function() ae.fold_open_all() end, "open all folds")
map("zM", "normal", function() ae.fold_close_all() end, "close all folds")
for _, k in ipairs({ "zE", "zD", "zv", "zi", "zn", "zN", "zx", "zX", "zO", "zC", "zA", "zj", "zk", "[z", "]z" }) do
  map(k, "normal", function() ae.fold(k, cnt()) end, "fold: " .. k)
end

-- ---------- files, buffers, info ----------
-- (legacy terminals send Ctrl-^ as Ctrl-6; ae reads both as <C-^>)
map("<C-^>", "normal", function() ae.alternate_buffer() end, "alternate buffer")
-- (not <Tab>: a terminal sends <Tab> for <C-i>, jump forward)
map("]b", "normal", function() ae.next_buffer() end, "next buffer")
map("[b", "normal", function() ae.prev_buffer() end, "previous buffer")
map("gf", "normal", function() ae.open_file_under_cursor() end, "edit the file under the cursor")
map("gx", "normal", function() ae.open_url_under_cursor() end, "open the URL / path under the cursor")
map("<C-g>", "normal", function() ae.file_info() end, "file info")
map("g<C-g>", "normal", function() ae.cursor_info() end, "cursor position statistics")
map("ga", "normal", function() ae.char_info() end, "character code under the cursor")
map("g8", "normal", function() ae.char_bytes() end, "UTF-8 bytes under the cursor")
map("<C-l>", "normal", function() ae.redraw() end, "redraw the screen")
-- LSP, on the keys Neovim gives it: K hover (j/k or <C-e>/<C-y> scroll the
-- box, any other key closes it), gd go to definition
map("K", "normal", function() ae.hover() end, "lsp hover")
map("gd", "normal", function() ae.goto_definition() end, "lsp goto definition")

-- ---------- command line, quitting ----------
-- `:` opens the command line (typed text runs as an ex command; <Tab> picks
-- a suggested action). A count gives a range: 3: is :.,.+2
map(":", "normal", function()
  if ae.has_count() then
    local n = ae.count()
    ae.command_palette(n == 1 and "." or (".,.+" .. (n - 1)))
  else
    ae.command_palette()
  end
end, "command line")
-- ZZ is :x (write if changed, then close the window), ZQ is :q!
map("ZZ", "normal", function() ae.write_quit_window(true) end, "write if changed and quit window")
map("ZQ", "normal", function() ae.quit_window(true) end, "quit window without saving")
map("<Esc>", "normal", function() ae.clear_cursors() end, "clear cursors / anchors / search highlight")

-- ======================================================================
-- Visual mode (the motions and operators are above)        :h visual.txt
-- ======================================================================
-- v / V / <C-v> switch the kind, or leave when it is the same
map("v", "visual", function() ae.enter_visual("char") end, "charwise / leave visual")
map("V", "visual", function() ae.enter_visual("line") end, "linewise / leave visual")
map("<C-v>", "visual", function() ae.enter_visual("block") end, "blockwise / leave visual")
map("<Esc>", "visual", function() ae.enter_mode("normal") end, "leave visual")
map("<C-c>", "visual", function() ae.enter_mode("normal") end, "leave visual")
-- text objects: iw/aw, iW/aW, is/as, ip/ap, i( i[ i{ i< i" i' i` it and a-forms
map("i", "visual", function() ae.text_object_inner() end, "inner text object")
map("a", "visual", function() ae.text_object_around() end, "a text object")
map("o", "visual", function() ae.swap_visual_ends() end, "swap selection ends")
map("O", "visual", function() ae.swap_visual_corner() end, "other corner (block) / swap ends")
-- as in vim every delete yanks, so x and <Del> fill the register like d
map("x", "visual", function() ae.operator("delete") end, "delete selection")
map("<Del>", "visual", function() ae.operator("delete") end, "delete selection")
map("s", "visual", function() ae.operator("change") end, "change selection")
map("r", "visual", function() ae.visual_replace() end, "replace every selected character")
map("~", "visual", function() ae.operator("toggle_case") end, "swap case of selection")
map("u", "visual", function() ae.operator("lower") end, "lowercase selection")
map("U", "visual", function() ae.operator("upper") end, "uppercase selection")
map("J", "visual", function() ae.visual_join() end, "join the selected lines")
map("gJ", "visual", function() ae.visual_join_raw() end, "join the selected lines without spaces")
map(">", "visual", function() ae.indent("in", cnt()); ae.enter_mode("normal") end, "indent selection")
map("<", "visual", function() ae.indent("out", cnt()); ae.enter_mode("normal") end, "dedent selection")
-- whole lines, whatever the selection's kind (D and C: to the line end in
-- a block)
map("D", "visual", function() ae.visual_lines("delete", true) end, "delete the selected lines")
map("X", "visual", function() ae.visual_lines("delete") end, "delete the selected lines")
map("Y", "visual", function() ae.visual_lines("yank") end, "yank the selected lines")
map("C", "visual", function() ae.visual_lines("change", true) end, "change the selected lines")
map("S", "visual", function() ae.visual_lines("change") end, "change the selected lines")
map("R", "visual", function() ae.visual_lines("change") end, "change the selected lines")
map("p", "visual", function() ae.visual_paste(false, cnt()) end, "replace selection with register")
map("P", "visual", function() ae.visual_paste(true, cnt()) end, "replace selection, keep the register")
-- blockwise I / A type on every selected line
map("I", "visual", function() ae.block_insert() end, "insert on every selected line")
map("A", "visual", function() ae.block_append() end, "append on every selected line")
map("<C-a>", "visual", function() ae.visual_increment(1, false, cnt()) end, "increment numbers")
map("<C-x>", "visual", function() ae.visual_increment(-1, false, cnt()) end, "decrement numbers")
map("g<C-a>", "visual", function() ae.visual_increment(1, true, cnt()) end, "increment numbers progressively")
map("g<C-x>", "visual", function() ae.visual_increment(-1, true, cnt()) end, "decrement numbers progressively")
map("*", "visual", function() ae.visual_search("forward", cnt()) end, "search the selected text")
map("#", "visual", function() ae.visual_search("backward", cnt()) end, "search the selected text backward")
-- Neovim's visual Q: replay the last recorded macro on each selected line
map("Q", "visual", function()
  local l1, _, l2 = ae.selection()
  ae.enter_mode("normal")
  if not l1 then return end
  for l = l1, l2 do ae.set_cursor(l, 1); ae.play_last_recording() end
end, "replay the last recorded macro on each selected line")
-- `:` starts the command line on the selected lines, `!` filters them
-- through a shell command
map(":", "visual", function() ae.command_palette("'<,'>") end, "command line on the selection")
map("!", "visual", function() ae.command_palette("'<,'>!") end, "filter the selection")

-- ======================================================================
-- Insert and Replace mode                                  :h insert.txt
-- ======================================================================
map("<Esc>", "insert", function() ae.enter_mode("normal") end, "leave insert")
-- <C-c> leaves without repeating the text for a count, as in vim
map("<C-c>", "insert", function() ae.insert_repeat(1); ae.enter_mode("normal") end, "leave insert")
map("<C-o>", "insert", function() ae.insert_one_normal_command() end, "one normal-mode command")
map("<C-\\><C-o>", "insert", function() ae.insert_one_normal_command_stay() end, "one normal-mode command, cursor kept")
map("<Insert>", "insert", function() ae.enter_mode("replace") end, "switch to Replace mode")

-- ---------- deleting and inserting text ----------
map("<CR>", "insert", function() ae.insert_newline() end, "newline")
map("<BS>", "insert", function() ae.backspace() end, "backspace")
map("<C-h>", "insert", function() ae.backspace() end, "backspace")
map("<Del>", "insert", function() ae.insert_delete_forward() end, "delete the char under the cursor")
map("<C-w>", "insert", function() ae.insert_delete_word_back() end, "delete word before cursor")
map("<C-u>", "insert", function() ae.insert_delete_to_line_start() end, "delete to line start")
map("<C-t>", "insert", function() ae.insert_indent() end, "indent the line by shiftwidth")
map("<C-d>", "insert", function() ae.insert_dedent() end, "dedent the line by shiftwidth")
map("<C-r>", "insert", function() ae.insert_register() end, "insert a register")
map("<C-a>", "insert", function() ae.insert_last_inserted() end, "insert the last inserted text")
map("<C-@>", "insert", function() ae.insert_last_inserted_stop() end, "insert the last inserted text, leave insert")
map("<C-e>", "insert", function() ae.insert_copy_below() end, "insert the char below the cursor")
map("<C-y>", "insert", function() ae.insert_copy_above() end, "insert the char above the cursor")
map("<C-k>", "insert", function() ae.insert_digraph() end, "digraph (<C-k>e: -> ë)")
-- <C-v> / <C-q> insert the next key literally (<C-v><Tab> is a real tab),
-- or a character by code: <C-v>065, <C-v>x41, <C-v>u20ac, <C-v>U0001f600,
-- <C-v>o101
map("<C-v>", "insert", function() ae.insert_literal() end, "insert a key literally / by code")
map("<C-q>", "insert", function() ae.insert_literal() end, "insert a key literally / by code")
map("<C-g>u", "insert", function() ae.insert_break_undo() end, "start a new undoable change")

-- ---------- moving ----------
map("<Left>", "insert", function() ae.move_cursor("left", ae.count()) end, "left")
map("<Right>", "insert", function() ae.move_cursor("right", ae.count()) end, "right")
map("<Up>", "insert", function() ae.move_cursor("up", ae.count()) end, "up")
map("<Down>", "insert", function() ae.move_cursor("down", ae.count()) end, "down")
map("<S-Left>", "insert", function() ae.word_backward() end, "word back")
map("<S-Right>", "insert", function() ae.word_forward() end, "word forward")
map("<C-Left>", "insert", function() ae.word_backward() end, "word back")
map("<C-Right>", "insert", function() ae.word_forward() end, "word forward")
map("<Home>", "insert", function() ae.line_start() end, "line start")
map("<End>", "insert", function() ae.line_end() end, "line end")
map("<C-Home>", "insert", function() ae.file_start(); ae.line_start() end, "start of the file")
map("<C-End>", "insert", function() ae.file_end(); ae.line_end() end, "end of the file")
for _, k in ipairs({ "<PageUp>", "<S-Up>" }) do
  map(k, "insert", function() ae.scroll("page-up") end, "page up")
end
for _, k in ipairs({ "<PageDown>", "<S-Down>" }) do
  map(k, "insert", function() ae.scroll("page-down") end, "page down")
end
-- <C-g>j / <C-g>k : a line down / up, to the column insert started in
for _, k in ipairs({ "j", "<C-j>", "<Down>" }) do
  map("<C-g>" .. k, "insert", function() ae.insert_line_move("down") end, "line down, to the insert start column")
end
for _, k in ipairs({ "k", "<C-k>", "<Up>" }) do
  map("<C-g>" .. k, "insert", function() ae.insert_line_move("up") end, "line up, to the insert start column")
end

-- ---------- completion ----------
-- keywords of this and the other buffers; <C-e> cancels, <C-y> accepts
map("<C-n>", "insert", function() ae.complete_keyword("next") end, "keyword completion")
map("<C-p>", "insert", function() ae.complete_keyword("prev") end, "keyword completion, backward")
map("<C-x><C-n>", "insert", function() ae.complete_keyword("next", "buffer") end, "keyword completion, this buffer")
map("<C-x><C-p>", "insert", function() ae.complete_keyword("prev", "buffer") end, "keyword completion, this buffer, backward")
map("<C-x><C-l>", "insert", function() ae.complete_keyword("prev", "line") end, "whole line completion")
-- the other <C-x> submodes; while one is on, its own key (<C-f>, <C-k>, ...)
-- or <C-n> / <C-p> moves through its matches
for _, m in ipairs({
  { "<C-f>", "file", "file name completion" },
  { "<C-k>", "dictionary", "completion from the 'dictionary' files" },
  { "<C-t>", "thesaurus", "completion from the 'thesaurus' files" },
  { "<C-i>", "include", "keywords of this and the #included files" },
  { "<C-d>", "define", "#define'd names" },
  { "<C-]>", "tag", "tag name completion" },
  { "<C-v>", "cmdline", "ex command-line completion" },
  { "<C-u>", "user", "completion by ae.set_completefunc" },
  { "s", "spell", "spelling suggestions" },
  { "<C-s>", "spell", "spelling suggestions" },
}) do
  local source = m[2]
  map("<C-x>" .. m[1], "insert", function() ae.complete_keyword("next", source) end, m[3])
end
-- <C-x> already ended any completion: <C-x><C-z> just keeps the text
map("<C-x><C-z>", "insert", function() end, "stop completion, keep the text")
-- (as in vim these scroll only while the cursor can stay where it is)
map("<C-x><C-e>", "insert", function()
  if ae.get_cursor() > ae.win_get_top() then ae.scroll("line-down") end
end, "scroll one line down")
map("<C-x><C-y>", "insert", function()
  local h = ae.win_size()
  if ae.get_cursor() < ae.win_get_top() + h - 1 then ae.scroll("line-up") end
end, "scroll one line up")
-- the language server's completion popup: <C-x><C-o> (vim's omni
-- completion) or <C-]>. Once open, <C-n> / <C-p> or the arrows move, <Tab>
-- / <CR> accept, <Esc> closes.
map("<C-x><C-o>", "insert", function() ae.complete() end, "LSP complete")
map("<C-]>", "insert", function() ae.complete() end, "LSP complete")

-- ---------- snippets ----------
-- <Tab> expands the snippet before the cursor, else jumps to the next stop,
-- else inserts an indent; <S-Tab> goes back a stop
map("<Tab>", "insert", function() ae.snippet_tab() end, "snippet / indent")
map("<S-Tab>", "insert", function() ae.snippet_jump_prev() end, "prev tabstop")

-- ---------- Replace mode ----------
-- <Esc>, <BS>, <CR>, the arrows and typed characters are built in
map("<C-c>", "replace", function() ae.enter_mode("normal") end, "leave replace")
map("<Insert>", "replace", function() ae.enter_mode("insert") end, "switch to Insert mode")

-- <C-\><C-n> goes to normal mode from anywhere
for _, mode in ipairs({ "normal", "visual", "insert", "replace" }) do
  map("<C-\\><C-n>", mode, function() ae.enter_mode("normal") end, "normal mode")
end

-- ======================================================================
-- Windows (<C-w>)                                          :h windows.txt
-- ======================================================================
-- A split opens above / to the left and takes the focus (vim without
-- 'splitbelow' / 'splitright'). Most keys also work with Ctrl held on the
-- second key (<C-w><C-v> = <C-w>v) and take a count (3<C-w>w, 10<C-w>+, or
-- <C-w>10+).
local function wincount(fn) return function() fn(ae.has_count() and ae.count() or nil) end end
for _, k in ipairs({ "s", "S", "<C-s>" }) do
  map("<C-w>" .. k, "normal", function() ae.new_window("up") end, "split horizontally")
end
for _, k in ipairs({ "v", "<C-v>" }) do
  map("<C-w>" .. k, "normal", function() ae.new_window("left") end, "split vertically")
end
for _, k in ipairs({ "n", "<C-n>" }) do
  map("<C-w>" .. k, "normal", function() ae.new_empty_window(false) end, "new window, empty buffer")
end
for _, k in ipairs({ "w", "<C-w>" }) do
  map("<C-w>" .. k, "normal", wincount(function(n) if n then ae.focus_window_nr(n) else ae.cycle_window() end end), "next window / Nth window")
end
map("<C-w>W", "normal", wincount(function(n) if n then ae.focus_window_nr(n) else ae.cycle_window_back() end end), "previous window / Nth window")
for _, k in ipairs({ "p", "<C-p>" }) do
  map("<C-w>" .. k, "normal", function() ae.previous_window() end, "last accessed window")
end
for _, k in ipairs({ "t", "<C-t>" }) do
  map("<C-w>" .. k, "normal", function() ae.focus_window_nr(1) end, "top-left window")
end
for _, k in ipairs({ "b", "<C-b>" }) do
  map("<C-w>" .. k, "normal", function() ae.focus_window_nr("last") end, "bottom-right window")
end
for _, d in ipairs({ { "h", "left" }, { "j", "down" }, { "k", "up" }, { "l", "right" } }) do
  map("<C-w>" .. d[1], "normal", function() ae.focus_window(d[2]) end, "focus " .. d[2])
  map("<C-w><C-" .. d[1] .. ">", "normal", function() ae.focus_window(d[2]) end, "focus " .. d[2])
  map("<C-w><" .. d[2] .. ">", "normal", function() ae.focus_window(d[2]) end, "focus " .. d[2])
  map("<C-w>" .. d[1]:upper(), "normal", function() ae.move_window(d[2]) end, "move window to the far " .. d[2])
end
-- terminals without the enhanced keyboard protocol send <C-h> as <BS>
map("<C-w><BS>", "normal", function() ae.focus_window("left") end, "focus left")
-- <C-w>q is :quit (the last window quits ae); <C-w>c is :close (never the last)
for _, k in ipairs({ "q", "<C-q>" }) do
  map("<C-w>" .. k, "normal", function() ae.quit_window() end, "quit window")
end
map("<C-w>c", "normal", function() ae.close_window() end, "close window")
for _, k in ipairs({ "o", "<C-o>" }) do
  map("<C-w>" .. k, "normal", function() ae.only_window() end, "only this window")
end
map("<C-w>=", "normal", function() ae.equalize_windows() end, "make windows equal size")
map("<C-w>+", "normal", function() ae.resize_window("height", ae.count()) end, "taller window")
map("<C-w>-", "normal", function() ae.resize_window("height", -ae.count()) end, "shorter window")
map("<C-w>>", "normal", function() ae.resize_window("width", ae.count()) end, "wider window")
map("<C-w><lt>", "normal", function() ae.resize_window("width", -ae.count()) end, "narrower window")
map("<C-w>_", "normal", wincount(function(n) ae.set_window_size("height", n) end), "set height (default: max)")
map("<C-w>|", "normal", wincount(function(n) ae.set_window_size("width", n) end), "set width (default: max)")
for _, k in ipairs({ "x", "<C-x>" }) do
  map("<C-w>" .. k, "normal", wincount(function(n) ae.exchange_window(n) end), "exchange with next window")
end
for _, k in ipairs({ "r", "<C-r>" }) do
  map("<C-w>" .. k, "normal", function() ae.rotate_windows("down", ae.count()) end, "rotate windows down")
end
map("<C-w>R", "normal", function() ae.rotate_windows("up", ae.count()) end, "rotate windows up")

-- ======================================================================
-- Leader (<Space>): what vim has no key for
-- ======================================================================
map("<Space>w", "normal", function() ae.save() end, "save")
map("<Space>q", "normal", function() ae.quit() end, "quit")
map("<Space>h", "normal", function() ae.help() end, "show help")
map("<Space>e", "normal", function() ae.toggle_filetree() end, "toggle file tree")
map("<Space>ff", "normal", function() ae.find_files() end, "find files")
-- buffers
map("<Space>bn", "normal", function() ae.next_buffer() end, "next buffer")
map("<Space>bp", "normal", function() ae.prev_buffer() end, "previous buffer")
map("<Space>bl", "normal", function() ae.buffer_list() end, "list open buffers")
map("<Space>bd", "normal", function() ae.close_buffer() end, "close buffer")
map("<Space>b/", "normal", function() ae.buffer_search() end, "search all buffers")
-- the system clipboard
map("<Space>y", "normal", function() ae.yank_clipboard() end, "yank line to clipboard")
map("<Space>y", "visual", function() ae.yank_clipboard(); ae.enter_mode("normal") end, "yank selection to clipboard")
map("<Space>p", "normal", function() ae.paste_clipboard() end, "paste from clipboard")
map("<Space>P", "normal", function() ae.paste_clipboard_above() end, "paste from clipboard above")
-- LSP
map("<Space>lr", "normal", function() ae.rename() end, "lsp rename symbol")
map("<Space>lf", "normal", function() ae.format() end, "lsp format buffer")
map("<Space>F", "normal", function() ae.format() end, "format buffer (LSP)")
map("<Space>ll", "normal", function() ae.diagnostics_list() end, "lsp list diagnostics")
-- replace from the cursor (in visual mode: in the selection), asking at each
-- match: y/<Space> replace, n skip, ! all the rest, q stop, ? help. <Space>R
-- takes a vim regexp and :s replacement. (:%s/x/y/gc is the vim way.)
nv("<Space>r", function() ae.query_replace() end, "query replace")
nv("<Space>R", function() ae.query_replace_regexp() end, "query replace regexp")

-- ======================================================================
-- Multiple cursors (<Bslash>, as in vim-visual-multi)
-- ======================================================================
map("<C-n>", "normal", function() ae.add_cursor_match() end, "select word / add cursor at next match")
map("<C-N>", "normal", function() ae.add_cursor_match_prev() end, "add cursor at previous match")
map("<C-Down>", "normal", function() ae.add_cursor_below() end, "add cursor below")
map("<C-Up>", "normal", function() ae.add_cursor_above() end, "add cursor above")
map("<Bslash>a", "normal", function() ae.select_all_matches() end, "select all word/symbol matches")
map("<Bslash>A", "normal", function() ae.align_cursors() end, "align cursors")
map("<Bslash><Bslash><Bslash>", "normal", function() ae.drop_anchor() end, "drop cursor anchor")
map("g<Bslash>", "normal", function() ae.activate_anchors() end, "activate cursor anchors")

-- ======================================================================
-- Overlays
-- ======================================================================

-- ---------- command line: the `:` palette and the / ? prompts ----------
-- unbound printable keys are typed into the input; nothing else is
map("<Esc>", "command", function() ae.cmdline_cancel() end, "cancel")
map("<C-c>", "command", function() ae.cmdline_cancel() end, "cancel")
map("<CR>", "command", function() ae.cmdline_accept() end, "run / accept")
map("<BS>", "command", function() ae.cmdline_backspace() end, "delete a character")
map("<C-h>", "command", function() ae.cmdline_backspace() end, "delete a character")
map("<C-w>", "command", function() ae.cmdline_delete_word() end, "delete a word")
map("<C-u>", "command", function() ae.cmdline_delete_line() end, "delete the input")
map("<C-r>", "command", function() ae.cmdline_insert_register() end, "insert a register")
map("<Tab>", "command", function() ae.cmdline_complete(1) end, "next suggestion / complete")
map("<S-Tab>", "command", function() ae.cmdline_complete(-1) end, "previous suggestion / complete")
map("<Up>", "command", function() ae.cmdline_select(-1) end, "previous item / history")
map("<Down>", "command", function() ae.cmdline_select(1) end, "next item / history")
map("<C-p>", "command", function() ae.cmdline_select(-1) end, "previous item / history")
map("<C-n>", "command", function() ae.cmdline_select(1) end, "next item / history")
map("<C-Up>", "command", function() ae.cmdline_history("older") end, "older history")
map("<C-Down>", "command", function() ae.cmdline_history("newer") end, "newer history")

-- ---------- file tree (while it is open) ----------
map("j", "filetree", function() ae.filetree_move(ae.count()) end, "next entry")
map("k", "filetree", function() ae.filetree_move(-ae.count()) end, "previous entry")
map("<Down>", "filetree", function() ae.filetree_move(ae.count()) end, "next entry")
map("<Up>", "filetree", function() ae.filetree_move(-ae.count()) end, "previous entry")
map("<CR>", "filetree", function() ae.filetree_open() end, "open file / toggle directory")
map("l", "filetree", function() ae.filetree_open() end, "open file / toggle directory")
map("a", "filetree", function() ae.filetree_create_file() end, "new file")
map("A", "filetree", function() ae.filetree_create_dir() end, "new directory")
map("r", "filetree", function() ae.filetree_rename() end, "rename")
map("d", "filetree", function() ae.filetree_delete() end, "delete")
map("q", "filetree", function() ae.filetree_close() end, "close the tree")
map("<Esc>", "filetree", function() ae.filetree_close() end, "close the tree")
map("<Space>e", "filetree", function() ae.toggle_filetree() end, "toggle file tree")
map(":", "filetree", function() ae.command_palette() end, "command line")
-- the tree is the window left of the others: <C-w>l (w, p) goes back to
-- them with the tree left open, <C-w>h from the leftmost window comes back
for _, k in ipairs({ "l", "<C-l>", "<Right>", "w", "<C-w>", "p", "<C-p>" }) do
  map("<C-w>" .. k, "filetree", function() ae.filetree_focus(false) end, "back to the windows")
end
for _, k in ipairs({ "c", "q", "<C-q>" }) do
  map("<C-w>" .. k, "filetree", function() ae.filetree_close() end, "close the tree")
end

-- ---------- LSP hover box (any other key closes it) ----------
map("<Esc>", "hover", function() ae.hover_close() end, "close")
map("j", "hover", function() ae.hover_scroll(1) end, "scroll down")
map("k", "hover", function() ae.hover_scroll(-1) end, "scroll up")
map("<C-e>", "hover", function() ae.hover_scroll(1) end, "scroll down")
map("<C-y>", "hover", function() ae.hover_scroll(-1) end, "scroll up")

-- ---------- LSP completion popup (word characters type through) ----------
map("<Esc>", "completion", function() ae.completion_close() end, "close")
map("<Down>", "completion", function() ae.completion_move(1) end, "next")
map("<Up>", "completion", function() ae.completion_move(-1) end, "previous")
map("<C-n>", "completion", function() ae.completion_move(1) end, "next")
map("<C-p>", "completion", function() ae.completion_move(-1) end, "previous")
map("<Tab>", "completion", function() ae.completion_accept() end, "accept")
map("<CR>", "completion", function() ae.completion_accept() end, "accept")
