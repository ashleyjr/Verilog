import serial
import time
import sys
import random

ser = serial.Serial(
    port='/dev/ttyUSB1',
    baudrate=460800,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)

def write(data, p=False):
    ser.write(chr(data))
    if p:
        print "Write: "+str(hex(data))

def read(p=False):
    while(ser.inWaiting() == 0):
        pass
    data = ord(ser.read(1))
    if p:
        print " Read: "+str(hex(data))
    return data

def buffer_empty():
    if ser.inWaiting() > 0:
        return False
    else:
        return True

TOP = 0x7F


####################################################
print "Phase 0, Incrementing addresses"
###################################################

# Write addr as data  to ram
for i in range(0,TOP+1):
    write(i)
    write((0x80 | i))

# Flush input
time.sleep(0.1)
while not buffer_empty():
    read()

# Read back
for i in range(0, TOP+1):
    write(i)
    if i != read():
        print "Fail: Reading "+str(hex(i))
        sys.exit(0)
print "Pass"


####################################################
print "Phase 1, Random addresses and data"
###################################################
read_count = 0
write_count = 0
model = []
for i in range(0, TOP+1):
    model.append(i)
for i in range(0, 100):
    addr = random.randint(0,TOP)
    write(addr, p=True)
    if random.choice([True,False]):
        # Read
        if model[addr] != read(p=True):
            print "Fail: Reading "+str(hex(addr))
    else:
        # Write
        read()
        data = random.randint(0, 0xFF)
        write((0x80 | data), p=True)
        model[addr] = data





