{ ... }:
''
  # Keep Wine prefix initialization progress dialogs from interrupting typing.
  window_rule = app_id:(?i)^wineboot[.]exe$,title:^Wine$,is_floating:1,is_open_silent:1,no_focus:1
''
