#!/usr/bin/python
import os
import re
import string
import sys
from os import listdir
from os.path import isfile, join

nm2hex = {
    'ADD'	: '0',
    'SUB'	: '1',
    'MUL'	: '2',
    'NAND'	: '3',
    'SW01'	: '4',
    'SW12'	: '5',
    'SW23'	: '6',
    'BE'	: '7',
    'POPC'	: '8',
    'PUSHC'	: '9',
    'POP'	: 'A',
    'PUSH'	: 'B',
    'LDW'	: 'C',
    'STW'	: 'D',
    'REF'	: 'E',
    'INT'	: 'F'
}

WarnLongConst = False
ErrNotHex = False

c = open("code.asm","r")
hx = ['0'] * 512


sys.stdout.write('Address\t1st\t2nd\n')
i = 0;
for line in c:
    # String handling
    line = re.sub(" ", "", line)    # remove unwanted
    line = re.sub("\n", "", line)
    line = re.sub("\r", "", line)

    comment = ""
    if(len(line.split('#')) > 1):
        comment = line.split('#')[1]



    line = line.split('#')[0]       # Split on comment

    chars = list(line)              # split in to char


    if(len(chars) != 0):
        if(i < 8):
            hx[i]   = chars[0]
            hx[i+1]   = chars[1]
            i = i + 2
            # Error checking
            if(len(chars) > 2):
                WarnLongConst = True
            if(chars[0] not in string.hexdigits):
                ErrNotHex = True
            if(chars[1] not in string.hexdigits):
                ErrNotHex = True
        else:
            line = re.sub(r"\W", "", line)  # remove unwanted
            if(line == "ISR"):
                i = 256;
            else:
                if((i % 2) == 0):
                    sys.stdout.write(str(hex(i/2)) + '\t' + line + '\t')
                else:
                    sys.stdout.write(line + '\n')
                hx[i] = nm2hex[line]
                i = i + 1
    else:
        if(comment[:6] == "LABEL:"):
            print "\n\n" + comment[6:]  + "= "+ str(hex(i)) +"\n"

print ""
print ""
print "Reg R0:  \t0x" + hx[0] +  hx[1]
print "Reg R1:  \t0x" + hx[2] +  hx[3]
print "Reg R2:  \t0x" + hx[4] +  hx[5]
print "Reg R3:  \t0x" + hx[6] +  hx[7]
print ""
print"Lines of code:\t" + str(i)
print
print hx
print



if(WarnLongConst):
    print "WARNING: First four lines must contain hexidecimal byte, first two chars taken"
if(ErrNotHex):
    print "ERROR: First four lines must contain hexidecimal byte, bad output"





v = open("up_memory.v", "wb")

# Write header
v.write("module up_memory(\n")
v.write("\tinput  wire\t\t\tclk,\n")
v.write("\tinput  wire\t\t\tnRst,\n")
v.write("\tinput  wire\t[7:0]   in,\n")
v.write("\tinput  wire\t[7:0]   address,\n")
v.write("\tinput  wire\t\t\twe,\n")
v.write("\toutput wire\t[7:0]   out,\n")
v.write("\toutput wire\t\t\tre,\n")
v.write("\toutput wire\t[7:0]\t\ttest\n")
v.write(");\n\n")

v.write("\treg [7:0] mem [255:0];\n\n")
v.write("\treg [4:0] count;\n\n")

v.write("\tassign re = (count > 5'h04) ? 1'b1 : 1'b0;     // PSRB number generate\n")

v.write("\tassign out = mem[address];\n")

v.write("\tassign test = mem[127];\n\n")

v.write("\talways@(posedge clk or negedge nRst) begin\n")
v.write("\t\tif(!nRst) begin\n")
v.write("\t\t\tcount <= 4'b0;\n")

for i in range(0,256):
	v.write("\t\t\tmem[" + str(i) +"] <= 8'h" + str(hx[(i*2)]) + str(hx[(i*2) + 1]) + ";\n")

v.write("\t\tend else begin\n")
v.write("\t\t\tif(we) mem[address] <= in;\n")
v.write("\t\t\tcount <= count + 1'b1;\n")
v.write("\t\tend\n")
v.write("\tend\n")

#
v.write("\nendmodule")


v.close()



