#!/usr/bin/python
import os
import platform
import subprocess
from optparse import OptionParser




if "__main__" == __name__:
    parser = OptionParser(usage="new_module.py [-n name]" )
    parser.add_option("-n", "--name", dest="name", help="Creates new module with a given name")
    (options, args) = parser.parse_args()

    sim = str(options.name)
    move = "cd " + sim

    print
    print "--- new_module.py ---"
    print "  Module: " + sim


    if(os.path.isdir(sim) == False):
        print "    Move: " + move + "/"
        os.mkdir(sim)
        os.chdir(sim)

        txt_name = sim + ".txt"
        v_name = sim + ".v"
        tb_name = sim + "_tb.v"


        txt = open(txt_name, "wb")
        txt.write(v_name + "\n")
        txt.write(tb_name + "\n")
        txt.close()

        v = open(v_name, "wb")
        v.write("module " + sim + "(\n" )
        v.write("\tinput\tclk,\n")
        v.write("\tinput\tnRst,\n")
        v.write(");"+ "\n")
        v.close()

        tb = open(tb_name, "wb")
        tb.write(v_name + "\n")
        tb.write(tb_name + "\n")
        tb.close()




    else:
        print "   Error: Module already exists!"

    print
    print "DONE"
    print
