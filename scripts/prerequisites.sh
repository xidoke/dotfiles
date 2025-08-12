#!/bin/bash

# Get the absolute path of the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. $SCRIPT_DIR/utils.sh

install_xcode() {
    info "Installing Apple's CLI tools (prerequisites for Git and Homebrew)..."
    if xcode-select -p >/dev/null; then
        warning "xcode is already installed"
    else
        xcode-select --install
        sudo xcodebuild -license accept
    fi
}

install_homebrew() {
    info "Installing Homebrew..."
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
    if hash brew &>/dev/null; then
        warning "Homebrew already installed"
    else
        sudo --validate
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi
}

install_nvm() {
    info "Installing NVM (Node Version Manager)..."
    
    if [ -d "$HOME/.nvm" ]; then
        warning "NVM already installed at $HOME/.nvm"
        return 0
    fi
    
    # Download and install NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    
    # Source NVM for current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        success "NVM installed successfully"
        
        # Install and set Node.js 20.11.0 as default
        info "Installing Node.js 20.11.0..."
        nvm install 20.11.0
        nvm use 20.11.0
        nvm alias default 20.11.0
        
        # Verify installation
        NODE_VERSION=$(node --version 2>/dev/null)
        if [ "$NODE_VERSION" = "v20.11.0" ]; then
            success "Node.js 20.11.0 installed and set as default"
        else
            warning "Node.js installed but version verification failed (got: $NODE_VERSION)"
        fi
    else
        error "NVM installation failed"
        return 1
    fi
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    install_xcode
    install_homebrew
    install_nvm
fi
