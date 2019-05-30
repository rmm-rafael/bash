#!/usr/bin/env bash

#set -xe

if [ -z "$HOME" ]; then 
    echo "Seems you're \$HOMEless :(" 
    exit 1 
fi

if ! [ -x "$(command -v brew)" ]; then
  echo "Error: brew is not installed."
  exit 1
fi

# GO HOME
cd "$HOME" || exit

## PROCESSOR
function caskapp() {
   arr=("$@")
   for i in "${arr[@]}";
      do
          echo "Checking and install ($i)"
          #brew cask info $i
          brew cask install $i
      done
}

## VARIABLES
ALL_IDS=(
    "visual-studio-code"
    "tuxera-ntfs"
    "transmission"
    "teamviewer"
    "stremio"
    "spotify"
    "skype"
    "skype-for-business"
    "postman"
    "jetbrains-toolbox"
    "jd-gui"
    "iina"
    "google-chrome"
    "firefox"
    "docker"
)

# LETS GO
caskapp ${ALL_IDS[@]} 