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
    while True:
        if(ser.inWaiting()):
            break
    ch = ser.read(1)
    hv = ord(ch)
    #print "Sent: " + str(data) + ", Got: " + str(hv)

def reset(con):
    send(con,88)
    send(con,88)
    send(con,88)

def period(con,addr,period):
    send(con,160)   # 0xAA
    send(con,addr)
    send(con,period)

def duty(con,addr,duty):
    send(con,187)   # 0xBB
    send(con,addr)
    send(con,duty)


leds = [5,10,15,20,25]

while 1 :
    reset(ser)

    for i in range(0,5):
        if(leds[i] > 30):
            show = 60 - leds[i]
        else:
            show = leds[i]
        print i,show,
        duty(ser,i,show)
        leds[i] += 2
        if(leds[i] > 55):
            leds[i] = 5
    print
