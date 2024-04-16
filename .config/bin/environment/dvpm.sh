#!/bin/bash
# Alias for projectScript.sh
# alias project='source ~/.config/bin/environment/projectScript.sh && main_run'

source ~/.config/bin/environment/baseScript.sh

# Required for extension
export WORKSPACE=~/Code/scv/scv-labs
export CURRENT_FILENAME=$(basename -- "$0")
# Internal variables
export MVP_WORKSPACE=${WORKSPACE}/avi-on-dvp
export DVP_FRONTEND_DIR=${MVP_WORKSPACE}/frontend
export DVP_SERVER_DIR=${MVP_WORKSPACE}/server
export DVP_DOCKER_MVP_PROJECT_NAME='dvp-mvp'


function do_tmux_session() {
  cd $WORKSPACE
  tmux new -s SCVDVP -n 'LunarVim'\; send-keys " lvim" ENTER \
    \; new-window -n 'LazyGit'\; send-keys " cd avi-on-dvp && lazygit" ENTER \
    \; new-window -n 'Terminals'\; send-keys " cd avi-on-dvp" ENTER \
    \; select-window -t:1
}

function do_start() {
  local DOCKER_CALL="docker compose -p ${DVP_DOCKER_MVP_PROJECT_NAME}"
  createMainPane "DVP MVP" \
    "Postgres" \
    ${MVP_WORKSPACE} \
    "${DOCKER_CALL} up -d; ${DOCKER_CALL} logs -f --tail 30 postgres"
  createCommandPane "Frontend" \
    "${DVP_FRONTEND_DIR}" \
    "sleep 30; npm run dev"
  createCommandPane "Backend" \
    ${MVP_WORKSPACE} \
    "sleep 30; ${DOCKER_CALL} up -d; ${DOCKER_CALL} logs -f --tail 30 server"
  tmux select-layout tiled  # Call it here to call it less times
}

function do_stop() {
  sleep 1
  pgrep -f "npm run dev"|xargs kill -9
  pushd ${MVP_WORKSPACE}
  docker compose -p ${DVP_DOCKER_MVP_PROJECT_NAME} stop
  tmux set pane-border-status off
  tmux kill-window -t "DVP"
  popd
}

function install_dependencies() {
  message "Installing node dependencies in ${LIGHT_GRAY}Frontend...${NC}"
  pushd ${DVP_FRONTEND_DIR}
  npm install
  popd
  message "Installing node dependencies in ${LIGHT_GRAY}Server...${NC}"
  pushd ${DVP_SERVER_DIR}
  npm install
  popd
}

function do_pull_project_repos() {
  # pull_repo avi-on-dvp main | log
  pull_repo avi-on-dvp main
}

function do_print_sub_menu() {
  echo -e "${LIGHT_RED}Services${NC}"
  echo -e "  ${GREEN}start${NC}      - Starts all services:"
  echo -e "  ${GREEN}stop${NC}       - Kill all services matching ${CYAN}${DVP_SERVICES_REGEX}${NC}"
  echo -e "  ${GREEN}restart|r${NC}  - Do a stop and start"
  echo -e "  ${GREEN}install|i${NC}  - npm install on frontend and server"
  # echo -e "  ${GREEN}mr_status${NC}         - List status of My MRs"
  # echo -e "  ${GREEN}migrate | m${NC}       - Run database migrations. Migrates all or one of: inventory/asn/receiving/forward_orders/catalogs/units"
  # echo -e "  ${GREEN}test_clients${NC}      - Executes receiving test in Optics"
}

# Required for extension
# Return 0 if
function run() {
  case $1 in
    restart|r)
      do_stop && sleep 1 && install_dependencies && do_start
      ;;
    install|i)
      install_dependencies
      ;;
    *)
      return 1
      ;;
  esac
  return 0
}
