#!/bin/bash
# Alias for projectScript.sh
# alias project='source ~/.config/bin/environment/projectScript.sh && main_run'

source ~/.config/bin/environment/baseScript.sh

# Required for extension
export WORKSPACE=~/Code/scv
export CURRENT_FILENAME=$(basename -- "$0")
export CALLING_SCRIPT="$(dirname "$(realpath "$0")")/$CURRENT_FILENAME"
# Internal variables
export SCV_SCM_DIR=${WORKSPACE}/Oz/packages/cms
export SCV_INTRANET_DIR=${WORKSPACE}/Oz/packages/intranet
export SCV_SITE_DIR=${WORKSPACE}/Oz/packages/site
export SCV_RESUMEBUILDER_DIR=${WORKSPACE}/Oz/packages/resume-builder



function do_tmux_session() {
  cd $WORKSPACE
  tmux new -s SCVIntranet -n 'LunarVim'\; send-keys " lvim" ENTER \
    \; new-window -n 'LazyGit'\; send-keys " cd Oz && lazygit" ENTER \
    \; new-window -n 'Terminals'\; send-keys " cd Oz" ENTER \
    \; select-window -t:1
}

function do_startIntranet() {
  createMainPane "Intranet" \
    "CMS" \
    ${SCV_INTRANET_DIR} \
    "docker compose up -d; docker compose logs -f --tail 100 cms"
  createCommandPane "Frontend" \
    "${SCV_INTRANET_DIR}/frontend" \
    "sleep 65; npm run dev"
  createCommandPane "Backend" \
    "${SCV_INTRANET_DIR}" \
    "sleep 60; docker compose up -d; docker compose logs -f --tail 100 intranet-backend"
  tmux select-layout tiled  # Call it here to call it less times
}

function do_stopIntranet() {
  sleep 1
  pgrep -f "npm run dev"|xargs kill -9
  pushd ${SCV_INTRANET_DIR}
  docker compose stop
  tmux set pane-border-status off
  tmux kill-window -t "Intranet"
  popd
}

function do_startResumeBuilder() {
  createMainPane "ResumeBuilder" \
    "CMS" \
    ${SCV_RESUMEBUILDER_DIR} \
    "docker compose up -d; docker compose logs -f --tail 100 cms"
  createCommandPane "Backend" \
    "${SCV_RESUMEBUILDER_DIR}" \
    "sleep 60; docker compose up -d; docker compose logs -f --tail 100 resume-builder-backend"
  createCommandPane "Frontend" \
    "${SCV_RESUMEBUILDER_DIR}/frontend" \
    "sleep 60; npm start"
  tmux select-layout tiled  # Call it here to call it less times
}

function do_stopResumeBuilder() {
  sleep 1
  pgrep -f "npm start"|xargs kill -9
  pushd ${SCV_RESUMEBUILDER_DIR}
  docker compose stop
  tmux set pane-border-status off
  tmux kill-window -t "ResumeBuilder"
  popd
}

function install_dependencies() {
  message "Installing node dependencies in ${LIGHT_GRAY}Oz...${NC}"
  pushd ${WORKSPACE}/Oz
  npm install
  popd
}

function do_pull_project_repos() {
  # pull_repo avi-on-dvp main | log
  pull_repo Oz develop
}

function do_create_intranet_secret_key() {
  pushd ${SCV_INTRANET_DIR}/server
  npx @fastify/secure-session > secret-key
  popd
}

function do_print_sub_menu() {
  echo -e "${LIGHT_RED}Services${NC}"
  echo -e "  ${GREEN}start_intra|si${NC} - Starts all services: optiturn(3000),asn(3032),receiving(3010),forward_orders(3017),catalogs(3018),units(3019),prometheus,sd_gateway(4010),sd_rules(4011)"
  echo -e "  ${GREEN}kill_intra|ki${NC}  - Kill all services matching ${CYAN}${SCV_SERVICES_REGEX}${NC}"
  echo -e "  ${GREEN}start_resume|sr${NC} - Starts all services: optiturn(3000),asn(3032),receiving(3010),forward_orders(3017),catalogs(3018),units(3019),prometheus,sd_gateway(4010),sd_rules(4011)"
  echo -e "  ${GREEN}kill_resume|kr${NC}  - Kill all services matching ${CYAN}${SCV_SERVICES_REGEX}${NC}"
  echo -e "  ${GREEN}secret_key${NC}        - Create the secret-key needed for managing secure cookies in intranet"
  # echo -e "${LIGHT_RED}Project Specifics${NC}"
  # echo -e "  ${GREEN}title${NC}             - Creates a branch title from a string replacing spaces with - and copy it to the clipboard."
  # echo -e "  ${GREEN}clear_dev_logs${NC}    - Clears both test and development log files"
}

# Required for extension
# Return 0 if
function run() {
  case $1 in
    start_intra|si)
      do_startIntranet
      ;;
    kill_intra|ki)
      # https://www.digitalocean.com/community/tutorials/how-to-use-bash-s-job-control-to-manage-foreground-and-background-processes
      do_stopIntranet
      ;;
    start_resume|sr)
      do_startResumeBuilder
      ;;
    kill_resume|kr)
      # https://www.digitalocean.com/community/tutorials/how-to-use-bash-s-job-control-to-manage-foreground-and-background-processes
      do_stopResumeBuilder
      ;;
    secret_key)
      do_create_intranet_secret_key
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

