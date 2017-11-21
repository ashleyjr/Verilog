#!/usr/bin/python

from up2Testbench import *

def main():
    execute = up2ExecuteTestbench()
    execute.randRun()

    stack = up2RegStackTestbench()
    stack.randRun(1024)

if "__main__" == __name__:
    main()
