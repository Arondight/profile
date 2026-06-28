## profileutils

Configuration management tools for updating and re-initializing the profile environment.

| Function | Description |
| -------- | ----------- |
| `profileupdate` | Pull the latest config from the upstream git repository. Use `profileupdate -f` to force overwrite local changes |
| `profilereconf` | Re-run the full install + init pipeline (`install.sh -a`), updating third-party repos and re-applying all configurations |

Aliases: `profile-update`, `profile_update`, `profile-reconf`, `profile_reconf`.