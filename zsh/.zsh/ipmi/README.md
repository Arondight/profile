## ipmi

Wrapper for `ipmitool` to manage remote servers via IPMI.

### Commands

| Command | Action |
| ------- | ------ |
| `ipmi-status` | Show power status |
| `ipmi-boot` | Power on |
| `ipmi-halt` | Power off |
| `ipmi-attach` | Attach virtual media |
| `ipmi-deattach` | Detach virtual media |

All commands require the environment variables `IPMI_IP`, `IPMI_USER`, and `IPMI_PASSWD` to be set.