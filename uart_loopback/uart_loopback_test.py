import time
import serial
from random import randint

ser = serial.Serial(
    port='/dev/ttyUSB1',
    baudrate=9600,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)

ser.isOpen()
ser.reset_input_buffer()

expected = []
count = 0

print "Tx       Rx"
while(1):
    tx = randint(0,255)
    print str(count)
    count = count + 1
    ser.write(chr(tx))
    #print '{:08b}'.format(tx)
    expected.append(tx)
    while ser.inWaiting():
        rx = ord(ser.read(1))
        #print '                     {:08b}'.format(rx)
        if expected[0] != rx:
            print "ERROR"
        else:
            expected = expected[1:]

    #if(rx != tx):
    #    print " error"
    #else:
            #    print ""
