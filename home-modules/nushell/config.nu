$env.config = {
  show_banner: false,
  edit_mode: vi
  keybindings: [
    {
      name: change_dir_with_yazi
      modifier: CONTROL
      keycode: Char_o
      mode: [vi_insert vi_normal]
      event: {
        send: ExecuteHostCommand
        cmd: "ya"
      }
    }
    {
      name: completion_down
      modifier: CONTROL
      keycode: Char_j
      mode: vi_insert
      event: {
        until: [
          { send: Menu name: completion_menu }
          { send: MenuDown }
        ]
      }
    }
    {
      name: completion_up
      modifier: CONTROL
      keycode: Char_k
      mode: vi_insert
      event: { send: MenuUp }
    }
    {
      name: completion_left
      modifier: CONTROL
      keycode: Char_h
      mode: vi_insert
      event: { send: MenuLeft }
    }
    {
      name: completion_right
      modifier: CONTROL
      keycode: Char_l
      mode: vi_insert
      event: {
        until: [
          { send: MenuRight }
          { send: HistoryHintComplete }
          { send: ClearScreen }

        ]
      }
    }
  ]
}

# Remove this after release 24.05, and use programs.yazi.enableNushellIntegration = true instead
def --env ya [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXX")
  yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp)
  if $cwd != "" and $cwd != $env.PWD {
    cd $cwd
  }
  rm -fp $tmp
}
