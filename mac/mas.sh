#!/usr/bin/env bash

#set -xe

if [ -z "$HOME" ]; then 
    echo "Seems you're \$HOMEless :("; 
    exit 1 
fi

if ! [ -x "$(command -v brew)" ]; then
  echo "Error: brew is not installed.";
  exit 1
fi

if ! [ -x "$(command -v mas)" ]; then
  brew install mas
fi

# LET'S GO
cd "$HOME" || exit

## PROCESSOR
function masapss() {
   arr=("$@")
   for i in "${arr[@]}";
      do
          echo "Checking and install ($i)"
          #mas info $i
          mas install $i
      done
}

## VARIABLES
APPLE_IDS=(
    "409183694" 
    "409201541" 
    "409203825" 
)

SOCIAL_IDS=(
    "1147396723" 
    "747648890" 
    "803453959"
)

BUSINESS_IDS=(
    "1278508951" 
    "568494494"
)

TOOLS_IDS=(
    "441258766" 
    "915542151" 
    "1333542190"
    "411643860"
    "639764244"
)

MS_IDS=(
    "462054704"
    "586683407"
    "462062816"
    "951937596"
    "410395246"
    "477537958"
    "1295203466"
)
 
masapss ${TOOLS_IDS[@]} 
masapss ${BUSINESS_IDS[@]}
masapss ${MS_IDS[@]}
masapss ${SOCIAL_IDS[@]}
masapss ${APPLE_IDS[@]}