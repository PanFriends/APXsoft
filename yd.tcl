proc yd {args} {

    set lo [exec more TEMP_ylow.txt]
    set hi [exec more TEMP_yhi.txt]

    if {[llength $args] == 0} {
#default is 1/10 of current yhi-ylo
    set dup [expr ($hi-$lo)/10.]
    }

    if {[llength $args] == 1} {
    set dup [lindex $args 0]
    }


    set lo [expr $lo-$dup]
    set hi [expr $hi-$dup]
    

ylohi $lo $hi

}
