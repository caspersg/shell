# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias clip='xclip -se c'

alias ga='git add -p'
alias gc='git commit'
alias gca='git commit --amend'
alias gs='git status'
alias gps='git push'
alias gco='git checkout'
alias gcop='git checkout -p'
alias gss='git stash'
alias gsp='git stash pop'
alias gpl='git pull'
alias gppl='gco target && git pull'
alias gd='git diff --color-words'
alias gdc='git diff --color-words --cached'
alias gl='git log --oneline --graph --decorate --all'
alias gcp='git cherry-pick'
alias gmt='git mergetool'
alias quiet='echo silent | sudo tee /sys/devices/platform/sony-laptop/thermal_control'
gitLinesChangedUser() {
  git log --author="$1" --since="$2" --pretty=tformat: --numstat \
| gawk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }' -
}
alias glines=gitLinesChangedUser
alias gcommits='git shortlog -sn'

alias ber='bundle exec rake'
alias be='bundle exec'

# function instead of alias for arguments

gcm() {
  git commit -m "$*"
}

kl() {
  kill -9 %$1
}