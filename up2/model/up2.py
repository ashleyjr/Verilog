#!/usr/bin/python
from up2Components import *

class up2:
    ''' Model of the up2 processor '''

    def __init__(self, code, addr_nibbles, data_nibbles):
        self.p = up2Stack()                             # PC Stack
        self.r = up2Stack()                             # Reg Stack
        self.e = up2Execute()                           # Execute
        self.f = up2Fetch(code)                         # Fetch
        self.m = up2Main(addr_nibbles,data_nibbles)     # Main memory

    def run(self):
        print "Running"
