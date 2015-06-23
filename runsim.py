#!/usr/bin/python
import os
import platform
import subprocess
from optparse import OptionParser




if "__main__" == __name__:
    parser = OptionParser(usage="runsim.py [-m module] [-s do a sim] [-w view waves]" )
    parser.add_option("-m", "--module", dest="module", help="module to simulate - should not be defined if program is")
    parser.add_option("-s", "--sim", action="store_true", dest="sim")
    parser.add_option("-w", "--waves", action="store_true", dest="waves")
    (options, args) = parser.parse_args()

    sim = str(options.module)

    move = "cd " + sim
    os.chdir(sim)

    print
    print "--- runsim.py ---"
    print "  Module: "+ sim
    print "    Move: " + move + "/"

    if((options.sim == None) and (options.waves == None)):
        print "    Info: You must specify and operation"


    if(options.sim):
        print "    Info: Simulate " + str(sim)

        cmd = "iverilog -o " + str(sim) + ".dat -c " + str(sim) +"_filelist.txt"
        print "     Cmd: " + cmd
        os.system(cmd)


        cmd = "vvp " + str(sim) + ".dat -vcd"
        print "     Cmd: " + cmd
        os.system(cmd)


    if(options.waves):
        cmd = "gtkwave " + str(sim) +".vcd"
        print "     Cmd: " + cmd
        os.system(cmd)

    print "DONE"
    print
