#!/usr/bin/python
import os
import platform
import subprocess
from optparse import OptionParser




if "__main__" == __name__:
    parser = OptionParser(usage="new_module.py [-n name]" )
    parser.add_option("-n", "--name", dest="name", help="Creates new module with a given name")
    (options, args) = parser.parse_args()

    sim = str(options.name)
    move = "cd " + sim

    print
    print "--- new_module.py ---"
    print "  Module: " + sim

    if(options.name):
        if(os.path.isdir(sim) == False):
            print "    Move: " + move + "/"
            os.mkdir(sim)
            os.chdir(sim)

            txt_name = sim + "_filelist.txt"
            v_name = sim + ".v"
            tb_name = sim + "_tb.v"

            txt = open(txt_name, "wb")
            txt.write(v_name + "\n")
            txt.write(tb_name + "\n")
            txt.close()

            v = open(v_name, "wb")
            v.write("module " + sim + "(\n" )
            v.write("\tinput\tclk,\n")
            v.write("\tinput\tnRst\n")
            v.write(");"+ "\n")
            v.write("\n")
            v.write("\talways@(posedge clk or negedge nRst) begin\n")
            v.write("\t\tif(!nRst) begin\n")
            v.write("\t\t\t// Reset code\n")
            v.write("\t\tend else begin\n")
            v.write("\t\t\t// Active code\n")
            v.write("\t\tend\n")
            v.write("\tend\n")
            v.write("endmodule\n")
            v.close()

            tb = open(tb_name, "wb")
            tb.write("module " + sim + "_tb;\n")
            tb.write("\n")
            tb.write("\tparameter CLK_PERIOD = 20;\n")
            tb.write("\n")
            tb.write("\treg clk;\n")
            tb.write("\treg nRst;\n")
            tb.write("\n")
            tb.write("\t" + sim + " " + sim + "(\n")
            tb.write("\t\t.clk\t(clk),\n")
            tb.write("\t\t.nRst\t(nRst)\n")
            tb.write("\t);"+ "\n")
            tb.write("\n")
            tb.write("\tinitial begin\n")
            tb.write("\t\twhile(1) begin\n")
            tb.write("\t\t\t#(CLK_PERIOD/2) clk = 0;\n")
            tb.write("\t\t\t#(CLK_PERIOD/2) clk = 1;\n")
            tb.write("\t\tend")
            tb.write("\tend\n")
            tb.write("\n")
            tb.write("\tinitial begin\n")
            tb.write("\t\t$dumpfile(\"" + sim + ".vcd\");\n")
            tb.write("\t\t$dumpvars(0," + sim + "_tb);\n")
            tb.write("\tend\n\n")
            tb.write("\tinitial begin\n")
            tb.write("\t\t\t\t\tnRst = 1;\n")
            tb.write("\t\t#100\t\tnRst = 0;\n")
            tb.write("\t\t#100\t\tnRst = 1;\n")
            tb.write("\t\t#10000\n")
            tb.write("\t\t$finish;\n")
            tb.write("\tend\n\n")
            tb.write("endmodule\n")
            tb.close()






        else:
            print "   Error: Module already exists!"

    else:
        print "   Error: Must define name"
    print
    print "DONE"
    print
