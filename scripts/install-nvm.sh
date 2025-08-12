#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh
. $SCRIPT_DIR/prerequisites.sh

info "Starting NVM installation..."
install_nvm

info "NVM installation completed."
info "To start using NVM in your current terminal session, run:"
info "source ~/.zshrc"
info ""
info "Node.js 20.11.0 has been installed and set as default."
info ""
info "You can use these commands:"
info "nvm list                    - Show installed Node versions"
info "nvm install 18             - Install Node.js v18"
info "nvm use 18                 - Switch to Node.js v18"
info "nvm install --lts          - Install latest LTS version"
info "nvm alias default 20.11.0  - Set 20.11.0 as default"
