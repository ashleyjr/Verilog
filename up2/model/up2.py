#!/usr/bin/python
import random

class up2Execute:
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

        ''' Flags '''
        self.z = 0

        ''' Model assertions '''
        assert self.regs[0] == 1, 'Fixed +1 reg assigned'
        for i in range(1,5):
            assert self.regs[i] < 16,'Overflow'
            assert self.regs[i] >= 0, 'Underflow'

    def writeRegs(self, regs):
        self.regs[1:3] = regs

    def readRegs(self):
        return self.regs

    def add(self):
        ''' Add with overflow wrap around '''
        self.regs[self.c] = self.regs[self.b] + self.regs[self.a]
        if self.regs[self.c] > 15:
            self.regs[self.c] -= 16
        self.updateZeroFlag()

    def sub(self):
        ''' Sub with underflow wrap around '''
        self.regs[self.c] = self.regs[self.b] - self.regs[self.a]
        if self.regs[self.c] < 0:
            self.regs[self.c] += 16
        self.updateZeroFlag()

    def updateZeroFlag(self):
        '''Flag after ALU update '''
        if 0 == self.regs[self.c]:
            self.z = 1
        else:
            self.z = 0

    def readZeroFLag(self):
        return self.z

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

class up2RegStack:
    ''' Model of the up2 processor register section '''

    def __init__(self):
        self.stack = []
        self.p = 0

        ''' Model assertions '''
        assert self.p >= 0, 'Stack out of range'

    def push(self, reg):
        if len(self.stack) == self.p:
            self.stack.append(reg)
        else:
            self.stack[self.p] = reg
        self.p += 1

    def pop(self):
        if 0 < self.p:
            self.p -= 1
        reg = self.stack[self.p]
        return reg

    def ptr(self):
        return self.p

class up2RegStackTestbench:
    ''' Testbench for regsiter stack section only '''

    def __init__(self):
        self.e = up2RegStack()

    def randReg(self):
        reg = []
        for i in range(0,5):
            reg.append(random.randint(0,15))
        return reg

    def randRun(self, runs):
        maxi = 0
        self.e.push(self.randReg())
        for run in range(0,runs):
            if self.e.ptr() > maxi:
                maxi = self.e.ptr()
            print   str(run) + "\t" + \
                    str(runs) + "\t" + \
                    str(self.e.ptr()) + "\t" +\
                    str(maxi),
            if random.randint(0,1):
                reg = self.randReg()
                self.e.push(reg)
                print "\tPUSH: " + str(reg)
            else:
                print "\tPOP:  " + str(self.e.pop())

class up2_execute_testbench:
    ''' Testbench for execute section only '''

    def __init__(self):
        self.e = up2Execute()

        ''' Model coverage '''
        self.coverage = []
        for i in range(0,5):
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
        for i in range(0,5):
            self.coverage[i][self.e.readRegs()[i]] = True

    def calcCoverage(self):
        total = 0
        covered = 0
        for i in range(1,5):
            for j in range(0,16):
                if self.coverage[i][j]:
                    covered += 1
                total += 1
        return float(covered)/float(total)

    def printCoverage(self):
        print "Reg\tValue\tCoverage"
        for i in range(1,5):
            for j in range(0,16):
                print str(i) + "\t" + str(j) + "\t" +  str(self.coverage[i][j])

    def randRun(self):
        run = 0
        while self.calcCoverage() < 1:
            op = random.randint(0,9)
            self.op(op)
            self.updateCoverage()
            print run,op,self.e.readRegs(),self.calcCoverage()
            run += 1

def main():
    execute = up2_execute_testbench()
    execute.randRun()

    stack = up2RegStackTestbench()
    stack.randRun(1024)

if "__main__" == __name__:
    main()
