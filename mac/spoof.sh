#!/usr/bin/env bash

#set -xe

# Documentation
# https://github.com/feross/SpoofMAC

if [ -n "${1}" ] ; then
    SECRET_ADDRESS=${1}
else
    echo 'mac address is required'
    exit 1    
fi

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

# install 
brew install spoof-mac

# spoof-mac 
sudo cat <<EOF >  /Library/LaunchDaemons/homebrew.mxcl.spoof-mac.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>MacSpoof</string>
    <key>ProgramArguments</key>
    <array>
      <string>/usr/local/bin/spoof-mac.py</string>
      <string>set</string>
      <string>${SECRET_ADDRESS}</string>
      <string>en0</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOF

# start the service
sudo brew services start spoof-mac