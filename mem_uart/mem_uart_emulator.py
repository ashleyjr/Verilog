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

MID_TRANSMISSION        = 0
START_OF_DATA_MASK      = 1
START_OF_ADDRESS_MASK   = 2
END_AND_WRITE_MASK      = 4
END_AND_READ_MASK       = 8

state = ""
count = 0
i = 0
while(count < 500):
    while ser.inWaiting():
        count = count + 1
        rx = ord(ser.read(1))
        cmd = rx & 0x0F
        rx = rx >> 4
        if(cmd == START_OF_DATA_MASK):
            state = "data"
            data = rx
            i = 0
        elif(cmd == START_OF_ADDRESS_MASK):
            state = "addr"
            addr = rx
            i = 0
        else:
            i = i + 1
            if(state == "data"):
                data |= rx << (4*i)
                if(cmd == END_AND_WRITE_MASK):
                    print "A="+str(addr)+",D="+str(data)
                elif(cmd == END_AND_READ_MASK):
                    print "Read data "+str(data)
            elif(state == "addr"):
                addr |= rx << (4*i)
                if(cmd == END_AND_WRITE_MASK):
                    pass
                    #print "Write addr "+str(addr)
                elif(cmd == END_AND_READ_MASK):
                    print "Read addr "+str(addr)

