#!/bin/bash

# Test script to verify all development tools installation

echo "=== Testing Development Tools Installation ==="

# Java
echo ""
echo "=== JAVA ==="
if command -v java &> /dev/null; then
    echo "✓ Java is available"
    java -version
    if [ -n "$JAVA_HOME" ]; then
        echo "✓ JAVA_HOME is set: $JAVA_HOME"
    else
        echo "✗ JAVA_HOME is not set"
    fi
else
    echo "✗ Java is not available"
fi

# Rust
echo ""
echo "=== RUST ==="
if command -v rustc &> /dev/null; then
    echo "✓ Rust is available"
    echo "Rust version: $(rustc --version)"
    echo "Cargo version: $(cargo --version)"
else
    echo "✗ Rust is not available"
fi

if command -v rustup &> /dev/null; then
    echo "✓ Rustup is available"
    echo "Active toolchain: $(rustup show active-toolchain)"
else
    echo "✗ Rustup is not available"
fi

# Ruby
echo ""
echo "=== RUBY ==="
if command -v ruby &> /dev/null; then
    echo "✓ Ruby is available"
    echo "Ruby version: $(ruby --version)"
else
    echo "✗ Ruby is not available"
fi

if command -v rbenv &> /dev/null; then
    echo "✓ rbenv is available"
    echo "rbenv version: $(rbenv --version)"
    echo "Current Ruby version: $(rbenv version)"
    echo ""
    echo "Available Ruby versions:"
    rbenv versions
else
    echo "✗ rbenv is not available"
fi

# Node.js (from previous test)
echo ""
echo "=== NODE.JS ==="
if command -v node &> /dev/null; then
    echo "✓ Node.js is available"
    echo "Node version: $(node --version)"
    echo "npm version: $(npm --version)"
else
    echo "✗ Node.js is not available"
fi

if command -v nvm &> /dev/null; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    echo "✓ NVM is available"
    echo "NVM version: $(nvm --version)"
else
    echo "✗ NVM is not available"
fi

echo ""
echo "=== SUMMARY ==="
echo "All tools tested. Check above for any missing tools."
