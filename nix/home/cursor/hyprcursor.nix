{
  runCommand,
  hyprcursor,
  xcur2png,
  adwaita-icon-theme,
}:

runCommand "lilpa-hyprcursor"
  {
    nativeBuildInputs = [
      hyprcursor
      xcur2png
    ];
  }
  ''
    # XCursor's Inherits=Adwaita is not part of the Hyprcursor format.
    # Include those shapes before overlaying the custom Lilpa cursors.
    mkdir LilpaTheme
    cp -r ${adwaita-icon-theme}/share/icons/Adwaita/cursors LilpaTheme/cursors
    chmod -R u+w LilpaTheme
    cp --remove-destination ${./LilpaTheme}/cursors/* LilpaTheme/cursors/
    # hyprcursor-util treats every regular file here as an XCursor.
    rm LilpaTheme/cursors/README.md

    hyprcursor-util --extract LilpaTheme --output . --resize nearest
    cat > extracted_LilpaTheme/manifest.hl <<'EOF'
    name = LilpaTheme-Hyprcursor
    description = Custom Lilpa Cursors (Hyprcursor)
    version = 1.0
    cursors_directory = hyprcursors
    EOF
    hyprcursor-util --create extracted_LilpaTheme --output .

    mkdir -p "$out/share/icons"
    mv theme_LilpaTheme-Hyprcursor "$out/share/icons/LilpaTheme-Hyprcursor"
  ''
