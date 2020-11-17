proc pldra { {yl 1e-4} } {

    #Plot data ratio in log; defaults yl=1e-4
    puts "$yl"

    plot ldata ratio
    logon
    fadd
}
