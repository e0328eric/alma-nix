local ext = ({ linux = "so", macos = "dylib", windows = "dll" })[ae.current_os()]

ae.add_language{
    extensions = { "glo" },
    library = ae.append_path { ae.config_dir, "tree-sitter", "glosso", "glosso." .. ext },
    symbol = "tree_sitter_glosso",
    highlights_file = ae.append_path { ae.config_dir, "tree-sitter", "glosso", "highlights.scm" },
    locals_file = ae.append_path { ae.config_dir, "tree-sitter", "glosso", "locals.scm" },
}

