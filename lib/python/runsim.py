#!/usr/bin/python
import os
import sys
import platform
import subprocess
from optparse import OptionParser


DEFAULT_LINES = 15

def cmd_print(cmd):
    print "     Cmd: " + cmd
    os.system(cmd)

def main():
    parser = OptionParser(usage="runsim.py [-m module] [-s do a sim] [-w view waves]" )
    parser.add_option("-d", "--deploy", action="store_true", dest="deploy")
    parser.add_option("-i", "--ice", action="store_true", dest="ice", help="translate and deploy to icestick")
    parser.add_option("-j", "--jice", action="store_true", dest="jice", help="translate to icestrick, no deplot")
    parser.add_option("-l", "--line", dest="lines", help="Number of lines of the log to print at runtime")
    parser.add_option("-m", "--module", dest="module", help="module to simulate - should not be defined if program is")
    parser.add_option("-n", "--new", dest="new", help="Creates new module with a given name")
    parser.add_option("-p", "--pnr", action="store_true", dest="pnr", help="place and route")
    parser.add_option("-s", "--sim", action="store_true", dest="sim")
    parser.add_option("-t", "--time", action="store_true", dest="time")
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
    if(options.ice != None):
        no_op = False
    if(options.jice != None):
        no_op = False
    if(options.deploy != None):
        no_op = False
    if(options.sim != None):
        no_op = False
    if(options.time != None):
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
        new = str(options.new)
        no_op = False
    if(no_op):
        print "    Info: You must specify and operation"
        sys.exit(0)

    if(options.lines != None):
        lines = int(options.lines)
    else:
        lines = DEFAULT_LINES

    print
    print "--- runsim.py ---"
    print "  Module: " + sim
    print "    Move: " + move + "/"

    if(options.sim):
        os.chdir(sim)
        print "    Info: Searching for simulation dependants"

        base        = sim.split('/')[-1]
        dat         = base  + ".dat"
        filelist    = base + "_filelist.txt"
        runsim      = base + "_runsim.txt"

        print "    Info: Simulate " + str(sim)
        cmd_print("iverilog -o " + dat + " -D SIM -c " + filelist)
        cmd_print("vvp " + dat + " -vcd > " + runsim)

        if lines > 2:
            print "    Info: Head of " + runsim + " (Max of "+str(lines)+" lines)"
            f = open(runsim)
            count = 1
            for line in f:
                print "    Info: " + line,
                if not options.all:
                    count = count + 1
                    if(count > lines):
                        break

    if(options.waves):
        os.chdir(sim)
        base        = sim.split('/')[-1]
        tcl         = base  + "_tb.tcl"
        vcd         = base  + ".vcd"
        cmd_print("gtkwave -S " + tcl + " " + vcd)


    if(options.syn_waves):
        os.chdir(sim)
        cmd_print("gtkwave -S" + str(sim) + "_tb.tcl " + str(sim) +"_syn.vcd ")


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

    if(options.pnr):
        os.chdir(sim)
        cmd_print("arachne-pnr -d 1k -p "+ str(sim) +".pcf "+ str(sim) +".blif -o "+ str(sim) +".asc")

    if(options.time):
        os.chdir(sim)
        t = sim.split('/')[-1] + ".time"
        cmd_print("cat "+t)

    if(options.deploy or options.ice or options.jice):
        os.chdir(sim)
        base        = sim.split('/')[-1]
        filelist    = base + "_filelist.txt"
        blif        = base + ".blif"
        blif_txt    = base + "_blif.txt"
        syn         = base + "_syn.v"
        syn_info    = base + "_syn.txt"
        pcf         = base + ".pcf"
        asc         = base + ".asc"
        binn        = base + ".bin"
        pack        = base + "_pack.txt"
        time        = base + ".time"

        if(options.ice or options.jice):
            f = open(filelist,"r")
            files = f.read()
            f.close()
            files = files.replace("\n"," ")
            # Remove testbench
            files = files.replace(base + "_tb.v","")

            print "    Info: Synth"
            cmd_print("rm -f "+syn_info)
            cmd_print("yosys -p 'synth_ice40 -top " + base + " -blif " + blif +"' " + files + " > " + syn_info)
            print "    Info: Usage..."
            f=open(syn_info)
            report = f.read()
            f.close()
            report = report.split('Printing statistics')[-1].split('.28')[0]
            for l in report.split('\n')[1:-1]:
                print "    Info: "+l
                if "Number of cells:                  0" in l:
                    print "   Error: Synthesis failed"
                    sys.exit()
            cmd_print("rm -f "+blif_txt)
            cmd_print("yosys -o " + syn + " " + blif + " > " + blif_txt)
            print "    Info: Place and route"
            cmd_print("arachne-pnr -d 1k -q -p "+ pcf +" "+ blif +" -o "+ asc )
            print "    Info: Timing info"
            cmd_print("rm -f "+time)
            cmd_print("icetime -tmd hx1k "+asc+" > "+time)
            f=open(time)
            report = f.read()
            f.close()
            report = report.split('Total path delay:')[-1].split('\n')[0]
            print "    Info: Timing = "+report
            print "    Info: Translate"
            cmd_print("rm -f "+pack)
            cmd_print("(icepack "+ asc +" "+ binn +") > " + pack )
        if (options.ice or options.deploy):
            print "    Info: Deploy to icestick"
            cmd_print("sudo iceprog "+ binn)


    if(options.new != None):

        if '/' not in new:
            print "Error: Malformed name"
            sys.exit(0)
        else:
            module_name = new.split('/')[-1]
            path = new[0:-len(module_name)]
            print module_name
            print path


        if(os.path.isdir(new) == False):
            os.makedirs(path)
            os.chdir(path)

            module_name = new.split('/')[-1]


            txt_name    = module_name + "_filelist.txt"
            v_name      = module_name + ".v"
            tb_name     = module_name + "_tb.v"
            tcl_name    = module_name + "_tb.tcl"
            pcf_name    = module_name + ".pcf"

            txt = open(txt_name, "wb")
            txt.write(v_name + "\n")
            txt.write(tb_name + "\n")
            txt.close()

            v = open(v_name, "wb")
            v.write("`timescale 1ns/1ps\n")
            v.write("module " + module_name + "(\n" )
            v.write("\tinput\t\t\t\ti_clk,\n")
            v.write("\tinput\t\t\t\ti_nrst,\n")
            v.write("\tinput\t\t\t\ti_rx,\n")
            v.write("\tinput\t\t\t\ti_sw2,\n")
            v.write("\tinput\t\t\t\ti_sw1,\n")
            v.write("\tinput\t\t\t\ti_sw0,\n")
            v.write("\toutput\treg\to_tx,\n")
            v.write("\toutput\treg\to_led4,\n")
            v.write("\toutput\treg\to_led3,\n")
            v.write("\toutput\treg\to_led2,\n")
            v.write("\toutput\treg\to_led1,\n")
            v.write("\toutput\treg\to_led0\n")
            v.write(");"+ "\n")
            v.write("\n")
            v.write("\talways@(posedge i_clk or negedge i_nrst) begin\n")
            v.write("\t\tif(!i_nrst) begin\n")
            v.write("\t\t\to_tx   <= 1'b0;\n")
            v.write("\t\t\to_led4 <= 1'b0;\n")
            v.write("\t\t\to_led3 <= 1'b0;\n")
            v.write("\t\t\to_led2 <= 1'b0;\n")
            v.write("\t\t\to_led1 <= 1'b0;\n")
            v.write("\t\t\to_led0 <= 1'b0;\n")
            v.write("\t\tend else begin\n")
            v.write("\t\t\to_tx   <= i_rx;\n")
            v.write("\t\t\to_led4 <= i_sw1;\n")
            v.write("\t\t\to_led3 <= 1'b1;\n")
            v.write("\t\t\to_led2 <= i_sw2;\n")
            v.write("\t\t\to_led1 <= 1'b1;\n")
            v.write("\t\t\to_led0 <= i_sw0;\n")
            v.write("\t\tend\n")
            v.write("\tend\n")
            v.write("endmodule\n")
            v.close()

            tb = open(tb_name, "wb")
            tb.write("`timescale 1ns/1ps\n")
            tb.write("module " + module_name + "_tb;\n")
            tb.write("\n")
            tb.write("\tparameter CLK_PERIOD = 20;\n")
            tb.write("\n")
            tb.write("\treg\tclk;\n")
            tb.write("\treg\tnrst;\n")
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
            tb.write("\t" + module_name + " " + module_name + "(\n")
            tb.write("\t\t.i_clk\t(clk),\n")
            tb.write("\t\t.i_nrst\t(nrst),\n")
            tb.write("\t\t.i_rx\t\t(rx),\n")
            tb.write("\t\t.i_sw2\t(sw2),\n")
            tb.write("\t\t.i_sw1\t(sw1),\n")
            tb.write("\t\t.i_sw0\t(sw0),\n")
            tb.write("\t\t.o_tx\t\t(tx),\n")
            tb.write("\t\t.o_led4\t(led4),\n")
            tb.write("\t\t.o_led3\t(led3),\n")
            tb.write("\t\t.o_led2\t(led2),\n")
            tb.write("\t\t.o_led1\t(led1),\n")
            tb.write("\t\t.o_led0\t(led0)\n")
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
            tb.write("\t\t\t$dumpfile(\"" + module_name + ".vcd\");\n")
            tb.write("\t\t\t$dumpvars(0," + module_name + "_tb);\n")
            tb.write("\t\t$display(\"                  TIME    nrst\");")
            tb.write("\t\t$monitor(\"%tps       %d\",$time,nrst);\n")
            tb.write("\tend\n\n")
            tb.write("\tinitial begin\n")
            tb.write("\t\t\t\t\tnrst\t\t= 1;\n")
            tb.write("\t\t\t\t\trx\t\t\t= 0;\n")
            tb.write("\t\t\t\t\tsw2\t\t= 0;\n")
            tb.write("\t\t\t\t\tsw1\t\t= 0;\n")
            tb.write("\t\t\t\t\tsw0\t\t= 0;\n")
            tb.write("\t\t#17\t\tnrst\t\t= 0;\n")
            tb.write("\t\t#17\t\tnrst\t\t= 1;\n")
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
