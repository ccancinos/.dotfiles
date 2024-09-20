#!/bin/bash
# Alias for baseScript.sh
# alias base='source ~/Code/scv/scv-labs/environment/splitScript/example/baseScript.sh && main_run'

# Declare this variables with specific values
# export WORKSPACE=~/Code/scv/scv-labs/environment/splitScript/example
# export CURRENT_FILENAME=$(basename -- "$0")

# Abstract variables for all scripts
# Doing this uses previous call values, moving them below
# export ALIAS_NAME="${CURRENT_FILENAME%.*}"
# export CALLING_SCRIPT="$(dirname "$(realpath "$0")")/$CURRENT_FILENAME"


# =====================================
# ===         IMPLEMENT             ===
# =====================================
function do_tmux_session(){
  echo 'Implement Me!!!'
}

function do_start() {
  echo "Implement do_start!!! ${WORKSPACE}"
}

function do_stop() {
  echo "Implement do_start!!! ${WORKSPACE}"
}

# =====================================
# ===         COLORS                ===
# =====================================
BLACK='\033[0;30m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
BROWN='\033[0;33m'
LIGHT_GRAY='\033[0;37m'
DARK_GRAY='\033[1;30m'
LIGHT_BLUE='\033[1;34m'
LIGHT_GREEN='\033[1;32m'
LIGHT_CYAN='\033[1;36m'
LIGHT_RED='\033[1;31m'
LIGHT_PURPLE='\033[1;35m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'

# =====================================
# ===      MESSAGE UTILITIES        ===
# =====================================
function progress_message() {
  echo -e "${CYAN}=========================================================================================================${NC}"
  message $*
  echo -e "${CYAN}=========================================================================================================${NC}"
}

function message() {
  local TIME=`date +"%Y-%m-%d %H:%M:%S"`
  echo -e "${CYAN}[$TIME] $*${NC}"
}

function error() {
  echo -e "${RED}$*${NC}"
}

function warn() {
  echo -e "${YELLOW}$*${NC}"
}

function success() {
  echo -e "${GREEN}$*${NC}"
}

function terminal_name {
  echo -ne "\033]0;"$*"\007"
  tmux set pane-border-status top
  tmux select-pane -T "$*"
}

# =====================================
# ===           TMUX                ===
# =====================================
# createMainPane <WindowTitle> <PaneTitle> <Path> <Command>
function createMainPane() {
  local window_title="${1}"
  local pane_title="${2}"
  local command="cd ${3};${4}"
  tmux new-window -n "${window_title}"
  tmux send-keys "${command}" ENTER
  tmux set pane-border-status top
  tmux select-pane -T "${pane_title}"
}

# createCommandPane <PaneTitle> <Path> <Command>
function createCommandPane() {
  local title="${1}"
  local command="cd ${2};${3}"
  tmux splitw
  tmux send-keys "${command}" ENTER
  tmux select-pane -T "${title}"
}

# =====================================
# ===           BASE                ===
# =====================================
function log() {
  tee -a ${WORKSPACE}/dev_script.log
}

function do_sharessh() {
  ssh -R 80:localhost:${1} ssh.localhost.run
  # If I want to use another name instead of my user name
  # ssh -R 80:localhost:$2 custom-name@ssh.localhost.run
}

function install_dependencies() {
  if [[ -f "Gemfile" ]]; then
    message "Checking gem dependencies..."
    bundle check || bundle install
  else
    message "No Gemfile in this directory :)"
  fi

  if [[ -f ".npmrc" ]]; then
    #   TODO: do something similar to bundle check before install
    message "Installing node dependencies..."
    npm install
  else
    message "No .npmrc in this directory :)"
  fi
}

function pull_repo() {
  local REPO="https://github.com/scvsoft/$1.git"
  # Get the URL used for fetching from the remote repository
  local REPO=$(git remote -v | grep origin | grep "(fetch)" | awk '{print $2}')
  local DIR="$WORKSPACE/$1"
  local BRANCH="$2"

  message "param: $1"
  message "trying to pull from: $DIR"
  if [[ -d "$DIR" ]] ; then
    progress_message "Updating project ${LIGHT_GRAY}$1${NC} ${CYAN}to branch${NC} ${LIGHT_GRAY}$2${NC}"
    pushd ${DIR}
    git checkout ${BRANCH}
    git pull
  else
    message "Repo not found $REPO"
    # message "Cloning $REPO into $DIR ..."
    # pushd ${WORKSPACE}
    # git clone -b ${BRANCH} ${REPO}
    # pushd ${DIR}
  fi
  install_dependencies
}

function do_pull_repositories() {
  local REPO=$1

  if [[ ! -z ${REPO} ]]; then
    pull_repo ${REPO} main | log
  else
    progress_message "Updating repositories"
    do_pull_project_repos
  fi
}

function do_git_checkout() {
  local tags branches target branch_name
  branches=$(
    git --no-pager branch --all\
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
#   tags=$(
#     git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches") |
    fzf --height 20% --no-hscroll --no-multi -n 2 --layout=reverse \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return

  branch_name=$(awk '{print $2}' <<<"$target" )
  if [[ $branch_name == origin/* ]]; then
    local base_name=$(basename ${branch_name})
    git checkout -b ${base_name} ${branch_name}
  else
    git checkout ${branch_name}
  fi
}

function do_fix_upstream() {
  pushd $WORKSPACE
  git branch --set-upstream-to=origin/$(git branch | grep \* | cut -d ' ' -f2) $(git branch | grep \* | cut -d ' ' -f2)
  # Original command from Quizlet
  # alias.fixupstream=!sh -c "git branch --set-upstream-to=origin/$(git branch | grep \* | cut -d ' ' -f2) $(git branch | grep \* | cut -d ' ' -f2)"
  popd
}

function do_docker_status() {
  progress_message "Containers"
  docker ps -a --format 'table {{.ID}}\t{{.Label "com.docker.compose.project"}}\t{{.Label "com.docker.compose.service"}}\t{{.Names}}\t{{.State}}\t{{.Label "com.docker.compose.image" | printf "%.19s"}}\t{{.Ports}}'
}

function do_print_menu() {
  local ALIAS_NAME="${CURRENT_FILENAME%.*}"
  local CALLING_SCRIPT="$(dirname "$(realpath "$0")")/$CURRENT_FILENAME"
  echo ${CALLING_SCRIPT}
  echo ${CURRENT_FILENAME}
  echo ${ALIAS_NAME}

  echo -e "usage: ${YELLOW}$ALIAS_NAME${NC} ${GREEN}<command>${NC} where command is one of the following in green!!!!:"
  echo
  echo -e "${LIGHT_RED}Local${NC}"
  echo -e "  ${GREEN}sharessh${NC}          - Shares local web server to the world.2nd argument is the local port.Ex: ${CYAN}scv sharessh 3002${NC}.Uses http://localhost.run/"
  echo -e "  ${GREEN}pull${NC}              - Update all the git repositories to their master/develop/main branch. If 2nd arg, update just that"
  echo -e "  ${GREEN}checkout | co${NC}     - Quick checkout branch."
  echo -e "  ${GREEN}fixupstream | fu${NC}  - Fix upstream for current branch"
  echo -e "  ${GREEN}tmuxsession${NC}       - Create tmux session with initial windows"
  echo -e "${LIGHT_RED}Docker${NC}"
  echo -e "  ${GREEN}status  | s${NC}       - Displays which docker containers are running"
  echo -e "  ${GREEN}title${NC}             - Creates a branch title from a string replacing spaces with - and copy it to the clipboard"
  # echo -e "  ${GREEN}logs    | l${NC}       - Live tail log for a container."
  # echo -e "  ${GREEN}bash    | b${NC}       - Run bash on a container."
  # echo -e "  ${GREEN}gc${NC}                - Garbage collect (delete) unused containers and images."
  if [[ -n "$CALLING_SCRIPT" ]]; then
    do_print_sub_menu
  fi
}

function main_run() {
  CWC=$(pwd)

  case $1 in
    sharessh)
      do_sharessh $2
      ;;
    fixupstream|fu)
      do_fix_upstream
      ;;
    checkout|co)
      do_git_checkout
      ;;
    status|s)
      do_docker_status
      ;;
    title)
      array="${@:2}" # Returns all args from second
      echo "${array}" | sed -E "s/'//g; s/[&: \"]/-/g"
      echo "${array}" | sed -E "s/'//g; s/[&: \"]/-/g" | pbcopy
      ;;
    menu)
      do_print_menu
      ;;
    tmuxsession)
      do_tmux_session
      ;;
    pull)
      do_pull_repositories $2
    ;;
    start)
        do_start
      ;;
    stop)
        do_stop
      ;;
    *)
      eval run "$@"
      retval="$?"
      if [ $retval -ne 0 ]
      then
        # echo '0 means error..'
        do_print_menu
      else
        echo 'ok...'
      fi
      ;;
  esac

  cd $CWC
}

