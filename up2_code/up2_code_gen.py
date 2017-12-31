#!/usr/bin/python
import os
import sys
import platform
import subprocess
from optparse import OptionParser


def main():
    parser = OptionParser(usage="up2_code_gen.py [-h hex]" )
    parser.add_option("-x", "--hex", dest="hex", help="Raw hex file to turn in to verilog LUT")
    parser.add_option("-v", "--verilog", dest="verilog", help="Output verilog file")

    (options, args) = parser.parse_args()

    if((options.hex == None) or (options.verilog == None)):
        print "Error: must supply hex file in and verilog file out"
    else:
        ''' Read input '''
        h = open(options.hex, "r").read()

        ''' Write output '''
        v = open(options.verilog, "wb")
        v.write("`timescale 1ns/1ps\n")
        v.write("module up2_code(\n")
        v.write("\tinput  [$clog2(SIZE)-1:0]   address,\n")
        v.write("\toutput [3:0]                data\n")
        v.write(");\n")
        v.write("\tparameter SIZE = " + str(len(h)) + ";\n")
        v.write("\tassign data = \n")
        for i in range(0, len(h)):
            v.write("\t\t(address == 'd" + str(i) + ") ? 4'h" + h[i] + " :\n")
        v.write("\t\t'h0;\n")
        v.write("endmodule\n")

if "__main__" == __name__:
    main()
