#!/bin/sh
set -e

echo "Activating feature 'Antidote (zsh)'"


LATEST_VERSION=$(wget -qO- https://api.github.com/repos/mattmc3/antidote/releases/latest | grep -Po '"name": "\K[^"]+')
DOWNLOAD_URL="https://github.com/mattmc3/antidote/archive/refs/tags/${LATEST_VERSION}.tar.gz"
wget --no-verbose -O /tmp/${LATEST_VERSION}.tar.gz ${DOWNLOAD_URL}

# The 'install.sh' entrypoint script is always executed as the root user.
#
# These following environment variables are passed in by the dev container CLI.
# These may be useful in instances where the context of the final 
# remoteUser or containerUser is useful.
# For more details, see https://containers.dev/implementors/features#user-env-var
echo "The effective dev container remoteUser is '$_REMOTE_USER'"
echo "The effective dev container remoteUser's home directory is '$_REMOTE_USER_HOME'"
mkdir ${ZDOTDIR:-$_REMOTE_USER_HOME}/.antidote
tar -xzf /tmp/${LATEST_VERSION}.tar.gz -C ${ZDOTDIR:-$_REMOTE_USER_HOME}/.antidote  --strip-components=1

echo "The effective dev container containerUser is '$_CONTAINER_USER'"
echo "The effective dev container containerUser's home directory is '$_CONTAINER_USER_HOME'"
# Run commands only if home directories are different
if [ "$_CONTAINER_USER_HOME" != "$_REMOTE_USER_HOME" ]; then
    mkdir ${ZDOTDIR:-$_REMOTE_USER_HOME}/.antidote
    tar -xzf /tmp/${LATEST_VERSION}.tar.gz -C ${ZDOTDIR:-$_REMOTE_USER_HOME}/.antidote  --strip-components=1
fi