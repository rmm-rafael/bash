#!/usr/bin/env bash

#set -xe

# Documentation
# https://itnext.io/upgrading-bash-on-macos-7138bd1066ba

if [ -z "$HOME" ]; then 
    echo "Seems you're \$HOMEless :("; 
    exit 1 
fi

if ! [ -x "$(command -v brew)" ]; then
  echo "Error: brew is not installed.";
  exit 1
fi

# GO HOME
cd "$HOME" || exit

# Ask for the administrator password upfront
sudo -v

# install 
brew install bash bash-completion@2

# show all bash versions 
which -a bash

# White list
sudo echo "/usr/local/bin/bash" >> /etc/shells

# Set default bash
chsh -s /usr/local/bin/bash

# show my settings
echo $BASH_VERSION

# for all users
sudo chsh -s /usr/local/bin/bash

# export values
echo 'export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
 [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"' >> .bash_profile