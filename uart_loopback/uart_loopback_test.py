import time
import serial

ser = serial.Serial(
    port='/dev/ttyUSB1',
    baudrate=115200,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)

ser.isOpen()
ser.reset_input_buffer()

print "Tx       Rx"
for tx in range(0,256):
    ser.write(chr(tx))
    while not ser.inWaiting():
        pass
    rx = ord(ser.read(1))
    print '{:08b}'.format(tx),'{:08b}'.format(rx),
    if(rx != tx):
        print " error"
    else:
        print ""
