# aur-skills

A collection of AI agent skills covering diverse topics for enhanced productivity and better adherence to requirements.

## Skills

### AUR (Arch User Repository)
- **aur-guides** - Master dispatcher for AUR package development
- **aur-pkgbuild** - PKGBUILD creation and syntax
- **aur-package-guidelines** - Arch Linux packaging standards
- **aur-submission** - AUR submission and maintenance
- **aur-audit** - Package auditing and validation
- **aur-makepkg** - Build process configuration
- **aur-vcs-packages** - Version Control System packages
- **aur-pacman** - Pacman usage guide
- **aur-helpers** - AUR helper tools (yay, paru, etc.)

## Installation

Each skill (`aur-guides` and the 8 specialized skills) is its own top-level
directory in this repo, and needs its own symlink. Most agent tools
(including Claude Code) only scan the *top level* of the skills directory -
they don't discover skills nested inside another skill's folder - so linking
just `aur-guides` will register the dispatcher but leave the specialized
skills invisible to `@aur-pkgbuild`, `@aur-makepkg`, etc.

Symlink every skill directory into your tool's skills path:

```bash
for skill in aur-guides aur-audit aur-helpers aur-makepkg \
             aur-package-guidelines aur-pacman aur-pkgbuild \
             aur-submission aur-vcs-packages; do
  ln -s "/path/to/pahheb-skills/$skill" "/tool/install/path/$skill"
done
```

Replace `/path/to/pahheb-skills` with the actual path to this repository on your machine, and `/tool/install/path` with your tool's specific path (see table below). A ready-made `install.sh` that does this for you is included in the repo root.

## Supported Tools

| Tool | Install Path | How to Invoke |
| :--- | :--- | :--- |
| Claude Code | `~/.claude/skills/` | `Use @aur-guides to help me create...` |
| Gemini CLI | `~/.gemini/skills/` | `Use aur-guides to help me create...` |
| Codex | `~/.agents/skills/` | `Use aur-guides to help me create...` |
| OpenCode | `~/.config/opencode/skills/` | `Use aur-guides to help me create...` |
| Cursor | `~/.cursor/skills/` | `@aur-guides help me create...` |
| Windsurf | `~/.codeium/windsurf/skills/` | `@aur-guides help me create...` |
| Antigravity | `~/.gemini/antigravity/skills/` | `Use @aur-guides to help me create...` |

## Usage

After installation, simply ask the AI agent about AUR-related tasks:

> "Use @aur-guides to help me create a PKGBUILD for my project"
> "Use @aur-makepkg to build this package"
> "Use @aur-submission to submit my package to the AUR"

The aur-guides skill is the main/router skill that will dispatch to the appropriate specialized skill based on your query.
The other skills are specialized in specific isolated tasks, intended for more fine-grained work and higher token efficiency.

## Credits

Based on [Pahheb/pahheb-skills](https://github.com/Pahheb/pahheb-skills).
This version restructures the skills so every specialized skill is
independently discoverable (see `CHANGELOG.md`) and corrects several
inaccurate commands/config examples across the AUR helper and pacman
guides.

## License

MIT License. Feel free to contribute.
