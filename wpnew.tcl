proc wpnew {par lo hi num} {

#movie for newpar par val
#val in range lo-hi

#wpnew 5 0.1 1 5

tclout pinfo $par
scan $xspec_tclout "%s" parname
 
    set del [expr { ($hi-$lo) / double($num)}]
    puts [format "delta %.2f\n" $del ]

    for {set i 0} {$i <= $num} {incr i} {
	set newval [expr {$lo+$i*$del}]

	puts [format "\n%s %.4f  %.4e\n" $parname $newval $newval]
newpar $par $newval
plot

    puts -nonewline " "
    #flush stdout
	set ans [gets stdin]    
	if {$ans == "0"} {
set i $num
   }

show all

}
}
