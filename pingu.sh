#!/bin/bash

# Function to send ping and handle the response
send_ping() {
    target=$1
    # Send a single ping (-c 1) and check if the ping is successful
    if ping -c 1 $target &> /dev/null; then
        echo "Ping to $target successful"
    else
        echo "Ping to $target failed"
    fi
}

# Main loop
while true; do
    # Send ping to multicast address
    send_ping "224.0.0.1"
    
    # Send ping to unicast address
    send_ping "10.30.1.1"
    
    # Wait for 10 seconds before sending the next ping
    sleep 10
done
