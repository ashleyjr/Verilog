import sys
import random
import threading
import numpy as np
import time
import math
from uart import uart


class uart_alu(uart):

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

    def load(self, a, b):
        width = 16
        if(a < 0):
            a = (2 ** width) + a
        if(b < 0):
            b = (2 ** width) + b
        for i in range(4, width+1, 4):
            c = a >> (width - i)
            c = c & 0xF
            c = c << 4
            c = c | 0x0
            self.tx(c)

            c = b >> (width - i)
            c = c & 0xF
            c = c << 4
            c = c | 0x1
            self.tx(c)

    def unload(self):
        ovf = self.ovf()
        width = 16
        b = []
        r = 0
        s = 0
        for i in range(0, width/4):
            self.tx(0x2)
            r |= self.rx() << s
            s += 8
        if r > 2 ** (width-1):
            r = r - (2 ** width)
        return ovf, r

    def ovf(self):
        self.tx(0x3)
        if 1 == self.rx():
            return True
        else:
            return False
    def add(self):
        self.tx(0x4)
    def sub(self):
        self.tx(0x5)
    def mul(self):
        self.tx(0x6)
    def div(self):
        self.tx(0x7)





def main():
    width = 16
    u = uart_alu(   baudrate        = 115200,
                    rx_buffer_size  = 2048 * 3)
    u.sync()

    for i in range(1000):
        a = random.randint(-4000, 4000)
        b = random.randint(-4000, 4000)
        u.load(a, b)
        reps = random.randint(0,3)
        for j in range(reps):
            op = random.randint(0, 3)
            if op == 0:
                u.add()
                ovf, o = u.unload()
                if o != (a + b):
                    print "Add error: " + str(a) + " + " + str(b) + " != " + str(o)
                else:
                    print str(a) + " + " + str(b) + " = " + str(o)
            elif op == 1:
                u.sub()
                ovf, o = u.unload()
                if o != (a - b):
                    print "Sub error: " + str(a) + " - " + str(b) + " != " + str(o)
                else:
                    print str(a) + " - " + str(b) + " = " + str(o)
            elif op == 2:
                u.mul()
                ovf, o = u.unload()
                e = a * b
                if  (e > (2 ** (width-1))) or (e < -(2 ** (width-1))):
                    print str(a) + " * " + str(b) + " = " + str(e)
                    if not ovf:
                        print "Mul ovf error"
                        print "Read " + str(o)
                        sys.exit(0)
                    else:
                        print "Mul ovf ok"
                elif o != (a * b):
                    print "Mul error: " + str(a) + " * " + str(b) + " != " + str(o)
                else:
                    print str(a) + " * " + str(b) + " = " + str(o)
            elif op == 3:
                u.div()
                ovf, o = u.unload()
                if b == 0:
                    if not ovf:
                        print "Div zero error"
                    else:
                        print "zero ok"
                else:
                    e = float(a) / float(b)
                    if e < 0:
                        e = math.ceil(e)
                    else:
                        e = math.floor(e)
                    if o != e:
                        print "Div error: " + str(a) + " / " + str(b) + " != " + str(o) + " exp = " + str(e)
                    else:
                        print str(a) + " / " + str(b) + " = " + str(o)


    u.finish()

if "__main__" == __name__:
    main()

