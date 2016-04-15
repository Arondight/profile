#!/usr/bin/env bash

if [[ -r ./hosts ]]; then
  sudo cp -f $(readlink -f ./hosts) /etc/hosts
fi

