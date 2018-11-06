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
            port='/dev/ttyUSB13',
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

def fm_tx_set():
    uart.tx(0xD)

def sample(rate):
    print "Set sample..."
    a = (0xF000 & rate) >> 12
    b = (0xF00 & rate) >> 8
    c = (0xF0 & rate) >> 4
    d = (0xF & rate)
    uart.tx((a << 4) | 0xC)
    uart.tx((b << 4) | 0xB)
    uart.tx((c << 4) | 0xA)
    uart.tx((d << 4) | 0x9)
    print "...done"

def write_sine(length=2047):
    print "Writing sine..."
    s = []
    for i in range(length):
        t = (i*2*3.1415)/length
        o = np.sin(t)
        f = o + 1
        s = int(np.floor(((2 ** 15)-1)*(f/2)))
        print '{:03x}'.format(i) + " = " +'{:016b}'.format(s),
        print " (%.4f = sin(%.4f))" % (o, t),
        print " (int = " + str(s) + ")"
        if(i == length-1):
            s |= 0x8000
        write_mem(i, s)
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

def uart_cmd_data(cmd, data):
    uart.tx((data << 4) | cmd)

def write_mem(addr, data):
    # Write data
    uart_cmd_data(0, (data & 0xF))
    uart_cmd_data(1, ((data >> 4) & 0xF))
    uart_cmd_data(2, ((data >> 8) & 0xF))
    uart_cmd_data(3, ((data >> 12) & 0xF))
    # Write address
    uart_cmd_data(4, (addr & 0xF))
    uart_cmd_data(5, ((addr >> 4) & 0xF))
    uart_cmd_data(6, ((addr >> 8) & 0x7))
    # Do a write
    uart_cmd_data(8, 0)

def read_mem(addr):
    # Write address
    uart_cmd_data(4, (addr & 0xF))
    uart_cmd_data(5, ((addr >> 4) & 0xF))
    uart_cmd_data(6, ((addr >> 8) & 0x7))
    # Do a read
    uart_cmd_data(7, 0)
    #
    uart_cmd_data(0xE,0)
    d = uart.rx()
    uart_cmd_data(0xF,0)
    d = d | (uart.rx() << 8)
    return d




sync()

write_sine(675)
#print "Readback..."
#for i in range(675):
#    print read_mem(i)
#print "...done"

samples = [ 440,
            494,
            523,
            587,
            659,
            698,
            784,
            880]

while(1):
    for s in samples:
        sample(100000/s)
        time.sleep(0.5)


uart.finish()


