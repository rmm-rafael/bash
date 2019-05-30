#!/usr/bin/env bash


#set -xe

if [ "${1}" == "extra" ] ; then
    EXTRA=true
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

# install the newest version
brew install git git-lfs 

# git user configuration
git config --global user.name $USER
git config --global user.email $EMAIL 

# git configurations
if [ -z "$EXTRA" ]; then 

echo <<EOF > .gitconfig
[filter "lfs"]
	process = git-lfs filter-process
	required = true
	clean = git-lfs clean -- %f
	smudge = git-lfs smudge -- %f
[alias]
   	# one-line log
	l = log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=short
	hist = log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short

	a = add
	ap = add -p

	ci = commit
	c = commit --verbose
	ca = commit -a --verbose
	cm = commit -m
	cam = commit -a -m
	m = commit --amend --verbose
	ac = !git add . && git commit -am

	# undo-commit
	uc = reset --soft HEAD~1

	rb = "git rebase -i `git merge-base HEAD master`"

	d = diff
	ds = diff --stat
	dc = diff --cached

	s = status

	st = stash
	stl = stash list
    sta = stash apply 

	co = checkout
	cob = checkout -b
	br = branch

	type = cat-file -t
	dump = cat-file -p

	# list branches sorted by last modified
	b = "!git for-each-ref --sort='-authordate' --format='%(authordate)%09%(objectname:short)%09%(refname)' refs/heads | sed -e 's-refs/heads/--'"

	# list aliases
	la = "!git config -l | grep alias | cut -c 7-"
EOF

fi