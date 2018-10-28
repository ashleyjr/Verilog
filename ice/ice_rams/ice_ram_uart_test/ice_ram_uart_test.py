import serial
import time
import sys
import random
import threading
import time

class ice_ram_uart_test:
    BAUDRATE= 38400
    RX_BUFFER_SIZE = 2048*3

    def __init__(self):
        self.ser = serial.Serial(
            port='/dev/ttyUSB2',
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

MEM_SIZE = 2048

mem = [0] * MEM_SIZE

def sync():
    print "Syncing..."
    for i in range(10):
        uart.tx(0xAA)
        time.sleep(0.1)
    print "...done"

def write(stop=MEM_SIZE):
    print "Writing to all addresses..."
    for i in range(stop):
        a = random.randint(0x0, 0xF)
        uart.tx(((a << 4) | 1))
        b = random.randint(0x0, 0xF)
        uart.tx(((b << 4) | 1))
        c = random.randint(0x0, 0xF)
        uart.tx(((c << 4) | 1))
        d = random.randint(0x0, 0xF)
        uart.tx(((d << 4) | 1))

        mem[i] =  (d << 12)|(c << 8)|(b << 4)|a
    print "...done"

def read():
    print "Requested memory dump..."
    uart.tx(0x0F)
    for addr in range(2048):
        b = uart.rx()
        t = uart.rx()
        data = (t << 8) | b
        if data != mem[addr]:
            print str(hex(addr))+": Got "+str(hex(data)) +", Expected "+str(hex(mem[addr]))
    print "..done"


sync()
write()
read()
write()
write()
read()
write()
read()
read()
write(stop=0xF)
read()
uart.finish()


