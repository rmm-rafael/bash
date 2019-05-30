
#!/usr/bin/env bash

#set -xe

# Depends on
# bash.sh (bash_completion)
# cask.sh (docker)

kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
alias k=kubectl
complete -F __start_kubectl k