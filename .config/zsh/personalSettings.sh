# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13
ZSH_CUSTOM_AUTOUPDATE_QUIET=true

export GH_TOKEN=<ChangeMe>

# Enable vi mode
bindkey -v
bindkey -s "^ts" '~/.config/bin/tmux-sessionizer.sh^M'

# Avoid duplicates in history
# https://unix.stackexchange.com/questions/599641/why-do-i-have-duplicates-in-my-zsh-history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# Handle dotfiles with github
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias edit="open -a 'Rubymine 3' $1"
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches -- $1"
alias gbase-branch=fgbase-branch
alias gmove=fgmove
alias lazyconfig='lazygit --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias gitconfig='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
# Use lazygit with defined config file
alias lazygit='CONFIG_DIR=~/.config/lazygit lazygit'
alias lvim=~/.local/bin/lvim
# Some alias taken from https://pastebin.com/raw/UWHMV2QF
alias myip="curl http://ipecho.net/plain; echo"
alias reload="source ~/.zshrc"
alias runp="lsof -i -P"
alias ports="lsof -i -P | grep LISTEN"
alias topten="history | commands | sort -rn | head"
alias usage='du -h -d1'

# Shows base branch from which this branch was created
function fgbase-branch() {
  git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
}

# Move base branch to a new branch
# Usefull when a branch from main now should extends from an intermediate branch
# ie: If I want to move branch2 from extending branch1 to now extend develop:
#   git rebase --onto develop branch1 branch2
#   fmove develop branch1 branch2
function fgmove() {
  local newBase=$1
  local currentBase=$2
  local branchToMove=$3
  git rebase --onto ${newBase} ${currentBase} ${branchToMove}
}

commands() {
  awk '{a[$2]++}END{for(i in a){print a[i] " " i}}'
}

# Process list using a TPC port
function port_proc() {
  lsof -i TCP:${1} | grep LISTEN
}

# Kills process list using a TCP port
function port_proc_kill() {
  lsof -i TCP:${1} | grep LISTEN | awk '{print $2}' | xargs kill -9
}
