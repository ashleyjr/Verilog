import serial
import time
import sys
import random

DEBUG = False
random.seed(0)
baudrate = 1000
run = 0
while True:

    baudrate = random.randint(baudrate, baudrate*2)
    if baudrate > 800000:
        break

    ser = serial.Serial(
        port='/dev/ttyUSB1',
        baudrate=baudrate,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        bytesize=serial.EIGHTBITS
    )

    def write(d):
        ser.write(chr(d))
        if DEBUG:
            print "Write: "+str(hex(d))

    def read():
        while(ser.inWaiting() == 0):
            pass
        d = ord(ser.read(1))
        if DEBUG:
            print " Read: "+str(hex(d))
        return d

    def buffer_empty():
        if ser.inWaiting() > 0:
            return False
        else:
            return True

    print "Run: "+str(run)
    print "\tBaudrate: "+str(baudrate)


    print "\tSyncing..."
    data = 0
    sync = 0
    while data != 0xAA:
        time.sleep(0.1)
        write(0xAA)
        data = read()
        sync = sync + 1
        if sync > 10:
            print "\tUnable to sync"
            print "\tFail"
            sys.exit(0)
    print "\tSync complete"

    for i in range(0, 100):
        data = random.randint(0x00, 0xFF)
        if DEBUG:
            print "\tWrite: "+str(hex(data))
        write(data)
        loop = read()
        if DEBUG:
            print "\tRead: "+str(hex(loop))
        if data != loop:
            print "\tFail"
            sys.exit(0)

    print "\tPass"
    run = run + 1
print "Passed all"
