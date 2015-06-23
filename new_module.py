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
    else:
        print "   Error: Module already exists!"

    print
    print "DONE"
    print
