#!/bin/bash
#
# Prayer Times CLI - Uninstall Script
#

INSTALL_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/prayer-times"
CACHE_DIR="${HOME}/.cache/prayer-times"

echo "Prayer Times CLI - Uninstaller"
echo "=============================="
echo ""

# Remove binary
if [[ -f "$INSTALL_DIR/prayer" ]]; then
    rm "$INSTALL_DIR/prayer"
    echo "✓ Removed $INSTALL_DIR/prayer"
else
    echo "- Binary not found"
fi

# Ask about config
if [[ -d "$CONFIG_DIR" ]]; then
    read -p "Remove config directory ($CONFIG_DIR)? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$CONFIG_DIR"
        echo "✓ Removed $CONFIG_DIR"
    else
        echo "- Kept config"
    fi
fi

# Ask about cache
if [[ -d "$CACHE_DIR" ]]; then
    read -p "Remove cache directory ($CACHE_DIR)? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$CACHE_DIR"
        echo "✓ Removed $CACHE_DIR"
    else
        echo "- Kept cache"
    fi
fi

echo ""
echo "Uninstall complete!"
