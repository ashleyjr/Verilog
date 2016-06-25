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
            tcl_name = sim + "_tb.tcl"
            pcf_name = sim + ".pcf"

            txt = open(txt_name, "wb")
            txt.write(v_name + "\n")
            txt.write(tb_name + "\n")
            txt.close()

            v = open(v_name, "wb")
            v.write("`timescale 1ns/1ps\n")
            v.write("module " + sim + "(\n" )
            v.write("\tinput\t\t\t\tclk,\n")
            v.write("\tinput\t\t\t\tnRst,\n")
            v.write("\tinput\t\t\t\trx,\n")
            v.write("\tinput\t\t\t\tsw2,\n")
            v.write("\tinput\t\t\t\tsw1,\n")
            v.write("\tinput\t\t\t\tsw0,\n")
            v.write("\toutput\treg\ttx,\n")
            v.write("\toutput\treg\tled4,\n")
            v.write("\toutput\treg\tled3,\n")
            v.write("\toutput\treg\tled2,\n")
            v.write("\toutput\treg\tled1,\n")
            v.write("\toutput\treg\tled0\n")
            v.write(");"+ "\n")
            v.write("\n")
            v.write("\talways@(posedge clk or negedge nRst) begin\n")
            v.write("\t\tif(!nRst) begin\n")
            v.write("\t\t\ttx   <= 1'b0;\n")
            v.write("\t\t\tled4 <= 1'b0;\n")
            v.write("\t\t\tled3 <= 1'b0;\n")
            v.write("\t\t\tled2 <= 1'b0;\n")
            v.write("\t\t\tled1 <= 1'b0;\n")
            v.write("\t\t\tled0 <= 1'b0;\n")
            v.write("\t\tend else begin\n")
            v.write("\t\t\ttx   <= rx;\n")
            v.write("\t\t\tled4 <= sw1;\n")
            v.write("\t\t\tled3 <= 1'b1;\n")
            v.write("\t\t\tled2 <= sw2;\n")
            v.write("\t\t\tled1 <= 1'b1;\n")
            v.write("\t\t\tled0 <= sw0;\n")
            v.write("\t\tend\n")
            v.write("\tend\n")
            v.write("endmodule\n")
            v.close()

            tb = open(tb_name, "wb")
            tb.write("`timescale 1ns/1ps\n")
            tb.write("module " + sim + "_tb;\n")
            tb.write("\n")
            tb.write("\tparameter CLK_PERIOD = 20;\n")
            tb.write("\n")
            tb.write("\treg\tclk;\n")
            tb.write("\treg\tnRst;\n")
            tb.write("\treg\trx;\n")
            tb.write("\treg\tsw2;\n")
            tb.write("\treg\tsw1;\n")
            tb.write("\treg\tsw0;\n")
            tb.write("\twire\ttx;\n")
            tb.write("\twire\tled4;\n")
            tb.write("\twire\tled3;\n")
            tb.write("\twire\tled2;\n")
            tb.write("\twire\tled1;\n")
            tb.write("\twire\tled0;\n")
            tb.write("\n")
            tb.write("\t" + sim + " " + sim + "(\n")
            tb.write("\t\t`ifdef POST_SYNTHESIS\n")
            tb.write("\t\t\t.clk\t(clk),\n")
            tb.write("\t\t\t.nRst\t(nRst),\n")
            tb.write("\t\t\t.rx\t(rx),\n")
            tb.write("\t\t\t.sw2\t(sw2),\n")
            tb.write("\t\t\t.sw1\t(sw1),\n")
            tb.write("\t\t\t.sw0\t(sw0),\n")
            tb.write("\t\t\t.tx\t(tx),\n")
            tb.write("\t\t\t.led4\t(led4),\n")
            tb.write("\t\t\t.led3\t(led3),\n")
            tb.write("\t\t\t.led2\t(led2),\n")
            tb.write("\t\t\t.led1\t(led1),\n")
            tb.write("\t\t\t.led0\t(led0)\n")
            tb.write("\t\t`else\n")
            tb.write("\t\t\t.clk\t(clk),\n")
            tb.write("\t\t\t.nRst\t(nRst),\n")
            tb.write("\t\t\t.rx\t(rx),\n")
            tb.write("\t\t\t.sw2\t(sw2),\n")
            tb.write("\t\t\t.sw1\t(sw1),\n")
            tb.write("\t\t\t.sw0\t(sw0),\n")
            tb.write("\t\t\t.tx\t(tx),\n")
            tb.write("\t\t\t.led4\t(led4),\n")
            tb.write("\t\t\t.led3\t(led3),\n")
            tb.write("\t\t\t.led2\t(led2),\n")
            tb.write("\t\t\t.led1\t(led1),\n")
            tb.write("\t\t\t.led0\t(led0)\n")
            tb.write("\t\t`endif\n")
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
            tb.write("\t\t`ifdef POST_SYNTHESIS\n")
            tb.write("\t\t\t$dumpfile(\"" + sim + "_syn.vcd\");\n")
            tb.write("\t\t\t$dumpvars(0," + sim + "_tb);\n")
            tb.write("\t\t`else\n")
            tb.write("\t\t\t$dumpfile(\"" + sim + ".vcd\");\n")
            tb.write("\t\t\t$dumpvars(0," + sim + "_tb);\n")
            tb.write("\t\t`endif\n")
            tb.write("\t\t$display(\"                  TIME    nRst\");")
            tb.write("\t\t$monitor(\"%tps       %d\",$time,nRst);")
            tb.write("\tend\n\n")
            tb.write("\tinitial begin\n")
            tb.write("\t\t\t\t\tnRst = 1;\n")
            tb.write("\t\t\t\t\trx      = 0;\n")
            tb.write("\t\t\t\t\tsw2     = 0;\n")
            tb.write("\t\t\t\t\tsw1     = 0;\n")
            tb.write("\t\t\t\t\tsw0     = 0;\n")
            tb.write("\t\t#17\t\tnRst  = 0;\n")
            tb.write("\t\t#17\t\tnRst  = 1;\n")
            tb.write("\t\t#17\t\tsw0   = 1;\n")
            tb.write("\t\t#17\t\tsw1   = 1;\n")
            tb.write("\t\t#17\t\tsw2   = 1;\n")
            tb.write("\t\t#17\t\trx    = 1;\n")
            tb.write("\t\t#17\t\tsw1   = 0;\n")
            tb.write("\t\t#17\t\tsw2   = 0;\n")
            tb.write("\t\t#17\t\tsw0   = 0;\n")
            tb.write("\t\t#17\t\trx    = 0;\n")
            tb.write("\t\t#10\n")
            tb.write("\t\t$finish;\n")
            tb.write("\tend\n\n")
            tb.write("endmodule\n")
            tb.close()

            tcl = open(tcl_name, "wb")
            tcl.write("set nsigs [ gtkwave::getNumFacs ]\n")
            tcl.write("set sigs [list]\n")
            tcl.write("for {set i 0} {$i < $nsigs} {incr i} {\n")
            tcl.write("    set name  [ gtkwave::getFacName $i ]\n")
            tcl.write("    lappend sigs $name\n")
            tcl.write("}\n")
            tcl.write("set added [ gtkwave::addSignalsFromList $sigs ]\n")
            tcl.write("gtkwave::/Time/Zoom/Zoom_Full\n")
            tcl.close()

            pcf = open(pcf_name, "wb")
            pcf.write("set_io clk   21\n\n")
            pcf.write("set_io nRst  78\n\n")
            pcf.write("set_io sw2   79\n")
            pcf.write("set_io sw1   80\n")
            pcf.write("set_io sw0   81\n\n")
            pcf.write("set_io led4  95\n")
            pcf.write("set_io led3  96\n")
            pcf.write("set_io led2  97\n")
            pcf.write("set_io led1  98\n")
            pcf.write("set_io led0  99\n\n")
            pcf.write("set_io tx    8\n")
            pcf.write("set_io rx    9\n")
            pcf.close()


        else:
            print "   Error: Module already exists!"

    else:
        print "   Error: Must define name"
    print
    print "DONE"
    print
