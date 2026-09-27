#!/usr/bin/env bash
# Symlinks every skill directory in this repo into a target skills folder.
#
# Usage:
#   ./install.sh ~/.claude/skills
#
# Each skill (aur-guides and the 8 specialized skills) must be linked
# individually: most agent tools only scan the top level of the skills
# directory and won't discover a skill nested inside another skill's folder.

set -euo pipefail

SKILLS=(
  aur-guides
  aur-audit
  aur-helpers
  aur-makepkg
  aur-package-guidelines
  aur-pacman
  aur-pkgbuild
  aur-submission
  aur-vcs-packages
)

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <target-skills-directory>" >&2
  echo "Example: $0 ~/.claude/skills" >&2
  exit 1
fi

TARGET="$1"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$TARGET"

for skill in "${SKILLS[@]}"; do
  link="$TARGET/$skill"
  if [[ -e "$link" || -L "$link" ]]; then
    echo "Skipping $skill: $link already exists"
    continue
  fi
  ln -s "$SOURCE_DIR/$skill" "$link"
  echo "Linked $skill -> $link"
done
