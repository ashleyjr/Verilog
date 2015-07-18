#!/usr/bin/python
import os
import platform
import subprocess
import csv
from optparse import OptionParser
from numpy import genfromtxt



if "__main__" == __name__:
    parser = OptionParser(usage="new_module.py [-n name]" )
    parser.add_option("-p", "--path", dest="path", help="File containing coeffcients")
    parser.add_option("-w", "--width", dest="width", help="Bit width")
    (options, args) = parser.parse_args()


    path = str(options.path)
    width = int(options.width)
    width1 = width - 1
    name = "fir_filter.v"


    print
    print "--- fir_filter_gen.py ---"
    print "\tCoeffcients: " + path

    coeffs = genfromtxt(path, delimiter=',')

    print coeffs


    if(os.path.isfile(name)):
        os.remove(name)

    fir = open(name, "wb")
    fir.write("module fir_filter(\n")
    fir.write("\tinput                      clk,\n")
    fir.write("\tinput                      nRst,\n")
    fir.write("\tinput                      sample,  // Take a sample\n")
    fir.write("\tinput    signed   [%0.0f:0]   in,      // Data in to filter\n" % width1)
    fir.write("\toutput   signed   [%0.0f:0]   out      // Data out of filter\n" % width1)
    fir.write(");\n")
    fir.write("\tparameter LENGTH = %0.0f;\n" % (len(coeffs)-2))
    fir.write("\treg signed [%0.0f:0] delay [LENGTH:0];\n\n" % width1)

    fir.write("\tassign\n")
    fir.write("\t\tout =\tin\t\t\t\t*\t\t\t%0.0f'd%0.0f\t\t\t+\n" % (width,coeffs[0]))
    for i in range(0,len(coeffs)-2):
        fir.write("\t\t\tdelay[%0.0f]\t\t\t*\t\t\t%0.0f'd%0.0f\t\t\t+\n" % (i,width, coeffs[i+1]))
    fir.write("\t\t\tdelay[%0.0f]\t\t\t*\t\t\t%0.0f'd%0.0f\t\t\t;\n\n" % (len(coeffs)-2, width, coeffs[len(coeffs)-1]))

    fir.write("")
    fir.write("")
    fir.write("\talways @(posedge clk or negedge nRst) begin\n")
    fir.write("\t\tif(!nRst) begin\n")
    fir.write("\t\t\tdelay[0] <= %0.0f'b0;\n" % width)
    fir.write("\t\tend else begin\n")
    fir.write("\t\t\tif(sample) begin\n")
    fir.write("\t\t\t\tdelay[0] <= in;\n")
    fir.write("\t\t\tend\n")
    fir.write("\t\tend\n")
    fir.write("\tend\n\n")
    fir.write("\tgenvar i;\n")
    fir.write("\t\tgenerate\n")
    fir.write("\t\t\tfor (i = 0; i < LENGTH; i = i + 1) begin: pipe\n")
    fir.write("\t\t\t\talways @(posedge clk or negedge nRst) begin\n")
    fir.write("\t\t\t\t\tif(!nRst) begin\n")
    fir.write("\t\t\t\t\t\tdelay[i] <= %0.0f'b0;\n" % width)
    fir.write("\t\t\t\t\tend else begin\n")
    fir.write("\t\t\t\t\t\tdelay[i+1] <= delay[i];\n")
    fir.write("\t\t\t\t\tend\n")
    fir.write("\t\t\t\tend\n")
    fir.write("\t\t\tend\n")
    fir.write("\t\tendgenerate\n")
    fir.write("endmodule\n")
    fir.close()

    print
    print "DONE"
    print

