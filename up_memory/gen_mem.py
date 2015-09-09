#!/usr/bin/python
import os
from os import listdir
from os.path import isfile, join


v = open("up_memory.v", "wb")

# Write header
v.write("module up_memory(\n")
v.write("\tinput  wire\t\t\tclk,\n")
v.write("\tinput  wire\t\t\tnRst,\n")
v.write("\tinput  wire\t[7:0]   in,\n")
v.write("\tinput  wire\t[7:0]   address,\n")
v.write("\tinput  wire\t\t\twe,\n")
v.write("\toutput wire\t[7:0]   out,\n")
v.write(");\n\n")

v.write("\treg [7:0] mem [255:0];\n\n")

v.write("\tassign out = mem[address];\n\n")

v.write("\talways@(posedge clk or negedge nRst) begin\n")
v.write("\t\tif(!nRst) begin\n")
for i in range(0,256):
	v.write("\t\t\tmem[" + str(i) +"] <= 8'h00;\n")

v.write("\t\tend else begin\n")
v.write("\t\t\tif(we) mem[address] <= in;\n")
v.write("\t\tend\n")
v.write("\tend\n")

#
v.write("\nendmodule")


v.close()



