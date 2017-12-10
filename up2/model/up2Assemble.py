#!/usr/bin/python
from up2Translate import up2Translate as t

class up2Assemble:
    ''' Assembler for up2 files '''

    def __init__(self, in_file, out_file):
        self.in_file = in_file
        self.out_file = out_file
        self.code = open(in_file, "r").read()
        self.resetErrorsAndWarnings()

    def resetErrorsAndWarnings(self):
        self.error = False
        self.warning = 0

    def printStats(self):
        print "--- Stats ---"
        print "Lines in: " + str(len(self.code.split("\n")))
        print "-------------"

    def printCode(self):
        print self.code

    def printCmds(self):
        for cmd in self.cmds:
            print cmd,self.cmds[cmd]

    def printInfo(self, info):
        print "    INFO: " + info

    def printWarning(self, warn):
        print " WARNING: " + warn
        self.warning += 1

    def printError(self, err):
        print "   ERROR: " + err
        self.error = True

    def printFinish(self):
        print "FINISHED:",
        if(self.error):
            print "ERROR"
        else:
            if(0 == self.warning):
                print "No warnings"
            elif(1 == self.warning):
                print "1 warning"
            else:
                print str(self.warning) + " warnings"
            self.printHex()

    def printStart(self):
        print "   START: up2 assembler"

    def printHex(self):
        top = "--"
        for i in range(0,len(self.out) / 256):
            top += "-"
        for i in range(0,16):
            top +=  "-" + str(hex(i))[2:]
        print top
        line = "0"
        while len(line) != 2 + len(self.out) / 256:
            line += "-"
        print line,
        for i in range(0,len(self.out)):
            print self.out[i],
            if (0 == (i + 1) % 16) and (0 != i) and (i+1 != len(self.out)):
                print
                line = str(hex((i + 1) / 16))[2:]
                while len(line) != 2 + len(self.out) / 256:
                    line += "-"
                print line,


    def removeWhiteSpace(self, line):
        return line.replace(" ","").replace("\t","")

    def assemble(self):
        self.printStart()
        self.resetErrorsAndWarnings()
        self.out = ""
        ptr = 0
        lines = self.code.split("\n")
        while ptr < len(lines) - 1 and not self.error:
            line = lines[ptr]
            self.printInfo("Assembling line " + str(ptr) + " "+ str(line))
            line = self.removeWhiteSpace(line.split("#")[0])
            cmd = ""
            for i in range(0, len(line)+1):
                if line[0:i] in t.cmds:
                    cmd = line[0:i]
                    break
            if "" == cmd:
                self.printError(str(cmd) + "not a valid operation")
            else:
                if cmd in t.use_muxes:
                    mux = line[len(cmd):]
                    if 3 == len(mux.split(",")):
                        if mux not in t.muxes:
                            self.printError("Line " + str(ptr) + " \"" + str(line) + "\" does not contain correct arguments")
                        else:
                            self.out += t.cmds[cmd]
                            self.out += t.muxes[mux]
                    else:
                        self.printError("Operation requires 3 mux arguments")
            ptr += 1
        self.printFinish()
















