##################################################################################################
# LOCAL CHANGES
##################################################################################################
# Move all .zompdump files from ~/ to a new location
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
##################################################################################################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
plugins=(fd zsh-autosuggestions zsh-syntax-highlighting autoupdate)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


##################################################################################################
# WORK SETTINGS
##################################################################################################
# Script with specific commands for Optoro project
# source ~/Optoro/code/environment/dev.sh
source ~/Code/scv/internal-tools/environment/scv.sh

# Add Qt to PATH
export PATH="$PATH:~/Qt5.5.0/5.5/clang_64/bin:/usr/local/sbin"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
export PATH="/usr/local/Cellar/kubernetes-cli/1.27.1/bin:$PATH"

# alias python3='/usr/bin/python3'
# alias python=python3
# alias pip=pip3

## Google Cloud SDK
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ccancinos/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ccancinos/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/ccancinos/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ccancinos/google-cloud-sdk/completion.zsh.inc'; fi
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
##/ Google Cloud SDK

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$PATH:$HOME/.rvm/scripts/rvm" ]] && source "$PATH:$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Put this into your $HOME/.zshrc to call nvm use automatically whenever you enter a directory that contains an .nvmrc file with a string telling nvm which node to use
# place this after nvm initialization!
# https://github.com/nvm-sh/nvm#zsh
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
#       Launch and forget enclosing the bkg command in a simple subshell
#       (nvm install 2>&1 > /dev/null &)
#       Launch and control later
#       {nvm installl &} 2>&1 > /dev/null
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
#     (nvm use 2>&1 > /dev/null &)
#       {nvm use &} 2>&1 > /dev/null
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    nvm use default
#     echo "Reverting to nvm default version"
#     If cannot find default version run: nvm install --lts # to install the LTS version of Node
#     (nvm use default 2>&1 > /dev/null &)
#     {nvm use default &} 2>&1 > /dev/null
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
##################################################################################################
# WORK SETTINGS
##################################################################################################

##################################################################################################
# PERSONAL STUFF
##################################################################################################
# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13
ZSH_CUSTOM_AUTOUPDATE_QUIET=true

# Enable vi mode
bindkey -v

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
##################################################################################################
# END PERSONAL STUFF
##################################################################################################

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

