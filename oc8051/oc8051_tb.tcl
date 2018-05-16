set sigs [list]

# Dump all signals
#set nsigs [ gtkwave::getNumFacs ]
#for {set i 0} {$i < $nsigs} {incr i} {
#    set name  [ gtkwave::getFacName $i ]
#    lappend sigs $name
#}

lappend sigs "oc8051_top_1.oc8051_alu_src_sel1.pc"
lappend sigs "oc8051_top_1.oc8051_sfr1.oc8051_acc1.acc"
lappend sigs "oc8051_xrom1.addr"
lappend sigs "oc8051_xrom1.data"

set added [ gtkwave::addSignalsFromList $sigs ]
gtkwave::/Time/Zoom/Zoom_Full
