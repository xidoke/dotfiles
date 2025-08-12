#!/bin/bash

# Standalone script to setup development tools

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh
. $SCRIPT_DIR/prerequisites.sh

info "Starting development tools setup..."

printf "\n"
info "===================="
info "Rust Setup"
info "===================="
setup_rust

printf "\n"
info "===================="
info "Ruby Setup"
info "===================="
setup_rbenv

printf "\n"  
info "===================="
info "Java Setup"
info "===================="
setup_java

printf "\n"
info "===================="
info "Testing Installation"
info "===================="

# Make test script executable and run it
chmod +x $SCRIPT_DIR/test-devtools.sh
$SCRIPT_DIR/test-devtools.sh

success "Development tools setup completed!"
info ""
info "To start using these tools in your current terminal:"
info "source ~/.zshrc"
info ""
info "Or open a new terminal session."
