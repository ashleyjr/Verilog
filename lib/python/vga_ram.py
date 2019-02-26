import sys
import random
import threading
import numpy as np
import time
from uart import uart
from matplotlib import pyplot as plt

def main():
    u = uart(   baudrate        = 115200,
                rx_buffer_size  = 1024)

    for i in range(0, 10):
        u.tx(0xAA)

    MEM_SIZE=2048*16
    IM_SIZE_W=180
    IM_SIZE_H=180
    IM_SIZE=IM_SIZE_W*IM_SIZE_H

    print "MEM_SIZE     ="+str(MEM_SIZE)
    print "IM_SIZE_W    ="+str(IM_SIZE_W)
    print "IM_SIZE_H    ="+str(IM_SIZE_H)
    print "IM_SIZE      ="+str(IM_SIZE)

    def update(im):
        u.tx(0x00)
        for i in range(0, 180):
            for j in range(0, 180, 3):
                c = im[i, j+2] * 16
                b = im[i, j+1] * 4
                a = im[i, j]
                k = 0x80 | c | b | a
                u.tx(k)

    im = np.zeros((180,180),dtype=int)

    for a in range(0, 180):
        for b in range(0, 180):
            im[a,b] = a % 3

    update(im)
    plt.imshow(im, interpolation='nearest')
    plt.show()

    u.finish()

if "__main__" == __name__:
    main()

