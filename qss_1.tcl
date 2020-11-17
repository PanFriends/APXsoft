proc qss {par lo hi} {

#A more sophisticated steppar implementation to find a value
#corresponding to a minimum

set i 10
    while {$lo != 0} {
	steppar $par $lo $hi $i
	plot contour

        stepw $par par.txt
        #produces delstat.txt and stepstat.txt
       
        #If the min in the statistic's values in stepstat.txt
        #is not the first or last line, then it is probably correct.
        exec /bin/sh -c "zoomcen.sh par.txt"


	#Get the value at the minimum
        set value [exec more zoomcenval.txt]

        #Message from zoomcen.sh
        set message [exec more message]
	puts "$message"
        puts "newpar $par $value"
	puts [format "more? (%.3e %.3e %i -- 0 ends)" $lo $hi $i]
	set ans [gets stdin]
	scan $ans "%f %f %i" lo hi i
    }

file delete zoomcenval.txt message


}
