#!/usr/bin/python
import random
from up2Utils import *
from up2 import *

class up2RegStackTestbench:
    ''' Testbench for regsiter stack section only '''

    def __init__(self):
        self.e = up2Stack()
        self.u = up2Utils()

    def randRun(self, runs):
        maxi = 0
        self.e.push(self.u.randReg(4,5))
        for run in range(0,runs):
            if self.e.ptr() > maxi:
                maxi = self.e.ptr()
            print   str(run) + "\t" + \
                    str(runs) + "\t" + \
                    str(self.e.ptr()) + "\t" +\
                    str(maxi),
            if random.randint(0,1):
                reg = self.u.randReg(4,5)
                self.e.push(reg)
                print "\tPUSH: " + str(reg)
            else:
                print "\tPOP:  " + str(self.e.pop())

class up2PcStackTestbench:
    ''' Testbench for PC stack section only '''

    def __init__(self):
        self.e = up2Stack()
        self.u = up2Utils()

    def randRun(self, runs):
        maxi = 0
        self.e.push(self.u.randReg(4,2))
        for run in range(0,runs):
            if self.e.ptr() > maxi:
                maxi = self.e.ptr()
            print   str(run) + "\t" + \
                    str(runs) + "\t" + \
                    str(self.e.ptr()) + "\t" +\
                    str(maxi),
            if random.randint(0,1):
                reg = self.u.randReg(4,2)
                self.e.push(reg)
                print "\tPUSH: " + str(reg)
            else:
                print "\tPOP:  " + str(self.e.pop())


class up2ExecuteTestbench:
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

class up2ExecuteRegStackTestbench:
    ''' Testbench for execute and register stack section only '''

    def __init__(self):
        self.e = up2Execute()
        self.r = up2Stack()
        self.u = up2Utils()

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
        elif(10 == op):
            self.r.push(self.e.readRegs())
        elif(11 == op):
            self.e.writeRegs(self.r.pop())


    def randRun(self):
        self.r.push(self.u.randReg(4,5))
        for i in range(0,32):
            op = random.randint(0,11)
            self.op(op)
            print op,self.e.readRegs()

class up2FetchTestbench:
    ''' Testbench for fectch section only '''

    def op(self, op):
        ''' Execute an op'''
        if(0 == op):
            print "incPc: ",
            self.f.incPc()
        elif(2 == op):
            print "relPc: ",
            self.f.relPc()
        elif(3 == op):
            print "absPc: ",
            self.f.absPc()

    def test(self, code, ops):
        self.f = up2Fetch(code)
        self.f.printCode()
        print "       ",
        self.f.printState()
        for op in ops:
            self.op(int(op))
            self.f.printState()

class up2MainTestbench:
    ''' Testbench for main memory section only '''

    def __init__(self):
        self.m = up2Main(4,4)
        self.m.swap()
        self.m.printMain()


        self.m.shift(int("A",16))
        self.m.shift(int("5",16))
        self.m.shift(int("C",16))
        self.m.shift(int("D",16))
        self.m.shift(int("2",16))


        #data = int("FFFF",16)
        #print data
        #print self.m.mask(data)









