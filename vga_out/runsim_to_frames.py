#!/usr/bin/python
from PIL import Image
import random

PCLK_MHZ = 1000
PCLK_PERIOD_NS = int(1e9/(PCLK_MHZ*1e6))

def main():

    ''' Load data, remove first and last 100 lines '''
    runsim = open("vga_out_runsim.txt","r").read()
    runsim = runsim.split("\n")
    runsim = runsim[100:-100]
    sim_len_ns = len(runsim)
    print PCLK_PERIOD_NS

    ''' Data as seen by clock processed to image '''
    state = "FIRST"
    frames = []
    width = 0
    v_sync_width = 0
    h_sync_width = 0
    for i in range(0, sim_len_ns, PCLK_PERIOD_NS):
        data = runsim[i].split(",")
        V = int(data[0])
        H = int(data[1])
        R = int(data[2])
        G = int(data[3])
        B = int(data[4])

        if state == "FIRST":
            state = "IDLE"
        elif state == "IDLE":
            v_sync_width += 1
            if (1 == V) and (0 == VL):
                print v_sync_width
                v_sync_width = 0
                frames.append([])
                state = "IN"
        elif state == "IN":
            if (0 == V) and (1 == VL):
                state = "IDLE"


            if (0 == H) and (1 == HL):
                h_sync_width = 0
            if (0 == H):
                h_sync_width += 1
            if (1 == H) and (0 == HL):
                print h_sync_width

            if (1 == H) and (0 == HL):
                width = 0
            else:
                width += 1
            frames[-1].append((R*255,G*255,B*255))

        VL = V
        HL = H


    ''' Find '''
    for i in range(0, len(frames)):

        #for i in range(0,(512*512)):
        #im.append((random.randint(0,256),random.randint(0,256),random.randint(0,256)))

        new_img = Image.new("RGB", (1056, 5000), "white")
        new_img.putdata(frames[i])
        new_img.save('frame'+str(i)+'.png')

    #i = 0
    #runsim_clk = []
    #while(i < sim_len_ns):
    #    if(0 == i % PCLK_PERIOD_NS)
    #    runsim_clk.append(runsim[i])




    #for i in range(5,(len(runsim)-1)):
    #    signals = runsim[i].split(",")
    #    V = int(signals[1])
    #    H = int(signals[2])
    #    R = int(signals[3])
    #    G = int(signals[4])
    #    B = int(signals[5])
    #    if i > 5:
    #        if((Vl == 0) and (V == 1)):
    #            print "Vertical Sync"
    #        if((Hl == 0) and (H == 1)):
    #            print "Horizontal Sync"
    #        print R,G,B
    #    ''' Last signals '''
    #    Vl = V
    #    Hl = H


if "__main__" == __name__:
    main()
