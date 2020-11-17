proc ylohi {args} {

    if {[llength $args] == 0} {
	set lo [exec more TEMP_ylow.txt]
	set hi [exec more TEMP_yhi.txt]
    } else {
	set lo [lindex $args 0]
	set hi [lindex $args 1]
    }
	setplot command window 1
	setplot command re y $lo $hi
	plot

	#Write out
	exec echo $lo > TEMP_ylow.txt
	exec echo $hi > TEMP_yhi.txt
    
    
}
