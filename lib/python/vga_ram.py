import sys
import random
import threading
import numpy as np
import time
from uart import uart

def main():
    u = uart(   baudrate        = 115200,
                rx_buffer_size  = 1024)

    for i in range(0, 10):
        u.tx(0xAA)

    u.tx(0x00)
    for i in range(0, 100):
        u.tx(0x80)
        print hex(u.rx())
    for i in range(0, 100):
        u.tx(0x95)
        print hex(u.rx())
    for i in range(0, 100):
        u.tx(0xAA)
        print hex(u.rx())
    for i in range(0, 100):
        u.tx(0xFF)
        print hex(u.rx())




    u.finish()

if "__main__" == __name__:
    main()

