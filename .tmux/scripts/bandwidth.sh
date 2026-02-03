#!/bin/bash
# Network bandwidth monitor for tmux status bar
# Shows upload/download rates for the primary network interface

# Cache file for storing previous readings
CACHE_FILE="/tmp/tmux_bandwidth_cache_$$"
CACHE_LOCK="/tmp/tmux_bandwidth_lock"

# Find primary network interface
get_interface() {
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS: get the primary interface from routing table
        route -n get default 2>/dev/null | grep 'interface:' | awk '{print $2}'
    else
        # Linux: get the default route interface
        ip route | grep default | awk '{print $5}' | head -1
    fi
}

# Get current bytes for interface
get_bytes() {
    local interface="$1"
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS: use netstat
        netstat -ibn | grep -w "$interface" | head -1 | awk '{print $7, $10}'
    else
        # Linux: read from /sys/class/net
        local rx_bytes=$(cat /sys/class/net/"$interface"/statistics/rx_bytes 2>/dev/null || echo 0)
        local tx_bytes=$(cat /sys/class/net/"$interface"/statistics/tx_bytes 2>/dev/null || echo 0)
        echo "$rx_bytes $tx_bytes"
    fi
}

# Format bytes to human readable
format_bytes() {
    local bytes="$1"
    if [[ $bytes -ge 1073741824 ]]; then
        printf "%.1fG" $(echo "scale=1; $bytes/1073741824" | bc)
    elif [[ $bytes -ge 1048576 ]]; then
        printf "%.1fM" $(echo "scale=1; $bytes/1048576" | bc)
    elif [[ $bytes -ge 1024 ]]; then
        printf "%.1fK" $(echo "scale=1; $bytes/1024" | bc)
    else
        printf "%dB" "$bytes"
    fi
}

main() {
    local interface=$(get_interface)

    if [[ -z "$interface" ]]; then
        echo ""
        exit 0
    fi

    local current_time=$(date +%s)
    read -r rx_bytes tx_bytes <<< "$(get_bytes "$interface")"

    # Read previous values from cache
    if [[ -f "$CACHE_FILE" ]]; then
        read -r prev_time prev_rx prev_tx < "$CACHE_FILE"

        local time_diff=$((current_time - prev_time))
        if [[ $time_diff -gt 0 && $time_diff -lt 10 ]]; then
            local rx_rate=$(( (rx_bytes - prev_rx) / time_diff ))
            local tx_rate=$(( (tx_bytes - prev_tx) / time_diff ))

            # Only show non-negative rates
            if [[ $rx_rate -ge 0 && $tx_rate -ge 0 ]]; then
                local rx_formatted=$(format_bytes $rx_rate)
                local tx_formatted=$(format_bytes $tx_rate)
                echo "D:${rx_formatted}/s U:${tx_formatted}/s"
            fi
        fi
    fi

    # Save current values for next run
    echo "$current_time $rx_bytes $tx_bytes" > "$CACHE_FILE"
}

main
