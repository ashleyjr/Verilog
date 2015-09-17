#!/usr/bin/python
import os
import platform
import subprocess
from optparse import OptionParser




if "__main__" == __name__:
    os.chdir("..")
    os.chdir("up_memory")
    os.system("python gen_mem.py")
    os.chdir("..")
    os.system("python runsim.py -m up -s")
    os.chdir("up")
  