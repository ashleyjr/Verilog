#!/usr/bin/python
import os
from os import listdir
from os.path import isfile, join

nm2hex = {
    'ADD'	: '0',
    'SUB'	: '1',
    'MUL'	: '2',
    'DIV'	: '3',
    'SW01'	: '4',
	'SW12'	: '5',
    'SW23'	: '6',
    'SWPC'	: '7',
    'LDW'	: '8',
    'STW'	: '9',
    'INT'	: 'A',
    'NAND'	: 'B',
    'PUSH'	: 'C',
    'POP'	: 'D',
    'BE'	: 'E',
    'BNE'	: 'F'
}

c = open("code.asm","r")
hx = ['0'] * 256
i = 0;
for line in c:
	hx[i] = nm2hex[line.rstrip()]
	print hx[i]
	i = i + 1

print hx

v = open("up_memory.v", "wb")

# Write header
v.write("module up_memory(\n")
v.write("\tinput  wire\t\t\tclk,\n")
v.write("\tinput  wire\t\t\tnRst,\n")
v.write("\tinput  wire\t[7:0]   in,\n")
v.write("\tinput  wire\t[7:0]   address,\n")
v.write("\tinput  wire\t\t\twe,\n")
v.write("\toutput wire\t[7:0]   out,\n")
v.write("\toutput wire\t\t\tre\n")
v.write(");\n\n")

v.write("\treg [7:0] mem [255:0];\n\n")

v.write("\tassign out = mem[address];\n")
v.write("\tassign re = 1'b1;\n\n")

v.write("\talways@(posedge clk or negedge nRst) begin\n")
v.write("\t\tif(!nRst) begin\n")

for i in range(0,128):
	v.write("\t\t\tmem[" + str(i) +"] <= 8'h" + str(hx[(i*2)]) + str(hx[(i*2) + 1]) + ";\n")

v.write("\t\tend else begin\n")
v.write("\t\t\tif(we) mem[address] <= in;\n")
v.write("\t\tend\n")
v.write("\tend\n")

#
v.write("\nendmodule")


v.close()



