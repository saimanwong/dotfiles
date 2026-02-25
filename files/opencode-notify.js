export const NotifyPlugin = async ({ $ }) => {
  // Capture the tmux window name at startup
  let paneLabel = ""
  if (process.env.TMUX && process.env.TMUX_PANE) {
    try {
      const fmt = "#I:#W"
      paneLabel = (
        await $`tmux display-message -p -t ${process.env.TMUX_PANE} ${fmt}`.nothrow().text()
      ).trim()
    } catch {}
  }

  const notify = async (title, message) => {
    // macOS system notification (terminal-notifier auto-prompts for permission on first run)
    const args = ['-message', message, '-title', title, '-timeout', '30', '-sound', 'default']
    if (paneLabel) args.push('-subtitle', paneLabel)
    await $`terminal-notifier ${args}`.nothrow()

    // tmux: show floating popup + bell
    if (process.env.TMUX && process.env.TMUX_PANE) {
      const windowIndex = paneLabel.split(':')[0]
      const popupCmd = `printf "\\n  \\033[1;33m${message}\\033[0m\\n  \\033[2m${paneLabel}\\033[0m\\n\\n  \\033[2m[Enter] go to window  [Ctrl-C] dismiss\\033[0m\\n\\n" && read -r -t 30 && tmux select-window -t :${windowIndex}`
      await $`tmux display-popup -E -b rounded -S ${'fg=colour214,bold'} -s ${'fg=colour255,bg=colour235'} -T ${'  OpenCode  '} -w 50 -h 9 ${popupCmd}`.nothrow()
      process.stdout.write("\x07")
    }
  }

  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        await notify("OpenCode", "Done - waiting for input")
      } else if (event.type === "permission.asked") {
        await notify("OpenCode", "Needs your approval")
      }
    },
  }
}
