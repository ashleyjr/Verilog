#!/usr/bin/python
import os
import platform
import subprocess
from optparse import OptionParser
from math import *



if "__main__" == __name__:
    parser = OptionParser(usage="new_module.py [-n name]" )
    parser.add_option("-n", "--name", dest="name", help="Creates new module with a given name")
    (options, args) = parser.parse_args()

    sim = "adc"

    print
    print "--- new_module.py ---"
    print "  Module: " + sim


    tb = open(sim + "_tb.v", "wb")
    tb.write("module " + sim + "_tb;\n")
    tb.write("\n")
    tb.write("\tparameter CLK_PERIOD = 20;\n")
    tb.write("\n")
    tb.write("\treg clk;\n")
    tb.write("\treg nRst;\n")
    tb.write("\treg [31:0] read;\n")
    tb.write("\n")
    tb.write("\t" + sim + " " + sim + "(\n")
    tb.write("\t\t.clk\t(clk),\n")
    tb.write("\t\t.nRst\t(nRst),\n")
    tb.write("\t\t.read\t(read)\n")
    tb.write("\t);"+ "\n")
    tb.write("\n")
    tb.write("\tinitial begin\n")
    tb.write("\t\twhile(1) begin\n")
    tb.write("\t\t\t#(CLK_PERIOD/2) clk = 0;\n")
    tb.write("\t\t\t#(CLK_PERIOD/2) clk = 1;\n")
    tb.write("\t\tend")
    tb.write("\tend\n")
    tb.write("\n")
    tb.write("\tinitial begin\n")
    tb.write("\t\t$dumpfile(\"" + sim + ".vcd\");\n")
    tb.write("\t\t$dumpvars(0," + sim + "_tb);\n")
    tb.write("\tend\n\n")
    tb.write("\tinitial begin\n")
    tb.write("\t\t\t\t\tnRst = 1;\n")
    tb.write("\t\t#100\t\tnRst = 0;\n")
    tb.write("\t\t#100\t\tnRst = 1;\n")

    for i in range(1,1000):
        val = 10000 + 10000*sin(float(i)/100)
        tb.write("\t\t#100\t\tread = 32'd%0.0f;\n" % val)
        print val

    tb.write("\t\t#10000\n")
    tb.write("\t\t$finish;\n")
    tb.write("\tend\n\n")
    tb.write("endmodule\n")
    tb.close()



    print
    print "DONE"
    print
