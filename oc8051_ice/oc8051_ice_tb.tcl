set sigs [list]
lappend sigs "i_nrst"
lappend sigs "i_clk"
lappend sigs "o_led0"
lappend sigs "o_led1"
lappend sigs "o_led2"
lappend sigs "o_led3"
lappend sigs "o_led4"
lappend sigs "oc8051_ice.ram_addr"
lappend sigs "oc8051_ice.ram_data_in"
lappend sigs "oc8051_ice.ram_data_out"
lappend sigs "oc8051_ice.rom_addr"
lappend sigs "oc8051_ice.rom_data"
lappend sigs "oc8051_ice"
lappend sigs "oc8051_ice"
lappend sigs "oc8051_ice"
lappend sigs "oc8051_ice"
set added [ gtkwave::addSignalsFromList $sigs ]
gtkwave::/Time/Zoom/Zoom_Full
