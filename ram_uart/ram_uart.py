import serial
import time
import sys
import random

DEBUG = False
random.seed(0)

ser = serial.Serial(
    port='/dev/ttyUSB1',
    baudrate=460800,
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

TOP = 0x7F
phase = 0
inc = True
rand = True
custom = True


if inc:
    ####################################################
    print "Phase "+str(phase)+", Incrementing addresses"
    ###################################################

    # Write addr as data  to ram
    for i in range(0,TOP+1):
        write(i)
        write((0x80 | i))

    # Flush input
    time.sleep(0.5)
    while not buffer_empty():
        read()

    # Read back
    for i in range(0, TOP+1):
        write(i)
        time.sleep(0.01)
        if i != read():
            print "Fail: Reading "+str(hex(i))
            sys.exit(0)
    print "Pass"
    phase = phase + 1

if rand:
    ####################################################
    print "Phase "+str(phase)+", Random addresses and data"
    ###################################################
    read_count = 0
    write_count = 0
    model = []
    for i in range(0, TOP+1):
        model.append(i)
    for i in range(0, 1000):
        addr = random.randint(0,TOP)
        write(addr)
        if model[addr] != read():
            print "Fail: Reading "+str(hex(addr))+", expected "+str(hex(model[addr]))
        if random.choice([True,False]):
            # Write
            data = random.randint(0, TOP)
            if DEBUG:
                print "Mem      "+str(hex(addr))+" < "+str(hex(data))
            write((0x80 | data))
            model[addr] = data
    print "Pass"
    phase = phase + 1

if custom:
    ####################################################
    print "Phase "+str(phase)+", Custom"
    ###################################################
    write(0x7b)
    read()
    write(0x80)
    write(0x7b)
    read()
    write(0xee)
    write(0x7b)
    read()
    write(0x7b)
    read()
    write(0x80)
    write(0x7b)
    read()
    write(0x7b)
    read()
    write(0xee)
    write(0x7b)
    read()
    phase = phase + 1
