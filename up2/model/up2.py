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
        self.m = up2Main(1,1)                           # Main mem

    def printStatus(self):
        r = self.e.readRegs()
        pc = self.f.getPc()
        print "PC=" + str(hex(pc)),
        print "R0=" + str(hex(r[1])),
        print "R1=" + str(hex(r[2])),
        print "R2=" + str(hex(r[3])),

    def run(self, count, print_option):
        print "\nModel run for " + str(count) + " ops"
        last_regs = str(self.e.readRegs())
        for i in range(0, count):

            if print_option == "ALL":
                self.printStatus()

            ''' Get current op '''
            for cmd in t.cmds:
                if str(t.cmds[cmd]) == self.f.getStrNibble():
                    c = cmd
                    break

            ''' Get mux setting '''
            if c in t.use_muxes:
                ''' Decode '''
                self.f.incPc()
                for mux in t.muxes:
                    if str(t.muxes[mux]) == self.f.getStrNibble():
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

            ''' Get address '''
            if c in t.use_address:
                self.f.incPc()
                address = self.f.getNibble() << 4
                self.f.incPc()
                address = address | self.f.getNibble()

            ''' Execute operation '''
            if "ADD" == c:
                self.e.add()
                self.f.incPc()
            elif "SUB" == c:
                self.e.sub()
                self.f.incPc()
            elif "OOR" == c:
                self.e.orr()
                self.f.incPc()
            elif "NOR" == c:
                self.e.nor()
                self.f.incPc()
            elif "XOR" == c:
                self.e.xor()
                self.f.incPc()
            elif "NAN" == c:
                self.e.nan()
                self.f.incPc()
            elif "LSL" == c:
                self.e.lsl()
                self.f.incPc()
            elif "LSR" == c:
                self.e.lsr()
                self.f.incPc()
            elif "BEQ" == c:
                if self.e.readZeroFLag():
                    self.f.setPc(address)
            elif "BNE" == c:
                if not self.e.readZeroFLag():
                    self.f.setPc(address)
            elif "JMP" == c:
                self.f.setPc(address)
            elif "SHM" == c:
                self.m.swapR0()
                self.f.incPc()
            elif "MEM" == c:
                self.m.swap()
                self.f.incPc()

            if print_option == "ALL":
                print "> " + c + " " + m + " > ",
                self.printStatus()
                print

            if print_option == "CHANGE":
                if last_regs != str(self.e.readRegs()):
                    self.printStatus()
                    print
                    last_regs = str(self.e.readRegs())











