#!/bin/bash

# Define network interface (Update as needed)
INTERFACE="eth0"

# Define Multicast IPs for SCADA protocols
CIP_MULTICAST="224.0.0.1"       # EtherNet/IP (Rockwell)
PROFINET_MULTICAST="224.0.0.2"  # PROFINET (Siemens)
MODBUS_MULTICAST="224.0.0.3"    # MODBUS/TCP Simulation

# Function to send UDP multicast packets with correctly formatted data
send_multicast() {
    IP=$1
    PORT=$2
    PAYLOAD=$3

    echo "[+] Sending SCADA multicast traffic to $IP:$PORT - $(date)"
    echo -ne "$PAYLOAD" | nc -u -w1 $IP $PORT
}

# EtherNet/IP (ENIP) Register Session Message (Valid Format)
ENIP_REGISTER_SESSION="\x65\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00"

# PROFINET DCP Hello Message (Basic Discovery Packet)
PROFINET_DCP_HELLO="\xfe\xfd\x05\x00\x00\x00\x00\x01\x00\x0e\x00\x08\x00\x04\x00\x01\x02\x03\x04"

# MODBUS/TCP Read Holding Registers Request
MODBUS_READ_HOLDING_REGISTERS="\x00\x01\x00\x00\x00\x06\x01\x03\x00\x64\x00\x0A"

# Infinite loop to send traffic every 5 seconds
while true; do
    send_multicast "$CIP_MULTICAST" 2222 "$ENIP_REGISTER_SESSION"
    send_multicast "$PROFINET_MULTICAST" 34964 "$PROFINET_DCP_HELLO"
    send_multicast "$MODBUS_MULTICAST" 502 "$MODBUS_READ_HOLDING_REGISTERS"
    
    sleep 5  # Adjust frequency as needed
done
