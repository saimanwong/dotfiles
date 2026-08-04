import { clearPaneBusy, clearPaneBusySync, markPaneBusy } from "./tmux-window-activity.mjs"

export const NotifyPlugin = async ({ $ }) => {
  // Capture the tmux window label at startup
  let paneLabel = ""
  let windowIndex = ""
  if (process.env.TMUX && process.env.TMUX_PANE) {
    try {
      const fmt = "#I:#W"
      paneLabel = (
        await $`tmux display-message -p -t ${process.env.TMUX_PANE} ${fmt}`.nothrow().text()
      ).trim().replace(/^0:[\u2800-\u28FF\s]+.*/, '0:ORCH')
      windowIndex = paneLabel.split(':')[0]
    } catch {}
  }

  const termAppName = "Alacritty"

  let latestMessage = ""
  let isBusy = false

  const setThinking = async () => {
    if (!process.env.TMUX || !process.env.TMUX_PANE || isBusy) return
    isBusy = true
    latestMessage = ""
    await markPaneBusy(process.env.TMUX_PANE, "opencode", { pid: process.pid })
  }

  const clearThinking = async () => {
    if (!process.env.TMUX || !process.env.TMUX_PANE || !isBusy) return
    isBusy = false
    await clearPaneBusy(process.env.TMUX_PANE, "opencode")
  }

  const notify = async (title, message, detail = "") => {
    await clearThinking()

    if (process.env.TMUX && windowIndex) {
      await $`tmux set-window-option -t :${windowIndex} window-status-style fg=colour232,bg=colour214,bold`.nothrow()
      await $`tmux refresh-client -S`.nothrow()
    }

    const preview = detail ? detail.replace(/\n+/g, ' ').trim().slice(0, 100) : ""
    const args = ['-message', preview || message, '-title', title, '-sound', 'default']
    if (paneLabel) args.push('-subtitle', paneLabel)
    if (termAppName && windowIndex) {
      args.push('-execute', `open -a ${JSON.stringify(termAppName)}`)
    }
    await $`terminal-notifier ${args}`.quiet().nothrow()

    if (process.env.TMUX && windowIndex) {
      const isActive = (await $`tmux display-message -p -t :${windowIndex} ${'#{window_active}'}`.nothrow().text()).trim() === "1"
      if (!isActive) {
        const safePreview = preview.replace(/[\\"$`]/g, '').slice(0, 60)
        const previewLine = safePreview ? `\n  \\033[0m${safePreview}` : ""
        const popupCmd = `printf "\n  \\033[1;33m${message}\\033[0m${previewLine}\n  \\033[2m${paneLabel}\\033[0m\n\n  \\033[2m[Enter] go to window  [Ctrl-C] dismiss\\033[0m\n\n" && read -r -t 30 && tmux select-window -t :${windowIndex}`
        const popupHeight = safePreview ? 11 : 9
        await $`tmux display-popup -E -b rounded -S ${'fg=colour214,bold'} -s ${'fg=colour255,bg=colour235'} -T ${'  OpenCode  '} -w 50 -h ${popupHeight} ${popupCmd}`.nothrow()
      }
    }
  }

  // Synchronous marker cleanup on process exit; the shared watcher removes the
  // aggregate frame only after every live pane owner has cleared.
  const cleanup = () => {
    if (!process.env.TMUX || !process.env.TMUX_PANE) return
    clearPaneBusySync(process.env.TMUX_PANE, "opencode")
  }

  process.on('exit', cleanup)
  process.on('SIGINT', () => { cleanup(); process.exit(130) })
  process.on('SIGTERM', () => { cleanup(); process.exit(143) })

  return {
    event: async ({ event }) => {
      if (event.type === "message.part.updated") {
        const part = event.properties?.part
        if (part?.type === "text" && part?.text) {
          latestMessage = part.text.trim()
        }
      } else if (event.type === "session.idle") {
        await notify("OpenCode", "Done - waiting for input", latestMessage)
      } else if (event.type === "session.status" && event.properties?.status?.type === "busy") {
        await setThinking()
      } else if (event.type === "question.asked") {
        const questionText = event.properties?.questions?.map(q => q.question).join(" / ") || ""
        await notify("OpenCode", "Waiting for your input", questionText)
      } else if (event.type === "permission.asked") {
        await notify("OpenCode", "Needs your approval", latestMessage)
      }
    },
  }
}
