set nsigs [ gtkwave::getNumFacs ]
set sigs [list]
for {set i 0} {$i < $nsigs} {incr i} {
    set name  [ gtkwave::getFacName $i ]
    lappend sigs $name
}
set added [ gtkwave::addSignalsFromList $sigs ]
gtkwave::/Time/Zoom/Zoom_Full
