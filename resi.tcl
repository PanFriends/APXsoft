proc resi {delta} {

    set up [expr $delta+1.]
    set down [expr 1.-$delta]
    setplot command window 2
    #setplot command log off
    setplot command log y off
    plot
    setplot command re y $down $up
    plot

}
