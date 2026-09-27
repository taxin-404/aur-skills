# Changelog

Changes made in this pass, relative to the original `pahheb-skills` repo.

## Structural fix

- **Flattened all 8 specialized skills out of `aur-guides/` to the repo
  root.** Most agent tools (Claude Code included) only scan the top level
  of the skills directory and do not discover a `SKILL.md` nested inside
  another skill's folder ([anthropics/claude-code#28266](https://github.com/anthropics/claude-code/issues/28266)).
  With the original layout, symlinking just `aur-guides` (as the old
  README instructed) registered the dispatcher but left `aur-pkgbuild`,
  `aur-audit`, `aur-makepkg`, `aur-package-guidelines`, `aur-pacman`,
  `aur-submission`, `aur-vcs-packages`, and `aur-helpers` undiscoverable -
  so none of the `@skill-name` invocations the README itself documents
  would have worked.
- Updated `README.md`'s install instructions to link all 9 skill
  directories, and added `install.sh` to automate it.

## Factual corrections

- **`aur-pacman`**: removed `[community]` from the `pacman.conf` example.
  It was merged into `[extra]` in 2023 and the empty stub repo was
  removed entirely in March 2025 - keeping it in a config now makes
  `pacman -Sy` error out.
- **`aur-pacman`**: fixed a nonsensical "search in descriptions" example
  (`pacman -Ss "^extrepo-keyword$"`); replaced with an accurate note on
  how `-Ss`/`-Qs` matching and anchoring actually work.
- **`aur-makepkg`**: corrected the claim that `.install` scripts "run
  chrooted" - they run directly on the live system as part of the
  pacman transaction, same as `aur-pkgbuild` already correctly stated
  elsewhere in the collection.
- **`aur-helpers`**: pikaur is written in **Python**, not Rust (fixed in
  the comparison table and features list).
- **`aur-helpers`**: rewrote the `aura` sections - `-S` is pacman's own
  operation and only ever touches official repos; AUR packages live
  under `-A` (install: `aura -A pkg`, upgrade: `aura -Au`, search:
  `aura -As`), and orphans are `-O`, not `-A`.
- **`aur-helpers`**: replaced the `yay` `config.json` example with real
  key names (`buildDir`, `pacmanbin`, `makepkgbin`, etc. - not
  `cloneDir`/`absDir`/`sudevel`/`develcheck`, which don't exist).
- **`aur-helpers`**: replaced the `paru.conf` example with real option
  names (`AurOnly`, `BottomUp`, `RemoveMake`, `SudoLoop`, `UpgradeMenu`,
  `NewsOnUpgrade`, `[bin] FileManager`, ...) - dropped fabricated options
  (`PkgListsByOrigin`, `[bin] Shower`, `NoEditMenu`, `RemoveUnrequired`).
- **`aur-helpers`**: "view PKGBUILD" is `-Gp` on yay/paru, not `-Sp`;
  "view AUR comments" is `paru -Gc`, not `yay -C` (unverified/likely
  invented); voting is a real yay feature (`yay -Wv`/`-Wu`, needs
  `AUR_USERNAME`/`AUR_PASSWORD`), not a pikaur `--vote` flag (no
  evidence this exists - pikaur has no CLI voting feature).

## Second pass - deeper verification

A further full read-through, checking every command/config example against
primary sources (ArchWiki, man pages, pacman/makepkg mailing list history)
rather than just reading for plausibility. Found and fixed:

- **`aur-pkgbuild`**: the Python packaging example used the deprecated
  `setup.py install` method as the primary/only approach. Added the
  PEP 517 `python-build`/`python-installer` method as the preferred
  pattern, kept `setup.py` as a clearly-labeled deprecated fallback (it
  emits `SetuptoolsDeprecationWarning`, and needs `python-setuptools` in
  `makedepends` on Python 3.12+ since `distutils` was removed from stdlib).
- **`aur-pkgbuild`**: "multiple licenses" example used two separate array
  elements (`license=('A' 'B')`), which is the old, ambiguous style per
  ArchWiki's own SPDX discussion. Fixed to the single-SPDX-expression
  form (`license=('A OR B')`), matching what `aur-package-guidelines`
  already correctly showed elsewhere in the collection.
- **`aur-package-guidelines`**: the "reproducible builds" section had
  `SOURCE_DATE_EPOCH=$(date +%s)` as something to set *inside* the
  PKGBUILD - this defeats the entire point (a fresh timestamp every
  build is the opposite of reproducible). `makepkg` already exports
  `SOURCE_DATE_EPOCH` itself; rewrote the section to explain that
  correctly and to fix the `repro` verification command's flag (`-d`,
  not the invented `-f`).
- **`aur-submission`**: "must not exist in core/extra/community" still
  had the dead `community` repo reference the first pass fixed in
  `pacman.conf` but missed here. Also fixed an `ssh-keygen -C
  "aur@archlinux.org"` example that used AUR's own domain as if it were
  the user's identity - replaced with a real user-identifying comment.
- **`aur-audit`**: a VCS source example used `?branch=main` (query
  string) instead of the correct `#branch=main` (URL fragment) -
  inconsistent with `aur-vcs-packages`, which already had this right.
- **`aur-vcs-packages`**: "Use git-fetch-submodules for large repos"
  referenced a tool that doesn't appear to exist anywhere. Replaced
  with an accurate note that makepkg has no shallow-clone support at
  all. Also added a real, commonly-hit fix to the submodules example:
  git ≥2.38.1 blocks local (`file://`) transport for submodules by
  default, which breaks makepkg's local-clone submodule setup unless
  you pass `-c protocol.file.allow=always`.
- **`aur-makepkg`**: the "Best Practices" list still had its own
  separate "scripts run chrooted" error that the first pass's fix to
  the main `.install` section didn't catch (same wrong claim, second
  location). Fixed to match.
- **`aur-makepkg`**: "Use ABS" as a way to get official PKGBUILDs - the
  `abs` tool was deprecated and removed years ago, and its replacement
  `asp` has itself since been deprecated in favor of `pkgctl`/plain git.
  Replaced with the current method.
- **`aur-makepkg`**: `--noprepare` and `--pkg` are not real makepkg
  flags - the man page has no such options. Fixed to `--noextract`
  (which already covers skipping `prepare()`) and `-R`/`--repackage`
  respectively, in three places, and added `-R` to the command table.
- **`aur-makepkg`**: a custom `DLAGENTS` example mapped `https` to
  `wget --passive-ftp`, an FTP-only flag that makes no sense for HTTPS.
  Removed it.
- **`aur-pacman`**: `pacman -Rc` was described as "remove package even
  if required by others" - it actually does something far more
  dangerous: cascade-removes the target *and every package that
  depends on it*, recursively (this has been known to take out entire
  desktop environments). Rewrote with an explicit warning and pointed
  to `-Rs` for the more modest "clean up this package's own now-unused
  deps" behavior people usually actually want.
- **`aur-pacman`**: `pacman -U --nosave` was labeled "install without
  dependencies" - `--nosave` is a remove-only flag (skip `.pacsave`
  backups) and has nothing to do with dependencies or installs. Fixed
  to the flag that actually does that, `--nodeps`.
- **`aur-helpers`**: "search official repos only" used `^term` (name
  anchoring, which narrows to an exact-name match regardless of
  source) where `--repo`/`--aur` are the flags that actually restrict
  which source is searched. Fixed.

## Not changed, flagged instead

- `aur-pkgbuild` and `aur-package-guidelines` duplicate a fair amount of
  content (naming rules, dependency types, licensing, forbidden paths).
  Left as-is since each skill should stay useful when loaded on its own,
  but worth a deliberate trim/cross-reference pass later if token
  footprint matters more than standalone completeness.
