#!/bin/bash

usage() {
    echo "Usage: $0 [-f|--force] <config_directory>"
    exit 1
}

installDependencies() {
    apt update

    local dependencies=()
    while IFS= read -r package; do
        dependencies+=("$package")
    done < "$1/dependencies"

    if [ ${#dependencies[@]} -gt 0 ]; then
        apt satisfy -y "${dependencies[@]}"
    fi
}

installRatflowCore() {
    if [ -d "/usr/share/ratflow" ]; then
        echo "ratflow-core already installed, skipping"
        return
    fi

    if [ ! -d "./ratflow-core" ]; then
        echo "Cloning ratflow-core"
        git clone --depth 1 https://github.com/ratflow/ratflow-core
    fi
    pushd ratflow-core
    echo "Installing ratflow-core"
    forceArg=""
    if [ $FORCE_MODE -eq 1 ]; then
        forceArg="-f"
    fi
    ./install.sh $forceArg $CORE_INSTALLER
    popd
}

installIconThemes() {
    wget -qO- https://git.io/papirus-icon-theme-install | sh
}

installUlauncher() {
    pushd /tmp
    # wget https://github.com/Ulauncher/Ulauncher/releases/download/5.15.7/ulauncher_5.15.7_all.deb -O ulauncher.deb
    wget https://github.com/Ulauncher/Ulauncher/releases/download/v6.0.0-beta8/ulauncher_6.0.0.beta8_all.deb -O ulauncher.deb
    apt install -y ./ulauncher.deb
    popd
}

installZimSetup() {
    ln -s /usr/share/ratflow/scripts/zimsetup.sh /usr/bin/zim-setup
}

installResource() {
    local src=$1
    local dst=$2

    # Check for existence of destination and FORCE_MODE not set
    if [ -e "$dst" ] && [ $FORCE_MODE -eq 0 ]; then
        if [ -d "$src" ]; then
            echo "Copying contents without replacing existing files: $dst"
            # Copy directory contents recursively without replacing existing files
            cp -rn "$src/"* "$dst"
        else
            echo "Skipping existing resource: $dst"
            echo "Note: use -f or --force to backup and replace"
        fi
        return
    fi

    # Handle force mode when destination exists
    if [ $FORCE_MODE -eq 1 ] && [ -e "$dst" ]; then
        local backupDir="/var/${PROJECT_NAME}-backups/$(date +%Y%m%d%H%M%S)/"
        mkdir -p "$backupDir$(dirname "$dst")"
        mv "$dst" "$backupDir$dst"
        echo "Backed up $dst to $backupDir"
    fi

    # Copy the source to destination
    if [ -d "$src" ]; then
        # Copy all contents recursively with replacement when FORCE_MODE is 1
        mkdir -p "$dst"
        cp -ra "$src/"* "$dst"
    else
        # This will copy files with replacement when FORCE_MODE is 1
        mkdir -p "$(dirname "$dst")"
        cp -rv "$src" "$dst"
    fi
}


# Function to run scripts in a directory
runScripts() {
    local dir=$1
    for script in "$dir"/*.sh; do
        [ -e "$script" ] || continue
        bash "$script"
    done
}

# Check for at least one argument
if [ $# -lt 1 ]; then
    usage
fi

# Parse arguments
FORCE_MODE=0
CONFIG_DIR=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f|--force) FORCE_MODE=1 ;;
        *) CONFIG_DIR="$1" ;;
    esac
    shift
done

if [[ -z "$CONFIG_DIR" ]]; then
    usage
fi

# Source the project configuration
source "$CONFIG_DIR/config" || { echo "Failed to source config file"; exit 1; }

installRatflowCore

installDependencies "$CONFIG_DIR"

installUlauncher

installIconThemes

# Install resources
while IFS= read -r line; do
    eval "installResource $line"
done < "$CONFIG_DIR/resources"

installZimSetup

# Run pre-installation scripts
runScripts "$CONFIG_DIR/preinst.d"

# Run post-installation scripts
runScripts "$CONFIG_DIR/postinst.d"

echo "Installation completed."
