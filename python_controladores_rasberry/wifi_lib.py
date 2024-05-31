import rp2
import network
import ubinascii
from secrets import secrets
import time


def wifi_init(retries=3):
    rp2.country('DE')
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    mac = ubinascii.hexlify(wlan.config('mac'), ':').decode()
    print('MAC Address:', mac)
    print('Channel:', str(wlan.config('channel')))
    print('SSID:', wlan.config('ssid'))
    print('RSSI:', str(wlan.config('txpower')))

    ssid = secrets['ssid']
    password = secrets['password']

    for attempt in range(retries):
        print(f'Attempting to connect, Attempt {attempt+1}/{retries}')
        wlan.connect(ssid, password)
        for i in range(10):  # Wait for connection with 10 seconds timeout
            if wlan.status() == network.STAT_GOT_IP:
                print('Connected. IP Address:', wlan.ifconfig()[0])
                return
            time.sleep(1)
        print('Connection attempt failed.')

    raise RuntimeError('Wi-Fi connection failed after maximum retries.')
