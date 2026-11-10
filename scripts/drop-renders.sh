#!/bin/bash
# Renders the Drop look offscreen with --png: every colorway, every shape and style, a classic
# twin for comparison, and three cue cards. Nothing is drawn on the screen.
# Usage: scripts/drop-renders.sh <bigarrow-binary> <out-dir>
set -u
BIN=$1
OUT=$2
mkdir -p "$OUT"
fail=0
run() { "$@" > /dev/null 2>> "$OUT/errors.txt" || { echo "FAILED: $*" >> "$OUT/errors.txt"; fail=1; }; }
point() { run "$BIN" point --look drop "$@"; }

for c in acid flare cobalt ink cement gum; do
  point --at 760,460 --color "$c" --from right --text "Click. This." --png "$OUT/colorway-$c.png"
done
for s in bend straight zigzag spiral; do
  point --at 760,460 --shape "$s" --from top-left --color flare --text "Not this one. That one." --png "$OUT/shape-$s.png"
done
point --at 760,460 --style ring --color cobalt --text "Flip it." --png "$OUT/style-ring.png"
point --rect 700,430,120,60 --style box --color acid --text "Type it here" --png "$OUT/style-box.png"
point --at 760,460 --size L --from bottom-left --text "Read this first" --png "$OUT/size-L.png"
point --at 760,460 --from top --close-button --color gum --text "Copy the PIN {{482913}}" --png "$OUT/copy-close.png"
run "$BIN" point --at 760,460 --from right --text "Click. This." --png "$OUT/classic-twin.png"
for card in 01-login 09-choice 11-checklist; do
  run "$BIN" card "docs/cards/$card.json" --look drop --png "$OUT/card-$card.png"
done
exit $fail
