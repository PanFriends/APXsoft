proc plodaralog { {yl 1e-4} } {

    #Plot data ratio in log; defaults yl=1e-4
    puts "$yl"

    plot ldata ratio
    logon
    fadd

    #set original_argv $argv
    #set argv [list "7"]
    #source /home/pana/.xspec/fadd.tcl
    #
    #set argv [list "$yl"]
    #source /home/pana/.xspec/ylow.tcl
    #
    #set argv $original_argv
        

}
    
