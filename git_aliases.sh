#!/bin/bash
git config --global alias.a "add -p"
git config --global alias.ai "add -i -A"
git config --global alias.c "commit"
git config --global alias.s "status"
git config --global alias.ps "push"
git config --global alias.pl "pull --autostash --rebase"
git config --global alias.co "checkout"
git config --global alias.cop "checkout -p"
git config --global alias.b "checkout -b"
git config --global alias.d "diff"
git config --global alias.dc "diff --cached"
git config --global alias.dn "diff --cached --name-only"
git config --global alias.l "log --oneline --graph --decorate --all"
git config --global alias.ld "log --all --graph --pretty=format:'%Cgreen%ad%Creset %C(auto)%h%d %s %C(bold black)%aN%Creset' --date=format-local:'%Y-%m-%d'"
git config --global alias.cp "cherry-pick"
git config --global alias.mt "mergetool"
git config --global alias.rc "rebase --continue"
git config --global alias.pristine "reset --hard && git clean -dfx"
git config --global alias.resetorigin "reset --hard && git clean -dfx"
# shortcut 'gresetorigin' 'git reset --hard origin/`git branch --show-current`'


git config --global alias.st "stash"
git config --global alias.sp "stash pop"
git config --global alias.pu "--set-upstream origin $(git rev-parse --abbrev-ref HEAD)"

git config --global core.editor nvim

# git config --global mergetool.fugitive.cmd 'nvim -f -c "Gvdiffsplit!" "$MERGED"'
# git config merge.conflictstyle diff3
# git config --global merge.tool fugitive
git config merge.conflictstyle diff3
git config --global merge.tool nvimdiff
git config --global mergetool.keepBackup false

git config --global commit.template ~/.gitmessage
