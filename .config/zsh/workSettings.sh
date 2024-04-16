# Creates an alias for each script with specific commands for each project
# Directory containing bash files
projectScriptsDirectory="/Users/ccancinos/.config/bin/environment"
# Array of files to exclude
exclude_files=("baseScript")
# Loop through each .sh file in the directory
for file in "$projectScriptsDirectory"/*.sh; do
  # Extract the file name without extension
  filename=$(basename "$file" .sh)
  # Check if the file should be excluded
  [[ " ${exclude_files[@]} " =~ " $filename " ]] && continue
  # Create an alias for the file
  alias_name="$filename"
  alias_command="source $file && main_run"
  alias "$alias_name"="$alias_command"
  # echo "Alias created: $alias_name -> $alias_command"
done
# alias dvp='source ~/.config/bin/environment/dvp.sh && main_run'

# Add Qt to PATH
export PATH="$PATH:~/Qt5.5.0/5.5/clang_64/bin:/usr/local/sbin"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
export PATH="/usr/local/Cellar/kubernetes-cli/1.27.1/bin:$PATH"

alias ts="~/.config/bin/tmux-smart-sessions.sh"

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

# this is for SCV intranet
export NODE_ENV=development
