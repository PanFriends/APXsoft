proc xrf {} {

    set lo [exec more TEMP_xlow.txt]
    set lo [expr $lo+1.]
    set hi [exec more TEMP_xhi.txt]
    set hi [expr $hi+1.]

xlohi $lo $hi

}
