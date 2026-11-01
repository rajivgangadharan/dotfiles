I want you to redesign my Linux desktop to match the reference images I've attached.

Work in four phases. Do not skip ahead, and stop for my approval between each.
Maintain a file called ~/dotfiles/ricing/PLAN.md throughout: after Phase 2 approval, write the
approved plan into it as a checklist, and tick off each item as it's completed.
If this session ever restarts, read ~/dotfiles/ricing/PLAN.md and
~/dotfiles/ricing/claude-rice-log.md first and resume from where they left off.

PHASE 1 — AUDIT (read-only)
Do not modify anything. Determine:

- Distro, version, package manager, desktop environment / window manager,
  display server (X11 or Wayland), shell, GPU driver
- Which config files currently control my desktop's appearance, and where they live
- Which of the tools needed for the target look are already installed
- Whether git is installed
- Whether a snapshot tool exists (timeshift, snapper, or a Btrfs root)

Report all of this to me before doing anything else.

PHASE 2 — PLAN
Research what the reference images use — WM, bar, launcher, terminal, fonts,
icon and GTK themes, compositor. Cite the sources you're basing this on.
If you cannot confidently identify the exact tools from the images, say so
explicitly and propose the closest well-documented equivalents instead —
do not guess and present it as fact.
Then give me:

- A written plan of exactly what you'll change and which files you'll touch
- A list of every package to be installed, with a one-line reason for each
  Wait for my approval, then write the plan into ~/dotfiles/ricing/PLAN.md as a checklist.

PHASE 3 — PREP
Once I approve:

- The dotfiles repo lives at ~/dotfiles and is managed with GNU Stow. Do not
  create a new git repo. Instead, add a .gitignore in ~/.config that ignores
  everything by default (\*) and whitelists ONLY the directories you plan to
  edit (e.g. !hypr/, !waybar/, !kitty/). Then commit the current state of the
  affected configs into ~/dotfiles as "pre-claude-baseline" and tag it.
  This needs no root — do it yourself.
- Write ONE shell script called ~/dotfiles/ricing/claude-setup.sh containing
  only the steps that require sudo: creation of a system snapshot FIRST, then
  package installation. Nothing else goes in it.
- Every line in the script must have a comment above it explaining what it does.
- If no snapshot tool is available, installing one and taking the snapshot must
  be the first actions in the script.
- The script must not contain any `curl | sh` / `wget | sh` patterns, and must
  not write to files outside the package manager's normal operation.
- Do not run the script. Tell me to read it and run it myself.

PHASE 4 — BUILD
After I confirm I've run the script:

- Make changes one component at a time. Commit to git after each component
  with a descriptive message, and tick it off in ~/dotfiles/ricing/PLAN.md.
- Never overwrite an existing config file without first copying it to
  <filename>.bak.
- Append every action you take to ~/dotfiles/ricing/claude-rice-log.md as you go: timestamp,
  what you changed, which file, why.
- Before telling me to reload the WM or log out, validate config syntax with
  the tool's own checker where one exists (e.g. hyprctl reload, i3 -C, sway -C)
  and report the result. Also tell me how to reach a TTY (Ctrl+Alt+F3) and
  restore the .bak file in case the graphical session breaks.
- Do not run sudo. If something needs root, stop and give me the exact command
  so I can run it myself.
- After each component, tell me what to look at to verify it worked.

Rules for the whole session:

- Never run rm -rf, dd, mkfs, chmod -R, or chown -R on anything.
- Never pipe a downloaded script directly into a shell.
- Never edit anything outside my home directory.
- Ask before installing anything not on the approved Phase 2 list.
- If a command fails, do not improvise workarounds involving root or system
  files — report the failure and wait.
