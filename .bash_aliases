#!/bin/bash

## directory aliases ##
#######################

# directory traversal
alias up='cd ..'
alias cd..='cd ..'

# directory listing
alias ll='ls -AhlF'
alias la='ls -AF'
alias l.='ls -d .*'
alias l='ls -CF'

## version control ##
#####################

# some git aliases
function ui_process() {
    (eval "$@" 2>&1 &) >/dev/null
}

alias gg='ui_process "git gui"'
alias gk='ui_process "gitk"'

function loc() {
    echo "   lines   words   chars filename"
    wc `find . -type f -name $1 | tr '\n' ' '`
}

function gitstat() {
    git log --author=$1 --pretty=tformat: --numstat | awk '{ adds += $1; subs += $2; loc += $1 - $2 } END { printf "added: %s removed: %s total: %s\n",adds,subs,loc }' -
}

## shell commands ##
####################

# Launch explain shell website for a commnad
function explain {
  # base url with first command already injected
  # $ explain tar
  #   => http://explainshel.com/explain/tar?args=
  url="http://explainshell.com/explain/$1?args="

  # removes $1 (tar) from arguments ($@)
  shift;

  # iterates over remaining args and adds builds the rest of the url
  for i in "$@"; do
    url=$url"$i""+"
  done

  # opens url in browser
  open $url
}

alias fucking='sudo'
alias va='$EDITOR ~/.bash_aliases'
alias sa='. ~/.bash_aliases'
alias h?='history | grep'

## Service Development aliases ##
#################################

function jsoncurl() {
    curl -H "Accept: application/json" -H "Content-Type: application/json" $@
    echo
}

alias blog_serve='bundle exec jekyll serve -D -w --config _config_development.yml &'
alias prc='RAILS_ENV=production RACK_ENV=production rails c'
