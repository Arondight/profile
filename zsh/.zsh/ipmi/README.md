## ipmi

Wrapper for `ipmitool` to manage remote servers via IPMI over LAN (`-I lanplus`).

### Commands

| Command | Action |
| ------- | ------ |
| `ipmi-status` | Query power status (`power status`) |
| `ipmi-boot` | Power on (`power on`) |
| `ipmi-halt` | Power off (`power off`) |
| `ipmi-attach` | Activate Serial-over-LAN console (`sol activate`) |
| `ipmi-deattach` | Deactivate Serial-over-LAN console (`sol deactivate`) |

Each command takes three positional arguments — `<ip> <user> <password>` — and forwards them to `_ipmi_action`, which calls `ipmitool -I lanplus -H <ip> -U <user> -P <passwd> -e!` with the corresponding action. Each command also has a hyphen-separated alias (e.g. `ipmi-status` for `ipmi_status`).