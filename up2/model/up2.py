#!/usr/bin/python
import random

class up2_model:
    ''' Model of the up2 processor '''

    def __init__(self):
        ''' Datapath is unknown initially '''
        self.reg = []
        for i in range(0,3):
            self.reg.append(self.randReg())

    def randReg(self):
        return random.randint(0,15)

    def add(self):
        ''' Add with overflow wrap around '''
        self.reg[0] = self.reg[1] + self.reg[2]
        if self.reg[0] > 15:
            self.reg[0] -= 16

    def sub(self):
        ''' Sub with underflow wrap around '''
        self.reg[0] = self.reg[1] - self.reg[2]
        if self.reg[0] < 0:
            self.reg[0] += 16

    def nibbleHexStr(self, val):
        ''' Return '''
        return hex(val)

    def statusStr(self):
        status = ""
        status += "R0: " + self.nibbleHexStr(self.reg[0]) + "\n"
        status += "R1: " + self.nibbleHexStr(self.reg[1]) + "\n"
        status += "R2: " + self.nibbleHexStr(self.reg[2]) + "\n"
        return status

#class up2_verif:
#    ''' Verification of the up2 model '''
#
#    def __init__(self):
#
#

def main():
    up2 = up2_model()

    for i in range(0,4):
        print up2.statusStr()
        up2.add()

if "__main__" == __name__:
    main()
