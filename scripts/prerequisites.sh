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

setup_rust() {
    info "Setting up Rust toolchain..."
    
    # Check if rustup is available (should be installed via Homebrew)
    if ! command -v rustup &> /dev/null; then
        error "rustup not found. Make sure 'brew install rustup-init' was successful"
        return 1
    fi
    
    # Initialize rustup if not already done
    if [ ! -d "$HOME/.rustup" ]; then
        info "Initializing rustup..."
        rustup-init -y --no-modify-path
        source "$HOME/.cargo/env"
    else
        warning "Rustup already initialized"
    fi
    
    # Install and set Rust 1.83 as default
    info "Installing Rust 1.83..."
    rustup toolchain install 1.83
    rustup default 1.83
    
    # Verify installation
    RUST_VERSION=$(rustc --version 2>/dev/null | grep -o "1\.83\.[0-9]*")
    if [ -n "$RUST_VERSION" ]; then
        success "Rust $RUST_VERSION installed and set as default"
    else
        warning "Rust installed but version verification failed"
    fi
}

setup_rbenv() {
    info "Setting up Ruby with rbenv..."
    
    # Check if rbenv is available (should be installed via Homebrew)  
    if ! command -v rbenv &> /dev/null; then
        error "rbenv not found. Make sure 'brew install rbenv ruby-build' was successful"
        return 1
    fi
    
    # Initialize rbenv
    eval "$(rbenv init - zsh)"
    
    # Install Ruby 3.2.2 if not already installed
    if ! rbenv versions | grep -q "3.2.2"; then
        info "Installing Ruby 3.2.2..."
        rbenv install 3.2.2
    else
        warning "Ruby 3.2.2 already installed"
    fi
    
    # Set as global default
    rbenv global 3.2.2
    
    # Verify installation
    RUBY_VERSION=$(ruby --version 2>/dev/null | grep -o "3\.2\.2")
    if [ -n "$RUBY_VERSION" ]; then
        success "Ruby $RUBY_VERSION installed and set as default"
        
        # Install bundler
        info "Installing bundler gem..."
        gem install bundler
    else
        warning "Ruby installed but version verification failed"
    fi
}

setup_java() {
    info "Setting up Java environment..."
    
    # Java should be installed via Homebrew cask 'temurin21'
    # Find Java 21 installation path
    JAVA_HOME_PATH=""
    
    # Check common locations for Temurin 21
    if [ -d "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home" ]; then
        JAVA_HOME_PATH="/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home"
    elif [ -d "/opt/homebrew/opt/openjdk@21" ]; then
        JAVA_HOME_PATH="/opt/homebrew/opt/openjdk@21"
    fi
    
    if [ -n "$JAVA_HOME_PATH" ]; then
        success "Java 21 found at $JAVA_HOME_PATH"
        export JAVA_HOME="$JAVA_HOME_PATH"
        
        # Verify Java version
        JAVA_VERSION=$(java -version 2>&1 | head -n 1 | grep -o "21\.[0-9]*\.[0-9]*")
        if [ -n "$JAVA_VERSION" ]; then
            success "Java $JAVA_VERSION configured successfully"
        else
            warning "Java found but version verification failed"
        fi
    else
        warning "Java 21 installation not found. Make sure 'brew install --cask temurin21' was successful"
    fi
}

if [ "$(basename "$0")" = "$(basename "${BASH_SOURCE[0]}")" ]; then
    install_xcode
    install_homebrew
    install_nvm
    setup_rust
    setup_rbenv  
    setup_java
fi
