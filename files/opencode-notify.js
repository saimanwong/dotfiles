export const NotifyPlugin = async ({ $ }) => {
  // Capture the tmux window index and name at startup
  let paneLabel = ""
  let originalWindowName = ""
  let windowIndex = ""
  if (process.env.TMUX && process.env.TMUX_PANE) {
    try {
      const fmt = "#I:#W"
      paneLabel = (
        await $`tmux display-message -p -t ${process.env.TMUX_PANE} ${fmt}`.nothrow().text()
      ).trim()
      windowIndex = paneLabel.split(':')[0]
      originalWindowName = paneLabel.split(':').slice(1).join(':')
        // Strip any leftover spinner braille prefixes from the window name
        // in case a previous instance died without cleanup and left e.g.
        // "⢿ ⡿ ORCHESTRATOR" as the window title.
        .replace(/^[\u2800-\u28FF\s]+/, '')
    } catch {}
  }

  const termAppName = "Alacritty"

  let latestMessage = ""
  let spinnerInterval = null
  let isBusy = false
  const frames = ['⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷']
  let frameIndex = 0

  // Kill any orphaned spinner subprocess left behind by a previous opencode
  // instance that crashed or was killed without cleanup.
  const killOrphanSpinner = async () => {
    if (!process.env.TMUX || !windowIndex) return
    const str = (await $`tmux show-window-option -t :${windowIndex} -v @opencode_spinner_pid`.nothrow().text()).trim()
    const pid = parseInt(str) || 0
    if (pid) {
      try { process.kill(pid) } catch {}
      await $`tmux set-window-option -t :${windowIndex} -u @opencode_spinner_pid`.nothrow()
    }
  }

  // Clean up orphans from previous sessions on startup
  await killOrphanSpinner()

  const setThinking = async () => {
    if (!process.env.TMUX || !windowIndex) return
    if (isBusy) return
    isBusy = true
    latestMessage = ""

    if (spinnerInterval) return

    // Use setInterval instead of a subprocess — the interval is tied to
    // this process's event loop so it can never become an orphan.
    spinnerInterval = setInterval(async () => {
      const frame = frames[frameIndex++ % frames.length]
      await $`tmux rename-window -t :${windowIndex} ${frame + ' ' + originalWindowName}`.nothrow()
    }, 150)
    // Mark that we own the spinner (for the exit handler)
    await $`tmux set-window-option -t :${windowIndex} @opencode_busy 1`.nothrow()
  }

  const clearThinking = async () => {
    if (!process.env.TMUX || !windowIndex) return
    if (!isBusy) return
    isBusy = false

    if (spinnerInterval !== null) {
      clearInterval(spinnerInterval)
      spinnerInterval = null
      await $`tmux rename-window -t :${windowIndex} ${originalWindowName}`.nothrow()
      await $`tmux set-window-option -t :${windowIndex} -u @opencode_busy`.nothrow()
    }
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
        const previewLine = safePreview ? `\n  \033[0m${safePreview}` : ""
        const popupCmd = `printf "\n  \033[1;33m${message}\033[0m${previewLine}\n  \033[2m${paneLabel}\033[0m\n\n  \033[2m[Enter] go to window  [Ctrl-C] dismiss\033[0m\n\n" && read -r -t 30 && tmux select-window -t :${windowIndex}`
        const popupHeight = safePreview ? 11 : 9
        await $`tmux display-popup -E -b rounded -S ${'fg=colour214,bold'} -s ${'fg=colour255,bg=colour235'} -T ${'  OpenCode  '} -w 50 -h ${popupHeight} ${popupCmd}`.nothrow()
      }
    }
  }

  // Synchronous cleanup when the opencode process exits (Ctrl+C, crash,
  // quit while busy, etc.).  Since the spinner is a setInterval (not a
  // subprocess), it dies with this process automatically.  We just need
  // to restore the tmux window name and clear the busy flag.
  const cleanup = () => {
    if (!process.env.TMUX || !windowIndex) return
    try {
      if (spinnerInterval) {
        clearInterval(spinnerInterval)
        spinnerInterval = null
      }
      Bun.spawnSync(['tmux', 'set-window-option', '-t', `:${windowIndex}`, '-u', '@opencode_busy'])
      Bun.spawnSync(['tmux', 'rename-window', '-t', `:${windowIndex}`, originalWindowName])
    } catch {}
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
