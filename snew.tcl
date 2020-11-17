proc snew {routine} {

    #.tcl suffix assumed

    source ~/.xspec/$routine.tcl
    set indexfile ~/.xspec/tclIndex

    #Add to $indexfile if not there yet
    exec /bin/bash -c "if ! \$(grep -q $routine.tcl $indexfile)  ; then echo \"set auto_index($routine) \[list source \[file join \$\"dir\" $routine.tcl\]\]\" >> $indexfile; fi"

}
