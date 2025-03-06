#!/bin/bash

# Define network interface (change as needed)
INTERFACE="eth0"

# Multicast IPs used in SCADA protocols
CIP_MULTICAST="224.0.0.1"       # EtherNet/IP
PROFINET_MULTICAST="224.0.0.2"  # PROFINET
MODBUS_BROADCAST="255.255.255.255"
DNP3_MULTICAST="224.0.0.3"
GOOSE_MULTICAST="01:0C:CD:01:00:01"  # IEC 61850 GOOSE (Layer 2)
SNMP_MULTICAST="224.0.1.1"
NTP_MULTICAST="224.0.1.129"
SYSLOG_BROADCAST="255.255.255.255"

# Function to send UDP multicast packets
send_multicast() {
    IP=$1
    PORT=$2
    PAYLOAD=$3

    echo "[+] Sending SCADA multicast traffic to $IP:$PORT"
    echo -n "$PAYLOAD" | nc -u -b -w1 $IP $PORT
}

# Function to send Layer 2 GOOSE messages (requires macchanger & hping3)
send_goose() {
    echo "[+] Sending fake IEC 61850 GOOSE message"
    hping3 --udp --destport 102 -c 1 --interface $INTERFACE -2 --spoof 192.168.1.100 --rand-source
}

# Infinite loop to send traffic at intervals
while true; do
    send_multicast "$CIP_MULTICAST" 2222 "Fake EtherNet/IP Data"
    send_multicast "$PROFINET_MULTICAST" 34964 "Fake PROFINET Data"
    send_multicast "$MODBUS_BROADCAST" 502 "Fake Modbus Data"
    send_multicast "$DNP3_MULTICAST" 20000 "Fake DNP3 Data"
    send_goose
    send_multicast "$SNMP_MULTICAST" 161 "Fake SNMP Trap"
    send_multicast "$NTP_MULTICAST" 123 "Fake NTP Sync"
    send_multicast "$SYSLOG_BROADCAST" 514 "<34>Mar 06 12:34:56 SCADA-HMI: Fake Syslog Event"

    sleep 5  # Adjust frequency
done
