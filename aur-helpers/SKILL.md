---
name: aur-helpers
description: Comprehensive guide for using AUR helper tools like yay, paru, pikaur, and aura for automating package management.
---

# Skill: aur-helpers

## Purpose

Comprehensive guide for using AUR helper tools (yay, paru, pikaur, aura, etc.). Covers installation, configuration, workflows, and comparisons to help AI agents assist users with AUR package management using their preferred helper.

## When to Use This Skill

This skill should be used when:
- Installing or configuring an AUR helper
- Managing AUR packages using a helper
- Troubleshooting AUR helper issues
- Choosing an AUR helper for a user
- Migrating between AUR helpers

## When NOT to Use This Skill

- For building packages manually (use aur-makepkg skill)
- For official repo packages (use pacman directly)
- When you prefer manual AUR workflow

## Overview

AUR helpers automate the process of finding, building, and installing packages from the AUR. They handle dependency resolution, PKGBUILD cloning, building, and installation.

### Common Features
- Search AUR and repositories
- Automatic dependency resolution
- PKGBUILD viewing/editing
- Package building
- AUR comment interaction

## yay

### Installation
```bash
# From AUR
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Or from official repos (if available)
pacman -S yay
```

### Basic Usage
```bash
# Upgrade all packages (including AUR)
yay -Syu

# Install package
yay -S package-name

# Search AUR
yay -Ss search-term

# Remove package
yay -R package-name

# Clean cache
yay -Scc
```

### Configuration
```bash
# Edit config
yay --editmenu      # Edit PKGBUILD before build
yay --nodiffmenu    # Skip diff menu
yay --useask        # Use pacman confirmation

# Options in yay.conf
--aur
--repo
--both (default)
```

### Search
```bash
# Search AUR only
yay -Ss term

# Search with details
yay -Si package-name

# Search both repos and AUR (bare term = combined search + selection menu)
yay term
```

## paru

### Installation
```bash
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

### Basic Usage
```bash
# Upgrade everything
paru -Syu

# Install package
paru -S package-name

# Search AUR
paru -Ss term

# View PKGBUILD
paru -Gp package-name

# Clean cache
paru -Scc
```

### Features
- Colorized output
- Better git support
- News reading (pacnews on upgrade)
- Written in Rust

See the "Configuration Files" section below for a full `paru.conf` example
(options like `AurOnly`, `BottomUp`, `RemoveMake`, `SudoLoop`).

## pikaur

### Installation
```bash
git clone https://aur.archlinux.org/pikaur.git
cd pikaur
makepkg -fsi
```

### Basic Usage
Pikaur wraps pacman's own flags directly rather than inventing new ones -
`-Syu` is split into `-Sy` (refresh) then `-Su` (confirm/install upgrades).
```bash
# Sync package DB, then upgrade (including AUR)
pikaur -Sy
pikaur -Su

# Install package
pikaur -S package-name

# Search (or list all AUR packages)
pikaur -Ss term

# Build without installing
pikaur -Sw package-name
```
See `pikaur -Sh`, `-Qh`, `-Ph`, `-Gh`, `-Xh` for its pikaur-specific flags.

### Features
- Written in Python
- Builds all reviewed PKGBUILDs in one batch, then installs without
  further interaction
- Shows unread Arch news before a sysupgrade
- Manual package selection via text editor during install
- Voting on packages is done through the AUR web interface, not the CLI

## aura

### Installation
```bash
git clone https://aur.archlinux.org/aura-bin.git
cd aura-bin
makepkg -si
```

### Basic Usage
Aura genuinely *is* pacman - `-S` only ever touches official repos, exactly
like plain pacman. AUR packages live under the separate `-A` operation, and
orphans under `-O`.
```bash
# Official repo packages - identical to pacman
aura -S package-name
aura -Syu

# AUR packages
aura -A package-name      # install from AUR
aura -Au                  # upgrade installed AUR packages
aura -As term              # search AUR
aura -Ai package-name      # AUR package info

# List orphaned packages
aura -O
```

### Features
- Haskell implementation (a Rust rewrite is in early progress upstream)
- Builds as a normal user even when aura itself is run via sudo
- Scans PKGBUILDs for suspicious/unsafe bash before building (`-P`)
- Keeps built packages cached for easy downgrading

## Comparison

| Feature | yay | paru | pikaur | aura |
|---------|-----|------|--------|------|
| Language | Go | Rust | Python | Haskell |
| Speed | Fast | Fast | Fast | Medium |
| Dependencies | Low | Low | Low | High |
| AUR uses a separate operation from `-S` | No | No | No | Yes (`-A`) |
| Features | Good | Excellent | Good | Good |

### Choosing a Helper

**yay** - Best for:
- Users familiar with pacman syntax
- Need AUR + official repos in one unified `-S`
- Good balance of features

**paru** - Best for:
- Maximum features and configurability
- Fast Rust implementation

**pikaur** - Best for:
- Users who want AUR builds fully reviewed and batched before any
  installation happens, with minimal added flags on top of pacman

**aura** - Best for:
- Haskell preference
- Wanting official-repo and AUR operations kept strictly separate

## Configuration Files

### yay (~/.config/yay/config.json)
Keys mirror `yay`'s internal flag names; run `yay -Pg` to print your current
config or `yay -Pd` for the defaults.
```json
{
  "aururl": "https://aur.archlinux.org",
  "buildDir": "~/.cache/yay",
  "editor": "vim",
  "makepkgbin": "makepkg",
  "pacmanbin": "pacman",
  "sortby": "votes",
  "searchby": "name-desc",
  "removemake": "ask",
  "sudobin": "sudo",
  "requestsplitn": 150,
  "completionrefreshtime": 7,
  "bottomup": true,
  "sudoloop": false,
  "timeupdate": false,
  "devel": false,
  "cleanAfter": false,
  "provides": true,
  "pgpfetch": true,
  "upgrademenu": true,
  "cleanmenu": true,
  "diffmenu": true,
  "editmenu": false,
  "combinedupgrade": false,
  "useask": false
}
```

### paru (~/.config/paru/paru.conf or /etc/paru.conf)
```ini
[options]
PgpFetch
Devel
Provides
DevelSuffixes = -git -svn -bzr -darcs -hg -fossil
#AurOnly
BottomUp
#RemoveMake
SudoLoop
#UseAsk
#CombinedUpgrade
CleanAfter
UpgradeMenu
NewsOnUpgrade
#LocalRepo
#Chroot

[bin]
FileManager = vifm
#MFlags = --skippgpcheck
#Sudo = doas
```

## Workflow Examples

### Install New Package
```bash
# Using yay
yay -S package-name

# Using paru
paru -S package-name

# Using pikaur
pikaur -S package-name

# Using aura (note the -A, not -S, for AUR packages)
aura -A package-name
```

### System Upgrade
```bash
# yay - one command upgrades official repos + AUR together
yay -Syu

# paru - same interface
paru -Syu

# pikaur - split into refresh then confirm
pikaur -Sy
pikaur -Su

# aura - official and AUR upgrades are separate commands
aura -Syu
aura -Au
```

### Search Packages
```bash
# Search AUR
yay -Ss search-term
paru -Ss search-term
pikaur -Ss search-term

# Search official repos only (not AUR)
yay --repo -Ss term
paru --repo -Ss term
```
(`^term$` anchors a search to an exact name match - it does not restrict
which source is searched. Use `--repo`/`--aur` for that.)

### Remove Package
```bash
# Remove with dependencies
yay -Rs package-name
paru -Rs package-name

# Remove completely
yay -Rns package-name
paru -Rns package-name
```

## AUR-Specific Operations

### View PKGBUILD
```bash
# yay / paru - download and print the PKGBUILD from AUR
yay -Gp package-name
paru -Gp package-name
```

### Edit PKGBUILD
```bash
# yay - prompt to edit before building
yay -S package-name --editmenu

# paru - same idea
paru -S package-name --editmenu
```

### View AUR Comments
```bash
# paru - print AUR comments directly
paru -Gc package-name

# Any helper: just open the package page
xdg-open https://aur.archlinux.org/packages/package-name/
```

### AUR Vote
```bash
# yay (v11.3+) - requires AUR_USERNAME and AUR_PASSWORD env vars
AUR_USERNAME=user AUR_PASSWORD=pass yay -Wv package-name   # vote
AUR_USERNAME=user AUR_PASSWORD=pass yay -Wu package-name   # unvote

# paru, pikaur, aura - vote via the AUR web interface instead
```

## Troubleshooting

### Key Issues
```bash
# Refresh keys
yay --refresh --gpgdir /etc/pacman.d/gnupg

# Or use pacman directly
pacman-key --refresh-keys
```

### Cache Issues
```bash
# Clean cache
yay -Scc
paru -Scc
pikaur -Scc
```

### Build Failures
```bash
# Rebuild from scratch
yay -S package-name --rebuild

# Clean build
yay -Scc && yay -S package-name
```

### Dependency Issues
```bash
# Skip dependency check
yay -S package-name --nodepcheck

# Install deps only
makepkg -s
```

## Security Considerations

### Always Review PKGBUILD
```bash
# Always view before install
yay -S package-name --editmenu
paru -S package-name --editmenu
```

### Signature Verification
```bash
# Enable checking
yay --pgpfetch
paru --pgpfetch
```

### Trusted Users
- Only install PKGBUILDs from trusted sources
- Check package comments
- Review source URLs

## Common Commands by Helper

| Action | yay | paru | pikaur |
|--------|-----|------|--------|
| Upgrade | -Syu | -Syu | -Syu |
| Install | -S | -S | -S |
| Search | -Ss | -Ss | -Ss |
| Remove | -R | -R | -R |
| Clean | -Scc | -Scc | -Scc |
| View PKGBUILD | -Gp | -Gp | - |

## Related Skills

- **aur-guides** - Main dispatcher
- **aur-pkgbuild** - PKGBUILD creation
- **aur-submission** - AUR submission
- **aur-makepkg** - Building
- **aur-pacman** - Pacman usage
- **aur-audit** - Validation
