#!/usr/bin/env python
import numpy as np
bits    = 10
length  = 2 ** 6

s = []
for i in range(0, length):
    t = (i*2*3.1415)/length
    f = 1 + np.sin(t)
    s .append(str(int(np.floor((2 ** 10)*(f/2)))))

print "`timescale 1ns/1ps"
print "module sin_lut("
print "\tinput\t[$clog2("+str(length)+")-1:0]\ti_theta,"
print "\toutput\t["+str(bits)+"-1:0]\to_sin"
print ");"
print "assign o_sin = ",
for i in range(length):
    if i != 0:
        print "\t\t",
    if i != length-1:
        print "(i_theta == 'd"+str(i)+") ?\t'd"+str(s[i]) + " : "
    else:
        print "// i_theta == 'd"+str(i)
        print "\t\t\t\t\t'd"+str(s[i])+";"
print "endmodule"
