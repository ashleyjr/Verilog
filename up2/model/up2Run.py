#!/usr/bin/python

from up2Testbench import *
from up2Utils import *

def main():
    execute = up2ExecuteTestbench()
    execute.randRun()

    stack = up2RegStackTestbench()
    stack.randRun(1024)

    dp = up2ExecuteRegStackTestbench()
    dp.randRun()

    fetch = up2FetchTestbench()
    fetch.test()


if "__main__" == __name__:
    main()
