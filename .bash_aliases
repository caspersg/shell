# bash history
# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
trap 'history -r' USR1
# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

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

#function to display commands
function exe { echo "\$ $@" ; "$@" ; }

# create shortcut
function shortcut {
  NAME=$1;
  shift;
  eval "function ${NAME} { exe $@; }";
}

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
gsk() { git stash --keep-index; }
gpl() { git pull --autostash --rebase; }
gppl() { gco target && gpl; }
gd() { git diff --color-words $*; }
gdc() { git diff --color-words --cached $*; }
gdn() { gd --name-only $*; }
gl() { git log --oneline --graph --decorate --all; }
glfn() { git log --graph --decorate --all --name-status; }
gcp() { git cherry-pick $*; }
gmt() { git mergetool; }
gmm() { gss && gco master && gpl && gco - && git merge master; }
grebase() { gco $1 && gpl && gco - && git rebase --autostash $1; }
grm() { grebase master; }
gpristine() { git reset --hard && git clean -dfx; }
gui() { git update-index --assume-unchanged $*; }
gcommits() { git shortlog -sn; }
glines() {
  git log --author="$1" --since="$2" --pretty=tformat: --numstat \
| gawk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }' - ;
}
shortcut 'gcm' 'git commit -m "$*"'

# ruby
shortcut 'be' 'bundle exec $*'
shortcut 'ber' 'be rake $*'
shortcut 'beg' 'be guard $*'
shortcut 'binc' 'bundle install --no-deployment && bundle clean --force'
shortcut 'rbv' 'rm -rf .bundle vendor'
shortcut 'tld' 'tail -f log/development.log'

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


# project specific aliases
export PROJECTS=~/projects
export PROJECT_NAMES=(core authentications messaging events pods hosted-vendors shares platform)

rdc() { ber deploy:clean; }
rd() { ber deploy; }
rde() { ber db:seed; }
rds() { ber deploy:status; }
db_start() { pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start; }
start_postgres() { db_start; }
scheduler_console() {
   DISABLE_JOB_INITIALIZER=true rails c; #ScheduledEvent.delete_all
}

cp_consumption_data() { cp ~/EIEPin/template ~/EIEPin/$1; }
# jlls() { ~/opt/s3cmd-1.5.2/s3cmd ls s3://ap-se-2-mywave-jenkins-logs; }
# jlsync() { ~/opt/s3cmd-1.5.2/s3cmd sync -r --no-mime-magic s3://ap-se-2-mywave-jenkins-logs/$1 ~/logs; }
# jls() {
#   jlsync platform-intermittent-failure-detection
#   jlsync platform-java-ruby-pr
#   jlsync platform-java-ruby-test-runner
#   jlsync platform-java-ruby
# }
# jldl() {
#   # platform-intermittent-failure-detection
#   # platform-java-ruby-pr
#   # platform-java-ruby-test-runner
#   # platform-java-ruby
#   ~/opt/s3cmd-1.5.2/s3cmd get -r --no-mime-magic s3://ap-se-2-mywave-jenkins-logs/$1 ~/logs
# }

# rta() {
#   forprojects gs &&
#   forprojects binc &&
#
#   pushd $PROJECTS/platform && ber deploy && popd &&
#
#   forprojects ber test:all
# }

#github
ssh_agent_github() { ssh-add; ssh -T git@github.com; }

alias ls='ls -G'
alias ll='ls -alFG'
