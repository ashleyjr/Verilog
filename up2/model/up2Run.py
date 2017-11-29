#!/usr/bin/python

from up2Testbench import *
from up2Utils import *

def main():
    execute = up2ExecuteTestbench()
    execute.randRun()

    reg_stack = up2RegStackTestbench()
    reg_stack.randRun(1024)

    pc_stack = up2PcStackTestbench()
    pc_stack.randRun(1024)

    dp = up2ExecuteRegStackTestbench()
    dp.randRun()

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

    main = up2MainTestbench()

if "__main__" == __name__:
    main()
