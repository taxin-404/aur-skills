---
name: aur-pacman
description: Comprehensive guide for using pacman, the Arch Linux package manager, covering installation, removal, queries, and troubleshooting.
---

# Skill: aur-pacman

## Purpose

Comprehensive guide for using pacman, the Arch Linux package manager. Covers package installation, removal, queries, database operations, and troubleshooting for both official repositories and AUR packages.

## When to Use This Skill

This skill should be used when:
- Installing or removing packages
- Querying installed packages
- Managing repositories
- Troubleshooting pacman issues
- Working with package databases
- Syncing and upgrading the system

## When NOT to Use This Skill

- For building packages (use aur-makepkg skill)
- For AUR package management (use aur-helpers skill)
- For non-Arch Linux systems

## Overview

pacman is the official package manager for Arch Linux. It handles package installation, upgrades, and removal while resolving dependencies.

### Key Concepts
- **Sync** - Download and install packages
- **Upgrade** - Update all system packages
- **Query** - Search installed packages
- **Database** - Manage package database

## Package Installation

### Basic Installation
```bash
# Install single package
pacman -S package-name

# Install multiple packages
pacman -S package1 package2 package3

# Install from specific repository
pacman -S extra/package-name
pacman -S core/package-name

# Reinstall package
pacman -S package-name
```

### Dependencies
```bash
# Install with dependencies only
pacman -S --asdeps package-name

# Install as explicit dependency
pacman -S --asexplicit package-name

# Install a local package file, skipping dependency checks
# (--nodeps applies to -S/-R/-U alike; --nosave is a -R-only option
# for skipping .pacsave backups, not relevant here)
pacman -U --nodeps package.pkg.tar.zst
```

### Groups
```bash
# Install group
pacman -S group-name

# See group members
pacman -Sg group-name

# Install only certain group members
pacman -S group-name package1 package2
```

## Package Removal

### Basic Removal
```bash
# Remove package (keep dependencies)
pacman -R package-name

# Remove package and dependencies
pacman -Rs package-name

# Remove package, dependencies, and config files
pacman -Rns package-name

# Remove orphaned packages
pacman -Rsn $(pacman -Qtdq)
```

### Forced Removal
```bash
# Force remove, skipping dependency checks entirely (use with caution)
pacman -Rdd package-name

# DANGEROUS: cascade-removes the target AND every package that depends
# on it, recursively. This is not "remove despite being required" - it
# actively removes the dependents too, and can take out large chunks of
# a system (entire desktop environments included). Use -Rs instead if
# you just want to also clean up the target's own now-unneeded deps.
pacman -Rc package-name
```

## Package Upgrades

### System Upgrade
```bash
# Sync and upgrade all packages
pacman -Syu

# Sync only (no upgrade)
pacman -Sy

# Download packages but don't install
pacman -Syuw

# Upgrade with ignore packages
pacman -Syu --ignore=package-name
pacman -Syu --ignoregroup=gnome
```

### Package Upgrade
```bash
# Upgrade single package
pacman -Syu package-name

# Downgrade package (from cache)
pacman -U /var/cache/pacman/pkg/package-old.pkg.tar.zst
```

## Querying Packages

### Search
```bash
# Search sync DBs by name/description (repos)
pacman -Ss keyword

# Search installed packages by name/description
pacman -Qs keyword

# Anchor to match the exact package name only
pacman -Ss "^package-name$"
pacman -Qs "^package-name$"
```
Both `-Ss` and `-Qs` already match against name AND description by
default - anchors (`^...$`) just narrow a search down to an exact name.

### Package Info
```bash
# Query package info (installed)
pacman -Qi package-name

# Query package info (not installed)
pacman -Si package-name

# Query file list
pacman -Ql package-name

# Query which package owns file
pacman -Qo /path/to/file

# Query explicit files
pacman -Qk package-name
```

### List Packages
```bash
# List all installed packages
pacman -Q

# List explicitly installed packages
pacman -Qe

# List native packages
pacman -Qn

# List foreign packages (AUR)
pacman -Qm

# List package group members
pacman -Sg group-name

# List outdated packages
pacman -Qu

# List packages not required by others
pacman -Qtdq
```

## Database Operations

### Cache Management
```bash
# Clean package cache
pacman -Sc     # Remove old package versions
pacman -Scc   # Remove all cached packages

# Keep only installed packages in cache
paccache -r

# Keep last 2 versions
paccache -r -k 2
```

### Repository Management
```bash
# Sync databases
pacman -Sy

# Force sync databases
pacman -Syy

# Check database integrity
pacman -Dk

# Repair database
pacman-db-upgrade
```

## Configuration

### /etc/pacman.conf

```ini
[options]
# Architecture
Architecture = x86_64

# Color output
Color

# Total download
TotalDownload

# Check space
CheckSpace

# ILoveCandy

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

# Note: [community] was merged into [extra] in 2023 and the deprecated
# section was removed from pacman.conf entirely in March 2025. Adding a
# [community] block back will make `pacman -Sy` error out - don't.

# Custom repository
[myrepo]
Server = https://myrepo.example.com/$arch
```

### Common Options
```ini
[options]
# Ignore upgrades for package
IgnorePkg = package-name

# Ignore upgrades for group
IgnoreGroup = gnome

# No upgrade (save new version as .pacnew)
NoUpgrade = /etc/pam.conf

# Don't extract specific files from packages
NoExtract = /usr/lib/modules/*
```

## Mirror Management

### Rank Mirrors
```bash
# Install reflector
pacman -S reflector

# Rank mirrors by speed
reflector --country US --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

# Simple ranking
rankmirrors -n 6 /etc/pacman.d/mirrorlist
```

### Manual Mirror
```bash
# Add custom mirror
Server = https://mirror.example.com/archlinux/$repo/os/$arch
```

## Troubleshooting

### Signature Issues
```bash
# Refresh keys
pacman-key --refresh-keys

# Reset pacman keys
rm -rf /etc/pacman.d/keyring
pacman-key --init
pacman-key --populate archlinux

# Temporarily disable signature checking (NOT RECOMMENDED)
# Add to /etc/pacman.conf under [options]:
# SigLevel = Never
```

### Database Lock
```bash
# Check if pacman is actually running
ps aux | grep pacman

# Verify if lock file is in use before removing
fuser /var/lib/pacman/db.lck

# Remove lock file (only if pacman not running)
rm /var/lib/pacman/db.lck
```

### Dependency Errors
```bash
# Check for broken links
ldd /path/to/binary

# Find missing dependency
pacman -Qo /usr/lib/libfoo.so

# Reinstall package
pacman -S package-name --overwrite "*"
```

### Disk Space
```bash
# Check disk usage
df -h

# Check pacman cache size
du -sh /var/cache/pacman/pkg/

# Remove old packages
pacman -Sc
```

### Failed Upgrade Recovery
```bash
# Boot from Arch ISO
# Mount filesystem
mount /dev/sdaX /mnt

# Chroot
arch-chroot /mnt

# Fix database
pacman -Dk

# Or reinstall core packages
pacman -Syu --ignore grub
```

## AUR Packages

### Manual AUR Install
```bash
# Download AUR package
git clone https://aur.archlinux.org/package-name.git
cd package-name

# View PKGBUILD (ALWAYS REVIEW!)
less PKGBUILD

# Build and install
makepkg -si
```

### Upgrading AUR Packages
```bash
cd package-name-git
git pull
makepkg -si
```

### AUR Dependencies
```bash
# Build all dependencies
makepkg -s

# Install missing AUR deps
cd /path/to/aur-package
makepkg -s
```

## Queries for Package Maintenance

### Find Unused Dependencies
```bash
# List orphan packages
pacman -Qtdq

# Remove orphans
pacman -Rsn $(pacman -Qtdq)
```

### Check Package Files
```bash
# List package files
pacman -Ql package-name

# Find file owner
pacman -Qo /usr/bin/program

# Check package dependencies
pacman -Qii package-name | grep DEPENDS
```

### Verify Installation
```bash
# Verify installed files (check presence)
pacman -Qk

# Show pacman version
pacman -V

# Check for missing files (with count)
pacman -Qk package-name
```

## Common Commands Summary

| Command | Purpose |
|---------|---------|
| `pacman -Syu` | Full system upgrade |
| `pacman -S package` | Install package |
| `pacman -R package` | Remove package |
| `pacman -Ss query` | Search repos |
| `pacman -Qs query` | Search installed |
| `pacman -Qi package` | Package info |
| `pacman -Ql package` | File list |
| `pacman -Qo file` | File owner |
| `pacman -Sc` | Clean cache |

## Related Skills

- **aur-guides** - Main dispatcher
- **aur-pkgbuild** - PKGBUILD creation
- **aur-audit** - Validation
- **aur-submission** - AUR submission
- **aur-makepkg** - Building
- **aur-helpers** - AUR helpers
