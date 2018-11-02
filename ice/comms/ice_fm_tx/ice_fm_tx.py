import serial
import time
import sys
import random
import threading
import time
import numpy as np

class ice_ram_uart_test:
    BAUDRATE= 38400
    RX_BUFFER_SIZE = 2048*3

    def __init__(self):
        self.ser = serial.Serial(
            port='/dev/ttyUSB7',
            baudrate=self.BAUDRATE,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            bytesize=serial.EIGHTBITS
        )


        self.rx_buf = [0] * self.RX_BUFFER_SIZE
        self.rx_buf_head = 0
        self.rx_buf_tail = 0

        self.stop = False
        threading.Thread(target=self.rx_buffer).start()


    def rx_buffer(self):
        while not self.stop:
            while(self.ser.inWaiting() != 0):
                self.rx_buf[self.rx_buf_head] = ord(self.ser.read(1))
                self.rx_buf_head += 1
                self.rx_buf_head %= self.RX_BUFFER_SIZE

    def tx(self, d):
        self.ser.write(chr(d))
        return

    def rx(self):
        while(self.rx_buf_tail == self.rx_buf_head):
            pass
        d = self.rx_buf[self.rx_buf_tail]
        self.rx_buf_tail += 1
        self.rx_buf_tail %= self.RX_BUFFER_SIZE
        return d

    def finish(self):
        self.stop = True
        return

uart = ice_ram_uart_test()


def sync():
    print "Syncing..."
    for i in range(10):
        uart.tx(0xAA)
        time.sleep(0.1)
    print "...done"

def sample(rate):
    print "Set sample..."
    uart.tx(((0xF & rate) << 4)| 3)
    uart.tx((0xF0 & rate)| 2)
    print "...done"

def write_sine(length=2047):
    print "Writing sine..."
    s = []
    for i in range(length):
        t = (i*2*3.1415)/length
        f = 1 + np.sin(t)
        s .append(int(np.floor((2 ** 16)*(f/2))))
    for i in range(length):
        print hex(s[i])
        if s[i] == 0:
            uart.tx(((1 << 4) | 1))
            uart.tx(((0 << 4) | 1))
            uart.tx(((0 << 4) | 1))
            uart.tx(((0 << 4) | 1))
        else:
            uart.tx((((s[i] & 0xF) << 4) | 1))
            uart.tx(((((s[i] >> 4) & 0xF) << 4) | 1))
            uart.tx(((((s[i] >> 8) & 0xF) << 4) | 1))
            uart.tx(((((s[i] >> 12) & 0xF) << 4) | 1))
    uart.tx(1)
    uart.tx(1)
    uart.tx(1)
    uart.tx(1)
    print "...done"

def read(length=2048):
    print "Requested memory dump..."
    uart.tx(0x0F)
    for addr in range(length):
        b = uart.rx()
        t = uart.rx()
        data = hex((t << 8) | b)
        print data
    print "...done"


sync()
sample(0xFF)
write_sine(17)
read(19)
read(19)
uart.finish()


