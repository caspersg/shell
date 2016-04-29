
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

# general aliases/functions
alias ll='ls -alFG'
sbp() { source ~/.bash_profile ; }

e() { atom $*; }
ebp() { e ~/.bash_profile ~/.bash_aliases ; }
la() { ls -A $*; }
l() { ls -CF $*; }

# osx
clip() { xclip -se c ;}

# git
ga() { git add -p $*; }
gc() { git commit $*; }
gca() { git commit --amend; }
gs() { git status; }
gps() { git push $*; }
gpsu() { gps -u origin HEAD; }
gco() { git checkout $*; }
gcop() { gco -p $*; }
gcob() { gco -b $*; }
gss() { git stash; }
gsp() { git stash pop; }
gpl() { git pull --rebase; }
gppl() { gco target && gpl; }
gd() { git diff --color-words $*; }
gdc() { git diff --color-words --cached $*; }
gdn() { gd --name-only $*; }
gl() { git log --oneline --graph --decorate --all; }
gcp() { git cherry-pick $*; }
gmt() { git mergetool; }
gmm() { gss && gco master && gpl && gco - && git merge master; }
grm() { gco master && gpl && gco - && git rebase master; }
gpristine() { git reset --hard && git clean -dfx; }
gui() { git update-index --assume-unchanged $*; }
gcommits() { git shortlog -sn; }
glines() {
  git log --author="$1" --since="$2" --pretty=tformat: --numstat \
| gawk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }' - ;
}
gcm() { git commit -m "$*"; }

# ruby
ber() { bundle exec rake $*; }
be() { bundle exec $*; }
binc() { bundle install --no-deployment && bundle clean --force; }
rbv() { rm -rf .bundle vendor; }
tld() { tail -f log/development.log; }


# system
k9() { kill -9 $*; }
kl() { k9 %$1; }
kill_all() { ps -A | grep $* | cut -d' ' -f1 | xargs -I {} k9 {}; }
findgrep() { find . | xargs grep -s $*; }
untilfail() {
  count=0
  while (time $*); do (( count++ )); done
  echo "failed on attempt $count"
}

forEachIn() {
  for ITEM in `ls $1`
  do
    echo "for $1/$ITEM $2"
    pushd $1/$ITEM
    eval $2 || return $?
    popd
  done
}

forprojects() {
  for PROJ in ${PROJECT_NAMES[@]}
  do
    # echo "for $PROJECTS/${PROJ} $*"
    pushd $PROJECTS/${PROJ}
    eval $* || return $?
    popd
  done
}

insert_start() { echo $1 | cat - $2 > temp_file.insert_start && mv temp_file.insert_start $2; }

# Add an "alert" alias for long running commands.  Use like so:
# sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
