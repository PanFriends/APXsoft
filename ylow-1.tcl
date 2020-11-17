proc ylow {args} {

    if {[llength $args] == 1} {
	setplot command window 1
	set lo [lindex $args 0]
	if {[file exists "TEMP_yhi.txt"]==1} {
	    set hi [exec more TEMP_yhi.txt]
	    setplot command re y $lo $hi
	} else {
	    setplot command re y $lo
	}
    }

    if {[llength $args] == 0} {
#default is 1/10 of current yhi-ylo

    set re "a"
    while { [string first "o" $re] == -1} {
	if {[file exists "TEMP_yhi.txt"]==1} {
	    set lo [exec more TEMP_ylow.txt]
	    set dup [expr ($hi-$lo)/10.]
	    set lo [expr $lo-$dup]
	    setplot command re y $lo $hi
	    plot
	    exec echo $lo > TEMP_ylow.txt
 
	    set ans [gets stdin]
	    scan $ans "%s" re
	}
    }
}
    exec echo $lo > TEMP_ylow.txt
    plot
}

