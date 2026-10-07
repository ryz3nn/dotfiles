#!/usr/bin/env sh

# Emit current workspace immediately
update_ws() {
    idx=$(niri msg -j workspaces 2>/dev/null | jq -r '.[] | select(.is_focused == true) | .idx')
    total=$(niri msg -j workspaces 2>/dev/null | jq -r 'length')
    if [ -n "$idx" ]; then
        echo "ws|string|[WS: ${idx}/${total}]"
        echo "" # Flush tag block to yambar
    fi
}

update_ws

# Listen to Niri events continuously
niri msg -j event-stream 2>/dev/null | while read -r line; do
    case "$line" in
        *"WorkspaceActivated"*|*"WorkspacesChanged"*)
            update_ws
            ;;
    esac
done
