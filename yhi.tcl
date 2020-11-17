proc yhi {args} {


setplot command window 1


set lo [exec more TEMP_ylow.txt]

    if {[llength $args] == 0} {
#default is 1/10 of current yhi-ylo


    set re "a"
    while { [string first "o" $re] == -1} {
     set hi [exec more TEMP_yhi.txt]
     set dup [expr ($hi-$lo)/10.]
     set hi [expr $hi+$dup]
     setplot command re y $lo $hi
     plot
     exec echo $hi > TEMP_yhi.txt
 
     set ans [gets stdin]
     scan $ans "%s" re
    }

} else {set hi [lindex $args 0]



setplot command re y $lo $hi
plot
exec echo $hi > TEMP_yhi.txt
}
}

