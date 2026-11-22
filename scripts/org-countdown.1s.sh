#!/bin/bash
# <xbar.title>Org countdown</xbar.title>
# <xbar.desc>Shows the Neovim org countdown (lua/custom/org_countdown.lua) in the menu bar.</xbar.desc>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
#
# Symlinked into the SwiftBar plugin folder; the ".1s" in the name means it runs every second.
# State file lines (written by Neovim): ends_at epoch, nvim pid, heading title.

state="$HOME/.cache/org-countdown"
[ -f "$state" ] || exit 0
{ read -r ends_at; read -r pid; read -r title; } < "$state"

# Neovim quit without cleaning up: hide instead of showing a stale clock.
if ! kill -0 "$pid" 2>/dev/null; then
  rm -f "$state"
  exit 0
fi

fmt() {
  local s=$1 h=$(($1 / 3600)) m=$(($1 % 3600 / 60))
  if [ "$h" -gt 0 ]; then
    printf '%d:%02d:%02d' "$h" "$m" $((s % 60))
  else
    printf '%02d:%02d' "$m" $((s % 60))
  fi
}

short="$title"
[ ${#title} -gt 25 ] && short="${title:0:24}…"

left=$((ends_at - $(date +%s)))
if [ "$left" -gt 0 ]; then
  echo "⏳ $(fmt "$left") $short | font=Menlo size=13"
else
  echo "⏰ +$(fmt $((-left))) $short | font=Menlo size=13 color=red"
fi
echo "---"
echo "$title"
