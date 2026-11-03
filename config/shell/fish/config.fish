switch (uname)
    case Linux
        source $HOME/.config/fish/os/linux.fish
    case Darwin
        source $HOME/.config/fish/os/darwin.fish
    case Windows
        source ./os/windows.fish
end

# Match dark_theme in ~/.config/nushell/config.nu. Global values override
# the older theme settings that may still exist as universal variables.
set --global fish_color_normal white
set --global fish_color_command cyan
set --global fish_color_builtin cyan --bold
set --global fish_color_function cyan --bold
set --global fish_color_keyword cyan --bold
set --global fish_color_param green --bold
set --global fish_color_option blue --bold
set --global fish_color_quote green
set --global fish_color_redirection magenta --bold
set --global fish_color_end magenta --bold
set --global fish_color_error white --background=red --bold
set --global fish_color_operator yellow
set --global fish_color_escape cyan --bold
set --global fish_color_comment brblack
set --global fish_color_autosuggestion brblack
set --global fish_color_valid_path cyan
set --global fish_color_match --underline
set --global fish_color_search_match white --background=red
set --global fish_color_selection --reverse
set --global fish_color_history_current --bold
set --global fish_color_cancel --reverse

# Colors for Fish's default prompt, matching Nushell's env.nu.
set --global fish_color_cwd green --bold
set --global fish_color_cwd_root red --bold
set --global fish_color_status red --bold
set --global fish_color_user brgreen
set --global fish_color_host normal
set --global fish_color_host_remote yellow

# Match Nushell's completion menus: green text, yellow descriptions,
# underlined matches, and reverse-video selection.
set --global fish_pager_color_completion green
set --global fish_pager_color_description yellow
set --global fish_pager_color_prefix green --underline
set --global fish_pager_color_progress yellow
set --global fish_pager_color_background normal
set --global fish_pager_color_selected_background --reverse
set --global fish_pager_color_selected_completion green --reverse
set --global fish_pager_color_selected_description yellow --reverse
set --global fish_pager_color_selected_prefix green --underline --reverse
