#!/usr/bin/env python
import numpy as np

last = 15

t = np.float64(1)
print "always @(i) begin"
print "\tcase(i)"
for i in range(0, last+1):
    val = np.arctan(t, dtype=np.float64)
    scaled = str(hex(int(0xFFFF * val)))
    scaled = scaled[2:]
    while len(scaled) < 4:
        scaled = "0" + scaled
    pretty_val = "{0:0.12f}".format(val)
    print "\t\t'h"+str(hex(i)[2:])+":\ta = 16'h" + scaled + ";\t// "+pretty_val+"\t = arctan(2^-"+str(i)+")\t= arctan("+str(t)+")"
    t = t/2
print "\tendcase"
print "end"



