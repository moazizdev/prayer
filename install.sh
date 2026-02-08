#!/bin/bash
#
# Prayer Times CLI - Install Script
#

set -e

INSTALL_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/prayer-times"

echo "Prayer Times CLI - Installer"
echo "============================"
echo ""

# Check dependencies
echo "Checking dependencies..."

if ! command -v jq &> /dev/null; then
    echo "❌ jq is not installed."
    echo "   Install with: sudo apt install jq"
    exit 1
else
    echo "✓ jq found"
fi

if ! command -v curl &> /dev/null; then
    echo "❌ curl is not installed."
    echo "   Install with: sudo apt install curl"
    exit 1
else
    echo "✓ curl found"
fi

echo ""

# Create install directory
mkdir -p "$INSTALL_DIR"

# Copy binary
echo "Installing prayer to $INSTALL_DIR..."
cp bin/prayer "$INSTALL_DIR/prayer"
chmod +x "$INSTALL_DIR/prayer"
echo "✓ Installed"

# Check if in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "⚠ $INSTALL_DIR is not in your PATH."
    echo ""
    echo "Add this to your ~/.bashrc or ~/.zshrc:"
    echo ""
    echo '  export PATH="$HOME/.local/bin:$PATH"'
    echo ""
    echo "Then run: source ~/.bashrc"
fi

# Create default config
echo ""
echo "Setting up configuration..."
mkdir -p "$CONFIG_DIR"

if [[ ! -f "$CONFIG_DIR/config.json" ]]; then
    cat > "$CONFIG_DIR/config.json" << 'EOF'
{
    "city": "Cairo",
    "country": "Egypt",
    "method": 5,
    "fetch_every_minutes": 360
}
EOF
    echo "✓ Created default config at $CONFIG_DIR/config.json"
    echo ""
    echo "⚠ Please edit the config with your city:"
    echo "  nano $CONFIG_DIR/config.json"
else
    echo "✓ Config already exists"
fi

echo ""
echo "============================"
echo "Installation complete!"
echo ""
echo "Try it out:"
echo "  prayer --help"
echo "  prayer --all"
echo "  prayer"
echo ""
