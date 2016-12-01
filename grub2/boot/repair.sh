#!/usr/bin/env bash

EFIDIR=${EFIDIR:-'/boot/EFI'}
BOOTID=${BOOTID:-'Arch Linux With GRUB2'}
PKGS=('dosfstools' 'grub' 'efibootmgr')

{
  if [[ 0 != $UID ]]
  then
    echo "This should run as root." >&2
    exit 1
  fi

  pacman --needed --noconfirm --color auto -S ${PKGS[@]}
  grub-install --target=x86_64-efi --efi-directory="${EFIDIR}" --bootloader-id="${BOOTID}" --recheck

  exit $?
}

