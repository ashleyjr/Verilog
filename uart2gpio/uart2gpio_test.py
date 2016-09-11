import time
import serial

# configure the serial connections (the parameters differs on the device you are connecting to)
ser = serial.Serial(
    port='/dev/ttyUSB1',
    baudrate=9600,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS
)

ser.isOpen()

def send(con,data):
    con.write(chr(data))
    time.sleep(0.1)
    while ser.inWaiting() > 0:
        ch = ser.read(1)
    hv = ord(ch)
    print "Sent: " + str(data) + ", Got: " + str(hv)

while 1 :
    send(ser,255)
    send(ser,255)
    send(ser,255)
    send(ser,255)
    send(ser,255)
    send(ser,1)
    send(ser,0)
    send(ser,10)
    send(ser,1)
    send(ser,255)
    send(ser,255)
    send(ser,255)
    send(ser,255)
    send(ser,255)
    send(ser,1)
    send(ser,0)
    send(ser,10)
    send(ser,0)
