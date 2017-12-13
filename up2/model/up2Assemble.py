#!/usr/bin/python
import re
from up2Utils import up2Utils as u
from up2Translate import up2Translate as t

class up2Assemble:
    ''' Assembler for up2 files '''

    def __init__(self, in_file, out_file):
        self.u = u()
        self.in_file = in_file
        self.out_file = out_file
        self.code = open(in_file, "r").read()
        self.resetErrorsAndWarnings()

    def resetErrorsAndWarnings(self):
        self.error = False
        self.warning = 0

    def printInfo(self, info):
        print "    INFO: " + info

    def printWarning(self, warn):
        print " WARNING: " + warn
        self.warning += 1

    def printError(self, err):
        print "   ERROR: " + err
        self.error = True

    def printFinish(self):
        ''' Last line depends on errors and warnings '''
        print "FINISHED:",
        if(self.error):
            print "ERROR"
        else:
            if(0 == self.warning):
                print "No warnings",
            elif(1 == self.warning):
                print "1 warning",
            else:
                print str(self.warning) + " warnings",

    def printStart(self):
        print "   START: up2 assembler"

    def printHex(self):
        ''' Print output hexadecimal in a 16 wide grid '''
        top = "-"
        for i in range(0,len(self.out) / 256):
            top += "-"
        for i in range(0,16):
            top +=  "-" + str(hex(i))[2:]
        self.printInfo(top)
        line = "0"
        while len(line) != 2 + len(self.out) / 256:
            line += "-"
        for i in range(0,len(self.out)):
            line += self.out[i] + " "
            if (0 == (i + 1) % 16) and (0 != i) and (i+1 != len(self.out)):
                self.printInfo(line)
                line = str(hex((i + 1) / 16))[2:]
                while len(line) != 2 + len(self.out) / 256:
                    line += "-"
        self.printInfo(line)

    def writeHex(self):
        self.printInfo("Writing " + str(self.out_file))
        open(self.out_file, "w").write(self.out)
        self.printHex()

    def removeWhiteSpace(self, line):
        return line.replace(" ","").replace("\t","")

    def assemble(self):
        ''' Run the assembler sequence '''
        self.printStart()
        self.resetErrorsAndWarnings()
        labels_set = {}
        self.out = ""
        ptr = 0
        lines = self.code.split("\n")
        while ptr < len(lines) - 1 and not self.error:
            ''' Prepare line '''
            line = lines[ptr]
            self.printInfo("Assembling line " + str(ptr) + " "+ str(line))
            line = self.removeWhiteSpace(line.split("#")[0])
            ''' Labels '''
            if ":" in line:
                label = line.split(":")[0]
                line = line.split(":")[1]
                address = len(self.out)
                labels_set[label] = address
                self.printInfo("Label: " + label + " assigned address " + str(hex(address)))
            ''' Operations '''
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
                elif cmd in t.use_address:
                    label = line[len(cmd):]
                    self.printInfo("Found label \'" + label + "\'")
                    self.out += t.cmds[cmd]
                    self.out += "<" + label + ">"

            ptr += 1
        self.printInfo("Hex length before linking is " +str(len(self.out)))
        ''' Use length before linking to set the depth '''
        nibbles = self.u.fit(len(self.out),4)
        self.printInfo("Requires " + str(nibbles) + " nibble address width")
        if(False == self.error):
            self.printInfo("Running linker")
            links = self.out.split("<")
            link_str = str(len(links) - 1)
            if int(link_str) > 1:
                link_str += " links found"
            else:
                link_str += " link found"
            self.printInfo(link_str)
            ''' Iterate out and process labels so addresses align '''
            while i < len(self.out):
                if "<" == self.out[i]:
                    ''' Find the label '''
                    address = i
                    label = ""
                    i += 1
                    while ">" != self.out[i]:
                        label += self.out[i]
                        i += 1
                    ''' Replace the label with a number '''
                    if label in labels_set:
                        self.printInfo("Found label origin for \'" + str(label) + "\'")


                        ''' Problems '''
                        # Position of label origin will change as nibble width is unkown
                        # Position of labels will change as nibble width in unkown

                        # Iterate over the assembler with all values of nibbles
                        # Trying 1 nibbles ... won't fit
                        # Trying 2 nibbles, etc...



                i += 1
            for label in labels_set:
                if label in self.out:
                    old = "<" + label + ">"
                    new =  str(hex(labels_set[label])[2:])
                    used = self.out.count(old)
                    swap_str = "Found " + str(used)
                    if used > 1:
                        swap_str += " references of "
                    else:
                        swap_str += " reference of "
                    swap_str += label
                    self.printInfo(swap_str)
                    self.out = self.out.replace(old,new)
                else:
                    self.printWarning("Label \'" + label + "\' has origin but no reference")
            left = self.out.split("<")[1:]
            if left:
                self.printError("Label \'" + left[0].split(">")[0] + "\' referenced but no origin set")
        if(False == self.error):
            self.writeHex()
            self.printInfo("Lines assembled = " + str(len(lines)))
        self.printFinish()
















