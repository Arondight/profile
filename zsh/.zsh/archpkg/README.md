## archpkg

A `slackpkg`-style wrapper around `pacman` for Arch Linux.

### Commands

| Command | Description |
|---------|-------------|
| `archpkg update` | Update package database |
| `archpkg check-updates [package]` | Check for available updates |
| `archpkg upgrade-all` | Upgrade all packages |
| `archpkg clean-system` | Clean orphaned packages and cached files |
| `archpkg install <package>` | Install a package |
| `archpkg reinstall <package>` | Reinstall a package |
| `archpkg remove <package>` | Remove a package |
| `archpkg download <package>` | Download a package without installing |
| `archpkg info <package>` | Show package information |
| `archpkg search <regex>` | Search for a package |
| `archpkg file-search <file>` | Find which package provides a file |
| `archpkg generate-template <file>` | Export installed package list to a template |
| `archpkg install-template <file>` | Install all packages from a template |
| `archpkg remove-template <file>` | Remove all packages from a template |
| `archpkg help` | Show help message |

Template files are simple text files with one package name per line, useful for replicating package sets across machines.