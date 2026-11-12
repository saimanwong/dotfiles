-- Keep Rex defaults, including cmd+k for the session picker.

rex.bind("ctrl+h", "pane.focus", { direction = "left" })
rex.bind("ctrl+j", "pane.focus", { direction = "down" })
rex.bind("ctrl+k", "pane.focus", { direction = "up" })
rex.bind("ctrl+l", "pane.focus", { direction = "right" })

-- tmux: ~/.tmux.conf:32-34
rex.bind("ctrl+b>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+b>shift+'", "pane.split", { direction = "down" })
rex.bind("ctrl+b>c", "client.tab.new")
rex.bind("ctrl+b>n", "client.tab.next")
rex.bind("ctrl+b>p", "client.tab.previous")
rex.bind("ctrl+b>s", "pane.go_to")
rex.bind("ctrl+b>z", "pane.zoom")

-- Send the prefix itself to the terminal by pressing it twice.
rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })
