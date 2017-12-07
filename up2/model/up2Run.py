#!/usr/bin/python
from optparse import OptionParser
from up2Testbench import *
from up2Utils import *

def main():
    parser = OptionParser(usage="./up2Run.py [single argument]" )
    parser.add_option("-e", "--execute",        action="store_true",    dest="execute")
    parser.add_option("-r", "--reg",            action="store_true",    dest="reg")
    parser.add_option("-p", "--pc",             action="store_true",    dest="pc")
    parser.add_option("-b", "--execute_reg",    action="store_true",    dest="execute_reg")
    parser.add_option("-f", "--fetch",          action="store_true",    dest="fetch")
    parser.add_option("-m", "--mem",            action="store_true",    dest="mem")
    parser.add_option("-d", "--datapath",       action="store_true",    dest="datapath")
    parser.add_option("-a", "--assemble",       action="store_true",    dest="assemble")
    parser.add_option("-c", "--code",           action="store_true",    dest="code")
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
        dpwm = up2ExecuteMainRegStackTestbench()
        dpwm.run()

if "__main__" == __name__:
    main()
