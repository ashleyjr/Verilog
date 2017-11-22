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
        assert len(self.regs) == 5, 'Fixed length of registers'
        assert self.regs[0] == 1, 'Fixed +1 reg assigned'
        for i in range(1,5):
            assert self.regs[i] < 16,'Overflow'
            assert self.regs[i] >= 0, 'Underflow'

    def writeRegs(self, regs):
        self.regs = regs

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

    def printStack(self):
        print self.stack

