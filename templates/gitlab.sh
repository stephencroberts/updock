#!/usr/bin/env bash
#
# Gitlab updock template
#
# Author: Stephen Roberts <stephenroberts@gmail.com>
# Version: 1

: "${GITLAB_CONFIG?GitLab config directory is required. Set GITLAB_CONFIG.}"
: "${GITLAB_LOGS?GitLab logs directory is required. Set GITLAB_LOGS.}"
: "${GITLAB_DATA?GitLab data directory is required. Set GITLAB_DATA.}"
: "${GITLAB_URL?GitLab URL is required. Set GITLAB_URL.}"

GITLAB_HTTP_PORT="${GITLAB_HTTP_PORT:-80}"
GITLAB_HTTPS_PORT="${GITLAB_HTTPS_PORT:-443}"
GITLAB_SSH_PORT="${GITLAB_SSH_PORT:-22}"

export IMAGE="${IMAGE:-gitlab/gitlab-ce:latest}"

##############################
# Starts the docker container
#
# Arguments:
#   container name
#   image name
##############################
function start_container() {
  docker run -d \
    --restart always \
    -p "$GITLAB_HTTP_PORT":80 \
    -p "$GITLAB_HTTPS_PORT":443 \
    -p "$GITLAB_SSH_PORT":22 \
    -v "${GITLAB_CONFIG}":/etc/gitlab \
    -v "${GITLAB_LOGS}":/var/log/gitlab \
    -v "${GITLAB_DATA}":/var/opt/gitlab \
    --name "$1" \
    "$2"
}

################################################################################
# Checks if the app is running
#
# This function should exit non-zero as long as the app is not running properly.
# It will be polled every second, waiting for the specified timeout.
################################################################################
function is_running() {
  curl --output /dev/null --silent --head --fail "$GITLAB_URL"
}

###################################
# Puts the app in maintenance mode
#
# Arguments:
#   container name
###################################
function enter_maintenance_mode() {
  docker exec "$1" gitlab-ctl deploy-page up
}

######################################
# Removes the app from maintence mode
#
# Arguments:
#   container name
######################################
function exit_maintenance_mode() {
  docker exec "$1" gitlab-ctl deploy-page down
}

##############################
# Gets the version of the app
#
# Arguments:
#   container name
##############################
function get_version() {
  docker exec "$1" cat /opt/gitlab/version-manifest.txt | grep gitlab-ce |\
    sed 's/gitlab-ce //'
}

##############################
# Creates a backup of the app
#
# Arguments:
#   container name
##############################
function backup() {
  docker exec "$1" gitlab-rake gitlab:backup:create
}

#################################
# Restores the app from a backup
#
# Arguments:
#   container name
#################################
function restore() {
  docker exec "$1" gitlab-ctl reconfigure
  docker exec "$1" gitlab-rake gitlab:backup:restore
}

