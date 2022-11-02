#!/bin/bash

set -x

if [[ $1 == "-v" ]]; then
  if [[ -z $2 ]]; then
    date +"%Y%m%d"
  else
    grep -oE "([0-9]+\.?)+" <(echo "$2")
  fi
elif [[ $1 == "-r" ]]; then
  if [[ -z $2 ]]; then
    echo "git$(git rev-parse --short HEAD)"
  else
    echo "$2" | sed -E 's/v([0-9]+\.?)+-//'
  fi
else
  echo "Usage: $0 -v | -r <tag>"
fi
