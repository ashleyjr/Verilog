#!/usr/bin/python
from optparse import OptionParser
from up2Testbench import *
from up2Utils import *
from up2Assemble import *
from up2 import *
import os

def main():
    parser = OptionParser(usage="./up2Run.py [single argument]" )
    parser.add_option("-e", "--execute",        action="store_true",    dest="execute")
    parser.add_option("-r", "--reg",            action="store_true",    dest="reg")
    parser.add_option("-p", "--pc",             action="store_true",    dest="pc")
    parser.add_option("-b", "--execute_reg",    action="store_true",    dest="execute_reg")
    parser.add_option("-f", "--fetch",          action="store_true",    dest="fetch")
    parser.add_option("-m", "--mem",            action="store_true",    dest="mem")
    parser.add_option("-d", "--datapath",       action="store_true",    dest="datapath")
    parser.add_option("-a", "--assemble",       action="store_true",    dest="assemble",    help="Assemble supplied up2lang (.up2) file")
    parser.add_option("-x", "--hex",            action="store_true",    dest="run",         help="Run supplied hex file")
    parser.add_option("-g", "--go",             action="store_true",    dest="go",          help="Assemble and run the machine code")
    parser.add_option("-i", "--in",                                     dest="in_file",     help="Code file to be assembled in")
    parser.add_option("-o", "--out",                                    dest="out_file",    help="Machine code file out")
    (options, args) = parser.parse_args()

    if(options.execute != None):
        execute = up2ExecuteTestbench()
        execute.randRun()

    elif(options.reg):
        reg_stack = up2RegStackTestbench()
        reg_stack.randRun(1024)

    elif(options.pc):
        pc_stack = up2PcStackTestbench()
        pc_stack.randRun(1024)

    elif(options.execute_reg):
        dp = up2ExecuteRegStackTestbench()
        dp.randRun()

    elif(options.fetch):
        ''' Specific test vectors to execute fecth section '''
        fetch = up2FetchTestbench()
        fetch.test(     # Increment over pc with 4
            "0123456789ABCEDF",
            "00000000000000"
        )
        fetch.test(     # Increment over pc width 5
            "0123456789ABCDEF0",
            "00000000000000"
        )
        fetch.test(     # Increment over pc width 6
            "0123456789ABCDEF0123456789ABCDEF0",
            "000000000000000000000000000000"
        )

    elif(options.mem):
        main = up2MainTestbench()

    elif(options.datapath):
        dpwm = ExecuteMainRegStackTestbench()
        dpwm.run()

    elif(options.assemble):
        a = up2Assemble(options.in_file,options.out_file)
        a.assemble()

    elif(options.go):

        if os.path.isfile(options.out_file):
            os.remove(options.out_file)

        a = up2Assemble(options.in_file,options.out_file)
        a.assemble()

        u = up2(options.out_file)
        u.run(300,"ALL MEM")

if "__main__" == __name__:
    main()
