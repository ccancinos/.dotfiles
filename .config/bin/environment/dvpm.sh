#!/bin/bash
# Alias for projectScript.sh
# alias project='source ~/.config/bin/environment/projectScript.sh && main_run'

source ~/.config/bin/environment/baseScript.sh

# Required for extension
# export WORKSPACE=~/Code/scv/scv-labs
export WORKSPACE=~/Code/avi-on/dashboard-platform
export CURRENT_FILENAME=$(basename -- "$0")
# Internal variables
# export MVP_WORKSPACE=${WORKSPACE}/avi-on-dvp
export MVP_WORKSPACE=${WORKSPACE}
export DVP_FRONTEND_DIR=${MVP_WORKSPACE}/frontend
export DVP_SERVER_DIR=${MVP_WORKSPACE}/server
export DVP_DOCKER_MVP_PROJECT_NAME='dvp-mvp'


function do_tmux_session() {
  cd $WORKSPACE
  tmux new -s 'DVP MVP' -n 'LunarVim'\; send-keys " lvim" ENTER \
    \; new-window -n 'LazyGit'\; send-keys " lazygit" ENTER \
    \; new-window -n 'Terminals'\
    \; select-window -t:1
}

    # "lt --port 3301 --subdomain ccancinos-dvp"
function do_start() {
  local DOCKER_CALL="docker compose -p ${DVP_DOCKER_MVP_PROJECT_NAME}"
  createMainPane "DVP MVP" \
    "Postgres" \
    ${MVP_WORKSPACE} \
    "${DOCKER_CALL} up -d; ${DOCKER_CALL} logs -f --tail 30 postgres"
  createCommandPane "Tunnel" \
    ${MVP_WORKSPACE} \
    "${DOCKER_CALL} up -d; ${DOCKER_CALL} logs -f --tail 30 localtunnel"
  createCommandPane "Frontend" \
    "${DVP_FRONTEND_DIR}" \
    "sleep 1; npm run dev"
  createCommandPane "Localstack" \
    ${MVP_WORKSPACE} \
    "sleep 1; ${DOCKER_CALL} up -d; ${DOCKER_CALL} logs -f --tail 100 localstack"
  createCommandPane "Backend" \
    ${MVP_WORKSPACE} \
    "sleep 1; ${DOCKER_CALL} up -d; ${DOCKER_CALL} logs -f --tail 30 server"
  tmux select-layout tiled  # Call it here to call it less times
}

function do_stop() {
  sleep 1
  pgrep -f "npm run dev"|xargs kill -9
  pushd ${MVP_WORKSPACE}
  docker compose -p ${DVP_DOCKER_MVP_PROJECT_NAME} stop
  tmux set pane-border-status off
  tmux kill-window -t "DVP MVP"
  # Not sure why some times the stack is empty
  if [ -n "$DIRSTACK" ]; then
    popd
  fi
}

function do_restart_server() {
  pushd ${MVP_WORKSPACE}
  docker compose -p dvp-mvp restart server; tmux send-keys -t "DVP\ MVP:DVP\ MVP.4" "docker compose -p dvp-mvp logs -f --tail 30 server" Enter
  if [ -n "$DIRSTACK" ]; then
    popd
  fi
}

function install_dependencies() {
  message "Installing node dependencies in ${LIGHT_GRAY}Server...${NC}"
  pushd ${DVP_SERVER_DIR}
  npm install
  message "Creating ${LIGHT_GRAY}build-info.json...${NC}"
  npm run generate:version-info
  popd
  message "Installing node dependencies in ${LIGHT_GRAY}Frontend...${NC}"
  pushd ${DVP_FRONTEND_DIR}
  npm install
  message "Building ${LIGHT_GRAY}Frontend...${NC}"
  npm run build
  popd
}

function do_pull_project_repos() {
  # pull_repo avi-on-dvp main | log
  pull_repo '' dev
}

function do_api_token() {
  curl -sS --location 'https://api-qa.avi-on.com/sessions' \
    --header 'Content-Type: application/json' \
    --data-raw '{
      "email": "claudio@scvsoft.com",
      "password": "9876Claudio"
    }' | tee >(jq '.') |jq -c '.credentials' | pbcopy
}

function do_ls_s3() {
  aws --endpoint-url=http://localhost:4566 s3 ls s3://floorplans --recursive
}

function do_rm_s3() {
  aws --endpoint-url=http://localhost:4566 s3 rm s3://floorplans --recursive
}

function do_dbsh() {
  # interactive terminal to postgres' psql
  docker exec -it dvp-mvp-postgres-1 sh -c 'psql -U dvp -d dvp'
}

function do_dbclear() {
  # truncates floorplans table in postgres container
  docker exec dvp-mvp-postgres-1 sh -c 'psql -U dvp -d dvp -c "TRUNCATE TABLE floorplans"'
}

function do_print_sub_menu() {
  echo -e "${LIGHT_RED}Services${NC}"
  echo -e "  ${GREEN}start${NC}              - Starts all services:"
  echo -e "  ${GREEN}stop${NC}               - Kill all services matching ${CYAN}${DVP_SERVICES_REGEX}${NC}"
  echo -e "  ${GREEN}restart|r${NC}          - Do a stop and start"
  echo -e "  ${GREEN}restart_server|rs${NC}  - Do a stop and start just the server container"
  echo -e "  ${GREEN}install|i${NC}          - npm install on frontend and server"
  echo -e "  ${GREEN}api_token|at${NC}       - gets api_token from avi-on"
  echo -e "${LIGHT_RED}Storage${NC}"
  echo -e "  ${GREEN}ls3${NC}                - list all S3 elements in the floorplan bucket"
  echo -e "  ${GREEN}rm3${NC}                - deletes all S3 elements in the floorplan bucket"
  echo -e "  ${GREEN}dbsh${NC}               - interactive psql console"
  echo -e "  ${GREEN}dbclear${NC}            - truncates floorplans table"
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
    restart_server|rs)
      do_restart_server
      ;;
    install|i)
      install_dependencies
      ;;
    api_token|at)
      do_api_token
      ;;
    ls3)
      do_ls_s3
      ;;
    rm3)
      do_rm_s3
      ;;
    dbsh)
      do_dbsh
      ;;
    dbclear)
      do_dbclear
      ;;
    *)
      return 1
      ;;
  esac
  return 0
}
