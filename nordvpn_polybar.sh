#!/bin/bash

# Display Status Function
display_status() {
    # Call nordvpn status and settings once and store the output
    local status_output=$(nordvpn status)
    local settings_output=$(nordvpn settings)

    # Parse the stored output
    local status=$(awk '/Status/ {print $4}' <<< "$status_output")
    local location=$(awk '/City/ {print $2}' <<< "$status_output")
    local transfer=$(awk '/Transfer/ {print $2, $3, "|", $5, $6}' <<< "$status_output")
    local killswitch=$(awk '/Kill Switch/ {print $3}' <<< "$settings_output")

    # Conditional display 

    if [ "$status" = "Connected" ]; then
        echo "Location: $location, Transfer: $transfer, Killswitch: $killswitch"
    elif [ "$killswitch" = "enabled" ]; then
        echo "Status: $status, Location: $location, Transfer: $transfer, Killswitch: $killswitch"
    else
        echo "VPN Disconnected"
    fi
}

# Toggle Kill switch Function
toggle_killswitch() {
    local killswitch_status=$(nordvpn settings | awk '/Kill Switch/ {print $3}')
    if [ "$killswitch_status" = "enabled" ]; then
        nordvpn set killswitch disable
    else
        nordvpn set killswitch enable
    fi
}

# Main Function
case "$1" in
    toggle)
        toggle_killswitch
        ;;
    *)
        display_status
        ;;
esac
