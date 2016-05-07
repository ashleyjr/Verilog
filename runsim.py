#!/usr/bin/python
import os
import platform
import subprocess
from optparse import OptionParser



def cmd_print(cmd):
    print "     Cmd: " + cmd
    os.system(cmd)

def main():
    parser = OptionParser(usage="runsim.py [-m module] [-s do a sim] [-w view waves]" )
    parser.add_option("-m", "--module", dest="module", help="module to simulate - should not be defined if program is")
    parser.add_option("-s", "--sim", action="store_true", dest="sim")
    parser.add_option("-w", "--waves", action="store_true", dest="waves")
    parser.add_option("-x", "--synth",action="store_true", dest="synth")
    parser.add_option("-y", "--synth_sim",action="store_true", dest="syn_sim")
    parser.add_option("-z", "--synth_waves",action="store_true", dest="syn_waves")
    (options, args) = parser.parse_args()

    sim = str(options.module)

    move = "cd " + sim
    os.chdir(sim)

    temp =  str(sim) + "_runsim.txt"

    yosys = str(sim) + "_yosys.ys"

    yosys_out = str(sim) + "_yosys_out.txt"

    yosys_blif = str(sim) + ".blif"
    print
    print "--- runsim.py ---"
    print "  Module: "+ sim
    print "    Move: " + move + "/"

    no_op = True
    if(options.sim != None):
        no_op = False
    if(options.waves != None):
        no_op = False
    if(options.synth != None):
        no_op = False
    if(options.syn_sim != None):
        no_op = False
    if(options.syn_waves != None):
        no_op = False
    if(no_op):
        print "    Info: You must specify and operation"


    if(options.sim):
        print "    Info: Searching for simulation dependants"
        code = "code"
        if(os.path.isdir(code)):
            os.chdir(code)
            print "    Move: " + code + "/"
            for file in os.listdir("."):
                if file.endswith(".asm"):
                    cmd_print("python assembler.py -c " + str(file) + " > " + str(file).replace(".asm",".txt"))
            os.chdir("..")



        print "    Info: Simulate " + str(sim)
        cmd_print("iverilog -o " + str(sim) + ".dat -c " + str(sim) +"_filelist.txt")
        cmd_print("vvp " + str(sim) + ".dat -vcd > " + temp)


        print "    Info: Head of " + temp
        f = open(temp)
        count = 1
        for line in f:
            print "    Info: " + line,
            count = count + 1
            if(count > 15):
                break


    if(options.synth):
        print "    Info: Synth"
        cmd_print("yosys -p 'synth_ice40 -top " + sim + " -blif " + sim +".blif' " + sim + ".v > " + sim + "_syn.txt")
        cmd_print("yosys -o " + sim + "_syn.v " + sim + ".blif > " + sim + "_blif.txt")


    if(options.syn_sim):
        cmd_print("iverilog -o " + sim + "_syn.dat -D POST_SYNTHESIS " + sim + "_tb.v " + sim + "_syn.v \ `yosys-config --datdir/ice40/cells_sim.v`")
        cmd_print("vvp " + str(sim) + "_syn.dat -vcd > " + temp)

    if(options.syn_waves):
        cmd_print("gtkwave -S" + str(sim) + "_tb.tcl " + str(sim) +"_syn.vcd ")

    if(options.waves):
        cmd_print("gtkwave -S " + str(sim) + "_tb.tcl "+ str(sim) +".vcd")

    print
    print "DONE"
    print

if "__main__" == __name__:
    main()
