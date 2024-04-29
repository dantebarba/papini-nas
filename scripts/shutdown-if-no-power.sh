#!/bin/sh
set -e
# Check if the network interface and shutdown threshold are provided as arguments
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <network_interface> <shutdown_threshold> <shutdown_trigger_file>"
    echo "Example: $0 enp0s25 3 /tmp/shutdown-trigger.txt"
    exit 1
fi

# Get the default gateway IP from the provided network interface
gateway_ip=$(ip route show | grep default | grep -oP 'via \K\S+' | head -n 1)

if [ -z "$gateway_ip" ]; then
    echo "Error: Unable to retrieve the default gateway IP."
    exit 1
fi

# Define constants
MAX_PING_FAILURE=10

# Define variables
network_interface="$1"
counter_file="$3"
shutdown_threshold="$2"

# Function to reset the counter to 0
reset_counter() {
    echo "0" > "$counter_file"
}

# Function to increment the counter
increment_counter() {
    current_count=$(cat "$counter_file")
    new_count=$((current_count + 1))
    echo "$new_count" > "$counter_file"
}

# Function to perform ping checks
perform_ping_checks() {
    failed_count=0

    # Perform 10 ping checks
    for i in $(seq "$MAX_PING_FAILURE"); do
        if ! ping -c 1 -W 1 "$gateway_ip" -I "$network_interface" > /dev/null 2>&1; then
            # Ping failed
            failed_count=$((failed_count + 1))
        fi
    done

    # If all pings failed, increment the counter and perform necessary actions
    if [ "$failed_count" -eq "$MAX_PING_FAILURE" ]; then
        increment_counter
        echo "All pings failed. Taking action..."
        # Add your custom actions here
    else
        # Not all pings failed, reset the counter to 0
        reset_counter
        echo "Not all pings failed. Resetting counter."
    fi
}

# Main script
if [ ! -e "$counter_file" ]; then
    # Counter file doesn't exist, create it with initial value 0
    echo "0" > "$counter_file"
fi

# Check if the counter has reached the shutdown threshold
current_count=$(cat "$counter_file")
if [ "$current_count" -eq "$shutdown_threshold" ]; then
    echo "Shutdown threshold reached. Resetting counter and shutting down..."
    reset_counter
    echo "Shutdown performed"
    shutdown -h +1
else
    # Perform ping checks
    perform_ping_checks
fi
