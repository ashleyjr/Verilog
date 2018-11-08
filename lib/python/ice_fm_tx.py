import sys
import random
import threading
import numpy as np
import time
from uart import uart


class uart_fm_tx(uart):

    def sync(self):
        print "Syncing..."
        for i in range(10):
            self.tx(0xAA)
            time.sleep(0.1)
        print "...done"


    def fm_set_tx(self):
        self.tx(0xD)

    def sample(self, rate):
        print "Set sample..."
        a = (0xF000 & rate) >> 12
        b = (0xF00 & rate) >> 8
        c = (0xF0 & rate) >> 4
        d = (0xF & rate)
        self.tx((a << 4) | 0xC)
        self.tx((b << 4) | 0xB)
        self.tx((c << 4) | 0xA)
        self.tx((d << 4) | 0x9)
        print "...done"

    def uart_cmd_data(self, cmd, data):
        self.tx((data << 4) | cmd)

    def read(self, length=2048):
        print "Requested memory dump..."
        self.tx(0x0F)
        for addr in range(length):
            b = self.rx()
            t = self.rx()
            data = hex((t << 8) | b)
            print data
        print "...done"

    def read_mem(self, addr):
        # Write address
        self.uart_cmd_data(4, (addr & 0xF))
        self.uart_cmd_data(5, ((addr >> 4) & 0xF))
        self.uart_cmd_data(6, ((addr >> 8) & 0x7))
        # Do a read
        self.uart_cmd_data(7, 0)
        #
        self.uart_cmd_data(0xE,0)
        d = self.rx()
        self.uart_cmd_data(0xF,0)
        d = d | (self.rx() << 8)
        return d

    def write_mem(self, addr, data):
        # Write data
        self.uart_cmd_data(0, (data & 0xF))
        self.uart_cmd_data(1, ((data >> 4) & 0xF))
        self.uart_cmd_data(2, ((data >> 8) & 0xF))
        self.uart_cmd_data(3, ((data >> 12) & 0xF))
        # Write address
        self.uart_cmd_data(4, (addr & 0xF))
        self.uart_cmd_data(5, ((addr >> 4) & 0xF))
        self.uart_cmd_data(6, ((addr >> 8) & 0x7))
        # Do a write
        self.uart_cmd_data(8, 0)

    def write_sine(self, length=2047):
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
            self.write_mem(i, s)
        print "...done"

def main():
    u = uart_fm_tx( baudrate        = 38400,
                    rx_buffer_size  = 2048 * 3)
    u.sync()
    u.write_sine(675)

    print "Readback..."
    for i in range(675):
        print u.read_mem(i)
    print "...done"

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
            u.sample(100000/s)
            time.sleep(0.5)


    u.finish()

if "__main__" == __name__:
    main()

