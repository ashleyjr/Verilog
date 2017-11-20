#!/usr/bin/python
import random

class up2_execute:
    ''' Model of the up2 processor execute section '''

    def __init__(self):
        ''' Register block '''
        self.regs = []
        self.regs.append(1)
        for i in range(1,5):
            self.regs.append(random.randint(0,15))

        ''' Mux setup '''
        self.a = random.randint(0,1)
        self.b = random.randint(2,3)
        self.c = random.randint(1,4)

    def writeRegs(self, regs):
        self.regs[1:3] = regs

    def readRegs(self):
        return self.regs

    def add(self):
        ''' Add with overflow wrap around '''
        self.regs[self.c] = self.regs[self.b] + self.regs[self.a]
        if self.regs[self.c] > 15:
            self.regs[self.c] -= 16

    def sub(self):
        ''' Sub with underflow wrap around '''
        self.regs[self.c] = self.regs[self.b] - self.regs[self.a]
        if self.regs[self.c] < 0:
            self.regs[self.c] += 16

    def setRegOut1(self):
        self.a = 0

    def setRegOutR0(self):
        self.a = 1

    def setRegOutR1(self):
        self.b = 2

    def setRegOutR2(self):
        self.b = 3

    def setRegInR0(self):
        self.c = 1

    def setRegInR1(self):
        self.c = 2

    def setRegInR2(self):
        self.c = 3

    def setRegInCmp(self):
        self.c = 4

class up2_execute_testbench:
    ''' Testbench for execute section only '''

    def __init__(self):
        self.e = up2_execute()
        self.coverage = []
        for i in range(0,3):
            self.coverage.append([False] * 16)

    def op(self, op):
        ''' Execute an op'''
        if(0 == op):
            self.e.add()
        elif(1 == op):
            self.e.sub()
        elif(2 == op):
            self.e.setRegOut1()
        elif(3 == op):
            self.e.setRegOutR0()
        elif(4 == op):
            self.e.setRegOutR1()
        elif(5 == op):
            self.e.setRegOutR2()
        elif(6 == op):
            self.e.setRegInR0()
        elif(7 == op):
            self.e.setRegInR1()
        elif(8 == op):
            self.e.setRegInR2()
        elif(9 == op):
            self.e.setRegInCmp()

    def updateCoverage(self):
        for i in range(0,3):
            self.coverage[i][self.e.readRegs()[i]] = True

    def calcCoverage(self):
        total = 0
        covered = 0
        for i in range(0,3):
            for j in range(0,16):
                if self.coverage[i][j]:
                    covered += 1
                total += 1
        return float(covered)/float(total)

    def randRun(self, its):
        assert self.e.readRegs()[0] == 1, 'Fixed +1 reg assigned'
        for i in range(0,5):
            assert self.e.readRegs()[0] < 16,'Overflow'
            assert self.e.readRegs()[0] > 0, 'Underflow'
        for i in range(0,its):
            op = random.randint(0,9)
            self.op(op)
            self.updateCoverage()
            print self.calcCoverage()

def main():
    up2 = up2_execute_testbench()
    up2.randRun(1000000)

if "__main__" == __name__:
    main()
