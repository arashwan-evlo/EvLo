#https://raw.githubusercontent.com/arashwan-evlo/EvLo/main/pingu.py
#nohup python3 ping_script.py &
#pip install ping3


import time
from ping3 import ping

def send_ping(target):
    response = ping(target)
    if response is not None:
        print(f"Ping to {target} successful, response time: {response} ms")
    else:
        print(f"Ping to {target} failed")

def main():
    while True:
        # Send ping to multicast address
        send_ping('224.0.0.1')

        # Send ping to unicast address
        send_ping('10.30.1.1')

        # Wait for 10 seconds before sending next ping
        time.sleep(10)

if __name__ == "__main__":
    main()
