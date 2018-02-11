#!/usr/bin/python
from PIL import Image
import random

TB_SAMPLE_NS = 40
PCLK_MHZ = 40
PCLK_PERIOD_NS = int(1e9/(PCLK_MHZ*1e6))

def main():

    ''' Load data, remove first and last 100 lines '''
    runsim = open("vga_out_runsim.txt","r").read()
    runsim = runsim.split("\n")
    runsim = runsim[100:-100]
    sim_len_ns = len(runsim)

    ''' Find frame and horizontal frequency '''
    first_v = True
    first_h = True
    width_v_ns = 0
    width_h_ns = 0
    vers = []
    hors = []
    for i in range(0, len(runsim)):
        data = runsim[i].split(",")
        V = int(data[0])
        H = int(data[1])
        if (i > 0):
            ''' Vertical '''
            if (VL == 0) and (V == 1):
                if not first_v:
                    f = 1/(width_v_ns*1e-9)
                    if f not in vers:
                        vers.append(f)
                else:
                    first_v = False
                width_v_ns = 0
            else:
                width_v_ns += TB_SAMPLE_NS
            ''' Horizontal '''
            if (HL == 0) and (H == 1):
                if not first_h:
                    f = 1/(width_h_ns*1e-9)
                    if f not in hors:
                        hors.append(f)
                else:
                    first_h = False
                width_h_ns = 0
            else:
                width_h_ns += TB_SAMPLE_NS
        VL = V
        HL = H
    print "Vertical frequency (Hz) "+str(vers)
    print "Horizontal frequency (Hz) "+str(hors)





    print "Processing 640 x 480 frames @ 60Hz"


    ''' Data as seen by clock processed to image '''
    first = True
    record = False
    frames = []
    for i in range(0, sim_len_ns):
        data = runsim[i].split(",")
        V = int(data[0])
        H = int(data[1])
        R = int(data[2])
        G = int(data[3])
        B = int(data[4])


        if (1 == V) and (0 == VL):
            record = True
            frames.append([])
        if record:
            frames[-1].append((R*255,G*255,B*255))


        first = False
        VL = V
        HL = H


    ''' Find '''
    for i in range(0, len(frames)):
        loc = 'frame'+str(i)+'.png'
        new_img = Image.new("RGB", (800, 523), "white")
        new_img.putdata(frames[i])
        new_img = new_img.crop((0,0,640,480))
        new_img.save(loc)


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
