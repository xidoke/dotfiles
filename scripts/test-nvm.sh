#!/bin/bash

# Test script to verify NVM and Node.js installation

echo "=== Testing NVM Installation ==="

# Check if NVM is installed
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    echo "✓ NVM is installed"
    
    # Source NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Check NVM version
    echo "NVM version: $(nvm --version)"
    
    # Check current Node version
    if command -v node &> /dev/null; then
        echo "✓ Node.js is available"
        echo "Node version: $(node --version)"
        echo "npm version: $(npm --version)"
    else
        echo "✗ Node.js is not available"
    fi
    
    # List installed versions
    echo ""
    echo "Installed Node.js versions:"
    nvm list
    
else
    echo "✗ NVM is not installed"
fi
