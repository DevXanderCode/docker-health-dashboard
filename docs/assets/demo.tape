# VHS tape script for the dhealth README demo GIF.
#
# VHS (https://github.com/charmbracelet/vhs) scripts a real terminal session
# and renders it deterministically to a GIF — no manual screen recording.
#
# Regenerate with (from the repo root):
#   vhs docs/assets/demo.tape
#
# Requires: vhs (brew install vhs), and dhealth's dependencies (docker, awk,
# tput) available on PATH, run from the repo root so `./dhealth` resolves.

Output docs/assets/demo.gif

Set Shell "bash"
Set FontSize 15
Set Width 1600
Set Height 760
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 60ms

Type "./dhealth"
Sleep 500ms
Enter
# ./dhealth takes ~3.5s in practice (docker stats --no-stream samples CPU over
# time), then hold the finished dashboard on screen for readability.
Sleep 5s
Sleep 4s
