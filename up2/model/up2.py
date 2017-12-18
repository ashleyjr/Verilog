#!/usr/bin/python
from up2Components import *
from up2Translate import up2Translate as t

class up2:
    ''' Model of the up2 processor '''

    def __init__(self, code_file):
        self.p = up2Stack()                             # PC Stack
        self.r = up2Stack()                             # Reg Stack
        self.e = up2Execute()                           # Execute
        self.f = up2Fetch(open(code_file, "r").read())  # Fetch

    def run(self, count):
        print "\nModel run for " + str(count) + " ops"
        for i in range(0, count):
            start_r = self.e.readRegs()
            start_pc = self.f.getPc()

            ''' Get current op '''
            for cmd in t.cmds:
                if str(t.cmds[cmd]) == str(self.f.getNibble()):
                    c = cmd
                    break

            ''' Get mux setting '''
            if c in t.use_muxes:
                ''' Decode '''
                self.f.incPc()
                for mux in t.muxes:
                    if str(t.muxes[mux]) == str(self.f.getNibble()):
                        m = mux
                        break
                ''' Set '''
                segs = m.split(',')
                if segs[0] == "R0":
                    self.e.setRegInR0()
                elif segs[0] == "R1":
                    self.e.setRegInR1()
                elif segs[0] == "R2":
                    self.e.setRegInR2()
                elif segs[0] == "R?":
                    self.e.setRegInCmp()
                if segs[1] == "1":
                    self.e.setRegOut1()
                elif segs[1] == "R0":
                    self.e.setRegOutR0()
                if segs[2] == "R1":
                    self.e.setRegOutR1()
                elif segs[2] == "R2":
                    self.e.setRegOutR2()

            ''' Execute operation '''
            if "ADD" == c:
                self.e.add()
            elif "SUB" == c:
                self.e.sub()
            elif "XOR" == c:
                self.e.xor()
            elif "LSL" == c:
                self.e.lsl()

            self.f.incPc()

            ''' Print status '''
            r = self.e.readRegs()
            print "PC=" + str(hex(start_pc)),
            print "R0=" + str(hex(start_r[1])),
            print "R1=" + str(hex(start_r[2])),
            print "R2=" + str(hex(start_r[3])),
            print "> " + c + " " + m + " > ",
            print "PC=" + str(hex(self.f.getPc())),
            print "R0=" + str(hex(r[1])),
            print "R1=" + str(hex(r[2])),
            print "R2=" + str(hex(r[3]))












