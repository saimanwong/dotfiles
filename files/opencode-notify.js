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
  let spinnerProc = null
  let isBusy = false

  // Check if a PID is still alive
  const isAlive = (pid) => {
    try { process.kill(pid, 0); return true } catch { return false }
  }

  // Get the stored spinner PID from tmux (shared across instances)
  const getStoredSpinnerPid = async () => {
    const str = (await $`tmux show-window-option -t :${windowIndex} -v @opencode_spinner_pid`.nothrow().text()).trim()
    return parseInt(str) || 0
  }

  const setThinking = async () => {
    if (!process.env.TMUX || !windowIndex) return
    if (isBusy) return
    isBusy = true
    latestMessage = ""

    // Check if another instance already has a live spinner running
    const existingPid = await getStoredSpinnerPid()
    if (existingPid && isAlive(existingPid)) return

    // No live spinner -- kill the dead one's PID entry if stale, then spawn
    if (existingPid) {
      await $`tmux set-window-option -t :${windowIndex} -u @opencode_spinner_pid`.nothrow()
    }

    spinnerProc = Bun.spawn(
      ['sh', '-c', `while true; do for f in ⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷; do tmux rename-window -t :${windowIndex} "$f ${originalWindowName}"; sleep 0.15; done; done`],
      { stdout: 'ignore', stderr: 'ignore' }
    )
    await $`tmux set-window-option -t :${windowIndex} @opencode_spinner_pid ${spinnerProc.pid}`.nothrow()
  }

  const clearThinking = async () => {
    if (!process.env.TMUX || !windowIndex) return
    if (!isBusy) return
    isBusy = false

    // Kill our spinner if we own it
    if (spinnerProc !== null) {
      spinnerProc.kill()
      spinnerProc = null
      await $`tmux set-window-option -t :${windowIndex} -u @opencode_spinner_pid`.nothrow()
      await $`tmux rename-window -t :${windowIndex} ${originalWindowName}`.nothrow()
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
    await $`terminal-notifier ${args}`.nothrow()

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
  // quit while busy, etc.) so the spinner shell loop doesn't become an
  // orphan that keeps renaming the tmux window forever.
  process.on('exit', () => {
    if (!process.env.TMUX || !windowIndex) return
    try {
      if (spinnerProc) {
        spinnerProc.kill()
        spinnerProc = null
        Bun.spawnSync(['tmux', 'set-window-option', '-t', `:${windowIndex}`, '-u', '@opencode_spinner_pid'])
        Bun.spawnSync(['tmux', 'rename-window', '-t', `:${windowIndex}`, originalWindowName])
      }
    } catch {}
  })

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
