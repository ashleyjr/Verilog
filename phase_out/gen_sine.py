#!/usr/bin/python
import os
import platform
import subprocess
from optparse import OptionParser
from math import*



if "__main__" == __name__:

    s = open("sine.hex","w+")
    Fs=8000
    f=31.35
    sample=256
    for n in range(sample):
        s.write( "%x\n" % int(100 * (1 + sin(2*pi*f*n/Fs))))
    s.close()
