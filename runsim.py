#!/usr/bin/python
import os
import sys
import platform
import subprocess
from optparse import OptionParser



def cmd_print(cmd):
    print "     Cmd: " + cmd
    os.system(cmd)

def main():
    parser = OptionParser(usage="runsim.py [-m module] [-s do a sim] [-w view waves]" )
    parser.add_option("-i", "--ice", action="store_true", dest="ice", help="translate and deploy to icestick")
    parser.add_option("-m", "--module", dest="module", help="module to simulate - should not be defined if program is")
    parser.add_option("-n", "--new", dest="new", help="Creates new module with a given name")
    parser.add_option("-p", "--pnr", action="store_true", dest="pnr", help="place and route")
    parser.add_option("-s", "--sim", action="store_true", dest="sim")
    parser.add_option("-a", "--all",action="store_true", dest="all")
    parser.add_option("-w", "--waves", action="store_true", dest="waves")
    parser.add_option("-x", "--synth",action="store_true", dest="synth")
    parser.add_option("-y", "--synth_sim",action="store_true", dest="syn_sim")
    parser.add_option("-z", "--synth_waves",action="store_true", dest="syn_waves")

    (options, args) = parser.parse_args()

    sim = str(options.module)
    move = "cd " + sim
    temp =  str(sim) + "_runsim.txt"
    yosys = str(sim) + "_yosys.ys"
    yosys_out = str(sim) + "_yosys_out.txt"
    yosys_blif = str(sim) + ".blif"

    no_op = True
    if(options.sim != None):
        no_op = False
    if(options.waves != None):
        no_op = False
    if(options.synth != None):
        no_op = False
    if(options.syn_sim != None):
        no_op = False
    if(options.syn_waves != None):
        no_op = False
    if(options.new != None):
        sim = str(options.new)
        no_op = False
    if(no_op):
        print "    Info: You must specify and operation"
        sys.exit(0)

    print
    print "--- runsim.py ---"
    print "  Module: " + sim
    print "    Move: " + move + "/"

    if(options.sim):
        os.chdir(sim)
        print "    Info: Searching for simulation dependants"
        code = "code"
        if(os.path.isdir(code)):
            os.chdir(code)
            print "    Move: " + code + "/"
            for file in os.listdir("."):
                if file.endswith(".asm"):
                    cmd_print("python assembler.py -c " + str(file) + " > " + str(file).replace(".asm",".txt"))
            os.chdir("..")

        print "    Info: Simulate " + str(sim)
        cmd_print("iverilog -o " + str(sim) + ".dat -c " + str(sim) +"_filelist.txt")
        cmd_print("vvp " + str(sim) + ".dat -vcd > " + temp)

        print "    Info: Head of " + temp
        f = open(temp)
        count = 1
        for line in f:
            print "    Info: " + line,
            if not options.all:
                count = count + 1
                if(count > 15):
                    break

    if(options.synth):
        os.chdir(sim)
        filelist = open(str(sim) + "_filelist.txt","r")
        files = filelist.read()
        files = files.replace("\n"," ")
        files = files.replace(str(sim) + "_tb.v","")
        print "    Info: Synth"

        cmd_print("yosys -p 'synth_ice40 -top " + sim + " -blif " + sim +".blif' " + files + " > " + sim + "_syn.txt")
        cmd_print("yosys -o " + sim + "_syn.v " + sim + ".blif > " + sim + "_blif.txt")

    if(options.syn_sim):
        os.chdir(sim)
        cmd_print("iverilog -o " + sim + "_syn.dat -D POST_SYNTHESIS " + sim + "_tb.v " + sim + "_syn.v \ `yosys-config --datdir/ice40/cells_sim.v`")
        cmd_print("vvp " + str(sim) + "_syn.dat -vcd > " + temp)

    if(options.syn_waves):
        os.chdir(sim)
        cmd_print("gtkwave -S" + str(sim) + "_tb.tcl " + str(sim) +"_syn.vcd ")

    if(options.waves):
        os.chdir(sim)
        cmd_print("gtkwave -S " + str(sim) + "_tb.tcl "+ str(sim) +".vcd")

    if(options.pnr):
        os.chdir(sim)
        cmd_print("arachne-pnr -d 1k -p "+ str(sim) +".pcf "+ str(sim) +".blif -o "+ str(sim) +".asc")

    if(options.ice):
        os.chdir(sim)
        filelist = open(str(sim) + "_filelist.txt","r")
        files = filelist.read()
        files = files.replace("\n"," ")
        files = files.replace(str(sim) + "_tb.v","")
        print "    Info: Synth"
        cmd_print("yosys -p 'synth_ice40 -top " + sim + " -blif " + sim +".blif' " + files + " > " + sim + "_syn.txt")
        cmd_print("yosys -o " + sim + "_syn.v " + sim + ".blif > " + sim + "_blif.txt")
        print "    Info: Place and route"
        cmd_print("arachne-pnr -d 1k -q -p "+ str(sim) +".pcf "+ str(sim) +".blif -o "+ str(sim) +".asc" )
        print "    Info: Translate"
        cmd_print("(icepack "+ str(sim) +".asc "+ str(sim) +".bin) > " + sim + "_pack.txt" )
        print "    Info: Deploy to icestick"
        cmd_print("sudo iceprog "+ str(sim) +".bin")

    if(options.new):
        if(os.path.isdir(sim) == False):
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
            tb.write("\t\tend\n")
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
            tb.write("\t\t$monitor(\"%tps       %d\",$time,nRst);\n")
            tb.write("\tend\n\n")
            tb.write("\tinitial begin\n")
            tb.write("\t\t\t\t\tnRst\t\t= 1;\n")
            tb.write("\t\t\t\t\trx\t\t\t= 0;\n")
            tb.write("\t\t\t\t\tsw2\t\t= 0;\n")
            tb.write("\t\t\t\t\tsw1\t\t= 0;\n")
            tb.write("\t\t\t\t\tsw0\t\t= 0;\n")
            tb.write("\t\t#17\t\tnRst\t\t= 0;\n")
            tb.write("\t\t#17\t\tnRst\t\t= 1;\n")
            tb.write("\t\t#17\t\tsw0\t\t= 1;\n")
            tb.write("\t\t#17\t\tsw1\t\t= 1;\n")
            tb.write("\t\t#17\t\tsw2\t\t= 1;\n")
            tb.write("\t\t#17\t\trx\t\t\t= 1;\n")
            tb.write("\t\t#17\t\tsw1\t\t= 0;\n")
            tb.write("\t\t#17\t\tsw2\t\t= 0;\n")
            tb.write("\t\t#17\t\tsw0\t\t= 0;\n")
            tb.write("\t\t#17\t\trx\t\t\t= 0;\n")
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

    print
    print "DONE"
    print

if "__main__" == __name__:
    main()
