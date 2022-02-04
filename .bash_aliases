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

e() { $EDITOR $*; }
ebp() { e ~/.bash_profile ~/.bash_aliases ; }
la() { ls -A $*; }
l() { ls -CF $*; }
vimInstallPlugins() { vim +PlugInstal +qall; }

# osx
clip() { xclip -se c ;}
alias cat='bat'
#alias find='fd'
alias preview="fzf --preview 'bat --color \"always\" {}'"
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"


# git
shortcut 'ga' 'git add -p $*'
shortcut 'gc' 'git commit $*'
shortcut 'gs' 'git status'
git_branchname() { git symbolic-ref --short HEAD; }
git_push() {
  if [[ `git_branchname` == "master" ]] || [[ `git_branchname` == "main" ]]
  then
    echo "cannot push to master or main";
    return -1;
  else
    git push $*;
  fi
}
shortcut 'gps' 'git_push $*'
shortcut 'gpsu' 'gps --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
shortcut 'gpsforce' 'gps --force-with-lease'
shortcut 'gco' 'git checkout $*'
shortcut 'gcop' 'gco -p $*'
shortcut 'gcob' 'gco -b $*'
shortcut 'gss' 'git stash'
shortcut 'gsp' 'git stash pop'
shortcut 'gsk' 'git stash --keep-index'
shortcut 'gpl' 'git pull --autostash --rebase'
shortcut 'gppl' 'gco target && gpl'
shortcut 'gd' 'git diff --color-words $*'
shortcut 'gdc' 'git diff --color-words --cached $*'
shortcut 'gdn' 'gd --name-only $*'
shortcut 'gl' 'git log --oneline --graph --decorate --all'
shortcut 'glfn' 'git log --graph --decorate --all --name-status'
shortcut 'gcp' 'git cherry-pick $*'
shortcut 'gmt' 'git mergetool'
shortcut 'gmm' 'gss && gco main && gpl && gco - && git merge main'
shortcut 'grebase' 'gco $1 && gpl && gco - && git rebase --autostash $*'
shortcut 'grbc' 'git rebase --continue'
shortcut 'grbm' 'grebase main'
shortcut 'gpristine' 'git reset --hard && git clean -dfx'
shortcut 'gui' 'git update-index --assume-unchanged $*'
shortcut 'gcommits' 'git shortlog -sn'
glines() {
  git log --author="$1" --since="$2" --pretty=tformat: --numstat \
| gawk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }' - ;
}
shortcut 'gca' 'git commit --amend $*'
shortcut 'gcna' 'git commit -n --amend $*'
shortcut 'gcm' 'git commit -m "$*"'
shortcut 'gcnm' 'git commit -n -m "$*"'
shortcut 'gclean' 'git clean -i'
shortcut 'gresetorigin' 'git reset --hard origin/`git branch --show-current`'
shortcut 'git_recent_files' 'git whatchanged --diff-filter=A $*'

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
untilsuccess() {
  count=0
  until $*
  do
    ((count++))
    echo "Try again $count"
  done
  echo "success on attempt $count"
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
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# project specific aliases
export PROJECTS=~/projects
export PROJECT_NAMES=()

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
#export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
#export JAVA_9_HOME=$(/usr/libexec/java_home -v9)
#export JAVA_10_HOME=$(/usr/libexec/java_home -v10)
#export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
#export JAVA_12_HOME=$(/usr/libexec/java_home -v12)
#export JAVA_17_HOME=$(/usr/libexec/java_home -v17)

#alias java8='export JAVA_HOME=$JAVA_8_HOME'
#alias java9='export JAVA_HOME=$JAVA_9_HOME'
#alias java10='export JAVA_HOME=$JAVA_10_HOME'
#alias java11='export JAVA_HOME=$JAVA_11_HOME'
#alias java12='export JAVA_HOME=$JAVA_12_HOME'
#alias java17='export JAVA_HOME=$JAVA_17_HOME'

# default to Java 12
#java17

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

shortcut 'ct' 'cut -d " " -f$*'

# zendesk
shortcut 'z' 'zdi $*'
shortcut 'zs' 'z world status'
shortcut 'zvstart' 'z vm start'
# shortcut 'zrestart' 'z vm start; z vm restart && z apps stop; z services stop; z services start; z apps start'
shortcut 'zrestart' 'zdi vm restart && zdi world restart'
shortcut 'zwr' 'zdi world restart'
shortcut 'zbaserestart' 'zdi consul restart && zdi dnsmasq restart && zdi nginx restart'
shortcut 'zclean' 'pushd ~/projects/zendesk/zdi && gpl && \
	docker_cleaup_volumes && docker_remove_unused_images && \
	echo "**** zdi vm stop" zdi vm stop ; \
	echo "**** vagrant destroy -f" && yes | vagrant destroy -f ; \
	echo "**** rm -rf ~/.vagrant.d" && rm -rf ~/.vagrant.d && \
	echo "**** rm -rf ~/VirtualBox\ VMs/" && rm -rf ~/VirtualBox\ VMs/ && \
	echo "**** brew cask uninstall virtualbox vagrant" && brew cask uninstall virtualbox vagrant '
shortcut 'zbuild' 'pushd ~/projects/zendesk/zdi && gpl && \
	echo "**** brew update && brew upgrade" && brew update && brew upgrade && \
	echo "**** brew cask upgrade " && brew cask upgrade && \
	echo "**** ./bin/onboard" && ./bin/onboard && \
	echo "**** zdi outbound_server seed" && z outbound_server seed && \
	echo "**** zdi update" && z update && zs'
shortcut 'zfresh' 'zclean && zbuild'
shortcut 'clean_unused_images' 'docker system prune --volumes'

# shortcut 'zfresh' 'znuke && z cleanup && z mysql reset && z bootstrap && z outbound_server seed && z update && zrestart && zs'
shortcut 'zmigrate' 'z migrations pull && z migrations migrate'
shortcut 'remote_debug' 'byebug --remote "dev.zd-dev.com:3033"'
shortcut 'migration_setup' 'pushd ../zendesk_database_migrations/ && git pull && zdi migrations pull && zdi migrations -d seed && popd'
shortcut 'resque_web_ssh' 'ssh -NL 9298:misc4.$1:9298 -v $1'
shortcut 'resque_web_ssh_prod' 'resque_web_ssl pod6'
shortcut 'resque_web_ssh_new_staging' 'ssh -NL 9298:miscb1.pod999.use1.zdsystest.com:9298  -v dba999'

shortcut 'goro' 'go run outboundd.go --run-all'
shortcut 'got' 'go test -v ./...'
shortcut 'gotapid' 'go test -check.v github.com/zendesk/server/apitests -tags apitests --env dev'
shortcut 'runnginx' 'sudo nginx -c /opt/outbound/nginx/nginx.conf'
shortcut 'flush_mem_cache_server' 'echo flush_all > /dev/tcp/127.0.0.1/11211'
alias zupdate_outbound='NO_MIGRATE=true zdi update'
shortcut 'cbt-prod' 'cbt -instance=ob-bigtable'
shortcut 'zodr' 'zdi outbound_server -d restart --watch'
shortcut 'zodk' 'zdi outbound_server stop'
shortcut 'zrdlodr' 'zdi outbound_server -ld --remote-debug restart'
shortcut 'zrdodr' 'zdi outbound_server -d --remote-debug restart'
shortcut 'zods' 'zdi outbound_server -d shell'
shortcut 'ztdr' 'zdi outbound_client -d restart'
shortcut 'cdos' 'cd ~/projects/go/src/github.com/zendesk/outbound/'
shortcut 'geds' 'gcloud beta emulators datastore start --project=outbound-dev-170121'
shortcut 'obctl_staging' 'obctl -e us1_staging'
shortcut 'obctl_prod' 'obctl -e us1_prod'

shortcut 'docker_cleaup_volumes' 'docker volume rm $(docker volume ls -qf dangling=true)'
shortcut 'docker_remove_unused_images' 'docker rmi $(docker images | grep "^<none>" | awk "{print $3}")'
shortcut 'statsd_logs' 'docker exec -it $1 /bin/bash -c "go get -u github.com/catkins/statsd-logger/cmd/statsd-logger && statsd-logger"'
shortcut 'statsd_trace' 'docker run --rm -it --name=datadog_agent --net=docker catkins/statsd-logger:tracing'
shortcut 'docker_shell' 'docker exec -it outbound_server /bin/bash'

shortcut 'go_tool_trace' 'go tool trace -http=":3333"'

shortcut 'update_ack_deadline' 'gcloud alpha pubsub subscriptions update projects/outbound-dev-170121/subscriptions/$1 --ack-deadline=$2'

shortcut 'shutdown_outboundd_touch_binary' 'docker exec -it outbound_server bash -c "touch /go/bin/outbound"'
shortcut 'docker_login_container_registry' 'docker-credential-gcr configure-docker; gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://gcr.io ; gcloud docker -- pull gcr.io/docker-images-180022/base/alpine:3.6'

shortcut 'pravda_fix' 'zdi metropolis restart -i gcr.io/docker-images-180022/apps/metropolis-dev:latest && zdi pravda restart'

shortcut 'kubectl_prod' 'kubectl --context connect-production  --namespace connect-server $*'
shortcut 'kubectl_staging' 'kubectl --context connect-staging  --namespace connect-server $*'


# go
shortcut 'go_imports' 'go list -f "{{ join .Imports \"\n\" }}" $1 | grep github.com/zendesk/outbound | grep -v vendor'
shortcut 'go_deps' 'go list -f "{{ join .Deps  \"\n\"}}" $1 | grep github.com/zendesk/outbound | grep -v vendor'
go_graph_deps() { godepgraph -s -p cloud.google.com,golang.org,google.golang.org $1; }
shortcut 'dot_png' 'dot -Tpng -o$1'


# python
# sandbox
#eval "$(pipenv --completion)"
# no longer sufficient eval "$(pyenv init -)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

export DYLD_LIBRARY_PATH=/usr/local/Cellar/mysql/8.0.17_1/lib/

shortcut 'cdso' 'cd ~/projects/zendesk/sandbox_orchestrator'
shortcut 'cdcch' 'cd ~/projects/zendesk/customer-config-history'
shortcut 'zsodr' 'zdi sandbox_orchestrator -d restart'
shortcut 'zwsodr' 'zdi sandbox_orchestrator_worker -d restart'
shortcut 'prtest' 'pipenv run py.test -vv $* --cov-report xml:cov.xml --cov'
shortcut 'psd' 'pipenv sync --dev && pipenv clean'
shortcut 'zsou' 'zdi sandbox_orchestrator update && psd'
shortcut 'sointegrationtest' 'pushd integration_tests && docker-compose build && docker-compose run webapp-integration-test && popd'
shortcut 'vagrant_file_change' 'pushd ~/projects/zendesk/zdi && vagrant plugin install vagrant-notify-forwarder && vagrant reload && popd'
shortcut 'soreset' 'zdi sandbox_orchestrator reset_db && zdi redis restart'
shortcut 'pyclean' 'find . -name '*.pyc' -delete && rm -rf ~/Library/Caches/black/* && pipenv --rm && psd'
shortcut 'pcsd' 'pyclean && psd'
shortcut 'pyblackclean' 'rm -rf ~/Library/Caches/black/*'

# Java shortcuts
shortcut 'gr' './gradlew $*'
shortcut 'grc' './gradlew check -i -t'
shortcut 'grr' './gradlew run -t'

export PIPENV_VERBOSITY=-1
export PYTHONDONTWRITEBYTECODE=1

#export SKIP=isort

function dfm {
  unset DOCKER_FOR_MAC_ENABLED
  unset DOCKER_HOST_IP
  export DOCKER_FOR_MAC_ENABLED=true
  export DOCKER_HOST_PORT=2375
  export DOCKER_HOST=unix:///var/run/docker.sock
}
function dfz {
  export DOCKER_FOR_MAC_ENABLED=false
  export DOCKER_HOST_IP=192.168.42.45
  export DOCKER_HOST_PORT=2375
  export DOCKER_HOST=tcp://192.168.42.45:2375
}
dfm
