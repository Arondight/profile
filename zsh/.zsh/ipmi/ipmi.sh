#!/usr/bin/env cat
# ==============================================================================
# ipmitool
# ==============================================================================
# Create by Arondight <shell_way@foxmail.com>
# ==============================================================================
# SOURCE ME!!!
# ==============================================================================

function _ipmi_action ()
{
  local _ip=$1 && shift
  local _user=$1 && shift
  local _passwd=$1 && shift
  local _action=($@)

  if [[ -z "$_ip" || -z "$_user" || -z "$_passwd" || 0 -eq "${#_action[@]}" ]]
  then
    echo 'Usage: _ipmi_action <ip> <user> <password> <action>' >&2
    return 1
  fi

  ipmitool -I lanplus -H "$_ip" -U "$_user" -P "$_passwd" -e! ${_action[@]}

  return $?
}

# ==============================================================================
# This show power status
# ==============================================================================
alias ipmi-status='ipmi_status'
function ipmi_status ()
{
  _ipmi_action $@ power status
  return $?
}

# ==============================================================================
# This turn power on
# ==============================================================================
alias impi-boot='ipmi_boot'
function ipmi_boot ()
{
  _ipmi_action $@ power on
  return $?
}

# ==============================================================================
# This turn power off
# ==============================================================================
alias ipmi-halt='ipmi_halt'
function ipmi_halt ()
{
  _ipmi_action $@ power off
  return $?
}

# ==============================================================================
# This to attach
# ==============================================================================
alias ipmi-attach='ipmi_attach'
function ipmi_attach ()
{
  _ipmi_action $@ sol activate
  return $?
}

# ==============================================================================
# This to deattach
# ==============================================================================
alias ipmi-deattach='ipmi_deattach'
function ipmi-deattach ()
{
  _ipmi_action $@ sol deactivate
  return $?
}

