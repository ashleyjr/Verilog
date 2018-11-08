import serial
import threading
import subprocess

class uart:
    def __init__(self, baudrate, rx_buffer_size):

        ''' Use dmesg find the last FTDI plugged in '''
        p = subprocess.Popen(['dmesg'], stdout=subprocess.PIPE)
        lines = p.communicate()
        for line in lines[0].split("\n"):
            if line is not None:
                if  ("FTDI" in line) and\
                    ("attached" in line) and\
                    ("ttyUSB" in line):
                    port = line.split(" ")[-1].strip('\n')
        print "Connecting to "+port
        self.ser = serial.Serial(
            port='/dev/'+port,
            baudrate=baudrate,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            bytesize=serial.EIGHTBITS
        )
        self.rx_buffer_size = rx_buffer_size
        self.rx_buf = [0] * self.rx_buffer_size
        self.rx_buf_head = 0
        self.rx_buf_tail = 0
        self.stop = False
        threading.Thread(target=self.rx_buffer).start()

    def rx_buffer(self):
        while not self.stop:
            while(self.ser.inWaiting() != 0):
                self.rx_buf[self.rx_buf_head] = ord(self.ser.read(1))
                self.rx_buf_head += 1
                self.rx_buf_head %= self.rx_buffer_size

    def tx(self, d):
        self.ser.write(chr(d))
        return

    def rx(self):
        while(self.rx_buf_tail == self.rx_buf_head):
            pass
        d = self.rx_buf[self.rx_buf_tail]
        self.rx_buf_tail += 1
        self.rx_buf_tail %= self.rx_buffer_size
        return d

    def finish(self):
        self.stop = True
        return


