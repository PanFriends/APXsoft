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

    set re "-"
    while { [string first "o" $re] == -1} {
	if {[file exists "TEMP_ylow.txt"]==1 && [file exists "TEMP_yhi.txt"]==1} {
	    set hi [exec more TEMP_yhi.txt]
	    set lo [exec more TEMP_ylow.txt]
#	    set dup [expr ($hi-$lo)/10.]
	    set ylog [exec more $::env(HOME)/.xspec/ylog.plot]
	    if { $ylog == 1 } {
		
		if { [string equal "+" $re] == 1 || [string equal "=" $re] == 1} {
		    set lo [expr $lo*1.1]
		}
		if { [string equal "-" $re] == 1} {
		    set lo [expr $lo*0.9]
		}
#		puts $lo
	    } else {

		if { [string equal "+" $re] == 1 || [string equal "=" $re] == 1} {
		    set lo [expr $lo*1.1]
		}
		if { [string equal "-" $re] == 1} {
		    set lo [expr $lo*0.9]
		}
#		puts $lo
		
#		set lo [expr $lo-$dup]

	    }
		
	    
	    setplot command re y $lo $hi
	    plot
	    exec echo $lo > TEMP_ylow.txt
 
	    set ans [gets stdin]
	    scan $ans "%s" re
	} else {

	}

	    
    }
}
    exec echo $lo > TEMP_ylow.txt
    plot
}

