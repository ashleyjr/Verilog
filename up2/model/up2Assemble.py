#!/usr/bin/python

class up2Assemble:
    ''' Assembler for up2 files '''

    def __init__(self, in_file, out_file):
        self.in_file = in_file
        self.out_file = out_file
        self.code = open(in_file, "r").read()

    def printStats(self):
        print self.in_file

    def printCode(self):
        print self.code

